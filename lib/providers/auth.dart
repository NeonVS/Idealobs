import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import '../models/http_exception.dart';

//const serverBaseUrl = 'http://localhost:3000';
const serverBaseUrl = 'https://5b0e91c28cae.ngrok.io';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  Timer _authTimer;
  DateTime _expiryDate;
  String _username;
  bool _isVerified = false;
  List<String> _enrolledProjects = [];

  bool get isAuth {
    print('tried');
    if (token != null && _isVerified == true) {
      return true;
    } else {
      return false;
    }
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  List<String> get enrolledProjects {
    return [..._enrolledProjects];
  }

  String get username {
    return _username;
  }

  Future<void> signup(String email, String password) async {
    try {
      final responseData = await http.post(
        serverBaseUrl + '/auth/signup',
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {'email': email, 'password': password},
        ),
      );
      final response = json.decode(responseData.body) as Map<String, dynamic>;
      if (responseData.statusCode >= 400) {
        throw HttpException(response['message']);
      }
      _token = response['token'].toString();
      _userId = response['userId'].toString();
      print(response['enrolledProjects']);
      _expiryDate = DateTime.now().add(
        Duration(minutes: 55),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> verify(String emailToken) async {
    try {
      final responseData = await http.post(
        serverBaseUrl + '/auth/verify',
        body: json.encode({'emailToken': emailToken}),
        headers: {
          'Authorization': 'Bearer ' + _token,
          'Content-Type': 'application/json'
        },
      );
      final response = json.decode(responseData.body);
      if (responseData.statusCode >= 400) {
        throw HttpException(response['message']);
      }
      _token = response['token'];
      _isVerified = true;
      _expiryDate = DateTime.now().add(Duration(minutes: 55));
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate':
              DateTime.now().add(Duration(hours: 1)).toIso8601String(),
          'isVerified': true
        },
      );
      await prefs.setString('userData', userData);
      await prefs.setStringList("enrolledProjects", _enrolledProjects);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final responseData = await http.post(serverBaseUrl + '/auth/login',
          body: json.encode({'email': email, 'password': password}),
          headers: {'Content-Type': 'application/json'});
      final response = json.decode(responseData.body);
      if (responseData.statusCode >= 400) {
        throw HttpException(response['message']);
      }
      _enrolledProjects = [];
      response['enrolledProjects'].forEach((projectId) {
        _enrolledProjects.add(projectId.toString());
      });
      _userId = response['userId'];
      _token = response['token'];
      _username = response['username'];
      _expiryDate = DateTime.now().add(Duration(minutes: 55));
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate':
              DateTime.now().add(Duration(minutes: 55)).toIso8601String(),
          'isVerified': true,
          'username': _username,
        },
      );
      await prefs.clear();
      prefs.setString('userData', userData);
      prefs.setStringList("enrolledProjects", _enrolledProjects);
      print(_username);
      notifyListeners();
      _autoLogout();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    print('entered');
    final prefs = await SharedPreferences.getInstance();
    Map<String, Object> extractedUserData;
    try {
      extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
    } catch (error) {
      return false;
    }
    if (extractedUserData == null) {
      return false;
    }
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (!extractedUserData.containsKey('userId')) {
      return false;
    }
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _username = extractedUserData['username'];
    _expiryDate = expiryDate;
    if (!extractedUserData.containsKey('isVerified') ||
        !extractedUserData['isVerified']) {
      return false;
    }
    _isVerified = extractedUserData['isVerified'];
    _enrolledProjects = prefs.getStringList('enrolledProjects');
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('enrolledProjects');
    await prefs.remove('userData');
    await prefs.clear();
    print('cleared');
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> complete_profile(
      File _image, String username, String _gender, String _description) async {
    try {
      Response response;
      Dio dio = new Dio();
      FormData formData = FormData.fromMap({
        'username': username,
        'gender': _gender,
        'description': _description,
        'image':
            await MultipartFile.fromFile(_image.path, filename: '$username.png')
      });
      dio.options.headers['Authorization'] = 'Bearer ' + _token;
      response = await dio.post(
        serverBaseUrl + '/auth/complete_profile',
        data: formData,
      );
      _username = username;
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate':
              DateTime.now().add(Duration(hours: 1)).toIso8601String(),
          'isVerified': true,
          'username': 'username',
        },
      );
      prefs.setString('userData', userData);
      prefs.setStringList("enrolledProjects", _enrolledProjects);
      print(response.data);
      print(username);
    } catch (error) {
      if (error.response.statusCode == 422) {
        throw HttpException('Username already taken!');
      } else {
        throw HttpException('Server Error, Please try after some time!');
      }
    }
  }

  Future<void> addEnrolledProject(String projectId) async {
    print(projectId);
    _enrolledProjects.add(projectId);
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("enrolledProjects", _enrolledProjects);
    notifyListeners();
  }
}

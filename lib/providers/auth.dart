import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const serverBaseUrl = 'http://localhost:3000';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  Timer _authTimer;
  DateTime _expiryDate;
  bool _isVerified = false;

  bool get isAuth {
    return token != null && _isVerified;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    try {
      final responseDate = await http.post(serverBaseUrl + '/auth/signup',
          body: json.encode({'email': email, 'password': password}));
      final response = json.decode(responseDate.body);
      _token = response.token;
      _userId = response._userId;
      _expiryDate = DateTime.now().add(Duration(hours: 1));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> verify(String emailToken) async {
    try {
      final responseData = await http.post(serverBaseUrl + '/auth/verify',
          body: json.encode({'emailToken': emailToken}),
          headers: {'Authorization': 'Bearer ' + token});
      final response = json.decode(responseData.body);
      _token = response.token;
      _isVerified = true;
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': DateTime.now().add(Duration(hours: 1)),
          'isVerified': true
        },
      );
      prefs.setString('userData', userData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final responseData = await http.post(serverBaseUrl + '/auth/login',
          body: json.encode({'email': email, 'password': password}));
      final response = json.decode(responseData.body);
      _userId = response.userId;
      _token = response.token;
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': DateTime.now().add(Duration(hours: 1)),
          'isVerified': true
        },
      );
      prefs.setString('userData', userData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    print('entered');
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (!extractedUserData.containsKey('userId')) {
      return false;
    }
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    _isVerified = extractedUserData['isVerified'];
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
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}

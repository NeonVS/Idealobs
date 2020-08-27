import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import './request.dart';

const serverBaseUrl = 'https://6f8e78027884.ngrok.io';

class Requests with ChangeNotifier {
  List<Request> _requests = [];
  final String token;
  final String userId;
  Requests(this.token, this.userId, this._requests);

  List<Request> get requests {
    return [..._requests];
  }

  Future<void> addRequest(Request request, File cv) async {
    try {
      Response response;
      Dio dio = new Dio();
      FormData formData = FormData.fromMap({
        'name': request.name,
        'officialEmail': request.email,
        'reasonForProject': request.reasonForPost,
        'info': request.info,
        'projectId': request.projectId,
        'projectCreatorId': request.projectCreatorId,
        'cv': await MultipartFile.fromFile(cv.path,
            filename: '$userId-${request.projectId}-cv.pdf'),
      });
      dio.options.headers['Authorization'] = 'Bearer ' + token;
      response = await dio.post(
        serverBaseUrl + '/request/new_request',
        data: formData,
      );
    } catch (error) {
      if (error.response.statusCode == 422) {
        try {
          final message = json.decode(error.response.toString()).toString();
          throw HttpException(message.split(":")[1].trim().split('}')[0]);
        } catch (error) {
          throw HttpException('Server Error, Please try after some time!');
        }
      } else {
        throw HttpException('Server Error, Please try after some time!');
      }
    }
  }

  Future<void> fetchAndSetRequests() async {
    print('requests');
    try {
      final responseData = await http.get(serverBaseUrl + '/request/requests',
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
          });
      final response = json.decode(responseData.body);
      print(response);
      final requests = response['requests'];
      List<Request> _loadedRequests = [];
      requests.forEach(
        (request) {
          _loadedRequests.insert(
            0,
            Request(
              name: request['name'],
              email: request['officialEmail'],
              userId: request['from'],
              projectCreatorId: request['to'],
              info: request['info'],
              reasonForPost: request['reasonForProject'],
              projectId: request['projectId'],
            ),
          );
        },
      );
      _requests = _loadedRequests;
      print(_loadedRequests);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> confirmRequest(Request request) async {
    try {
      final response = await http.post(
        serverBaseUrl + '/request/confirm_request',
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
        },
        body: json.encode(
          {
            'projectId': request.projectId,
            'userId': request.userId,
          },
        ),
      );
    } catch (error) {
      throw HttpException('Server Error, Please try after some time!');
    }
  }

  Future<void> denyRequest(Request request) async {
    try {
      final response = await http.post(
        serverBaseUrl + '/request/deny_request',
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
        },
        body: json.encode(
          {
            'projectId': request.projectId,
            'userId': request.userId,
          },
        ),
      );
    } catch (error) {
      throw HttpException('Server Error, Please try after some time!');
    }
  }

  Future<void> removeRequest(Request request) {
    _requests.remove(request);
    notifyListeners();
  }
}

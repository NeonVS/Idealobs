import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import './project.dart';

const serverBaseUrl = 'https://e1e553dc7b59.ngrok.io';

class Projects with ChangeNotifier {
  List<Project> _items = [];
  final String token;
  final String userId;
  Projects(this.token, this.userId, this._items);

  List<Project> get items {
    return [..._items];
  }

  Future<void> addProject(Project project, File image, File attachment) async {
    try {
      final check = await http.post(
          serverBaseUrl + '/project/check_projectName',
          body: json.encode({'projectName': project.projectName}),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
          });
      final result = json.decode(check.body);
      if (result['message'] == 'false') {
        return throw HttpException(
            'User can not have multiple projects with same name!');
      }
    } catch (error) {
      return throw HttpException(
          'User can not have multiple projects with same name!');
    }
    try {
      print(userId);
      Response response;
      Dio dio = new Dio();
      FormData formData = FormData.fromMap({
        'projectName': project.projectName,
        'companyName': project.companyName,
        'numColabs': project.numColabs,
        'budget': project.budget,
        'amountPayable': project.amountPayable,
        'intro': project.intro,
        'description': project.description,
        'youtubeUrl': project.youtubeUrl,
        'dateTime': project.dateTime.toIso8601String(),
        'project_image': await MultipartFile.fromFile(image.path,
            filename: '$userId-${project.projectName}.jpg'),
        'project_file': await MultipartFile.fromFile(attachment.path,
            filename: '$userId-${project.projectName}.pdf'),
      });
      dio.options.headers['Authorization'] = 'Bearer ' + token;
      response = await dio.post(
        serverBaseUrl + '/project/add_project',
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
}

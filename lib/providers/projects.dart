import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import './project.dart';

const serverBaseUrl = 'https://4fa63b1644a1.ngrok.io';

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
      print(response.data);
    } catch (error) {
      if (error.response.statusCode == 422) {
        throw HttpException('Username already taken!');
      } else {
        throw HttpException('Server Error, Please try after some time!');
      }
    }
  }
}

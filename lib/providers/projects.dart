import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import './project.dart';

const serverBaseUrl = 'https://5b0e91c28cae.ngrok.io';

class Projects with ChangeNotifier {
  List<Project> _items = [];
  final String token;
  final String userId;
  Projects(this.token, this.userId, this._items);

  List<Project> get items {
    return [..._items];
  }

  List<Project> get yourItems {
    return [
      ..._items.where((project) {
        return project.creator == userId;
      }).toList()
    ];
  }

  Future<String> addProject(
      Project project, File image, File attachment) async {
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
        'categories': project.categories,
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

      return response.data['projectId'];
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

  Future<void> fetchAndSetProjects() async {
    try {
      print('entered');
      final responseData = await http
          .get(serverBaseUrl + '/project/get_projects', headers: {
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json'
      });
      final response = json.decode(responseData.body);
      final projects = response['projects'];
      List<Project> _loadedItems = [];
      projects.forEach(
        (project) {
          List<String> cat = [];
          project['categories'].forEach((el) {
            cat.insert(0, el.toString());
          });
          print(cat);
          _loadedItems.insert(
            0,
            Project(
              projectName: project['projectName'],
              companyName: project['companyName'],
              numColabs: project['numColabs'],
              budget: project['budget'].toDouble(),
              amountPayable: project['amountPayable'].toDouble(),
              intro: project['intro'],
              description: project['description'],
              dateTime: DateTime.parse(project['dateTime'].toString()),
              youtubeUrl: project['youtubeUrl'],
              likes: project['likes'],
              creator: project['creator'],
              projectId: project['_id'],
              categories: cat,
            ),
          );
        },
      );
      _items = _loadedItems;

      print(_loadedItems);
    } catch (error) {
      throw HttpException('Server Error');
    }
  }

  List<Project> fetchByCategory(String category) {
    return items.where((project) {
      return project.categories.contains(category);
    }).toList();
  }

//   static Future<void> downloadFile(String url, Function progressChange,
//       String projectName, String creator) async {
//     print(creator);
//     print(projectName);
//     Dio dio = Dio();
//     try {
//       final dir = await getApplicationDocumentsDirectory();
//       await dio.download(url, '${dir.path}/$projectName.pdf',
//           queryParameters: {'creator': creator, 'projectName': projectName},
//           onReceiveProgress: (rec, total) {
//         progressChange(rec, total);
//       });
//     } catch (error) {
//       print(error);
//       throw HttpException('Server Error');
//     }
//   }
}

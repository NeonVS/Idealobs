import 'package:flutter/material.dart';

class Request with ChangeNotifier {
  final String name;
  final String email;
  final String userId;
  final String projectCreatorId;
  final String info;
  final String reasonForPost;
  final String projectId;
  Request({
    @required this.userId,
    @required this.projectCreatorId,
    @required this.info,
    @required this.reasonForPost,
    @required this.projectId,
    @required this.name,
    @required this.email,
  });
}

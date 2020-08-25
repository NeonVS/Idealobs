import 'package:flutter/material.dart';

class Message extends ChangeNotifier {
  final String projectId;
  final String projectName;
  final DateTime dateTime;
  final Map<String, String> message;
  Message({
    @required this.projectId,
    @required this.projectName,
    @required this.message,
    @required this.dateTime,
  });
}

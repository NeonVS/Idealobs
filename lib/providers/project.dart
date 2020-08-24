import 'package:flutter/material.dart';

class Project with ChangeNotifier {
  final String projectName;
  final String companyName;
  final int numColabs;
  final double budget;
  final double amountPayable;
  final String intro;
  final String description;
  final DateTime dateTime;
  final List<String> categories;
  final String youtubeUrl;
  final String creator;
  final int likes;
  final String projectId;
  Project({
    @required this.projectName,
    @required this.companyName,
    @required this.numColabs,
    @required this.budget,
    @required this.amountPayable,
    @required this.intro,
    @required this.description,
    @required this.dateTime,
    @required this.categories,
    this.projectId,
    this.creator,
    this.youtubeUrl,
    this.likes,
  });
}

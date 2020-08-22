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
  final int likes;
  Project(
      {@required this.projectName,
      @required this.companyName,
      @required this.numColabs,
      @required this.budget,
      @required this.amountPayable,
      @required this.intro,
      @required this.description,
      @required this.dateTime,
      @required this.categories,
      this.youtubeUrl,
      this.likes});
}

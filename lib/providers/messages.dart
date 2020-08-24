import 'package:flutter/material.dart';

import './message.dart';

class Messages with ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages {
    return [..._messages];
  }
}

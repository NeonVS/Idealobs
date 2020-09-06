import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './message.dart';

const serverBaseUrl = 'https://5b0e91c28cae.ngrok.io';

class Messages with ChangeNotifier {
  String _token;
  String _userId;
  List<Message> _messages = [];

  Messages(this._token, this._userId, this._messages);

  List<Message> get messages {
    return [..._messages];
  }

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  void fetchAndSetMessages() async {
    try {
      final responseData = await http.get(serverBaseUrl + '/message/messages',
          headers: {
            'Authorization': 'Bearer ' + _token,
            'Content-Type': 'application/json'
          });
      final response = json.decode(responseData.body);
      final messages = response['messages'];
      print(messages);
      List<Message> _loadedMessages = [];
      messages.forEach((message) {
        _loadedMessages.add(
          Message(
            projectName: message['projectName'],
            projectId: message['projectId'],
            dateTime: DateTime.parse(message['dateTime']),
            message: {
              'senderId': message['senderId'],
              'senderUsername': message['senderUsername'],
              'text': message['text'],
            },
          ),
        );
      });
      _messages = _loadedMessages;
      notifyListeners();
      //print(messages);
    } catch (error) {
      print(error);
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/project.dart';
import '../providers/message.dart';
import '../providers/messages.dart';

const serverBaseUrl = 'https://0a7ef1bd2657.ngrok.io';

class MessageScreen extends StatefulWidget {
  Project _project;
  SocketIO _socketIO;
  List<Message> _messages;

  MessageScreen(this._project, this._messages, this._socketIO);
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  //SocketIO socketIO;
  bool _isInit = true;
  final _controller = TextEditingController();

  void _sendMessage(String text) {
    Messages _messages = Provider.of<Messages>(context, listen: false);
    final _auth = Provider.of<Auth>(context, listen: false);
    final message = Message(
        projectId: widget._project.projectId,
        projectName: widget._project.projectName,
        dateTime: DateTime.now(),
        message: {
          'senderId': _auth.userId,
          'senderUsername': _auth.username,
          'text': text,
        });
    widget._socketIO.sendMessage(
      'send_message',
      json.encode({
        'projectId': widget._project.projectId,
        'projectName': widget._project.projectName,
        'dateTime': DateTime.now().toIso8601String(),
        'senderId': _auth.userId,
        'senderUsername': _auth.username,
        'text': text,
      }),
    );
    _controller.text = '';
    FocusScope.of(context).unfocus();
    //_messages.addMessage(message);
  }

  Stack _messageBubble(String message, String userName, String userImage,
      bool _isMe, DateTime dateTime) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              _isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: _isMe ? Colors.grey[300] : Color(0xFFFEF9EB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !_isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: _isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              width: 180,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                  crossAxisAlignment:
                      _isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.headline1.color,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      message,
                      style: TextStyle(
                        color: _isMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.headline1.color,
                      ),
                      textAlign: _isMe ? TextAlign.end : TextAlign.start,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        if (_isMe)
                          Expanded(
                            child: Text(
                              '${dateTime.hour.toString()}:${dateTime.minute.toString()}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        if (!_isMe) Spacer(),
                        if (!_isMe)
                          Text(
                            '${dateTime.hour.toString()}:${dateTime.minute.toString()}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    )
                  ]),
            ),
          ],
        ),
        Positioned(
          top: 1,
          left: _isMe ? null : 160,
          right: _isMe ? 160 : null,
          child: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
              radius: 25,
            ),
          ),
        ),
      ],
      overflow: Overflow.visible, //So that avatar is not cropped
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      height: 70,
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: () {},
            iconSize: 25,
            color: Colors.indigo,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              decoration:
                  InputDecoration.collapsed(hintText: 'Send a message...'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage(_controller.text);
            },
            iconSize: 25,
            color: Colors.indigo,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<Auth>(context, listen: false).username;
    final reversedList = Provider.of<Messages>(context)
        .messages
        .where((element) => element.projectId == widget._project.projectId)
        .toList();
    var messages = List.from(reversedList.reversed);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 0,
        title: Row(
          children: [
            Text(
              widget._project.projectName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Hero(
              tag: widget._project.projectId,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  serverBaseUrl +
                      '/project/project_image?creator=${widget._project.creator}&projectName=${widget._project.projectName.replaceAll(' ', '%20')}',
                ),
                radius: 20,
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.indigo,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.only(top: 15),
                      itemCount: messages.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        final bool isMe =
                            messages[index].message['senderUsername'] ==
                                username;
                        // return _buildMessage(
                        //     messages[index].message['text'], isMe);
                        return _messageBubble(
                          messages[index].message['text'],
                          messages[index].message['senderUsername'],
                          serverBaseUrl +
                              '/auth/profile_pic?username=${messages[index].message['senderUsername']}',
                          isMe,
                          messages[index].dateTime,
                        );
                      },
                    ),
                  ),
                ),
              ),
              _buildMessageComposer()
            ],
          ),
        ),
      ),
    );
  }
}

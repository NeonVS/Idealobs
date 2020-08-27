import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:provider/provider.dart';

import '../providers/projects.dart';
import '../providers/auth.dart';
import '../providers/project.dart';
import '../providers/message.dart';
import '../providers/messages.dart';

const serverBaseUrl = 'https://6f8e78027884.ngrok.io';

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
    //_messages.addMessage(message);
  }

  // _buildMessage(String message, bool isMe) {
  //   return Container(
  //     margin: isMe
  //         ? EdgeInsets.only(
  //             top: 8.0,
  //             bottom: 8.0,
  //             left: 140.0,
  //           )
  //         : EdgeInsets.only(
  //             top: 8.0,
  //             bottom: 8.0,
  //             right: 140.0,
  //           ),
  //     padding: EdgeInsets.symmetric(
  //       horizontal: 25.0,
  //       vertical: 15.0,
  //     ),
  //     decoration: BoxDecoration(
  //       color: isMe ? Color(0xFFFEF9EB) : Color(0xFFFFEFEE),
  //       borderRadius: isMe
  //           ? BorderRadius.only(
  //               topLeft: Radius.circular(15.0),
  //               bottomLeft: Radius.circular(15.0),
  //             )
  //           : BorderRadius.only(
  //               topRight: Radius.circular(15.0),
  //               bottomRight: Radius.circular(15.0),
  //             ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '15:00 PM',
  //           style: TextStyle(
  //             color: Colors.blueGrey,
  //             fontSize: 16.0,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         SizedBox(
  //           height: 8.0,
  //         ),
  //         Text(
  //           message,
  //           style: TextStyle(
  //             color: Colors.blueGrey,
  //             fontSize: 16.0,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Stack _messageBubble(
      String message, String userName, String userImage, bool _isMe) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              _isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: _isMe ? Colors.grey[300] : Theme.of(context).accentColor,
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
        )
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

  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  //   socketIO = SocketIOManager().createSocketIO(
  //       'https://6f8e78027884.ngrok.io', '/',
  //       query: 'chatID=${widget._project.projectId}');
  //   socketIO.init();
  //   socketIO.subscribe('receive_message', (_) {
  //     print('hellooo');
  //   });
  //   socketIO.connect();
  // }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // if (_isInit) {
    //   _isInit = false;
    //   final _messages = Provider.of<Messages>(context, listen: false);
    //   socketIO = SocketIOManager().createSocketIO(
    //     'https://6f8e78027884.ngrok.io',
    //     '/',
    //     query: 'chatID=${widget._project.projectId}',
    //   );
    //   socketIO.init();
    //   socketIO.subscribe(
    //     'receive_message',
    //     (jsonData) {
    //       Map<String, dynamic> data = json.decode(jsonData);
    //       final _message = Message(
    //           projectId: data['projectId'].toString(),
    //           projectName: data['projectName'].toString(),
    //           dateTime: DateTime.parse(data['dateTime']),
    //           message: {
    //             'senderId': data['senderId'].toString(),
    //             'senderUsername': data['senderUsername'].toString(),
    //             'text': data['text'].toString(),
    //           });
    //       print('added');

    //       _messages.addMessage(_message);
    //       setState(() {});
    //     },
    //   );
    //   socketIO.connect();

    ///////////////////////////////////
    //   SocketIO _socketIO;
    //   _socketIO = SocketIOManager().createSocketIO(
    //     'https://6f8e78027884.ngrok.io',
    //     '/dynamic-101',
    //     query: 'chatID=5f43b23866de3d529c6245cf',
    //   );
    //   _socketIO.init();
    //   _socketIO.connect();
    //   ///////////////////////////////////
    //   SocketIO __socketIO;
    //   __socketIO = SocketIOManager().createSocketIO(
    //     'https://6f8e78027884.ngrok.io',
    //     '/dynamic-103',
    //     query: 'chatID=5f43b23866de3d529c6245cf',
    //   );
    //   __socketIO.init();
    //   __socketIO.connect();
    //}
    ///////////////////////////////////
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // socketIO.disconnect();
    // SocketIOManager().destroySocket(socketIO);
    // socketIO.destroy();
    // socketIO = null;
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
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget._project.projectName,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

import '../providers/messages.dart';
import '../providers/message.dart';
import '../providers/project.dart';
import '../providers/projects.dart';
import '../providers/auth.dart';

import './message_screen.dart';

const serverBaseUrl = 'https://0a7ef1bd2657.ngrok.io';

class MessageOverviewScreen extends StatefulWidget {
  static const routeName = '/message_overview_screen';
  @override
  _MessageOverviewScreenState createState() => _MessageOverviewScreenState();
}

class _MessageOverviewScreenState extends State<MessageOverviewScreen> {
  bool _isInit = true;
  List<Project> _projects;
  List<String> _enrolledProjectIds;
  List<Project> _enrolledProject;
  List<SocketIO> _socketIO = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
      final _messages = Provider.of<Messages>(context, listen: false);
      _messages.fetchAndSetMessages();
      _projects = Provider.of<Projects>(context, listen: false).items;
      _enrolledProjectIds =
          Provider.of<Auth>(context, listen: false).enrolledProjects;
      _enrolledProject = _projects.where((project) {
        return _enrolledProjectIds.contains(project.projectId);
      }).toList();
      _enrolledProject.forEach(
        (project) {
          SocketIO socketIO;
          socketIO = SocketIOManager().createSocketIO(
              'https://0a7ef1bd2657.ngrok.io', '/dynamic-${project.projectId}',
              query: 'chatID=${project.projectId}');
          socketIO.init();
          socketIO.subscribe(
            'receive-message',
            (jsonData) {
              Map<String, dynamic> data = json.decode(jsonData);
              final _message = Message(
                  projectId: data['projectId'].toString(),
                  projectName: data['projectName'].toString(),
                  dateTime: DateTime.parse(data['dateTime']),
                  message: {
                    'senderId': data['senderId'].toString(),
                    'senderUsername': data['senderUsername'].toString(),
                    'text': data['text'].toString(),
                  });
              print('added');

              _messages.addMessage(_message);
              setState(() {});
            },
          );
          socketIO.connect();
          _socketIO.add(socketIO);
        },
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _socketIO.forEach((socketIO) {
      socketIO.disconnect();
      SocketIOManager().destroySocket(socketIO);
      socketIO.destroy();
      socketIO = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    final mediaQuery = MediaQuery.of(context);
    final _messages = Provider.of<Messages>(context, listen: true);
    print('rebuild');
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Container(
          color: Colors.indigo,
          child: Column(
            children: [
              SizedBox(height: constraints.maxHeight * 0.05),
              Container(
                height: constraints.maxHeight * 0.95,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30),
                  ),
                  child: ListView.builder(
                    itemCount: _enrolledProject.length,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => MessageScreen(
                                _enrolledProject[index],
                                _messages.messages
                                    .where((message) =>
                                        message.projectId ==
                                        _enrolledProject[index].projectId)
                                    .toList(),
                                _socketIO[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 5.0,
                            bottom: 5.0,
                            right: 20.0,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFEFEE),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Hero(
                                    tag: _enrolledProject[index].projectId,
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: NetworkImage(
                                        serverBaseUrl +
                                            '/project/project_image?creator=${_enrolledProject[index].creator}&projectName=${_enrolledProject[index].projectName.replaceAll(' ', '%20')}',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _enrolledProject[index].projectName,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        width: mediaQuery.size.width * 0.45,
                                        child: Text(
                                          _enrolledProject[index].companyName,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '15:60 PM',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    width: 40,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'NEW',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

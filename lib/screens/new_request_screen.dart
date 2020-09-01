import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../providers/request.dart';
import '../providers/auth.dart';
import '../providers/requests.dart';
import '../providers/project.dart';

class AddNewRequest extends StatefulWidget {
  static String routeName = '/add_new_request';
  @override
  _AddNewRequestState createState() => _AddNewRequestState();
}

class _AddNewRequestState extends State<AddNewRequest> {
  File _cv;
  String _name;
  String _email;
  String _info;
  String _userId;
  String _reasonForPost;
  Project _project;
  bool _fileLoading = false;
  bool _isLoading = false;
  bool _isInit = true;

  final _form = GlobalKey<FormState>();

  void _pickAttachment() async {
    try {
      setState(() {
        _fileLoading = true;
      });
      _cv = await FilePicker.getFile();
      print(_cv);
    } catch (error) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Some error has occurred!'),
          content: Text(error.message.toString()),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Okay'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _fileLoading = false;
      });
    }
  }

  void _save() async {
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    if (_cv == null) {
      return;
    }
    _form.currentState.save();
    print(_cv);
    print(_name);
    print(_email);
    print(_info);
    print(_reasonForPost);
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Requests>(context, listen: false).addRequest(
          Request(
            name: _name,
            email: _email,
            userId: _userId,
            projectCreatorId: _project.creator,
            info: _info,
            reasonForPost: _reasonForPost,
            projectId: _project.projectId,
          ),
          _cv);
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } catch (error) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Some error has occurred!'),
          content: Text(error.message.toString()),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Okay'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
      _project = ModalRoute.of(context).settings.arguments as Project;
      _userId = Provider.of<Auth>(context, listen: false).userId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spinKitFile = SpinKitCubeGrid(
      color: Colors.orangeAccent,
      size: 25,
    );
    final spinKitConfirm =
        SpinKitWave(color: Theme.of(context).primaryColor, size: 50);
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text('Join Request Form'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      actions: [
        IconButton(icon: Icon(Icons.save), onPressed: () {}),
      ],
    );
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Container(
        height: mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top,
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              children: [
                SizedBox(height: mediaQuery.size.height * 0.03),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/new_request.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                Text(
                  'Join Request',
                  style: TextStyle(fontSize: 20, fontFamily: 'Alata'),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Your Name',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.length < 1) {
                        return 'Name field cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _name = value;
                    },
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Official Email Address',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (!value.contains('@')) {
                        return 'Please enter valid email address';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _email = value;
                    },
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description),
                      labelText: 'Tell us about yourself!',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    maxLines: 7,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value.length < 10) {
                        return 'You should write more than  10 words!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _info = value;
                    },
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description),
                      labelText: 'Why should we hire you?',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    maxLines: 15,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value.length < 20) {
                        return 'Write more than 20 words!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _reasonForPost = value;
                    },
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 1.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: mediaQuery.size.width * 0.50,
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Please select your CV mentioning your skills!',
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Container(
                            width: mediaQuery.size.width * 0.30,
                            child: _fileLoading
                                ? spinKitFile
                                : _cv == null
                                    ? FlatButton(
                                        child: Text('Pick File'),
                                        onPressed: _pickAttachment,
                                      )
                                    : Icon(
                                        Icons.done,
                                        color: Colors.green[200],
                                      ),
                          )
                        ],
                      ),
                      if (_cv != null) Divider(),
                      if (_cv != null)
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${_cv.path.split('/').last.length > 31 ? _cv.path.split('/').last.substring(0, 29) : _cv.path.split('/').last}',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.grey[600]),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(
                                    () {
                                      _cv = null;
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                if (_isLoading) spinKitConfirm,
                if (!_isLoading)
                  SizedBox(
                    height: 50,
                    width: mediaQuery.size.width * 0.6,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: _save,
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

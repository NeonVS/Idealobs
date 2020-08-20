import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widget/profile_image_picker.dart';
import '../providers/auth.dart';

class ProfileComplete extends StatefulWidget {
  static String routeName = '/complete_profile';
  @override
  _ProfileCompleteState createState() => _ProfileCompleteState();
}

class _ProfileCompleteState extends State<ProfileComplete> {
  File _image;
  String _username;
  String _gender = 'Male';
  String _description;
  final _form = GlobalKey<FormState>();
  bool _isImageLoading = false;
  bool _isLoading = false;

  void _pickImage(String option) async {
    setState(() {
      _isImageLoading = true;
    });
    try {
      _image = await pick(option);
      Navigator.of(context).pop();
    } catch (error) {
      Navigator.of(context).pop();
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Some error has occurred!'),
          content: Text('Error while picking the file!'),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Okay'),
            ),
          ],
        ),
      );
    }
    setState(() {
      _isImageLoading = false;
    });
  }

  void _onChangeGender(String gender) {
    _gender = gender.split('.')[1];
  }

  void _save() async {
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false)
          .complete_profile(_image, _username, _gender, _description);
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
  Widget build(BuildContext context) {
    final spinKit =
        SpinKitWave(color: Theme.of(context).primaryColor, size: 35);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(220.0),
          child: AppBar(
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0, -1),
                  end: Alignment(0, 1),
                  colors: <Color>[Colors.orange[300], Colors.orange],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
            ),
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(100),
              ),
            ),
            title: Text('Complete your Profile'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    FlatButton.icon(
                                      onPressed: () {
                                        _pickImage('Camera');
                                      },
                                      icon: Icon(Icons.camera),
                                      label: Text('Camera'),
                                    ),
                                    Spacer(),
                                    FlatButton.icon(
                                      onPressed: () {
                                        _pickImage('Gallery');
                                      },
                                      icon: Icon(Icons.collections),
                                      label: Text('Gallery'),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: _isImageLoading
                            ? CircleAvatar(
                                child: CircularProgressIndicator(),
                                radius: 50,
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: _image == null
                                    ? NetworkImage(
                                        'https://cdn2.iconfinder.com/data/icons/romance-30/100/online-dating-pick-1-romance-online-dating-choose-pick-partner-like-view-info-profile-512.png')
                                    : FileImage(_image),
                                radius: 50,
                              ),
                      ),
                      Chip(
                        label: Text('Your Profile Picture'),
                        backgroundColor: Colors.white,
                      )
                    ],
                  )),
            ),
          ),
        ),
        body: Container(
            child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: mediaQuery.size.height * 0.07),
                  Container(
                    width: mediaQuery.size.width * 0.85,
                    child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Username',
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        validator: (value) {
                          if (value.length < 4) {
                            return 'Username must be atleast 4 characters long!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value;
                        }),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: mediaQuery.size.width * 0.85,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[900],
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: GenderPickerWithImage(
                      showOtherGender: true,
                      verticalAlignedText: false,
                      selectedGender: _gender == 'Male'
                          ? Gender.Male
                          : _gender == 'Female' ? Gender.Female : Gender.Others,
                      selectedGenderTextStyle: TextStyle(
                          color: Color(0xFF8b32a8),
                          fontWeight: FontWeight.bold),
                      unSelectedGenderTextStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal),
                      onChanged: (Gender gender) {
                        print(gender.toString().split('.')[1]);
                        _onChangeGender(gender.toString());
                      },
                      equallyAligned: true,
                      animationDuration: Duration(milliseconds: 300),
                      isCircular: true,
                      // default : true,
                      opacityOfGradient: 0.4,
                      padding: const EdgeInsets.all(3),
                      size: 70, //default : 40
                    ),
                  ),
                  SizedBox(height: 40),
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
                        onSaved: (value) {
                          _description = value;
                        }),
                  ),
                  SizedBox(height: 40),
                  if (_isLoading) spinKit,
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
                ],
              ),
            ),
          ),
        )));
  }
}

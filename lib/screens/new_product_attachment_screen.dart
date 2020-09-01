import 'dart:io';

import 'package:flutter/material.dart';

import './new_product_location_screen.dart';
import '../widget/profile_image_picker.dart';

class NewProductAttachmentScreen extends StatefulWidget {
  Function _setLocation;
  Function _setExplanationAndSubmit;
  Function _setAttachment;
  NewProductAttachmentScreen(
      this._setAttachment, this._setLocation, this._setExplanationAndSubmit);
  @override
  _NewProductAttachmentScreenState createState() =>
      _NewProductAttachmentScreenState();
}

class _NewProductAttachmentScreenState
    extends State<NewProductAttachmentScreen> {
  bool _isImageLoading = false;
  bool _isLoaded = false;
  File _image;
  String _youtubeUrl;
  final _form = GlobalKey<FormState>();

  void _pickImage(String option) async {
    setState(() {
      _isImageLoading = true;
    });
    try {
      _image = await pick(option);
      if (_image == null) {
        setState(() {
          _isImageLoading = false;
        });
        return;
      }
      setState(() {
        _isLoaded = true;
      });
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

  void _save() {
    final _isValid = _form.currentState.validate();
    if (!_isValid || !_isLoaded) {
      return;
    }
    _form.currentState.save();
    widget._setAttachment(_image, _youtubeUrl);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => NewProductLocationScreen(
            widget._setLocation, widget._setExplanationAndSubmit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        height: mediaQuery.size.height,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Theme(
              data: ThemeData(primaryColor: Colors.deepPurple),
              child: Container(
                height: mediaQuery.size.height,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 400,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: _isLoaded
                                      ? FileImage(_image)
                                      : NetworkImage(
                                          'https://www.volusion.com/blog/content/images/2018/10/Photos.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Please choose an image for your product!',
                            style: TextStyle(fontSize: 20, fontFamily: 'Alata'),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (ctx) {
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
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
                          color: Colors.deepPurple,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Pick an image',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: mediaQuery.size.width * 0.85,
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.video_library),
                              labelText: 'Youtube URL',
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (!value.contains('youtube.com')) {
                                return 'Please enter valid YouTube URL';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _youtubeUrl = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 50,
                              width: mediaQuery.size.width * 0.3,
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(Icons.arrow_back_ios,
                                      color: Colors.deepPurple[400], size: 40)),
                            ),
                            SizedBox(
                              height: 50,
                              width: mediaQuery.size.width * 0.3,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onPressed: () {
                                  _save();
                                },
                                child: Icon(Icons.arrow_forward_ios,
                                    color: Colors.deepPurple[400], size: 40),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:file_picker/file_picker.dart';

import '../widget/profile_image_picker.dart';
import '../widget/category_selector.dart';

import '../providers/project.dart';
import '../providers/projects.dart';

import '../helpers/category.dart';

class AddNewProject extends StatefulWidget {
  static String routeName = '/new_project';
  @override
  _AddNewProjectState createState() => _AddNewProjectState();
}

class _AddNewProjectState extends State<AddNewProject> {
  String _projectName;
  String _companyName;
  int _currentValue = 1;
  double _budget;
  double _payment;
  String _intro;
  String _description;
  String _youtubeUrl;
  List<String> _categories;
  File _image;
  File _attachment;
  List<int> _categoryIndexes = [];
  Set<int> selectedValues;

  bool _imageLoading = false;
  bool _fileLoading = false;
  bool _isLoading = false;

  DateTime selectedDate;
  final _form = GlobalKey<FormState>();

  void _showMultiSelect(BuildContext context) async {
    final items = <MultiSelectDialogItem<int>>[
      MultiSelectDialogItem(1, 'Production'),
      MultiSelectDialogItem(2, 'Social'),
      MultiSelectDialogItem(3, 'Educational'),
      MultiSelectDialogItem(4, 'Community'),
      MultiSelectDialogItem(5, 'Research'),
      MultiSelectDialogItem(6, 'Business'),
      MultiSelectDialogItem(7, 'IT'),
      MultiSelectDialogItem(8, 'Science and Technology'),
      MultiSelectDialogItem(9, 'Arts and Painting'),
    ];

    selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: _categoryIndexes.toSet(),
        );
      },
    );
    setState(() {
      _categories = convertToCategory(selectedValues);
      _categoryIndexes = selectedValues.toList();
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate)
      setState(
        () {
          selectedDate = picked;
        },
      );
  }

  void _pickImage() async {
    try {
      setState(() {
        _imageLoading = true;
      });
      _image = await pick('Gallery');
      if (_image == null) {
        setState(() {
          _imageLoading = false;
        });
        return;
      }
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
        _imageLoading = false;
      });
    }
  }

  void _pickAttachment() async {
    try {
      setState(() {
        _fileLoading = true;
      });
      _attachment = await FilePicker.getFile();
      print(_attachment);
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
    if (_categories == null || _categories.length <= 0) {
      throw HttpException('You must select atleast one category!');
    }
    _form.currentState.save();
    final project = new Project(
      projectName: _projectName,
      companyName: _companyName,
      numColabs: _currentValue,
      budget: _budget,
      amountPayable: _payment,
      intro: _intro,
      description: _description,
      categories: _categories,
      youtubeUrl: _youtubeUrl,
      dateTime: selectedDate,
    );
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Projects>(context, listen: false)
          .addProject(project, _image, _attachment);
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
    final mediaQuery = MediaQuery.of(context);

    final appBar = AppBar(
      title: Text('New Project Form'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      actions: [
        IconButton(icon: Icon(Icons.save), onPressed: _save),
      ],
    );

    final spinKit = SpinKitRotatingCircle(
      color: Colors.orangeAccent,
      size: 50,
    );

    final spinKitFile = SpinKitCubeGrid(
      color: Colors.orangeAccent,
      size: 25,
    );

    final spinKitConfirm =
        SpinKitWave(color: Theme.of(context).primaryColor, size: 50);

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
                      image: AssetImage('images/new_project.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Divider(),
                SizedBox(height: mediaQuery.size.height * 0.03),
                Text(
                  'New Project',
                  style: TextStyle(fontSize: 20, fontFamily: 'Alata'),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.filter_frames),
                      labelText: 'Project Name',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.length < 4) {
                        return 'Project Name should be atleast 4 characters long';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _projectName = value;
                    },
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.business),
                      labelText: 'Company Name',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.length < 4) {
                        return 'Company Name should be atleast 4 characters long';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _companyName = value;
                    },
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(width: 1.5, color: Colors.grey[400])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Number of collaborators required?',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          width: mediaQuery.size.width * 0.50),
                      Container(
                        width: mediaQuery.size.width * 0.34,
                        child: NumberPicker.integer(
                          initialValue: _currentValue,
                          minValue: 0,
                          maxValue: 100,
                          onChanged: (newValue) {
                            setState(() {
                              _currentValue = newValue;
                              print(_currentValue);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.monetization_on),
                      labelText: 'Total budget',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      try {
                        double.parse(value);
                      } catch (error) {
                        return 'Value can only be number!';
                      }
                      if (double.parse(value) < 1) {
                        return 'Value should be positive number!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _budget = double.parse(value);
                    },
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.monetization_on),
                      labelText: 'Total amount payable to each contributor',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      try {
                        double.parse(value);
                      } catch (error) {
                        return 'Value can only be number!';
                      }
                      if (double.parse(value) < 1) {
                        return 'Value should be positive number!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _payment = double.parse(value);
                    },
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description),
                      labelText: 'Tell us about your project!',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    maxLines: 7,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value.length < 10) {
                        return 'Project intro should be atleast 10 characters long!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _intro = value;
                    },
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description),
                      labelText: 'Description',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    maxLines: 15,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value.length < 20) {
                        return 'Description should be atleast 20 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description = value;
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Project should finish by?',
                              style: TextStyle(
                                  fontSize: 17, color: Colors.grey[600]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                              child: Text('Pick Date'),
                              onPressed: () => _selectDate(context),
                            ),
                          )
                        ],
                      ),
                      if (selectedDate != null) Divider(),
                      if (selectedDate != null)
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                selectedDate.day.toString() +
                                    '/' +
                                    selectedDate.month.toString() +
                                    '/' +
                                    selectedDate.year.toString(),
                                style: TextStyle(
                                    fontSize: 17, color: Colors.grey[600]),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(
                                    () {
                                      selectedDate = null;
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
                              'Please select categories related to project!',
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
                              child: FlatButton(
                                child: Text('Select Categories'),
                                onPressed: () => _showMultiSelect(context),
                              ))
                        ],
                      ),
                      if (_categories != null && _categories.length != 0)
                        Divider(),
                      if (_categories != null && _categories.length != 0)
                        Container(
                          height: _categories != null
                              ? _categories.length * 25.0
                              : 0,
                          child: ListView.builder(
                              itemCount:
                                  _categories != null ? _categories.length : 0,
                              itemBuilder: (ctx, index) {
                                return Row(
                                  children: [
                                    SizedBox(width: 15),
                                    Icon(Icons.confirmation_number,
                                        color: Colors.grey[600]),
                                    SizedBox(width: 45),
                                    Text(
                                      _categories[index],
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  ],
                                );
                              }),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.video_library),
                        labelText: 'Youtube URL (Optional)',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {
                        _youtubeUrl = value;
                      }),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: mediaQuery.size.width * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.grey[400],
                      ),
                      image: _imageLoading
                          ? null
                          : DecorationImage(
                              image: _image == null
                                  ? NetworkImage(
                                      'https://mobikul.com/wp-content/uploads/2018/04/download-1-5-1024x383.png')
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                    ),
                    height: 250,
                    child: _imageLoading ? Center(child: spinKit) : null,
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
                              'Please select document related to project!',
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
                                : _attachment == null
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
                      if (_attachment != null) Divider(),
                      if (_attachment != null)
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${_attachment.path.split('/').last.length > 31 ? _attachment.path.split('/').last.substring(0, 29) : _attachment.path.split('/').last}',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.grey[600]),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(
                                    () {
                                      _attachment = null;
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

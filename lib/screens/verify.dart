import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  bool _onEditing = true;
  String _code;
  void _press() {}
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Verify your Email'),
          backgroundColor: Colors.orange[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          )),
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Center(
                child: VerificationCode(
                  textStyle: TextStyle(fontSize: 30.0, color: Colors.blue[400]),
                  underlineColor: Colors.amber,
                  keyboardType: TextInputType.number,
                  length: 4,
                  // clearAll is NOT required, you can delete it
                  // takes any widget, so you can implement your design
                  clearAll: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      deleteIcon: Icon(Icons.delete),
                      label: Text('Clear all'),
                    ),
                  ),
                  onCompleted: (String value) {
                    setState(() {
                      _code = value;
                    });
                  },
                  onEditing: (bool value) {
                    setState(() {
                      _onEditing = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                height: 50,
                width: mediaQuery.width * 0.6,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: _press,
                  color: Theme.of(context).primaryColor,
                  child: Text('Verify',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
              Container(
                height: mediaQuery.height * 0.5,
                child: Image.asset('images/verify.png', fit: BoxFit.fitWidth),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

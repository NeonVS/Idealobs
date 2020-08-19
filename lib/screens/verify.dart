import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/auth.dart';

class Verify extends StatefulWidget {
  static const routeName = '/verify';
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  bool _onEditing = true;
  bool _finished = false;
  bool _isLoading = false;
  String _code;
  void _submit() async {
    if (_code.length == 4) {
      try {
        print('entered');
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Auth>(context, listen: false).verify(_code);
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } catch (error) {
        print(error);
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Some error has occurred!'),
            content: Text(error.toString()),
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
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spinKit =
        SpinKitWave(color: Theme.of(context).primaryColor, size: 50);
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
                      _finished = true;
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
              if (_isLoading) spinKit,
              if (!_isLoading)
                SizedBox(
                  height: 50,
                  width: mediaQuery.width * 0.6,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: _finished ? _submit : null,
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

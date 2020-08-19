import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/auth.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _form = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  bool _isLoading = false;

  String _email;
  String _password;

  void _save(BuildContext ctx) async {
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false).login(_email, _password);
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } catch (error) {
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
  }

  void _signup(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed('/signup');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final spinKit =
        SpinKitWave(color: Theme.of(context).primaryColor, size: 35);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: mediaQuery.height * 0.07),
                  Container(
                    height: mediaQuery.height * 0.5,
                    child:
                        Image.asset('images/login_pic.png', fit: BoxFit.cover),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: mediaQuery.width * 0.85,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Enter email',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      onSaved: (value) {
                        _email = value;
                      },
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: mediaQuery.width * 0.85,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        labelText: 'Password',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      onSaved: (value) {
                        _password = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8) {
                          return 'Length of password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_isLoading) spinKit,
                  if (!_isLoading)
                    SizedBox(
                      height: 50,
                      width: mediaQuery.width * 0.6,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () => _save(context),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    width: mediaQuery.width * 0.3,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      onPressed: () => _signup(context),
                      color: Colors.grey,
                      child: Text('Register ?',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// decoration: BoxDecoration(
//   image: DecorationImage(
//       image: AssetImage('images/login.png'), fit: BoxFit.fitHeight),
// ),

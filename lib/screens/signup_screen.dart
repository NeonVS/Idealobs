import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/auth.dart';

class Signup extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _form = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _passwordController = TextEditingController();
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
      await Provider.of<Auth>(context, listen: false).signup(_email, _password);
      Navigator.of(context).pushNamed('/verify');
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

  void _login(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final spinKit =
        SpinKitWave(color: Theme.of(context).primaryColor, size: 35);
    final mediaQuery = MediaQuery.of(context).size;
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
                    height: mediaQuery.height * 0.45,
                    child:
                        Image.asset('images/register.png', fit: BoxFit.cover),
                  ),
                  Center(
                    child: Container(
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
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        onSaved: (value) {
                          _email = value;
                        },
                      ),
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
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Length of password must be at least 8 characters';
                          }
                          return null;
                        },
                        controller: _passwordController,
                        textInputAction: TextInputAction.next,
                        focusNode: _passwordFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_confirmPasswordFocusNode);
                        },
                        onSaved: (value) {
                          _password = value;
                        }),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: mediaQuery.width * 0.85,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        labelText: 'Confirm Password',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Confirm Password and Password should match';
                        }
                        return null;
                      },
                      focusNode: _confirmPasswordFocusNode,
                      textInputAction: TextInputAction.done,
                      //onFieldSubmitted: (_) => _save(context),
                    ),
                  ),
                  SizedBox(height: 40),
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
                        child: Text('Confirm',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                  if (!_isLoading) SizedBox(height: 20),
                  if (!_isLoading)
                    SizedBox(
                      height: 40,
                      width: mediaQuery.width * 0.3,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        onPressed: () => _login(context),
                        color: Colors.grey,
                        child: Text('Login ?',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
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

import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  void _press() {}
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: mediaQuery.height * 0.07),
              Container(
                height: mediaQuery.height * 0.5,
                child: Image.asset('images/register.png', fit: BoxFit.cover),
              ),
              // Text(
              //   'Register',
              //   style: TextStyle(fontSize: 24),
              // ),
              // SizedBox(height: 20),
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
                ),
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
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                height: 50,
                width: mediaQuery.width * 0.6,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: _press,
                  color: Theme.of(context).primaryColor,
                  child: Text('Confirm',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

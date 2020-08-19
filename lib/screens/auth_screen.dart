import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  void _press() {}

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/main3.png'), fit: BoxFit.fitHeight),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
          ),
        ),
        Positioned(
          width: mediaQuery.size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 53,
                width: mediaQuery.size.width * 0.84,
                child: RaisedButton(
                  onPressed: _press,
                  color: Color.fromRGBO(131, 123, 217, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textColor: Colors.white,
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                height: 53,
                width: mediaQuery.size.width * 0.84,
                child: RaisedButton(
                  onPressed: _press,
                  color: Color.fromRGBO(131, 123, 217, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textColor: Colors.white,
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Welcome to Idealobs',
                  style: TextStyle(
                      fontSize: 10, color: Color.fromRGBO(131, 123, 217, 1))),
            ],
          ),
          bottom: mediaQuery.size.height * 0.08,
          //left: MediaQuery.of(context).size.width * 0.05,
        )
      ],
    );
  }
}

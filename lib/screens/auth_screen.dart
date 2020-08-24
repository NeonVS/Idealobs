import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static String routeName = '/auth_screen';
  void _login(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/login');
  }

  void _signup(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/signup');
  }

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
            // appBar: AppBar(
            //     title: Text('Idealobs'),
            //     centerTitle: true,
            //     backgroundColor: Colors.orangeAccent,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.vertical(
            //         bottom: Radius.circular(30),
            //       ),
            //     )),
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
                  onPressed: () => _login(context),
                  color: Colors.orangeAccent,
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
                  onPressed: () => _signup(context),
                  color: Colors.orangeAccent,
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
              // Chip(
              //   label: Text('Welcome to idealobs'),
              // ),
            ],
          ),
          bottom: mediaQuery.size.height * 0.08,
          //left: MediaQuery.of(context).size.width * 0.05,
        )
      ],
    );
  }
}

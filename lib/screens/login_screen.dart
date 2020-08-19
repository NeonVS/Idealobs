import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void _press() {}

  void _signup(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed('/signup');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: mediaQuery.height * 0.07),
                Container(
                  height: mediaQuery.height * 0.5,
                  child: Image.asset('images/login_pic.png', fit: BoxFit.cover),
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
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20),
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
    );
  }
}
// decoration: BoxDecoration(
//   image: DecorationImage(
//       image: AssetImage('images/login.png'), fit: BoxFit.fitHeight),
// ),

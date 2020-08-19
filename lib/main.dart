import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/verify.dart';
import './screens/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'idealobs',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            accentColor: Colors.yellow,
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(fontSize: 20),
                ),
          ),
          home: AuthScreen(),
          routes: {
            Signup.routeName: (ctx) => Signup(),
            Login.routeName: (ctx) => Login(),
            Verify.routeName: (ctx) => Verify(),
            Dashboard.routeName: (ctx) => Dashboard(),
          },
        ),
      ),
    );
  }
}
// auth.isAuth
//               ? Dashboard()
//               : FutureBuilder(
//                   future: auth.tryAutoLogin(),
//                   builder: (ctx, authResultSnapshot) {
//                     if (authResultSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return Container();
//                     } else {
//                       return AuthScreen();
//                     }
//                   },
//                 )

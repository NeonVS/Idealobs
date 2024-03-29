import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:here_sdk/core.dart';

import './providers/auth.dart';
import './providers/projects.dart';
import './providers/requests.dart';
import './providers/messages.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/order.dart';
import './screens/auth_screen.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/verify.dart';
import './screens/dashboard.dart';
import './screens/profile_complete.dart';
import './screens/splash_screen.dart';
import './screens/new_project_screen.dart';
import './screens/category_item_screen.dart';
import './screens/project_detail_screen.dart';
import './screens/pdf_view_screen.dart';
import './screens/new_request_screen.dart';
import './screens/requests_screen.dart';
import './screens/message_overview_screen.dart';
import './screens/new_product_screen.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './screens/main_screen.dart';

void main() {
  SdkContext.init(IsolateOrigin.main);
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
        ChangeNotifierProxyProvider<Auth, Projects>(
          update: (ctx, auth, previousProducts) => Projects(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Requests>(
          update: (ctx, auth, previousRequests) => Requests(
            auth.token,
            auth.userId,
            previousRequests == null ? [] : previousRequests.requests,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Messages>(
          update: (ctx, auth, previousMessages) => Messages(
            auth.token,
            auth.userId,
            previousMessages == null ? [] : previousMessages.messages,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          update: (ctx, auth, previousCart) => Cart(
            auth.token,
            auth.userId,
            previousCart == null ? [] : previousCart.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'idealobs',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            accentColor: Colors.yellow,
            fontFamily: 'Alata',
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(fontSize: 20),
                ),
          ),
          home: auth.isAuth
              ? Dashboard()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) {
                    if (authResultSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      print('splash');
                      return SplashScreen();
                    } else {
                      print('entry');
                      return AuthScreen();
                    }
                  },
                ),
          routes: {
            Signup.routeName: (ctx) => Signup(),
            Login.routeName: (ctx) => Login(),
            Verify.routeName: (ctx) => Verify(),
            Dashboard.routeName: (ctx) => Dashboard(),
            ProfileComplete.routeName: (ctx) => ProfileComplete(),
            AddNewProject.routeName: (ctx) => AddNewProject(),
            CategoryItems.routeName: (ctx) => CategoryItems(),
            ProjectDetailScreen.routeName: (ctx) => ProjectDetailScreen(),
            PdfViewer.routeName: (ctx) => PdfViewer(),
            AddNewRequest.routeName: (ctx) => AddNewRequest(),
            RequestsScreen.routeName: (ctx) => RequestsScreen(),
            MessageOverviewScreen.routeName: (ctx) => MessageOverviewScreen(),
            NewProductScreen.routeName: (ctx) => NewProductScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            MainScreen.routeName: (ctx) => MainScreen(),
          },
        ),
      ),
    );
  }
}

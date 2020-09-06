import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/projects.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/requests.dart';
import '../providers/products.dart';
import '../helpers/curve_painter.dart';
import '../widget/main_screen_product_overview.dart';
import '../widget/main_screen_project_overview.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main_screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final yourProjects = Provider.of<Projects>(context).yourItems;
    final projects = Provider.of<Projects>(context).items;
    final cart = Provider.of<Cart>(context).items;
    final yourProducts = Provider.of<Products>(context).yourItems;
    final requests = Provider.of<Requests>(context).requests;
    final yourContributions = Provider.of<Auth>(context).enrolledProjects;
    print(yourContributions);
    return Scaffold(
      backgroundColor: Color.fromRGBO(241, 243, 247, 1),
      body: SingleChildScrollView(
        child: Container(
          width: mediaQuery.size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: mediaQuery.size.width * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Your Stats',
                      style: TextStyle(fontFamily: 'Alata', fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 300,
                width: mediaQuery.size.width * 0.8,
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(
                        1.1,
                        1.1,
                      ),
                      blurRadius: 10.0,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(80),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(80),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: mediaQuery.size.width * 0.40,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 48,
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(135, 160, 229, 1)
                                                  .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, bottom: 2),
                                              child: Text(
                                                'Projects',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Alata',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: -0.1,
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 28,
                                                  height: 28,
                                                  child: Image.network(
                                                      "https://image.freepik.com/free-vector/opened-business-plan-documents-binder_3446-634.jpg"),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4, bottom: 3),
                                                  child: Text(
                                                    '${yourProjects.length}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Alata',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4, bottom: 3),
                                                  child: Text(
                                                    'p',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Alata',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      letterSpacing: -0.2,
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 48,
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(245, 110, 152, 1)
                                                  .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, bottom: 2),
                                              child: FittedBox(
                                                child: Text(
                                                  'Contributions',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Alata',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    letterSpacing: -0.1,
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 28,
                                                  height: 28,
                                                  child: Image.network(
                                                    "https://static1.squarespace.com/static/56677969d8af10373a88d834/t/56e1d76437013b87984cc278/1472239195328/dance-lesson-contribution.jpg?format=1500w",
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4, bottom: 3),
                                                  child: Text(
                                                    '${yourContributions.length}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Alata',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, bottom: 3),
                                                  child: Text(
                                                    'c',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Alata',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      letterSpacing: -0.2,
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: mediaQuery.size.width * 0.35,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Center(
                                child: Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(100.0),
                                          ),
                                          border: new Border.all(
                                              width: 5,
                                              color:
                                                  Colors.blue.withOpacity(0.2)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '${yourContributions.length}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Alata',
                                                fontWeight: FontWeight.normal,
                                                fontSize: 20,
                                                letterSpacing: 0.0,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            Text(
                                              'Contri',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Alata',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                letterSpacing: 0.0,
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: CustomPaint(
                                        painter: CurvePainter(
                                          colors: [
                                            Color.fromRGBO(67, 72, 207, 1),
                                            Color.fromRGBO(138, 152, 232, 1),
                                            Color.fromRGBO(108, 141, 226, 1),
                                          ],
                                          angle: yourContributions.length * 3.6,
                                        ),
                                        child: SizedBox(
                                          width: 108,
                                          height: 108,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 8, bottom: 8),
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(241, 243, 247, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 8, bottom: 16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Products',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Alata',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      letterSpacing: -0.2,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Container(
                                      height: 4,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(135, 160, 229, 1)
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: ((70 / 50) *
                                                yourProducts.length),
                                            height: 4,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Color.fromRGBO(
                                                    135, 160, 229, 1),
                                                Color.fromRGBO(135, 160, 229, 1)
                                                    .withOpacity(0.5),
                                              ]),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      '${yourProducts.length} items',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Alata',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Cart Items',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Alata',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.2,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Container(
                                          height: 4,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(245, 110, 152, 1)
                                                    .withOpacity(0.2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width:
                                                    ((70 / 50) * cart.length),
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    Color.fromRGBO(
                                                            245, 110, 152, 1)
                                                        .withOpacity(0.1),
                                                    Color.fromRGBO(
                                                        245, 110, 152, 1),
                                                  ]),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          '${cart.length} items',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Alata',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Requests',
                                        style: TextStyle(
                                          fontFamily: 'Alata',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.2,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 0, top: 4),
                                        child: Container(
                                          height: 4,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(241, 180, 64, 1)
                                                    .withOpacity(0.2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: ((70 / 50) *
                                                    requests.length),
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    Color.fromRGBO(
                                                            241, 180, 64, 1)
                                                        .withOpacity(0.1),
                                                    Color.fromRGBO(
                                                        241, 180, 64, 1),
                                                  ]),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(4.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          '${requests.length} requests',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Alata',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: mediaQuery.size.width * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Exciting Products',
                      style: TextStyle(fontFamily: 'Alata', fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              Container(
                height: 250,
                child: MainScreenProductOverview(),
              ),
              Row(
                children: [
                  SizedBox(
                    width: mediaQuery.size.width * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Recent Projects',
                      style: TextStyle(fontFamily: 'Alata', fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              Container(
                height: 660,
                child: Center(
                  child: Container(
                    width: mediaQuery.size.width * 0.8,
                    child: Column(
                      children: [
                        MainScreenProjectOverview(projects[0]),
                        SizedBox(height: 20),
                        MainScreenProjectOverview(projects[1]),
                        SizedBox(height: 20),
                        MainScreenProjectOverview(projects[2]),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

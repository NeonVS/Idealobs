import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/order.dart';
import '../widget/order_item.dart';

class OrderScreen extends StatefulWidget {
  static String routeName = '/order_screen';
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isLoading = false;
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
      setState(() {
        _isLoading = true;
      });
      print('entry');
      Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final items = Provider.of<Orders>(context).items;
    print(items.length);
    return Scaffold(
      // appBar: AppBar(
      //   leading: BackButton(color: Colors.white),
      //   centerTitle: true,
      //   title: Text(
      //     'Your Orders',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   elevation: 10,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.vertical(
      //       bottom: Radius.circular(30),
      //     ),
      //   ),
      //   backgroundColor: Colors.deepPurple,
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         Icons.shopping_cart,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         Navigator.of(context).pushNamed('/order_screen');
      //       },
      //     ),
      //   ],
      // ),
      body: _isLoading == true
          ? Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SpinKitCubeGrid(
                  color: Colors.deepPurple,
                  size: 50,
                ),
              ),
            )
          : Container(
              height: mediaQuery.size.height,
              child: SingleChildScrollView(
                child: Theme(
                  data: ThemeData(
                    primaryColor: Colors.deepPurple,
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: Color.fromRGBO(247, 247, 247, 1),
                        child: Container(
                          height: mediaQuery.size.height * 0.25,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(100),
                            ),
                            color: Colors.deepPurple,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 20,
                                left: 150,
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(150.0),
                                      color: Colors.deepPurple[400]),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                right: 100,
                                child: Container(
                                  height: 400,
                                  width: 400,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200),
                                    color: Colors.deepPurple[300],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 115,
                                left: 15,
                                child: Text(
                                  'Your Orders',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(246, 246, 246, 1)),
                                ),
                              ),
                              Positioned(
                                top: 38,
                                right: 15,
                                child: IconButton(
                                  alignment: Alignment.topLeft,
                                  icon: Icon(Icons.shopping_cart,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/cart_screen');
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 35),
                                child: IconButton(
                                  alignment: Alignment.topLeft,
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: mediaQuery.size.height * 0.75,
                        color: Color.fromRGBO(247, 247, 247, 1),
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (ctx, index) {
                            return OrderItemCard(items[index]);
                          },
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../providers/cart.dart';
import '../helpers/razorPayHandler.dart';
import '../widget/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = '/cart_screen';
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isInit = true;
  List<CartItem> _orderItems = [];
  double _total = 0;
  Razorpay razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() {
    final options = {
      'key': 'rzp_test_WcZxVUgP1f9PlM',
      'amount': _total*100,
      'name': 'Idealobs',
      'description': 'Payment for your products!',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorpay.open(options);
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      try {
        final cartProvider = Provider.of<Cart>(context, listen: false);
        _orderItems = [...cartProvider.items];
        if (_orderItems.length > 0) {
          _isInit = false;
        }
      } catch (error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Some error has occurred!'),
            content: Text(error.message.toString()),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Okay'),
              ),
            ],
          ),
        );
      }
    }
    print('run');
    final _items = Provider.of<Cart>(context, listen: false).items;
    print(_items);
    final _temp = _items
        .where(
          (element1) => _orderItems.fold(
            false,
            (previousValue, element2) =>
                element1.product.productId == element2.product.productId ||
                previousValue,
          ),
        )
        .toList();
    _total = 0;
    _orderItems = _temp;
    _orderItems.forEach((element) {
      print(element.quantity);
      _total += element.price * element.quantity;
    });
    print(_total);
  }

  void addAndRemoveOrderItems(bool value, CartItem item) {
    print('entry');
    if (value) {
      _orderItems.add(item);
      setState(() {
        _total = _total + item.price * item.quantity;
      });
    } else {
      _orderItems.removeWhere((value) {
        return value.product.productId == item.product.productId;
      });
      setState(() {
        _total = _total - item.price * item.quantity;
      });
    }
    print(_orderItems);
  }

  void deleteCartItem(CartItem item) async {
    try {
      addAndRemoveOrderItems(false, item);
      await Provider.of<Cart>(context, listen: false).deleteItem(item);
    } catch (error) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot remove item from Cart!'),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Cart>(context).items;
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        height: mediaQuery.size.height,
        child: SingleChildScrollView(
          child: Theme(
            data: ThemeData(primaryColor: Colors.deepPurple),
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
                                borderRadius: BorderRadius.circular(150.0),
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
                            'Shopping Cart',
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(246, 246, 246, 1)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 35),
                          child: IconButton(
                            alignment: Alignment.topLeft,
                            icon: Icon(Icons.arrow_back, color: Colors.white),
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
                  height: mediaQuery.size.height * 0.67,
                  color: Color.fromRGBO(247, 247, 247, 1),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey(items[index].product.productId),
                        background: Container(
                          color: Color.fromRGBO(247, 247, 247, 1),
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 30,
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) {
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Are you sure?'),
                              content: Text(
                                  'Do you want to remove item from the cart?'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  },
                                ),
                                FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop(true);
                                  },
                                )
                              ],
                            ),
                          );
                        },
                        child:
                            CartItemCard(items[index], addAndRemoveOrderItems),
                        onDismissed: (direction) async {
                          try {
                            await Provider.of<Cart>(context, listen: false)
                                .deleteItem(
                              items[index],
                            );
                            deleteCartItem(items[index]);
                          } catch (error) {
                            _orderItems.add(items[index]);
                            setState(() {});
                          }
                        },
                      );
                    },
                    itemCount: items.length,
                  ),
                ),
                Container(
                  height: mediaQuery.size.height * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        padding: EdgeInsets.all(8),
                        child: FittedBox(
                          child: Text(
                            'Total : \$ $_total',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Alata',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () {
                            openCheckout();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Order Now',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.deepPurple[600])),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          color: Color(0xFFFDD34A).withOpacity(1),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

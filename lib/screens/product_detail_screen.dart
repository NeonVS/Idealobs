import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import '../providers/cart.dart';

const serverBaseUrl = 'https://0a7ef1bd2657.ngrok.io';

class ProductDetailScreen extends StatefulWidget {
  Product _product;
  ProductDetailScreen(this._product);
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        height: mediaQuery.size.height,
        child: SingleChildScrollView(
          child: Theme(
            data: ThemeData(primaryColor: Colors.deepPurple),
            child: Column(
              children: [
                Hero(
                  tag: widget._product.productId,
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          serverBaseUrl +
                              '/product/product_image?creator=${widget._product.creatorId}&productName=${widget._product.productName}',
                        ),
                      ),
                    ),
                  ),
                ),
                FlatButton(
                  child: Text(
                    'Add to cart',
                  ),
                  onPressed: () {
                    CartItem item = CartItem(
                      product: widget._product,
                      quantity: 1,
                      price: widget._product.price,
                    );
                    Provider.of<Cart>(context, listen: false).addItem(item);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

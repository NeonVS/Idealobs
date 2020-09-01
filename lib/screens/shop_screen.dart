import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import './product_detail_screen.dart';
import '../providers/products.dart';
import '../widget/carousel.dart';

const serverBaseUrl = 'https://0a7ef1bd2657.ngrok.io';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    print(height);
    final products = Provider.of<Products>(context).items;
    return LayoutBuilder(builder: (context, constraints) {
      print(constraints.maxHeight);
      return Container(
        height: constraints.maxHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(247, 247, 247, 1),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(90, 60),
                      bottomRight: Radius.elliptical(90, 60)),
                ),
                child: Column(
                  children: [
                    Container(
                      child: Carousel(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Amazing products for you!',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Alata',
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(247, 247, 247, 1),
                ),
                height: height - 420,
                child: GridView.builder(
                  itemCount: products.length,
                  padding: const EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3.3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (ctx, i) {
                    return ClipRRect(
                      key: ValueKey(products[i].productId),
                      borderRadius: BorderRadius.circular(20),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        elevation: 3,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProductDetailScreen(products[i])));
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Hero(
                                      tag: products[i].productId,
                                      child: Image.network(
                                          serverBaseUrl +
                                              '/product/product_image?creator=${products[i].creatorId}&productName=${products[i].productName}',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      // height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Colors.deepPurple[400]),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.favorite),
                                            onPressed: () {},
                                            color: Colors.red[600],
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                '${products[i].productName}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Alata',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {},
                                  child: Text('Add to Cart !',
                                      style: TextStyle(color: Colors.white)),
                                  color: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.deepPurple),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

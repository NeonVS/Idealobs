import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import './user_location_screen.dart';

const serverBaseUrl = 'https://5b0e91c28cae.ngrok.io';

class ProductDetailScreen extends StatefulWidget {
  Product _product;
  ProductDetailScreen(this._product);
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int index = 0;
  YoutubePlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'feQhHStBVLE',
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
      ),
    );
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: widget._product.productId,
                  child: Stack(children: [
                    if (index == 0)
                      GestureDetector(
                        onPanUpdate: (details) {
                          if (details.delta.dx < 0) {
                            setState(() {
                              if (index == 0) {
                                index = 1;
                                print(index);
                              }
                            });
                          }
                        },
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
                    if (index == 1)
                      GestureDetector(
                        onPanUpdate: (details) {
                          if (details.delta.dx > 0) {
                            setState(() {
                              if (index == 1) {
                                index = 0;
                                print(index);
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 400,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true,
                            onReady: () {
                              print('Player is ready');
                            },
                          ),
                        ),
                      ),
                    Positioned(
                      top: 30,
                      left: 0,
                      child: FlatButton(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.deepPurple[400],
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 30,
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400],
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.deepPurple[400],
                          Colors.deepPurple[600]
                        ]),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(90, 45),
                      bottomRight: Radius.elliptical(90, 45),
                    ),
                  ),
                  child: Row(
                    children: [
                      Spacer(),
                      FlatButton(
                          child: Icon(Icons.image, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              index = 0;
                            });
                          }),
                      FlatButton(
                        child: Icon(Icons.video_library, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            index = 1;
                          });
                        },
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    'Product Number: ${widget._product.productId}',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15.0,
                        color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    '${widget._product.productName}',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 25.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: (MediaQuery.of(context).size.width / 10 +
                                MediaQuery.of(context).size.width / 2) -
                            10.0,
                        child: Text(
                          '${widget._product.info}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12.0,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        '\$ ${widget._product.price}',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 25.0,
                            color: Color(0xFFFDD34A),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Row(children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    width: mediaQuery.size.width * 0.6,
                    height: 50,
                    child: RaisedButton(
                      child: Text('Add to cart',
                          style: TextStyle(color: Colors.white)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.deepPurple[600],
                      onPressed: () {
                        CartItem item = CartItem(
                          product: widget._product,
                          quantity: 1,
                          price: widget._product.price,
                        );
                        Provider.of<Cart>(context, listen: false).addItem(item);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) =>
                        //         NewProductLocationScreen(widget._product),
                        //   ),
                        // );
                      },
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Color(0xFFFDD34A)),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.playlist_add_check,
                        color: Color(0xFFFDD34A)),
                    onPressed: () {},
                  ),
                  Spacer(),
                ]),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Idea behind the Product',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        color: Colors.grey),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "This text is very very very very very very very very very very very very very very very very very very very very very very very very very long",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        color: Colors.grey.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'How seller is meeting your needs!',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        color: Colors.grey),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "This text is very very very very very very very very very very very very very very very very very very very very very very very very very long",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        color: Colors.grey.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Seller Location',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 400,
                  width: double.infinity,
                  child: FlutterMap(
                    options: new MapOptions(
                      center: new LatLng(widget._product.place.latitude,
                          widget._product.place.longitude),
                      minZoom: 10.0,
                      zoom: 15,
                    ),
                    layers: [
                      new TileLayerOptions(
                        urlTemplate:
                            "https://api.mapbox.com/styles/v1/neonvs/ckee1t4h50hna19o5byf6ywei/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibmVvbnZzIiwiYSI6ImNrZHZ6a3lsazJudXUzMHBhOXVyN3UycXEifQ.Sd3HcLamjLQcW8BFxoJ6_w",
                        additionalOptions: {
                          'accessToken':
                              'pk.eyJ1IjoibmVvbnZzIiwiYSI6ImNrZHZ6a3lsazJudXUzMHBhOXVyN3UycXEifQ.Sd3HcLamjLQcW8BFxoJ6_w',
                          'id': 'mapbox.mapbox-streets-v8',
                        },
                      ),
                      new MarkerLayerOptions(
                        markers: [
                          new Marker(
                            width: 45.0,
                            height: 45.0,
                            point: new LatLng(widget._product.place.latitude,
                                widget._product.place.longitude),
                            builder: (context) => new Container(
                              child: IconButton(
                                icon: Image.asset('assets/poi.png'),
                                color: Colors.red,
                                iconSize: 45.0,
                                onPressed: () {
                                  print('Marker tapped');
                                },
                              ),
                            ),
                          )
                        ],
                      ),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class MainScreenProductOverview extends StatelessWidget {
  List<Color> _startColors = [
    Color.fromRGBO(250, 120, 130, 1),
    Color.fromRGBO(122, 143, 226, 1),
    Color.fromRGBO(250, 151, 183, 1),
  ];
  List<Color> _endColors = [
    Color.fromRGBO(255, 178, 152, 1),
    Color.fromRGBO(92, 93, 216, 1),
    Color.fromRGBO(252, 83, 136, 1),
  ];
  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final products = Provider.of<Products>(context).items;
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) {
          return SizedBox(
            width: 220,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: mediaQueryWidth * 0.1,
                    right: 8,
                    bottom: 16,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: _startColors[index].withOpacity(0.6),
                          offset: const Offset(1.1, 4.0),
                          blurRadius: 8.0,
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          _startColors[index],
                          _endColors[index],
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(54.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 54, left: 16, right: 16, bottom: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 14),
                          Text(
                            '${products[index].productName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Alata',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 0.2,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 138,
                                    child: Text(
                                      '${products[index].info}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      style: TextStyle(
                                        fontFamily: 'Alata',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        letterSpacing: 0.2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '\$ ${products[index].price}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Alata',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                  letterSpacing: 0.2,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -10,
                  left: 30,
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: Colors.white70.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 47,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        'https://image.freepik.com/free-vector/hazelnut-chocolate-label_167715-807.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: products.length > 3 ? 3 : products.length,
      ),
    );
  }
}

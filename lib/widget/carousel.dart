import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _current = 0;
  final List<String> imgList = [
    'https://image.freepik.com/free-vector/mobile-phone-represents-front-shop-store-shopping-online-website-mobile-application_50058-298.jpg',
    'https://image.freepik.com/free-photo/3d-open_58466-4131.jpg',
    'https://image.freepik.com/free-vector/abstract-dark-sales-background-concept_23-2148408570.jpg',
    'https://i.pinimg.com/564x/e5/3c/c1/e53cc1eb2c4d8ad2a790dc0f2d866eeb.jpg',
    'https://wl-brightside.cf.tsp.li/resize/728x/jpg/bb3/03d/ed1d315c36b9e311c1f977ff37.jpg',
    'https://image.freepik.com/free-photo/young-asian-women-with-startup-small-business-entrepreneur-freelance-working-home-excited-about-orders-many-customers-online-marketing-packing-box-delivery-thai-model_41350-397.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(0, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    return Container(
        child: Column(children: [
      CarouselSlider(
        items: imageSliders,
        options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imgList.map((url) {
          int index = imgList.indexOf(url);
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index
                  ? Color.fromRGBO(1, 1, 4, 0)
                  : Color.fromRGBO(0, 0, 0, 0.4),
            ),
          );
        }).toList(),
      ),
    ]));
  }
}

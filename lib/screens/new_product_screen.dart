import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../models/place.dart';
import './new_product_attachment_screen.dart';
import './new_product_location_screen.dart';

class NewProductScreen extends StatefulWidget {
  static String routeName = '/new_product';
  @override
  _NewProductScreenState createState() => _NewProductScreenState();
}

final appBar = AppBar(
  leading: BackButton(color: Colors.white),
  title: Text(
    'Add new Product',
    style: TextStyle(color: Colors.white),
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(30),
    ),
  ),
  backgroundColor: Colors.deepPurple,
  actions: [
    IconButton(icon: Icon(Icons.save, color: Colors.white), onPressed: () {}),
  ],
);

class _NewProductScreenState extends State<NewProductScreen> {
  PlaceLocation place;
  String idea;
  String supplyExplanation;
  String _productName;
  String _companyName;
  double _price;
  String _info;
  File _image;
  String _youtubeUrl;

  final _form = GlobalKey<FormState>();

  void setLocation(PlaceLocation _place) {
    place = _place;
  }

  void setAttachment(File _img, String _yurl) {
    _image = _img;
    _youtubeUrl = _yurl;
  }

  void setExplanationAndSubmit(String _idea, String _supplyExplanation) async {
    idea = _idea;
    supplyExplanation = _supplyExplanation;
    final product = Product(
      place: PlaceLocation(
        latitude: place.latitude,
        longitude: place.longitude,
        address1: place.address1,
        address2: place.address2,
        pincode: place.pincode,
        city: place.city,
        state: place.state,
      ),
      productName: _productName,
      companyName: _companyName,
      price: _price,
      idea: _idea,
      info: _info,
      supplyExplanation: _supplyExplanation,
      youtubeUrl: _youtubeUrl,
    );
    try {
      await Provider.of<Products>(context, listen: false)
          .addProduct(product, _image);
    } catch (error) {
      throw error;
    }
  }

  void _save() {
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => NewProductAttachmentScreen(
            setAttachment, setLocation, setExplanationAndSubmit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Container(
          height: mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top,
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Theme(
                data: ThemeData(primaryColor: Colors.deepPurple),
                child: Column(
                  children: [
                    SizedBox(height: mediaQuery.size.height * 0.03),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/new_product.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.03),
                    Text(
                      'New Product',
                      style: TextStyle(fontSize: 20, fontFamily: 'Alata'),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: mediaQuery.size.width * 0.85,
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.filter_frames),
                          labelText: 'Product Name',
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.length < 4) {
                            return 'Project Name should be atleast 4 characters long';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _productName = value;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: mediaQuery.size.width * 0.85,
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.business),
                          labelText: 'Company Name',
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.length < 4) {
                            return 'Company Name should be atleast 4 characters long';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _companyName = value;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: mediaQuery.size.width * 0.85,
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.monetization_on),
                          labelText: 'Price',
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          try {
                            double.parse(value);
                          } catch (error) {
                            return 'Price can only be number!';
                          }
                          if (double.parse(value) < 1) {
                            return 'Price should be positive number!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _price = double.parse(value);
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: mediaQuery.size.width * 0.85,
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.description),
                          labelText: 'Tell us about your product!',
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        maxLines: 7,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value.length < 10) {
                            return 'You should tell about your product in more than 10 words!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _info = value;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Spacer(),
                        SizedBox(
                          height: 50,
                          width: mediaQuery.size.width * 0.3,
                          child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () {
                                _save();
                              },
                              child: Icon(Icons.arrow_forward_ios,
                                  color: Colors.deepPurple[400], size: 40)),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import './map_screen.dart';
import '../models/place.dart';
import '../providers/product.dart';

class NewProductLocationScreen extends StatefulWidget {
  static String routeName = '/location_screen';
  final Product _product;
  NewProductLocationScreen(this._product);
  @override
  _NewProductLocationScreenState createState() =>
      _NewProductLocationScreenState();
}

class _NewProductLocationScreenState extends State<NewProductLocationScreen> {
  double _latitude = 28.7041;
  double _longitude = 77.1025;
  bool _mapLoading = false;
  PlaceLocation _location;
  String _address1;
  String _address2;
  double _pincode;
  String _state;
  String _city;

  final _form = GlobalKey<FormState>();

  Future<void> _getCurrentUserLocation() async {
    setState(() {
      _mapLoading = true;
    });
    final locData = await Location().getLocation();
    setState(() {
      _latitude = locData.latitude;
      _longitude = locData.longitude;
      _mapLoading = false;
    });
    print(locData);
  }

  Future<void> _selectOnMap() async {
    setState(() {
      _mapLoading = true;
    });
    final selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    print(selectedLocation[0]);
    print(selectedLocation[1]);
    setState(() {
      _latitude = selectedLocation[0];
      _longitude = selectedLocation[1];
      _mapLoading = false;
    });
  }

  void _save() {
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();

    _location = PlaceLocation(
      latitude: _latitude,
      longitude: _longitude,
      address1: _address1,
      address2: _address2,
      pincode: _pincode,
      city: _city,
      state: _state,
    );
    CartItem item = CartItem(
      product: widget._product,
      quantity: 1,
      price: widget._product.price,
    );
    Provider.of<Cart>(context, listen: false).addItem(item);
    Navigator.of(context).pushNamed('/shop_screen');
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (BuildContext context) =>
    //         NewProductDetailScreen(widget.setExplanationAndSubmit),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        height: mediaQuery.size.height,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Theme(
              data: ThemeData(primaryColor: Colors.deepPurple),
              child: Column(
                children: [
                  if (_mapLoading)
                    Container(height: 400, width: double.infinity),
                  if (!_mapLoading)
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: FlutterMap(
                          options: new MapOptions(
                            center: new LatLng(_latitude, _longitude),
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
                            new MarkerLayerOptions(markers: [
                              new Marker(
                                width: 45.0,
                                height: 45.0,
                                point: new LatLng(_latitude, _longitude),
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
                            ])
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Please select your location',
                      style: TextStyle(fontSize: 20, fontFamily: 'Alata'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: mediaQuery.size.width * 0.45,
                        child: RaisedButton(
                          color: Colors.deepPurple[400],
                          textColor: Colors.white,
                          onPressed: _getCurrentUserLocation,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [
                              Icon(Icons.location_on),
                              Text('Current Location')
                            ]),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      Container(
                        width: mediaQuery.size.width * 0.45,
                        child: RaisedButton(
                          color: Colors.deepPurple[400],
                          textColor: Colors.white,
                          onPressed: _selectOnMap,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [
                              Icon(Icons.map),
                              Text('  Select on Map'),
                            ]),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: mediaQuery.size.width * 0.85,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description),
                        labelText: 'Address Line 1',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      maxLines: 1,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.length < 1) {
                          return 'Address line 1 cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _address1 = value;
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: mediaQuery.size.width * 0.85,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description),
                        labelText: 'Address Line 2',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      maxLines: 1,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.length < 1) {
                          return 'Address line 2 cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _address2 = value;
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: mediaQuery.size.width * 0.85,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.pin_drop),
                        labelText: 'Pin Code',
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
                          return 'Pincode can only be number!';
                        }
                        if (double.parse(value) < 1) {
                          return 'Please enter valid pincode';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _pincode = double.parse(value);
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: mediaQuery.size.width * 0.85,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_city),
                        labelText: 'District/City',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.length < 1) {
                          return 'District/City cannot be empty';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _city = value;
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: mediaQuery.size.width * 0.85,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.assistant_photo),
                        labelText: 'State',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.length < 1) {
                          return 'State cannot be empty';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _state = value;
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: mediaQuery.size.width * 0.3,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.arrow_back_ios,
                                color: Colors.deepPurple[400], size: 40)),
                      ),
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
        ),
      ),
    );
  }
}

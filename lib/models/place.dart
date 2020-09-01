import 'package:flutter/material.dart';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address1;
  final String address2;
  final double pincode;
  final String city;
  final String state;
  const PlaceLocation({
    @required this.latitude,
    @required this.longitude,
    @required this.address1,
    @required this.address2,
    @required this.pincode,
    @required this.city,
    @required this.state,
  });
}

import 'package:flutter/material.dart';
import '../models/place.dart';

class Product with ChangeNotifier {
  final PlaceLocation place;
  final String productName;
  final String companyName;
  final double price;
  final String idea;
  final String info;
  final String supplyExplanation;
  final String youtubeUrl;
  final String productId;
  final String creatorId;
  Product(
      {@required this.place,
      @required this.productName,
      @required this.companyName,
      @required this.price,
      @required this.idea,
      @required this.info,
      @required this.supplyExplanation,
      @required this.youtubeUrl,
      this.productId,
      this.creatorId,});
}

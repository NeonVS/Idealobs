import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';
import '../models/place.dart';

const serverBaseUrl = 'https://5b0e91c28cae.ngrok.io';

class OrderItem {
  final Product product;
  final int quantity;
  final double price;

  OrderItem({this.product, this.quantity, this.price});
}

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];
  final String token;
  final String userId;
  Orders(this.token, this.userId, this._items);

  List<OrderItem> get items {
    return [..._items];
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((element) {
      total += element.price;
    });
    return total;
  }

  Future<void> addItem(List<OrderItem> items) async {
    try {
      List<Map<String, String>> orderItems = [];
      items.forEach((element) {
        orderItems.add({
          'productId': element.product.productId,
          'quantity': element.quantity.toString(),
          'price': element.price.toString(),
        });
      });
      final response = await http.post(serverBaseUrl + '/order/add_item',
          body: json.encode(orderItems),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
          });
      items.forEach((element) {
        _items.insert(0, element);
      });
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Server Error, Please try after some time!');
    }
  }

  Future<void> fetchAndSetOrders() async {
    try {
      final responseData = await http.get(
        serverBaseUrl + '/order/get_orders',
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
        },
      );
      final response = json.decode(responseData.body);
      print(response);
      final orders = response['orders'];
      print(orders);
      List<OrderItem> _loadedItems = [];
      orders.forEach((item) {
        final product = Product(
          place: PlaceLocation(
            latitude: item['productId']['latitude'].toDouble(),
            longitude: item['productId']['longitude'].toDouble(),
            address1: item['productId']['address1'].toString(),
            address2: item['productId']['address2'].toString(),
            pincode: item['productId']['pincode'].toDouble(),
            city: item['productId']['city'].toString(),
            state: item['productId']['state'].toString(),
          ),
          productName: item['productId']['productName'].toString(),
          companyName: item['productId']['companyName'].toString(),
          price: item['productId']['price'].toDouble(),
          idea: item['productId']['idea'].toString(),
          info: item['productId']['info'].toString(),
          supplyExplanation: item['productId']['supplyExplanation'].toString(),
          youtubeUrl: item['productId']['youtubeUrl'].toString(),
          productId: item['productId']['_id'].toString(),
          creatorId: item['productId']['creatorId'].toString(),
        );
        _loadedItems.add(
          OrderItem(
            product: product,
            quantity: item['quantity'].toInt(),
            price: item['price'].toDouble(),
          ),
        );
      });
      print(items);
      _items = _loadedItems;
      notifyListeners();
    } catch (error) {}
  }
}

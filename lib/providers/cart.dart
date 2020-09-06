import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/place.dart';
import './product.dart';

const serverBaseUrl = 'https://5b0e91c28cae.ngrok.io';

class CartItem {
  final Product product;
  final int quantity;
  final double price;

  CartItem({this.product, this.quantity, this.price});
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];
  final String token;
  final String userId;
  bool isLoaded = false;
  double orderTotal = 0;
  Cart(this.token, this.userId, this._items);

  List<CartItem> get items {
    return [..._items];
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((element) {
      total += element.price;
    });
    return total;
  }

  Future<void> addItem(CartItem item) async {
    try {
      CartItem cartProduct;
      int index = _items.indexWhere(
          (element) => element.product.productId == item.product.productId);
      if (index == -1) {
        cartProduct = item;
      } else {
        cartProduct = CartItem(
            product: item.product,
            quantity: _items[index].quantity + 1,
            price: item.price);
      }
      final response = await http.post(serverBaseUrl + '/cart/add_item',
          body: json.encode({
            'productId': cartProduct.product.productId,
            'quantity': cartProduct.quantity,
            'price': cartProduct.price
          }),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
          });
      if (index == -1) {
        _items.insert(0, cartProduct);
      } else {
        _items.removeAt(index);
        _items.insert(index, cartProduct);
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Server Error, Please try after some time!');
    }
  }

  Future<void> decreaseItem(CartItem item) async {
    try {
      int index = _items.indexWhere(
          (element) => element.product.productId == item.product.productId);
      CartItem cartProduct = CartItem(
        product: item.product,
        quantity: item.quantity - 1,
        price: item.price,
      );
      final response = await http.post(serverBaseUrl + '/cart/add_item',
          body: json.encode({
            'productId': cartProduct.product.productId,
            'quantity': cartProduct.quantity,
            'price': cartProduct.price
          }),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
          });
      _items.removeAt(index);
      _items.insert(index, cartProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Server Error, Please try after some time!');
    }
  }

  Future<void> fetchAndSetCartItems() async {
    try {
      final responseData = await http.get(
        serverBaseUrl + '/cart/get_items',
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
        },
      );
      final response = json.decode(responseData.body);
      final cart = response['cart'];
      List<CartItem> _loadedItems = [];
      print(cart);
      cart['cartItem'].forEach((item) {
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
        _loadedItems.insert(
          0,
          CartItem(
            product: product,
            quantity: item['quantity'].toInt(),
            price: item['price'].toDouble(),
          ),
        );
      });
      _items = _loadedItems;
      isLoaded = true;
      //notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Server Error, Please try after some time! ok?');
    }
  }

  Future<void> deleteItem(CartItem item) async {
    try {
      final response = await http.post(serverBaseUrl + '/cart/delete_item',
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
          },
          body: json.encode({
            'productId': item.product.productId,
          }));
      _items.removeWhere(
          (element) => element.product.productId == item.product.productId);
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Server Error, Please try after some time!');
    }
  }

  void deleteItems(List<CartItem> items) {
    final _loadedItems = _items;
    _loadedItems.removeWhere((element) {
      return items.fold(false, (previousValue, item) {
        return element.product.productId == item.product.productId ||
            previousValue;
      });
    });
    _items = _loadedItems;
    notifyListeners();
  }
}

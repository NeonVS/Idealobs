import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../models/place.dart';
import './product.dart';

const serverBaseUrl = 'https://5b0e91c28cae.ngrok.io';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String token;
  final String userId;
  Products(this.token, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get yourItems {
    return [..._items.where((product) => product.creatorId == userId).toList()];
  }

  Future<void> addProduct(Product product, File image) async {
    try {
      Response response;
      Dio dio = new Dio();
      FormData formData = FormData.fromMap({
        'productName': product.productName,
        'companyName': product.companyName,
        'price': product.price,
        'info': product.info,
        'latitude': product.place.latitude,
        'longitude': product.place.longitude,
        'address1': product.place.address1,
        'address2': product.place.address2,
        'pincode': product.place.pincode,
        'city': product.place.city,
        'state': product.place.state,
        'idea': product.idea,
        'youtubeUrl': product.youtubeUrl,
        'supplyExplanation': product.supplyExplanation,
        'product_image': await MultipartFile.fromFile(image.path,
            filename: '$userId-${product.productName}.jpg'),
      });
      dio.options.headers['Authorization'] = 'Bearer ' + token;
      response = await dio.post(
        serverBaseUrl + '/product/add_product',
        data: formData,
      );
      _items.add(
        Product(
          place: PlaceLocation(
            latitude: product.place.latitude,
            longitude: product.place.longitude,
            address1: product.place.address1,
            address2: product.place.address2,
            pincode: product.place.pincode,
            city: product.place.city,
            state: product.place.state,
          ),
          productName: product.productName,
          companyName: product.companyName,
          price: product.price,
          idea: product.idea,
          info: product.info,
          supplyExplanation: product.supplyExplanation,
          youtubeUrl: product.youtubeUrl,
          productId: response.data['productId'],
          creatorId: userId,
        ),
      );
    } catch (error) {
      if (error.response.statusCode == 422) {
        try {
          final message = json.decode(error.response.toString()).toString();
          throw HttpException(message.split(":")[1].trim().split('}')[0]);
        } catch (error) {
          throw HttpException('Server Error, Please try after some time!');
        }
      } else {
        throw HttpException('Server Error, Please try after some time!');
      }
    }
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final responseData = await http.get(
        serverBaseUrl + '/product/get_products',
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json'
        },
      );
      final response = json.decode(responseData.body);
      final products = response['products'];
      print(products);
      List<Product> _loadedItems = [];
      products.forEach((product) {
        _loadedItems.insert(
            0,
            Product(
              place: PlaceLocation(
                latitude: product['latitude'].toDouble(),
                longitude: product['longitude'].toDouble(),
                address1: product['address1'].toString(),
                address2: product['address2'].toString(),
                pincode: product['pincode'].toDouble(),
                city: product['city'].toString(),
                state: product['state'].toString(),
              ),
              productName: product['productName'].toString(),
              companyName: product['companyName'].toString(),
              price: product['price'].toDouble(),
              idea: product['idea'].toString(),
              info: product['info'].toString(),
              supplyExplanation: product['supplyExplanation'].toString(),
              youtubeUrl: product['youtubeUrl'].toString(),
              productId: product['_id'].toString(),
              creatorId: product['creatorId'].toString(),
            ));
        _items = _loadedItems;
      });
    } catch (error) {
      print(error);
      throw HttpException('Server Error');
    }
  }
}

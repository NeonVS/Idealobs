import 'package:flutter/material.dart';

import '../widget/category_item.dart';

import '../helpers/category.dart';

class CategoriesScreen extends StatelessWidget {
  final List<dynamic> _items = itemDataProvider();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return CategoryItem(_items[index]['title'], _items[index]['imageUrl']);
      },
      itemCount: 9,
    );
  }
}

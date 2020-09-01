import 'package:flutter/material.dart';

import '../widget/category_item.dart';

import '../helpers/category.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<dynamic> _items = itemDataProvider();
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

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

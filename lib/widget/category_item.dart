import 'package:flutter/material.dart';

import '../screens/category_item_screen.dart';

class CategoryItem extends StatelessWidget {
  final String _title;
  final String _imageUrl;

  CategoryItem(this._title, this._imageUrl);
  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(CategoryItems.routeName, arguments: _title);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectCategory(context),
      borderRadius: BorderRadius.circular(15),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                _imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Text(
                _title,
                style: TextStyle(fontSize: 16, fontFamily: 'Alata'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

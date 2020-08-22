import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widget/category_item.dart';

import '../providers/projects.dart';

import '../helpers/category.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<dynamic> _items = itemDataProvider();
  bool _isInit = true;
  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
      setState(
        () {
          _isLoading = true;
        },
      );
      Provider.of<Projects>(context, listen: false).fetchAndSetProjects().then(
            (value) => setState(
              () {
                _isLoading = false;
              },
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spinKit =
        SpinKitCubeGrid(color: Theme.of(context).primaryColor, size: 50);
    return _isLoading
        ? Center(child: spinKit)
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return CategoryItem(
                  _items[index]['title'], _items[index]['imageUrl']);
            },
            itemCount: 9,
          );
  }
}

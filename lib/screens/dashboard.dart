import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

import '../widget/app_drawer.dart';
import '../screens/category_screen.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
  }

  void changePage(int index) {
    setState(() {
      print(index);
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final appBar = AppBar(
      title: Text('Welcome to idealobs'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      actions: [
        IconButton(
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.black,
          ),
          onPressed: null,
        ),
        IconButton(
          icon: Icon(
            Icons.person,
            color: Colors.black,
          ),
          onPressed: null,
        )
      ],
    );
    return Scaffold(
      appBar: appBar,
      drawer: AppDrawer(),
      body: Container(
        height: mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top,
        child: CategoriesScreen(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: PopupMenuButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          onSelected: (value) {
            if (value == 0) {
              Navigator.of(context).pushNamed('/new_project');
            }
            if (value == 1) {
              Navigator.of(context).pushNamed('/new_product');
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              child: ListTile(
                  leading: Icon(Icons.filter_none), title: Text('New Project')),
              value: 0,
            ),
            PopupMenuItem(
              child: ListTile(
                  leading: Icon(Icons.shopping_basket),
                  title: Text('New Product')),
              value: 1,
            ),
          ],
          icon: Icon(
            Icons.add,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        opacity: .2,
        currentIndex: currentIndex,
        onTap: (value) {
          //print(value);
          changePage(value);
        },
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        elevation: 8,
        hasInk: true,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.red,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.shop,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.shop,
                color: Colors.deepPurple,
              ),
              title: Text("Shop")),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(
                Icons.attach_money,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.attach_money,
                color: Colors.indigo,
              ),
              title: Text("Contribute")),
          BubbleBottomBarItem(
            backgroundColor: Colors.green,
            icon: Icon(
              Icons.message,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.message,
              color: Colors.green,
            ),
            title: Text("Messages"),
          )
        ],
      ),
    );
  }
}

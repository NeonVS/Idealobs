import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/projects.dart';
import '../providers/requests.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../widget/app_drawer.dart';
import '../widget/badge.dart';
import '../screens/category_screen.dart';
import '../screens/requests_screen.dart';
import '../screens/message_overview_screen.dart';
import '../screens/shop_screen.dart';
import '../screens/main_screen.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex;
  bool _areCategoriesLoading = false;
  bool _areProductsLoading = false;
  bool _isInit = true;
  List<String> _title = [
    'Welcome to idealobs',
    'Shop',
    'Contribute',
    'Messages'
  ];
  List<Color> _colors = [
    Color.fromRGBO(241, 243, 247, 1),
    Colors.deepPurple,
    Colors.orange.withOpacity(0.8),
    Colors.indigo
  ];
  Map<int, Widget> _body = {
    0: CategoriesScreen(),
    1: ShopScreen(),
    2: CategoriesScreen(),
    3: MessageOverviewScreen(),
  };

  Widget body(int index) {
    if (currentIndex == 0) {
      if (_areProductsLoading) {
        return spinkit(Colors.deepPurple);
      }
      return MainScreen();
    }
    if (currentIndex == 1) {
      if (_areProductsLoading) {
        return spinkit(Colors.deepPurple);
      }
      return ShopScreen();
    }
    if (currentIndex == 2) {
      if (_areCategoriesLoading) {
        return spinkit(Theme.of(context).primaryColor);
      }
      return CategoriesScreen();
    }
    if (currentIndex == 3) {
      return MessageOverviewScreen();
    }
  }

  Widget spinkit(Color color) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: SpinKitCubeGrid(color: color, size: 50),
      ),
    );
  }

  // Map<String, Color> _headColor = {'light': Colors.black, 'dark': Colors.white};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
    Provider.of<Requests>(context, listen: false).fetchAndSetRequests();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
      setState(
        () {
          _areCategoriesLoading = true;
          _areProductsLoading = true;
        },
      );
      Provider.of<Projects>(context, listen: false).fetchAndSetProjects().then(
            (value) => setState(
              () {
                _areCategoriesLoading = false;
              },
            ),
          );
      Provider.of<Cart>(context, listen: false)
          .fetchAndSetCartItems()
          .then((value) {
        Provider.of<Products>(context, listen: false)
            .fetchAndSetProducts()
            .then(
              (value) => setState(
                () {
                  _areProductsLoading = false;
                },
              ),
            );
      });
    }
  }

  RoundedRectangleBorder shape(index) {
    if (index == 0) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(0),
        ),
      );
    }
    if (index == 1) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(0),
        ),
      );
    }
    if (index == 2) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      );
    }
    if (index == 3) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(0),
        ),
      );
    }
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
      centerTitle: true,
      title: Text(
        _title[currentIndex],
        style: TextStyle(
          color: currentIndex == 0 || currentIndex == 2
              ? Colors.black
              : Colors.white,
        ),
      ),
      elevation: currentIndex == 2 ? 10.0 : 0.0,
      leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: currentIndex == 0 || currentIndex == 2
                ? Colors.black
                : Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          }),
      shape: shape(currentIndex),
      backgroundColor: _colors[currentIndex],
      actions: [
        IconButton(
          icon: Icon(
            Icons.shopping_cart,
            color: currentIndex == 0 || currentIndex == 2
                ? Colors.black
                : Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/cart_screen');
          },
        ),
        if (currentIndex == 1)
          IconButton(
            icon: Icon(
              Icons.playlist_add_check,
              color: currentIndex == 0 || currentIndex == 2
                  ? Colors.black
                  : Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/order_screen');
            },
          ),
        if (currentIndex == 2)
          Consumer<Requests>(
            builder: (_, request, ch) => Badge(
              child: ch,
              value: request.requests.length.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.person),
              color: currentIndex == 0 || currentIndex == 2
                  ? Colors.black
                  : Colors.white,
              onPressed: () {
                Navigator.of(context).pushNamed(RequestsScreen.routeName);
              },
            ),
          ),
      ],
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      body: Container(
        height: mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top,
        child: body(currentIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
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
                leading: Icon(Icons.filter_none),
                title: Text('New Project'),
              ),
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
            color: currentIndex == 0 || currentIndex == 2
                ? Colors.black
                : Colors.white,
          ),
        ),
        backgroundColor: _colors[currentIndex],
        foregroundColor: Colors.white,
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
              backgroundColor: Colors.orange.withOpacity(0.8),
              icon: Icon(
                Icons.attach_money,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.attach_money,
                color: Colors.orange.withOpacity(0.8),
              ),
              title: Text("Contribute")),
          BubbleBottomBarItem(
            backgroundColor: Colors.indigo,
            icon: Icon(
              Icons.message,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.message,
              color: Colors.indigo,
            ),
            title: Text("Messages"),
          ),
        ],
      ),
    );
  }
}

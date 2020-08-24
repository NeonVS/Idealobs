import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/projects.dart';
import '../providers/requests.dart';
import '../widget/app_drawer.dart';
import '../widget/badge.dart';
import '../screens/category_screen.dart';
import '../screens/requests_screen.dart';
import '../screens/message_overview_screen.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex;
  List<String> _title = [
    'Welcome to idealobs',
    'Shop',
    'Contribute',
    'Messages'
  ];
  List<Color> _colors = [
    Colors.red,
    Colors.deepPurple,
    Colors.orange.withOpacity(0.8),
    Colors.indigo
  ];
  Map<int, Widget> _body = {
    0: CategoriesScreen(),
    1: CategoriesScreen(),
    2: CategoriesScreen(),
    3: MessageOverviewScreen(),
  };
  bool _isLoading = false;
  bool _isInit = true;
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

  void changePage(int index) {
    setState(() {
      print(index);
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final spinKit =
        SpinKitCubeGrid(color: Theme.of(context).primaryColor, size: 50);
    final appBar = AppBar(
      title: Text(
        _title[currentIndex],
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      backgroundColor: _colors[currentIndex],
      actions: [
        IconButton(
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
          onPressed: null,
        ),
        Consumer<Requests>(
          builder: (_, request, ch) => Badge(
            child: ch,
            value: request.requests.length.toString(),
          ),
          child: IconButton(
            icon: Icon(Icons.person),
            color: Colors.white,
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
        child: _isLoading ? Center(child: spinKit) : _body[currentIndex],
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
          )
        ],
      ),
    );
  }
}

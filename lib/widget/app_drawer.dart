import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                colors: [color.withOpacity(0.7), color],
                begin: Alignment(0, -1),
                end: Alignment(0, 1),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://lh3.googleusercontent.com/proxy/ncftxUnSbBA1Zjar8Nv-tqX0IJN0gZfxz8XEwwnLkWKOmjqyOLfLBWiCWabIsmnVq9xGh3qPkhTgviLxZnuVnx0qH7MTusO2pZgQIaJAqwCcnw-QHAgLpvs'),
                          fit: BoxFit.fill),
                    ),
                  ),
                  title: Text('Hello Vishu Saxena',
                      style: TextStyle(fontSize: 25)),
                  subtitle: Text('Here is a second line'),
                  //trailing: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}

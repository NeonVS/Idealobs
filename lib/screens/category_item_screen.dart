import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/project.dart';
import '../providers/projects.dart';

import './project_detail_screen.dart';

const serverBaseUrl = 'https://b4046dad2fa6.ngrok.io';

class CategoryItems extends StatelessWidget {
  static String routeName = '/category_items';

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context).settings.arguments as String;
    final List<Project> items =
        Provider.of<Projects>(context).fetchByCategory(category);
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text(category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
    );
    return Scaffold(
      appBar: appBar,
      body: Container(
        height: mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (ctx, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(ProjectDetailScreen.routeName,
                    arguments: items[index]);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Hero(
                            tag:
                                '${items[index].creator}-${items[index].projectName}',
                            child: Image.network(
                              serverBaseUrl +
                                  '/project/project_image?creator=${items[index].creator}&projectName=${items[index].projectName}',
                              height: mediaQuery.size.height * 0.28,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 10,
                          child: Container(
                            width: 200,
                            color: Colors.black54,
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Text(
                              items[index].projectName,
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: mediaQuery.size.width * 0.27,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.schedule),
                                SizedBox(width: 6),
                                Text(
                                    '${items[index].dateTime.difference(DateTime.now()).inDays.floor().toString()} days')
                              ],
                            ),
                          ),
                          Container(
                            width: mediaQuery.size.width * 0.27,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.attach_money),
                                SizedBox(width: 6),
                                Text('${items[index].amountPayable}')
                              ],
                            ),
                          ),
                          Container(
                            width: mediaQuery.size.width * 0.27,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.business),
                                SizedBox(width: 6),
                                Text('${items[index].budget}')
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

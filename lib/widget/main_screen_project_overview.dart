import 'package:flutter/material.dart';

import '../providers/project.dart';
import '../providers/projects.dart';

class MainScreenProjectOverview extends StatelessWidget {
  Project _project;
  MainScreenProjectOverview(this._project);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      width: mediaQuery.size.width * 0.8,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topRight: Radius.circular(68.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
                  child: Text(
                    '${_project.projectName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Alata',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: -0.1,
                      color: Colors.black,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 3),
                          child: Text(
                            '\$ ${_project.amountPayable}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Alata',
                              fontWeight: FontWeight.w600,
                              fontSize: 28,
                              color: Color.fromRGBO(67, 72, 207, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              color: Colors.grey.withOpacity(0.5),
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                '${_project.dateTime.day.toString() + '/' + _project.dateTime.month.toString() + '/' + _project.dateTime.year.toString()}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Alata',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 8),
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(241, 243, 247, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 24, top: 8, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FittedBox(
                              child: Text(
                                '\$ ${_project.budget}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Alata',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.2,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                'Budget',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Alata',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${_project.numColabs}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Alata',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Collaborators',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Alata',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '${_project.dateTime.difference(DateTime.now()).inDays}',
                                  style: TextStyle(
                                    fontFamily: 'Alata',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Body fat',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Alata',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

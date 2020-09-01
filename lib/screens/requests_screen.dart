import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/request.dart';
import '../providers/requests.dart';
import '../providers/auth.dart';

class RequestsScreen extends StatefulWidget {
  static const routeName = '/requests_screen';

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  bool _isLoading = false;

  void _confirm(Request request, BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final requests = Provider.of<Requests>(context, listen: false);
      await requests.confirmRequest(request);
      await Provider.of<Auth>(context, listen: false)
          .addEnrolledProject(request.projectId);
      requests.removeRequest(request);
    } catch (error) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Some error has occurred!'),
          content: Text(error.message.toString()),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Okay'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deny(Request request, BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final requests = Provider.of<Requests>(context, listen: false);
      await requests.denyRequest(request);
      requests.removeRequest(request);
    } catch (error) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Some error has occurred!'),
          content: Text(error.message.toString()),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Okay'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final requests = Provider.of<Requests>(context).requests;
    final mediaQuery = MediaQuery.of(context);
    final spinKit =
        SpinKitCubeGrid(color: Theme.of(context).primaryColor, size: 50);
    final appBar = AppBar(
      title: Text('Your Requests'),
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
        child: _isLoading
            ? Center(child: spinKit)
            : ListView.builder(
                itemCount: requests.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: mediaQuery.size.width * 0.9,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                            width: 3,
                          ),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.orange[100], Colors.orange[500]]),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: mediaQuery.size.width * 0.22,
                                height: mediaQuery.size.width * 0.22,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      image: new NetworkImage(
                                          'https://0a7ef1bd2657.ngrok.io/auth/profile_pic?userId=${requests[index].userId}'),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                        color: Colors.orange[400], width: 3)),
                              ),
                            ),
                            Container(
                              width: mediaQuery.size.width * 0.55,
                              child: Column(
                                children: [
                                  Container(
                                    height: 80,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            requests[index].name,
                                            style: TextStyle(
                                                fontFamily: 'Alata',
                                                fontSize: 20),
                                          ),
                                        ),
                                        Text(
                                          requests[index].email,
                                          style: TextStyle(
                                              fontFamily: 'Alata',
                                              fontSize: 14),
                                        ),
                                        Divider(
                                            color: Colors.orange[400],
                                            thickness: 3)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: FlatButton(
                                            color: Colors.green[400],
                                            child: Text(
                                              'Confirm',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            onPressed: () {
                                              _confirm(
                                                  requests[index], context);
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: FlatButton(
                                            color: Colors.red[400],
                                            child: Text(
                                              'Deny',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            onPressed: () {
                                              _deny(requests[index], context);
                                            },
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

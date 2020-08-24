import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/projects.dart';
import '../providers/auth.dart';

class MessageOverviewScreen extends StatefulWidget {
  static const routeName = '/message_overview_screen';
  @override
  _MessageOverviewScreenState createState() => _MessageOverviewScreenState();
}

class _MessageOverviewScreenState extends State<MessageOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _projects = Provider.of<Projects>(context, listen: false).items;
    final _enrolledProjectIds =
        Provider.of<Auth>(context, listen: false).enrolledProjects;
    final _enrolledProject = _projects.where((project) {
      return _enrolledProjectIds.contains(project.projectId);
    }).toList();
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Container(
          height: constraints.maxHeight,
          child: ListView.builder(
            itemCount: _enrolledProject.length,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  Card(
                    child: ListTile(
                        title: Text(_enrolledProject[index].projectName)),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}

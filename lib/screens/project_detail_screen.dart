import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import '../providers/project.dart';
import './new_request_screen.dart';
import '../providers/projects.dart';

const serverBaseUrl = 'https://b4046dad2fa6.ngrok.io';

class ProjectDetailScreen extends StatefulWidget {
  static String routeName = '/project_detail_screen';

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  YoutubePlayerController _controller;
  Project project;
  String downloadUrl;
  PDFDocument document;

  @override
  void initState() {
    // TODO: implement initState
    _controller = YoutubePlayerController(
      initialVideoId: 'feQhHStBVLE',
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    project = ModalRoute.of(context).settings.arguments as Project;
    downloadUrl = serverBaseUrl +
        '/project/project_attachment?creator=${project.creator}&projectName=${project.projectName}';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${project.projectName}'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: mediaQuery.size.height * 0.03),
                Container(
                  width: mediaQuery.size.width * 0.95,
                  height: mediaQuery.size.height * 0.38,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300],
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Hero(
                      tag: '${project.creator}-${project.projectName}',
                      child: Image.network(
                        serverBaseUrl +
                            '/project/project_image?creator=${project.creator}&projectName=${project.projectName}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      '${project.projectName}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Alata',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                Chip(
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'PAY ${project.amountPayable}',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.8),
                    avatar: Icon(
                      Icons.attach_money,
                      color: Colors.white,
                    )),
                SizedBox(height: mediaQuery.size.height * 0.03),
                Text(
                  '${project.intro}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Description: ${project.intro}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                    softWrap: true,
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                Container(
                  width: mediaQuery.size.width * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300],
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          'Details',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Company name ${project.companyName}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Total budget is ${project.budget}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Number of Collaborators required are ${project.numColabs}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Project should finish by ${project.dateTime.day.toString() + '/' + project.dateTime.month.toString() + '/' + project.dateTime.year.toString()}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                if (project.youtubeUrl != null)
                  Container(
                    width: mediaQuery.size.width * 0.95,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300],
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        onReady: () {
                          print('Player is ready');
                        },
                      ),
                    ),
                  ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                FlatButton.icon(
                  onPressed: () => {
                    Navigator.of(context)
                        .pushNamed('/pdf_view', arguments: downloadUrl),
                  },
                  icon: Icon(Icons.open_in_new, color: Colors.green[300]),
                  label: Text('View Attachment',
                      style: TextStyle(color: Colors.green[300])),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                SizedBox(
                  height: 50,
                  width: mediaQuery.size.width * 0.6,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () => {
                      Navigator.of(context).pushNamed(AddNewRequest.routeName,
                          arguments: project),
                    },
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Apply for it ?',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

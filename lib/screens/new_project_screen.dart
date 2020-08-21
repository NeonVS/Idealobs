import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class AddNewProject extends StatefulWidget {
  static String routeName = '/new_project';
  @override
  _AddNewProjectState createState() => _AddNewProjectState();
}

class _AddNewProjectState extends State<AddNewProject> {
  int _currentValue = 1;
  DateTime selectedDate = DateTime.now();
  final _form = GlobalKey<FormState>();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final appBar = AppBar(
      title: Text('New Project Form'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      actions: [
        IconButton(icon: Icon(Icons.save), onPressed: () {}),
      ],
    );

    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Container(
        height: mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top,
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              children: [
                SizedBox(height: mediaQuery.size.height * 0.03),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/new_project.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Divider(),
                SizedBox(height: mediaQuery.size.height * 0.03),
                Text(
                  'New Project',
                  style: TextStyle(fontSize: 20, fontFamily: 'Alata'),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.filter_frames),
                      labelText: 'Project Name',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.business),
                      labelText: 'Company Name',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(width: 1.5, color: Colors.grey[400])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Number of collaborators required?',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          width: mediaQuery.size.width * 0.50),
                      Container(
                        width: mediaQuery.size.width * 0.34,
                        child: NumberPicker.integer(
                          initialValue: _currentValue,
                          minValue: 0,
                          maxValue: 100,
                          onChanged: (newValue) =>
                              setState(() => _currentValue = newValue),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.monetization_on),
                      labelText: 'Total budget',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.monetization_on),
                      labelText: 'Total amount payable to each contributor',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description),
                        labelText: 'Tell us about your project!',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      maxLines: 7,
                      onSaved: (value) {}),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description),
                        labelText: 'Description',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      maxLines: 15,
                      onSaved: (value) {}),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 1.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Project should finish by?',
                          style:
                              TextStyle(fontSize: 17, color: Colors.grey[600]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          child: Text('Pick Date'),
                          onPressed: () => _selectDate(context),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: mediaQuery.size.width * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.video_library),
                      labelText: 'Youtube URL (Optional)',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  child: Container(
                    width: mediaQuery.size.width * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.grey[400],
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://mobikul.com/wp-content/uploads/2018/04/download-1-5-1024x383.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 250,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

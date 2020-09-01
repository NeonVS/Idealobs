import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NewProductDetailScreen extends StatefulWidget {
  Function _setExplanationAndSubmit;
  NewProductDetailScreen(this._setExplanationAndSubmit);
  @override
  _NewProductDetailScreenState createState() => _NewProductDetailScreenState();
}

class _NewProductDetailScreenState extends State<NewProductDetailScreen> {
  bool _isLoading = false;
  String _idea;
  String _supplyExplanation;
  bool _checkValue = false;
  final _form = GlobalKey<FormState>();

  void _save() async {
    final _isValid = _form.currentState.validate();
    if (!_checkValue || !_isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await widget._setExplanationAndSubmit(_idea, _supplyExplanation);
    } catch (error) {
      showDialog(
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
        Navigator.of(context).pushReplacementNamed('/dashboard');
      });
    }
  }

  final appBar = AppBar(
    leading: BackButton(color: Colors.white),
    title: Text(
      'Idea behind Product',
      style: TextStyle(color: Colors.white),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
    backgroundColor: Colors.deepPurple,
    actions: [
      IconButton(icon: Icon(Icons.done, color: Colors.white), onPressed: () {}),
    ],
  );
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final spinKit = SpinKitWave(color: Colors.deepPurple, size: 30);
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
            child: Theme(
              data: ThemeData(primaryColor: Colors.deepPurple),
              child: Column(
                children: [
                  SizedBox(height: mediaQuery.size.height * 0.03),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/product_idea.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'What is idea and motive behind your product?',
                      style: TextStyle(fontSize: 20, fontFamily: 'Alata'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: mediaQuery.size.width * 0.85,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.length < 10) {
                          return 'You should tell in more than 10 words!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _idea = value;
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'How will you meet consumer needs?',
                      style: TextStyle(fontSize: 20, fontFamily: 'Alata'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: mediaQuery.size.width * 0.85,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.length < 10) {
                          return 'You should tell in more than 10 words';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _supplyExplanation = value;
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: mediaQuery.size.width * 0.85,
                    child: CheckboxListTile(
                      title: Text(
                          "I hereby agree to the terms and conditions of Idealobs Private Limited."),
                      value: _checkValue,

                      onChanged: (newValue) {
                        setState(() {
                          _checkValue = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                      activeColor: Colors.deepPurple[400],
                    ),
                  ),
                  SizedBox(height: 30),
                  if (!_isLoading)
                    SizedBox(
                      height: 50,
                      width: mediaQuery.size.width * 0.6,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          _save();
                        },
                        color: Colors.deepPurple,
                        child: Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  if (_isLoading) spinKit,
                  if (_isLoading) SizedBox(height: 20),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

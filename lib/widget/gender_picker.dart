import 'package:flutter/material.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';

class GenderPicker extends StatefulWidget {
  Function _onChangeGender;
  String _currentGender;
  GenderPicker(this._onChangeGender, this._currentGender);

  @override
  _GenderPickerState createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  Gender _value;

  @override
  Widget build(BuildContext context) {
    print(widget._currentGender);
    if (widget._currentGender == 'male') {
      _value = Gender.Male;
    }
    if (widget._currentGender == 'female') {
      _value = Gender.Female;
    }
    if (widget._currentGender == 'others') {
      _value = Gender.Others;
    }
    return GenderPickerWithImage(
      showOtherGender: true,
      verticalAlignedText: false,
      selectedGender: _value,
      selectedGenderTextStyle:
          TextStyle(color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
      unSelectedGenderTextStyle:
          TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
      onChanged: (Gender gender) {
        widget._onChangeGender(gender.toString());
      },
      equallyAligned: true,
      animationDuration: Duration(milliseconds: 300),
      isCircular: true,
      // default : true,
      opacityOfGradient: 0.4,
      padding: const EdgeInsets.all(3),
      size: 70, //default : 40
    );
  }
}

import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File> pick(String option) async {
  PickedFile _pickedFile;
  final _picker = ImagePicker();
  if (option == 'Camera') {
    _pickedFile = await _picker.getImage(source: ImageSource.camera);
  }
  if (option == 'Gallery') {
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);
  }
  if (_pickedFile == null) {
    return null;
  }
  return File(_pickedFile.path);
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screen/add_screen.dart';
import 'package:image_picker/image_picker.dart';

//ומצלמת את התמונה  Function פעולה שמקבלת
class PickPicture extends StatefulWidget {
  const PickPicture({Key key, @required this.onPickedImage}) : super(key: key);
  final void Function(File image) onPickedImage;

  @override
  State<PickPicture> createState() => _PickPictureState();
}

class _PickPictureState extends State<PickPicture> {
  File _imagepicker;
  // פעולה שלא מקבלת משתנים
//טענת יציאה : פעולה שמטרתה לצלם
  void _pickedimagecamera() async {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedimage == null) {
      return null;
    }
    setState(() {
      _imagepicker = File(pickedimage.path);
    });
    widget.onPickedImage(_imagepicker);
  }
  // פעולה שלא מקבלת משתנים
//טענת יציאה : פעולה שמטרתה לקבל תמונה מהגלרייה

  void _pickedimagegallery() async {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimage == null) {
      return null;
    }
    setState(() {
      _imagepicker = File(pickedimage.path);
    });
    widget.onPickedImage(_imagepicker);
  }

  //BuildContext טענת כניסה : פעולה שמקבלת
  // טענת יציאה : פעולה שבונה את הכפתור של המצלמה
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
            radius: 40,
            foregroundImage:
                _imagepicker != null ? FileImage(_imagepicker) : null),
        TextButton.icon(
            onPressed: (() {
              _pickedimagecamera();
            }),
            icon: Icon(Icons.camera),
            label: Text('to take pictures')),
        TextButton.icon(
            onPressed: (() {
              _pickedimagegallery();
            }),
            icon: Icon(Icons.browse_gallery),
            label: Text('add image from the gallery'))
      ],
    );
  }
}

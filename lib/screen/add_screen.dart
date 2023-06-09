import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/models/product.dart';
import 'package:flutter_complete_guide/screen/tab_bottom_admin.dart';
import 'package:flutter_complete_guide/widget/picture_photo.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../providers/product_provider.dart';

// רשימת הקטגוריות של הוצרים
const List<String> categories = [
  '',
  'computers and phones',
  'electric products',
  'tv',
  'perfume',
  'gaming',
  'for house',
  'for kitchen',
  'tea and coffiee',
  'babies',
  'toys',
  'camping',
  'bicycle'
];

// טענת כניסה:לא מקבלת משתנים
//_NewProductState טענת יציאה : מזמן את המחלקה של
class NewProduct extends StatefulWidget {
  const NewProduct({Key key}) : super(key: key);

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  // טענת כניסה:לא מקבלת משתנים
// טענת יציאה : הפעולה מטרתה להוסיף מוצרים  ובמידה ואחד השדות ריקים להוציא הודעת שגיאה
  Future<void> _trySubmit(BuildContext context) async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (kind == '') {
      final snackBar = SnackBar(
        content: const Text('you do not have a kind'),
        action: SnackBarAction(
          label: 'enter please a kind ',
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    if (isValid && kind != '') {
      if (_selectedimage == null) {
        final snackBar = SnackBar(
          content: const Text('you do not have a picture'),
          action: SnackBarAction(
            label: 'enter please a picture ',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      _formKey.currentState.save();
      final storage = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      final uploadTask = storage.putFile(_selectedimage);
      final TaskSnapshot snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();

      String str = await Provider.of<ProductsProvider>(context, listen: false)
          .addProductsData(
              _name.trim(),
              _price.trim(),
              DateTime.now(),
              kind.trim(),
              _picture.trim(),
              _description.trim(),
              url.trim(),
              context);
      print(str);
      if (str == null) {
        setState(() {
          _isloading = false;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error message'),
              content: Text('you got an erorr so it does not add product'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  bool isloading = false;

  var _description = '';
  var _picture = '';
  var _name = '';
  var _place = '';
  var _price = '';
  var _phone = '';
  File _selectedimage;
  //String nameField, Function checkValid, String valueKey,Function changevalue טענת כניסה : פעולה שמקבלת
//טענת יציאה: פעולה מחזירה שורה בה ניתן להקליד את הערכים של המוצר
  Widget textfield(String nameField, Function checkValid, String valueKey,
      Function changevalue) {
    ValueKey<String> key = new ValueKey(valueKey);
    return TextFormField(
      key: key,
      validator: checkValid,
      decoration: InputDecoration(
        labelText: nameField,
      ),
      onSaved: changevalue,
    );
  }

// Stringטענת כניסה :  פעולה שמקבלת קטע של
// אם כן  true אם לא  ו   false טענת יציאה: פעולה שבודקת שהאיברים שמרכיבים אותו מספריים ומחזירה
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  String kind = categories.first;

  @override
  //טענת כניסה : BuildContext פעולה שממקבל
  //טענת יציאה: פעולה שיוצרת את מסך הוספת המוצר בו רושמים את הפרטים שלו מתמונות לקטגוריות ממחירים שם ממוצר ותיאור
  Widget build(BuildContext context) {
    return _isloading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blue,
                title: Text(
                  'add product',
                  style: TextStyle(color: Colors.black),
                )),
            body: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          PickPicture(
                            onPickedImage: (image) {
                              _selectedimage = image;
                            },
                          ),
                          textfield(
                            'nameField',
                            (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid name.';
                              }
                              return null;
                            },
                            'name',
                            (value) {
                              _name = value;
                            },
                          ),
                          textfield(
                            'descriptionField',
                            (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid name.';
                              }
                              return null;
                            },
                            'description',
                            (value) {
                              _description = value;
                            },
                          ),
                          textfield(
                            'priceField',
                            (value) {
                              if (value.isEmpty ||
                                  !isNumeric(value.toString())) {
                                return 'Please enter a valid price.';
                              }
                              if (double.parse(value.toString()) < 0) {
                                return 'please enter a valid price';
                              }
                              return null;
                            },
                            'price',
                            (value) {
                              _price = value;
                            },
                          ),
                          DropdownButton<String>(
                            value: kind,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String value) {
                              // This is called when the user selects an item.
                              setState(() {
                                kind = value;
                              });
                            },
                            items: categories
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isloading = true;
                              });
                              _trySubmit(context);
                            },
                            child: Text('add advertisement'),
                          )
                        ]))));
  }
}
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/models/product.dart';
import 'package:flutter_complete_guide/screen/tab_bottom_admin.dart';
import 'package:flutter_complete_guide/widget/picture_photo.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../providers/product_provider.dart';

// רשימת הקטגוריות של הוצרים
const List<String> categories = [
  '',
  'computers and phones',
  'electric products',
  'tv',
  'perfume',
  'gaming',
  'for house',
  'for kitchen',
  'tea and coffiee',
  'babies',
  'toys',
  'camping',
  'bicycle'
];

// טענת כניסה:לא מקבלת משתנים
//_NewProductState טענת יציאה : מזמן את המחלקה של
class NewProduct extends StatefulWidget {
  const NewProduct({Key key}) : super(key: key);

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  // טענת כניסה:לא מקבלת משתנים
// טענת יציאה : הפעולה מטרתה להוסיף מוצרים  ובמידה ואחד השדות ריקים להוציא הודעת שגיאה
  Future<void> _trySubmit(BuildContext context) async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (kind == '') {
      final snackBar = SnackBar(
        content: const Text('you do not have a kind'),
        action: SnackBarAction(
          label: 'enter please a kind ',
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    if (isValid && kind != '') {
      if (_selectedimage == null) {
        final snackBar = SnackBar(
          content: const Text('you do not have a picture'),
          action: SnackBarAction(
            label: 'enter please a picture ',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      _formKey.currentState.save();
      final storage = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      final uploadTask = storage.putFile(_selectedimage);
      final TaskSnapshot snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();

      String str = await Provider.of<ProductsProvider>(context, listen: false)
          .addProductsData(
              _name.trim(),
              _price.trim(),
              DateTime.now(),
              kind.trim(),
              _picture.trim(),
              _description.trim(),
              url.trim(),
              context);
      print(str);
      if (str == null) {
        setState(() {
          _isloading = false;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error message'),
              content: Text('you got an erorr so it does not add product'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  bool isloading = false;

  var _description = '';
  var _picture = '';
  var _name = '';
  var _place = '';
  var _price = '';
  var _phone = '';
  File _selectedimage;
  //String nameField, Function checkValid, String valueKey,Function changevalue טענת כניסה : פעולה שמקבלת
//טענת יציאה: פעולה מחזירה שורה בה ניתן להקליד את הערכים של המוצר
  Widget textfield(String nameField, Function checkValid, String valueKey,
      Function changevalue) {
    ValueKey<String> key = new ValueKey(valueKey);
    return TextFormField(
      key: key,
      validator: checkValid,
      decoration: InputDecoration(
        labelText: nameField,
      ),
      onSaved: changevalue,
    );
  }

// Stringטענת כניסה :  פעולה שמקבלת קטע של
// אם כן  true אם לא  ו   false טענת יציאה: פעולה שבודקת שהאיברים שמרכיבים אותו מספריים ומחזירה
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  String kind = categories.first;

  @override
  //טענת כניסה : BuildContext פעולה שממקבל
  //טענת יציאה: פעולה שיוצרת את מסך הוספת המוצר בו רושמים את הפרטים שלו מתמונות לקטגוריות ממחירים שם ממוצר ותיאור
  Widget build(BuildContext context) {
    return _isloading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blue,
                title: Text(
                  'add product',
                  style: TextStyle(color: Colors.black),
                )),
            body: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          PickPicture(
                            onPickedImage: (image) {
                              _selectedimage = image;
                            },
                          ),
                          textfield(
                            'nameField',
                            (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid name.';
                              }
                              return null;
                            },
                            'name',
                            (value) {
                              _name = value;
                            },
                          ),
                          textfield(
                            'descriptionField',
                            (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid name.';
                              }
                              return null;
                            },
                            'description',
                            (value) {
                              _description = value;
                            },
                          ),
                          textfield(
                            'priceField',
                            (value) {
                              if (value.isEmpty ||
                                  !isNumeric(value.toString())) {
                                return 'Please enter a valid price.';
                              }
                              if (double.parse(value.toString()) < 0) {
                                return 'please enter a valid price';
                              }
                              return null;
                            },
                            'price',
                            (value) {
                              _price = value;
                            },
                          ),
                          DropdownButton<String>(
                            value: kind,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String value) {
                              // This is called when the user selects an item.
                              setState(() {
                                kind = value;
                              });
                            },
                            items: categories
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isloading = true;
                              });
                              _trySubmit(context);
                            },
                            child: Text('add advertisement'),
                          )
                        ]))));
  }
}

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/models/product.dart';
import 'package:flutter_complete_guide/screen/tab_bottom_admin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

const List<String> lst = [
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

class UpdateProduct extends StatefulWidget {
  final Product updatedproduct;
  UpdateProduct( this.updatedproduct);

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final _formKey = GlobalKey<FormState>();
  //String id טענת כניסה : פעולה שמקבלת
//טענת יציאה :  פעולה שמטרתה לעדכן את פרטי המוצר  לפי הערכים שהקלדנו
  bool _isloading = false;
  Future<void> _trySubmitAllDetails(
      String id, BuildContext context, Product product) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      // ignore: unnecessary_null_comparison
      if (_imagepicker == null) {
        final snackBar = SnackBar(
          content: const Text('You do not have a picture'),
          action: SnackBarAction(
            label: 'Enter please a picture',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      final storage = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      final uploadTask = storage.putFile(_imagepicker);
      final TaskSnapshot snapshot = await uploadTask;

      if (kind == '') {
        final snackBar = SnackBar(
          content: const Text('You do not have a type'),
          action: SnackBarAction(
            label: 'Enter please a type',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      final url = await snapshot.ref.getDownloadURL();

      String str = await Provider.of<ProductsProvider>(context, listen: false)
          .updateallTheDetails(
        id,
      );
      if (str == '') {
        String str1 =
            await Provider.of<ProductsProvider>(context, listen: false)
                .addProductsData(_name.trim(), _price.trim(), DateTime.now(),
                    kind.trim(), '', _description.trim(), url.trim(), context);
        // ignore: unnecessary_null_comparison
        if (str1 == null) {
          setState(() {
            product.updateProduct();
          });
          setState(() {
            _isloading = false;
          });
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return TabBottomAdmin('admin');
          }));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error message'),
                content: Text(str1.toString()),
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error message'),
              content: Text(str.toString()),
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

// Stringטענת כניסה :  פעולה שמקבלת קטע של
// אם כן  true אם לא  ו   false טענת יציאה: פעולה שבודקת שהאיברים שמרכיבים אותו מספריים ומחזירה
  bool isNumeric(String s) {
    // ignore: unnecessary_null_comparison
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  late File _imagepicker;
  // פעולה שלא מקבלת משתנים
//טענת יציאה : פעולה שמטרתה להביא תמונה מהלרייה
  void _pickedImageCamera() async {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedimage == null) {
      return null;
    }
    setState(() {
      _imagepicker = File(pickedimage.path);
    });
  }

  void _pickedImageGallery() async {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimage == null) {
      return null;
    }
    setState(() {
      _imagepicker = File(pickedimage.path);
    });
  }

  //String nameField, Function checkValid, String valueKey,Function changevalue טענת כניסה : פעולה שמקבלת
//טענת יציאה: פעולה מחזירה שורה בה ניתן להקליד את הערכים של המוצר
Widget textfield(String nameField, String? Function(String?)? checkValid, String valueKey, void Function(String?)? changevalue) {
  ValueKey<String> key = ValueKey<String>(valueKey);
  return TextFormField(
    key: key,
    validator: checkValid,
    decoration: InputDecoration(
      labelText: nameField,
    ),
    onSaved: changevalue,
  );
}
  var _price = '';
  var _description = '';
  var _name = '';
  String kind = lst.first;
  int isAppear = 0;

  //BuildContext טענת כניסה:פעולה שמקבלת
//טענת יציאה: פעולה שמטרתה לבנות מסך שמעדכן מוצרים
  Widget build(BuildContext context) {
    print('yhty');
    return Scaffold(
      appBar: AppBar(title: Text('update client details')),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                          child: MouseRegion(
                        onHover: (event) {
                          setState(() {
                            isAppear = 1;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            isAppear = 0;
                          });
                        },
                        onEnter: (event) {
                          setState(() {
                            isAppear = 1;
                          });
                        },
                        child: CircleAvatar(
                            backgroundColor:
                                isAppear == 1 ? Colors.black : null,
                            child: isAppear == 1
                                ? IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('choose option'),
                                              content: Text(
                                                  'take picture from the gallery or take a photo with the camera'),
                                              actions: <Widget>[
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: Icon(
                                                        Icons.exit_to_app)),
                                                ElevatedButton(
                                                  child: Text('gallery'),
                                                  onPressed: () {
                                                    _pickedImageGallery();

                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ElevatedButton(
                                                  child: Text('camera '),
                                                  onPressed: () {
                                                    _pickedImageCamera();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.add),
                                  )
                                : Container(),
                            // ignore: unnecessary_null_comparison
                            backgroundImage: _imagepicker == null
                                ? NetworkImage(widget.updatedproduct.picture)
                                : null,
                            radius: 40,
                            // ignore: unnecessary_null_comparison
                            foregroundImage: _imagepicker != null
                                ? FileImage(_imagepicker)
                                : null),
                      )),
                      Container(
                        child: Text(
                            'press on the circle in order to change your photo '),
                      ),
                      textfield(
                        'priveous : ' + widget.updatedproduct.name,
                        (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid name.';
                          }
                          return null;
                        },
                        'name',
                        (value) {
                          setState(() {
                            _name = value!;
                          });
                        },
                      ),
                      textfield(
                        'priveous : ' + widget.updatedproduct.description,
                        (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid description.';
                          }
                          return null;
                        },
                        'description',
                        (value) {
                          setState(() {
                            _description = value!;
                          });
                        },
                      ),
                      textfield(
                        'priveous : ' + widget.updatedproduct.price.toString(),
                        (value) {
                          if (!isNumeric(value.toString()) && value!.isEmpty) {
                            return 'Please enter a valid price.';
                          }
                          if (double.parse(value.toString()) < 0) {
                            return 'please enter a valid price';
                          }
                          return null;
                        },
                        'price',
                        (value) {
                          setState(() {
                            _price = value!;
                          });
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
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            kind = value?? '';
                          });
                        },
                        items:
                            lst.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      ElevatedButton(
                          onPressed: (() {
                            setState(() {
                              _isloading = true;
                            });
                            _trySubmitAllDetails(widget.updatedproduct.id,
                                context, widget.updatedproduct);
                          }),
                          child: Text('update details')),
                    ],
                  ))),
    );
  }
}

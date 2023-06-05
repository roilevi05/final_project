import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/models/auth.dart';
import 'package:flutter_complete_guide/models/product.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widget/picture_photo.dart';

class UpdateClient extends StatefulWidget {
  const UpdateClient({Key key}) : super(key: key);

  Product get updatedproduct => null;

  @override
  State<UpdateClient> createState() => _UpdateClientState();
}

class _UpdateClientState extends State<UpdateClient> {
  final _formKey = GlobalKey<FormState>();
  //String uid טענת כניסה : פעולה שמקבלת
//טענת יציאה :  פעולה שמטרתה לעדכן את פרטי המשתמש לפי הערכים שהקלדנו
  Future<void> _trySubmitUserName(String uid) async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      Provider.of<AuthProvdier>(context, listen: false)
          .updateUserName(uid, _username.trim());
    }
  }
  //String uid טענת כניסה : פעולה שמקבלת
//טענת יציאה :  פעולה שמטרתה לעדכן את פרטי המשתמש לפי הערכים שהקלדנו

  Future<void> _trySubmitPhone(String uid) async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      Provider.of<AuthProvdier>(context, listen: false)
          .updatePhone(uid, _phone.trim());
    }
  }

  var _username = '';

// Stringטענת כניסה :  פעולה שמקבלת קטע של
// אם כן  true אם לא  ו   false טענת יציאה: פעולה שבודקת שהאיברים שמרכיבים אותו מספריים ומחזירה
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  //String phone טענת כניסה : פעולה שמקבלת
  // אם הוא לא תקיןfalseאם הוא תקין ו true טענת יציאה :פעולה שבודקת שמספר אכן מספר טלפון ומחזירה
  bool checkphone(String p) {
    int sum = 0;
    for (int i = 0; i < p.length; i++) {
      if (!isNumeric(p[i])) {
        sum++;
      }
    }
    if (sum > 0) {
      return true;
    }
    return false;
  }

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

  var _phone = '';

//String id טענת כניסה : פעולה שמקבלת
// טענת יציאה : פעולה שמטרתה לעדכן את התמונה לפי הערכים שהקלדנו

  Future<void> _trySubmitPicture(String id) async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      if (_imagepicker == null) {
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
      final uploadTask = storage.putFile(_imagepicker);
      final TaskSnapshot snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();

      Provider.of<AuthProvdier>(context, listen: false).updatePicture(
        url.trim(),
        id,
      );
    }
  }

  File _imagepicker;
  // פעולה שלא מקבלת משתנים
//טענת יציאה : פעולה שמטרתה לצלם
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

  bool iconapear = false;
  int checkIfIconApear = 0;
  // BuildContext טענת כניסה : פעולה שמקבלת
//טענת יציאה : פעולה שממטרתה לבנות מסך שמעדכן פרטי משתמש
  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<AuthProvdier>(context, listen: false).getuid();
    List<Auth> listOfUser =
        Provider.of<AuthProvdier>(context, listen: false).Auths;
    Auth theClientuser = listOfUser.firstWhere(
      (element) => element.uid == uid,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('update client details'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                          child: MouseRegion(
                        onHover: (event) {
                          setState(() {
                            checkIfIconApear = 1;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            checkIfIconApear = 0;
                          });
                        },
                        onEnter: (event) {
                          setState(() {
                            checkIfIconApear = 1;
                          });
                        },
                        child: CircleAvatar(
                            backgroundColor:
                                checkIfIconApear == 1 ? Colors.black : null,
                            child: checkIfIconApear == 1
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
                            backgroundImage: _imagepicker == null
                                ? NetworkImage(theClientuser.url)
                                : null,
                            radius: 40,
                            foregroundImage: _imagepicker != null
                                ? FileImage(_imagepicker)
                                : null),
                      )),
                      ElevatedButton(
                        child: Text(
                            'press on the circle in order to change your photo '),
                        onPressed: () {
                          _trySubmitPicture(theClientuser.uid);
                        },
                      )
                    ],
                  ),
                  Container(
                    child: ExpansionTile(
                      title: Text('your username is ' + theClientuser.userName),
                      leading: Text(
                        'if you want to change press on me ',
                        style: TextStyle(fontSize: 12),
                      ),
                      children: <Widget>[
                        textfield(
                          'priveous : ' + theClientuser.userName,
                          (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid name.';
                            }
                            return null;
                          },
                          'username',
                          (value) {
                            setState(() {
                              _username = value;
                            });
                          },
                        ),
                        ElevatedButton(
                            onPressed: (() {
                              _trySubmitUserName(uid);
                            }),
                            child: Text('update details')),
                      ],
                    ),
                  ),
                  Container(
                    child: ExpansionTile(
                      title: Text('your phone is ' + theClientuser.phone),
                      leading: Text(
                        'if you want to change press on me ',
                        style: TextStyle(fontSize: 12),
                      ),
                      children: <Widget>[
                        textfield(
                          'priveous : ' + theClientuser.phone,
                          (value) {
                            if (checkphone(value.toString()) ||
                                value.length != 10) {
                              return 'Please enter a valid phone.';
                            }

                            return null;
                          },
                          'phone',
                          (value) {
                            setState(() {
                              _phone = value;
                            });
                          },
                        ),
                        ElevatedButton(
                            onPressed: (() {
                              _trySubmitPhone(uid);
                            }),
                            child: Text('update details')),
                      ],
                    ),
                  )
                ],
              ))),
    );
  }
}

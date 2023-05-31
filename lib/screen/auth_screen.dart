import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/providers/finalorder_provider.dart';
import 'package:provider/provider.dart';

import '../widget/picture_photo.dart';

class AuthScreen extends StatefulWidget {
  @override
  final bool isLoading = false;

  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //String phone טענת כניסה : פעולה שמקבלת
  // אם הוא לא תקיןfalseאם הוא תקין ו true טענת יציאה :פעולה שבודקת שמספר אכן מספר טלפון ומחזירה
  bool checkphone(String phone) {
    int sum = 0;
    for (int i = 0; i < phone.length; i++) {
      if (!isNumeric(phone[i])) {
        sum++;
      }
    }
    if (sum > 0) {
      return true;
    }
    return false;
  }
// Stringטענת כניסה :  פעולה שמקבלת קטע של
// אם כן  true אם לא  ו   false טענת יציאה: פעולה שבודקת שהאיברים שמרכיבים אותו מספריים ומחזירה

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

//טענת כניסה : הפעולה לא מקבלת משתנים
//של קטע שבו ניתן לכתוב את טלפון של המשתמש Widgetטענת יציאה: פעולה שיוצרת
  Widget phone() {
    return TextFormField(
      key: ValueKey('phone'),
      validator: (value) {
        if (checkphone(value.toString()) || value.length != 10) {
          return 'Please enter a valid phone.';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'phone',
      ),
      onSaved: (value) {
        _phone = value;
      },
    );
  }

  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _phone = '';

  // טענת כניסה:לא מקבלת משתנים
// טענת יציאה : הפעולה מטרתה לאמת את פרטי המשתמש ולחבר אותו לאפליקציה

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!_isLogin) {
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
      final storage = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      final uploadTask = storage.putFile(_selectedimage);
      final TaskSnapshot snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      if (isValid) {
        _formKey.currentState.save();
        Provider.of<AuthProvdier>(context, listen: false).submitAuthForm(
            _userEmail.trim(),
            _userPassword.trim(),
            _userName.trim(),
            _phone.trim(),
            _isLogin,
            context,
            url.trim());
      }
    } else {
      if (isValid) {
        _formKey.currentState.save();
        Provider.of<AuthProvdier>(context, listen: false).submitAuthForm(
            _userEmail.trim(),
            _userPassword.trim(),
            _userName.trim(),
            _phone.trim(),
            _isLogin,
            context,
            '');
      }
    }
  }
  //טענת כניסה :  לא מקבלת משתנים

//של מסך ההתחברות  Widgetטענת יציאה : פעולה שמחזירה
  File _selectedimage;
  Widget authForm() {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin)
                    PickPicture(
                      onPickedImage: (image) {
                        _selectedimage = image as File;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  if (!_isLogin) phone(),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      onPressed: _trySubmit,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.blue),
                      ),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(
                        _isLogin
                            ? 'Create new account'
                            : 'I already have an account',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // BuildContextטענת כניסה : פעולה שמקבלת

// טענת יציאה : פעולה שמציגה את המסך של ההתחברות
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 77, 100, 120),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 80,
              ),
              RotationTransition(
                  turns: new AlwaysStoppedAnimation(-10 / 360),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      height: 220,
                      width: 250,
                      image: NetworkImage(
                          'https://m.media-amazon.com/images/G/01/gc/designs/livepreview/a_generic_white_10_us_noto_email_v2016_us-main._CB627448186_.png'),
                    ),
                  )),
              Container(
                height: 20,
              ),
              authForm(),
            ],
          ),
        ));
  }
}

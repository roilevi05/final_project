import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/models/auth.dart';
import 'package:flutter_complete_guide/screen/add_screen.dart';
import 'package:flutter_complete_guide/screen/tab_bottom_admin.dart';

class AuthProvdier with ChangeNotifier {
  String adminId = 'js5ogWgGeyfiaOnCvs9jYDF2i943';
  String uid;
//של המשתמש שנכנס idעולה שמחזירה את ה
  String getuid() {
    return uid;
  }

  ///_Auths מהווה פעולה שמטרת לשלוף את הנתונים מ

  List<Auth> get Auths {
    return [..._Auths];
  }

//String url, String id טענת כניסה : פעולה שמקבלת
//Firebase טענת יציאה : פעולה שמעדכנת את תמונות המשתמש ב
  Future<String> updatePicture(String url, String id) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({"url": url}).then((result) {
        print("new user true");
      });
      return '';
    } catch (erorr) {
      return erorr.toString();
    }
  }

  var _isLoading = false;
  final _auth = FirebaseAuth.instance;
  List<Auth> _Auths = [];

// טענת כניסה : פעולה שלא ממקבלת משתנים
  //_Auths מהטבלה של המוצרים ולהוסיף אותם ל Firebaseטענת יציאה : פעולה שמטרתה לקלוט נתונים מה

  Future<void> fetch() async {
    try {
      _Auths = [];
      await FirebaseFirestore.instance.collection('users').get().then(
        (QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach(
            (doc) {
              _Auths.add(
                Auth(doc['email'], doc['username'], doc['phone'], doc.id,
                    doc['kind'], doc['url']),
              );
            },
          );
        },
      );
    } catch (erorr) {}
  }

//String uid, String username טענת כניסה : פעולה שמקבלת
//Firebase טענת יציאה פעולה שממעדכנת את שם המשתמש של המשתמש ב
  Future<String> updateUserName(
      String uid, String username, BuildContext context) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'username': username}).then((result) {
        print("new USer true");
      });
      return '';
    } catch (erorr) {
      return erorr.toString();
    }
  }

//String uid, String phone טענת כניסה : פעולה שמקבלת
//Firebase טענת יציאה פעולה שממעדכנת את מספר הטלפון של המשתמש ב
  Future<String> updatePhone(String uid, String phone) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'phone': phone}).then((result) {
        print("new USer true");
      });
      return '';
    } catch (erorr) {
      return erorr.toString();
    }
  }

  var collection = FirebaseFirestore.instance.collection('users');
//String email, String password, String username,tring phone, bool isLogin, BuildContext ctx, String url טענת כניסה : פעולה שמקבלת
  ///של המשתמש ונכנסת למסך הראשי של האפליקציה  id ל  uid טענת ציאה : פעולה שמטרת למאמת את כניסת המשתמש ובנוסף מעדכת את המשתנה

  void submitAuthForm(String email, String password, String username,
      String phone, bool isLogin, BuildContext ctx, String url) async {
    UserCredential authResult;
    try {
      _isLoading = true;

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        var all1 = await collection.get();
        var a1 = all1.docs
            .firstWhere((element) => element['email'] == email)['kind'];
        if (a1 == 'admin') {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (context) => TabBottomAdmin(a1)),
          );
        } else {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (context) => TabBottomAdmin('client')),
          );
        }
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'username': username,
          'email': email,
          'phone': phone,
          'kind': 'client',
          'url': url
        });
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (context) => TabBottomAdmin('client')),
        );
      }
      this.uid = authResult.user.uid;
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      _isLoading = false;
    } catch (err) {
      _isLoading = false;

      final snackBar = SnackBar(
        content: const Text('you have a mistake in your detail'),
        action: SnackBarAction(
          label: 'try again ',
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
      return;

      print(err);
    }
    notifyListeners();
  }
}

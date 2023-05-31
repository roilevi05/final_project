import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String uid;
  String email;
  String userName;
  String phone;
  String kind;
  String url;
  //String email, String userName, String phone, String uid, String kind, String url טענת כניסה : פעולה שמקבלת
  //טענת יציאה : הפעולה יוצרת משתמש  חדש
  Auth(String email, String userName, String phone, String uid, String kind,
      String url) {
    this.email = email;
    this.userName = userName;
    this.phone = phone;
    this.uid = uid;
    this.kind = kind;
    this.url = url;
  }
}

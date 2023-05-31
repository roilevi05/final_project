import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/product.dart';

class finalOrder with ChangeNotifier {
  String orderid;
  String userid;
  Timestamp date;
  String isSold;
  //String userid, Timestamp time, String isSold, String orderid טענת כניסה : פעולה שמקבלת
  //טענת יציאה : הפעולה יוצרת הזמנה  חדשה
  finalOrder(String userid, Timestamp time, String isSold, String orderid) {
    this.isSold = isSold;
    this.userid = userid;
    this.date = date;
    this.orderid = orderid;
  }
  //String state טענת כניסה : הפעולה  מקבלת
  // טענת יציאה :הפעולה משנה את הסטטוס של ההזמנה בהתאם לסטטוס שהתקבל
  void changeState(String state) {
    this.isSold = state;
    notifyListeners();
  }
}

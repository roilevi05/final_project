import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/order.dart';

class Product with ChangeNotifier {
  String picture;
  String id;
  String name;
  double price;
  Timestamp time;
  String cat;
  String description;
  bool delete;
  bool isUpdated;

  //String name, double price, String cat, Timestamp time, String id,String picture, String description, bool delete טענת כניסה : פעולה שמקבלת
  //טענת יציאה : הפעולה יוצרת מוצר חדש
  Product(String name, double price, String cat, Timestamp time, String id,
      String picture, String description, bool delete, bool isUpdated) {
    this.name = name;
    this.price = price;
    this.time = time;
    this.cat = cat;
    this.delete = delete;
    this.isUpdated = isUpdated;

    this.id = id;
    this.picture = picture;
    this.description = description;
  }
  //טענת כניסה : הפעולה לא מקבלת משתנים
  // טענת יציאה : הפעולה משנה את הסטטוס של הוצר לנמחק
  void deleteProduct() {
    this.delete = !delete;
    notifyListeners();
  }

  void updateProduct() {
    this.isUpdated = !isUpdated;
    notifyListeners();
  }
}

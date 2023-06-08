import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/auth.dart';
import 'package:flutter_complete_guide/models/order.dart';
import 'package:flutter_complete_guide/models/order.dart';
import 'package:flutter_complete_guide/models/order.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../models/product.dart';
import '../screen/tab_bottom_admin.dart';

class productInOrderProvider with ChangeNotifier {
  List<order> _allProductInOrders = [];

  ///_allProductInOrders מהווה פעולה שמטרת לשלוף את הנתונים מ
  List<order> get allProductInOrders {
    return [..._allProductInOrders];
  }
// טענת כניסה : פעולה שלא ממקבלת משתנים
  //_allProductInOrders מהטבלה של המוצרים ולהוסיף אותם ל Firebaseטענת יציאה : פעולה שמטרתה לקלוט נתונים מה

  Future<void> fetchAllTheOrders() async {
    try {
      _allProductInOrders = [];
      await FirebaseFirestore.instance.collection('orderproduct').get().then(
        (QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach(
            (doc) {
              _allProductInOrders.add(order(doc['orderid'], doc['productid'],
                  doc['date'], double.parse(doc['amount']), doc.id));
            },
          );
        },
      );
    } catch (erorr) {}
  }

  var collection = FirebaseFirestore.instance.collection('products');

  String a12 = AuthProvdier().getuid();
  //Product product, String uid טענת כניסה :פעולה שמקבלת
// orderproduct בטבלה של  Firebase פעולה שמטרתה להוסיף נתונים ל

  Future<String> addOrder(
      Product product, String uid, BuildContext context) async {
    FirebaseFirestore.instance.collection('orderproduct').add({
      'productid': product.id,
      'date': DateTime.now(),
      'amount': (1).toString(),
      'orderid': uid,
    });
  }

  var collection1 = FirebaseFirestore.instance.collection('orderproduct');

  //order order1 טענת כניסה :פעולה שמקבלת
//Firebaseטענת יציאה: פעולה שמטרתה למחוק את הפריטים בעל התכונות שקיבלנו ב

  Future<String> delete1(order order1, BuildContext context) async {
    try {
      for (order i in _allProductInOrders) {
        if (i == order1) {
          await FirebaseFirestore.instance
              .collection('orderproduct')
              .doc(order1.id)
              .delete();
        }
      }
      return '';
    } catch (erorr) {
      return erorr.toString();
    }
  }
  //order order1 טענת כניסה :פעולה שמקבלת
//Providerטענת יציאה: פעולה שמטרתה למחוק את הפריטים בעל התכונות שקיבלנו ב

  void delete(order order1) async {
    try {
      for (order i in _allProductInOrders) {
        if (i == order1) {
          _allProductInOrders.remove(order1);
          break;
        }
      }
      notifyListeners();
    } catch (erorr) {}
  }
}

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/models/auth.dart';
import 'package:flutter_complete_guide/models/order.dart';
import 'package:flutter_complete_guide/models/order.dart';
import 'package:flutter_complete_guide/models/order.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../models/product.dart';

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

  Future<void> addOrder(Product product, String uid) async {
    try {
      FirebaseFirestore.instance.collection('orderproduct').doc().set({
        'productid': product.id,
        'date': DateTime.now(),
        'amount': (1).toString(),
        'orderid': uid
      }).then((value) => null);
      notifyListeners();
    } catch (erorr) {}
  }

  var collection1 = FirebaseFirestore.instance.collection('orderproduct');

  //order order1 טענת כניסה :פעולה שמקבלת
//Firebaseטענת יציאה: פעולה שמטרתה למחוק את הפריטים בעל התכונות שקיבלנו ב

  Future<void> delete1(order order1) async {
    try {
      for (order i in _allProductInOrders) {
        if (i == order1) {
          await FirebaseFirestore.instance
              .collection('orderproduct')
              .doc(order1.id)
              .delete();
        }
      }
      notifyListeners();
    } catch (erorr) {}
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

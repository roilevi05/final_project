import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/final_order.dart';
import 'package:flutter_complete_guide/models/order.dart';

class FinalOrderProvider with ChangeNotifier {
  List<finalOrder> _allOrders = [];

  ///_allOrders מהווה פעולה שמטרת לשלוף את הנתונים מ

  List<finalOrder> get allOrders {
    return [..._allOrders];
  }

  int gety() {
    return y;
  }
// טענת כניסה : פעולה שלא ממקבלת משתנים
  //_allOrders מהטבלה של המוצרים ולהוסיף אותם ל Firebaseטענת יציאה : פעולה שמטרתה לקלוט נתונים מה

  Future<void> fetchOrders() async {
    _allOrders = [];
    await FirebaseFirestore.instance.collection('order').get().then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            _allOrders.add(
              finalOrder(doc['userid'], doc['time'], doc['issold'], doc.id),
            );
          },
        );
      },
    );
  }

  String uid;
  int y = 0;
  //String userId טענת כניסה :פעולה שמקבלת
// order בטבלה של  Firebase פעולה שמטרתה להוסיף נתונים ל

  Future<void> addOrderData(String userId) {
    FirebaseFirestore.instance.collection('order').add({
      'userid': userId,
      'issold': 'not pay',
      'time': DateTime.now()
    }).then((DocumentReference doc) {
      _allOrders.add(finalOrder(userId, Timestamp.now(), 'not pay', doc.id));
      uid = doc.id;
    });
    notifyListeners();
  }

  var collection = FirebaseFirestore.instance.collection('order');
  String orderId = '';
  // טענת כניסה : הפעולה לא מקבלת שתנים
  //orderId טענת יציאה :פעולה שמחזירה את המשתנה
  String getorderId() {
    return orderId;
  }

//String uid טענת כניסה : פעולה שמקבלת
// Firebaseשל ההזמנה מה idטענת יציאה: פעולה שמטרתה לקבל את ה
  Future<void> returnId(String uid) async {
    {
      var getCollection = await collection.get();
      var getId = getCollection.docs
          .firstWhere((element) =>
              element['userid'] == uid && element['issold'] == 'not pay')
          .id;
      this.orderId = getId.toString();
      notifyListeners();
    }
  }

//String id, String state טענת כניסה : פעולה שמקבלת
//Firebase טענת יציאה : פעולה שמטרתה לבדוק אם צב המוצר ולשנות אותו בהתאם לקלט ב
  Future<void> changeState(String id, String state) async {
    FirebaseFirestore.instance
        .collection('order')
        .doc(id)
        .update({"issold": state}).then((result) {
      print("new USer true");
    }).catchError((onError) {
      print(onError);
    });
  }

//String id, String state טענת כניסה : פעולה שמקבלת
//Provider טענת יציאה : פעולה שמטרתה לבדוק אם צב המוצר ולשנות אותו בהתאם לקלט ב
  void changeStateProvider(String id, String state) {
    for (finalOrder i in _allOrders) {
      if (i.orderid == id) {
        i.changeState(state);
      }
    }
  }
}

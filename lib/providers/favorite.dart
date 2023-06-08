import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/favorite_product.dart';

import '../screen/tab_bottom_admin.dart';

class FavoriteProvider with ChangeNotifier {
  List<FavoriteProduct> _favorite;

  ///_favorite מהווה פעולה שמטרת לשלוף את הנתונים מ

  List<FavoriteProduct> get favorite {
    return [..._favorite];
  }
  //String userid, String productid טענת כניסה :פעולה שמקבלת
// Favorite בטבלה של  Firebase פעולה שמטרתה להוסיף נתונים ל

  Future<String> addFavorite(String userid, String productid) async {
    try {
      await FirebaseFirestore.instance
          .collection('favorite')
          .add({'userid': userid, 'productid': productid}).then(
              ((DocumentReference doc) {
        _favorite.add(FavoriteProduct(userid, productid, doc.id));
      }));
      notifyListeners();
      return '';
    } catch (erorr) {
      return erorr.toString();
    }
  }
  //String productid, String userid טענת כניסה :פעולה שמקבלת
//Firebaseטענת יציאה: פעולה שמטרתה למחוק את הפריטים בעל התכונות שקיבלנו ב

  Future<String> delete(String productid, String userid) async {
    try {
      for (FavoriteProduct i in _favorite) {
        if (productid == i.productId && userid == i.userId) {
          await FirebaseFirestore.instance
              .collection('favorite')
              .doc(i.id)
              .delete();
        }
      }
      return '';
    } catch (erorr) {
      return erorr.toString();
    }
  }
  //String productid, String userid טענת כניסה :פעולה שמקבלת
//Providerטענת יציאה: פעולה שמטרתה למחוק את הפריטים בעל התכונות שקיבלנו ב

  void deleteProvider(String productId, String userId) async {
    for (FavoriteProduct i in _favorite) {
      if (productId == i.productId && userId == i.userId) {
        _favorite.remove(i);
      }
    }
    notifyListeners();
  }

// טענת כניסה : פעולה שלא ממקבלת משתנים
  //_favorite מהטבלה של המוצרים ולהוסיף אותם ל Firebaseטענת יציאה : פעולה שמטרתה לקלוט נתונים מה

  Future<void> fetchFavorite() async {
    try {
      _favorite = [];
      await FirebaseFirestore.instance.collection('favorite').get().then(
        (QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach(
            (doc) {
              _favorite.add(
                FavoriteProduct(doc['userid'], doc['productid'], doc.id),
              );
            },
          );
        },
      );
    } catch (erorr) {}
  }
  //String id טענת כניסה :פעולה שמקבלת
//Firebaseטענת יציאה: פעולה שמטרתה למחוק את הפריטים בעל התכונות שקיבלנו ב

  Future<String> delete1(String id) async {
    try {
      await FirebaseFirestore.instance.collection('favorite').doc(id).delete();
      return '';
    } catch (erorr) {
      return erorr.toString();
    }
  }
  //String id טענת כניסה :פעולה שמקבלת
//Providerטענת יציאה: פעולה שמטרתה למחוק את הפריטים בעל התכונות שקיבלנו ב

  void deleteProvider1(String id) async {
    _favorite.remove(_favorite.firstWhere((element) => element.id == id));
    notifyListeners();
  }
}

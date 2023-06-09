import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/order.dart';
import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

// טענת כניסה : פעולה שלא ממקבלת משתנים
  //_products מהטבלה של המוצרים ולהוסיף אותם ל Firebaseטענת יציאה : פעולה שמטרתה לקלוט נתונים מה
  Future<void> fetchProduct() async {
    _products = [];
    try {
      await FirebaseFirestore.instance.collection('products').get().then(
        (QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach(
            (doc) {
              print(doc['name']);
              print(doc['isUpdate']);

              _products.add(
                Product(
                    doc['name'],
                    double.parse(doc['price']),
                    doc['kind'],
                    doc['time'],
                    doc.id,
                    doc['url'],
                    doc['description'],
                    doc['delete'],
                    doc['isUpdate']),
              );
            },
          );
        },
      );
    } catch (erorr) {
      print(erorr);
    }
  }

  String uid = '';
  //String name,String price, DateTime time,String kind,String picture,String description,String image טענת כניסה :פעולה שמקבלת
// products בטבלה של  Firebase פעולה שמטרתה להוסיף נתונים ל
  Future<String> addProductsData(
      String name,
      String price,
      DateTime time,
      String kind,
      String picture,
      String description,
      String image,
      BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': name,
        'price': price.toString(),
        'time': DateTime.now(),
        'kind': kind,
        'url': image,
        'description': description,
        'delete': false,
        'isUpdate': false,
      }).then((DocumentReference doc) {
        _products.add(Product(name, double.parse(price), kind, Timestamp.now(),
            doc.id, picture, description, false, false));
      });
            notifyListeners();

      return '';
    } catch (erorr) {
      return erorr.toString();
    }
  }

// String id טענת כניסה : פעולה שמקבלת
//Firebaseטענת יציאה : פעולה שמטרתה לעדכן את הסטטוס של המוצר מלא מעודכן למעודכן
  Future<String> updateallTheDetails(String id) async {
    try {
      FirebaseFirestore.instance
          .collection('products')
          .doc(id)
          .update({'isUpdate': true}).then((result) {
        print("new user true");
      }).catchError((onError) {
        print(onError);
      });
      return '';
    } catch (erorr) {
      return erorr.toString();
    }
  }

  var collection = FirebaseFirestore.instance.collection('products');

  //Product product טענת כניסה : פעולה שמקבלת
//Firebaseב trueטענת יציאה : פעולה שמטרתה לשנות את הסטטוס של האם המוצצר נמחק ל
  Future<String> deleteProduct(Product product) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .update({"delete": true});
      print("Product deleted successfully");
      return '';
    } catch (error) {
      return error.toString();
    }
  }

  //Product product טענת כניסה : פעולה שמקבלת
//Providerב trueטענת יציאה : פעולה שמטרתה לשנות את הסטטוס של האם המוצצר נמחק ל
  void DeleteProductProvider(Product product) {
    product.delete = true;
    notifyListeners();
  }

  // טענת כניסה : פעולה שמקבלת
  //טענת יציאה: פעולה שמקבלת את הרשימה הכוללת של המוצרים ורשימה כוללת של הזמנות ומקבלת את הסכום שלהם ומחזירה למשתמש את החיר הכולל של ההזמנה
  double finalprice(List<order> lstorder, List<Product> lstproduct) {
    double sum = 0;
    for (order i in lstorder) {
      sum = i.amount *
              lstproduct
                  .firstWhere((element) => element.id == i.productid)
                  .price +
          sum;
    }
    return sum;
  }
}

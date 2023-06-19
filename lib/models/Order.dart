import 'package:cloud_firestore/cloud_firestore.dart';


class order {
  String id = '';
  String orderid = '';
  String productid = '';
  Timestamp date=Timestamp.now();
  double amount=0;
  //String orderid, String productid, Timestamp date, double amount,String id טענת כניסה : פעולה שמקבלת
  //טענת יציאה : הפעולה יוצרת הזמנה  חדשה
  order(String orderid, String productid, Timestamp date, double amount,
      String id) {
    this.orderid = orderid;
    this.amount = amount;
    this.date = date;
    this.productid = productid;
    this.id = id;
  }
}

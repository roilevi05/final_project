import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class chat with ChangeNotifier {
  Timestamp createAt;
  bool isAdmin;
  String text;
  String url;
  String userId;
  String userName;
  bool isRead;
  String id;
  //Timestamp createAt, String text, String url, String userId,  String userName, bool isRead, String id טענת כניסה : פעולה שמקבלת
  //טענת יציאה : הפעולה יוצרת הודעה  חדשה
  chat(Timestamp createAt, String text, String url, String userId,
      String userName, bool isRead, String id) {
    this.createAt = createAt;
    this.text = text;
    this.url = url;
    this.userId = userId;
    this.userName = userName;
    this.isAdmin = isAdmin;
    this.id = id;
    this.isRead = isRead;
  }
// טענת כניסה : הפעולה לא מקבלת משתנים
// טענת יציאה : הפעולה מעדכנת את סטטוס ההזמנה מלא נקרא לנקרא
  void changeBoolOfIsRead() {
    isRead = !isRead;
    notifyListeners();
  }
}

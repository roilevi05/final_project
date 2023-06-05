import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/chat.dart';
import 'package:flutter_complete_guide/screen/erorrMessage.dart';

import '../screen/tab_bottom_admin.dart';

class chatProvider with ChangeNotifier {
  List<chat> _chats = [];

  ///_chats מהווה פעולה שמטרת לשלוף את הנתונים מ

  List<chat> get chats {
    return [..._chats];
  }
// טענת כניסה : פעולה שלא ממקבלת משתנים
  //_chats מהטבלה של המוצרים ולהוסיף אותם ל Firebaseטענת יציאה : פעולה שמטרתה לקלוט נתונים מה

  Future<void> fetchChat() async {
    try {
      _chats = [];
      await FirebaseFirestore.instance.collection('chat').get().then(
        (QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach(
            (doc) {
              print(
                doc['userId'],
              );
              _chats.add(
                chat(doc['createAt'], doc['text'], doc['url'], doc['userId'],
                    doc['username'], doc['isRead'], doc.id),
              );
            },
          );
        },
      );
    } catch (erorr) {}
  }

//String id טענת כניסה : פעולה שמקבלת
  ///אם לא  false  אם כן ו trueטענת יציאה: פעולה שמטרת לבדוק אם יש הודעה בצאט של המנהל שלא נקראה ולכן מחזירה
  bool checkNewMessage(String id) {
    for (chat i in _chats) {
      if (i.userId == id) {
        if (!(i.isRead)) {
          return true;
        }
      }
    }
    return false;
  }

//String id טענת כניסה : פעולה שמקבלת
//Firebase  טענת יציאה : פעולה שבודקת אם יש הודעה שלא נקראה של המשתמש ומעדכנת את הסטטוס אם נקרא או לא נקרא ל-נקרא ב
  Future<void> updateNewMessage(String id) async {
    try {
      for (chat i in chats) {
        if (!i.isRead && i.userId == id) {
          FirebaseFirestore.instance
              .collection('chat')
              .doc(i.id)
              .update({'isRead': true});
        }
      }
    } catch (erorr) {
    }
  }

//String id טענת כניסה : פעולה שמקבלת
//Provider טענת יציאה : פעולה שבודקת אם יש הודעה שלא נקראה של המשתמש ומעדכנת את הסטטוס אם נקרא או לא נקרא ל-נקרא ב
  void updateNewMessageProvider(String id) {
    for (chat i in chats) {
      if (!i.isRead && i.userId == id) {
        i.changeBoolOfIsRead();
      }
    }
  }
}

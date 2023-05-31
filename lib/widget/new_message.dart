import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../providers/auth_provider.dart';

//ומציגה מסך שבו ניתן להוסיף הודעה בהתאם לזהות של השתמש String userId פעולה שמקבלת
class NewMessage extends StatefulWidget {
  final String userId;
  NewMessage(@required this.userId);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final auth = FirebaseAuth.instance.currentUser.uid;

  final _messageController = TextEditingController();
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

//טענת כניסה : פעולה שלא מקבלת משתנים
//  Firebaseטענת יציאה : פעולה שמטרתה להעלות את ההודעה שנכתבה ל
  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final auth = FirebaseAuth.instance.currentUser.uid;
    List<Auth> listuser =
        Provider.of<AuthProvdier>(context, listen: false).Auths;

    Auth admin = listuser.firstWhere((element) => element.uid == auth);

    if (admin.kind != 'admin') {
      FirebaseFirestore.instance.collection('chat').add({
        'text': enteredMessage,
        'createAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData.data()['username'],
        'url': userData.data()['url'],
        'isAdmin': false,
        'isRead': false
      });
    } else {
      FirebaseFirestore.instance.collection('chat').add({
        'text': enteredMessage,
        'createAt': Timestamp.now(),
        'userId': widget.userId,
        'username': userData.data()['username'],
        'url': userData.data()['url'],
        'isAdmin': true,
        'isRead': true
      });
    }
  }

  //BuildContext טענת כניסה : פעולה שמקבלת
  // טענת יציאה : פעולה שבונה את המקום שבו רושמים את ההודעה
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(children: <Widget>[
        Expanded(
            child: TextField(
          controller: _messageController,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          enableSuggestions: true,
          decoration: const InputDecoration(labelText: 'send a message'),
        )),
        IconButton(onPressed: _submitMessage, icon: Icon(Icons.send))
      ]),
    );
  }
}

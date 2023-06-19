import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/widget/chat_messages_screen_new1.dart';
import 'package:flutter_complete_guide/widget/new_message.dart';

class AllChat extends StatefulWidget {
  final String userId;
  AllChat( this.userId);
  @override
  State<AllChat> createState() => _AllChatState();
}

class _AllChatState extends State<AllChat> {
  late String userid;
  // טענת כניסה:לא מקבלת משתנים
  //useridל AllChat יציאה מטרת הפעולה היא להכניס את הערך שהתקבל ב
  void initState() {
    userid = widget.userId;
    super.initState();
  }

//ויוצרת את הממסך של הצאט  BuildContext ה הפעולה מקבלת
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chat'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: ChatMessages(userid),
        ),
        NewMessage(userid)
      ]),
    );
  }
}

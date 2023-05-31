import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/screen/all_chat.dart';
import 'package:flutter_complete_guide/models/auth.dart';
import 'package:flutter_complete_guide/models/chat.dart';
import 'package:flutter_complete_guide/providers/chat_provider.dart';
import 'package:provider/provider.dart';

import '../providers/product_in_order.dart';
import '../providers/auth_provider.dart';
import '../providers/finalorder_provider.dart';
import '../providers/product_provider.dart';

class AdminChat extends StatefulWidget {
  const AdminChat({Key key}) : super(key: key);

  @override
  State<AdminChat> createState() => _AdminChatState();
}

class _AdminChatState extends State<AdminChat> {
  bool checkIsRead;
  //String uid טענת כניסה :מקבלת
  //checkIsRead טענת יציאה פעולה שבודקת אם יש הודעה שלא נקראה בידי המנהל ומעדכנת את
  void changeBool(String uid) {
    checkIsRead =
        Provider.of<chatProvider>(context, listen: false).checkNewMessage(uid);
  }

//BuildContextטענת כניסה: פעולה שמקבלת
//טענת יציאה : פעולה שמחזירה את הרשימה של הצאטים של המנהל עם הלקוחות
  @override
  Widget build(BuildContext context) {
    List<chat> listChat = Provider.of<chatProvider>(context).chats;
    List<Auth> listuser =
        Provider.of<AuthProvdier>(context, listen: false).Auths;
    listuser.removeWhere(
      (element) => element.kind == 'admin',
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('list of all the chats'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          changeBool(listuser[index].uid);

          return ExpansionTile(
            title: checkIsRead
                ? Text(
                    'you have a new message from : ' + listuser[index].userName)
                : Text(listuser[index].userName),
            children: <Widget>[
              Row(children: <Widget>[
                ElevatedButton(
                  child:
                      Text('enter the chat with :' + listuser[index].userName),
                  onPressed: (() {
                    Provider.of<chatProvider>(context, listen: false)
                        .updateNewMessage(listuser[index].uid);
                    Provider.of<chatProvider>(context, listen: false)
                        .updateNewMessageProvider(listuser[index].uid);
                    setState(() {
                      changeBool(listuser[index].uid);
                    });

                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return AllChat(listuser[index].uid);
                    }));
                  }),
                )
              ])
            ],
          );
        }),
        itemCount: listuser.length,
      ),
    );
  }
}

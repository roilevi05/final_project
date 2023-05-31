import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/providers/product_provider.dart';
import 'package:flutter_complete_guide/screen/add_screen.dart';
import 'package:flutter_complete_guide/screen/auth_screen.dart';
import 'package:flutter_complete_guide/screen/tab_bottom_admin.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../providers/auth_provider.dart';

// טענת כניסה פעולה שלא מקבלת משתנים
//BigDrawer טענת יציאה : מממשת את המחלקה של
class DrawerTabScreen extends StatelessWidget {
  const DrawerTabScreen({Key key}) : super(key: key);

  @override
  void signout() {
    FirebaseAuth.instance.signOut();
  }

// טענת כניסה : פעולה שלא מקבלת משתנים
//עם אפשרות לצאת מהאפליקציה   Drawer טענת יציאה : פעולה שבונה
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Column(children: <Widget>[
        Container(
          color: Colors.blue,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                'choose one of the option',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          height: 250,
        ),
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
            ),
            onPressed: () {
              signout();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
            child: Row(
              children: <Widget>[
                Center(
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                ),
                Container(
                  width: 30,
                ),
                Container(
                    height: 40,
                    width: 160,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'exit from the app',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    )),
              ],
            )),
      ]),
    );
  }
}

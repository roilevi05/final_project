import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product_in_order.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/providers/chat_provider.dart';
import 'package:flutter_complete_guide/providers/favorite.dart';
import 'package:flutter_complete_guide/providers/finalorder_provider.dart';
import 'package:flutter_complete_guide/providers/product_provider.dart';
import 'package:flutter_complete_guide/screen/add_screen.dart';
import 'package:flutter_complete_guide/screen/auth_screen.dart';
import 'package:flutter_complete_guide/screen/tab_bottom_admin.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

// המסך הראשי של האפליקציה
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: AuthProvdier(),
          ),
          ChangeNotifierProvider.value(value: ProductsProvider()),
          ChangeNotifierProvider.value(value: productInOrderProvider()),
          ChangeNotifierProvider.value(value: FinalOrderProvider()),
          ChangeNotifierProvider.value(value: FavoriteProvider()),
          ChangeNotifierProvider.value(value: chatProvider()),
        ],
        child: MaterialApp(
          title: 'FlutterChat',
          theme: ThemeData(
            primarySwatch: Colors.pink,
            backgroundColor: Colors.pink,
            accentColor: Colors.deepPurple,
            accentColorBrightness: Brightness.dark,
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              return AuthScreen();
            },
          ),
        ));
  }
}

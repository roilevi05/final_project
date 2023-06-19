import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/screen/admin_chats.dart';
import 'package:flutter_complete_guide/screen/all_chat.dart';
import 'package:flutter_complete_guide/providers/product_in_order.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/providers/chat_provider.dart';
import 'package:flutter_complete_guide/screen/search_screen.dart';
import 'package:flutter_complete_guide/screen/update_client.dart';
import 'package:flutter_complete_guide/drawers/drawer_tabbaradmin.dart';
import 'package:provider/provider.dart';

import '../providers/favorite.dart';
import '../providers/finalorder_provider.dart';
import '../providers/product_provider.dart';
import 'add_screen.dart';
import 'all_order_screen_admin.dart';
import 'favorite_screen.dart';
import 'final_shop.dart';
import 'option_screen_admin.dart';

// String kind טענת כניסה : הפעולה מקבלת
//_TabBottomAdminState טענת יציאה : מזמן את המחלקה של
class TabBottomAdmin extends StatefulWidget {
  final String kind;
  TabBottomAdmin( this.kind);
  @override
  State<TabBottomAdmin> createState() => _TabBottomAdminState();
}

class _TabBottomAdminState extends State<TabBottomAdmin> {
  bool _isInit = true;
  bool _isLoading = true;
  // טענת כניסה : הפעולה לא קולטת משתנים
//FireBaseטענת יציאה : פעולה שקולטת את הנתונים מה
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchProduct()
          .then((_) {
        Provider.of<FavoriteProvider>(context, listen: false)
            .fetchFavorite()
            .then((value) {
          Provider.of<FinalOrderProvider>(context, listen: false)
              .fetchOrders()
              .then((value) {
            Provider.of<productInOrderProvider>(context, listen: false)
                .fetchAllTheOrders()
                .then((value) {
              Provider.of<AuthProvdier>(context, listen: false)
                  .fetch()
                  .then((value) {
                Provider.of<chatProvider>(context, listen: false)
                    .fetchChat()
                    .then((value) {
                  _isLoading = false;
                  setState(() {
                    _isInit = false;
                  });
                });
              });
            });
          });
        });
      });
    } catch (erorr) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('erorr message'),
            content: Text(
              erorr.toString(),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return TabBottomAdmin(isAdmin);
                  }));
                },
                child: Text('ok'),
              ),
            ],
          );
        },
      );
    }
    super.didChangeDependencies();
  }

  int _selectedIndex = 0;
  String isAdmin = '';

  @override
  // טענת כניסה:לא מקבלת משתנים
  //isAdminל TabBottomAdmin יציאה מטרת הפעולה היא להכניס את הערך שהתקבל ב
  void initState() {
    isAdmin = widget.kind;
    // TODO: implement initState
    super.initState();
  }

  // טענת כניסה:לא מקבלת משתנים
// טענת יציאה : פעולה שמחזירה רשימה של כל מסך בהתאם לסוג המשתמש מנהל או לא ובהתאם לסוג המסך
  Widget getlist() {
    return _selectedIndex == 0 && isAdmin == 'admin'
        ? OptionScreen('admin')
        : _selectedIndex == 1 && isAdmin == 'admin'
            ? NewProduct()
            : _selectedIndex == 2 && isAdmin == 'admin'
                ? SearchScreen('admin', '')
                : _selectedIndex == 3 && isAdmin == 'admin'
                    ? AllOrder('admin')
                    : _selectedIndex == 4 && isAdmin == 'admin'
                        ? AdminChat()
                        : _selectedIndex == 0
                            ? OptionScreen('')
                            : _selectedIndex == 1
                                ? FavoriteScreen()
                                : _selectedIndex == 2
                                    ? SearchScreen('client', '')
                                    : _selectedIndex == 3
                                        ? Cart()
                                        : _selectedIndex == 4
                                            ? AllOrder('client')
                                            : _selectedIndex == 5
                                                ? UpdateClient()
                                                : _selectedIndex == 6
                                                    ? AllChat('')
                                                    : Container();
  }

  //BuildContext טענת כניסה : פעולה שמקבלת
//טענת יציאה :פעולה שמציגה את הממסך הראשי שבו ניתן לעבור בין המסכים הראשיים של האפליקציה
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.kind + ' screen')),
      drawer: DrawerTabScreen(),
      body: _isLoading ? CircularProgressIndicator() : getlist(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        items: isAdmin == 'admin'
            ? const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.shop),
                    label: 'products',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: 'add product',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'search',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'all order',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.send),
                    label: 'chat',
                    backgroundColor: Colors.blue),
              ]
            : const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.shop),
                    label: 'products',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'favorite',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'all order',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.payment),
                    label: 'pay screen',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'all order',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.update),
                    label: 'update details',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.send),
                    label: 'chat',
                    backgroundColor: Colors.blue),
              ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: (int index) {
          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
      ),
    );
  }
}

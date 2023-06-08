import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/final_order.dart';
import 'package:flutter_complete_guide/providers/finalorder_provider.dart';
import 'package:flutter_complete_guide/widget/all_order_widget.dart';
import 'package:flutter_complete_guide/drawers/drawer_admin.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../providers/product_in_order.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import 'final_shop.dart';

//String isAdmin טענת כניסה : הפעולה מקבלת
//_AllOrderState טענת יציאה : מזמן את המחלקה של
class AllOrder extends StatefulWidget {
  final String isAdmin;
  AllOrder(@required this.isAdmin);

  @override
  State<AllOrder> createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  List<finalOrder> listoforders = [];

  String isAdmin;
  // טענת כניסה:לא מקבלת משתנים
  //isAdminל AllOrderטענת יציאה מטרת הפעולה היא להכניס את הערך שהתקבל ב
  void initState() {
    isAdmin = widget.isAdmin;
    // TODO: implement initState
    super.initState();
  }

//List<finalOrder> lst12, String uid טענת כניסה :מקבלת
//לפי אם סופק או שולם ואם מדובר במשתש שהוא לא ממנהל להראות את כל ההזמנות  listoforders טענת יציאה : מעדכנת את הרשימה
  void filterListByIsSold(List<finalOrder> lst12, String uid) {
    listoforders = [];
    if (isAdmin != 'admin') {
      for (finalOrder i in lst12) {
        if ((i.isSold == 'pay' || i.isSold == 'supak') && i.userid == uid) {
          listoforders.add(i);
        }
      }
    } else {
      for (finalOrder i in lst12) {
        if (i.isSold == 'pay' || i.isSold == 'supak') {
          listoforders.add(i);
        }
      }
    }
  }

//String orderid, List<order> lst  פעולה שמקבלת טענת כניסה : א
//שקיבלנו  orderidשלהם שווה ל orderidלזאת שהערכים בה הם כאלו ש list1טענת יציאה: פעולה שמשנה את הרשימה
  List<order> getListFiltered(String orderid, List<order> lst) {
    List<order> list1 = [];
    for (order i in lst) {
      if (i.orderid == orderid) {
        list1.add(i);
      }
    }

    return list1;
  }

  bool _isInit = true;
  bool _isLoading = true;
  //  BuildContext טענת כניסה : פעולה שמקבלת

//טענת יציאה: פעולה שמציגה את ההזמנות של המשתמשים
  @override
  Widget build(BuildContext context) {
    List<Product> lstProduct =
        Provider.of<ProductsProvider>(context, listen: false).products;
    List<order> lstProductInOrder =
        Provider.of<productInOrderProvider>(context, listen: false)
            .allProductInOrders;
    List<finalOrder> lstFinalOrder =
        Provider.of<FinalOrderProvider>(context, listen: false).allOrders;

    String uid = Provider.of<AuthProvdier>(context, listen: false).getuid();
    filterListByIsSold(lstFinalOrder, uid);

    return Scaffold(
        appBar: AppBar(
          title: Text('all orders'),
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: listoforders.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text('order number : ' + index.toString()),
              subtitle: listoforders[index].isSold == 'supack'
                  ? Text(
                      listoforders[index].isSold,
                      style: TextStyle(color: Colors.green),
                    )
                  : Text(
                      listoforders[index].isSold,
                      style: TextStyle(color: Colors.red),
                    ),
              children: <Widget>[
                listoforders[index].isSold == 'pay'
                    ? isAdmin == 'admin'
                        ? ElevatedButton(
                            onPressed: () async {
                              String str =
                                  await Provider.of<FinalOrderProvider>(context,
                                          listen: false)
                                      .changeState(
                                          listoforders[index].orderid, 'supak');
                              if (str == '') {
                                setState(() {
                                  Provider.of<FinalOrderProvider>(context,
                                          listen: false)
                                      .changeStateProvider(
                                          listoforders[index].orderid, 'supak');
                                });
                              } else {
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error message'),
                                      content: Text(str),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Text('give the order'))
                        : Container(
                            child: Text(''),
                          )
                    : Container(),
                Container(
                  height: 10,
                ),
                OrderWidget(getListFiltered(
                    listoforders[index].orderid, lstProductInOrder))
              ],
            );
          },
        ));
  }
}

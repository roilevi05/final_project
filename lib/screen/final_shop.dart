import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/models/final_order.dart';
import 'package:flutter_complete_guide/models/order.dart';
import 'package:flutter_complete_guide/providers/product_in_order.dart';
import 'package:flutter_complete_guide/providers/finalorder_provider.dart';
import 'package:flutter_complete_guide/screen/pay_screen.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<order> list = [];
  //String uid1, List<order> lst11 טענת כניסה : פעולה שממקבלת
  //uid1 זהה לקלט orderidכך שהרשיה תכלול פריטים שה list טענת יציאה :פעולה שמעדכנת את הרשימה
  void toClassify(String uid1, List<order> lst11) {
    list = [];
    for (order i in lst11) {
      if (i.orderid == uid1) {
        list.add(i);
      }
    }
  }

  String orderid = '';
  //String uid, List<finalOrder> finalOrders, List<order> Orders טענת כניסה : פעולה שמקבלת
  //כך שהוא תואם את המשתמש שביצע את ההזמנה  list טענת יציאה :פעולה שמעדכנת את
  void getTheListThatNotPaid(
      String uid, List<finalOrder> finalOrders, List<order> Orders) {
    list == [];
    for (finalOrder i in finalOrders) {
      if (uid == i.userid && i.isSold == 'not pay') {
        orderid = i.orderid;
        toClassify(i.orderid, Orders);
        break;
      }
    }
  }
  // BuildContextטענת כניסה : פעולה שמקבלת
//טענת יציאה :פעולה שבונה את המסך של עגלת התשלום לפני התשלום

  @override
  Widget build(BuildContext context) {
    List<Product> lstProduct =
        Provider.of<ProductsProvider>(context, listen: false).products;
    List<order> lst =
        Provider.of<productInOrderProvider>(context, listen: false)
            .allProductInOrders;
    List<finalOrder> lst2 =
        Provider.of<FinalOrderProvider>(context, listen: false).allOrders;

    String uid = Provider.of<AuthProvdier>(context, listen: false).getuid();
    getTheListThatNotPaid(uid, lst2, lst);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Shopping cart',
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemBuilder: ((context, index) {
            return Row(
              children: <Widget>[
                Image(
                  image: NetworkImage(lstProduct
                      .firstWhere(
                          (element) => element.id == list[index].productid)
                      .picture),
                  height: 175,
                  width: 175,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Text('name'),
                              ),
                              Container(
                                height: 0,
                              ),
                              Container(
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Text(lstProduct
                                    .firstWhere((element) =>
                                        element.id == list[index].productid)
                                    .name),
                              ),
                            ],
                          ),
                          Container(
                            width: 0,
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Text('price'),
                              ),
                              Container(
                                height: 0,
                              ),
                              Container(
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Text(
                                    "${lstProduct.firstWhere((element) => element.id == list[index].productid).price}\$"),
                              ),
                            ],
                          ),
                          Container(
                            width: 0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(5.0),
                          padding: const EdgeInsets.all(5.0),
                          height: 60,
                          width: 130,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Text(lstProduct
                              .firstWhere((element) =>
                                  element.id == list[index].productid)
                              .description),
                        ),
                        Container(
                          width: 15,
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              child: Text('delete product'),
                              width: 50,
                            ),
                            IconButton(
                                onPressed: () async {
                                  String str =
                                      await Provider.of<productInOrderProvider>(
                                              context,
                                              listen: false)
                                          .delete1(list[index], context);
                                  print(str.toString());

                                  if (str == '') {
                                    Provider.of<productInOrderProvider>(context,
                                            listen: false)
                                        .delete(list[index]);
                                    setState(() {
                                      lst = Provider.of<productInOrderProvider>(
                                              context,
                                              listen: false)
                                          .allProductInOrders;
                                      list = [];
                                      getTheListThatNotPaid(uid, lst2, lst);
                                    });
                                  } else {
                                    showDialog(
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
                                icon: Icon(Icons.delete))
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            );
          }),
          itemCount: list.length,
        ),
        floatingActionButton: Row(
          children: <Widget>[
            Card(
              child: Container(
                child: Center(
                  child: Text(
                    '${Provider.of<ProductsProvider>(context, listen: false).finalprice(list, lstProduct)}',
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 44, 38, 38)),
                  ),
                ),
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(5.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                height: 50,
                width: 100,
              ),
            ),
            ElevatedButton(
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: (() {
                  if (Provider.of<ProductsProvider>(context, listen: false)
                          .finalprice(list, lstProduct) >
                      0) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return PayScreen(
                          Provider.of<ProductsProvider>(context, listen: false)
                              .finalprice(list, lstProduct),
                          orderid);
                    }));
                  }
                }),
                child: Text(
                  'pay ',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ))
          ],
        ));
  }
}

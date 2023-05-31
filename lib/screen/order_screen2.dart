import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/final_order.dart';
import 'package:flutter_complete_guide/models/order.dart';
import 'package:flutter_complete_guide/providers/product_in_order.dart';
import 'package:flutter_complete_guide/screen/tab_bottom_admin.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/finalorder_provider.dart';
import '../providers/product_provider.dart';

//Product product טענת כניסה : הפעולה מקבלת
//_OrderScreenState טענת יציאה : מזמן את המחלקה של
class OrderScreen extends StatefulWidget {
  final Product product;
  OrderScreen(@required this.product);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<finalOrder> list = [];

  List<finalOrder> list1 = [];
  //BuildContext context טענת כניסה : פעולה שמקבלת
  //טענת יציאה :פעולה שבונה מסך ובו אנו מוסיפים את המוצר להזמנה
  @override
  Widget build(BuildContext context) {
    List<finalOrder> listOfOrders =
        Provider.of<FinalOrderProvider>(context, listen: false).allOrders;
    String uid = Provider.of<AuthProvdier>(context, listen: false).getuid();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.product.name),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: <Widget>[
            Image(
              image: NetworkImage(widget.product.picture),
              width: double.infinity,
              height: 400,
            ),
            Container(
              child: Text(widget.product.description),
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(1.0),
              width: 200,
              height: 100,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
            ),
            Center(
              child: Center(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(1.0),
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Center(child: Text('${widget.product.price}\$')),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: Text('add order'),
              onPressed: () {
                int sum = 0;
                for (finalOrder i in listOfOrders) {
                  if (i.userid == uid) {
                    sum++;
                    if (i.isSold == 'not pay') {
                      Provider.of<productInOrderProvider>(context,
                              listen: false)
                          .addOrder(widget.product, i.orderid);
                    } else {
                      Provider.of<FinalOrderProvider>(context, listen: false)
                          .addOrderData(uid);
                      Provider.of<FinalOrderProvider>(context, listen: false)
                          .returnId(uid)
                          .then((value) {
                        String orderid = Provider.of<FinalOrderProvider>(
                                context,
                                listen: false)
                            .getorderId();

                        Provider.of<productInOrderProvider>(context,
                                listen: false)
                            .addOrder(widget.product, orderid);
                      });
                    }
                  }
                }

                if (sum == 0) {
                  Provider.of<FinalOrderProvider>(context, listen: false)
                      .addOrderData(uid);

                  Provider.of<FinalOrderProvider>(context, listen: false)
                      .returnId(uid)
                      .then((value) {
                    String orderid =
                        Provider.of<FinalOrderProvider>(context, listen: false)
                            .getorderId();

                    Provider.of<productInOrderProvider>(context, listen: false)
                        .addOrder(widget.product, orderid);
                  });
                }
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return TabBottomAdmin('client');
                }));
              },
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/final_order.dart';
import 'package:flutter_complete_guide/providers/product_in_order.dart';
import 'package:flutter_complete_guide/screen/tab_bottom_admin.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/finalorder_provider.dart';

class OrderScreen extends StatefulWidget {
  final Product product;
  OrderScreen( this.product);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int y = 0;
  String check = '';

  Future<void> showErrorDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error message'),
          content: Text('You encountered an error.'),
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
          Image.network(
            widget.product.picture,
            width: double.infinity,
            height: 400,
          ),
          Container(
            child: Text(widget.product.description),
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(1.0),
            width: 200,
            height: 100,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          ),
          Center(
            child: Row(
              children: <Widget>[
                Expanded(child: SizedBox()),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(1.0),
                  width: 100,
                  height: 50,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Center(child: Text('${widget.product.price}\$')),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(),
            child: Text('Add Order'),
            onPressed: () async {
              if (check == '') {
                int sum = 0;
                for (finalOrder i in listOfOrders) {
                  if (i.userid == uid) {
                    sum++;
                    print('check');
                    print(i.isSold);
                    if (i.isSold == 'not pay') {
                      try {
                        await Provider.of<productInOrderProvider>(context,
                                listen: false)
                            .addOrder(widget.product, i.orderid, context);
                      } catch (error) {
                        setState(() {
                          check = error.toString();
                        });
                        await showErrorDialog();
                        return;
                      }
                      break;
                    } else {
                      try {
                        await Provider.of<FinalOrderProvider>(context,
                                listen: false)
                            .addOrderData(uid)
                            .then((value) async {
                          try {
                            await Provider.of<FinalOrderProvider>(context,
                                    listen: false)
                                .returnId(uid)
                                .then((value) async {
                              String orderid = Provider.of<FinalOrderProvider>(
                                      context,
                                      listen: false)
                                  .getorderId();

                              try {
                                await Provider.of<productInOrderProvider>(
                                        context,
                                        listen: false)
                                    .addOrder(widget.product, orderid, context);
                              } catch (error) {
                                setState(() {
                                  check = error.toString();
                                });
                                await showErrorDialog();
                                return;
                              }
                            });
                          } catch (error) {
                            setState(() {
                              check = error.toString();
                            });
                            await showErrorDialog();
                            return;
                          }
                        });
                      } catch (error) {
                        setState(() {
                          check = error.toString();
                        });
                        await showErrorDialog();
                        return;
                      }
                    }
                  }
                }

                if (sum == 0) {
                  try {
                    await Provider.of<FinalOrderProvider>(context,
                            listen: false)
                        .addOrderData(uid)
                        .then((value) async {
                      try {
                        await Provider.of<FinalOrderProvider>(context,
                                listen: false)
                            .returnId(uid)
                            .then((value) async {
                          String orderid = Provider.of<FinalOrderProvider>(
                                  context,
                                  listen: false)
                              .getorderId();

                          try {
                            await Provider.of<productInOrderProvider>(context,
                                    listen: false)
                                .addOrder(widget.product, orderid, context);
                          } catch (error) {
                            setState(() {
                              check = error.toString();
                            });
                            await showErrorDialog();
                            return;
                          }
                        });
                      } catch (error) {
                        setState(() {
                          check = error.toString();
                        });
                        await showErrorDialog();
                        return;
                      }
                    });
                  } catch (error) {
                    setState(() {
                      check = error.toString();
                    });
                    await showErrorDialog();
                    return;
                  }
                }
              }

              if (check != '') {
                await showErrorDialog();
              } else {
                await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) {
                  return TabBottomAdmin('client');
                }));
              }
            },
          ),
        ],
      ),
    );
  }
}

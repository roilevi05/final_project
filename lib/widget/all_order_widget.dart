import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/order.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';

class OrderWidget extends StatefulWidget {
  final List<order> listOfOrders;
  OrderWidget( this.listOfOrders);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  //BuildContext טענת כניסה : פעולה שמקבלת
  //טענת יציאה: פעולה שמחזירה את הרשימה של המוצרים שנממצאים בהזמנה
  Widget build(BuildContext context) {
    List<Product> lstProduct =
        Provider.of<ProductsProvider>(context, listen: false).products;
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: Text('name'),
                ),
                Container(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: 80,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  margin: const EdgeInsets.all(1.0),
                  padding: const EdgeInsets.all(5.0),
                  child: Text(lstProduct
                      .firstWhere((element) =>
                          element.id == widget.listOfOrders[index].productid)
                      .name),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  child: Text('picture'),
                ),
                Container(
                  height: 10,
                ),
                Image(
                    height: 50,
                    width: 80,
                    image: NetworkImage(lstProduct
                        .firstWhere((element) =>
                            element.id == widget.listOfOrders[index].productid)
                        .picture)),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  child: Text('price'),
                ),
                Container(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: 80,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  margin: const EdgeInsets.all(1.0),
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                      '${lstProduct.firstWhere((element) => element.id == widget.listOfOrders[index].productid).price}'),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  child: Text('amount'),
                ),
                Container(
                  height: 10,
                ),
                Container(
                  height: 50,
                  width: 80,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  margin: const EdgeInsets.all(1.0),
                  padding: const EdgeInsets.all(5.0),
                  child: Text('${widget.listOfOrders[index].amount}'),
                ),
              ],
            ),
          ],
        );
      }),
      itemCount: widget.listOfOrders.length,
    );
  }
}

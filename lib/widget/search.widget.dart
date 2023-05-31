import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../models/favorite_product.dart';
import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/favorite.dart';
import '../providers/product_provider.dart';
import '../screen/order_screen2.dart';

class SearchWidget extends StatefulWidget {
  final List<Product> list;
  SearchWidget(@required this.list);
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  List<Product> listproducts = [];
  //String userid, String productid, List<FavoriteProduct> favorite טענת כניסה : פעולה שמקבלת
//false ואם לא  trueאם נמצא  useridו productidטענת יציאה : פעולה שבודקת אם המוצר ברשימת המוצרים האהובים לפי ה
  bool checklove(
      String userid, String productid, List<FavoriteProduct> favorite) {
    for (FavoriteProduct i in favorite) {
      if (productid == i.productId && userid == i.userId) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    listproducts = widget.list;
    // TODO: implement initState
    super.initState();
  }

  //BuildContext טענת כניסה : פעולה שמקבלת
  // טענת יציאה : פעולה שבונה את הרשימה של המוצרים המסוננים
  @override
  Widget build(BuildContext context) {
    List<Product> listOfProducts =
        Provider.of<ProductsProvider>(context).products;
    List<FavoriteProduct> listOfFavorite =
        Provider.of<FavoriteProvider>(context).favorite;
    return SingleChildScrollView(
        child: ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
            child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text(listproducts[index].name),
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                ),
                Container(
                  child: Text('${listproducts[index].price}'),
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                ),
                checklove(
                        Provider.of<AuthProvdier>(context, listen: false)
                            .getuid(),
                        listproducts[index].id,
                        listOfFavorite)
                    ? IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          String id =
                              Provider.of<AuthProvdier>(context, listen: false)
                                  .getuid();

                          Provider.of<FavoriteProvider>(context, listen: false)
                              .delete(listproducts[index].id, id);
                        })
                    : IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {
                          String id =
                              Provider.of<AuthProvdier>(context, listen: false)
                                  .getuid();
                          Provider.of<FavoriteProvider>(context, listen: false)
                              .addFavorite(id, listproducts[index].id);
                        }),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return OrderScreen(listproducts[index]);
                      }));
                    },
                    icon: Icon(Icons.payment))
              ],
            ),
            Container(
              child: Text(listproducts[index].description),
              height: 200,
              width: 400,
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(5.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
            )
          ],
        ));
      },
      itemCount: listproducts.length,
    ));
  }
}

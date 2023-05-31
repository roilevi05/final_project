import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/models/favorite_product.dart';
import 'package:flutter_complete_guide/models/product.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/providers/favorite.dart';
import 'package:flutter_complete_guide/drawers/drawer_tabbaradmin.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<FavoriteProduct> lstfavorite = [];
  //String uid, List<FavoriteProduct> lst טענת כניסה : פעולה שממקבלת
  //lstfavorite טענת יצציאה פעולה שמעדכנת את הרשימה של המוצרים האהובים של המשתמש המסוים  כלומר את
  void getListOfFavoriteByUserId(String uid, List<FavoriteProduct> lst) {
    lstfavorite = [];
    for (FavoriteProduct i in lst) {
      if (i.userId == uid) {
        lstfavorite.add(i);
      }
    }
  }

  // BuildContextטענת כניסה : פעולה שמקבלת
//טענת יציאה :פעולה שבונה מסך ובו רשימת המוצרים האהובים
  @override
  Widget build(BuildContext context) {
    List<Product> lstproduct =
        Provider.of<ProductsProvider>(context, listen: false).products;
    List<FavoriteProduct> lstfavorite =
        Provider.of<FavoriteProvider>(context, listen: false).favorite;
    String uid = Provider.of<AuthProvdier>(context, listen: false).getuid();
    getListOfFavoriteByUserId(uid, lstfavorite);
    return Scaffold(
      appBar: AppBar(
        title: Text('favorite products'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          return Card(
            child: Row(
              children: <Widget>[
                Image(
                    height: 130,
                    width: 130,
                    image: NetworkImage(lstproduct
                        .firstWhere((element) =>
                            element.id == lstfavorite[index].productId)
                        .picture)),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(5.0),
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Text('name'),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5.0),
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Text('price'),
                        ),
                      ],
                    ),
                    Row(children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Text(lstproduct
                            .firstWhere((element) =>
                                element.id == lstfavorite[index].productId)
                            .name),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Text(
                            '${lstproduct.firstWhere((element) => element.id == lstfavorite[index].productId).price}'),
                      ),
                    ]),
                  ],
                ),
                ElevatedButton.icon(
                    onPressed: (() {
                      Provider.of<FavoriteProvider>(context, listen: false)
                          .delete1(lstfavorite[index].id);
                      Provider.of<FavoriteProvider>(context, listen: false)
                          .deleteProvider1(lstfavorite[index].id);

                      setState(() {
                        lstfavorite = Provider.of<FavoriteProvider>(context,
                                listen: false)
                            .favorite;
                        getListOfFavoriteByUserId(uid, lstfavorite);
                      });
                    }),
                    icon: Icon(Icons.favorite),
                    label: Text('cancel love'))
              ],
            ),
          );
        }),
        itemCount: lstfavorite.length,
      ),
    );
  }
}

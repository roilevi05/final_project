import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/screen/update_product.dart';
import 'package:provider/provider.dart';

import '../models/favorite_product.dart';
import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/favorite.dart';
import '../providers/product_provider.dart';
import 'order_screen2.dart';

class SearchScreen extends StatefulWidget {
  final String isAdmin;
  final String searchlast;

  SearchScreen(@required this.isAdmin, @required this.searchlast);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> listproducts = [];

  var _name = '';
  @override
  // טענת כניסה:לא מקבלת משתנים
  //_nameל SearchScreen יציאה מטרת הפעולה היא להכניס את הערך שהתקבל ב
  void initState() {
    _name = widget.searchlast;
    // TODO: implement initState
    super.initState();
  }

  //List<Product> lst טענת כניסה : פעולה שמקבלת
//כך שהערכים שבתוכה שמם כולל את הקלט  listproductsטענת יציאה : הפעולה מעדכנת את
  Widget name(List<Product> lst) {
    return TextFormField(
      key: ValueKey('name'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a valid name.';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'name',
      ),
      onSaved: (value) {
        _name = value;
      },
      onChanged: (value) {
        setState(() {
          listproducts = [];
          if (value != '') {
            for (Product i in lst) {
              if (i.delete == false &&
                  i.name.contains(value) &&
                  i.isUpdated == false) {
                listproducts.add(i);
              }
            }
          }
        });
      },
    );
  }

  //String userid, String productid, List<FavoriteProduct> favorite טענת כניסה : פעולה שמקבלת
//false ואם לא  trueאם נמצא  useridו productidטענת יציאה : פעולה שבודקת אם המוצר ברשימת המוצרים האהובים לפי ה
  bool checkIsFavorite(
      String userid, String productid, List<FavoriteProduct> favorite) {
    for (FavoriteProduct i in favorite) {
      if (productid == i.productId && userid == i.userId) {
        return true;
      }
    }
    return false;
  }

  final ScrollController _firstController = ScrollController();
  //BuildContext טענת כניסה : פעולה שמקבלת
  // טענת יציאה : פעולה שבונה את המסך של חיפוש המוצרים
  @override
  Widget build(BuildContext context) {
    List<Product> lstProduct = Provider.of<ProductsProvider>(context).products;
    List<FavoriteProduct> lstFavorite =
        Provider.of<FavoriteProvider>(context).favorite;

    return Scaffold(
      appBar: AppBar(
        title: Text('search screen'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Form(child: name(lstProduct)),
        Scrollbar(
          thumbVisibility: true,
          controller: _firstController,
          child: ListView.builder(
            controller: _firstController,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  Container(
                    height: 1,
                    color: Colors.black,
                  ),
                  Row(
                    children: <Widget>[
                      Image(
                        image: NetworkImage(listproducts[index].picture),
                        height: 150,
                        width: 150,
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Text('name'),
                                    margin: const EdgeInsets.all(5.0),
                                    padding: const EdgeInsets.all(5.0),
                                    width: 80,
                                  ),
                                  Container(
                                    child: Text(listproducts[index].name),
                                    margin: const EdgeInsets.all(5.0),
                                    padding: const EdgeInsets.all(5.0),
                                    width: 80,
                                  ),
                                  Container(
                                    width: 60,
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.all(5.0),
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Text('price'),
                                    width: 80,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(5.0),
                                    padding: const EdgeInsets.all(5.0),
                                    width: 80,
                                    child:
                                        Text('${listproducts[index].price}\$'),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(1.0),
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Text(listproducts[index].description),
                                height: 60,
                                width: 140,
                              ),
                              widget.isAdmin == 'admin'
                                  ? Column(
                                      children: <Widget>[
                                        Container(
                                          child: Text('edit'),
                                        ),
                                        IconButton(
                                            onPressed: (() {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) {
                                                return UpdateProduct(
                                                    listproducts[index]);
                                              }));
                                            }),
                                            icon: Icon(Icons.edit))
                                      ],
                                    )
                                  : Container()
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  widget.isAdmin != 'admin'
                      ? Row(
                          children: <Widget>[
                            Container(
                              width: 20,
                            ),
                            Container(
                              width: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text('pay for your product  '),
                                ),
                                widget.isAdmin != 'admin'
                                    ? IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (_) {
                                            return OrderScreen(
                                                listproducts[index]);
                                          }));
                                        },
                                        icon: Icon(Icons.payment))
                                    : Container(),
                              ],
                            ),
                            checkIsFavorite(
                                    Provider.of<AuthProvdier>(context,
                                            listen: false)
                                        .getuid(),
                                    listproducts[index].id,
                                    lstFavorite)
                                ? IconButton(
                                    icon: Icon(Icons.favorite),
                                    onPressed: () {
                                      String id = Provider.of<AuthProvdier>(
                                              context,
                                              listen: false)
                                          .getuid();

                                      Provider.of<FavoriteProvider>(context,
                                              listen: false)
                                          .delete(listproducts[index].id, id);
                                      Provider.of<FavoriteProvider>(context,
                                              listen: false)
                                          .deleteProvider(
                                              listproducts[index].id, id);

                                      setState(() {
                                        lstFavorite =
                                            Provider.of<FavoriteProvider>(
                                                    context,
                                                    listen: false)
                                                .favorite;
                                      });
                                    })
                                : IconButton(
                                    icon: Icon(Icons.favorite_border),
                                    onPressed: () {
                                      String id = Provider.of<AuthProvdier>(
                                              context,
                                              listen: false)
                                          .getuid();
                                      Provider.of<FavoriteProvider>(context,
                                              listen: false)
                                          .addFavorite(
                                              id, listproducts[index].id);
                                    }),
                          ],
                        )
                      : Container()
                ],
              );
            },
            shrinkWrap: true,
            itemCount: listproducts.length,
          ),
        ),
      ])),
    );
  }
}

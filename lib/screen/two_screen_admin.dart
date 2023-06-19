
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/favorite_product.dart';
import 'package:flutter_complete_guide/models/product.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/providers/favorite.dart';
import 'package:flutter_complete_guide/providers/product_provider.dart';

import 'package:flutter_complete_guide/screen/order_screen2.dart';
import 'package:flutter_complete_guide/screen/update_product.dart';
import 'package:flutter_complete_guide/drawers/drawer_admin.dart';
import 'package:provider/provider.dart';

enum sortkinds { high_to_low, low_to_high, abc, nothing }

enum clasifiedkinds { zero_till_one_thousand, above_one_thousand, all_products }

class ProductScreen extends StatefulWidget {
  final String isAdmin;
  final String kind;
  ProductScreen( this.kind, this.isAdmin);
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool islove = false;
  List<Product> listproducts = [];
//List<Product> lst טענת כניסה : פעולה שמקבלת
//לפי הקטגוריה שקיבלנו  listproductsטענת יציאה : פעולה שמטרתה לעדכן את הרשימה
  void toClassify(List<Product> lst) {
    listproducts = [];
    for (Product i in lst) {
      if (i.cat == widget.kind && i.delete == false && i.isUpdate == false) {
        listproducts.add(i);
      }
    }
  }

  Future getShowDialog(String str) {
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

// טענת כניסה פעולה שמקבלת מוצר
//טענת יציאה : פעולה שמחזירה את הכפתור שמאפשר לעבור למסך שמעדכן את המוצר
  Widget getEdit(Product product) {
    return Column(
      children: <Widget>[
        Container(
          child: Text('edit'),
        ),
        IconButton(
            onPressed: (() {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return UpdateProduct(product);
              }));
            }),
            icon: Icon(Icons.edit))
      ],
    );
  }

//טענת כניסה : פעולה שמקבלת טקסט
//Container טענת יציאה : פעולה שמחזירה
  Widget getContainer(String text) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(5.0),
      child: Text(text),
    );
  }

// טענת כניסה:פעולה שלא מקבלת משתנים
// טענת יציאה : הודעת שגיאה
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

  final ScrollController _firstController = ScrollController();
  //String userid, String productid, List<FavoriteProduct> favorite טענת כניסה : פעולה שמקבלת
//false ואם לא  trueאם נמצא  useridו productidטענת יציאה : פעולה שבודקת אם המוצר ברשימת המוצרים האהובים לפי ה
  bool checkIfFavorite(
      String userid, String productid, List<FavoriteProduct> favorite) {
    for (FavoriteProduct i in favorite) {
      if (productid == i.productId && userid == i.userId) {
        return true;
      }
    }
    return false;
  }

  sortkinds _character = sortkinds.nothing;
  //String whichkindofsort, sortkinds sort טענת כניסה : פעולה שמקבלת
//שממטרתו לשנות את הערך של המיון לפי איזה קטגוריה  Widgetטענת יציאה : וממחזירה
Widget sortButton(String whichkindofsort, sortkinds sort) {
  return Row(
    children: <Widget>[
      Radio<sortkinds?>(
        value: sort,
        groupValue: _character,
        onChanged: (sortkinds? value) {  // Accept nullable sortkinds
          setState(() {
            _character = value ?? sort;
            sortBy = whichkindofsort;
          });
        },
      ),
      Container(
        child: Text(whichkindofsort),
      )
    ],
  );
}

  clasifiedkinds _casified = clasifiedkinds.all_products;
  //String whichkindofsort, clasifiedkinds clasified טענת כניסה : פעולה שמקבלת
//שממטרתו לשנות את הערך של הסיווג לפי איזה קטגוריה  Widgetטענת יציאה: פעולה שמחזירה

  Widget clasifiedButton(String whichkindofsort, clasifiedkinds clasified) {
    return Row(
      children: <Widget>[
        Radio<clasifiedkinds>(
          value: clasified,
          groupValue: _casified,
          onChanged: (clasifiedkinds ?value) {
            setState(() {
              value = clasified;
              _casified = value?? clasifiedkinds.all_products;
              clasifiedby = whichkindofsort;
            });
          },
        ),
        Container(
          child: Text(whichkindofsort),
        )
      ],
    );
  }

  String sortBy = '';
  // sortBy='ph2l'

  String clasifiedby = '';

  //BuildContext טענת כניסה : פעולה שמקבלת

//טענת יציאה:ובונה מסך שבו יש רשימה של כל המוצרים כולל האפשרות לסווג לקטגוריות
  Widget build(BuildContext context) {
    List<Product> listOfProduct =
        Provider.of<ProductsProvider>(context).products;

    List<FavoriteProduct> lstFavoriteProduct =
        Provider.of<FavoriteProvider>(context).favorite;

    toClassify(listOfProduct);

    if (sortBy == 'low to high') {
      listproducts.sort((a, b) {
        return a.price.compareTo(b.price);
      });
      listOfProduct.sort((a, b) {
        return a.price.compareTo(b.price);
      });
    }
    if (sortBy == 'high to low') {
      listproducts.sort((a, b) {
        return b.price.compareTo(a.price);
      });
      listOfProduct.sort((a, b) {
        return b.price.compareTo(a.price);
      });
    }

    if (sortBy == 'abc') {
      listproducts.sort((b, a) {
        return b.name.compareTo(a.name);
      });
      listOfProduct.sort((b, a) {
        return b.name.compareTo(a.name);
      });
    }
    List<Product> listForTheFilter = listproducts;

    if (clasifiedby == '0-1000') {
      List<Product> lst1 = listForTheFilter;

      listproducts = [];
      lst1.removeWhere((element) => element.price > 1000);
      listproducts = lst1;
    }

    if (clasifiedby == '>1000') {
      List<Product> lst1 = listForTheFilter;

      listproducts = [];
      lst1.removeWhere(
          (element) => element.price < 1000.0 && element.price > 0.0);
      listproducts = lst1;
    }

    if (clasifiedby == 'all products') {
      List<Product> lst1 = listForTheFilter;

      listproducts = [];
      listproducts = lst1;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.kind),
          backgroundColor: Colors.blue,
          actions: <Widget>[],
        ),
        drawer: widget.isAdmin == 'admin'
            ? BigDrawer(listproducts, context, 'admin')
            : BigDrawer(listproducts, context, 'client'),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 150,
                    child: ExpansionTile(
                      title: Text('sort'),
                      children: <Widget>[
                        sortButton('abc', sortkinds.abc),
                        sortButton('high to low', sortkinds.high_to_low),
                        sortButton('low to high', sortkinds.low_to_high),
                      ],
                    ),
                  ),
                  Container(
                    width: 150,
                    child: ExpansionTile(
                      title: Text('clasified'),
                      children: <Widget>[
                        clasifiedButton(
                            'all products', clasifiedkinds.all_products),
                        clasifiedButton(
                            '>1000', clasifiedkinds.above_one_thousand),
                        clasifiedButton(
                            '0-1000', clasifiedkinds.zero_till_one_thousand),
                      ],
                    ),
                  ),
                ],
              ),
              Scrollbar(
                child: ListView.builder(
                    controller: _firstController,
                    shrinkWrap: true,
                    itemCount: listproducts.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                  child: Container(
                                child: Image(
                                  image:
                                      NetworkImage(listproducts[index].picture),
                                  height: 125,
                                  width: 125,
                                ),
                              )),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      getContainer(listproducts[index].name),
                                      getContainer(
                                          "${listproducts[index].price}\$"),
                                      widget.isAdmin != 'admin'
                                          ? checkIfFavorite(
                                                  Provider.of<AuthProvdier>(
                                                          context,
                                                          listen: false)
                                                      .getuid(),
                                                  listproducts[index].id,
                                                  lstFavoriteProduct)
                                              ? IconButton(
                                                  icon: Icon(Icons.favorite),
                                                  onPressed: () async {
                                                    String id = Provider.of<
                                                                AuthProvdier>(
                                                            context,
                                                            listen: false)
                                                        .getuid();

                                                    Future<
                                                        String> str = Provider
                                                            .of<FavoriteProvider>(
                                                                context,
                                                                listen: false)
                                                        .delete(
                                                            listproducts[index]
                                                                .id,
                                                            id);
                                                    String isdone = await str;
                                                    print(isdone);
                                                    if (isdone == '') {
                                                      setState(() {
                                                        Provider.of<FavoriteProvider>(
                                                                context,
                                                                listen: false)
                                                            .deleteProvider(
                                                                listproducts[
                                                                        index]
                                                                    .id,
                                                                id);
                                                        lstFavoriteProduct =
                                                            Provider.of<FavoriteProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .favorite;
                                                      });
                                                    } else {
                                                      getShowDialog(isdone);
                                                    }
                                                  })
                                              : IconButton(
                                                  icon: Icon(
                                                      Icons.favorite_border),
                                                  onPressed: () async {
                                                    String id = Provider.of<
                                                                AuthProvdier>(
                                                            context,
                                                            listen: false)
                                                        .getuid();

                                                    String str = await Provider
                                                            .of<FavoriteProvider>(
                                                                context,
                                                                listen: false)
                                                        .addFavorite(
                                                            id,
                                                            listproducts[index]
                                                                .id);
                                                    if (str == '') {
                                                      setState(() {
                                                        lstFavoriteProduct =
                                                            Provider.of<FavoriteProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .favorite;
                                                      });
                                                    } else {
                                                      getShowDialog(str);
                                                    }

                                                    setState(() {
                                                      islove = !islove;
                                                    });
                                                  })
                                          : Container(),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      child: Text(
                                        listproducts[index].description,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      margin: const EdgeInsets.all(15.0),
                                      padding: const EdgeInsets.all(5.0),
                                      height: 100,
                                      width: 150,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Align(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 150,
                                          ),
                                          widget.isAdmin != 'admin'
                                              ? Row(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                          'pay for your product'),
                                                    ),
                                                    widget.isAdmin != 'admin'
                                                        ? IconButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(MaterialPageRoute(
                                                                      builder:
                                                                          (_) {
                                                                return OrderScreen(
                                                                    listproducts[
                                                                        index]);
                                                              }));
                                                            },
                                                            icon: Icon(
                                                                Icons.payment))
                                                        : Container(),
                                                  ],
                                                )
                                              : Container(),
                                          widget.isAdmin == 'admin'
                                              ? Column(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text('delete '),
                                                    ),
                                                    IconButton(
                                                        onPressed: () async {
                                                          Future<String>
                                                              isdone =
                                                              Provider.of<ProductsProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .deleteProduct(
                                                            listproducts[index],
                                                          );
                                                          String str =
                                                              await isdone;
                                                          if (str == '') {
                                                            setState(() {
                                                              listproducts[
                                                                      index]
                                                                  .deleteProduct();
                                                            });
                                                          } else {
                                                            getShowDialog(str);
                                                          }
                                                        },
                                                        icon:
                                                            Icon(Icons.delete))
                                                  ],
                                                )
                                              : Container(),
                                          widget.isAdmin == 'admin'
                                              ? getEdit(listproducts[index])
                                              : Container(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ));

                      
                    }),
                thumbVisibility: true,
                controller: _firstController,
              )
            ],
          ),
        ));
  }
}

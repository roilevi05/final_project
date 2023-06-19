// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screen/two_screen_admin.dart';

class OptionScreen extends StatelessWidget {
  final String isAdmin;
  OptionScreen(this.isAdmin);

  int i = 0;
  //BuildContext ctx, String kind טענת כניסה : פעולה שמקבלת
  //טענת יציאה: פעולה שעוברת למסך המוצרים שתואם לאותה הקטגוריה
  void move(BuildContext ctx, String kind) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return ProductScreen(kind, isAdmin);
    }));
  }

// רשימה של כל הקטגוריות של המוצרים
  List<String> category = [
    'computers and phones',
    'electric products',
    'tv',
    'perfume',
    'gaming',
    'for house',
    'for kitchen',
    'tea and coffiee',
    'babies',
    'toys',
    'camping',
    'bicycle'
  ];
  // רשימה של כל התמונות של הקטגוריות של המוצרים

  List<String> categorypicture = [
    'https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/n1yd4pe1io4ozcrugk53.jpg',
    'https://www.bharattesthouse.com/img/Our-services/Testing/Electrical-Appliances.jpg',
    'https://m.media-amazon.com/images/I/91UsHjAPTlL._AC_UF1000,1000_QL80_.jpg',
    'https://ksp.co.il/shop/items/512/50022.jpg',
    'https://distritocambioclimatico.com/wp-content/uploads/2022/06/pexels-lucie-liz-3165335-1.jpg',
    'https://superpharmstorage.blob.core.windows.net/hybris/brands/house_v2/header_mobile.jpg',
    'https://samgal.co.il/wp-content/uploads/2019/10/%D7%A1%D7%9E%D7%92%D7%9C-%D7%9E%D7%98%D7%91%D7%97%D7%99%D7%9D-%D7%99%D7%95%D7%A7%D7%A8%D7%AA%D7%99%D7%99%D7%9D-%D7%9E%D7%A2%D7%95%D7%A6%D7%91%D7%99%D7%9D.jpg',
    'https://m.maariv.co.il/HttpHandlers/ShowImage.ashx?id=343998&w=500&h=380',
    'https://market.marmelada.co.il/images/detailed/5667/WhatsApp_Image_2020-01-14_at_21.38.17.jpeg',
    'https://www.havakuk.com/wp-content/uploads/2021/01/%D7%AA%D7%9E%D7%95%D7%A0%D7%94-%D7%A6%D7%A2%D7%A6%D7%95%D7%A2%D7%99%D7%9D-300x300.jpg',
    'https://www.printop.co.il/files/articles/29_1.jpg',
    'https://www.rosen-meents.co.il/files/catalog/item/source/rainbow_r2md_black1.jpg'
  ];
  //String name, String pictureid, BuildContext ctx טענת כניסה : פעולה שמקבלת
  //של העיגול שבתוכו התמונה ומתחתיו השם של הקטגוריה  Widgetטענת יציאה : פעולה שיוצרת את ה
  Widget circlewithpicture(String name, String pictureid, BuildContext ctx) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: CircleAvatar(
              onBackgroundImageError: (exception, stackTrace) {
                move(ctx, name);
              },
              backgroundImage: NetworkImage(pictureid),
              radius: 35,
            ),
            onTap: () {
              move(ctx, name);
            },
          ),
          Container(
            child: Text(name),
          )
        ],
      ),
    );
  }

  // BuildContextטענת כניסה : פעולה שמקבלת
//טענת יציאה :   פעולה שבונה את המסך שבו נמצאות הקטגוריות לבחירה
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('products'),
          backgroundColor: Colors.blue,
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: 1.5,
              crossAxisSpacing: 48,
              mainAxisSpacing: 10),
          itemBuilder: ((context, index) {
            return circlewithpicture(
                category[index], categorypicture[index], context);
          }),
          itemCount: category.length,
        ));

    
  }
}

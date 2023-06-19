import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/screen/tab_bottom_admin.dart';

// טענת כניסה:לא מקבלת משתנים
//_AfterPayState טענת יציאה : מזמן את המחלקה של
class AfterPay extends StatefulWidget {
  const AfterPay({Key? key}) : super(key: key);

  @override
  State<AfterPay> createState() => _AfterPayState();
}

class _AfterPayState extends State<AfterPay> {
  @override
  //  BuildContext טענת כניסה : פעולה שמקבלת
  //טענת יציאה: פעולה שמחזירה מסך של אישור התשלום

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('you did the order'),
          automaticallyImplyLeading: false,
        ),
        body: Container(
            child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
              ),
              Center(
                child: Container(
                  height: 200,
                  width: 350,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 5)),
                  margin: const EdgeInsets.all(1.0),
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'the bank except the paying',
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 71, 61, 61)),
                  ),
                ),
              ),
              ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return TabBottomAdmin('client');
                    }));
                  },
                  icon: Icon(Icons.arrow_left_outlined),
                  label: Text(
                    'return to the main screen',
                    style: TextStyle(
                        fontSize: 23, color: Color.fromARGB(255, 71, 61, 61)),
                  ))
            ],
          ),
        )));
  }
}

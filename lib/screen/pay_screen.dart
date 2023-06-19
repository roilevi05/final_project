import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/finalorder_provider.dart';
import 'package:flutter_complete_guide/screen/after_pay.dart';
import 'package:provider/provider.dart';

// רשיממת החודשים
const List<String> month = [
  '',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12'
];
// רשימת השנים
const List<String> years = [
  '',
  '2023',
  '2024',
  '2025',
  '2026',
  '2027',
  '2028',
  '2029',
  '2030',
];
//String orderidו double finalprice טענת כניסה : הפעולה מקבלת
//_PayScreenState טענת יציאה : מזמן את המחלקה של

class PayScreen extends StatefulWidget {
  final double finalprice;
  final String orderid;

  PayScreen( this.finalprice,  this.orderid);
  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // טענת כניסה : הפעולה לא מקבלת משתנים
//טענת יציאה :פעולה שבודקת אם השדות שמילאנו אם הם תקינים וממשנה את הסטטוס של ההזמנה מלא שולם לשולם
  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      if (firstmonth == '') {
        final snackBar = SnackBar(
          content: const Text('you do not have a month'),
          action: SnackBarAction(
            label: 'enter please a month ',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      if (firstyear == '') {
        final snackBar = SnackBar(
          content: const Text('you do not have a year'),
          action: SnackBarAction(
            label: 'enter please a year ',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      _formKey.currentState!.save();

      String str = await Provider.of<FinalOrderProvider>(context, listen: false)
          .changeState(widget.orderid, 'pay');
      if (str == '') {
        Provider.of<FinalOrderProvider>(context, listen: false)
            .changeStateProvider(widget.orderid, 'pay');
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return AfterPay();
        }));
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
    }
  }

  String firstmonth = month.first;
  String firstyear = years.first;
  //String nameField, Function checkValid, String valueKey,Function changevalue טענת כניסה : פעולה שמקבלת
//טענת יציאה: פעולה מחזירה שורה בה ניתן להקליד את הערכים של התשלום
Widget textfield(String nameField, String? Function(String?)? checkValid, String valueKey) {
  ValueKey<String> key = ValueKey<String>(valueKey);
  return TextFormField(
    key: key,
    validator: checkValid,
    decoration: InputDecoration(
      labelText: nameField,
    ),
    onSaved: (value) {
      // Add your logic here to handle saving the input value
    },
  );
}


//BuildContext טענת כניסה : פעולה שמקבלת
// טענת יציאה : פעולה שבונה מסך בו ניתן להקליד פרטי אשראי
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('final pay'),
        ),
        body: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.topRight,
                child: Container(
                  child: Text(
                    '${widget.finalprice}\$',
                    style: TextStyle(fontSize: 30),
                  ),
                )),
            Container(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: textfield('credit_number', (var value) {
                      if (value!.isEmpty || value.length != 16) {
                        return 'Please enter a valid credit number.';
                      }
                      return null;
                    }, 'credit'),
                  ),
                  Container(
                    child: textfield('three numbers in the back of the card ',
                        (var value) {
                      if (value!.isEmpty || value.length != 3) {
                        return 'Please enter a valid credit number.';
                      }
                      return null;
                    }, 'three'),
                  ),
                  Row(
                    children: <Widget>[
                      Center(
                        child: Row(children: <Widget>[
                          DropdownButton<String>(
                            value: firstmonth,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
onChanged: (String? value) {
  // This is called when the user selects an item.
  setState(() {
    firstmonth = value ?? '';  // Provide a default value in case value is null
  });
},
                            items: month
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          Container(
                            child: Text('   /  '),
                          ),
                          DropdownButton<String>(
                            value: firstyear,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
onChanged: (String? value) {
  setState(() {
    firstyear = value ?? '';
  });
},

                            items: years
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ]),
                      )
                    ],
                  )
                ],
              ),
            ),
            ElevatedButton(
                onPressed: (() {
                  _trySubmit();
                }),
                child: Text('pay'))
          ],
        ));
  }
}

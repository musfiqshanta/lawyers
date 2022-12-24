// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MyApps extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showProgress = false;
  String email = "", password = "";
  String date_of_birth = "";
  int year = 0;
  int day = 0;
  int month = 0;

  TextEditingController date_controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Date Picker"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  var parts = date_of_birth.split('/');
                  if (parts.length >= 2) {
                    year = int.parse(parts[2].trim());
                    month = int.parse(parts[1].trim());
                    day = int.parse(parts[0].trim());
                  }

                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              AlertDialog(
                                backgroundColor: Colors.white,
                                actions: <Widget>[
                                  Container(
                                    height: 30,
                                    child: MaterialButton(
                                      color: Colors.green,
                                      child: Text(
                                        'Set',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          date_of_birth = date_controller.text;
                                        });

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  Text(date_controller.text),
                                  Text(date_controller.text),
                                  Text(date_controller.text),
                                  Text(date_controller.text),
                                  Text(date_controller.text),
                                  Text(date_controller.text),
                                  Text(date_controller.text),
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      setState(() {
                                        date_controller.text = date_of_birth;
                                      });

                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                                content: Container(
                                  height: 300,
                                  width: 300,
                                  child: SfDateRangePicker(
                                    initialSelectedDate:
                                        DateTime(year, month, day),
                                    onSelectionChanged: _onSelectionChanged,
                                    selectionMode:
                                        DateRangePickerSelectionMode.single,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Column(
                  children: [
                    Text(date_controller.text),
                    TextField(
                      textAlign: TextAlign.center,
                      //  controller: date_controller,
                      enableInteractiveSelection: false,
                      enabled: false,
                      focusNode: FocusNode(),
                      decoration: InputDecoration(
                          hintText: "Date Of Birth",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 5,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(32.0),
                child: MaterialButton(
                  onPressed: () async {},
                  minWidth: 200.0,
                  height: 45.0,
                  child: Text(
                    "Register",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Already Registred? Login Now",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w900),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
      } else if (args.value is DateTime) {
        date_controller.text =
            DateFormat('dd/MM/yyyy').format(args.value).toString();
        ;
      } else if (args.value is List<DateTime>) {
      } else {}
    });
  }
}

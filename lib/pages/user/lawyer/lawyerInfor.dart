import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../provider/button_provider.dart';

class Layersinfo extends StatelessWidget {
  final String? fn, ln, adr, gen, cou, city, zip, signtype, about;

  const Layersinfo({
    Key? key,
    this.fn,
    this.ln,
    this.adr,
    this.gen,
    this.cou,
    this.city,
    this.zip,
    this.signtype,
    this.about,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lawyer Info"),
      ),
      body: LawyerInformations(
        fn: fn!,
        ln: ln!,
        adr: adr!,
        gen: gen!,
        cou: cou!,
        city: city!,
        zip: zip!,
        signtype: signtype!,
        about: about!,
      ),
    );
  }
}

class LawyerInformations extends StatefulWidget {
  final String fn, ln, adr, gen, cou, city, zip, signtype, about;
  const LawyerInformations({
    Key? key,
    required this.fn,
    required this.ln,
    required this.adr,
    required this.gen,
    required this.cou,
    required this.city,
    required this.zip,
    required this.signtype,
    required this.about,
  }) : super(key: key);

  @override
  _LawyerInformationsState createState() => _LawyerInformationsState();
}

class _LawyerInformationsState extends State<LawyerInformations> {
  DateTime selectedDate = DateTime.now();
  String? dateformate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      helpText: "Bar Admission Date",
      useRootNavigator: true,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onSecondary: Colors.blue,
            ),
          ),
          child: child ?? const Text(""),
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        String pickedd = DateFormat("dd/M/yyyy").format(picked);
        debugPrint(pickedd);
        dateformate = pickedd;
        //pickedd = picked;
      });

      debugPrint("Date");

      debugPrint(selectedDate.toString());
    }
  }

  var gen = "Male";
  var cu = "Bangladesh";
  var bs = "Dhaka";
  var ps = "Islamabadh";
  var ins = "Kolkata";
  var at = "Sign Up as a";
  var sc = "School";
  var col = "College";
  var uni = "University";
  var pr = "Practice Area";
  var cou = "Select Your Court";
  // DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var gender = ["Male", "Female", "Other"];
    var country = [
      'Bangladesh',
      "Pakistan",
      "India",
      "China",
      "Greace",
      "Germany"
    ];

    var bd = ["Dhaka", "Chittagon", "khulan"];
    var pk = ["Islamabadh", "Karachi", "Peswoar"];
    var ind = ["Kolkata", "Dilhi", "Mumbai"];
    // var ch = ["Beijing", "Honkong", "Shanhai"];
    //var ger = ["Berline", "Humburg", "Hessen"];
    var accountType = ["Sign Up as a", "Client", "Lawyer"];
    var school = [
      'School',
      'Vicarunneca',
      'Bangla college',
      "titumir",
      "Dhaka College"
    ];
    var college = [
      "College",
      "Bangla College",
      "Dhaka College",
      "Titumir College"
    ];
    var university = [
      "University",
      "Dhaka univesity",
      "Jogonnath University",
      "Jahangir nogor",
      "City Univeristy"
    ];
    var practice = [
      "Practice Area",
      "General Practice",
      "Accident & Injury",
      "Bankruptcy & Debt",
      "Business",
      "Civil & Human Rights",
      "Consumer Rights",
      "Criminal ",
      "Divorce & Family Law ",
      "Employment ",
      "Environmental Law ",
      "Estate ",
      "Government ",
      "Health Care ",
      "Immigration ",
      "Industry Specialties ",
      "Intellectual Property ",
      "International ",
      "Lawsuit & Dispute ",
      "Mass Torts ",
      "Motor Vehicle ",
      "Real Estate ",
      "Tax ",
      "Other "
    ];

    var courts = [
      "Select Your Court",
      "Dhaka Metropolitan Court",
      "Chittagong Metropolitan Court",
      "Rajshahi Metropolitan Court",
      "khulna Metropolitan Court",
      "Barisal Metropolitan Court",
      "Sylhet Metropolitan Court",
      "Mymensingh Metropolitan Court",
      "Rangpur Metropolitan Court",
    ];

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 20.0,
            runAlignment: WrapAlignment.spaceAround,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Data From First page
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                child: TextFormField(
                  initialValue: widget.fn,
                  decoration: const InputDecoration(
                      labelText: "First Name", border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                child: TextFormField(
                  initialValue: widget.ln,
                  decoration: const InputDecoration(
                      labelText: "Last Name", border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                child: TextFormField(
                  initialValue: widget.adr,
                  decoration: const InputDecoration(
                      labelText: "Adress", border: OutlineInputBorder()),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2.2,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(border: InputBorder.none),
                    icon: const Icon(Icons.arrow_downward),
                    style: const TextStyle(color: Colors.black87),
                    onChanged: (String? newValue) {
                      setState(() {
                        gen = newValue!;
                      });
                    },
                    value: widget.gen,
                    items: gender.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(border: InputBorder.none),
                    icon: const Icon(Icons.arrow_downward),
                    style: const TextStyle(color: Colors.black87),
                    onChanged: (String? newValue) {
                      setState(() {
                        cu = newValue!;
                      });
                    },
                    value: widget.cou,
                    items:
                        country.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              cu == "Bangladesh"
                  ? Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: DropdownButtonFormField(
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black87),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (String? newValue) {
                            setState(() {
                              bs = newValue!;
                              //  state.didChange(newValue);
                              //debugPrint(x);
                            });
                          },
                          value: widget.city,
                          items:
                              bd.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  : cu == "Pakistan"
                      ? Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DropdownButtonFormField(
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black87),
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              onChanged: (String? newValue) {
                                setState(() {
                                  ps = newValue!;
                                });
                              },
                              value: widget.city,
                              items: pk.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DropdownButtonFormField(
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 10,
                              style: const TextStyle(color: Colors.black87),
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              onChanged: (String? newValue) {
                                setState(() {
                                  ins = newValue!;
                                  //  state.didChange(newValue);
                                  //debugPrint(x);
                                });
                              },
                              value: widget.city,
                              items: ind.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.5,
                child: TextFormField(
                  initialValue: widget.zip,
                  decoration: const InputDecoration(
                      labelText: "ZipCode", border: OutlineInputBorder()),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonFormField(
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 10,
                    style: const TextStyle(color: Colors.black87),
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (String? newValue) {
                      setState(() {
                        at = newValue!;

                        context.read<Counter>().increment(at);

                        //debugPrint(at);
                      });
                    },
                    value: widget.signtype,
                    items: accountType
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Lawyer Data
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(border: InputBorder.none),
                    icon: const Icon(Icons.arrow_downward),
                    style: const TextStyle(color: Colors.black87),
                    onChanged: (String? newValue) {
                      setState(() {
                        sc = newValue!;
                      });
                    },
                    value: sc,
                    items: school.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(border: InputBorder.none),
                    icon: const Icon(Icons.arrow_downward),
                    style: const TextStyle(color: Colors.black87),
                    onChanged: (String? newValue) {
                      setState(() {
                        col = newValue!;
                      });
                    },
                    value: col,
                    items:
                        college.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(border: InputBorder.none),
                    icon: const Icon(Icons.arrow_downward),
                    style: const TextStyle(color: Colors.black87),
                    onChanged: (String? newValue) {
                      setState(() {
                        uni = newValue!;
                      });
                    },
                    value: uni,
                    items: university
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(border: InputBorder.none),
                    icon: const Icon(Icons.arrow_downward),
                    style: const TextStyle(color: Colors.black87),
                    onChanged: (String? newValue) {
                      setState(() {
                        pr = newValue!;
                      });
                    },
                    value: pr,
                    items:
                        practice.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(border: InputBorder.none),
                    icon: const Icon(Icons.arrow_downward),
                    style: const TextStyle(color: Colors.black87),
                    onChanged: (String? newValue) {
                      setState(() {
                        cou = newValue!;
                      });
                    },
                    value: cou,
                    items: courts.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: dateformate == null
                    ? const Padding(
                        padding: EdgeInsets.symmetric(
                          //horizontal: 14.0,
                          vertical: 20.0,
                        ),
                        child: Text(
                          "Bar Admission Date",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16.0,
                        ),
                        child: Text(
                          dateformate!,
                          style: const TextStyle(fontSize: 22.0),
                        ),
                      ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Price", border: OutlineInputBorder()),
                ),
              ),
              TextFormField(
                initialValue: widget.about,
                minLines: 5,
                maxLines: 20,
                decoration: const InputDecoration(
                    labelText: "About You", border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

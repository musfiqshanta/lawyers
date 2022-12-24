// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../user/lawyer/lawyer_single_info.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _search = TextEditingController();
  final FocusNode _node = FocusNode();
  @override
  void initState() {
    _search.addListener(() {});
    super.initState();
  }

  var x = 0;
  String? query;
  // final Stream<QuerySnapshot> _usersStreams =
  //     FirebaseFirestore.instance.collection('lawyer_data').snapshots();

  // QuerySnapshot<Map<String, dynamic>> x = FirebaseFirestore.instance
  //     .collection('users')
  //     .get() as QuerySnapshot<Map<String, dynamic>>;

  // print(x);
  // Stream<QuerySnapshot> _usersStream;
  dynamic searchKey = '';
  bool filter = false;
  var practice = [
    "All Category",
    "General Practice",
    "Accident & Injury",
    "Bankruptcy & Debt",
    "Business",
    "Civil & Human Rights",
    "Consumer Rights",
    "Criminal",
    "Divorce & Family Law",
    "Employment",
    "Environmental Law",
    "Estate",
    "Government",
    "Health Care",
    "Immigration",
    "Industry Specialties",
    "Intellectual Property",
    "International",
    "Lawsuit & Dispute",
    "Mass Torts",
    "Motor Vehicle",
    "Real Estate",
    "Tax",
    "Other"
  ];
  var courts = [
    "All Court",
    "Dhaka Metropolitan Court",
    "Chittagong Metropolitan Court",
    "Rajshahi Metropolitan Court",
    "khulna Metropolitan Court",
    "Barisal Metropolitan Court",
    "Sylhet Metropolitan Court",
    "Mymensingh Metropolitan Court",
    "Rangpur Metropolitan Court",
  ];

  //FirebaseFirestore streamQuery;
  var pr = "All Category";
  var cou = "All Court";
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('lawyer_data').snapshots();
  @override
  Widget build(BuildContext context) {
    // TextField(),
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        final list = snapshot.data!.docs;

        return Column(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: TextField(
                    onChanged: (value) {
                      //  _search.text.toLowerCase();
                      setState(() {
                        searchKey = value;
                      });
                    },
                    controller: _search,
                    focusNode: _node,
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _search.clear();
                          _node.unfocus();
                        },
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor)),
                    onPressed: () {
                      setState(() {
                        filter = !filter;
                      });
                    },
                    child: Text("Filter"))
              ],
            ),
            Visibility(
                visible: filter,
                maintainAnimation: true,
                maintainState: true,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DropdownButtonFormField(
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            icon: const Icon(Icons.arrow_downward),
                            style: const TextStyle(color: Colors.black87),
                            onChanged: (String? newValue) {
                              setState(() {
                                pr = newValue!;
                              });
                            },
                            value: pr,
                            items: practice
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DropdownButtonFormField(
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            icon: const Icon(Icons.arrow_downward),
                            style: const TextStyle(color: Colors.black87),
                            onChanged: (String? newValue) {
                              setState(() {
                                cou = newValue!;
                              });
                            },
                            value: cou,
                            items: courts
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: 250),
                  children: [
                    ...list
                        .where((QueryDocumentSnapshot element) =>
                            element["First_Name"]
                                .toString()
                                .toLowerCase()
                                .contains(searchKey.toLowerCase()))
                        .where((QueryDocumentSnapshot element) =>
                            element["Practice_category"]
                                .toString()
                                .toLowerCase()
                                .contains(pr == "All Category"
                                    ? ""
                                    : pr.toLowerCase()))
                        .where((QueryDocumentSnapshot element) =>
                            element["Practice_court"]
                                .toString()
                                .toLowerCase()
                                .contains(cou == "All Court"
                                    ? ""
                                    : cou.toLowerCase()))
                        .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      Future<String> downloadURLExample() async {
                        String downloadURL = await firebase_storage
                            .FirebaseStorage.instance
                            .ref('Profile/${data['ID']}')
                            .getDownloadURL();

                        return downloadURL;
                        // print("downloadURL");
                        // print(downloadURL);
                        // return downloadURL;
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SingleLawyerInfo(
                                    getid: data['ID'],
                                  )));
                        },
                        child: SizedBox(
                          height: 500,
                          child: Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  FutureBuilder(
                                    future: downloadURLExample(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            backgroundImage: NetworkImage(
                                                snapshot.data.toString()),
                                          ),
                                        );
                                      }
                                      return const Text("Loading...");
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "${data['First_Name']} ${data['Last_Name']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    data['Practice_category'],
                                    style: const TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text("\$ ${data['Price']} /hr",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xffc0392b),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ]),
            ),
          ],
        );
      },
    );
  }
}

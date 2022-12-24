// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../Chat/chat.dart';

class TabUserData extends StatefulWidget {
  final String? getid;
  const TabUserData({Key? key, this.getid}) : super(key: key);

  @override
  _TabUserDataState createState() => _TabUserDataState();
}

class _TabUserDataState extends State<TabUserData> {


  @override
  Widget build(BuildContext context) {
    //var now = DateTime.now();
    DateTime? now = DateTime.now();
    String time = DateFormat('hh:mm').format(now);
    String today = DateFormat('dd /M /yyyy').format(now);

    const boldtextStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    const semiboldtextStyle =
        TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    final FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference personalInfo =
        FirebaseFirestore.instance.collection('lawyer_data');
    final Stream<QuerySnapshot> appoinmentlist = FirebaseFirestore.instance
        .collection("appoinment/${widget.getid}/book")
        .snapshots();
    final Stream<QuerySnapshot> hire = FirebaseFirestore.instance
        .collection("hire/${widget.getid}/approval")
        .snapshots();
    Future getlocation() async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      String add = "${placemarks[0].locality} , ${placemarks[0].country} ";
      // return placemarks[0].country;
      return add;
    }

    Future<String> downloadURLExample() async {
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('Profile/${widget.getid}')
          .getDownloadURL();

      return downloadURL;
    }


    // DateTime selectedDate = DateTime.now();
    // String? dateformate;
    String pickedd = DateFormat("dd/M/yyyy").format(now);
   

    Future<String?> dialog(BuildContext context) {
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Thanks for your Requset'),
          content: const Text('Your request have been process'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    

    return Scaffold(
      
     
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: personalInfo.doc(widget.getid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            FutureBuilder(
                              future: downloadURLExample(),
                              //future: FirebaseFirestore.instance.collection('users'),
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

                                  // return Text("");
                                }
                                return const Text("Loading...");
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  " ${data['First_Name']} ${data['Last_Name']}",
                                  style: boldtextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                FutureBuilder(
                                    future: getlocation(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return RichText(
                                          text: TextSpan(children: [
                                            const WidgetSpan(
                                              child: Icon(
                                                Icons.location_on,
                                                color: Color(0xFF7f8c8d),
                                              ),
                                            ),
                                            TextSpan(
                                                text:
                                                    " ${snapshot.data.toString()}",
                                                style: const TextStyle(
                                                    color: Color(0xFF7f8c8d)))
                                          ]),
                                        );
                                      } else {
                                        return const Text("Loading...");
                                      }
                                    }),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${time.toString()} local time",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 28, 29, 29)),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return Center(
                    child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ));
              },
            ),
            Container(
              height: 20.0,
              decoration: const BoxDecoration(color: Color(0xFFecf0f1)),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: appoinmentlist,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Review",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          RichText(
                              text: const TextSpan(
                                  style: TextStyle(color: Color(0xffc0392b)),
                                  children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.star,
                                    color: Color(0xffc0392b),
                                  ),
                                ),
                                TextSpan(
                                    text: "4.9 (150)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ]))
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            "Solved Case",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "150",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffc0392b)),
                          )
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            "Bail Case",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "120",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffc0392b)),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Like",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          RichText(
                              text: const TextSpan(
                                  style: TextStyle(color: Color(0xffc0392b)),
                                  children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.favorite,
                                    color: Color(0xFFED4C67),
                                  ),
                                ),
                                TextSpan(
                                    text: "120",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ]))
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              height: 20.0,
              decoration: const BoxDecoration(color: Color(0xFFecf0f1)),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: appoinmentlist,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                final total = snapshot.data!.docs;
                print(" Total lists");
                print(total.length);
                var x = 0;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Clients",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "250",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffc0392b)),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Totall Appoinment",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${total.length}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffc0392b)),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Today Appoinment",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ...total
                              .where((QueryDocumentSnapshot element) =>
                                  element["date"].contains(today))
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            double todaylent = data.length / 2;
                            x++;
                            return Visibility(
                              visible: false,
                              child: Text(""),
                            );
                          }).toList(),
                          Text(
                            x.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffc0392b)),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              height: 20.0,
              decoration: const BoxDecoration(color: Color(0xFFecf0f1)),
            ),
            FutureBuilder<DocumentSnapshot>(
              future: personalInfo.doc(widget.getid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 20.0,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFecf0f1)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Categories",
                                        style: boldtextStyle,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            data["Practice_category"],
                                            style: semiboldtextStyle,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 20.0,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFecf0f1)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Intro",
                                        style: boldtextStyle,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        data["About"],
                                        textAlign: TextAlign.justify,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 20.0,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFecf0f1)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Basic Info",
                                        style: boldtextStyle,
                                      ),
                                      const SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            const WidgetSpan(
                                                child: Icon(Icons.school)),
                                            const TextSpan(
                                                text: '  Bar AdmissionDate : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: data["AdmissionDate"]),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            const WidgetSpan(
                                                child: Icon(Icons.school)),
                                            const TextSpan(
                                                text: '  Practice Court : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: data["Practice_court"]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 20.0,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFecf0f1)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Education",
                                        style: boldtextStyle,
                                      ),
                                      const SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            const WidgetSpan(
                                                child: Icon(Icons.school)),
                                            const TextSpan(
                                                text: '  School : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(text: data["School"]),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            const WidgetSpan(
                                                child: Icon(Icons.school)),
                                            const TextSpan(
                                                text: '  College : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(text: data["College"]),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            const WidgetSpan(
                                                child: Icon(Icons.school)),
                                            const TextSpan(
                                                text: '  University : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(text: data["University"]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 20.0,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFecf0f1)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Contact Info",
                                        style: boldtextStyle,
                                      ),
                                      const SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            const WidgetSpan(
                                                child: Icon(Icons.school)),
                                            const TextSpan(
                                                text: '  Mobile : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(text: data["Phone"]),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            const WidgetSpan(
                                                child: Icon(Icons.school)),
                                            const TextSpan(
                                                text: '  Email : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(text: data["Email"]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 20.0,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFecf0f1)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Places Lived",
                                        style: boldtextStyle,
                                      ),
                                      const SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            const WidgetSpan(
                                                child: Icon(Icons.school)),
                                            const TextSpan(
                                                text: '  BirthPlace : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(text: data["BirthPlace"]),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            const WidgetSpan(
                                                child: Icon(Icons.school)),
                                            const TextSpan(
                                                text: '  Current Place : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(text: data["Adress"]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 25.0,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFecf0f1)),
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return Center(
                    child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

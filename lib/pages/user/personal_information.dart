// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:lawyer/pages/user/add_personal_information.dart';

class PersonalInformations extends StatelessWidget {
  const PersonalInformations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                    shadowColor: MaterialStateProperty.all(Colors.white)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PersonalInformation()));
                },
                child: const Text("Edit"))
          ],
          title: const Text("Profile Info"),
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: const PersonalInfo(),
      ),
    );
  }
}

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({Key? key}) : super(key: key);

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    var now = DateTime.now();
    String today = DateFormat('dd /M /yyyy').format(now);
    String time = DateFormat('hh:mm').format(now);
    const boldtextStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    const semiboldtextStyle =
        TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

    CollectionReference personalInfo =
        FirebaseFirestore.instance.collection('lawyer_data');
    CollectionReference review =
        FirebaseFirestore.instance.collection('review');
    CollectionReference bail = FirebaseFirestore.instance.collection('bail');
    final Stream<DocumentSnapshot<Object?>> ratesolve =
        review.doc(auth.currentUser!.uid).snapshots();
    final Stream<DocumentSnapshot<Object?>> tbail =
        bail.doc(auth.currentUser!.uid).snapshots();

    final Stream<QuerySnapshot> appoinmentlist = FirebaseFirestore.instance
        .collection("appoinment/${auth.currentUser!.uid}/book")
        .snapshots();
    final Stream<QuerySnapshot> hirelist = FirebaseFirestore.instance
        .collection("hire/${auth.currentUser!.uid}/list")
        .where('approval', isEqualTo: true)
        .snapshots();
    // FirebaseAuth auth = FirebaseAuth.instance;
    // debugPrint("user");
    // debugPrint(auth.currentUser!.phoneNumber.toString());
    Future<Position> _determinePosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition();
    }

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
          .ref('Profile/${auth.currentUser!.uid.toString()}')
          .getDownloadURL();

      return downloadURL;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: personalInfo.doc(auth.currentUser?.uid.toString()).get(),
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
                                    backgroundImage:
                                        NetworkImage(snapshot.data.toString()),
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
          StreamBuilder<DocumentSnapshot>(
            stream: ratesolve,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              if (snapshot.requireData.data() == null) {
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
                              text: TextSpan(
                                  style: TextStyle(color: Color(0xffc0392b)),
                                  children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.star,
                                    color: Color(0xffc0392b),
                                  ),
                                ),
                                TextSpan(
                                    text: "0",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ]))
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Solved Case",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "0",
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
                            "0",
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
                                    text: "0",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ]))
                        ],
                      ),
                    ],
                  ),
                );
              }
              final solveCase = snapshot.data!['total'];

              final rating = snapshot.data!['rating'];

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
                            text: TextSpan(
                                style: TextStyle(color: Color(0xffc0392b)),
                                children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.star,
                                  color: Color(0xffc0392b),
                                ),
                              ),
                              TextSpan(
                                  text: rating.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ]))
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Solved Case",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          solveCase.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffc0392b)),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Bail Case",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: tbail,
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Loading");
                            }

                            if (snapshot.requireData.data() == null) {
                              return Text(
                                "0",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffc0392b)),
                              );
                            }
                            return Text(
                              snapshot.data!['bail'].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffc0392b)),
                            );
                          },
                        ),
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
                                  style: TextStyle(fontWeight: FontWeight.bold))
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
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              final total = snapshot.data!.docs;
              // print(" Total lists");
              // print(total.length);
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
                        StreamBuilder<QuerySnapshot>(
                          stream: hirelist,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Loading");
                            }
                            final list = snapshot.data!.docs;
                            print("list.length");
                            print(list.length);
                            return Text(
                              list.length.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffc0392b)),
                            );
                          },
                        ),
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
            future: personalInfo.doc(auth.currentUser?.uid.toString()).get(),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Basic Info",
                                      style: boldtextStyle,
                                    ),
                                    const SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          const WidgetSpan(
                                              child: Icon(Icons.school)),
                                          const TextSpan(
                                              text: '  Bar AdmissionDate : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(text: data["AdmissionDate"]),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          const WidgetSpan(
                                              child: Icon(Icons.school)),
                                          const TextSpan(
                                              text: '  Practice Court : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Education",
                                      style: boldtextStyle,
                                    ),
                                    const SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          const WidgetSpan(
                                              child: Icon(Icons.school)),
                                          const TextSpan(
                                              text: '  School : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(text: data["School"]),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          const WidgetSpan(
                                              child: Icon(Icons.school)),
                                          const TextSpan(
                                              text: '  College : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(text: data["College"]),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          const WidgetSpan(
                                              child: Icon(Icons.school)),
                                          const TextSpan(
                                              text: '  University : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Contact Info",
                                      style: boldtextStyle,
                                    ),
                                    const SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          const WidgetSpan(
                                              child: Icon(Icons.school)),
                                          const TextSpan(
                                              text: '  Mobile : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(text: data["Phone"]),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          const WidgetSpan(
                                              child: Icon(Icons.school)),
                                          const TextSpan(
                                              text: '  Email : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Places Lived",
                                      style: boldtextStyle,
                                    ),
                                    const SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          const WidgetSpan(
                                              child: Icon(Icons.school)),
                                          const TextSpan(
                                              text: '  BirthPlace : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(text: data["BirthPlace"]),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          const WidgetSpan(
                                              child: Icon(Icons.school)),
                                          const TextSpan(
                                              text: '  Current Place : ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
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
    );
  }
}

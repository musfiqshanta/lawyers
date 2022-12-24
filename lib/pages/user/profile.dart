// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lawyer/pages/user/personal_information.dart';
import '../../main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'lawyer/appoinment.dart';
import 'lawyer/hire_list.dart';
import 'lawyer/request_list.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xff22a6b3),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Userprofile(),
      ),
    );
  }
}

class Userprofile extends StatefulWidget {
  const Userprofile({Key? key}) : super(key: key);

  @override
  _UserprofileState createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

//  debugPrint(ref);
  @override
  Widget build(BuildContext context) {
    const boldtextStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    CollectionReference personalInfo =
        FirebaseFirestore.instance.collection('lawyer_data');
    FirebaseAuth auth = FirebaseAuth.instance;
    Future<String> downloadURLExample() async {
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('Profile/${auth.currentUser!.uid.toString()}')
          .getDownloadURL();
      debugPrint(downloadURL);
      return downloadURL;
    }

    Future<void> uploadFile(String filePath) async {
      File file = File(filePath);

      try {
        await firebase_storage.FirebaseStorage.instance
            .ref('Profile/${auth.currentUser!.uid.toString()}')
            .putFile(file);
      } catch (e) {
        // e.g, e.code == 'canceled'
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 10,
                child: Card(
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                          future: downloadURLExample(),
                          //future: FirebaseFirestore.instance.collection('users'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Stack(
                                children: [
                                  SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      backgroundImage: _pickedImage != null
                                          ? FileImage(_pickedImage!)
                                          : NetworkImage(
                                                  snapshot.data.toString())
                                              as ImageProvider,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  "Choose Options",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: ListBody(children: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          final XFile? image =
                                                              await _picker.pickImage(
                                                                  source:
                                                                      ImageSource
                                                                          .camera);
                                                          final path = image!
                                                              .path
                                                              .toString();
                                                          debugPrint(
                                                              "Image Paths");

                                                          setState(() {
                                                            _pickedImage =
                                                                File(path);
                                                          });

                                                          uploadFile(path);
                                                          debugPrint(
                                                              _pickedImage
                                                                  .toString());
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.camera,
                                                              size: 22,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "Camera",
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                            )
                                                          ],
                                                        )),
                                                    TextButton(
                                                        onPressed: () async {
                                                          final XFile? image =
                                                              await _picker.pickImage(
                                                                  source: ImageSource
                                                                      .gallery);
                                                          final path = image!
                                                              .path
                                                              .toString();
                                                          debugPrint(
                                                              "Image Paths");

                                                          setState(() {
                                                            _pickedImage =
                                                                File(path);
                                                          });
                                                          uploadFile(path);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.photo,
                                                              size: 22,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "Gallary",
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                            )
                                                          ],
                                                        )),
                                                  ]),
                                                ),
                                              );
                                            });
                                      },
                                      child: ClipOval(
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          color: Theme.of(context).primaryColor,
                                          child: Icon(
                                            Icons.photo_camera,
                                            size: 35,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                              // return Text("");
                            }
                            return Text("Loading");
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: personalInfo
                              .doc(auth.currentUser?.uid.toString())
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text("Something went wrong");
                            }

                            if (snapshot.hasData && !snapshot.data!.exists) {
                              return const Text("Document does not exist");
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> data =
                                  snapshot.data!.data() as Map<String, dynamic>;

                              return Text(
                                " ${data['First_Name']} ${data['Last_Name']}",
                                style: boldtextStyle,
                              );
                            }

                            return Center(
                                child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ));
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            //width: 380,
            child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                elevation: 10,
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PersonalInformations()));
                      },
                      leading: const Icon(Icons.supervised_user_circle),
                      title: const Text('Profile'),
                      trailing: const Icon(Icons.more_vert),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RequestList()));
                      },
                      leading: Icon(Icons.settings),
                      title: Text('Send Request'),
                      trailing: Icon(Icons.more_vert),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HireList()));
                      },
                      leading: Icon(Icons.article),
                      title: Text('Hire Request'),
                      trailing: Icon(Icons.more_vert),
                    ),
                    ListTile(
                      leading: Icon(Icons.notification_important),
                      title: Text('Appoinments'),
                      trailing: Icon(Icons.more_vert),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Appoinment()));
                      },
                    ),
                    const ListTile(
                      leading: Icon(Icons.online_prediction),
                      title: Text('Online Status'),
                      trailing: Icon(Icons.more_vert),
                    ),
                    const ListTile(
                      leading: Icon(Icons.support),
                      title: Text('Support '),
                      trailing: Icon(Icons.more_vert),
                    ),
                    InkWell(
                      onTap: () async {
                        await auth.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyApp()));
                      },
                      child: const ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout '),
                      ),
                    ),
                  ],
                )
                //child: Text("hello"),
                ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

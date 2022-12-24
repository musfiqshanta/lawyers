import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../pages/user/lawyer/lawyer_single_info.dart';

class Recomanded extends StatefulWidget {
  const Recomanded({Key? key}) : super(key: key);

  @override
  _RecomandedState createState() => _RecomandedState();
}

class _RecomandedState extends State<Recomanded> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('lawyer_data').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        final list = snapshot.data!.docs;

        return SizedBox(
          height: 370,
          child: ListView.builder(
            itemCount: list.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              Future<String> downloadURLExample() async {
                FirebaseAuth auth = FirebaseAuth.instance;
                String downloadURL = await firebase_storage
                    .FirebaseStorage.instance
                    .ref('Profile/${list[index].id.toString()}')
                    .getDownloadURL();

                return downloadURL;
              }

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SingleLawyerInfo(
                            getid: list[index].id,
                          )));
                },
                child: Row(
                  children: [
                    Container(
                      height: 350,
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        elevation: 8,
                        child: Column(
                          children: [
                            FutureBuilder(
                              future: downloadURLExample(),
                              //future: FirebaseFirestore.instance.collection('users'),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Image(
                                    image: NetworkImage(
                                      snapshot.data.toString(),
                                    ),
                                    width: 250,
                                    height: 150,
                                  );

                                  // return Text("");
                                }
                                return const Text("Loading...");
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 230,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${list[index]['First_Name']} ${list[index]['Last_Name']}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        list[index]['Practice_category'],
                                        style: const TextStyle(
                                            color: Color(0xffc0392b),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.star,
                                        size: 15,
                                        color: Colors.red,
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 15,
                                        color: Colors.red,
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 15,
                                        color: Colors.red,
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 15,
                                        color: Colors.red,
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 15,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              width: 200,
                              child: Divider(
                                height: 40,
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: 210,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.people_sharp,
                                        color: Colors.black,
                                      ),
                                      Text(" 12 Law Stuff",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ],
                                  ),
                                  Text(
                                    "\$ ${list[index]['Price']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xffc0392b)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:lawyer/pages/user/lawyer/lawyer_single_info.dart';

class LawyersFromcategory extends StatefulWidget {
  final String category;
  const LawyersFromcategory({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _LawyersFromcategoryState createState() => _LawyersFromcategoryState();
}

class _LawyersFromcategoryState extends State<LawyersFromcategory> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('lawyer_data')
        .where("Practice_category", isEqualTo: widget.category)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          final list = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: 250),
            itemCount: list.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              Future<String> downloadURLExample() async {
                String downloadURL = await firebase_storage
                    .FirebaseStorage.instance
                    .ref('Profile/${list[index].id.toString()}')
                    .getDownloadURL();
                // debugPrint(downloadURL);
                return downloadURL;
              }

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SingleLawyerInfo(
                            getid: list[index].id,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "4.8 ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Color(0xfffa8231),
                                  )
                                ],
                              )
                            ],
                          ),
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
                            height: 20,
                          ),
                          Text(
                            "${list[index]['First_Name']} ${list[index]['Last_Name']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            list[index]['Practice_category'],
                            style: const TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("\$ ${list[index]['Price']} /hr",
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
            },
          );
        },
      ),
    );
  }
}

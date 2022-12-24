// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/pages/user/order_info.dart';

class RequestList extends StatelessWidget {
  const RequestList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Submited Request")),
      body: CheckRequest(),
    );
  }
}

class CheckRequest extends StatefulWidget {
  const CheckRequest({Key? key}) : super(key: key);

  @override
  State<CheckRequest> createState() => _CheckRequestState();
}

class _CheckRequestState extends State<CheckRequest> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('lawyer_data');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final Stream<QuerySnapshot> showlist = FirebaseFirestore.instance
        .collection("hirelist/${auth.currentUser!.uid}/client")
        .snapshots();

    print(showlist.length);
    return StreamBuilder<QuerySnapshot>(
      stream: showlist,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        final list = snapshot.data!.docs;
        return list.isEmpty
            ? const Text("There is No hire request")
            : ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OrderInfo(
                                id: list[index].id,
                              )));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FutureBuilder<DocumentSnapshot>(
                          future: users.doc(list[index].id).get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text("Something went wrong");
                            }

                            if (snapshot.hasData && !snapshot.data!.exists) {
                              return Text("Document does not exist");
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> data =
                                  snapshot.data!.data() as Map<String, dynamic>;

                              print("data.length");
                              print(data.length);

                              print(list[index]["approval"]);
                              late Color color;
                              if (list[index]["approval"] == true) {
                                color = Colors.green;
                              } else {
                                color = Colors.red;
                              }
                              return ListTile(
                                tileColor: color,
                                title: Text(
                                  " ${data['First_Name']} ${data['Last_Name']}",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              );
                            }

                            return Text("loading....");
                          },
                        ),

                        // ListTile(
                        //   title: Text("${list[index]["approval"]}"),
                        // ),
                        const Divider(
                          color: Colors.grey,
                        )
                      ],
                    ),
                  );
                },
              );
      },
    );
  }
}

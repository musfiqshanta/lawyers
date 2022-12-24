import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'lawyer_single_Info.dart';

class Appoinment extends StatefulWidget {
  const Appoinment({Key? key}) : super(key: key);

  @override
  State<Appoinment> createState() => _AppoinmentState();
}

class _AppoinmentState extends State<Appoinment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appoinment"),
      ),
      body: Notification(),
    );
  }
}

class Notification extends StatefulWidget {
  const Notification({Key? key}) : super(key: key);

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance
    //       .collection('chats/$idUser/messages')
    //       .orderBy(MessageField.createdAt, descending: true)
    //       .snapshots()
    final FirebaseAuth auth = FirebaseAuth.instance;
    final Stream<QuerySnapshot> appoinment = FirebaseFirestore.instance
        .collection("appoinment/${auth.currentUser!.uid}/book")
        .snapshots();

    print("auth.currentUser!.uid");
    print(auth.currentUser!.uid);

    final _fireStore = FirebaseFirestore.instance;
    CollectionReference users =
        FirebaseFirestore.instance.collection('lawyer_data');
    return StreamBuilder<QuerySnapshot>(
      stream: appoinment,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        final list = snapshot.data!.docs;
        print("list.length");
        print(list.length);
        return list.isEmpty
            ? Text("There is no more appoinment")
            : ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SingleLawyerInfo(
                                getid: list[index].id,
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
                              return Text(
                                  " ${data['First_Name']} ${data['Last_Name']}");
                            }

                            return Text("loading");
                          },
                        ),
                        ListTile(
                          title: Text("${list[index]["date"]}"),
                          subtitle: Text("${list[index]["time"]}"),
                        ),
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

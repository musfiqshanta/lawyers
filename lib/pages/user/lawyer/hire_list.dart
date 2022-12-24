import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/pages/user/lawyer/hire_info.dart';

class HireList extends StatefulWidget {
  const HireList({Key? key}) : super(key: key);

  @override
  State<HireList> createState() => _HireListState();
}

class _HireListState extends State<HireList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hire List")),
      body: ShowList(),
    );
  }
}

class ShowList extends StatefulWidget {
  const ShowList({Key? key}) : super(key: key);

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final Stream<QuerySnapshot> hirelist = FirebaseFirestore.instance
        .collection("hire/${auth.currentUser!.uid}/list")
        .snapshots();
    CollectionReference users =
        FirebaseFirestore.instance.collection('lawyer_data');
    CollectionReference hireentry =
        FirebaseFirestore.instance.collection('hire');
    CollectionReference hirelists =
        FirebaseFirestore.instance.collection('hirelist');
    Future<void> updatehire(String id, bool hireme) {
      return hireentry
          .doc(auth.currentUser!.uid)
          .collection("list")
          .doc(id)
          .update({
            "approval": hireme,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> updaterequest(String id, bool hireme) {
      return hirelists
          .doc(id)
          .collection("client")
          .doc(auth.currentUser!.uid)
          .update({
            "approval": hireme,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: hirelist,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                ? const Text("There is No hire request")
                : ListView.builder(
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HireInfo(list[index].id)));
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

                                if (snapshot.hasData &&
                                    !snapshot.data!.exists) {
                                  return Text("Document does not exist");
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;

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
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              updatehire(list[index].id, true);
                                              updaterequest(
                                                  list[index].id, true);
                                            },
                                            icon: Icon(Icons.check),
                                            color: Colors.green,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              updatehire(list[index].id, false);
                                              updaterequest(
                                                  list[index].id, false);
                                            },
                                            icon: Icon(Icons.clear),
                                            color: Colors.red,
                                          ),
                                        ],
                                      ));
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
        ),
      ],
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/pages/feedback.dart';

class OrderInfo extends StatelessWidget {
  String id;

  OrderInfo({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("Order Info"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(icon: Icon(Icons.notification_add)),
              ],
            ),
          ),
          body: Info(id: id),
        ),
      ),
    );
  }
}

class Info extends StatefulWidget {
  String id;
  Info({required this.id, Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference post = FirebaseFirestore.instance.collection('post');
    final Stream<QuerySnapshot> showpost = FirebaseFirestore.instance
        .collection("post/${widget.id}/${auth.currentUser!.uid}")
        .snapshots();
    final Stream<DocumentSnapshot<Map<String, dynamic>>> bailapproval =
        FirebaseFirestore.instance
            .collection("bail")
            .doc(widget.id)
            .collection("client")
            .doc(auth.currentUser!.uid)
            .snapshots();
    final Stream<DocumentSnapshot<Map<String, dynamic>>> caseApprove =
        FirebaseFirestore.instance
            .collection("dismiss")
            .doc(widget.id)
            .collection("client")
            .doc(auth.currentUser!.uid)
            .snapshots();

    Future<void> addpost(String msg) {
      return post
          .doc(widget.id)
          .collection(auth.currentUser!.uid)
          .add({
            "message": msg,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    CollectionReference bailcase =
        FirebaseFirestore.instance.collection('bail');
    final Stream<DocumentSnapshot<Object?>> bailcount = FirebaseFirestore
        .instance
        .collection('bail')
        .doc(widget.id)
        .snapshots();
    Future<void> totalbail(int bail) {
      return bailcase
          .doc(widget.id)
          .set({
            "bail": bail,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    CollectionReference users =
        FirebaseFirestore.instance.collection('lawyer_data');

    CollectionReference dismiss =
        FirebaseFirestore.instance.collection('dismiss');
    Future<void> bail(bool bail) {
      return bailcase
          .doc(widget.id)
          .collection("client")
          .doc(auth.currentUser!.uid)
          .update({
            "bail": bail,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> notbail(bool bail, bool req) {
      return bailcase
          .doc(widget.id)
          .collection("client")
          .doc(auth.currentUser!.uid)
          .update({"bail": bail, "request": req, "reject": true})
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> cdismiss(bool dis, int rev) {
      return dismiss
          .doc(widget.id)
          .collection("client")
          .doc(auth.currentUser!.uid)
          .update({
            "dismiss": dis,
            "review": rev,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> cndismiss(bool dis, bool req) {
      return dismiss
          .doc(widget.id)
          .collection("client")
          .doc(auth.currentUser!.uid)
          .update({"dismiss": dis, "request": req, "reject": true})
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    CollectionReference addreview =
        FirebaseFirestore.instance.collection('review');
    Future<void> totalreview() {
      return addreview
          .doc(widget.id)
          .set({
            "rating": 0.0,
            "total": 0,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    final _formKey = GlobalKey<FormState>();
    late String txt;
    late int review;
    return TabBarView(
      children: [
        Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      minLines:
                          3, // any number you need (It works as the rows for the textarea)
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (valu) {
                        txt = valu;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            addpost(txt);
                          },
                          child: const Text("Post")),
                    )
                  ],
                )),
            StreamBuilder<QuerySnapshot>(
              stream: showpost,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                final list = snapshot.data!.docs;
                print("list.lengths");
                print(list.length);
                return Expanded(
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (contex, index) {
                        return Text(list[index]["message"]);
                      }),
                );
              },
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: bailapproval,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                late bool x;
                late Color color;
                late String text;
                if (snapshot.requireData.data() != null) {
                  x = snapshot.data!.get('request');

                  if (snapshot.data!['bail'] == true) {
                    color = Color.fromARGB(255, 93, 206, 97);
                    text = "Thanks";
                  } else {
                    color = Colors.yellow;
                    text = "Are You agree ?";
                  }
                } else {
                  x = false;
                }

                return FutureBuilder<DocumentSnapshot>(
                  future: users.doc(widget.id).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> datas =
                          snapshot.data!.data() as Map<String, dynamic>;

                      return x == true
                          ? Column(
                              children: [
                                ListTile(
                                  tileColor: color,
                                  title: Text(
                                    "${datas['First_Name']} ${datas['Last_Name']} request for bail",
                                  ),
                                  subtitle: Text(text),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: StreamBuilder<DocumentSnapshot>(
                                            stream: bailcount,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<DocumentSnapshot>
                                                    snapshot) {
                                              if (snapshot.hasError) {
                                                return const Text(
                                                    "Something went wrong");
                                              }

                                              if (snapshot.requireData.data() ==
                                                  null) {
                                                return IconButton(
                                                    onPressed: () {
                                                      bail(true);

                                                      totalbail(1);
                                                    },
                                                    icon: Icon(Icons.check));
                                              }
                                              final tbail =
                                                  snapshot.data!['bail'];
                                              return IconButton(
                                                  onPressed: () {
                                                    bail(true);

                                                    totalbail(tbail + 1);
                                                  },
                                                  icon: Icon(Icons.check));
                                            }),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            notbail(false, false);
                                          },
                                          icon: Icon(Icons.clear)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Text("No Request");
                    }

                    return Text("loading....");
                  },
                );
              },
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: caseApprove,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                late bool x;
                late Color color;
                late String text;
                late String title;
                if (snapshot.requireData.data() != null) {
                  x = snapshot.data!.get('request');

                  if (snapshot.data!['dismiss'] == true) {
                    color = Color.fromARGB(255, 93, 206, 97);
                    text = "Make Review ";
                    title = "Congratulations ";
                    review = 0;
                  } else {
                    color = Colors.yellow;
                    text = "Are You agree ?";
                    title = "Wants to dismiss";
                    review = 1;
                  }

                  if (snapshot.data!['review'] == 1) {
                    review = 1;
                  } else if (snapshot.data!['review'] == 0) {
                    review = 0;
                  } else {
                    review = 2;
                    text = "This Case Now dismiss";
                  }
                } else {
                  x = false;
                }

                print("snapshot.requireData");
                print(snapshot.requireData.data());
                // print("snapshot.data!.get('request')");
                // print(snapshot.data!.get('request'));
                // return Text("data");
                return FutureBuilder<DocumentSnapshot>(
                  future: users.doc(widget.id).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> datas =
                          snapshot.data!.data() as Map<String, dynamic>;

                      return x == true
                          ? Column(
                              children: [
                                ListTile(
                                  tileColor: color,
                                  title: Text(
                                    "${datas['First_Name']} ${datas['Last_Name']} $title",
                                  ),
                                  subtitle: Text(text),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      review == 1
                                          ? IconButton(
                                              onPressed: () {
                                                cdismiss(true, 0);
                                                // totalreview();
                                              },
                                              icon: Icon(Icons.check))
                                          : review == 0
                                              ? IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Feedbackpage(
                                                                  id: widget.id,
                                                                )));
                                                  },
                                                  icon: Icon(Icons.reviews))
                                              : IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.star)),
                                      IconButton(
                                          onPressed: () {
                                            cndismiss(false, false);
                                          },
                                          icon: Icon(Icons.clear))
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Text("No Request");
                    }

                    return Text("loading....");
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

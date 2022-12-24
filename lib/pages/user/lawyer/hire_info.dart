import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/pages/user/tab_user_info.dart';

class HireInfo extends StatelessWidget {
  final String id;
  const HireInfo(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Case Info"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(icon: Icon(Icons.info_outline_rounded)),
                Tab(icon: Icon(Icons.people)),
              ],
            ),
          ),
          body: AllInfo(id: id),
        ),
      ),
    );
  }
}

class AllInfo extends StatefulWidget {
  final String id;
  const AllInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<AllInfo> createState() => _AllInfoState();
}

class _AllInfoState extends State<AllInfo> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference post = FirebaseFirestore.instance.collection('post');
    CollectionReference bailcase =
        FirebaseFirestore.instance.collection('bail');
    CollectionReference dismiss =
        FirebaseFirestore.instance.collection('dismiss');
    final _formKey = GlobalKey<FormState>();
    Future<void> addpost(String msg) {
      return post
          .doc(auth.currentUser!.uid)
          .collection(widget.id)
          .add({
            "message": msg,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> bail(bool bail) {
      return bailcase
          .doc(auth.currentUser!.uid)
          .collection("client")
          .doc(widget.id)
          .set({
            "bail": bail,
            "request": true,
            "reject": "",
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

 
    Future<void> dismissCase(bool dis) {
      return dismiss
          .doc(auth.currentUser!.uid)
          .collection("client")
          .doc(widget.id)
          .set({
            "dismiss": dis,
            "request": true,
            "reject": "",
            "review": 1,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    final Stream<DocumentSnapshot<Map<String, dynamic>>> bailinfo = bailcase
        .doc(auth.currentUser!.uid)
        .collection("client")
        .doc(widget.id)
        .snapshots();
    final Stream<DocumentSnapshot<Map<String, dynamic>>> dismissinfo = dismiss
        .doc(auth.currentUser!.uid)
        .collection("client")
        .doc(widget.id)
        .snapshots();

    final Stream<QuerySnapshot> showpost = FirebaseFirestore.instance
        .collection("post/${auth.currentUser!.uid}/${widget.id}")
        .snapshots();

    late String txt;

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
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: bailinfo,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  late Color color;
                  late String sub;
                  print("snapshot.data");
                  print(snapshot.requireData.data());
                  if (snapshot.requireData.data() != null) {
                    if (snapshot.data!['request'] == true) {
                      color = Colors.yellow;
                      sub = "Your Request has been procerss";
                    } else {
                      color = Colors.white;
                      sub = "";
                    }
                    if (snapshot.data!['reject'] == true) {
                      color = Colors.red;
                    }
                    if (snapshot.data!['bail'] == true) {
                      color = Color.fromARGB(255, 93, 206, 97);
                      sub = "Cogratulatinos Approved";
                    }
                  } else {
                    color = Colors.white;
                    sub = "";
                  }

                  return Column(
                    children: [
                      ListTile(
                          tileColor: color,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Is this case Bail?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            bail(false);
                                            Navigator.pop(context);
                                          },
                                          child: Text("Yes")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("No"))
                                    ],
                                  );
                                });
                          },
                          leading: const Icon(Icons.supervised_user_circle),
                          title: const Text('Bail Case'),
                          subtitle: Text(sub)),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                }),
            StreamBuilder<DocumentSnapshot>(
                stream: dismissinfo,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  late Color color;
                  late String sub;
                  print("snapshot.data");
                  print(snapshot.requireData.data());
                  if (snapshot.requireData.data() != null) {
                    if (snapshot.data!['request'] == true) {
                      color = Colors.yellow;
                      sub = "Your Request has been procerss";
                    } else {
                      color = Colors.white;
                      sub = "";
                    }
                    if (snapshot.data!['reject'] == true) {
                      color = Colors.red;
                    }
                    if (snapshot.data!['dismiss'] == true) {
                      color = Color.fromARGB(255, 93, 206, 97);
                      sub = "Cogratulatinos Approved";
                    }
                  } else {
                    color = Colors.white;
                    sub = "";
                  }

                  return Column(
                    children: [
                      ListTile(
                        tileColor: color,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Is this case Dismiss"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          dismissCase(false);
                                          Navigator.pop(context);
                                        },
                                        child: Text("Yes")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("No"))
                                  ],
                                );
                              });
                        },
                        leading: const Icon(Icons.supervised_user_circle),
                        title: const Text('Case dismiss'),
                      ),
                    ],
                  );
                }),
          ],
        ),
        TabUserData(getid: widget.id),
      ],
    );
  }
}

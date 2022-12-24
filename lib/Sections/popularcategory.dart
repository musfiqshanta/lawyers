import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/user/lawyer/lawyerbycategory.dart';

class Poularcategory extends StatefulWidget {
  const Poularcategory({Key? key}) : super(key: key);

  @override
  _PoularcategoryState createState() => _PoularcategoryState();
}

class _PoularcategoryState extends State<Poularcategory> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('lawyer_data')
        .where("Practice_category")
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          final list1 = snapshot.data!.docs.where((element) {
            return element
                .get("Practice_category")
                .toString()
                .contains("General Practice");
          }).toList();
          final list2 = snapshot.data!.docs.where((element) {
            return element
                .get("Practice_category")
                .toString()
                .contains("Accident & Injury");
          }).toList();
          final list3 = snapshot.data!.docs.where((element) {
            return element
                .get("Practice_category")
                .toString()
                .contains("Divorce & Family Law");
          }).toList();
          final list4 = snapshot.data!.docs.where((element) {
            return element
                .get("Practice_category")
                .toString()
                .contains("Environmental Law");
          }).toList();

          return SizedBox(
            height: 190,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                //  print(listx[1].toString());
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LawyersFromcategory(
                              category: "General Practice",
                            )));
                  },
                  child: Category(
                    list: list1,
                    title: "General Practice",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LawyersFromcategory(
                              category: "Accident & Injury",
                            )));
                  },
                  child: Category(
                    list: list2,
                    title: "Accident & Injury",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LawyersFromcategory(
                              category: "Divorce & Family Law",
                            )));
                  },
                  child: Category(
                    list: list3,
                    title: "Divorce & Family Law",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LawyersFromcategory(
                              category: "Environmental Law",
                            )));
                  },
                  child: Category(
                    list: list4,
                    title: "Environmental Law",
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class Category extends StatelessWidget {
  final String title;
  final List<QueryDocumentSnapshot<Object?>> list;

  const Category({Key? key, required this.list, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 180,
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
                const Image(
                  image: AssetImage('images/d.jpg'),
                  width: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  list.length.toString() + " Lawyers",
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../user/lawyer/lawyerbycategory.dart';

class Categorypage extends StatefulWidget {
  const Categorypage({Key? key}) : super(key: key);

  @override
  _CategorypageState createState() => _CategorypageState();
}

class _CategorypageState extends State<Categorypage> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('lawyer_data')
      .where("Practice_category")
      .snapshots();

  late List x;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('lawyer_data')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (kDebugMode) print("Category");
        print(doc["Practice_category"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        final list = snapshot.data!.docs;
        final cat1 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("General Practice");
        }).toList();
        final cat2 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Accident & Injury");
        }).toList();
        final cat3 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Bankruptcy & Debt");
        }).toList();
        final cat4 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Business");
        }).toList();
        final cat5 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Civil & Human Rights");
        }).toList();
        final cat6 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Consumer Rights");
        }).toList();
        final cat7 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Criminal");
        }).toList();
        final cat8 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Divorce & Family Law");
        }).toList();
        final cat9 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Employment");
        }).toList();
        final cat10 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Environmental Law");
        }).toList();
        final cat11 = list.where((element) {
          return element.get("Practice_category").toString().contains("Estate");
        }).toList();
        final cat12 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Government");
        }).toList();
        final cat13 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Health Care");
        }).toList();
        final cat14 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Immigration");
        }).toList();
        final cat15 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Industry Specialties");
        }).toList();
        final cat16 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Intellectual Property");
        }).toList();
        final cat17 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("International");
        }).toList();
        final cat18 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Lawsuit & Dispute");
        }).toList();
        final cat19 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Mass Torts");
        }).toList();
        final cat20 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Motor Vehicle");
        }).toList();
        final cat21 = list.where((element) {
          return element
              .get("Practice_category")
              .toString()
              .contains("Real Estate");
        }).toList();
        final cat22 = list.where((element) {
          return element.get("Practice_category").toString().contains("Tax");
        }).toList();
        final cat23 = list.where((element) {
          return element.get("Practice_category").toString().contains("Other");
        }).toList();
        return GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisExtent: 200),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            if (cat1.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "General Practice",
                          )));
                },
                child: Category(
                  list: cat1,
                  title: "General Practice",
                ),
              ),
            if (cat2.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Accident & Injury",
                          )));
                },
                child: Category(
                  list: cat2,
                  title: "Accident & Injury",
                ),
              ),
            if (cat3.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Bankruptcy & Debt",
                          )));
                },
                child: Category(
                  list: cat3,
                  title: "Bankruptcy & Debt",
                ),
              ),
            if (cat4.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Business",
                          )));
                },
                child: Category(
                  list: cat4,
                  title: "Business",
                ),
              ),
            if (cat5.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Civil & Human Rights",
                          )));
                },
                child: Category(
                  list: cat5,
                  title: "Civil & Human Rights",
                ),
              ),
            if (cat6.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Consumer Rights",
                          )));
                },
                child: Category(
                  list: cat6,
                  title: "Consumer Rights",
                ),
              ),
            if (cat7.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Criminal",
                          )));
                },
                child: Category(
                  list: cat7,
                  title: "Criminal",
                ),
              ),
            if (cat8.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Divorce & Family Law",
                          )));
                },
                child: Category(
                  list: cat8,
                  title: "Divorce & Family Law",
                ),
              ),
            if (cat9.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Employment",
                          )));
                },
                child: Category(
                  list: cat9,
                  title: "Employment",
                ),
              ),
            if (cat10.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Environmental Law",
                          )));
                },
                child: Category(
                  list: cat10,
                  title: "Environmental Law",
                ),
              ),
            if (cat11.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Estate",
                          )));
                },
                child: Category(
                  list: cat11,
                  title: "Estate",
                ),
              ),
            if (cat12.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Government",
                          )));
                },
                child: Category(
                  list: cat12,
                  title: "Government",
                ),
              ),
            if (cat13.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Health Care",
                          )));
                },
                child: Category(
                  list: cat13,
                  title: "Health Care",
                ),
              ),
            if (cat14.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Immigration",
                          )));
                },
                child: Category(
                  list: cat14,
                  title: "Immigration",
                ),
              ),
            if (cat15.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Industry Specialties",
                          )));
                },
                child: Category(
                  list: cat15,
                  title: "Industry Specialties",
                ),
              ),
            if (cat16.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Intellectual Property",
                          )));
                },
                child: Category(
                  list: cat16,
                  title: "Intellectual Property",
                ),
              ),
            if (cat17.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "International",
                          )));
                },
                child: Category(
                  list: cat17,
                  title: "International",
                ),
              ),
            if (cat18.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Lawsuit & Dispute",
                          )));
                },
                child: Category(
                  list: cat18,
                  title: "Lawsuit & Dispute",
                ),
              ),
            if (cat19.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Mass Torts",
                          )));
                },
                child: Category(
                  list: cat19,
                  title: "Mass Torts",
                ),
              ),
            if (cat20.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Motor Vehicle",
                          )));
                },
                child: Category(
                  list: cat20,
                  title: "Motor Vehicle",
                ),
              ),
            if (cat21.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Real Estate",
                          )));
                },
                child: Category(
                  list: cat21,
                  title: "Real Estate",
                ),
              ),
            if (cat22.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Tax",
                          )));
                },
                child: Category(
                  list: cat22,
                  title: "Tax",
                ),
              ),
            if (cat23.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LawyersFromcategory(
                            category: "Other",
                          )));
                },
                child: Category(
                  list: cat23,
                  title: "Other",
                ),
              ),
          ],
        );
      },
    );
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
        Card(
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          elevation: 8,
          child: Column(
            children: [
              Image(
                image: const AssetImage('images/d.jpg'),
                width: MediaQuery.of(context).size.width / 2.1,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        )
      ],
    );
  }
}

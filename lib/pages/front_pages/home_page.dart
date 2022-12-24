import 'package:flutter/material.dart';
import 'package:lawyer/Sections/popularcategory.dart';
import 'package:lawyer/Sections/popularlawer.dart';
import 'package:lawyer/Sections/recomanded.dart';
import '../../main.dart';

class Homepagem extends StatelessWidget {
  const Homepagem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Hompage(),
    );
  }
}

class Hompage extends StatefulWidget {
  const Hompage({Key? key}) : super(key: key);

  @override
  _HompageState createState() => _HompageState();
}

class _HompageState extends State<Hompage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Popular Categorys",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              page: 0,
                              title: "All Category",
                            )));
                  },
                  child: Text(
                    "View ALl+",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const Poularcategory(),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Recomanded For You",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const Recomanded(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Popular Lawyer",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              page: 1,
                              title: "All Lawyers",
                            )));
                  },
                  child: Text(
                    "View ALl+",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const PopularLawer(),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lawyer/main.dart';

class Feedbackpage extends StatelessWidget {
  String id;
  Feedbackpage({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(" feedback")),
      body: Review(
        id: id,
      ),
    );
  }
}

class Review extends StatefulWidget {
  String id;
  Review({required this.id, Key? key}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference review =
        FirebaseFirestore.instance.collection('review');
    CollectionReference dismiss =
        FirebaseFirestore.instance.collection('dismiss');
    Future<void> addReview(String msg, double rate) {
      return review
          .doc(widget.id)
          .collection("client")
          .doc(auth.currentUser!.uid)
          .set({
            "rating": rate,
            "message": msg,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> totalreview(double rate, int count) {
      return review
          .doc(widget.id)
          .set({
            "rating": rate,
            "total": count,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    Future<void> cdismiss(int rev) {
      return dismiss
          .doc(widget.id)
          .collection("client")
          .doc(auth.currentUser!.uid)
          .update({
            "review": rev,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    final Stream<DocumentSnapshot<Map<String, dynamic>>> showRate =
        FirebaseFirestore.instance
            .collection("review")
            .doc(widget.id)
            .snapshots();

    late String msg;
    late double rate;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            onChanged: (value) {
              msg = value;
            },
            decoration: InputDecoration(labelText: "Write something"),
            minLines: 3,
            maxLines: null,
          ),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              rate = rating;
            },
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: showRate,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              // print("rates");
              // print(rates);
              // print("Totals");
              // print(total);
              if (snapshot.requireData.data() == null) {
                return ElevatedButton(
                    onPressed: () {
                      cdismiss(2);
                      addReview(msg, rate);
                      double frates = 0 + rate;
                      int ftotal = 0 + 1;

                      print("total reate and cont");
                      print(frates);
                      print(ftotal);
                      totalreview(frates, ftotal);

                      Navigator.pop(context);
                    },
                    child: Text("submit"));
              }

              print("snapshot.requireData.data()");
              print(snapshot.requireData.data());

              double rates = snapshot.data!['rating'];
              int total = snapshot.data!['total'];

              return ElevatedButton(
                  onPressed: () {
                    cdismiss(2);
                    addReview(msg, rate);
                    double frates = rates + rate;
                    int ftotal = total + 1;

                    print("total reate and cont");
                    print(frates);
                    print(ftotal);
                    totalreview(frates, ftotal);

                    Navigator.pop(context);
                  },
                  child: Text("submit"));
            },
          ),
        ],
      ),
    );
  }
}

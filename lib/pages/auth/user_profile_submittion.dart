import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfile {
  Future addUser(
    String firstName,
    String lastName,
    String adress,
    String gender,
    String country,
    String? city,
    String? zipv,
    String? aboutv,
    String email,
    String uId,
  ) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('client_data');
    final FirebaseAuth auth = FirebaseAuth.instance;

    // Call the user's CollectionReference to add a new user
    return await users
        .doc(auth.currentUser!.uid.toString())
        .set({
          'First_Name': firstName,
          'Last_Name': lastName,
          'Adress': adress,
          'Gender': gender,
          'Country': country,
          'City': city,
          'Zip': zipv,
          'About': aboutv,
          'Email': email,
          'ID': uId,
        })
        .then((value) => debugPrint("User Added"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
  }
}

class LawyerProfile {
  Future addUser(
    String firstName,
    String lastName,
    String birthplace,
    String adress,
    String phone,
    String gender,
    String country,
    String city,
    String zipv,
    String school,
    String college,
    String university,
    String pCategory,
    String pCourt,
    String admissionDate,
    String price,
    String aboutv,
    String email,
    String uId,
  ) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('lawyer_data');
    final FirebaseAuth auth = FirebaseAuth.instance;

    // Call the user's CollectionReference to add a new user
    return await users
        .doc(auth.currentUser!.uid.toString())
        .set({
          'First_Name': firstName,
          'Last_Name': lastName,
          'BirthPlace': birthplace,
          'Adress': adress,
          'Phone': phone,
          'Gender': gender,
          'Country': country,
          'City': city,
          'Zip': zipv,
          'School': school,
          'College': college,
          'University': university,
          'Practice_category': pCategory,
          'Practice_court': pCourt,
          'AdmissionDate': admissionDate,
          'Price': price,
          'About': aboutv,
          'Email': email,
          'ID': uId,
        })
        .then((value) => debugPrint("User Added"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
  }
}

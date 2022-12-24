import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/pages/user/profile.dart';

import '../user/user_auth_page.dart';

class Conditional extends StatefulWidget {
  const Conditional({Key? key}) : super(key: key);

  @override
  _ConditionalState createState() => _ConditionalState();
}

class _ConditionalState extends State<Conditional> {
  Future refresh() async {}
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    debugPrint("Current user");
    if (auth.currentUser != null) {
      return  Userprofile();
    } else {
      return const Guestprofile();
    }
  }
}

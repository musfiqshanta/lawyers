import 'package:flutter/material.dart';
import '../../main.dart';
import '../auth/login.dart';
import '../auth/registration.dart';
import '../auth/auth.dart';

class Guestprofile extends StatefulWidget {
  const Guestprofile({Key? key}) : super(key: key);

  @override
  _GuestprofileState createState() => _GuestprofileState();
}

class _GuestprofileState extends State<Guestprofile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Guestbody(),
    );
  }
}

class Guestbody extends StatefulWidget {
  const Guestbody({Key? key}) : super(key: key);

  @override
  _GuestbodyState createState() => _GuestbodyState();
}

class _GuestbodyState extends State<Guestbody> {
  final _userAuth = Authservice();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Register()));
          },
          child: Row(
            children: const [
              Icon(
                Icons.add,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Registration",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Login()));
          },
          child: Row(
            children: const [
              Icon(
                Icons.add,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        TextButton(
          onPressed: () async {
            await _userAuth.signinAnn();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyApp()));
          },
          child: Row(
            children: const [
              Icon(
                Icons.add,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Guest Sign In ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

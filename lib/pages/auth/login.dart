import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:lawyer/pages/auth/registration.dart';
import 'auth.dart';
import '../../main.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const RegisterBody(),
    );
  }
}

class RegisterBody extends StatefulWidget {
  const RegisterBody({Key? key}) : super(key: key);

  @override
  _RegisterBodyState createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final _userAuth = Authservice();
  final _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode = FocusNode();
  FocusNode myFocusNode2 = FocusNode();
  FocusNode myFocusNode3 = FocusNode();
  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    myFocusNode2 = FocusNode();
    myFocusNode3 = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    myFocusNode2.dispose();
    myFocusNode3.dispose();

    super.dispose();
  }

  late Color color;

  final RegExp _passvalid = RegExp(r"^[A-Za-z]", caseSensitive: true);
  late int passlen;
  dynamic test;
  late String email, password;
  bool shpass = true;
  bool indigator = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Sign In",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        focusNode: myFocusNode2,
                        onSaved: (value) {
                          email = value!;
                        },
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please add some text";
                          }
                          if (!value.contains("com") ||
                              !value.contains("@") ||
                              value.length < 5) {
                            return "Invalid Email";
                          }

                          return null;
                        },
                        onTap: () {
                          setState(() {
                            color = Colors.teal;
                          });
                        },
                        autofocus: false,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 1.0,
                          )),
                          icon: const Icon(
                            Icons.email,
                            size: 40.0,
                          ),
                          labelText: "Email",
                          labelStyle: TextStyle(
                              color:
                                  myFocusNode2.hasFocus ? color : Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        onSaved: (value) {
                          password = value!;
                        },
                        onChanged: (String value) {
                          setState(() {
                            if (_passvalid.hasMatch(value)) {
                              color = Theme.of(context).primaryColor;
                            } else {
                              color = Colors.red;
                            }
                            password = value;
                          });
                        },
                        validator: (value) {
                          if (!_passvalid.hasMatch(value!)) {
                            return "Invalid Password";
                          }
                          return null;
                        },
                        focusNode: myFocusNode3,
                        onTap: () {
                          setState(() {
                            color = Colors.teal;
                          });
                        },
                        autofocus: false,
                        obscureText: shpass,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                          icon: const Icon(
                            Icons.lock,
                            size: 40.0,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (shpass == true) {
                                  shpass = false;
                                } else {
                                  shpass = true;
                                }
                              });
                            },
                            child: Icon(shpass
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color:
                                  myFocusNode3.hasFocus ? color : Colors.grey),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20.0,
              ),
              indigator == true
                  ? const CircularProgressIndicator(
                      backgroundColor: Colors.green,
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            indigator = true;
                          });

                          debugPrint("SHow user and pass");
                          debugPrint(email);
                          debugPrint(password);
                          dynamic result =
                              await _userAuth.signin(email, password);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyApp()));
                          setState(() {
                            indigator = false;
                          });
                          debugPrint(result);
                        }
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
              const SizedBox(
                height: 20.0,
              ),
              RichText(
                text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                    ),
                    text: "Don't have an account?",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const Register()));
                      },
                    children: [
                      TextSpan(
                          text: " Create Account",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()));
                            }),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

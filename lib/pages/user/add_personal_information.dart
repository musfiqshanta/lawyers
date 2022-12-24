import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/button_provider.dart';
import '../auth/user_profile_submittion.dart';
import 'lawyer/add_lawyer_personal_information.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({Key? key}) : super(key: key);

  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Theme.of(context).primaryColor,
        // actions: [
        //   //buttons()
        // ]
        //Text("Tor heda ${context.watch<Counter>().getdata}")],
      ),
      body: const UserInformation(),
    );
  }
}

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  String? fnv,
      lnv,
      bplace,
      adrv,
      phn,
      genv,
      couv,
      cityv,
      zipv,
      signtypev,
      aboutv,
      uId;

  var gen = "Male";
  var cu = "Country";
  var bs = "City";
  var ps = "City";
  var ins = "City";
  var at = "Sign Up as a";
  final _formKey = GlobalKey<FormState>();

  UserProfile userProfile = UserProfile();

  @override
  Widget build(BuildContext context) {
    var gender = ["Male", "Female", "Other"];
    var country = [
      "Country",
      'Bangladesh',
      "Pakistan",
      "India",
      "China",
      "Greace",
      "Germany"
    ];

    var bd = ["City", "Dhaka", "Chittagon", "khulan"];
    var pk = ["City", "Islamabadh", "Karachi", "Peswoar"];
    var ind = ["City", "Kolkata", "Dilhi", "Mumbai"];
    // var ch = ["Beijing", "Honkong", "Shanhai"];
    // var ger = ["Berline", "Humburg", "Hessen"];
    var accountType = ["Sign Up as a", "Client", "Lawyer"];
    String email;
    final FirebaseAuth auth = FirebaseAuth.instance;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 10.0,
            runAlignment: WrapAlignment.spaceAround,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: "First Name", border: OutlineInputBorder()),
                  onChanged: (value) {
                    setState(() {
                      fnv = value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      lnv = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "Last Name", border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      adrv = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "Adress", border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      bplace = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "BirthPlace", border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      phn = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "Mobile", border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      zipv = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "ZipCode", border: OutlineInputBorder()),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2.2,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      icon: const Icon(Icons.arrow_downward),
                      style: const TextStyle(color: Colors.black87),
                      onChanged: (String? newValue) {
                        setState(() {
                          cu = newValue!;
                          couv = cu;
                        });
                      },
                      value: cu,
                      items:
                          country.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              cu == "Bangladesh"
                  ? Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black87),
                            onChanged: (String? newValue) {
                              setState(() {
                                bs = newValue!;
                                cityv = newValue;
                                //  state.didChange(newValue);
                                //debugPrint(x);
                              });
                            },
                            value: bs,
                            items: bd
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )
                  : cu == "Pakistan"
                      ? Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(color: Colors.black87),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    ps = newValue!;
                                    cityv = newValue;
                                  });
                                },
                                value: ps,
                                items: pk.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 10,
                                style: const TextStyle(color: Colors.black87),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    ins = newValue!;
                                    cityv = newValue;
                                    //  state.didChange(newValue);
                                    //debugPrint(x);
                                  });
                                },
                                value: ins,
                                items: ind.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      icon: const Icon(Icons.arrow_downward),
                      style: const TextStyle(color: Colors.black87),
                      onChanged: (String? newValue) {
                        setState(() {
                          gen = newValue!;
                          genv = gen;
                        });
                      },
                      value: gen,
                      items:
                          gender.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 10,
                      style: const TextStyle(color: Colors.black87),
                      onChanged: (String? newValue) {
                        setState(() {
                          at = newValue!;
                          signtypev = newValue;

                          context.read<Counter>().increment(at);

                          //debugPrint(at);
                        });
                      },
                      value: at,
                      items: accountType
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              TextFormField(
                onChanged: (String? newValue) {
                  setState(() {
                    aboutv = newValue!;

                    context.read<Counter>().increment(at);

                    //debugPrint(at);
                  });
                },
                minLines: 5,
                maxLines: 20,
                decoration: const InputDecoration(
                    labelText: "About You", border: OutlineInputBorder()),
              ),
              context.watch<Counter>().getdata == "Client"
                  ? ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                          shadowColor: MaterialStateProperty.all(Colors.white)),
                      onPressed: () async {
                        email = auth.currentUser!.email!;
                        uId = auth.currentUser!.uid;

                        await userProfile.addUser(
                          fnv!,
                          lnv!,
                          adrv!,
                          genv!,
                          couv!,
                          cityv,
                          zipv,
                          aboutv,
                          email,
                          uId!,
                        );
                      },
                      child: const Text("Save"),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                          shadowColor: MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        email = auth.currentUser!.email!;
                        uId = auth.currentUser!.uid;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Layersinfo(
                                  fn: fnv,
                                  ln: lnv,
                                  bplace: bplace,
                                  adr: adrv,
                                  phn: phn,
                                  gen: genv,
                                  cou: couv,
                                  city: cityv,
                                  zip: zipv,
                                  about: aboutv,
                                  email: email,
                                  uId: uId,
                                )));
                      },
                      child: const Text("Next"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

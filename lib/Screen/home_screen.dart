import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latihan/View%20Model/auth_view_model.dart';
import 'package:latihan/View%20Model/user_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController noHpcontroller = TextEditingController();

  final UserViewModel _userViewModel = UserViewModel();

  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final currentuser = FirebaseAuth.instance.currentUser!;
  late UserViewModel userViewModel;

  @override
  Widget build(BuildContext context) {
    final signOut = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.amber.shade200,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        onPressed: () async {
          await _auth.signOut();
        },
        child: const Text(
          "LogOut",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          textAlign: TextAlign.center,
        ),
      ),
    );
    final emailField = TextFormField(
        controller: emailController,
        autofocus: false,
        validator: (value) {
          if (value != null) {
            if (value.contains('@') && value.endsWith('.com')) {
              return null;
            }
            return 'Enter a Valid Email Address';
          }
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final noHpFrom = TextFormField(
      controller: noHpcontroller,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "no Hp",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final firstname = TextFormField(
        controller: firstnameController,
        autofocus: false,
        validator: (value) {
          return null;

          // if (value != null) {
          //   if (value.contains('@') && value.endsWith('.com')) {
          //     return null;
          //   }
          //   return 'Enter a Valid Email Address';
          // }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Username",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final Tambah = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.amber.shade200,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) return;

          _userViewModel.addViewModel(
              email: emailController.text,
              firstname: firstnameController.text,
              noHp: noHpcontroller.text);
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            Fluttertoast.showToast(msg: 'Success');
          } else {
            Fluttertoast.showToast(msg: 'gagal');
          }
        },
        child: const Text(
          "Tambah",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );

    Query dbreff =
        FirebaseDatabase.instance.ref().child('Data').child(currentuser.uid);
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
          actions: [
            Padding(padding: const EdgeInsets.only(right: 5), child: signOut)
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              emailField,
              SizedBox(
                height: 5,
              ),
              firstname,
              SizedBox(
                height: 5,
              ),
              noHpFrom,
              SizedBox(
                height: 25,
              ),
              Tambah,
              SizedBox(
                height: 20,
              ),
              Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFf8c46b),
                  ),
                  child: Text("Hasil Penambahan Data")),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFf8c46b),
                        Colors.black38,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.1, 1],
                    ),
                  ),
                  child: FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 3)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: FirebaseAnimatedList(
                              query: dbreff,
                              itemBuilder:
                                  (context, snapshot, animation, index) {
                                Map Data = snapshot.value as Map;
                                Data['key'] = snapshot.key;
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 40),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("Email"),
                                          Text(Data["email"].toString()),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("Firstname"),
                                          Text(Data["firstname"].toString()),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("No Hp"),
                                          Text(Data["noHp"].toString()),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }),
                ),
              )
            ],
          ),
        ));
  }
}

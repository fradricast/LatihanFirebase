import 'package:latihan/Model/firebase_user_model.dart';
import 'package:latihan/Widget/widget_handle.dart';
import 'package:latihan/Screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser?>(context);
    if (user == null) {
      return const Handler();
    } else {
      return const HomeScreen();
    }
  }
}

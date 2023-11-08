import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:latihan/View%20Model/auth_view_model.dart';
import 'package:latihan/firebase_options.dart';
import 'package:latihan/Model/firebase_user_model.dart';
import 'package:latihan/View%20Model/user_view_model.dart';

import 'package:latihan/Widget/widget_tree.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
      ],
      builder: (context, widget) {
        return StreamProvider<FirebaseUser?>.value(
            value: AuthService().user,
            initialData: null,
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  appBarTheme: AppBarTheme(color: const Color(0xFFf8c46b)),
                  brightness: Brightness.light,
                  primaryColor: Colors.black,
                  buttonTheme: ButtonThemeData(
                    buttonColor: Colors.black,
                    textTheme: ButtonTextTheme.primary,
                    colorScheme: Theme.of(context)
                        .colorScheme
                        .copyWith(secondary: Colors.white),
                  ),
                  fontFamily: 'Georgia',
                  // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan[600]),
                ),
                home: Wrapper()));
      },
    );
  }
}

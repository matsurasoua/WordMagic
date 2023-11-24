import 'package:flutter/material.dart';
import 'package:word_magic/login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordMagic',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        // "/test2": (BuildContext context) => TestPage2(),
        // "/test3": (BuildContext context) => TestPage3(),
      },
    );
  }
}

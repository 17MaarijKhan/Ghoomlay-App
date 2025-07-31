import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_3/firebase_options.dart';
import 'package:flutter_application_3/pages/SignUp.dart';
import 'package:flutter_application_3/pages/add_page.dart';
import 'package:flutter_application_3/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghoomlay App',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: SignUp(),
    );
  }
}

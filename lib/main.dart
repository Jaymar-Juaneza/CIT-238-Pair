import 'package:flutter/material.dart';
import 'package:google_map_app/pages/google_map_page.dart';
import 'package:google_map_app/pages/land-page.dart';
import 'package:google_map_app/pages/login.dart';
import 'package:google_map_app/pages/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_map_app/pages/survey.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Google Maps App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/', // Set the initial route
        routes: {
          '/': (context) => const Landing(), // Landing page route
          '/register': (context) => const RegisterPage(),
          '/login': (context) => const Login(), 
          '/survey': (context) => const Survey(),
          '/land':(context) => const GoogleMapPage(),
        },
      );
}


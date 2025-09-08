import 'package:dpg_app/pages/welcome_page.dart';
import 'package:dpg_app/theme/light_mode.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taxi Chatbot',
      theme: lightMode,
      home: WelcomePage(),
    );
  }
}



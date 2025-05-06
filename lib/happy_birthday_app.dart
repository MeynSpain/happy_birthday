import 'package:flutter/material.dart';
import 'package:happy_birthday/home_page.dart';

class HappyBirthdayApp extends StatelessWidget {
  const HappyBirthdayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

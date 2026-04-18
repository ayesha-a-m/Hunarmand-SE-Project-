import 'package:flutter/material.dart';
import 'screens/splashscreen.dart';


void main() {
  runApp(const HunarmandApp());
}

class HunarmandApp extends StatelessWidget {
  const HunarmandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'landing_screen.dart';
import 'package:hunarmand/main.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Spacer(),

          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFF6F8F72), width: 2),
            ),
            child: const Center(
              child: Icon(Icons.spa, size: 50, color: Color(0xFF6F8F72)),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Hunarmand",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5A6E5A),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "دستکار بازار",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6F8F72),
            ),
          ),

          const Spacer(),

          const Text(
            "Empowering Women Artisans Across Pakistan",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Dot(active: true),
              Dot(active: false),
              Dot(active: false),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final bool active;
  const Dot({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? Color(0xFF6F8F72) : Colors.grey.shade400,
        shape: BoxShape.circle,
      ),
    );
  }
}
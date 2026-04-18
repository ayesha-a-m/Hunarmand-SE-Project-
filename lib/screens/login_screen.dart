import 'package:flutter/material.dart';
import 'customer_homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name = '';
  String email = '';
  String password = '';

  bool isRegister = true; // toggle login/register

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const SizedBox(height: 20),

              // 🔤 Title
              const Text(
                "Artisan Marketplace",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 5),

              const Text(
                "Discover handmade treasures",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              // 🔘 Toggle (Login/Register)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => isRegister = false);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isRegister ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(child: Text("Login")),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => isRegister = true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isRegister ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(child: Text("Register")),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 👤 Name (only in register)
              if (isRegister) ...[
                buildInput("Full Name", (val) => name = val),
                const SizedBox(height: 15),
              ],

              // 📧 Email
              buildInput("Email", (val) => email = val),
              const SizedBox(height: 15),

              // 🔒 Password
              buildInput("Password", (val) => password = val, isPassword: true),
              const SizedBox(height: 25),

              // ✅ Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A9B76),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const CustomerHomeScreen()),
                  );
                },
                child: Text(isRegister ? "Create Account" : "Login"),
              ),

              const SizedBox(height: 15),

              // 🔁 Switch text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isRegister
                        ? "Already have an account? "
                        : "Don't have an account? ",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => isRegister = !isRegister);
                    },
                    child: Text(
                      isRegister ? "Login" : "Register",
                      style: const TextStyle(
                        color: Color(0xFF7A9B76),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Supporting indigenous women artisans across Pakistan",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔧 Reusable input field
  Widget buildInput(String hint, Function(String) onChanged,
      {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F5F3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
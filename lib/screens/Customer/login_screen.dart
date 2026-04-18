import 'package:flutter/material.dart';
import 'customer_homescreen.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  bool isRegister = false;
  String name = '', email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── Back ───────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios,
                          size: 16, color: Colors.black54),
                      Text('Back',
                          style: TextStyle(
                              fontSize: 14, color: Colors.black54)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Icon ───────────────────────────────────
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEAF2EA),
                  border: Border.all(
                      color: const Color(0xFF7A9B76), width: 1.5),
                ),
                child: const Icon(Icons.shopping_bag_outlined,
                    size: 34, color: Color(0xFF7A9B76)),
              ),
              const SizedBox(height: 16),

              const Text(
                'Customer',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Browse and purchase handmade products',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // ── Toggle ─────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _toggleBtn('Login', !isRegister,
                        () => setState(() => isRegister = false)),
                    _toggleBtn('Register', isRegister,
                        () => setState(() => isRegister = true)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Fields ─────────────────────────────────
              if (isRegister) ...[
                _inputField('Full Name',
                    (v) => name = v),
                const SizedBox(height: 14),
              ],
              _inputField('Email',
                  (v) => email = v,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              _inputField('Password',
                  (v) => password = v,
                  isPassword: true),
              const SizedBox(height: 28),

              // ── Button ─────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CustomerHomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A9B76),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    isRegister ? 'Create Account' : 'Login',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Switch ─────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isRegister
                        ? 'Already have an account? '
                        : "Don't have an account? ",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () =>
                        setState(() => isRegister = !isRegister),
                    child: Text(
                      isRegister ? 'Login' : 'Register',
                      style: const TextStyle(
                        color: Color(0xFF7A9B76),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Supporting indigenous women artisans across Pakistan',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleBtn(
      String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight:
                    active ? FontWeight.w600 : FontWeight.normal,
                color:
                    active ? Colors.black87 : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String hint,
    Function(String) onChanged, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      obscureText: isPassword,
      onChanged: onChanged,
      keyboardType: keyboardType,
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
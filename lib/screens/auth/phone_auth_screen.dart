import 'package:flutter/material.dart';
import 'otp_screen.dart';
import '../../services/auth_service.dart';

class PhoneAuthScreen extends StatefulWidget {
  final String? preSelectedRole; // 'seller' or 'customer'
  const PhoneAuthScreen({super.key, this.preSelectedRole});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final raw = _phoneController.text.trim();

    if (raw.isEmpty) {
      setState(() => _errorMessage = 'Please enter your phone number.');
      return;
    }

    String phone = raw;
    if (!phone.startsWith('+')) {
      phone = raw.startsWith('0') ? '+92${raw.substring(1)}' : '+92$raw';
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await AuthService.sendOtp(
      phoneNumber: phone,
      onCodeSent: (verificationId) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(
              phoneNumber: phone,
              verificationId: verificationId,
              preSelectedRole: widget.preSelectedRole,
            ),
          ),
        );
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = error;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color(0xFF6F8F72), width: 2),
                  ),
                  child: const Icon(Icons.spa,
                      size: 40, color: Color(0xFF6F8F72)),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'Hunarmand',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5A6E5A),
                  ),
                ),
              ),

              const Center(
                child: Text(
                  'دستکار بازار',
                  style: TextStyle(
                      fontSize: 16, color: Color(0xFF6F8F72)),
                ),
              ),

              const SizedBox(height: 50),

              const Text(
                'Enter your phone number',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "We'll send a verification code via SMS.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 24),

              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '03XX XXXXXXX',
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    child: const Text(
                      '🇵🇰 +92',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(_errorMessage!,
                    style:
                    const TextStyle(color: Colors.red, fontSize: 13)),
              ],

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A9B76),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isLoading ? null : _sendOtp,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Send OTP',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Center(
                child: Text(
                  'Empowering Women Artisans Across Pakistan',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
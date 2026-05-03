import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/splashscreen.dart';
import 'screens/auth/phone_auth_screen.dart';
import 'screens/auth/profile_setup_screen.dart';
import 'screens/customer/customer_homescreen.dart';
import 'screens/seller/seller_dashboard.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HunarmandApp());
}

class HunarmandApp extends StatelessWidget {
  const HunarmandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hunarmand',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7A9B76),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── Auth Gate ────────────────────────────────────────────────────────────────
// Placed after splash — routes user based on auth state + role
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Not logged in → Phone auth
        if (!snapshot.hasData || snapshot.data == null) {
          return const PhoneAuthScreen();
        }

        // Logged in → check profile completeness
        return FutureBuilder<bool>(
          future: AuthService.isProfileComplete(snapshot.data!.uid),
          builder: (context, profileSnap) {
            if (profileSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // First time login → profile setup
            if (profileSnap.data != true) {
              return const ProfileSetupScreen();
            }

            // Profile done → route by role
            return FutureBuilder<Map<String, dynamic>?>(
              future: AuthService.getUserProfile(snapshot.data!.uid),
              builder: (context, userSnap) {
                if (userSnap.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                final role = userSnap.data?['role'] ?? 'customer';
                if (role == 'seller') return const SellerDashboardScreen();
                return const CustomerHomeScreen();
              },
            );
          },
        );
      },
    );
  }
}
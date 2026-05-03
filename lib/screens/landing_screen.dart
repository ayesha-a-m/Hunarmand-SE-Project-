import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth/phone_auth_screen.dart';
import 'Seller/seller_dashboard.dart';
import 'Customer/customer_homescreen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  // Check if user is already logged in and route accordingly
  Future<void> _handleRoleTap(BuildContext context, String role) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Already logged in — update role and route directly
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'role': role});

      if (!context.mounted) return;
      if (role == 'seller') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SellerDashboardScreen()),
              (_) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
              (_) => false,
        );
      }
    } else {
      // Not logged in — go to phone auth with role pre-selected
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PhoneAuthScreen(preSelectedRole: role),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5EF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Logo ─────────────────────────────────────
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                      color: const Color(0xFF7A9B76), width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7A9B76).withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.spa,
                    size: 48, color: Color(0xFF7A9B76)),
              ),
              const SizedBox(height: 24),

              // ── Title ─────────────────────────────────────
              const Text(
                'Hunarmand',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D5A3E),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'دستکار بازار',
                style: TextStyle(fontSize: 18, color: Color(0xFF7A9B76)),
              ),
              const SizedBox(height: 10),
              const Text(
                'Empowering women artisans across Pakistan',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),

              const Spacer(flex: 2),

              // ── Section label ──────────────────────────────
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Continue as',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ── Customer card ──────────────────────────────
              _RoleCard(
                icon: Icons.shopping_bag_outlined,
                title: 'Customer',
                subtitle: 'Browse & buy handmade products',
                bullets: const [
                  'Browse artisan products',
                  'Search by category',
                  'Contact sellers directly',
                ],
                onTap: () => _handleRoleTap(context, 'customer'),
              ),

              const SizedBox(height: 14),

              // ── Seller card ────────────────────────────────
              _RoleCard(
                icon: Icons.storefront_outlined,
                title: 'Seller',
                subtitle: 'List & manage your products',
                bullets: const [
                  'Add & manage products',
                  'Post training courses',
                  'Track your orders',
                ],
                onTap: () => _handleRoleTap(context, 'seller'),
              ),

              const Spacer(flex: 2),

              // ── Footer ─────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Supporting indigenous women artisans  ',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text('🇵🇰', style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable role card ─────────────────────────────────────────────────────────
class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> bullets;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.bullets,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2EA),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 26, color: const Color(0xFF7A9B76)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      )),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54)),
                  const SizedBox(height: 10),
                  ...bullets.map(
                        (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFF7A9B76),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(b,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
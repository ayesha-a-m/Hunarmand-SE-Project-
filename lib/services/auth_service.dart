import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Current user ───────────────────────────────────────────────────────────
  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─── Send OTP ────────────────────────────────────────────────────────────────
  /// Sends an SMS OTP to [phoneNumber] (must include country code, e.g. +923001234567).
  /// [onCodeSent] receives the verificationId to be used later.
  /// [onError] receives a human-readable error message.
  static Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
    void Function()? onAutoVerified,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),

      // Auto-retrieval (Android only) — OTP filled automatically
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        onAutoVerified?.call();
      },

      verificationFailed: (FirebaseAuthException e) {
        String msg = 'Verification failed. Please try again.';
        if (e.code == 'invalid-phone-number') {
          msg = 'Invalid phone number. Include country code (e.g. +92...).';
        } else if (e.code == 'too-many-requests') {
          msg = 'Too many requests. Please wait before trying again.';
        }
        onError(msg);
      },

      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        // Timeout — user must manually enter OTP
      },
    );
  }

  // ─── Verify OTP ──────────────────────────────────────────────────────────────
  /// Returns null on success, or an error message string on failure.
  static Future<String?> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      return null; // success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        return 'Invalid OTP. Please check and try again.';
      } else if (e.code == 'session-expired') {
        return 'OTP expired. Please request a new one.';
      }
      return 'Something went wrong. Please try again.';
    }
  }

  // ─── Save / update user profile in Firestore ─────────────────────────────────
  /// Call this after OTP verification to persist extra user info.
  /// [role] must be either "seller" or "customer".
  static Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String phone,
    required String role, // "seller" or "customer"
    String? city,
    String? bio,
  }) async {
    final data = {
      'uid': uid,
      'name': name,
      'phone': phone,
      'role': role,
      'city': city ?? '',
      'bio': bio ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  // ─── Fetch user profile ───────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  // ─── Check if profile is complete ────────────────────────────────────────────
  /// Returns true if the user has a saved name and role in Firestore.
  static Future<bool> isProfileComplete(String uid) async {
    final profile = await getUserProfile(uid);
    return profile != null &&
        (profile['name'] as String?)?.isNotEmpty == true &&
        (profile['role'] as String?)?.isNotEmpty == true;
  }

  // ─── Sign out ─────────────────────────────────────────────────────────────────
  static Future<void> signOut() async {
    await _auth.signOut();
  }
}
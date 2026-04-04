import 'package:crypto/crypto.dart';
import 'package:bcrypt/bcrypt.dart';
import 'dart:convert';
import 'dart:math';

class EncryptionService {

  // ── PASSWORD HASHING (BCrypt) ──────────────────────────────
  // ✅ BCrypt is the gold standard for password hashing
  // It's slow by design — prevents brute force attacks

  static String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt(logRounds: 12));
  }

  static bool verifyPassword(String plainPassword, String hashedPassword) {
    try {
      return BCrypt.checkpw(plainPassword, hashedPassword);
    } catch (e) {
      return false;
    }
  }

  // ── OTP HASHING (SHA-256) ──────────────────────────────────
  // ✅ Fast hash — good for short-lived OTPs

  static String hashOtp(String otp) {
    return sha256.convert(utf8.encode(otp)).toString();
  }

  static bool verifyOtp(String enteredOtp, String storedHash) {
    return hashOtp(enteredOtp) == storedHash;
  }

  // ── TOKEN GENERATION ───────────────────────────────────────
  // ✅ Generates secure random tokens for reset links etc.

  static String generateSecureToken({int length = 32}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(length, (i) => chars[random.nextInt(chars.length)]).join();
  }

  // ── OTP GENERATION ─────────────────────────────────────────
  // ✅ Cryptographically secure 6-digit OTP

  static String generateOtp() {
    final random = Random.secure();
    final otp = random.nextInt(900000) + 100000; // Always 6 digits
    return otp.toString();
  }

  // ── DATA MASKING (For Display) ─────────────────────────────
  // ✅ Masks sensitive data for UI display

  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return '**@$domain';
    return '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}@$domain';
  }

  static String maskPhone(String phone) {
    if (phone.length < 4) return '****';
    return '${'*' * (phone.length - 4)}${phone.substring(phone.length - 4)}';
  }

  // ── STRING HASHING (General Purpose) ──────────────────────
  // ✅ SHA-256 for general data integrity checks

  static String hashString(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  // ── HMAC (For Webhook Verification etc.) ──────────────────
  // ✅ Used to verify data hasn't been tampered with

  static String generateHmac(String data, String secret) {
    final key = utf8.encode(secret);
    final bytes = utf8.encode(data);
    final hmac = Hmac(sha256, key);
    return hmac.convert(bytes).toString();
  }

  static bool verifyHmac(String data, String secret, String expectedHmac) {
    return generateHmac(data, secret) == expectedHmac;
  }
}
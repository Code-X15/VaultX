import 'dart:math';
import 'package:flutter/material.dart';

class PasswordGenerator {
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _digits = '0123456789';
  static const String _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
  static const String _ambiguous = 'l1O0';

  static String generate({
    int length = 16,
    bool useLowercase = true,
    bool useUppercase = true,
    bool useDigits = true,
    bool useSymbols = true,
    bool avoidAmbiguous = false,
  }) {
    String chars = '';
    if (useLowercase) {
      chars += avoidAmbiguous
          ? _lowercase.replaceAll(RegExp('[$_ambiguous]'), '')
          : _lowercase;
    }
    if (useUppercase) {
      chars += avoidAmbiguous
          ? _uppercase.replaceAll(RegExp('[$_ambiguous]'), '')
          : _uppercase;
    }
    if (useDigits) {
      chars += avoidAmbiguous
          ? _digits.replaceAll(RegExp('[$_ambiguous]'), '')
          : _digits;
    }
    if (useSymbols) chars += _symbols;
    if (chars.isEmpty) chars = _lowercase + _digits;

    final rand = Random.secure();
    final buffer = StringBuffer();

    // Guarantee at least one of each selected type
    if (useLowercase && chars.contains(RegExp('[a-z]'))) {
      final pool = avoidAmbiguous
          ? _lowercase.replaceAll(RegExp('[$_ambiguous]'), '')
          : _lowercase;
      buffer.write(pool[rand.nextInt(pool.length)]);
    }
    if (useUppercase && chars.contains(RegExp('[A-Z]'))) {
      final pool = avoidAmbiguous
          ? _uppercase.replaceAll(RegExp('[$_ambiguous]'), '')
          : _uppercase;
      buffer.write(pool[rand.nextInt(pool.length)]);
    }
    if (useDigits) {
      final pool = avoidAmbiguous
          ? _digits.replaceAll(RegExp('[$_ambiguous]'), '')
          : _digits;
      buffer.write(pool[rand.nextInt(pool.length)]);
    }
    if (useSymbols) {
      buffer.write(_symbols[rand.nextInt(_symbols.length)]);
    }

    while (buffer.length < length) {
      buffer.write(chars[rand.nextInt(chars.length)]);
    }

    // Shuffle
    final list = buffer.toString().split('');
    list.shuffle(rand);
    return list.take(length).join();
  }

  static double strengthScore(String password) {
    double score = 0;
    if (password.length >= 8) score += 0.2;
    if (password.length >= 12) score += 0.2;
    if (password.length >= 16) score += 0.1;
    if (password.contains(RegExp(r'[A-Z]'))) score += 0.1;
    if (password.contains(RegExp(r'[a-z]'))) score += 0.1;
    if (password.contains(RegExp(r'[0-9]'))) score += 0.15;
    if (password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'))) {
      score += 0.15;
    }
    return score.clamp(0.0, 1.0);
  }

  static String strengthLabel(double score) {
    if (score < 0.3) return 'Weak';
    if (score < 0.5) return 'Fair';
    if (score < 0.75) return 'Strong';
    return 'Very Strong';
  }

  static Color strengthColor(double score) {
    if (score < 0.3) return const Color(0xFFE53935);
    if (score < 0.5) return const Color(0xFFFF9800);
    if (score < 0.75) return const Color(0xFF4CAF50);
    return const Color(0xFF00BCD4);
  }
}

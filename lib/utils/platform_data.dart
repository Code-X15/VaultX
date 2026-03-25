import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlatformInfo {
  final String name;
  final IconData icon;
  final Color color;
  final String hint;
  final String category;

  const PlatformInfo({
    required this.name,
    required this.icon,
    required this.color,
    required this.hint,
    required this.category,
  });
}

class PlatformData {
  static const Map<String, PlatformInfo> all = {
    'Google': PlatformInfo(
      name: 'Google',
      icon: FontAwesomeIcons.google,
      color: Color(0xFFEA4335),
      hint: 'yourname@gmail.com',
      category: 'Productivity',
    ),
    'Facebook': PlatformInfo(
      name: 'Facebook',
      icon: FontAwesomeIcons.facebook,
      color: Color(0xFF1877F2),
      hint: 'yourname@facebook.com',
      category: 'Social',
    ),
    'Instagram': PlatformInfo(
      name: 'Instagram',
      icon: FontAwesomeIcons.instagram,
      color: Color(0xFFE1306C),
      hint: '@yourusername',
      category: 'Social',
    ),
    'Twitter / X': PlatformInfo(
      name: 'Twitter / X',
      icon: FontAwesomeIcons.xTwitter,
      color: Color(0xFFFFFFFF),
      hint: '@yourusername',
      category: 'Social',
    ),
    'LinkedIn': PlatformInfo(
      name: 'LinkedIn',
      icon: FontAwesomeIcons.linkedin,
      color: Color(0xFF0A66C2),
      hint: 'yourname@email.com',
      category: 'Professional',
    ),
    'TikTok': PlatformInfo(
      name: 'TikTok',
      icon: FontAwesomeIcons.tiktok,
      color: Color(0xFF69C9D0),
      hint: '@yourusername',
      category: 'Social',
    ),
    'Snapchat': PlatformInfo(
      name: 'Snapchat',
      icon: FontAwesomeIcons.snapchat,
      color: Color(0xFFFFFC00),
      hint: 'yourusername',
      category: 'Social',
    ),
    'YouTube': PlatformInfo(
      name: 'YouTube',
      icon: FontAwesomeIcons.youtube,
      color: Color(0xFFFF0000),
      hint: 'yourname@gmail.com',
      category: 'Entertainment',
    ),
    'WhatsApp': PlatformInfo(
      name: 'WhatsApp',
      icon: FontAwesomeIcons.whatsapp,
      color: Color(0xFF25D366),
      hint: '+1234567890',
      category: 'Messaging',
    ),
    'GitHub': PlatformInfo(
      name: 'GitHub',
      icon: FontAwesomeIcons.github,
      color: Color(0xFFFFFFFF),
      hint: 'yourusername',
      category: 'Developer',
    ),
    'Discord': PlatformInfo(
      name: 'Discord',
      icon: FontAwesomeIcons.discord,
      color: Color(0xFF5865F2),
      hint: 'yourusername',
      category: 'Messaging',
    ),
    'Pinterest': PlatformInfo(
      name: 'Pinterest',
      icon: FontAwesomeIcons.pinterest,
      color: Color(0xFFE60023),
      hint: 'yourusername',
      category: 'Social',
    ),
    'Reddit': PlatformInfo(
      name: 'Reddit',
      icon: FontAwesomeIcons.reddit,
      color: Color(0xFFFF4500),
      hint: 'u/yourusername',
      category: 'Social',
    ),
    'Spotify': PlatformInfo(
      name: 'Spotify',
      icon: FontAwesomeIcons.spotify,
      color: Color(0xFF1DB954),
      hint: 'yourname@email.com',
      category: 'Entertainment',
    ),
    'Twitch': PlatformInfo(
      name: 'Twitch',
      icon: FontAwesomeIcons.twitch,
      color: Color(0xFF9146FF),
      hint: 'yourusername',
      category: 'Entertainment',
    ),
    'Apple': PlatformInfo(
      name: 'Apple',
      icon: FontAwesomeIcons.apple,
      color: Color(0xFFFFFFFF),
      hint: 'yourname@icloud.com',
      category: 'Productivity',
    ),
    'Microsoft': PlatformInfo(
      name: 'Microsoft',
      icon: FontAwesomeIcons.microsoft,
      color: Color(0xFF00A4EF),
      hint: 'yourname@outlook.com',
      category: 'Productivity',
    ),
    'Telegram': PlatformInfo(
      name: 'Telegram',
      icon: FontAwesomeIcons.telegram,
      color: Color(0xFF26A5E4),
      hint: '@yourusername',
      category: 'Messaging',
    ),
    'Other': PlatformInfo(
      name: 'Other',
      icon: FontAwesomeIcons.lock,
      color: Color(0xFFE53935),
      hint: 'yourname@email.com',
      category: 'Other',
    ),
  };

  static PlatformInfo getInfo(String platform) =>
      all[platform] ?? all['Other']!;

  static List<String> get names => all.keys.toList();

  static List<String> get categories =>
      all.values.map((e) => e.category).toSet().toList()..sort();
}

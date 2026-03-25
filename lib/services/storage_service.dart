import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/password_entry.dart';

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  static const String _key = 'sv_password_entries';

  static Future<List<PasswordEntry>> getAll() async {
    try {
      final data = await _storage.read(key: _key);
      if (data == null || data.isEmpty) return [];
      final List<dynamic> list = jsonDecode(data);
      return list
          .map((e) => PasswordEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<bool> save(PasswordEntry entry) async {
    try {
      final entries = await getAll();
      entries.removeWhere((e) => e.id == entry.id);
      entries.add(entry);
      await _storage.write(
        key: _key,
        value: jsonEncode(entries.map((e) => e.toJson()).toList()),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> delete(String id) async {
    try {
      final entries = await getAll();
      entries.removeWhere((e) => e.id == id);
      await _storage.write(
        key: _key,
        value: jsonEncode(entries.map((e) => e.toJson()).toList()),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> deleteAll() async {
    try {
      await _storage.delete(key: _key);
      return true;
    } catch (_) {
      return false;
    }
  }
}

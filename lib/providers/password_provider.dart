import 'package:flutter/foundation.dart';
import '../models/password_entry.dart';
import '../services/storage_service.dart';

class PasswordProvider extends ChangeNotifier {
  List<PasswordEntry> _entries = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<PasswordEntry> get entries => _filtered;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  int get totalCount => _entries.length;

  List<PasswordEntry> get _filtered {
    if (_searchQuery.isEmpty) {
      return List.from(_entries)
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
    final q = _searchQuery.toLowerCase();
    return _entries
        .where(
          (e) =>
              e.platform.toLowerCase().contains(q) ||
              e.email.toLowerCase().contains(q) ||
              (e.username?.toLowerCase().contains(q) ?? false),
        )
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _entries = await StorageService.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> save(PasswordEntry entry) async {
    final result = await StorageService.save(entry);
    if (result) {
      _entries.removeWhere((e) => e.id == entry.id);
      _entries.add(entry);
      notifyListeners();
    }
    return result;
  }

  Future<bool> delete(String id) async {
    final result = await StorageService.delete(id);
    if (result) {
      _entries.removeWhere((e) => e.id == id);
      notifyListeners();
    }
    return result;
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  Map<String, List<PasswordEntry>> get groupedByPlatform {
    final Map<String, List<PasswordEntry>> map = {};
    for (final e in _entries) {
      map.putIfAbsent(e.platform, () => []).add(e);
    }
    return map;
  }
}

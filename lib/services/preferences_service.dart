import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Service for persistent app preferences and settings (file-based, no external deps)
class PreferencesService {
  PreferencesService._();
  static final instance = PreferencesService._();

  late File _prefsFile;
  late Map<String, dynamic> _cache;

  /// Initialize preferences service (call once at app startup)
  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    _prefsFile = File(p.join(appDir.path, 'axiom_data', 'preferences.json'));

    // Ensure directory exists
    await _prefsFile.parent.create(recursive: true);

    // Load existing preferences
    if (await _prefsFile.exists()) {
      try {
        final contents = await _prefsFile.readAsString();
        _cache = Map<String, dynamic>.from(
          jsonDecode(contents) as Map<String, dynamic>,
        );
      } catch (_) {
        _cache = {};
      }
    } else {
      _cache = {};
    }
  }

  /// Persist cache to disk
  Future<void> _save() async {
    await _prefsFile.writeAsString(jsonEncode(_cache));
  }

  /// Get a string value
  Future<String?> getString(String key) async {
    return _cache[key] as String?;
  }

  /// Set a string value
  Future<bool> setString(String key, String value) async {
    _cache[key] = value;
    await _save();
    return true;
  }

  /// Get a boolean value
  Future<bool?> getBool(String key) async {
    return _cache[key] as bool?;
  }

  /// Set a boolean value
  Future<bool> setBool(String key, bool value) async {
    _cache[key] = value;
    await _save();
    return true;
  }

  /// Get an integer value
  Future<int?> getInt(String key) async {
    final val = _cache[key];
    if (val is int) return val;
    if (val is String) return int.tryParse(val);
    return null;
  }

  /// Set an integer value
  Future<bool> setInt(String key, int value) async {
    _cache[key] = value;
    await _save();
    return true;
  }

  /// Remove a value
  Future<bool> remove(String key) async {
    _cache.remove(key);
    await _save();
    return true;
  }

  /// Clear all preferences
  Future<bool> clear() async {
    _cache.clear();
    await _save();
    return true;
  }
}

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';

/// Singleton service for storing and retrieving application settings.
/// Settings are persisted to ~/axiom_data/settings.json
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();

  factory SettingsService() {
    return _instance;
  }

  SettingsService._internal();

  static SettingsService get instance => _instance;

  Map<String, dynamic>? _cache;
  late Directory _dataDir;
  bool _initialized = false;

  /// Initialize the settings service and load existing settings.
  Future<void> initialize() async {
    if (_initialized) return;

    final appSupport = await getApplicationSupportDirectory();
    _dataDir = Directory(path.join(appSupport.path, 'axiom_data'));
    if (!_dataDir.existsSync()) {
      _dataDir.createSync(recursive: true);
    }

    _cache = {};
    await _loadSettings();
    _initialized = true;
  }

  /// Load settings from disk into memory.
  Future<void> _loadSettings() async {
    try {
      final file = File(path.join(_dataDir.path, 'settings.json'));
      if (file.existsSync()) {
        final content = await file.readAsString();
        _cache = Map<String, dynamic>.from(jsonDecode(content));
      } else {
        _cache = {};
      }
    } catch (e) {
      print('Error loading settings: $e');
      _cache = {};
    }
  }

  /// Save all settings to disk.
  Future<void> _saveSettings() async {
    try {
      final file = File(path.join(_dataDir.path, 'settings.json'));
      await file.writeAsString(jsonEncode(_cache));
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  /// Get a setting value by key.
  Future<dynamic> get(String key) async {
    if (!_initialized) await initialize();
    return _cache?[key];
  }

  /// Set a setting value by key.
  Future<void> set(String key, dynamic value) async {
    if (!_initialized) await initialize();
    _cache?[key] = value;
    await _saveSettings();
  }

  /// Remove a setting by key.
  Future<void> remove(String key) async {
    if (!_initialized) await initialize();
    _cache?.remove(key);
    await _saveSettings();
  }

  /// Get all settings.
  Future<Map<String, dynamic>> getAll() async {
    if (!_initialized) await initialize();
    return Map<String, dynamic>.from(_cache ?? {});
  }

  /// Clear all settings.
  Future<void> clear() async {
    if (!_initialized) await initialize();
    _cache?.clear();
    await _saveSettings();
  }

  /// Get a setting with a default fallback.
  Future<T> getOrDefault<T>(String key, T defaultValue) async {
    final value = await get(key);
    return (value != null) ? value as T : defaultValue;
  }

  /// Check if a setting exists.
  Future<bool> has(String key) async {
    if (!_initialized) await initialize();
    return _cache?.containsKey(key) ?? false;
  }
}

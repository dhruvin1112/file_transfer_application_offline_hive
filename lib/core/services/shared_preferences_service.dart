import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  static Future<SharedPreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesService(prefs);
  }

  // Onboarding
  bool get isOnboardingCompleted =>
      _prefs.getBool(StorageKeys.onboardingCompleted) ?? false;

  Future<bool> setOnboardingCompleted(bool completed) =>
      _prefs.setBool(StorageKeys.onboardingCompleted, completed);

  // Device Custom Name
  String? get deviceCustomName =>
      _prefs.getString(StorageKeys.deviceCustomName);

  Future<bool> setDeviceCustomName(String name) =>
      _prefs.setString(StorageKeys.deviceCustomName, name);

  // Auto-Accept Transfers Setting
  bool get autoAcceptTransfers =>
      _prefs.getBool(StorageKeys.autoAcceptTransfers) ?? false;

  Future<bool> setAutoAcceptTransfers(bool value) =>
      _prefs.setBool(StorageKeys.autoAcceptTransfers, value);

  // Custom Save Directory
  String? get saveDirectoryPath =>
      _prefs.getString(StorageKeys.saveDirectoryPath);

  Future<bool> setSaveDirectoryPath(String path) =>
      _prefs.setString(StorageKeys.saveDirectoryPath, path);

  // Transferred Bytes Counter
  int get totalTransferredBytes =>
      _prefs.getInt(StorageKeys.totalTransferredBytes) ?? 0;

  Future<bool> incrementTransferredBytes(int bytes) {
    final current = totalTransferredBytes;
    return _prefs.setInt(StorageKeys.totalTransferredBytes, current + bytes);
  }

  // Clear all preferences
  Future<bool> clearAll() => _prefs.clear();
}

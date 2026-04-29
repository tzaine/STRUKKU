// lib/core/services/preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyUserName = 'user_name';
  static const String _keyOnboardingDone = 'onboarding_done';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static Future<PreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  // ─── User Name ─────────────────────────────────────────────────────────────
  String? get userName => _prefs.getString(_keyUserName);

  Future<void> setUserName(String name) async {
    await _prefs.setString(_keyUserName, name);
  }

  // ─── Onboarding ────────────────────────────────────────────────────────────
  bool get isOnboardingDone => _prefs.getBool(_keyOnboardingDone) ?? false;

  Future<void> completeOnboarding() async {
    await _prefs.setBool(_keyOnboardingDone, true);
  }

  Future<void> reset() async {
    await _prefs.clear();
  }
}

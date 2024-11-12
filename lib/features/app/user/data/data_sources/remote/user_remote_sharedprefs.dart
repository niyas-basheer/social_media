import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  // Keys for SharedPreferences
  static const String _keyUid = 'uid';
  static const String _keyPhoneNumber = 'phone_number';

  // Save UID
  Future<void> saveUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUid, uid);
  }

  // Get UID
  Future<String?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUid);
  }

  // Save Phone Number
  Future<void> savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhoneNumber, phoneNumber);
  }

  // Get Phone Number
  Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhoneNumber);
  }

  // Remove UID
  Future<void> removeUid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUid);
  }

  // Remove Phone Number
  Future<void> removePhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPhoneNumber);
  }

  // Clear All Preferences
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

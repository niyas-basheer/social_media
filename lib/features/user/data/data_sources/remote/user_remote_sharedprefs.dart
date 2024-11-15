import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
 
  static const String _keyUid = 'uid';
  static const String _keyPhoneNumber = 'phone_number';
  static const String _signInStatusKey = 'isSignedIn';

  Future<void> saveSignInStatus(bool isSignedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_signInStatusKey, isSignedIn);
  }


  Future<bool> getSignInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_signInStatusKey) ?? false;
  }


  Future<void> clearSignInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_signInStatusKey);
  }

  
  Future<void> saveUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUid, uid);
  }

 
  Future<String?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUid);
  }

 
  Future<void> savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhoneNumber, phoneNumber);
  }

  
  Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhoneNumber);
  }

 
  Future<void> removeUid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUid);
  }

  
  Future<void> removePhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPhoneNumber);
  }

  
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

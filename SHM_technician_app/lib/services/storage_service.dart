import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class StorageService {
  static Future<void> saveTechnicianData({
    required String id,
    required String name,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.storageTechnicianId, id);
    await prefs.setString(AppConstants.storageTechnicianName, name);
    await prefs.setString(AppConstants.storageTechnicianPhone, phone);
    await prefs.setBool(AppConstants.storageIsLoggedIn, true);
  }

  static Future<Map<String, String?>> getTechnicianData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString(AppConstants.storageTechnicianId),
      'name': prefs.getString(AppConstants.storageTechnicianName),
      'phone': prefs.getString(AppConstants.storageTechnicianPhone),
    };
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.storageIsLoggedIn) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.storageTechnicianId);
    await prefs.remove(AppConstants.storageTechnicianName);
    await prefs.remove(AppConstants.storageTechnicianPhone);
    await prefs.setBool(AppConstants.storageIsLoggedIn, false);
  }
}


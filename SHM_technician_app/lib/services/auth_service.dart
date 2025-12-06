import 'package:shared_preferences/shared_preferences.dart';
import '../models/technician_model.dart';

class AuthService {
  static const String _keyTechnicianId = 'technician_id';
  static const String _keyTechnicianName = 'technician_name';
  static const String _keyTechnicianPhone = 'technician_phone';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // حفظ بيانات تسجيل الدخول
  static Future<void> saveLogin(Technician technician) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyTechnicianId, technician.id);
    await prefs.setString(_keyTechnicianName, technician.name);
    await prefs.setString(_keyTechnicianPhone, technician.phone);
  }

  // جلب بيانات الفني المحفوظة
  static Future<Technician?> getSavedTechnician() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    
    if (!isLoggedIn) return null;

    final id = prefs.getString(_keyTechnicianId);
    final name = prefs.getString(_keyTechnicianName);
    final phone = prefs.getString(_keyTechnicianPhone);

    if (id != null && name != null && phone != null) {
      return Technician(id: id, name: name, phone: phone);
    }

    return null;
  }

  // التحقق من حالة تسجيل الدخول
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // تسجيل الخروج
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyTechnicianId);
    await prefs.remove(_keyTechnicianName);
    await prefs.remove(_keyTechnicianPhone);
  }
}


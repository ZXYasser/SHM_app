import 'package:flutter/foundation.dart';

class AppConstants {
  // ================================
  // 🔧 API Configuration
  // ================================

  /// تحديد URL حسب المنصة
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    } else {
      return 'http://10.202.97.38:3000';
    }
  }

  // Endpoints
  static const String technicianLoginEndpoint = '/technician-login';
  static const String requestsEndpoint = '/requests';
  static const String updateRequestEndpoint = '/requests';

  // ================================
  // 🎨 App Colors
  // ================================
  static const int primaryColorValue = 0xFF00A65A;

  // ================================
  // ℹ App Info
  // ================================
  static const String appName = 'سهم - الفنيين';
  static const String appTagline = 'لوحة تحكم الفني';

  // ================================
  // 📱 Storage Keys
  // ================================
  static const String storageTechnicianId = 'technician_id';
  static const String storageTechnicianName = 'technician_name';
  static const String storageTechnicianPhone = 'technician_phone';
  static const String storageIsLoggedIn = 'is_logged_in';
}

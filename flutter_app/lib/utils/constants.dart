import 'package:flutter/foundation.dart';

class AppConstants {
  // ================================
  // 🔧 API Configuration
  // ================================

  /// تحديد URL حسب المنصة
  /// - Web: يستخدم localhost (لأن المتصفح لا يمكنه الوصول لـ IP محلي مباشرة)
  /// - Mobile/Desktop: يستخدم IP الشبكة
  static String get baseUrl {
    if (kIsWeb) {
      // Flutter Web - استخدم localhost
      return 'http://localhost:3000';
    } else {
      // Mobile/Desktop - استخدم IP الشبكة
      return 'http://10.202.97.38:3000';
    }
  }

  /// (اختياري) في حال تشغيل التطبيق على المحاكي Android
  // static const String baseUrl = 'http://10.0.2.2:3000';

  // Endpoints
  static const String newRequestEndpoint = '/new-request';
  static const String requestsEndpoint = '/requests';

  // ================================
  // 🎨 App Colors
  // ================================
  static const int primaryColorValue = 0xFF00A65A;

  // ================================
  // ℹ App Info
  // ================================
  static const String appName = 'سهم';
  static const String appTagline = 'نوصلك للحل';

  // ================================
  // 🛠 Services
  // ================================
  static const String serviceTire = 'بنشر متنقل';
  static const String serviceBattery = 'بطارية متنقلة';
}

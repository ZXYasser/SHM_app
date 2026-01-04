class AppConstants {
  // ================================
  // 🔧 API Configuration
  // ================================

  /// تحديد URL حسب المنصة
  /// Railway URL - يعمل على جميع المنصات
  static String get baseUrl {
    return 'https://shmapp-production.up.railway.app';
  }

  /// (اختياري) في حال تشغيل التطبيق على المحاكي Android
  // static const String baseUrl = 'http://10.0.2.2:3000';

  // Endpoints
  static const String newRequestEndpoint = '/new-request';
  static const String requestsEndpoint = '/requests';

  // ================================
  // 🎨 App Colors
  // ================================
  static const int primaryColorValue = 0xFF42A5F5; // أزرق فاتح

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
  static const String serviceElectrical = 'خلل كهربائي';
  static const String serviceOther = 'خلل آخر';
  static const String serviceAC = 'إصلاح تكييف';
  static const String serviceOil = 'تغيير زيت';
  static const String serviceMechanic = 'ميكانيكا';
  static const String serviceKey = 'مفتاح';
}

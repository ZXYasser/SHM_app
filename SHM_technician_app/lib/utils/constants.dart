class AppConstants {
  // ================================
  // 🔧 API Configuration
  // ================================

  /// تحديد URL حسب المنصة
  /// Railway URL - يعمل على جميع المنصات
  static String get baseUrl {
    return 'https://shmapp-production.up.railway.app';
  }

  // Endpoints
  static const String technicianLoginEndpoint = '/technician-login';
  static const String requestsEndpoint = '/requests';
  static const String updateRequestEndpoint = '/requests';

  // ================================
  // 🎨 App Colors
  // ================================
  static const int primaryColorValue = 0xFF42A5F5; // أزرق فاتح

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

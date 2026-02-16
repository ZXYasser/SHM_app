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
  static const String updateRequestEndpoint = '/requests';

  // ================================
  // 🎨 App Colors
  // ================================
  static const int primaryColorValue = 0xFF42A5F5; // أزرق فاتح

  // ================================
  // ℹ App Info
  // ================================
  static const String appName = 'سهم';
  static const String appTagline = 'نوصلك للحل';

  /// للعرض في الشروط وسياسة الاسترجاع — املأها عند التوفر
  static const String supportEmail = ''; // مثال: support@shm.sa
  static const String supportPhone = ''; // مثال: 0500000000
  static const String supportWebsite = ''; // مثال: https://shm.sa

  // ================================
  // 🛠 Services
  // ================================
  static const String serviceTire = 'بنزيـن ';
  static const String serviceBattery = 'بطاريـة ';
  static const String serviceElectrical = 'خلل كهربائي';
  static const String serviceOther = 'خلل آخر';
  static const String serviceAC = 'إصلاح تكييف';
  static const String serviceOil = 'تغيير زيت';
  static const String serviceMechanic = 'ميكانيكا';
  static const String serviceKey = 'مفتـاح';

  // خدمات إضافية
  static const String serviceTireChange = 'تغيير إطارات';
  static const String serviceFullInspection = 'فحص شامل';
  static const String serviceTow = 'خدمة السحب';

  // خدمات متميزة
  static const String serviceSubscription = 'اشتراك شهري/سنوي';
  static const String serviceLoyalty = 'برنامج نقاط الولاء';
  static const String serviceDiscount = 'خصومات للعملاء المتكرن';
  static const String serviceVIP = 'خدمة VIP';

  // ================================
  // 💰 Service Prices
  // ================================
  /// Map للتسعيرات - price: السعر بالريال، isVariable: true إذا كان السعر متغير
  static Map<String, Map<String, dynamic>> get servicePrices => {
    serviceTire: {'price': 50, 'isVariable': false},
    serviceBattery: {'price': 80, 'isVariable': false},
    serviceElectrical: {'price': 100, 'isVariable': false},
    serviceAC: {'price': 120, 'isVariable': false},
    serviceOil: {'price': null, 'isVariable': true}, // متغير حسب الكمية
    serviceMechanic: {'price': 150, 'isVariable': false},
    serviceKey: {'price': 80, 'isVariable': false},
    serviceOther: {'price': 100, 'isVariable': false},
    serviceTireChange: {'price': null, 'isVariable': true}, // متغير حسب الكمية
    serviceFullInspection: {'price': 120, 'isVariable': false},
    serviceTow: {'price': 150, 'isVariable': false},
  };

  /// الحصول على سعر الخدمة
  static int? getServicePrice(String serviceType) {
    final priceInfo = servicePrices[serviceType];
    return priceInfo?['price'] as int?;
  }

  /// التحقق من كون السعر متغير
  static bool isServicePriceVariable(String serviceType) {
    final priceInfo = servicePrices[serviceType];
    return priceInfo?['isVariable'] == true;
  }

  /// الحصول على نص السعر للعرض
  static String getServicePriceText(String serviceType) {
    if (isServicePriceVariable(serviceType)) {
      return 'حسب الكمية';
    }
    final price = getServicePrice(serviceType);
    if (price == null) {
      return 'غير محدد';
    }
    return '$price ريال';
  }
}

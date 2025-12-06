# تطبيق الفنيين - سهم

تطبيق Flutter منفصل للفنيين لإدارة الطلبات.

## الميزات

- تسجيل دخول الفنيين
- عرض جميع الطلبات
- فلترة الطلبات حسب الحالة
- تحديث حالة الطلب
- فتح الموقع في خرائط Google
- الملف الشخصي للفني

## التثبيت

```bash
cd SHM_technician_app
flutter pub get
```

## التشغيل

```bash
flutter run
```

## البناء

```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios
```

## الإعدادات

- تأكد من أن Backend يعمل على `http://10.202.97.38:3000`
- يمكن تعديل IP في `lib/utils/constants.dart`

## البنية

```
lib/
├── main.dart                 # نقطة البداية
├── models/
│   └── request_model.dart   # نموذج الطلب
├── screens/
│   ├── login_screen.dart    # تسجيل الدخول
│   ├── main_screen.dart     # الشاشة الرئيسية
│   ├── home_screen.dart     # قائمة الطلبات
│   ├── order_details_screen.dart  # تفاصيل الطلب
│   └── profile_screen.dart  # الملف الشخصي
├── services/
│   ├── api_service.dart     # API calls
│   └── storage_service.dart # Local storage
└── utils/
    └── constants.dart       # الثوابت
```


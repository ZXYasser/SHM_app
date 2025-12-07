# 🔧 إصلاح مشاكل بناء APK

## المشاكل التي تم إصلاحها:

### 1. ✅ Android NDK Version
- **المشكلة**: Plugins تتطلب NDK 27.0.12077973
- **الحل**: تم تحديث `ndkVersion` في `build.gradle.kts`

### 2. ✅ مشكلة الذاكرة
- **المشكلة**: "insufficient memory" و "The paging file is too small"
- **الحل**: تم تقليل الذاكرة المطلوبة في `gradle.properties`:
  - من `-Xmx8G` إلى `-Xmx2G`
  - من `MaxMetaspaceSize=4G` إلى `512m`
  - إضافة `-XX:-UseParallelGC` كما اقترح الخطأ

---

## 📝 التغييرات:

### `SHM_technician_app/android/app/build.gradle.kts`:
```kotlin
ndkVersion = "27.0.12077973"
```

### `SHM_technician_app/android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx2G -XX:MaxMetaspaceSize=512m -XX:ReservedCodeCacheSize=256m -XX:+HeapDumpOnOutOfMemoryError -XX:-UseParallelGC
```

نفس التغييرات في `flutter_app/android/`

---

## 🚀 بناء APK الآن:

### للـ Technician App:
```bash
cd SHM_technician_app
flutter clean
flutter pub get
flutter build apk --release
```

### للـ Customer App:
```bash
cd flutter_app
flutter clean
flutter pub get
flutter build apk --release
```

---

## ⚠️ إذا استمرت مشكلة الذاكرة:

### خيار 1: زيادة Virtual Memory (Page File)
1. افتح **Control Panel** → **System** → **Advanced system settings**
2. **Advanced** tab → **Performance** → **Settings**
3. **Advanced** tab → **Virtual memory** → **Change**
4. اختر **Custom size**
5. **Initial size**: `4096` MB
6. **Maximum size**: `8192` MB
7. اضغط **Set** ثم **OK**
8. أعد تشغيل الكمبيوتر

### خيار 2: بناء Debug بدلاً من Release
```bash
flutter build apk --debug
```
(أصغر حجماً وأسرع في البناء)

### خيار 3: إغلاق البرامج الأخرى
- أغلق جميع البرامج غير الضرورية
- أغلق المتصفحات المفتوحة
- أغلق IDEs الأخرى

---

## ✅ بعد الإصلاح:

إذا نجح البناء، ستحصل على:
- `SHM_technician_app/build/app/outputs/flutter-apk/app-release.apk`
- `flutter_app/build/app/outputs/flutter-apk/app-release.apk`

يمكنك تثبيت APK على الجوال مباشرة!


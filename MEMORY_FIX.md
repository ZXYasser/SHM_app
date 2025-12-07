# 🔧 حل مشكلة الذاكرة في بناء APK

## ⚠️ المشكلة
```
The paging file is too small for this operation to complete
insufficient memory for the Java Runtime Environment
```

هذه مشكلة في **Virtual Memory (Page File)** في Windows، وليس في الكود.

---

## ✅ الحلول المطبقة

### 1. تقليل استهلاك الذاكرة
تم تحديث `gradle.properties`:
- `-Xmx1024m` (1GB بدلاً من 2GB)
- `MaxMetaspaceSize=256m`
- `ReservedCodeCacheSize=128m`
- إيقاف Gradle daemon (`org.gradle.daemon=false`)
- إضافة إعدادات Kotlin daemon

---

## 🚀 خطوات البناء (بعد الإصلاح)

### 1. إيقاف جميع Gradle Daemons
```bash
cd SHM_technician_app
cd android
.\gradlew --stop
```

### 2. تنظيف المشروع
```bash
cd ..
flutter clean
flutter pub get
```

### 3. بناء APK
```bash
flutter build apk --debug
```

---

## 🔧 حل جذري: زيادة Page File في Windows

إذا استمرت المشكلة، يجب زيادة Virtual Memory:

### الخطوات:
1. اضغط `Win + R`
2. اكتب: `sysdm.cpl` واضغط Enter
3. **Advanced** tab → **Performance** → **Settings**
4. **Advanced** tab → **Virtual memory** → **Change**
5. **إلغاء** "Automatically manage paging file size"
6. اختر **Custom size**:
   - **Initial size**: `4096` (4GB)
   - **Maximum size**: `8192` (8GB)
7. اضغط **Set** → **OK**
8. **أعد تشغيل الكمبيوتر** (مهم جداً!)

---

## 🎯 حلول بديلة

### 1. بناء على جهاز آخر
- استخدم جهاز بذاكرة أكبر
- أو استخدم Android Studio على جهاز آخر

### 2. استخدام Flutter Build Online
- استخدم GitHub Actions
- أو استخدم Codemagic / AppCircle

### 3. بناء Debug فقط (أخف)
```bash
flutter build apk --debug
```

### 4. بناء Split APKs (أصغر)
```bash
flutter build apk --split-per-abi
```
هذا ينشئ 3 ملفات APK أصغر (arm64, arm32, x64)

---

## 📝 ملاحظات

- بعد زيادة Page File، **يجب إعادة تشغيل الكمبيوتر**
- بعد إعادة التشغيل، جرب البناء مرة أخرى
- إذا استمرت المشكلة، استخدم Split APKs أو بناء على جهاز آخر

---

## ✅ بعد إصلاح Page File

```bash
cd SHM_technician_app
flutter clean
flutter pub get
flutter build apk --debug
```

يجب أن يعمل الآن!


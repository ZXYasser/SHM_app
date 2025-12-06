# 🚗 SHM - ورشة سيارات متنقلة

نظام إدارة شامل لورشة سيارات متنقلة يتكون من:
- تطبيق Flutter للعملاء
- تطبيق Flutter للفنيين
- لوحة تحكم React للإدارة
- Backend Node.js/Express مع Firebase Firestore

## 📁 بنية المشروع

```
SHM_app/
├── flutter_app/              # تطبيق العملاء (Flutter)
├── SHM_technician_app/       # تطبيق الفنيين (Flutter)
├── SHM_dashboard/            # لوحة التحكم (React)
└── SHM_backend/              # الخادم (Node.js/Express)
```

## 🚀 البدء السريع

### 1. Backend
```bash
cd SHM_backend
npm install
node server.js
```

### 2. Dashboard
```bash
cd SHM_dashboard
npm install
npm run dev
```

### 3. Flutter Apps
```bash
# تطبيق العملاء
cd flutter_app
flutter pub get
flutter run

# تطبيق الفنيين
cd SHM_technician_app
flutter pub get
flutter run
```

## 📚 التوثيق

- [بنية المشروع](./PROJECT_ARCHITECTURE.md) - شرح شامل لكيفية عمل المشروع
- [دليل النشر](./SHM_backend/DEPLOYMENT_GUIDE.md) - كيفية نشر Backend على Cloud
- [دليل النشر السريع](./SHM_backend/QUICK_START.md) - نشر سريع بدون GitHub

## 🔒 الأمان

⚠️ **مهم جداً**: لا ترفع `firebase-key.json` إلى GitHub!
- الملف موجود في `.gitignore`
- استخدم Environment Variables في Production

## 📝 الترخيص

ISC


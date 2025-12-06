# 🚀 دليل النشر - نشر Backend على Cloud

هذا الدليل يشرح كيفية نشر Backend على خدمة سحابية مجانية ليعمل بشكل دائم بدون الحاجة لتشغيله على الابتوب.

---

## 📋 الخيارات المتاحة

### 1. **Railway** (موصى به) ⭐
- ✅ مجاني للبداية (500 ساعة/شهر)
- ✅ سهل جداً في الإعداد
- ✅ دعم ممتاز
- ✅ تحديثات تلقائية من GitHub

### 2. **Render**
- ✅ مجاني تماماً
- ✅ سهل في الإعداد
- ⚠️ ينام بعد 15 دقيقة من عدم الاستخدام (لكن يستيقظ عند الطلب)

### 3. **Heroku**
- ⚠️ مدفوع الآن (لكن لديه خطة مجانية محدودة)

---

## 🎯 الطريقة 1: النشر على Railway (الأسهل)

### الخيار أ: النشر بدون GitHub (من الابتوب مباشرة)

#### الخطوة 1: إنشاء حساب على Railway
1. اذهب إلى [railway.app](https://railway.app)
2. سجل دخول باستخدام GitHub (حساب GitHub فقط للتسجيل، لا حاجة لرفع الكود)
3. اضغط "New Project"

#### الخطوة 2: تثبيت Railway CLI
1. اذهب إلى [railway.app/cli](https://railway.app/cli)
2. ثبّت Railway CLI:
   ```bash
   # Windows (PowerShell)
   iwr https://railway.app/install.ps1 | iex
   
   # أو استخدم npm
   npm install -g @railway/cli
   ```

#### الخطوة 3: تسجيل الدخول من Terminal
```bash
cd SHM_backend
railway login
```

#### الخطوة 4: ربط المشروع بـ Railway
```bash
railway init
# اختر "Create a new project"
```

#### الخطوة 5: رفع المشروع
```bash
railway up
```

هذا سيرفع المشروع ويبدأ النشر مباشرة!

---

### الخيار ب: النشر من GitHub (موصى به للمستقبل)

#### الخطوة 1: رفع المشروع على GitHub
1. أنشئ repository جديد على GitHub
2. ارفع مجلد `SHM_backend` فقط:
   ```bash
   cd SHM_backend
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/your-username/your-repo.git
   git push -u origin main
   ```

#### الخطوة 2: ربط المشروع في Railway
1. في Railway Dashboard، اضغط "New Project"
2. اختر "Deploy from GitHub repo"
3. اختر repository الخاص بك
4. اختر مجلد `SHM_backend` (إذا كان في root، اتركه فارغاً)

### الخطوة 3: إعداد Environment Variables
1. في Railway dashboard، اذهب إلى "Variables"
2. أضف المتغيرات التالية من `firebase-key.json`:

```
FIREBASE_PROJECT_ID=shm-app-9927d
FIREBASE_PRIVATE_KEY_ID=478a2d8715d942c5af982f80e8ee31bb27c6e4f6
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-fbsvc@shm-app-9927d.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=100326045955381477380
FIREBASE_CLIENT_X509_CERT_URL=https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40shm-app-9927d.iam.gserviceaccount.com
```

3. **الأهم**: أضف `FIREBASE_PRIVATE_KEY`:
   - افتح `firebase-key.json`
   - انسخ قيمة `private_key` (كلها بما فيها `-----BEGIN PRIVATE KEY-----` و `-----END PRIVATE KEY-----`)
   - في Railway، أضفها كـ `FIREBASE_PRIVATE_KEY`
   - **مهم**: يجب أن تحافظ على `\n` في النص (Railway يحولها تلقائياً)

### الخطوة 4: النشر
1. Railway سيبدأ النشر تلقائياً
2. انتظر حتى يكتمل (2-3 دقائق)
3. ستحصل على URL مثل: `https://your-app-name.up.railway.app`

### الخطوة 5: تحديث التطبيقات
1. افتح `flutter_app/lib/utils/constants.dart`
2. غيّر `baseUrl` إلى URL الجديد:
```dart
static String get baseUrl {
  if (kIsWeb) {
    return 'https://your-app-name.up.railway.app';  // ← غيّر هنا
  } else {
    return 'https://your-app-name.up.railway.app';  // ← غيّر هنا
  }
}
```

3. نفس الشيء في `SHM_technician_app/lib/utils/constants.dart`
4. في `SHM_dashboard/src/Orders.jsx` وغيرها، غيّر `http://localhost:3000` إلى URL الجديد

---

## 🎯 الطريقة 2: النشر على Render (مجاني تماماً)

### الخطوة 1: إنشاء حساب
1. اذهب إلى [render.com](https://render.com)
2. سجل دخول باستخدام GitHub

### الخطوة 2: إنشاء Web Service
1. اضغط "New +" → "Web Service"
2. اختر repository الخاص بك
3. الإعدادات:
   - **Name**: `shm-backend`
   - **Environment**: `Node`
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
   - **Plan**: Free

### الخطوة 3: إعداد Environment Variables
1. في "Environment" tab، أضف نفس المتغيرات كما في Railway
2. أضف أيضاً:
   ```
   NODE_ENV=production
   ```

### الخطوة 4: النشر
1. اضغط "Create Web Service"
2. انتظر حتى يكتمل النشر
3. ستحصل على URL مثل: `https://shm-backend.onrender.com`

### ملاحظة مهمة:
- Render ينام بعد 15 دقيقة من عدم الاستخدام
- عند أول طلب بعد النوم، قد يستغرق 30-60 ثانية للاستيقاظ
- هذا مجاني تماماً!

---

## 🔧 إعداد Firebase Credentials كـ Environment Variables

### من `firebase-key.json` إلى Environment Variables:

افتح `firebase-key.json` وانسخ القيم التالية:

```json
{
  "project_id": "shm-app-9927d"  → FIREBASE_PROJECT_ID
  "private_key_id": "..."        → FIREBASE_PRIVATE_KEY_ID
  "private_key": "-----BEGIN..." → FIREBASE_PRIVATE_KEY (كامل)
  "client_email": "..."          → FIREBASE_CLIENT_EMAIL
  "client_id": "..."             → FIREBASE_CLIENT_ID
  "client_x509_cert_url": "..."  → FIREBASE_CLIENT_X509_CERT_URL
}
```

**مهم جداً**: عند نسخ `private_key`:
- يجب أن يكون كاملاً من `-----BEGIN PRIVATE KEY-----` إلى `-----END PRIVATE KEY-----`
- يجب أن يحافظ على `\n` (سطر جديد) - معظم الخدمات تحولها تلقائياً

---

## 📝 تحديث جميع التطبيقات

بعد الحصول على URL الجديد (مثل `https://your-app.up.railway.app`):

### 1. Flutter Customer App
```dart
// flutter_app/lib/utils/constants.dart
static String get baseUrl {
  return 'https://your-app.up.railway.app';
}
```

### 2. Flutter Technician App
```dart
// SHM_technician_app/lib/utils/constants.dart
static String get baseUrl {
  return 'https://your-app.up.railway.app';
}
```

### 3. React Dashboard
```javascript
// SHM_dashboard/src/Orders.jsx
const res = await fetch('https://your-app.up.railway.app/requests', {
  // ...
});
```

**أو** أنشئ ملف `.env`:
```env
VITE_API_URL=https://your-app.up.railway.app
```

ثم استخدمه:
```javascript
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000';
```

---

## ✅ التحقق من النشر

بعد النشر، اختبر الـ endpoint:
```
https://your-app.up.railway.app/health
```

يجب أن ترى:
```json
{
  "server": "running",
  "firebase": "connected",
  "timestamp": "..."
}
```

---

## 🔒 الأمان

### ⚠️ مهم جداً:
1. **لا تشارك `firebase-key.json`** في GitHub
2. تأكد من وجوده في `.gitignore`
3. استخدم Environment Variables فقط في Production

### تحسينات للأمان:
1. تقييد CORS لمصادر محددة:
```javascript
app.use(cors({
  origin: ['https://your-dashboard.vercel.app', 'https://your-app.com'],
  // ...
}));
```

2. إضافة rate limiting
3. استخدام HTTPS فقط

---

## 🆘 حل المشاكل

### المشكلة: "Firebase initialization failed"
- **الحل**: تأكد من أن جميع Environment Variables موجودة وصحيحة
- تأكد من أن `FIREBASE_PRIVATE_KEY` كامل وصحيح

### المشكلة: "Cannot connect to Firestore"
- **الحل**: تأكد من أن Firebase project نشط
- تحقق من أن Service Account لديه صلاحيات Firestore

### المشكلة: "App sleeps after inactivity" (Render)
- **الحل**: هذا طبيعي في الخطة المجانية
- يمكنك ترقية للخطة المدفوعة أو استخدام Railway

---

## 📊 مقارنة الخدمات

| الميزة | Railway | Render |
|--------|---------|--------|
| مجاني | ✅ 500 ساعة/شهر | ✅ غير محدود |
| ينام بعد عدم الاستخدام | ❌ لا | ✅ نعم (15 دقيقة) |
| سهولة الإعداد | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| سرعة الاستجابة | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| دعم HTTPS | ✅ تلقائي | ✅ تلقائي |

---

## 🎉 النتيجة

بعد النشر:
- ✅ Backend يعمل 24/7
- ✅ لا حاجة لتشغيل الابتوب
- ✅ يمكن اختبار التطبيق من أي مكان
- ✅ جميع التطبيقات تتصل بـ Backend المنشور

**الآن يمكنك اختبار التطبيق في الحياة الواقعية! 🚀**


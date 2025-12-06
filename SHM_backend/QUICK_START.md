# 🚀 دليل النشر السريع - بدون GitHub

إذا لم ترفع المشروع على GitHub بعد، يمكنك النشر مباشرة من الابتوب!

---

## 📦 الطريقة 1: Railway CLI (الأسهل)

### الخطوة 1: تثبيت Railway CLI

**Windows (PowerShell):**
```powershell
iwr https://railway.app/install.ps1 | iex
```

**أو باستخدام npm:**
```bash
npm install -g @railway/cli
```

### الخطوة 2: تسجيل الدخول
```bash
cd SHM_backend
railway login
```
سيُفتح المتصفح لتسجيل الدخول.

### الخطوة 3: إنشاء مشروع جديد
```bash
railway init
```
اختر "Create a new project" وأعطه اسم (مثل `shm-backend`)

### الخطوة 4: إضافة Environment Variables

**الطريقة 1: من Terminal**
```bash
railway variables set FIREBASE_PROJECT_ID=shm-app-9927d
railway variables set FIREBASE_PRIVATE_KEY_ID=478a2d8715d942c5af982f80e8ee31bb27c6e4f6
railway variables set FIREBASE_CLIENT_EMAIL=firebase-adminsdk-fbsvc@shm-app-9927d.iam.gserviceaccount.com
railway variables set FIREBASE_CLIENT_ID=100326045955381477380
railway variables set FIREBASE_CLIENT_X509_CERT_URL=https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40shm-app-9927d.iam.gserviceaccount.com
```

**للـ private_key (الأهم):**
1. افتح `firebase-key.json`
2. انسخ قيمة `private_key` (كلها)
3. في Terminal:
```bash
railway variables set FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nMIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQCzqq9R9wEkP66J\n..."
```

**الطريقة 2: من Dashboard**
1. اذهب إلى [railway.app](https://railway.app)
2. افتح مشروعك
3. اضغط "Variables" tab
4. أضف كل متغير يدوياً

### الخطوة 5: النشر!
```bash
railway up
```

هذا سيرفع المشروع ويبدأ النشر. انتظر حتى يكتمل (2-3 دقائق).

### الخطوة 6: الحصول على URL
```bash
railway domain
```
أو من Dashboard → Settings → Generate Domain

ستحصل على URL مثل: `https://your-app.up.railway.app`

---

## 🌐 الطريقة 2: Render (بدون GitHub أيضاً)

### الخطوة 1: إنشاء حساب
1. اذهب إلى [render.com](https://render.com)
2. سجل دخول

### الخطوة 2: إنشاء Web Service
1. اضغط "New +" → "Web Service"
2. اختر "Build and deploy from a Git repository"
3. **أو** اختر "Public Git repository" وارفع الكود لاحقاً

### الخطوة 3: رفع الكود
يمكنك رفع الكود مباشرة من Render Dashboard:
1. اضغط "Manual Deploy"
2. ارفع ملف ZIP من مجلد `SHM_backend`

### الخطوة 4: إعداد Environment Variables
في Render Dashboard → Environment:
- أضف جميع Firebase variables كما في Railway

### الخطوة 5: النشر
Render سيبدأ النشر تلقائياً.

---

## 📝 ملاحظات مهمة

### ⚠️ قبل النشر:
1. تأكد من أن `firebase-key.json` موجود في `.gitignore`
2. لا ترفع `firebase-key.json` إلى أي مكان
3. استخدم Environment Variables فقط

### ✅ بعد النشر:
1. اختبر الـ endpoint: `https://your-app.up.railway.app/health`
2. يجب أن ترى:
   ```json
   {
     "server": "running",
     "firebase": "connected"
   }
   ```

### 🔄 تحديث التطبيقات:
بعد الحصول على URL، غيّر `baseUrl` في:
- `flutter_app/lib/utils/constants.dart`
- `SHM_technician_app/lib/utils/constants.dart`
- `SHM_dashboard/src/*.jsx`

---

## 🆘 حل المشاكل

### "railway: command not found"
- تأكد من تثبيت Railway CLI
- أعد تشغيل Terminal

### "Firebase initialization failed"
- تأكد من إضافة جميع Environment Variables
- تأكد من أن `FIREBASE_PRIVATE_KEY` كامل وصحيح

### "Cannot connect to Firestore"
- تحقق من أن Firebase project نشط
- تأكد من أن Service Account لديه صلاحيات

---

## 🎉 النتيجة

بعد النشر:
- ✅ Backend يعمل 24/7
- ✅ URL دائم (مثل `https://your-app.up.railway.app`)
- ✅ لا حاجة لتشغيل الابتوب
- ✅ يمكن اختبار التطبيق من أي مكان!

**الآن يمكنك اختبار التطبيق في الحياة الواقعية! 🚀**


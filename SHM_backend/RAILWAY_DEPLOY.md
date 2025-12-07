# 🚂 نشر Backend على Railway من GitHub

بعد رفع المشروع على GitHub، يمكنك نشر Backend فقط على Railway.

---

## 🎯 الخطوات

### 1. إنشاء حساب على Railway
1. اذهب إلى [railway.app](https://railway.app)
2. سجل دخول باستخدام GitHub
3. اضغط **"New Project"**

### 2. ربط المشروع من GitHub
1. اختر **"Deploy from GitHub repo"**
2. اختر repository: `ZXYasser/SHM_app`
3. **مهم**: في "Root Directory"، اكتب: `SHM_backend`
   - هذا يخبر Railway أن يستخدم مجلد `SHM_backend` فقط

### 3. إعداد Environment Variables
في Railway Dashboard → **Variables** tab، أضف:

```
FIREBASE_PROJECT_ID=shm-app-9927d
FIREBASE_PRIVATE_KEY_ID=478a2d8715d942c5af982f80e8ee31bb27c6e4f6
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-fbsvc@shm-app-9927d.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=100326045955381477380
FIREBASE_CLIENT_X509_CERT_URL=https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40shm-app-9927d.iam.gserviceaccount.com
```

**الأهم**: أضف `FIREBASE_PRIVATE_KEY`:
1. افتح `SHM_backend/firebase-key.json` محلياً
2. انسخ قيمة `private_key` (كلها من `-----BEGIN` إلى `-----END`)
3. في Railway، أضفها كـ:
   ```
   FIREBASE_PRIVATE_KEY=-----BEGIN PRIVATE KEY-----\nMIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQCzqq9R9wEkP66J\n...
   ```

### 4. النشر
- Railway سيبدأ النشر تلقائياً
- انتظر حتى يكتمل (2-3 دقائق)
- ستحصل على URL مثل: `https://your-app.up.railway.app`

### 5. الحصول على Domain
1. في Railway Dashboard → **Settings**
2. اضغط **"Generate Domain"**
3. ستحصل على URL دائم

---

## ✅ التحقق

اختبر الـ endpoint:
```
https://your-app.up.railway.app/health
```

يجب أن ترى:
```json
{
  "server": "running",
  "firebase": "connected"
}
```

---

## 🔄 تحديثات تلقائية

بعد النشر:
- أي `git push` جديد إلى GitHub سيحدث Backend تلقائياً
- Railway يراقب `SHM_backend` folder فقط

---

## 📝 ملاحظات

- ✅ فقط Backend يحتاج Railway
- ✅ Flutter apps يتم بناؤها كـ APK/IPA (لا تحتاج server)
- ✅ Dashboard يمكن نشره على Vercel/Netlify لاحقاً (اختياري)

---

## 🎉 النتيجة

بعد النشر:
- ✅ Backend يعمل 24/7
- ✅ URL دائم: `https://your-app.up.railway.app`
- ✅ تحديثات تلقائية من GitHub
- ✅ لا حاجة لتشغيل الابتوب!


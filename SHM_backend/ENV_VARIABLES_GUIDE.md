# 🔐 دليل إضافة Environment Variables في Railway

هذا الدليل يشرح كيفية إضافة Firebase credentials كـ Environment Variables في Railway.

---

## 📋 الخطوات التفصيلية

### 1. افتح Railway Dashboard
1. اذهب إلى [railway.app](https://railway.app)
2. سجل دخول
3. افتح المشروع الخاص بك (SHM Backend)

### 2. افتح Variables Tab
1. في المشروع، اضغط على **"Variables"** tab (في القائمة الجانبية)
2. أو اضغط على المشروع → **Settings** → **Variables**

### 3. أضف المتغيرات التالية

اضغط **"New Variable"** لكل متغير وأضف:

#### المتغير 1: FIREBASE_PROJECT_ID
- **Key**: `FIREBASE_PROJECT_ID`
- **Value**: `shm-app-9927d`
- اضغط **"Add"**

#### المتغير 2: FIREBASE_PRIVATE_KEY_ID
- **Key**: `FIREBASE_PRIVATE_KEY_ID`
- **Value**: `478a2d8715d942c5af982f80e8ee31bb27c6e4f6`
- اضغط **"Add"**

#### المتغير 3: FIREBASE_CLIENT_EMAIL
- **Key**: `FIREBASE_CLIENT_EMAIL`
- **Value**: `firebase-adminsdk-fbsvc@shm-app-9927d.iam.gserviceaccount.com`
- اضغط **"Add"**

#### المتغير 4: FIREBASE_CLIENT_ID
- **Key**: `FIREBASE_CLIENT_ID`
- **Value**: `100326045955381477380`
- اضغط **"Add"**

#### المتغير 5: FIREBASE_CLIENT_X509_CERT_URL
- **Key**: `FIREBASE_CLIENT_X509_CERT_URL`
- **Value**: `https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40shm-app-9927d.iam.gserviceaccount.com`
- اضغط **"Add"**

#### المتغير 6: FIREBASE_PRIVATE_KEY (الأهم!)
- **Key**: `FIREBASE_PRIVATE_KEY`
- **Value**: انسخ القيمة الكاملة من `firebase-key.json`:
  ```
  -----BEGIN PRIVATE KEY-----
  MIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQCzqq9R9wEkP66J
  Md9X72WXn3T77npQ9lDgNCm6N8ZjbrD4kvLWU9b8nQENrA9cwhJ8SBT70uESzYPq
  THXrc//OlK72lTgQbPUCV9YnSuzZg+Y/qYP2Hpff565ZwUdJb65uJ71s42lo8zHc
  zZISHRgCz7YWQ+Q1QyOz22QFrQ2idPVE0U/LWSIatDvckjw08v+506n2O72jZwL+
  j9udo9Llmokwlh1xWlG1O1/AYXO1p8RIR08UWLyCMNVvO4ysi5RK41A0gPbo+I6h
  GUzqL/gwrhDYGaDr3IzLuKcHjYX9Sk4Mt2IU8NMADilVois6LdPtlxU/sYxCXWya
  zieo3CabAgMBAAECgf8DPkPzrxFKklfWKe1l8qpqkkPjjiiP0XXalj1B3VsI5NO5
  mXkeEACHzOjmgPKuxZvGHq3GK4hY8XQPL2ltpDnuRoqE6P4d+HSx2BKc2UUncboX
  RVFO7aNMVAU6awDSysiVekj09++lfRt09FCLzNueOSGnmpIjDqp7K/Lr+MNCXeHL
  nH+5Xc8uu+vVHcClDnKpZVam3E6a/KRKKAfhRMiGQDSS76LG49mL54U3ihkrFHvs
  4jLpQsp8p8MsRFntqX/DvFvOiD5NNyrjMv6g+XILj2u3MhJjgRIJVUo7aHmazhhq
  7JSR5XidbFVApcKCiAsOa0+xIHHE2yGR0CTJn4UCgYEA+3odF8ODgA4XvBBwed94
  iN5T5v+aZFiSiCBwKPwovDHI1ioA69UtHbVBD8fxyXAtxrRR5g8LbDKduJNhwBkk
  MEi8zFH3OoLTIbLdirkT0ZR6WkzDKWTXXrq6szN1Tvv9k2V9Z04JYYTTnwCbxi3P
  X4YmRMvqMvl3jUEOFfBCuGcCgYEAtuXunlDC/wUsJ1Y6bV845igkQ0LlGN44GUqr
  vgxGZiaZUvm2Dk8znRN4tK903OAb79o9bazhl1rxk30OLTB1e1+8pZ65UcZueoep
  huTEGcaw/AmCIx7tbHHR2Y2HSZmnNJwSo9CWRTWKpLDA4p/ohjSleOHO5+AgSQjo
  Sxicj60CgYAs98YSBMUT9fEqkOn78Qj1uIPaT6SFAw2Yx+wmeAi0tlZKbZJimWkK
  4elzb/Z9ZdDZsk7ey5voShjH85rMJfLBq5APHS0PSmuEoB5bewLfPCSw1v8i/MRC
  TTOrba0xZYAPhltpSJwG0yCgUxSH2JM3ap6XOLt1SASnvpVNOPxFSwKBgEcIhCVO
  fn0nGB/q+GQ0AFg7LOJGn82JuMXx30O/ZrQTt6anPxLNpeESh+W84ylJjPAZlZP7
  +d2bv4kln5TjZi1VYGH+hEEDTTMfbzLptFPCfEhWtQlI4LMmfXb95ZYrK+pd10ty
  HnqgsckGsNMTge5lkgKhyIb73+4dnIJV+7A9AoGBAN77geCes5+9FG6hPiFeOx3E
  GCwarBDaGkjQPRyjsyC4YbNe8CPaflmuy84Qk69/DHiR+LC+lNwsBoCFfuHVUbvz
  kjiXihOu2nnlKsxu1Gq0Cskx9mlkMxELu4Lt53aIOnbSBQH92SquYoP9B9zBU5J7
  xTXWt+yY/z6ivLhTYSPN
  -----END PRIVATE KEY-----
  ```
- **مهم**: انسخ الكل بما فيه `-----BEGIN PRIVATE KEY-----` و `-----END PRIVATE KEY-----`
- Railway سيتعامل مع `\n` تلقائياً
- اضغط **"Add"**

---

## ✅ التحقق من المتغيرات

بعد إضافة جميع المتغيرات، يجب أن ترى قائمة مثل:

```
FIREBASE_PROJECT_ID = shm-app-9927d
FIREBASE_PRIVATE_KEY_ID = 478a2d8715d942c5af982f80e8ee31bb27c6e4f6
FIREBASE_CLIENT_EMAIL = firebase-adminsdk-fbsvc@shm-app-9927d.iam.gserviceaccount.com
FIREBASE_CLIENT_ID = 100326045955381477380
FIREBASE_CLIENT_X509_CERT_URL = https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40shm-app-9927d.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY = -----BEGIN PRIVATE KEY-----\n...
```

---

## 🎯 طريقة سريعة (نسخ ولصق)

إذا كان لديك `firebase-key.json` مفتوح:

1. **FIREBASE_PROJECT_ID**: انسخ من `"project_id"`
2. **FIREBASE_PRIVATE_KEY_ID**: انسخ من `"private_key_id"`
3. **FIREBASE_CLIENT_EMAIL**: انسخ من `"client_email"`
4. **FIREBASE_CLIENT_ID**: انسخ من `"client_id"`
5. **FIREBASE_CLIENT_X509_CERT_URL**: انسخ من `"client_x509_cert_url"`
6. **FIREBASE_PRIVATE_KEY**: انسخ من `"private_key"` (كلها!)

---

## ⚠️ ملاحظات مهمة

1. **لا تشارك هذه القيم** مع أي شخص
2. **FIREBASE_PRIVATE_KEY** يجب أن يكون كاملاً (من BEGIN إلى END)
3. Railway قد يحول `\n` تلقائياً - لا تقلق
4. بعد إضافة المتغيرات، Railway سيعيد النشر تلقائياً

---

## 🔄 بعد إضافة المتغيرات

1. Railway سيعيد النشر تلقائياً
2. انتظر حتى يكتمل (2-3 دقائق)
3. تحقق من Logs للتأكد من نجاح الاتصال بـ Firebase
4. اختبر: `https://your-app.up.railway.app/health`

---

## 🆘 إذا واجهت مشاكل

### "Firebase initialization failed"
- تأكد من أن جميع المتغيرات موجودة
- تأكد من أن `FIREBASE_PRIVATE_KEY` كامل وصحيح

### "Cannot connect to Firestore"
- تحقق من أن Firebase project نشط
- تأكد من أن Service Account لديه صلاحيات Firestore

---

## ✅ النتيجة

بعد إضافة جميع المتغيرات:
- ✅ Backend سيتصل بـ Firebase تلقائياً
- ✅ لا حاجة لـ `firebase-key.json` في Production
- ✅ آمن تماماً (المتغيرات مشفرة في Railway)


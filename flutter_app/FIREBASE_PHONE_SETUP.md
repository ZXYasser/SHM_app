# إعداد تسجيل الدخول برقم الجوال (Firebase Phone Auth) للإنتاج والمتجر

## توضيح مهم

**Firebase يعمل مع أي رقم جوال.**  
لا تحتاج إضافة أرقام المستخدمين في Firebase مسبقاً. أي مستخدم يدخل رقمه في التطبيق يمكنه استلام رمز SMS حقيقي.

- **أرقام الاختبار (Phone numbers for testing)** في Firebase Console: اختيارية. عند إضافتها، هذه الأرقام فقط تحصل على رمز ثابت (مثل 123456) لتوفير رسائل SMS أثناء التطوير. لا تمنع الأرقام الأخرى من العمل.
- **للمتجر:** لا تضيف أرقام المستخدمين. اترك طريقة "Phone" مفعّلة فقط.

---

## ⚠️ خطأ "internal error" / "billing not enabled" (مهم جداً)

إذا ظهر على الجوال أو في الـ Console:

- **"internal error"** أو **"billing not enabled"** أو **BILLING_NOT_ENABLED**

فالسبب: **تسجيل الدخول برقم الجوال (Phone Auth) يتطلب تفعيل الفوترة (Billing) على مشروع Google Cloud** حتى يعمل إرسال SMS، حتى لو كنت على الخطة المجانية (Spark).

- يمكنك البقاء على **الخطة المجانية** في Firebase؛ المطلوب فقط **ربط حساب فوترة** بالمشروع.
- ضمن الحدود المجانية لن يُخصم منك مبلغ (مثلاً عدد محدود من رسائل SMS مجاناً يومياً).
- بدون ربط الفوترة، إرسال الرمز سيفشل لأي رقم (بما فيه أرقام الاختبار خارج القائمة).

### تفعيل الفوترة (خطوات مختصرة)

1. افتح [Google Cloud Console](https://console.cloud.google.com) واختر **نفس المشروع** المرتبط بمشروع Firebase (مثلاً `shm-app-9927d`).
2. من القائمة الجانبية: **Billing** (الفوترة) → **Link a billing account** (ربط حساب فوترة).
3. إن لم يكن لديك حساب فوترة: **Create account** وأنشئ حساباً (يُطلب بطاقة للتسجيل، لكنك لن تُفوتر فوق الحد المجاني إذا التزمت بالحدود).
4. بعد الربط، انتظر دقائق ثم جرّب إرسال رمز التحقق مرة أخرى من التطبيق.

بعد تفعيل الفوترة، خطأ "billing not enabled" و "internal error" الناتج عنه يجب أن يختفي، ورسالة **400 Bad Request** على الويب قد تختفي أيضاً إذا كان السبب نفسه.

- **على الويب (Chrome / Flutter web):** إن استمر خطأ 400 بعد تفعيل الفوترة، تأكد من إضافة النطاق في Firebase: **Authentication** → **Settings** → **Authorized domains** (مثلاً `localhost` للتطوير).

---

## لماذا قد لا يُرسل الرمز لرقم جديد؟ (بعد تفعيل الفوترة)

عادة السبب أحد التالي:

1. **الفوترة غير مفعّلة** (انظر القسم أعلاه).
2. **بصمة SHA-1 غير مضافة في Firebase** (شائع على Android).
3. **بناء Release:** إذا كنت تختبر بنسخة الإصدار أو نسخة المتجر، يجب إضافة SHA-1 لمفتاح التوقيع (Release keystore) وليس فقط Debug.

---

## خطوات الحل (لعمل الإرسال مع كل المستخدمين)

### 1. تفعيل الفوترة (Billing)

كما في القسم **"خطأ billing not enabled"** أعلاه: ربط حساب فوترة بالمشروع في Google Cloud Console.

### 2. Firebase Console

1. افتح [Firebase Console](https://console.firebase.google.com) → مشروعك.
2. **Authentication** → **Sign-in method** → **Phone** → تأكد أنه **مفعّل**.
3. لا حاجة لإضافة أرقام المستخدمين. (أرقام الاختبار اختيارية للتطوير فقط.)

### 3. إضافة بصمات SHA-1 و SHA-256 (مهم لـ Android)

Firebase يستخدمها للتحقق من أن الطلب من تطبيقك فعلاً. بدونها قد يفشل إرسال الرمز.

1. في Firebase: **Project settings** (⚙️) → **Your apps** → اختر تطبيق Android (`com.shm.workshop`).
2. في قسم **SHA certificate fingerprints**:
   - اضغط **Add fingerprint**.
   - أضف **SHA-1** ثم **SHA-256** لكل مفتاح تستخدمه (انظر أدناه).

#### الحصول على SHA-1 و SHA-256

**للتطوير (Debug):**

```bash
cd flutter_app/android
./gradlew signingReport
```

أو على Windows:

```powershell
cd flutter_app\android
.\gradlew.bat signingReport
```

انسخ **SHA-1** و **SHA-256** من قسم `Variant: debug` وأضفهما في Firebase.

**للإصدار والمتجر (Release):**

- إذا أنشأت مفتاح Release خاصاً بك:
  ```bash
  keytool -list -v -keystore مسار/مفتاحك.jks -alias alias_name
  ```
- إذا استخدمت **Google Play App Signing**: من **Play Console** → تطبيقك → **Setup** → **App signing** انسخ SHA-1 و SHA-256 من **App signing key certificate** وأضفهما في Firebase.

بعد إضافة البصمات، حمّل ملف **google-services.json** الجديد (إن ظهر) وضعه في `android/app/` ثم أعد بناء التطبيق.

### 4. تنسيق رقم الجوال

يجب أن يكون الرقم بصيغة **E.164**، مثلاً:

- السعودية: `+9665xxxxxxxx`
- مع كود الدولة في البداية وبدون صفر زائد بعد كود الدولة.

التطبيق يطلب من المستخدم إدخال الرقم مع كود الدولة (مثل +966...).

---

## ملخص

| المطلوب | الوصف |
|--------|--------|
| **تفعيل الفوترة (Billing)** | ربط حساب فوترة بالمشروع في Google Cloud (مطلوب لـ Phone Auth) |
| تفعيل Phone | Authentication → Sign-in method → Phone مفعّل |
| SHA-1 و SHA-256 | مضافة في Firebase لكل مفتاح (Debug و Release / Play) |
| تنسيق الرقم | E.164 مع + وكود الدولة |
| أرقام المستخدمين | لا تُضاف في Firebase؛ التطبيق يعمل مع أي رقم |

بعد تطبيق الخطوات أعلاه، إرسال رمز SMS يعمل لأي مستخدم يدخل رقمه من التطبيق، سواء للتطوير أو عند الإطلاق في المتجر.

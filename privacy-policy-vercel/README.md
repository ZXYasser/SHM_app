# صفحة سياسة الخصوصية — ورشة SHM

صفحة ويب ثابتة لسياسة الخصوصية لاستخدامها في Google Play Console وربطها من التطبيق.

## النشر على Vercel

### الطريقة 1: من واجهة Vercel

1. سجّل الدخول إلى [vercel.com](https://vercel.com) واتصل بحساب GitHub (أو GitLab/Bitbucket).
2. انقر **Add New** → **Project**.
3. اختر المستودع الذي يحتوي مجلد `privacy-policy-vercel`، أو انسخ محتويات هذا المجلد إلى مستودع جديد.
4. في **Root Directory** اختر `privacy-policy-vercel` (أو اتركه فارغاً إذا كان المستودع يحتوي فقط على ملفات الصفحة).
5. اضغط **Deploy**. بعد انتهاء النشر ستحصل على رابط مثل:  
   `https://اسم-المشروع.vercel.app`

### الطريقة 2: من سطر الأوامر (Vercel CLI)

```bash
cd privacy-policy-vercel
npx vercel
```

اتبع التعليمات (تسجيل الدخول إن لزم)، ثم انشر للإنتاج:

```bash
npx vercel --prod
```

## الرابط لـ Play Console

بعد النشر، استخدم الرابط الثابت للصفحة الرئيسية، مثلاً:

- `https://اسم-المشروع.vercel.app`
- أو إذا ربطت دوميناً مخصصاً: `https://privacy.yourdomain.com`

أدخل هذا الرابط في **Play Console** → تطبيقك → **سياسة الخصوصية** (Policy → App content → Privacy policy).

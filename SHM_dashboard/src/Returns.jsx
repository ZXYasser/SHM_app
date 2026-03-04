export default function Returns() {
  const sections = [
    { title: "1) نطاق السياسة", body: "تنطبق هذه السياسة على جميع المدفوعات التي تتم عبر تطبيق ورشة سهم باستخدام وسائل الدفع الإلكترونية المتاحة داخل التطبيق." },
    { title: "2) الحالات التي يمكن فيها الاسترجاع", body: "يجوز طلب استرجاع المبلغ في الحالات التالية:\n• تم تحصيل مبلغ دون تنفيذ الخدمة.\n• تم خصم مبلغ مكرر بالخطأ.\n• تعذر تنفيذ الخدمة من طرف ورشة سهم بعد الدفع.\n• وجود خطأ واضح في احتساب السعر." },
    { title: "3) الحالات التي لا يشملها الاسترجاع", body: "لا يتم استرجاع المبلغ في الحالات التالية:\n• تم تنفيذ الخدمة بالكامل وفق الطلب.\n• تم إلغاء الطلب بعد تحرك الفني ووصوله للموقع.\n• تأخر العميل أو تعذر الوصول إليه في الموقع المحدد.\n• سوء استخدام الخدمة أو تقديم معلومات غير صحيحة." },
    { title: "4) آلية طلب الاسترجاع", body: "يمكن تقديم طلب الاسترجاع خلال مدة أقصاها 48 ساعة من وقت تنفيذ أو إلغاء الطلب عبر:\n\n📧 البريد الإلكتروني: [ضع بريدك هنا]\n📱 رقم التواصل: [ضع رقمك هنا]\n\nيجب تزويدنا برقم الطلب وتفاصيل المشكلة." },
    { title: "5) مدة معالجة الاسترجاع", body: "يتم مراجعة الطلب خلال 3–7 أيام عمل.\n\nفي حال الموافقة، يتم إعادة المبلغ إلى نفس وسيلة الدفع المستخدمة.\n\nقد تستغرق البنوك من 5–14 يوم عمل لإظهار المبلغ في حسابك حسب سياسة الجهة المالية." },
    { title: "6) أحكام عامة", body: "تحتفظ ورشة سهم بحق رفض طلب الاسترجاع إذا تبين إساءة استخدام الخدمة.\n\nأي استرجاع يتم وفق الأنظمة المعمول بها في المملكة العربية السعودية." },
  ];

  return (
    <div className="w-full flex flex-col items-center px-4 pt-6 pb-20">
      <div className="w-full max-w-2xl mx-auto">
        <div className="bg-white rounded-2xl shadow-lg border border-gray-100 p-8 sm:p-10">
          <h1 className="text-2xl sm:text-3xl font-bold text-blue-600 mb-2 text-center">سياسة الاسترجاع</h1>
          <p className="text-gray-500 text-sm mb-8 text-center">ورشة سهم – خدمة ورشة سيارات متنقلة · آخر تحديث: 2026-02</p>
          <div className="space-y-8">
            {sections.map((sec) => (
              <section key={sec.title} className="pb-8 border-b border-gray-100 last:border-0 last:pb-0">
                <h2 className="text-lg font-bold text-gray-800 mb-3 text-center">{sec.title}</h2>
                <p className="text-gray-600 leading-relaxed whitespace-pre-line text-center">{sec.body}</p>
              </section>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

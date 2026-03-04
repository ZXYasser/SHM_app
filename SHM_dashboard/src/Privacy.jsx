export default function Privacy() {
  return (
    <div className="w-full flex flex-col items-center px-4 pt-6 pb-20">
      <div className="w-full max-w-2xl mx-auto">
        <div className="bg-white rounded-2xl shadow-lg border border-gray-100 p-8 sm:p-10">
          <h1 className="text-2xl sm:text-3xl font-bold text-blue-600 mb-2 text-center">سياسة الخصوصية</h1>
          <p className="text-gray-500 text-sm mb-8 text-center">تطبيق ورشة سهم — خدمة ورشة سيارات متنقلة</p>
          <p className="text-gray-600 leading-relaxed mb-8 text-center">
            تطبيق ورشة سهم يقدّم خدمة ورشة سيارات متنقلة (نوصلك للحل). نجمّع فقط ما نحتاجه لتشغيل الخدمة ولا نبيع بياناتك لأي طرف.
          </p>

          <div className="space-y-8">
            <section className="pb-8 border-b border-gray-100 last:border-0 last:pb-0">
              <h2 className="text-lg font-bold text-gray-800 mb-3 text-center">ما البيانات التي نجمعها؟</h2>
              <p className="text-gray-600 leading-relaxed text-center">
                عند تسجيل الدخول: البريد الإلكتروني أو تسجيل كضيف.
                عند طلب الخدمة: موقعك (إحداثيات GPS) حتى يصل الفني إليك، ونوع الخدمة، موديل السيارة، رقم اللوحة، وملاحظاتك. نستخدم أيضاً معرف المستخدم من نظام تسجيل الدخول لربط الطلبات بحسابك.
              </p>
            </section>

            <section className="pb-8 border-b border-gray-100 last:border-0 last:pb-0">
              <h2 className="text-lg font-bold text-gray-800 mb-3 text-center">لماذا نستخدمها؟</h2>
              <p className="text-gray-600 leading-relaxed text-center">
                لتوصيل طلبك للفني، التواصل معك بخصوص الطلب، وتحسين التطبيق. لا نبيع بياناتك الشخصية ولا نستخدمها للإعلان لجهات ثالثة.
              </p>
            </section>

            <section className="pb-8 border-b border-gray-100 last:border-0 last:pb-0">
              <h2 className="text-lg font-bold text-gray-800 mb-3 text-center">هل نشارك البيانات مع غيرنا؟</h2>
              <p className="text-gray-600 leading-relaxed text-center">
                نشارك مع الفنيين فقط ما يلزم لتنفيذ الطلب (مثل الموقع ونوع الخدمة). إذا طُلبت منا بيانات قانونياً نلتزم بالقانون.
              </p>
            </section>

            <section className="pb-8 border-b border-gray-100 last:border-0 last:pb-0">
              <h2 className="text-lg font-bold text-gray-800 mb-3 text-center">كيف نحمي بياناتك؟</h2>
              <p className="text-gray-600 leading-relaxed text-center">
                الاتصال بين التطبيق والخوادم يتم عبر بروتوكولات آمنة. نحرص على إجراءات مناسبة لحماية البيانات.
              </p>
            </section>

            <section className="pb-8 border-b border-gray-100 last:border-0 last:pb-0">
              <h2 className="text-lg font-bold text-gray-800 mb-3 text-center">ما حقوقك؟</h2>
              <p className="text-gray-600 leading-relaxed text-center">
                يمكنك طلب الاطلاع على بياناتك أو تصحيحها أو حذفها عبر التواصل معنا من داخل التطبيق (تواصل معنا / القائمة).
              </p>
            </section>

            <section>
              <h2 className="text-lg font-bold text-gray-800 mb-3 text-center">تحديث السياسة</h2>
              <p className="text-gray-600 leading-relaxed text-center">
                قد نعدّل هذه السياسة لاحقاً. سنخبرك بأي تغيير مهم عبر التطبيق أو البريد.
              </p>
            </section>
          </div>
        </div>
      </div>
    </div>
  );
}

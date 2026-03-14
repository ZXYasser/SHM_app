import { Link } from "react-router-dom";
import { FiMail, FiPhone } from "react-icons/fi";

/** بيانات التواصل — نفس قيم التذييل، يمكنك تعديلها */
const CONTACT = {
  email: "info@shm.sa",
  phone: "05xxxxxxxx",
  appName: "ورشة سهم",
};

export default function DeleteAccount() {
  return (
    <div className="w-full flex flex-col items-center px-4 pt-6 pb-20">
      <div className="w-full max-w-2xl mx-auto">
        <div className="bg-white rounded-2xl shadow-lg border border-gray-100 p-8 sm:p-10">
          <h1 className="text-2xl sm:text-3xl font-bold text-blue-600 mb-2 text-center">
            طلب حذف الحساب والبيانات
          </h1>
          <p className="text-gray-500 text-sm mb-8 text-center">
            تطبيق {CONTACT.appName} — خدمة ورشة سيارات متنقلة
          </p>

          <p className="text-gray-600 leading-relaxed mb-8 text-center">
            إذا رغبت في حذف حسابك وجميع البيانات المرتبطة به من تطبيق {CONTACT.appName}، يرجى اتباع الخطوات أدناه. نلتزم بحقك في طلب حذف بياناتك وفقاً لسياسة الخصوصية والأنظمة المعمول بها.
          </p>

          <div className="space-y-8">
            <section className="pb-8 border-b border-gray-100">
              <h2 className="text-lg font-bold text-gray-800 mb-3 text-center">
                الخطوات المطلوبة لطلب الحذف
              </h2>
              <ol className="list-decimal list-inside space-y-3 text-gray-600 leading-relaxed text-center max-w-lg mx-auto">
                <li>تواصل معنا عبر أحد الوسيلتين أدناه (البريد الإلكتروني أو رقم الهاتف).</li>
                <li>اذكر طلبك بوضوح: «أريد حذف حسابي وجميع بياناتي المرتبطة به من تطبيق {CONTACT.appName}».</li>
                <li>أرفق أو اذكر البريد الإلكتروني أو رقم الجوال المرتبط بحسابك في التطبيق لتسهيل عملية التعريف.</li>
                <li>سنراجع طلبك ونرد عليك خلال مدة لا تتجاوز 30 يوماً (أو وفق المدة التي ينص عليها النظام).</li>
                <li>بعد التأكد من هويتك، سنقوم بحذف الحساب والبيانات وفق ما هو موضح في قسم «ما الذي سيتم حذفه؟» أدناه.</li>
              </ol>
            </section>

            <section className="pb-8 border-b border-gray-100">
              <h2 className="text-lg font-bold text-gray-800 mb-3 text-center">
                وسائل التواصل لطلب الحذف
              </h2>
              <div className="flex flex-col sm:flex-row items-center justify-center gap-6 text-gray-600">
                <a
                  href={`mailto:${CONTACT.email}?subject=طلب حذف الحساب والبيانات - ${CONTACT.appName}`}
                  className="inline-flex items-center gap-2 text-blue-600 hover:text-blue-700 font-medium"
                >
                  <FiMail size={20} />
                  <span>{CONTACT.email}</span>
                </a>
                <a
                  href={`tel:${CONTACT.phone}`}
                  className="inline-flex items-center gap-2 text-blue-600 hover:text-blue-700 font-medium"
                >
                  <FiPhone size={20} />
                  <span>{CONTACT.phone}</span>
                </a>
              </div>
              <p className="text-gray-500 text-sm mt-4 text-center">
                يمكنك أيضاً استخدام قائمة «تواصل معنا» أو «مساعدة» داخل التطبيق وإرسال نفس الطلب.
              </p>
            </section>

            <section className="pb-8 border-b border-gray-100">
              <h2 className="text-lg font-bold text-gray-800 mb-3 text-center">
                ما الذي سيتم حذفه؟
              </h2>
              <p className="text-gray-600 leading-relaxed text-center mb-3">
                عند تنفيذ طلب الحذف، نقوم بحذف البيانات التالية المرتبطة بحسابك:
              </p>
              <ul className="list-disc list-inside space-y-1 text-gray-600 leading-relaxed text-center max-w-lg mx-auto">
                <li>بيانات الحساب (البريد الإلكتروني، رقم الجوال، معلومات التسجيل).</li>
                <li>سجل الطلبات وبياناتها (نوع الخدمة، الموقع، تفاصيل المركبة، الملاحظات).</li>
                <li>أي بيانات أخرى مخزنة في أنظمتنا والمرتبطة بمعرف حسابك.</li>
              </ul>
            </section>

            <section className="pb-8 border-b border-gray-100">
              <h2 className="text-lg font-bold text-gray-800 mb-3 text-center">
                ما الذي قد يُحتفظ به؟
              </h2>
              <p className="text-gray-600 leading-relaxed text-center">
                قد نحتفظ ببعض السجلات لأغراض قانونية أو محاسبية أو لحل النزاعات، مثل: نسخ مجهولة أو مجمعة لا تُعرّفك شخصياً، أو سجلات المعاملات المالية للفترة التي يفرضها القانون. لا نستخدم هذه البيانات لإعادة التعريف بك أو للتواصل معك بعد تنفيذ طلب الحذف.
              </p>
            </section>

            <section className="pb-8 border-b border-gray-100">
              <h2 className="text-lg font-bold text-gray-800 mb-3 text-center">
                مدة الاحتفاظ بعد الحذف
              </h2>
              <p className="text-gray-600 leading-relaxed text-center">
                يتم تنفيذ حذف الحساب والبيانات الشخصية خلال المدة المذكورة في الرد على طلبك (عادةً خلال 30 يوماً من التأكد من الهوية). أي بيانات يُستثنى الاحتفاظ بها لأسباب قانونية تخضع لفترات الاحتفاظ وفق الأنظمة المعمول بها في المملكة العربية السعودية.
              </p>
            </section>

            <section>
              <h2 className="text-lg font-bold text-gray-800 mb-3 text-center">
                سياسة الخصوصية وحقوقك
              </h2>
              <p className="text-gray-600 leading-relaxed text-center mb-4">
                لمزيد من التفاصيل حول جمعنا لبياناتك وحقوقك، يرجى الاطلاع على{" "}
                <Link to="/privacy" className="text-blue-600 hover:text-blue-700 font-medium underline">
                  سياسة الخصوصية
                </Link>
                .
              </p>
              <p className="text-gray-500 text-sm text-center">
                آخر تحديث: 2026
              </p>
            </section>
          </div>
        </div>
      </div>
    </div>
  );
}

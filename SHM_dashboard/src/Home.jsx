import { Link } from "react-router-dom";
import { FiDollarSign, FiShield, FiTool, FiCalendar, FiSmartphone, FiMapPin, FiTruck } from "react-icons/fi";

export default function Home() {
  const benefits = [
    { icon: FiDollarSign, title: "توفير يصل إلى 47%", subtitle: "مقارنة بورش الوكلاء" },
    { icon: FiShield, title: "فنيون معتمدون ومؤهلون بالكامل", subtitle: "على مستوى الدولة" },
    { icon: FiTool, title: "ضمان لمدة عام", subtitle: "على جميع القطع والإصلاحات" },
    { icon: FiCalendar, title: "حجوزات في نفس اليوم أو اليوم التالي", subtitle: "في منزلك أو مكتبك" },
  ];

  const howItWorks = [
    {
      icon: FiSmartphone,
      title: "احصل على عرض سعر فوري",
      description: "اختر سيارتك وموقعك، أخبرنا ما الخطأ، وسنقدم لك سعراً ثابتاً فورياً في ثوانٍ.",
    },
    {
      icon: FiMapPin,
      title: "اختر التاريخ والوقت والموقع",
      description: "سيأتي الفني إلى العنوان الذي يناسبك، في التاريخ والوقت الذي تختاره.",
    },
    {
      icon: FiTruck,
      title: "الفني يأتي إليك",
      description: "لا داعي للذهاب إلى الورشة — بمجرد الحجز، فقط اجلس واسترخِ بينما يأتي الفني إليك.",
    },
  ];

  return (
    <div className="w-full flex flex-col items-center">
      {/* حاوية المحتوى — في منتصف الصفحة بعرض أقصى ومسافات جانبية */}
      <div className="w-full max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col pt-2">
      {/* ─── القسم 1: الهيرو — شريط كامل مع شكل هندسي ─── */}
      <section className="w-full relative bg-gradient-to-b from-gray-50 to-white overflow-hidden rounded-2xl">
        <div className="absolute top-0 left-0 w-full h-full max-w-2xl bg-blue-500/5 rounded-br-[200px] lg:rounded-br-[300px]" aria-hidden />
        <div className="w-full px-6 lg:px-10 py-16 lg:py-24">
          <div className="relative flex flex-col lg:flex-row items-center justify-between gap-14 lg:gap-16">
            <div className="flex-1 order-2 lg:order-1 flex justify-center lg:justify-end">
              <div className="w-[260px] sm:w-[300px] drop-shadow-2xl" style={{ transform: "perspective(800px) rotateY(-8deg) rotateX(2deg)" }}>
                <div className="bg-gray-900 rounded-[2.5rem] p-2.5 shadow-2xl border-4 border-gray-800">
                  <div className="bg-white rounded-[2rem] overflow-hidden aspect-[9/19] relative">
                    <img src="/app-screenshot.png" alt="تطبيق ورشة سهم" className="absolute inset-0 w-full h-full object-cover object-top" />
                  </div>
                </div>
              </div>
            </div>
            <div className="flex-1 order-1 lg:order-2 text-center lg:text-right max-w-xl">
              <p className="text-blue-600 font-semibold text-sm tracking-wider mb-3">تطبيق ورشة سهم</p>
              <h1 className="text-3xl sm:text-4xl lg:text-5xl font-bold text-gray-900 mb-4 leading-tight">
                سيارتك تستحق الأفضل
                <br />
                <span className="text-blue-600">ورشة سهم</span>
              </h1>
              <p className="text-gray-600 leading-relaxed mb-8 text-base sm:text-lg">
                ورشة سهم خويك اللي ما يخليك — نخدمك بكل اللي تحتاجه سيارتك: عناية، صيانة، بنشر، بطارية، مفتاح، وخدمات طوارئ متنقلة.
              </p>
              <div className="flex flex-col sm:flex-row gap-3 justify-center lg:justify-start">
                <a href="https://play.google.com/store/apps" target="_blank" rel="noopener noreferrer" className="inline-flex items-center justify-center gap-2 px-6 py-3.5 bg-gray-900 hover:bg-gray-800 text-white rounded-xl font-semibold shadow-lg transition">
                  <span className="text-xl">▶</span>
                  <span>متوفر على Google Play</span>
                </a>
                <a href="https://www.apple.com/app-store/" target="_blank" rel="noopener noreferrer" className="inline-flex items-center justify-center gap-2 px-6 py-3.5 bg-gray-900 hover:bg-gray-800 text-white rounded-xl font-semibold shadow-lg transition">
                  <span className="font-bold">App</span>
                  <span>متوفر على App Store</span>
                </a>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ─── القسم 2: مميزاتنا — شريط بخلفية مميزة وعنوان واضح ─── */}
      <section id="services" className="w-full scroll-mt-24 bg-white border border-t-0 border-gray-100 rounded-2xl rounded-t-none mt-6">
        <div className="w-full px-6 lg:px-10 py-16 lg:py-20">
          <div className="flex items-center gap-4 mb-12">
            <span className="flex h-14 w-1.5 rounded-full bg-blue-600" aria-hidden />
            <div>
              <p className="text-blue-600 text-base lg:text-lg font-semibold tracking-wide mb-2">لماذا نحن</p>
              <h2 className="text-2xl lg:text-3xl font-bold text-gray-900">مميزاتنا</h2>
            </div>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-10">
            {benefits.map(({ icon: Icon, title, subtitle }) => (
              <div key={title} className="flex flex-col items-center text-center">
                <Icon className="mb-4 text-blue-600 shrink-0" size={64} strokeWidth={2} />
                <h3 className="text-gray-900 font-bold text-lg mb-2">{title}</h3>
                <p className="text-gray-600 text-sm leading-relaxed">{subtitle}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* فاصل أبيض بين مميزاتنا والخطوات */}
      <div className="w-full bg-white min-h-[80px] py-12 lg:py-16" aria-hidden="true" />

      {/* ─── القسم 3: كيف يعمل — شريط رمادي فاتح وثلاث بطاقات كبيرة ─── */}
      <section className="w-full bg-gray-50 border border-t-0 border-gray-100 rounded-2xl rounded-t-none">
        <div className="w-full px-6 lg:px-10 py-16 lg:py-20">
          <div className="text-center mb-14">
            <p className="text-blue-600 text-sm font-semibold tracking-wider mb-2">الخطوات</p>
            <h2 className="text-2xl lg:text-3xl font-bold text-gray-900 mb-3">احجز فنيًا موثوقًا به في بضع نقرات فقط</h2>
            <p className="text-gray-500 text-base max-w-xl mx-auto">كيف يعمل</p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {howItWorks.map(({ icon: Icon, title, description }, i) => (
              <div
                key={title}
                className="relative flex flex-col items-center text-center p-8 bg-white rounded-2xl border border-gray-200 shadow-sm hover:shadow-md hover:border-blue-100 transition-all duration-200"
              >
                <span className="absolute top-5 left-5 text-3xl font-black text-gray-100 leading-none">{String(i + 1).padStart(2, "0")}</span>
                <div className="w-16 h-16 rounded-2xl bg-blue-100 text-blue-600 flex items-center justify-center mb-5">
                  <Icon size={32} strokeWidth={2} />
                </div>
                <h3 className="text-gray-900 font-bold text-xl mb-3">{title}</h3>
                <p className="text-gray-600 text-sm leading-relaxed max-w-[280px]">{description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* فاصل أبيض بين الخطوات والوثائق */}
      <div className="w-full bg-white min-h-[80px] py-12 lg:py-16" aria-hidden="true" />

      {/* ─── القسم 4: السياسات — شريط أبيض وعناوين منظمة ─── */}
      <section className="w-full bg-white border border-t-0 border-gray-100 rounded-2xl rounded-t-none">
        <div className="w-full max-w-5xl mx-auto px-6 lg:px-10 py-16 lg:py-20">
          <div className="text-center mb-12">
            <p className="text-gray-500 text-sm font-semibold tracking-wider mb-1">الوثائق</p>
            <h2 className="text-2xl lg:text-3xl font-bold text-gray-900 mb-3">السياسات والوثائق</h2>
            <p className="text-gray-500 text-base max-w-md mx-auto">يمكنك الاطّلاع على سياسة الخصوصية والشروط وسياسة الاسترجاع.</p>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
            <Link
              to="/privacy"
              className="group flex flex-col items-center text-center p-8 bg-gray-50 rounded-2xl border border-gray-100 hover:border-blue-200 hover:bg-blue-50/30 transition-all duration-200"
            >
              <span className="text-4xl mb-4">🔒</span>
              <h3 className="font-bold text-gray-900 mb-2 text-lg group-hover:text-blue-600 transition">سياسة الخصوصية</h3>
              <p className="text-gray-600 text-sm leading-relaxed">كيف نتعامل مع بياناتك</p>
            </Link>
            <Link
              to="/terms"
              className="group flex flex-col items-center text-center p-8 bg-gray-50 rounded-2xl border border-gray-100 hover:border-blue-200 hover:bg-blue-50/30 transition-all duration-200"
            >
              <span className="text-4xl mb-4">📜</span>
              <h3 className="font-bold text-gray-900 mb-2 text-lg group-hover:text-blue-600 transition">الشروط والأحكام</h3>
              <p className="text-gray-600 text-sm leading-relaxed">شروط استخدام الخدمة</p>
            </Link>
            <Link
              to="/returns"
              className="group flex flex-col items-center text-center p-8 bg-gray-50 rounded-2xl border border-gray-100 hover:border-blue-200 hover:bg-blue-50/30 transition-all duration-200"
            >
              <span className="text-4xl mb-4">↩️</span>
              <h3 className="font-bold text-gray-900 mb-2 text-lg group-hover:text-blue-600 transition">سياسة الاسترجاع</h3>
              <p className="text-gray-600 text-sm leading-relaxed">الإلغاء والاسترداد</p>
            </Link>
          </div>
        </div>
      </section>
      </div>
    </div>
  );
}

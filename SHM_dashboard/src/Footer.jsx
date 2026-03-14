import { Link } from "react-router-dom";
import { FiMail, FiPhone } from "react-icons/fi";
import { FaFacebookF, FaTwitter, FaInstagram, FaLinkedinIn, FaWhatsapp } from "react-icons/fa";

/** بيانات التذييل — يمكنك تعديلها من هنا */
const FOOTER = {
  email: "info@shm.sa",
  phone: "05xxxxxxxx",
  social: {
    facebook: "https://facebook.com",
    twitter: "https://twitter.com",
    instagram: "https://instagram.com",
    linkedin: "https://linkedin.com",
    whatsapp: "https://wa.me/9665xxxxxxxx",
  },
  company: {
    name: "ورشة سهم",
    cr: "xxxxxxxxxx",
    vat: "3xxxxxxxxxxxxx",
    address: "المملكة العربية السعودية",
  },
};

export default function Footer() {
  return (
    <footer className="w-full mt-auto bg-[#faf8f5] border-t border-gray-200">
      {/* القسم العلوي — أربعة أعمدة */}
      <div className="w-full max-w-6xl mx-auto px-6 py-12">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-10 lg:gap-8 text-center lg:text-right">
          {/* 1. اتصل بنا */}
          <div>
            <h3 className="text-gray-800 font-bold text-lg mb-4">اتصل بنا</h3>
            <a
              href={`mailto:${FOOTER.email}`}
              className="flex items-center justify-center lg:justify-end gap-2 text-gray-600 hover:text-blue-600 transition mb-2"
            >
              <FiMail className="text-blue-600 shrink-0" size={18} />
              <span>{FOOTER.email}</span>
            </a>
            <a
              href={`tel:${FOOTER.phone}`}
              className="flex items-center justify-center lg:justify-end gap-2 text-gray-600 hover:text-blue-600 transition"
            >
              <FiPhone className="text-blue-600 shrink-0" size={18} />
              <span>{FOOTER.phone}</span>
            </a>
          </div>

          {/* 2. مساعدة */}
          <div>
            <h3 className="text-gray-800 font-bold text-lg mb-4">مساعدة</h3>
            <ul className="space-y-2">
              <li>
                <a href={`mailto:${FOOTER.email}`} className="text-gray-600 hover:text-blue-600 transition">
                  اتصل بنا
                </a>
              </li>
              <li>
                <Link to="/privacy" className="text-gray-600 hover:text-blue-600 transition">
                  سياسة الخصوصية
                </Link>
              </li>
              <li>
                <Link to="/terms" className="text-gray-600 hover:text-blue-600 transition">
                  الشروط والأحكام
                </Link>
              </li>
              <li>
                <Link to="/delete-account" className="text-gray-600 hover:text-blue-600 transition">
                  طلب حذف الحساب والبيانات
                </Link>
              </li>
            </ul>
          </div>

          {/* 3. الشركة */}
          <div>
            <h3 className="text-gray-800 font-bold text-lg mb-4">الشركة</h3>
            <ul className="space-y-2">
              <li>
                <Link to="/" className="text-gray-600 hover:text-blue-600 transition">
                  الرئيسية
                </Link>
              </li>
              <li>
                <a href="#services" className="text-gray-600 hover:text-blue-600 transition">
                  خدماتنا
                </a>
              </li>
              <li>
                <Link to="/returns" className="text-gray-600 hover:text-blue-600 transition">
                  سياسة الاسترجاع
                </Link>
              </li>
            </ul>
          </div>

          {/* 4. اللوجو + أزرار التطبيق */}
          <div className="flex flex-col items-center lg:items-end">
            <Link to="/" className="flex items-center gap-2 mb-1">
              <div className="w-11 h-11 bg-gradient-to-br from-blue-600 to-blue-500 rounded-xl flex items-center justify-center shadow-md">
                <span className="text-white font-bold text-xl">س</span>
              </div>
              <span className="text-xl font-bold text-gray-800">سهم</span>
            </Link>
            <p className="text-blue-600 text-sm font-medium mb-4">نوصلك للحل</p>
            <div className="flex flex-col sm:flex-row gap-3">
              <a
                href="https://play.google.com/store/apps"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center justify-center gap-2 px-5 py-2.5 bg-gray-900 hover:bg-gray-800 text-white rounded-lg text-sm font-medium transition"
              >
                <span className="text-lg">▶</span>
                <span>متوفر على Google Play</span>
              </a>
              <a
                href="https://www.apple.com/app-store/"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center justify-center gap-2 px-5 py-2.5 bg-gray-900 hover:bg-gray-800 text-white rounded-lg text-sm font-medium transition"
              >
                <span className="text-sm font-bold">App</span>
                <span>متوفر على App Store</span>
              </a>
            </div>
          </div>
        </div>
      </div>

      {/* خط فاصل */}
      <div className="w-full max-w-6xl mx-auto px-6">
        <div className="h-px bg-gray-200" />
      </div>

      {/* القسم السفلي — أيقونات التواصل، حقوق النشر، البيانات التجارية */}
      <div className="w-full max-w-6xl mx-auto px-6 py-8">
        <div className="flex flex-col lg:flex-row items-center justify-between gap-6">
          {/* يسار: سوشيال + حقوق النشر */}
          <div className="flex flex-col items-center lg:items-start gap-3">
            <div className="flex items-center gap-4">
              <a href={FOOTER.social.facebook} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:text-blue-700 transition p-1.5 rounded-full hover:bg-blue-50" aria-label="فيسبوك">
                <FaFacebookF size={20} />
              </a>
              <a href={FOOTER.social.twitter} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:text-blue-700 transition p-1.5 rounded-full hover:bg-blue-50" aria-label="تويتر">
                <FaTwitter size={20} />
              </a>
              <a href={FOOTER.social.instagram} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:text-blue-700 transition p-1.5 rounded-full hover:bg-blue-50" aria-label="انستغرام">
                <FaInstagram size={20} />
              </a>
              <a href={FOOTER.social.linkedin} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:text-blue-700 transition p-1.5 rounded-full hover:bg-blue-50" aria-label="لينكدإن">
                <FaLinkedinIn size={20} />
              </a>
              <a href={FOOTER.social.whatsapp} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:text-blue-700 transition p-1.5 rounded-full hover:bg-blue-50" aria-label="واتساب">
                <FaWhatsapp size={20} />
              </a>
            </div>
            <p className="text-gray-500 text-sm">جميع الحقوق محفوظة © {new Date().getFullYear()}</p>
            <p className="text-blue-600 text-xs font-medium">ورشة سهم</p>
          </div>

          {/* يمين: شارة ضريبة + بيانات الشركة */}
          <div className="flex flex-col items-center lg:items-end gap-3 text-center lg:text-right">
            <div className="px-4 py-2 bg-blue-600 text-white rounded-lg text-sm font-bold">
              ضريبة القيمة المضافة
            </div>
            <div className="text-gray-600 text-sm space-y-1 max-w-xs">
              <p>{FOOTER.company.name} · س.ج: {FOOTER.company.cr}</p>
              <p>الرقم الضريبي: {FOOTER.company.vat}</p>
              <p>العنوان: {FOOTER.company.address}</p>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}

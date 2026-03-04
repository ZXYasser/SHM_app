import { Outlet, Link, useLocation } from "react-router-dom";
import Footer from "./Footer";

export default function PublicLayout() {
  const location = useLocation();
  const isHome = location.pathname === "/";

  return (
    <div dir="rtl" className="min-h-screen bg-white flex flex-col">
      {/* هيدر على طراز الصفحة المرجعية: لوجو | تنقل | أزرار */}
      <header className="w-full bg-white border-b border-gray-100 sticky top-0 z-50 shadow-sm">
        <div className="w-full max-w-6xl mx-auto px-6 py-4 flex flex-row items-center justify-between gap-6">
          {/* اللوجو — يمين */}
          <Link to="/" className="flex items-center gap-2 shrink-0 hover:opacity-90 transition">
            <div className="w-10 h-10 bg-gradient-to-br from-blue-600 to-blue-500 rounded-xl flex items-center justify-center shadow-md">
              <span className="text-white font-bold text-xl">س</span>
            </div>
            <span className="text-xl font-bold text-gray-800">سهم</span>
          </Link>

          {/* التنقل — وسط */}
          <nav className="flex flex-wrap items-center justify-center gap-1 min-w-0">
            <Link
              to="/"
              className={`px-4 py-2 rounded-lg font-medium transition text-center focus:outline-none focus:ring-2 focus:ring-blue-500/30 focus:ring-offset-2 ${
                isHome ? "text-blue-600 border-b-2 border-blue-600" : "text-gray-600 hover:text-blue-600 hover:bg-blue-50"
              }`}
            >
              الرئيسية
            </Link>
            <a href="#services" className="px-4 py-2 text-gray-600 hover:text-blue-600 hover:bg-blue-50 rounded-lg font-medium transition text-center">
              خدماتنا
            </a>
            <Link to="/privacy" className="px-4 py-2 text-gray-600 hover:text-blue-600 hover:bg-blue-50 rounded-lg font-medium transition text-center">
              السياسات
            </Link>
          </nav>

          {/* أزرار الإجراء — يسار (في RTL) */}
          <div className="flex items-center gap-3 shrink-0">
            <Link
              to="/dashboard"
              className="inline-flex items-center justify-center px-4 py-2.5 border-2 border-blue-600 text-blue-600 rounded-xl font-semibold hover:bg-blue-50 transition text-center focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2"
            >
              دخول الإدارة
            </Link>
            <a
              href="https://play.google.com/store/apps"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center justify-center gap-2 px-5 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-semibold shadow-md hover:shadow-lg transition text-center focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2"
            >
              حمل التطبيق
            </a>
          </div>
        </div>
      </header>

      <main className="flex-1 w-full flex flex-col items-center pt-20 lg:pt-24 pb-20">
        <Outlet />
      </main>

      <Footer />
    </div>
  );
}

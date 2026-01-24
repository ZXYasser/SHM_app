import { useState } from "react";
import { FiUser, FiLock, FiLogIn, FiAlertCircle, FiLoader } from "react-icons/fi";

export default function Login({ onLogin }) {
  const [username, setUsername] = useState("");
  const [pass, setPass] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = async () => {
    // Reset error
    setError("");
    
    // Validation
    if (!username.trim() || !pass.trim()) {
      setError("يرجى إدخال جميع الحقول");
      return;
    }

    setLoading(true);

    // Simulate API call
    setTimeout(() => {
      if (username === "admin" && pass === "shm123") {
        setLoading(false);
        onLogin();
      } else {
        setLoading(false);
        setError("بيانات الدخول غير صحيحة");
      }
    }, 800);
  };

  const handleKeyPress = (e) => {
    if (e.key === "Enter") {
      handleLogin();
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-600 via-blue-500 to-blue-400 flex items-center justify-center p-6 relative overflow-hidden">
      {/* Enhanced Background Pattern */}
      <div className="absolute inset-0">
        {/* Geometric Pattern */}
        <div className="absolute inset-0 bg-[linear-gradient(to_right,rgba(255,255,255,0.08)_1px,transparent_1px),linear-gradient(to_bottom,rgba(255,255,255,0.08)_1px,transparent_1px)] bg-[size:50px_50px]"></div>
        
        {/* Decorative Circles */}
        <div className="absolute top-0 right-0 w-96 h-96 bg-blue-400/20 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2"></div>
        <div className="absolute bottom-0 left-0 w-96 h-96 bg-blue-500/20 rounded-full blur-3xl translate-y-1/2 -translate-x-1/2"></div>
        <div className="absolute top-1/2 left-1/2 w-80 h-80 bg-blue-300/15 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2"></div>
        
        {/* Diagonal Lines */}
        <div className="absolute inset-0 bg-[linear-gradient(45deg,transparent_30%,rgba(255,255,255,0.05)_50%,transparent_70%)] bg-[size:100px_100px]"></div>
      </div>

      {/* Login Card */}
      <div className="relative w-full max-w-lg bg-white rounded-2xl shadow-2xl overflow-hidden">
        {/* Top Accent Bar */}
        <div className="h-2 bg-gradient-to-r from-blue-600 via-blue-500 to-blue-400"></div>

        {/* Card Content */}
        <div className="p-12">
          {/* Logo Section */}
          <div className="flex flex-col items-center mb-10">
            <div className="w-16 h-16 bg-gradient-to-br from-blue-600 to-blue-500 rounded-xl flex items-center justify-center shadow-lg mb-4">
              <span className="text-white font-bold text-3xl">سهم</span>
            </div>
            <h1 className="text-2xl font-bold text-gray-800 mb-2">
              تسجيل الدخول
            </h1>
            <p className="text-sm text-gray-500 text-center">
              لوحة تحكم سهم - نظام إدارة الطلبات
            </p>
          </div>

          {/* Error Message */}
          {error && (
            <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg flex items-center gap-3">
              <FiAlertCircle className="text-red-600 flex-shrink-0" size={20} />
              <p className="text-red-700 text-sm font-medium">{error}</p>
            </div>
          )}

          {/* Input Fields */}
          <div className="space-y-5">
            {/* Username Field */}
            <div>
              <label className="block text-gray-700 text-sm font-semibold mb-2">
                اسم المستخدم
              </label>
              <div className="flex items-center gap-3">
                <div className="flex-shrink-0 w-8 h-10 flex items-center justify-center text-gray-400">
                  <FiUser size={20} />
                </div>
                <div className="flex-1 max-w-sm">
                  <input
                    type="text"
                    className="w-full border-2 border-gray-200 p-4 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all duration-200 bg-white hover:border-gray-300 placeholder-gray-400 placeholder-opacity-70"
                    placeholder="أدخل اسم المستخدم"
                    value={username}
                    onChange={(e) => {
                      setUsername(e.target.value);
                      setError("");
                    }}
                    onKeyPress={handleKeyPress}
                    disabled={loading}
                  />
                </div>
              </div>
            </div>

            {/* Password Field */}
            <div>
              <label className="block text-gray-700 text-sm font-semibold mb-2 ">
                كلمة المرور
              </label>
              <div className="flex items-center gap-3">
                <div className="flex-shrink-0 w-8 h-10 flex items-center justify-center text-gray-400 ">
                  <FiLock size={20} />
                </div>
                <div className="flex-1 max-w-sm relative">
                  <input
                    type={showPassword ? "text" : "password"}
                    className="w-full border-2 border-gray-200 p-4 pr-16 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all duration-200 bg-white hover:border-gray-300 placeholder-gray-400 placeholder-opacity-70"
                    placeholder="أدخل كلمة المرور"
                    value={pass}
                    onChange={(e) => {
                      setPass(e.target.value);
                      setError("");
                    }}
                    onKeyPress={handleKeyPress}
                    disabled={loading}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute left-4 top-1/2 transform -translate-y-1/2 text-sm text-blue-600 hover:text-blue-700 font-medium transition-colors px-2 py-1 rounded hover:bg-blue-50 "
                    tabIndex={-1}
                  >
                    {showPassword ? "إخفاء" : "عرض"}
                  </button>
                </div>
              </div>
            </div>
          </div>




          {/**************** Login Button ****************/}
          <div className="mt-8 flex justify-center">
            <button
              onClick={handleLogin}
              disabled={loading}
              className="w-80 bg-blue-600 hover:bg-blue-700 text-white py-3.5 rounded-lg text-base font-semibold shadow-md hover:shadow-lg transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
            {loading ? (
              <>
                <FiLoader className="animate-spin" size={20} />
                <span>جاري التحقق...</span>
              </>
            ) : (
              <>
                <FiLogIn size={20} />
                <span>دخول</span>
              </>
            )}
            </button>
          </div>

          {/* Footer */}
          <div className="mt-8 pt-6 border-t border-gray-200">
            <p className="text-center text-gray-500 text-xs">
              © {new Date().getFullYear()} سهم Dashboard - جميع الحقوق محفوظة
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

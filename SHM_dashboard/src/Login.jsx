import { useState } from "react";
import { FiPhone, FiLock, FiLogIn, FiAlertCircle, FiLoader } from "react-icons/fi";

export default function Login({ onLogin }) {
  const [phone, setPhone] = useState("");
  const [pass, setPass] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = async () => {
    // Reset error
    setError("");
    
    // Validation
    if (!phone.trim() || !pass.trim()) {
      setError("يرجى إدخال جميع الحقول");
      return;
    }

    // Phone validation (Saudi format)
    const phoneRegex = /^(05|5)[0-9]{8}$/;
    const cleanPhone = phone.replace(/\s/g, '');
    if (!phoneRegex.test(cleanPhone)) {
      setError("يرجى إدخال رقم جوال صحيح (مثال: 0501234567)");
      return;
    }

    setLoading(true);

    // Simulate API call
    setTimeout(() => {
      if ((phone === "admin" || cleanPhone === "0500000000") && pass === "shm123") {
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
      {/* Animated Background Elements */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-blue-400 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-blob"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-blue-500 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-blob animation-delay-2000"></div>
        <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-80 h-80 bg-blue-300 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-blob animation-delay-4000"></div>
      </div>

      {/* Container */}
      <div className="relative w-full max-w-md relative z-10 animate-[fadeIn_0.8s_ease] group/card">
        {/* Ultra Premium Multi-layer Glow System */}
        <div className="absolute -inset-4 bg-gradient-to-r from-blue-300 via-blue-500 via-blue-400 to-blue-500 rounded-[3rem] opacity-20 blur-3xl group-hover/card:opacity-35 transition-opacity duration-1000 animate-pulse"></div>
        <div className="absolute -inset-3 bg-gradient-to-r from-blue-500 via-blue-400 to-blue-500 rounded-[2.8rem] opacity-15 blur-2xl group-hover/card:opacity-25 transition-opacity duration-800"></div>
        <div className="absolute -inset-2 bg-gradient-to-r from-blue-400 via-blue-500 via-blue-300 to-blue-500 rounded-[2.5rem] opacity-10 blur-xl group-hover/card:opacity-20 transition-opacity duration-600"></div>
        
        {/* Animated Rotating Gradient Border - Always Visible */}
        <div className="absolute -inset-1 rounded-[2.4rem] overflow-hidden">
          <div className="absolute inset-0 rounded-[2.4rem] bg-gradient-to-r from-blue-500 via-blue-400 via-blue-300 via-blue-400 via-blue-500 to-blue-400 bg-[length:400%_100%] animate-[gradient_6s_linear_infinite] opacity-60 group-hover/card:opacity-100 transition-opacity duration-500"></div>
          <div className="absolute inset-[3px] rounded-[2.3rem] bg-gradient-to-br from-white via-white to-blue-50/30 backdrop-blur-2xl"></div>
        </div>
        
        {/* Secondary Animated Border Layer */}
        <div className="absolute -inset-0.5 rounded-[2.35rem] overflow-hidden opacity-0 group-hover/card:opacity-100 transition-opacity duration-700">
          <div className="absolute inset-0 rounded-[2.35rem] bg-gradient-to-r from-blue-600 via-blue-500 via-blue-400 to-blue-600 bg-[length:300%_100%] animate-[gradient_4s_linear_infinite]"></div>
        </div>
        
        {/* Main Card with Ultra Premium Design */}
        <div className="relative bg-gradient-to-br from-white via-white/98 to-white/95 backdrop-blur-3xl rounded-[2.3rem] border-2 border-white/80 shadow-[0_25px_70px_-15px_rgba(0,0,0,0.4),0_15px_50px_-10px_rgba(59,130,246,0.4),inset_0_1px_0_rgba(255,255,255,0.9)] overflow-hidden">
          {/* Ultra Premium Shimmer Effect */}
          <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/40 via-white/30 via-white/20 to-transparent -translate-x-full group-hover/card:translate-x-full transition-transform duration-[4000ms] ease-in-out"></div>
          
          {/* Multi-layer Premium Gradient Overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white via-white/98 to-blue-50/50 pointer-events-none"></div>
          <div className="absolute inset-0 bg-gradient-to-t from-white/60 via-transparent to-transparent pointer-events-none"></div>
          <div className="absolute inset-0 bg-gradient-to-b from-transparent via-transparent to-blue-50/30 pointer-events-none"></div>
          
          {/* Premium Dot Pattern with Animation */}
          <div className="absolute inset-0 opacity-[0.04] bg-[radial-gradient(circle_at_2px_2px,rgb(59,130,246)_1px,transparent_0)] bg-[length:28px_28px] pointer-events-none animate-[patternMove_20s_linear_infinite]"></div>
          
          {/* Ultra Advanced Corner Decorations */}
          <div className="absolute -top-24 -right-24 w-72 h-72 bg-gradient-to-br from-blue-300/25 via-blue-200/20 via-blue-100/15 to-transparent rounded-full blur-3xl animate-pulse"></div>
          <div className="absolute -bottom-20 -left-20 w-56 h-56 bg-gradient-to-tr from-blue-300/20 via-blue-200/15 via-blue-100/10 to-transparent rounded-full blur-3xl animate-pulse animation-delay-2000"></div>
          <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-blue-200/10 rounded-full blur-3xl animate-pulse animation-delay-4000"></div>
          
          {/* Premium Inner Border with Multi-layer Glow */}
          <div className="absolute inset-[3px] rounded-[2.2rem] bg-gradient-to-br from-white via-white/98 to-white/95 pointer-events-none border border-white/60"></div>
          <div className="absolute inset-[4px] rounded-[2.15rem] bg-gradient-to-br from-white/50 via-transparent to-transparent pointer-events-none"></div>
          
          {/* Enhanced Floating Light Orbs */}
          <div className="absolute top-10 right-10 w-3 h-3 bg-blue-400/70 rounded-full blur-md animate-pulse shadow-lg shadow-blue-400/50"></div>
          <div className="absolute bottom-14 left-14 w-2 h-2 bg-blue-500/60 rounded-full blur-sm animate-pulse animation-delay-1000 shadow-lg shadow-blue-500/40"></div>
          <div className="absolute top-1/3 right-1/4 w-1.5 h-1.5 bg-blue-300/50 rounded-full blur-sm animate-pulse animation-delay-2000"></div>
          
          {/* Subtle Grid Overlay */}
          <div className="absolute inset-0 opacity-[0.015] bg-[linear-gradient(to_right,rgba(59,130,246,0.1)_1px,transparent_1px),linear-gradient(to_bottom,rgba(59,130,246,0.1)_1px,transparent_1px)] bg-[size:40px_40px] pointer-events-none"></div>
          
          {/* Content Container */}
          <div className="relative z-10 p-8 md:p-10">
        
        {/* Logo Section */}
        <div className="flex flex-col items-center mb-8">
          <div className="relative mb-6">
            {/* Outer Glow */}
            <div className="absolute inset-0 bg-gradient-to-br from-blue-400/50 to-blue-600/50 rounded-2xl blur-xl opacity-50 animate-pulse"></div>
            
            {/* Logo Container */}
            <div className="relative w-20 h-20 bg-gradient-to-br from-blue-600 via-blue-500 to-blue-400 rounded-2xl flex items-center justify-center shadow-2xl transform hover:scale-105 transition-all duration-300 hover:shadow-blue-500/50">
              <span className="text-white font-bold text-4xl drop-shadow-lg">س</span>
            </div>
            
            {/* Animated Ring */}
            <div className="absolute -top-1 -right-1 w-6 h-6 bg-blue-400 rounded-full animate-ping opacity-75"></div>
            <div className="absolute -top-1 -right-1 w-6 h-6 bg-blue-500 rounded-full"></div>
            
            {/* Decorative Dots */}
            <div className="absolute -bottom-2 -left-2 w-3 h-3 bg-blue-300 rounded-full opacity-60"></div>
            <div className="absolute -bottom-2 -right-2 w-2 h-2 bg-blue-400 rounded-full opacity-60"></div>
          </div>
          
          <h1 className="text-3xl font-bold bg-gradient-to-r from-gray-800 to-gray-600 bg-clip-text text-transparent mb-2">
            تسجيل الدخول
          </h1>
          <p className="text-center text-gray-500 text-sm font-medium">
            مرحبًا بك في لوحة تحكم سهم
          </p>
        </div>

        {/* Error Message */}
        {error && (
          <div className="mb-6 p-4 bg-gradient-to-r from-red-50 to-red-100/50 border border-red-200/50 rounded-xl flex items-center gap-3 animate-[slideDown_0.3s_ease] shadow-lg backdrop-blur-sm">
            <div className="flex-shrink-0 w-10 h-10 bg-red-100 rounded-full flex items-center justify-center">
              <FiAlertCircle className="text-red-600" size={18} />
            </div>
            <p className="text-red-700 text-sm font-semibold">{error}</p>
          </div>
        )}

        {/* Input Fields */}
        <div className="space-y-5">
          {/* Phone Field */}
          <div>
            <label className="block text-gray-700 text-sm font-semibold mb-2">
              رقم الجوال
            </label>
            <div className="relative">
              <div className="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 z-10">
                <FiPhone size={20} />
              </div>
              <input
                type="tel"
                className="w-full border-2 border-gray-200/60 p-4 pr-12 rounded-2xl focus:ring-4 focus:ring-blue-500/30 focus:border-blue-500 outline-none transition-all duration-300 bg-gradient-to-br from-white to-gray-50/50 backdrop-blur-sm focus:bg-white focus:shadow-2xl focus:shadow-blue-500/30 hover:border-blue-400/60 hover:shadow-lg placeholder-gray-400 font-medium"
                placeholder="05xxxxxxxx"
                value={phone}
                onChange={(e) => {
                  // Allow only numbers
                  const value = e.target.value.replace(/\D/g, '');
                  setPhone(value);
                  setError("");
                }}
                onKeyPress={handleKeyPress}
                disabled={loading}
                maxLength={10}
              />
              {/* Premium Input Glow Effect */}
              <div className="absolute inset-0 rounded-2xl bg-gradient-to-r from-blue-500/0 via-blue-500/15 to-blue-500/0 opacity-0 focus-within:opacity-100 transition-opacity duration-500 pointer-events-none blur-sm"></div>
              <div className="absolute -inset-0.5 rounded-2xl bg-gradient-to-r from-blue-400 to-blue-500 opacity-0 focus-within:opacity-20 transition-opacity duration-500 pointer-events-none blur-md"></div>
            </div>
            <p className="text-xs text-gray-400 mt-1 pr-1">مثال: 0501234567</p>
          </div>

          {/* Password Field */}
          <div>
            <label className="block text-gray-700 text-sm font-semibold mb-2">
              كلمة المرور
            </label>
            <div className="relative">
              <div className="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 z-10">
                <FiLock size={20} />
              </div>
              <input
                type={showPassword ? "text" : "password"}
                className="w-full border-2 border-gray-200/60 p-4 pr-12 pl-16 rounded-2xl focus:ring-4 focus:ring-blue-500/30 focus:border-blue-500 outline-none transition-all duration-300 bg-gradient-to-br from-white to-gray-50/50 backdrop-blur-sm focus:bg-white focus:shadow-2xl focus:shadow-blue-500/30 hover:border-blue-400/60 hover:shadow-lg placeholder-gray-400 font-medium"
                placeholder="أدخل كلمة المرور"
                value={pass}
                onChange={(e) => {
                  setPass(e.target.value);
                  setError("");
                }}
                onKeyPress={handleKeyPress}
                disabled={loading}
              />
              {/* Premium Input Glow Effect */}
              <div className="absolute inset-0 rounded-2xl bg-gradient-to-r from-blue-500/0 via-blue-500/15 to-blue-500/0 opacity-0 focus-within:opacity-100 transition-opacity duration-500 pointer-events-none blur-sm"></div>
              <div className="absolute -inset-0.5 rounded-2xl bg-gradient-to-r from-blue-400 to-blue-500 opacity-0 focus-within:opacity-20 transition-opacity duration-500 pointer-events-none blur-md"></div>
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute left-4 top-1/2 transform -translate-y-1/2 text-sm text-blue-600 hover:text-blue-700 font-medium transition-colors z-10 px-2 py-1 rounded-lg hover:bg-blue-50"
                tabIndex={-1}
              >
                {showPassword ? "إخفاء" : "عرض"}
              </button>
            </div>
          </div>
        </div>

        {/* Login Button */}
        <button
          onClick={handleLogin}
          disabled={loading}
          className="relative mt-8 w-full bg-gradient-to-r from-blue-600 via-blue-500 to-blue-600 text-white py-4 rounded-2xl text-lg font-bold shadow-xl hover:shadow-2xl hover:shadow-blue-500/60 transition-all duration-300 transform hover:scale-[1.02] active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none flex items-center justify-center gap-2 overflow-hidden group/btn"
        >
          {/* Button Glow */}
          <div className="absolute inset-0 bg-gradient-to-r from-blue-400 to-blue-600 opacity-0 group-hover/btn:opacity-100 transition-opacity duration-300 rounded-2xl blur-xl"></div>
          
          {/* Button Shine Effect */}
          <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/30 to-transparent -translate-x-full group-hover/btn:translate-x-full transition-transform duration-1000 rounded-2xl"></div>
          
          {/* Button Border Glow */}
          <div className="absolute -inset-0.5 bg-gradient-to-r from-blue-400 via-blue-500 to-blue-400 rounded-2xl opacity-0 group-hover/btn:opacity-100 blur-sm transition-opacity duration-300"></div>
          
          <span className="relative z-10 flex items-center gap-2">
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
          </span>
        </button>

        {/* Footer */}
        <div className="mt-8 pt-6 border-t border-gradient-to-r from-transparent via-gray-200/50 to-transparent">
          <p className="text-center text-gray-400 text-xs font-medium">
            © {new Date().getFullYear()} سهم Dashboard
          </p>
          <p className="text-center text-gray-400 text-xs mt-1">
            جميع الحقوق محفوظة
          </p>
        </div>
          </div>
        </div>
      </div>

      <style>{`
        @keyframes blob {
          0%, 100% {
            transform: translate(0, 0) scale(1);
          }
          33% {
            transform: translate(30px, -50px) scale(1.1);
          }
          66% {
            transform: translate(-20px, 20px) scale(0.9);
          }
        }
        .animate-blob {
          animation: blob 7s infinite;
        }
        .animation-delay-2000 {
          animation-delay: 2s;
        }
        .animation-delay-4000 {
          animation-delay: 4s;
        }
        @keyframes slideDown {
          from {
            opacity: 0;
            transform: translateY(-10px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        @keyframes gradient {
          0% {
            background-position: 0% 50%;
          }
          50% {
            background-position: 100% 50%;
          }
          100% {
            background-position: 0% 50%;
          }
        }
        @keyframes patternMove {
          0% {
            background-position: 0 0;
          }
          100% {
            background-position: 28px 28px;
          }
        }
        .animation-delay-1000 {
          animation-delay: 1s;
        }
        .animation-delay-2000 {
          animation-delay: 2s;
        }
        .animation-delay-4000 {
          animation-delay: 4s;
        }
      `}</style>
    </div>
  );
}

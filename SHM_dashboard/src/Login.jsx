import { useState } from "react";

export default function Login({ onLogin }) {
  const [email, setEmail] = useState("");
  const [pass, setPass] = useState("");

  const handleLogin = () => {
    if (email === "admin" && pass === "shm123") {
      onLogin();
    } else {
      alert("بيانات الدخول غير صحيحة");
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-700 to-green-500 flex items-center justify-center p-6">
      
      {/* Container */}
      <div className="bg-white w-[380px] p-8 rounded-2xl shadow-2xl border border-gray-100 animate-[fadeIn_0.8s_ease]">
        
        {/* Logo */}
        <div className="flex justify-center mb-6">
          <div className="w-24 h-24 bg-green-600 rounded-full flex items-center justify-center">
            <span className="text-white font-bold text-3xl">س</span>
          </div>
        </div>


        {/* Title */}
        <h1 className="text-2xl font-extrabold text-center text-gray-800 mb-2">
          تسجيل الدخول
        </h1>

        <p className="text-center text-gray-500 mb-6 text-sm">
          مرحبًا بك في لوحة تحكم النظام
        </p>

        {/* Input Fields */}
        <div className="space-y-4">
          <div>
            <label className="text-gray-600 text-sm">البريد الإلكتروني</label>
            <input
              type="email"
              className="w-full border p-3 rounded-lg mt-1 shadow-sm focus:ring-2 focus:ring-green-500 focus:outline-none"
              placeholder="example@shm.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </div>

          <div>
            <label className="text-gray-600 text-sm">كلمة المرور</label>
            <input
              type="password"
              className="w-full border p-3 rounded-lg mt-1 shadow-sm focus:ring-2 focus:ring-green-500 focus:outline-none"
              placeholder="••••••••"
              value={pass}
              onChange={(e) => setPass(e.target.value)}
            />
          </div>
        </div>

        {/* Login Button */}
        <button
          onClick={handleLogin}
          className="mt-6 w-full bg-green-600 text-white py-3 rounded-lg text-lg font-semibold shadow-lg hover:bg-green-700 transition"
        >
          دخول
        </button>

        {/* Footer Text */}
        <p className="text-center text-gray-400 text-xs mt-6">
          © {new Date().getFullYear()} SHM Dashboard — جميع الحقوق محفوظة
        </p>
      </div>
    </div>
  );
}

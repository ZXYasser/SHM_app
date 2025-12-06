import { useState } from "react";
import {
  FiMenu,
  FiList,
  FiUsers,
  FiSettings,
  FiLogOut,
} from "react-icons/fi";

export default function Sidebar({ onNavigate, currentPage, onLogout }) {
  const [open, setOpen] = useState(true);

  const menuItems = [
    { name: "الطلبات", icon: <FiList size={20} />, key: "orders" },
    { name: "الفنيين", icon: <FiUsers size={20} />, key: "technicians" },
    { name: "الإعدادات", icon: <FiSettings size={20} />, key: "settings" },
  ];

  return (
    <div
      dir="rtl"
      className={`${
        open ? "w-64" : "w-20"
      } bg-gradient-to-b from-green-700 to-green-600 text-white min-h-screen p-4 transition-all duration-300 shadow-2xl flex flex-col`}
    >
      {/* Logo + Toggle */}
      <div className="flex items-center justify-between mb-10">
        {/* اسم النظام */}
        <div className={`flex items-center gap-3 transition-all duration-300 ${
          open ? "opacity-100" : "opacity-0 pointer-events-none"
        }`}>
          <div className="w-10 h-10 bg-white rounded-lg flex items-center justify-center">
            <span className="text-green-700 font-bold text-xl">س</span>
          </div>
          <h1 className="text-2xl font-bold">
            سهم
          </h1>
        </div>

        {/* زر القائمة */}
        <button 
          onClick={() => setOpen(!open)}
          className="p-2 hover:bg-green-600 rounded-lg transition"
        >
          <FiMenu size={22} />
        </button>
      </div>

      {/* القائمة */}
      <ul className="space-y-2 flex-1">
        {menuItems.map((item) => {
          const isActive = currentPage === item.key;
          return (
            <li
              key={item.key}
              onClick={() => onNavigate(item.key)}
              className={`flex items-center gap-4 p-3 rounded-lg cursor-pointer transition-all duration-200 ${
                isActive 
                  ? "bg-white text-green-700 shadow-lg" 
                  : "hover:bg-green-600 hover:bg-opacity-50"
              }`}
            >
              <span className={isActive ? "text-green-700" : ""}>{item.icon}</span>

              {/* الاختفاء عند الإغلاق */}
              <span
                className={`text-lg font-medium transition-all duration-300 whitespace-nowrap ${
                  open ? "opacity-100" : "opacity-0 pointer-events-none"
                }`}
              >
                {item.name}
              </span>
            </li>
          );
        })}
      </ul>

      {/* تسجيل الخروج */}
      <div
        onClick={onLogout}
        className="flex items-center gap-3 p-3 cursor-pointer hover:bg-red-600 rounded-lg transition mt-auto border-t border-green-600 pt-4"
      >
        <FiLogOut size={20} />
        {open && <span className="text-lg">تسجيل الخروج</span>}
      </div>
    </div>
  );
}

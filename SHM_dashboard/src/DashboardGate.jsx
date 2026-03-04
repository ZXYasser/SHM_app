import { useNavigate } from "react-router-dom";
import Login from "./Login";
import Dashboard from "./Dashboard";

/**
 * يعرض إما شاشة الدخول أو لوحة التحكم حسب حالة تسجيل الدخول.
 * لا يغيّر منطق Login أو Dashboard أو الـ API.
 */
export default function DashboardGate({ loggedIn, onLogin, onLogout }) {
  const navigate = useNavigate();

  const handleLogin = () => {
    onLogin();
    navigate("/dashboard", { replace: true });
  };

  const handleLogout = () => {
    onLogout();
    navigate("/", { replace: true });
  };

  if (!loggedIn) {
    return <Login onLogin={handleLogin} />;
  }

  return <Dashboard onLogout={handleLogout} />;
}

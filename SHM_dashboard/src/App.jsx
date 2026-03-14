import { useState } from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import PublicLayout from "./PublicLayout";
import Home from "./Home";
import Privacy from "./Privacy";
import Terms from "./Terms";
import Returns from "./Returns";
import DeleteAccount from "./DeleteAccount";
import DashboardGate from "./DashboardGate";

export default function App() {
  const [loggedIn, setLoggedIn] = useState(false);

  return (
    <BrowserRouter>
      <Routes>
        {/* صفحات عامة */}
        <Route element={<PublicLayout />}>
          <Route path="/" element={<Home />} />
          <Route path="/privacy" element={<Privacy />} />
          <Route path="/terms" element={<Terms />} />
          <Route path="/returns" element={<Returns />} />
          <Route path="/delete-account" element={<DeleteAccount />} />
        </Route>

        {/* لوحة الإدارة — محمية بتسجيل الدخول */}
        <Route
          path="/dashboard"
          element={
            <DashboardGate
              loggedIn={loggedIn}
              onLogin={() => setLoggedIn(true)}
              onLogout={() => setLoggedIn(false)}
            />
          }
        />

        {/* دخول الإدارة: إعادة توجيه إلى /dashboard */}
        <Route path="/login" element={<Navigate to="/dashboard" replace />} />

        {/* أي مسار غير معروف → الرئيسية */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
}

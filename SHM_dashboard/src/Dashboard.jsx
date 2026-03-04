import { useState, useRef } from "react";
import Sidebar from "./Sidebar";
import Orders from "./Orders";
import Technicians from "./Technicians";
import OrderDetails from "./OrderDetails";

/**
 * لوحة التحكم الداخلية — الطلبات، الفنيون، الإعدادات.
 * يُستخدم فقط بعد تسجيل الدخول. لا يغيّر أي شيء في config أو API.
 */
export default function Dashboard({ onLogout }) {
  const [page, setPage] = useState("orders");
  const [selectedOrder, setSelectedOrder] = useState(null);
  const refreshOrdersRef = useRef(null);

  return (
    <div className="flex flex-row-reverse min-h-screen bg-gray-50">
      <Sidebar
        currentPage={page}
        onNavigate={(p) => {
          setPage(p);
          setSelectedOrder(null);
        }}
        onLogout={onLogout}
      />

      <div className="flex-1 p-6">
        {selectedOrder ? (
          <OrderDetails
            order={selectedOrder}
            onBack={() => setSelectedOrder(null)}
            onUpdateStatus={() => {
              setSelectedOrder(null);
              if (refreshOrdersRef.current) {
                refreshOrdersRef.current();
              }
            }}
          />
        ) : (
          <>
            {page === "orders" && (
              <Orders
                onOpenRequest={setSelectedOrder}
                onRefreshReady={(refreshFn) => {
                  refreshOrdersRef.current = refreshFn;
                }}
              />
            )}
            {page === "technicians" && <Technicians />}
            {page === "settings" && (
              <div className="bg-white rounded-xl shadow-md p-8">
                <h1 className="text-3xl font-bold text-gray-800 mb-6">الإعدادات</h1>
                <p className="text-gray-600">قريباً...</p>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}

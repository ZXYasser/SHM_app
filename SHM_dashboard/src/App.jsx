import { useState, useRef } from "react";
import Login from "./Login";
import Sidebar from "./Sidebar";
import Orders from "./Orders";
import Technicians from "./Technicians";
import OrderDetails from "./OrderDetails";

export default function App() {
  const [loggedIn, setLoggedIn] = useState(false);
  const [page, setPage] = useState("orders");
  const [selectedOrder, setSelectedOrder] = useState(null);
  const refreshOrdersRef = useRef(null);

  // Show login if not logged in
  if (!loggedIn) {
    return <Login onLogin={() => setLoggedIn(true)} />;
  }

  return (
    <div className="flex flex-row-reverse min-h-screen bg-gray-50">
      {/* Sidebar */}
      <Sidebar 
        currentPage={page}
        onNavigate={(p) => {
          setPage(p);
          setSelectedOrder(null); // Reset selected order when navigating
        }}
        onLogout={() => setLoggedIn(false)}
      />

      {/* Main Content */}
      <div className="flex-1 p-6">
        {selectedOrder ? (
          <OrderDetails 
            order={selectedOrder} 
            onBack={() => setSelectedOrder(null)}
            onUpdateStatus={() => {
              setSelectedOrder(null);
              // Refresh orders list
              if (refreshOrdersRef.current) {
                refreshOrdersRef.current();
              }
            }}
          />
        ) : (
          <>
            {/* صفحة الطلبات */}
            {page === "orders" && (
              <Orders 
                onOpenRequest={setSelectedOrder}
                onRefreshReady={(refreshFn) => {
                  refreshOrdersRef.current = refreshFn;
                }}
              />
            )}

            {/* صفحة الفنيين */}
            {page === "technicians" && <Technicians />}

            {/* صفحة الإعدادات */}
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

import { useEffect, useState, useMemo } from "react";
import { FiEye, FiRefreshCw, FiFilter, FiTrash2 } from "react-icons/fi";

export default function Orders({ onOpenRequest }) {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [statusFilter, setStatusFilter] = useState("all");
  const [technicians, setTechnicians] = useState([]);

  // Fetch from backend
  const loadOrders = async () => {
    try {
      setLoading(true);
      setError(null);
      const res = await fetch("http://localhost:3000/requests");
      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }
      const data = await res.json();
      if (Array.isArray(data)) {
        setOrders(data);
      } else {
        throw new Error("Expected array but got: " + typeof data);
      }
    } catch (err) {
      console.error("Error loading requests:", err);
      setError("فشل في تحميل الطلبات. تأكد من أن الخادم يعمل.");
      setOrders([]);
    } finally {
      setLoading(false);
    }
  };

  // Load technicians
  const loadTechnicians = async () => {
    try {
      const res = await fetch("http://localhost:3000/technicians");
      if (res.ok) {
        const data = await res.json();
        setTechnicians(Array.isArray(data) ? data : []);
      }
    } catch (err) {
      console.error("Error loading technicians:", err);
    }
  };

  // Get technician name by ID
  const getTechnicianName = (techId) => {
    if (!techId) return '-';
    const tech = technicians.find(t => (t.id || t._id) === techId);
    return tech ? tech.name : '-';
  };

  // Delete order
  const deleteOrder = async (orderId) => {
    if (!window.confirm("هل أنت متأكد من حذف هذا الطلب؟")) return;

    try {
      console.log("🗑️ Deleting order with ID:", orderId);
      const res = await fetch(`http://localhost:3000/requests/${orderId}`, {
        method: "DELETE",
        headers: {
          "Content-Type": "application/json",
        },
      });

      console.log("📥 Delete response status:", res.status);
      console.log("📥 Delete response headers:", res.headers.get("content-type"));

      // التحقق من نوع الـ response
      const contentType = res.headers.get("content-type");
      if (!contentType || !contentType.includes("application/json")) {
        const text = await res.text();
        console.error("❌ Non-JSON response:", text.substring(0, 200));
        throw new Error("الخادم لم يعد استجابة صحيحة. تأكد من أن الخادم يعمل.");
      }

      const data = await res.json();
      console.log("📥 Delete response data:", data);

      if (!res.ok) {
        throw new Error(data.error || "Failed to delete order");
      }

      if (data.success !== false) {
        await loadOrders();
        alert(data.message || "تم حذف الطلب بنجاح");
      } else {
        throw new Error(data.error || "فشل في حذف الطلب");
      }
    } catch (err) {
      console.error("❌ Error deleting order:", err);
      alert(`فشل في حذف الطلب: ${err.message}`);
    }
  };

  useEffect(() => {
    loadOrders();
    loadTechnicians();
    // Auto-refresh every 10 seconds
    const interval = setInterval(loadOrders, 10000);
    return () => clearInterval(interval);
  }, []);

  // Filter orders by status
  const filteredOrders = useMemo(() => {
    if (statusFilter === "all") return orders;
    return orders.filter(order => order.status === statusFilter);
  }, [orders, statusFilter]);

  // Calculate statistics
  const stats = useMemo(() => {
    return {
      total: orders.length,
      new: orders.filter(o => o.status === "new").length,
      inProgress: orders.filter(o => o.status === "in_progress").length,
      completed: orders.filter(o => o.status === "completed").length,
    };
  }, [orders]);

  // Helper to format date
  const formatDate = (order) => {
    let createdAtDate = null;
    if (order.createdAt) {
      if (order.createdAt.toDate) {
        createdAtDate = order.createdAt.toDate();
      } else if (order.createdAt.seconds) {
        createdAtDate = new Date(order.createdAt.seconds * 1000);
      } else if (typeof order.createdAt === 'string') {
        createdAtDate = new Date(order.createdAt);
      } else {
        createdAtDate = new Date(order.createdAt);
      }
    }
    return createdAtDate ? createdAtDate.toLocaleString("ar-SA") : 'غير محدد';
  };

  return (
    <div className="p-4" dir="rtl">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-3xl font-bold text-gray-800">الطلبات</h1>
        <button
          onClick={loadOrders}
          disabled={loading}
          className="flex items-center gap-2 bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition disabled:opacity-50"
        >
          <FiRefreshCw className={loading ? "animate-spin" : ""} size={18} />
          تحديث
        </button>
      </div>

      {/* Statistics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div className="bg-gradient-to-br from-blue-500 to-blue-600 text-white p-6 rounded-xl shadow-lg">
          <div className="text-sm opacity-90 mb-1">إجمالي الطلبات</div>
          <div className="text-3xl font-bold">{stats.total}</div>
        </div>
        <div className="bg-gradient-to-br from-yellow-500 to-yellow-600 text-white p-6 rounded-xl shadow-lg">
          <div className="text-sm opacity-90 mb-1">طلبات جديدة</div>
          <div className="text-3xl font-bold">{stats.new}</div>
        </div>
        <div className="bg-gradient-to-br from-indigo-500 to-indigo-600 text-white p-6 rounded-xl shadow-lg">
          <div className="text-sm opacity-90 mb-1">قيد التنفيذ</div>
          <div className="text-3xl font-bold">{stats.inProgress}</div>
        </div>
        <div className="bg-gradient-to-br from-green-500 to-green-600 text-white p-6 rounded-xl shadow-lg">
          <div className="text-sm opacity-90 mb-1">مكتملة</div>
          <div className="text-3xl font-bold">{stats.completed}</div>
        </div>
      </div>

      {/* Filter */}
      <div className="bg-white rounded-xl shadow-md p-4 mb-6 border border-gray-200">
        <div className="flex items-center gap-4">
          <FiFilter size={20} className="text-gray-600" />
          <span className="text-gray-700 font-medium">فلترة حسب الحالة:</span>
          <div className="flex gap-2">
            {[
              { key: "all", label: "الكل" },
              { key: "new", label: "جديدة" },
              { key: "in_progress", label: "قيد التنفيذ" },
              { key: "completed", label: "مكتملة" },
            ].map((filter) => (
              <button
                key={filter.key}
                onClick={() => setStatusFilter(filter.key)}
                className={`px-4 py-2 rounded-lg transition ${
                  statusFilter === filter.key
                    ? "bg-green-600 text-white"
                    : "bg-gray-100 text-gray-700 hover:bg-gray-200"
                }`}
              >
                {filter.label}
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* Error Message */}
      {error && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-4">
          {error}
        </div>
      )}

      {/* Orders Table */}
      <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-200">
        {loading ? (
          <div className="p-12 text-center">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-green-600"></div>
            <p className="mt-4 text-gray-600">جاري التحميل...</p>
          </div>
        ) : filteredOrders.length === 0 ? (
          <div className="p-12 text-center">
            <p className="text-gray-400 text-lg">
              {statusFilter === "all" 
                ? "لا يوجد طلبات حتى الآن" 
                : "لا توجد طلبات بهذه الحالة"}
            </p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-right">
              <thead className="bg-gradient-to-r from-gray-50 to-gray-100 text-gray-700">
                <tr>
                  <th className="p-4 font-semibold">الخدمة</th>
                  <th className="p-4 font-semibold">السيارة</th>
                  <th className="p-4 font-semibold">رقم اللوحة</th>
                  <th className="p-4 font-semibold">الفني</th>
                  <th className="p-4 font-semibold">الحالة</th>
                  <th className="p-4 font-semibold">التاريخ</th>
                  <th className="p-4 font-semibold text-center">إجراءات</th>
                </tr>
              </thead>
              <tbody>
                {filteredOrders.map((order, index) => (
                  <tr
                    key={order.id || order._id || index}
                    className="border-b hover:bg-green-50 transition-all duration-200"
                  >
                    <td className="p-4 font-medium">{order.serviceType || 'غير محدد'}</td>
                    <td className="p-4">{order.carModel || 'غير محدد'}</td>
                    <td className="p-4 text-gray-600">{order.plateNumber || '-'}</td>
                    <td className="p-4">
                      <span className={`px-2 py-1 rounded text-sm ${
                        order.technicianId 
                          ? 'bg-blue-100 text-blue-700' 
                          : 'bg-gray-100 text-gray-600'
                      }`}>
                        {order.technicianId ? getTechnicianName(order.technicianId) : 'غير معين'}
                      </span>
                    </td>
                    <td className="p-4">
                      <span
                        className={`px-3 py-1.5 rounded-lg text-white text-sm font-medium ${
                          order.status === "new"
                            ? "bg-yellow-500"
                            : order.status === "in_progress"
                            ? "bg-blue-600"
                            : order.status === "completed"
                            ? "bg-green-600"
                            : "bg-red-600"
                        }`}
                      >
                        {order.status === "new"
                          ? "جديد"
                          : order.status === "in_progress"
                          ? "قيد التنفيذ"
                          : order.status === "completed"
                          ? "مكتمل"
                          : "ملغي"}
                      </span>
                    </td>
                    <td className="p-4 text-gray-600">{formatDate(order)}</td>
                    <td className="p-4 text-center">
                      <div className="flex items-center justify-center gap-2">
                        <button
                          onClick={() => onOpenRequest && onOpenRequest(order)}
                          className="bg-green-600 p-2.5 rounded-lg text-white hover:bg-green-700 transition shadow-sm hover:shadow-md"
                          title="عرض التفاصيل"
                        >
                          <FiEye size={18} />
                        </button>
                        <button
                          onClick={() => deleteOrder(order.id || order._id)}
                          className="bg-red-600 p-2.5 rounded-lg text-white hover:bg-red-700 transition shadow-sm hover:shadow-md"
                          title="حذف الطلب"
                        >
                          <FiTrash2 size={18} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}

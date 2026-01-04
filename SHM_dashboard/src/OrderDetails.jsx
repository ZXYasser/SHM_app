import { useState, useEffect } from "react";
import { FiArrowRight, FiMapPin, FiTruck, FiFileText, FiCalendar, FiTag, FiX, FiTrash2, FiUser } from "react-icons/fi";
import { API_URL } from "./config";

export default function OrderDetails({ order, onBack, onUpdateStatus }) {
  const [updatingStatus, setUpdatingStatus] = useState(false);
  const [deleting, setDeleting] = useState(false);
  const [technicians, setTechnicians] = useState([]);
  const [loadingTechnicians, setLoadingTechnicians] = useState(false);
  const [assigningTechnician, setAssigningTechnician] = useState(false);
  const [selectedTechnicianId, setSelectedTechnicianId] = useState(order.technicianId || '');

  // Load technicians
  useEffect(() => {
    loadTechnicians();
  }, []);

  const loadTechnicians = async () => {
    setLoadingTechnicians(true);
    try {
      const res = await fetch(`${API_URL}/technicians`);
      if (res.ok) {
        const data = await res.json();
        setTechnicians(Array.isArray(data) ? data : []);
      }
    } catch (err) {
      console.error("Error loading technicians:", err);
    } finally {
      setLoadingTechnicians(false);
    }
  };

  // Assign technician to order
  const assignTechnician = async () => {
    if (!selectedTechnicianId) {
      alert("يرجى اختيار فني");
      return;
    }

    if (!window.confirm("هل تريد تعيين هذا الفني للطلب؟")) {
      return;
    }

    setAssigningTechnician(true);
    try {
      const orderId = order.id || order._id;
      
      // Validate technicianId
      if (!selectedTechnicianId || selectedTechnicianId.trim() === '') {
        alert("يرجى اختيار فني صحيح");
        setAssigningTechnician(false);
        return;
      }
      
      const requestBody = { 
        technicianId: selectedTechnicianId.trim(),
        status: order.status === 'new' ? 'in_progress' : order.status
      };
      
      console.log("🔧 Assigning technician:", {
        orderId,
        technicianId: selectedTechnicianId,
        technicianIdType: typeof selectedTechnicianId,
        technicianIdLength: selectedTechnicianId?.length,
        requestBody: JSON.stringify(requestBody)
      });
      
      const res = await fetch(`${API_URL}/requests/${orderId}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(requestBody),
      });

      const responseData = await res.json();
      console.log("📥 Response from server:", responseData);

      if (res.ok) {
        console.log("✅ Technician assigned successfully");
        alert("تم تعيين الفني للطلب بنجاح");
        if (onUpdateStatus) onUpdateStatus();
        onBack();
      } else {
        console.error("❌ Failed to assign technician:", responseData);
        alert("فشل تعيين الفني: " + (responseData.error || "خطأ غير معروف"));
      }
    } catch (err) {
      console.error("Error assigning technician:", err);
      alert("حدث خطأ أثناء تعيين الفني");
    } finally {
      setAssigningTechnician(false);
    }
  };

  // Get technician name by ID
  const getTechnicianName = (techId) => {
    if (!techId) return 'غير معين';
    const tech = technicians.find(t => (t.id || t._id) === techId);
    return tech ? tech.name : 'غير معين';
  };

  // Format date
  const formatDate = () => {
    if (!order.createdAt) return 'غير محدد';
    let createdAtDate = null;
    if (order.createdAt.toDate) {
      createdAtDate = order.createdAt.toDate();
    } else if (order.createdAt.seconds) {
      createdAtDate = new Date(order.createdAt.seconds * 1000);
    } else if (typeof order.createdAt === 'string') {
      createdAtDate = new Date(order.createdAt);
    } else {
      createdAtDate = new Date(order.createdAt);
    }
    return createdAtDate ? createdAtDate.toLocaleString("ar-SA") : 'غير محدد';
  };

  // Get status badge
  const getStatusBadge = (status) => {
    const statusConfig = {
      new: { label: "جديد", color: "bg-yellow-500" },
      in_progress: { label: "قيد التنفيذ", color: "bg-blue-600" },
      completed: { label: "مكتمل", color: "bg-green-600" },
      cancelled: { label: "ملغي", color: "bg-red-600" },
    };
    const config = statusConfig[status] || statusConfig.new;
    return (
      <span className={`px-4 py-2 rounded-lg text-white font-medium ${config.color}`}>
        {config.label}
      </span>
    );
  };

  // Update status
  const updateStatus = async (newStatus) => {
    if (!window.confirm(`هل تريد تغيير حالة الطلب إلى "${newStatus === 'in_progress' ? 'قيد التنفيذ' : newStatus === 'completed' ? 'مكتمل' : 'ملغي'}"؟`)) {
      return;
    }

    setUpdatingStatus(true);
    try {
      const res = await fetch(`${API_URL}/requests/${order.id || order._id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ status: newStatus }),
      });
      if (res.ok) {
        if (onUpdateStatus) onUpdateStatus();
        onBack();
      } else {
        alert("فشل تحديث الحالة");
      }
    } catch (err) {
      console.error("Error updating status:", err);
      alert("حدث خطأ أثناء تحديث الحالة");
    } finally {
      setUpdatingStatus(false);
    }
  };

  // Delete order
  const deleteOrder = async () => {
    if (!window.confirm("هل أنت متأكد من حذف هذا الطلب؟ لا يمكن التراجع عن هذا الإجراء.")) {
      return;
    }

    setDeleting(true);
    try {
      const orderId = order.id || order._id;
      console.log("🗑️ Deleting order with ID:", orderId);
      
      const res = await fetch(`${API_URL}/requests/${orderId}`, {
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

      if (res.ok && data.success !== false) {
        alert(data.message || "تم حذف الطلب بنجاح");
        if (onUpdateStatus) onUpdateStatus();
        onBack();
      } else {
        throw new Error(data.error || "فشل حذف الطلب");
      }
    } catch (err) {
      console.error("❌ Error deleting order:", err);
      alert(`حدث خطأ أثناء حذف الطلب: ${err.message}`);
    } finally {
      setDeleting(false);
    }
  };

  // Google Maps URL
  const mapsUrl = `https://www.google.com/maps?q=${order.latitude},${order.longitude}`;

  return (
    <div className="p-6" dir="rtl">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-4">
          <button
            onClick={onBack}
            className="flex items-center gap-2 bg-gray-600 text-white px-4 py-2 rounded-lg hover:bg-gray-700 transition"
          >
            <FiArrowRight size={18} />
            رجوع
          </button>
          <h2 className="text-3xl font-bold text-gray-800">تفاصيل الطلب</h2>
        </div>
        <div className="flex items-center gap-3">
          {getStatusBadge(order.status)}
          <button
            onClick={deleteOrder}
            disabled={deleting}
            className="flex items-center gap-2 bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition disabled:opacity-50"
            title="حذف الطلب"
          >
            <FiTrash2 size={18} />
            {deleting ? 'جاري الحذف...' : 'حذف'}
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Left Column - Order Info */}
        <div className="space-y-6">
          {/* Order Details Card */}
          <div className="bg-white rounded-xl shadow-lg p-6 border border-gray-200">
            <h3 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
              <FiFileText className="text-blue-600" />
              معلومات الطلب
            </h3>
            <div className="space-y-4">
              <div className="flex items-start gap-3">
                <FiTag className="text-gray-400 mt-1" size={20} />
                <div>
                  <div className="text-sm text-gray-500">نوع الخدمة</div>
                  <div className="text-lg font-semibold text-gray-800">{order.serviceType || 'غير محدد'}</div>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <FiTruck className="text-gray-400 mt-1" size={20} />
                <div>
                  <div className="text-sm text-gray-500">نوع وموديل السيارة</div>
                  <div className="text-lg font-semibold text-gray-800">{order.carModel || 'غير محدد'}</div>
                </div>
              </div>
              {order.plateNumber && (
                <div className="flex items-start gap-3">
                  <FiTag className="text-gray-400 mt-1" size={20} />
                  <div>
                    <div className="text-sm text-gray-500">رقم اللوحة</div>
                    <div className="text-lg font-semibold text-gray-800">{order.plateNumber}</div>
                  </div>
                </div>
              )}
              <div className="flex items-start gap-3">
                <FiFileText className="text-gray-400 mt-1" size={20} />
                <div>
                  <div className="text-sm text-gray-500">وصف المشكلة</div>
                  <div className="text-base text-gray-700 mt-1">{order.notes || 'لا يوجد وصف'}</div>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <FiCalendar className="text-gray-400 mt-1" size={20} />
                <div>
                  <div className="text-sm text-gray-500">تاريخ الطلب</div>
                  <div className="text-base text-gray-700">{formatDate()}</div>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <FiUser className="text-gray-400 mt-1" size={20} />
                <div>
                  <div className="text-sm text-gray-500">الفني المعين</div>
                  <div className="text-lg font-semibold text-gray-800">
                    {getTechnicianName(order.technicianId)}
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Assign Technician Card */}
          <div className="bg-white rounded-xl shadow-lg p-6 border border-gray-200">
            <h3 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
              <FiUser className="text-blue-600" />
              تعيين فني للطلب
            </h3>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  اختر الفني
                </label>
                {loadingTechnicians ? (
                  <div className="text-center py-4">
                    <div className="inline-block animate-spin rounded-full h-6 w-6 border-b-2 border-blue-600"></div>
                    <p className="mt-2 text-sm text-gray-500">جاري التحميل...</p>
                  </div>
                ) : technicians.length === 0 ? (
                  <p className="text-sm text-gray-500 py-4">لا يوجد فنيون متاحون</p>
                ) : (
                  <select
                    value={selectedTechnicianId}
                    onChange={(e) => setSelectedTechnicianId(e.target.value)}
                    className="w-full border border-gray-300 p-3 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  >
                    <option value="">-- اختر فني --</option>
                    {technicians.map((tech) => (
                      <option key={tech.id || tech._id} value={tech.id || tech._id}>
                        {tech.name} - {tech.phone}
                      </option>
                    ))}
                  </select>
                )}
              </div>
              <button
                onClick={assignTechnician}
                disabled={assigningTechnician || !selectedTechnicianId || loadingTechnicians}
                className="w-full bg-blue-600 text-white px-4 py-3 rounded-lg hover:bg-blue-700 transition disabled:opacity-50 disabled:cursor-not-allowed font-medium"
              >
                {assigningTechnician ? 'جاري التعيين...' : 'تعيين الفني للطلب'}
              </button>
              {order.technicianId && (
                <button
                  onClick={async () => {
                    if (!window.confirm("هل تريد إلغاء تعيين الفني من هذا الطلب؟")) return;
                    setAssigningTechnician(true);
                    try {
                      const res = await fetch(`${API_URL}/requests/${order.id || order._id}`, {
                        method: "PATCH",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify({ technicianId: null }),
                      });
                      if (res.ok) {
                        alert("تم إلغاء تعيين الفني");
                        if (onUpdateStatus) onUpdateStatus();
                        onBack();
                      }
                    } catch (err) {
                      alert("فشل إلغاء التعيين");
                    } finally {
                      setAssigningTechnician(false);
                    }
                  }}
                  disabled={assigningTechnician}
                  className="w-full bg-red-600 text-white px-4 py-3 rounded-lg hover:bg-red-700 transition disabled:opacity-50 font-medium"
                >
                  إلغاء تعيين الفني
                </button>
              )}
            </div>
          </div>

          {/* Location Card */}
          <div className="bg-white rounded-xl shadow-lg p-6 border border-gray-200">
            <h3 className="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
              <FiMapPin className="text-blue-600" />
              الموقع
            </h3>
            <div className="space-y-3">
              <div className="text-sm text-gray-600">
                <span className="font-medium">خط العرض:</span> {order.latitude}
              </div>
              <div className="text-sm text-gray-600">
                <span className="font-medium">خط الطول:</span> {order.longitude}
              </div>
              <a
                href={mapsUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition mt-2"
              >
                <FiMapPin size={18} />
                فتح في خرائط Google
              </a>
            </div>
          </div>

          {/* Status Actions */}
          {order.status !== 'completed' && order.status !== 'cancelled' && (
            <div className="bg-white rounded-xl shadow-lg p-6 border border-gray-200">
              <h3 className="text-xl font-bold text-gray-800 mb-4">تغيير الحالة</h3>
              <div className="flex flex-wrap gap-3">
                {order.status === 'new' && (
                  <button
                    onClick={() => updateStatus('in_progress')}
                    disabled={updatingStatus}
                    className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition disabled:opacity-50"
                  >
                    {updatingStatus ? 'جاري التحديث...' : 'بدء التنفيذ'}
                  </button>
                )}
                {order.status === 'in_progress' && (
                  <>
                    <button
                      onClick={() => updateStatus('completed')}
                      disabled={updatingStatus}
                      className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition disabled:opacity-50"
                    >
                      {updatingStatus ? 'جاري التحديث...' : 'إكمال الطلب'}
                    </button>
                    <button
                      onClick={() => updateStatus('cancelled')}
                      disabled={updatingStatus}
                      className="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition disabled:opacity-50"
                    >
                      {updatingStatus ? 'جاري التحديث...' : 'إلغاء الطلب'}
                    </button>
                  </>
                )}
              </div>
            </div>
          )}
        </div>

        {/* Right Column - Map */}
        <div className="bg-white rounded-xl shadow-lg overflow-hidden border border-gray-200">
          <div className="p-4 bg-gray-50 border-b border-gray-200">
            <h3 className="text-lg font-semibold text-gray-800">موقع العميل</h3>
          </div>
          <iframe
            className="w-full h-[600px]"
            src={`https://maps.google.com/maps?q=${order.latitude},${order.longitude}&z=15&output=embed&hl=ar`}
            frameBorder="0"
            allowFullScreen
          ></iframe>
        </div>
      </div>
    </div>
  );
}
  
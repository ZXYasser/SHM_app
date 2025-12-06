import { useEffect, useState } from "react";
import { FiUserPlus, FiTrash2, FiUsers, FiPhone, FiLock, FiRefreshCw } from "react-icons/fi";

export default function Technicians() {
  const [techs, setTechs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [adding, setAdding] = useState(false);
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [password, setPassword] = useState("");

  // =============== Load Technicians ===============
  const loadTechnicians = async () => {
    try {
      setLoading(true);
      setError(null);
      const res = await fetch("http://localhost:3000/technicians");
      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }
      const data = await res.json();
      if (Array.isArray(data)) {
        setTechs(data);
      } else {
        throw new Error("Expected array but got: " + typeof data);
      }
    } catch (err) {
      console.error("Error loading technicians:", err);
      setError("فشل في تحميل الفنيين. تأكد من أن الخادم يعمل.");
      setTechs([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadTechnicians();
  }, []);

  // =============== Add Technician ===============
  const addTechnician = async () => {
    if (!name.trim() || !phone.trim() || !password.trim()) {
      alert("يرجى تعبئة جميع الحقول");
      return;
    }

    setAdding(true);
    try {
      const res = await fetch("http://localhost:3000/technicians", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name: name.trim(), phone: phone.trim(), password: password.trim() }),
      });

      if (!res.ok) {
        throw new Error("Failed to add technician");
      }

      setName("");
      setPhone("");
      setPassword("");
      await loadTechnicians();
      alert("تم إضافة الفني بنجاح");
    } catch (err) {
      console.error("Error adding technician:", err);
      alert("فشل في إضافة الفني");
    } finally {
      setAdding(false);
    }
  };

  // =============== Delete Technician ===============
  const deleteTechnician = async (id) => {
    if (!window.confirm("هل أنت متأكد من حذف هذا الفني؟")) return;

    try {
      console.log("🗑️ Deleting technician with ID:", id);
      const res = await fetch(`http://localhost:3000/technicians/${id}`, {
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
        throw new Error(data.error || "Failed to delete technician");
      }

      if (data.success !== false) {
        await loadTechnicians();
        alert(data.message || "تم حذف الفني بنجاح");
      } else {
        throw new Error(data.error || "فشل في حذف الفني");
      }
    } catch (err) {
      console.error("❌ Error deleting technician:", err);
      alert(`فشل في حذف الفني: ${err.message}`);
    }
  };

  // Format date
  const formatDate = (tech) => {
    if (!tech.createdAt) return 'غير محدد';
    let createdAtDate = null;
    if (tech.createdAt.toDate) {
      createdAtDate = tech.createdAt.toDate();
    } else if (tech.createdAt.seconds) {
      createdAtDate = new Date(tech.createdAt.seconds * 1000);
    } else if (typeof tech.createdAt === 'string') {
      createdAtDate = new Date(tech.createdAt);
    } else {
      createdAtDate = new Date(tech.createdAt);
    }
    return createdAtDate ? createdAtDate.toLocaleString("ar-SA") : 'غير محدد';
  };

  return (
    <div className="p-6" dir="rtl">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-3xl font-bold text-gray-800 flex items-center gap-3">
          <FiUsers className="text-green-600" size={32} />
          إدارة الفنيين
        </h2>
        <button
          onClick={loadTechnicians}
          disabled={loading}
          className="flex items-center gap-2 bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 transition disabled:opacity-50"
        >
          <FiRefreshCw className={loading ? "animate-spin" : ""} size={18} />
          تحديث
        </button>
      </div>

      {/* Error Message */}
      {error && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-6">
          {error}
        </div>
      )}

      {/* Add Technician Card */}
      <div className="bg-gradient-to-br from-green-50 to-white rounded-xl shadow-lg p-6 mb-8 border border-green-100">
        <h3 className="text-xl font-semibold mb-4 text-gray-800 flex items-center gap-2">
          <FiUserPlus className="text-green-600" size={24} />
          إضافة فني جديد
        </h3>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
          <div className="relative">
            <FiUsers className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
            <input
              type="text"
              placeholder="اسم الفني"
              className="w-full border border-gray-300 p-3 pr-10 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
              value={name}
              onChange={(e) => setName(e.target.value)}
            />
          </div>

          <div className="relative">
            <FiPhone className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
            <input
              type="text"
              placeholder="رقم الجوال"
              className="w-full border border-gray-300 p-3 pr-10 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
            />
          </div>

          <div className="relative">
            <FiLock className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
            <input
              type="password"
              placeholder="كلمة المرور"
              className="w-full border border-gray-300 p-3 pr-10 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </div>
        </div>

        <button
          onClick={addTechnician}
          disabled={adding || !name.trim() || !phone.trim() || !password.trim()}
          className="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg transition disabled:opacity-50 disabled:cursor-not-allowed shadow-md hover:shadow-lg"
        >
          {adding ? "جاري الإضافة..." : "إضافة الفني"}
        </button>
      </div>

      {/* List Technicians */}
      <div className="bg-white rounded-xl shadow-lg overflow-hidden border border-gray-200">
        <div className="bg-gradient-to-r from-gray-50 to-gray-100 p-4 border-b border-gray-200">
          <h3 className="text-xl font-semibold text-gray-800">
            قائمة الفنيين ({techs.length})
          </h3>
        </div>

        {loading ? (
          <div className="p-12 text-center">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-green-600"></div>
            <p className="mt-4 text-gray-600">جاري التحميل...</p>
          </div>
        ) : techs.length === 0 ? (
          <div className="p-12 text-center">
            <p className="text-gray-400 text-lg">لا يوجد فنيون حتى الآن</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-right">
              <thead className="bg-gray-50 text-gray-700">
                <tr>
                  <th className="p-4 font-semibold">الاسم</th>
                  <th className="p-4 font-semibold">رقم الجوال</th>
                  <th className="p-4 font-semibold">الحالة</th>
                  <th className="p-4 font-semibold">تاريخ الإضافة</th>
                  <th className="p-4 font-semibold text-center">إجراءات</th>
                </tr>
              </thead>
              <tbody>
                {techs.map((t, index) => (
                  <tr
                    key={t.id || t._id || index}
                    className="border-b hover:bg-green-50 transition-all duration-200"
                  >
                    <td className="p-4 font-medium">{t.name || 'غير محدد'}</td>
                    <td className="p-4">{t.phone || 'غير محدد'}</td>
                    <td className="p-4">
                      <span
                        className={`px-3 py-1.5 rounded-lg text-white text-sm font-medium ${
                          t.status === "active" || t.status === "available"
                            ? "bg-green-600"
                            : "bg-gray-500"
                        }`}
                      >
                        {t.status === "active" || t.status === "available" ? "نشط" : "غير نشط"}
                      </span>
                    </td>
                    <td className="p-4 text-gray-600">{formatDate(t)}</td>
                    <td className="p-4 text-center">
                      <button
                        className="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition shadow-sm hover:shadow-md flex items-center gap-2 mx-auto"
                        onClick={() => deleteTechnician(t.id || t._id)}
                      >
                        <FiTrash2 size={16} />
                        حذف
                      </button>
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

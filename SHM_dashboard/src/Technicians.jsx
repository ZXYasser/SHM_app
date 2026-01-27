import { useEffect, useState } from "react";
import { FiUserPlus, FiTrash2, FiUsers, FiPhone, FiLock, FiRefreshCw, FiStar, FiX } from "react-icons/fi";
import { API_URL } from "./config";

export default function Technicians() {
  const [techs, setTechs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [adding, setAdding] = useState(false);
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [password, setPassword] = useState("");
  const [ratings, setRatings] = useState({});
  const [selectedTechForRatings, setSelectedTechForRatings] = useState(null); // الفني الحالي لعرض تقييماته

  // =============== Load Technicians ===============
  const loadTechnicians = async () => {
    try {
      setLoading(true);
      setError(null);
      const res = await fetch(`${API_URL}/technicians`);
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

  // =============== Load Ratings ===============
  const loadRatings = async () => {
    try {
      const res = await fetch(`${API_URL}/technicians/ratings`);
      if (res.ok) {
        const data = await res.json();
        setRatings(data);
      }
    } catch (err) {
      console.error("Error loading ratings:", err);
    }
  };

  useEffect(() => {
    loadTechnicians();
    loadRatings();
  }, []);

  // =============== Add Technician ===============
  const addTechnician = async () => {
    if (!name.trim() || !phone.trim() || !password.trim()) {
      alert("يرجى تعبئة جميع الحقول");
      return;
    }

    setAdding(true);
    try {
      const res = await fetch(`${API_URL}/technicians`, {
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
      const res = await fetch(`${API_URL}/technicians/${id}`, {
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
          <FiUsers className="text-blue-600" size={32} />
          إدارة الفنيين
        </h2>
        <div className="flex items-center gap-3">
          <button
            onClick={() => {
              loadTechnicians();
              loadRatings();
            }}
            disabled={loading}
            className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition disabled:opacity-50"
          >
            <FiRefreshCw className={loading ? "animate-spin" : ""} size={18} />
            تحديث
          </button>
        </div>
      </div>

      {/* Error Message */}
      {error && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-6">
          {error}
        </div>
      )}

      {/* Add Technician Card */}
      <div className="bg-gradient-to-br from-blue-50 to-white rounded-xl shadow-lg p-6 mb-8 border border-blue-100">
        <h3 className="text-xl font-semibold mb-4 text-gray-800 flex items-center gap-2">
          <FiUserPlus className="text-blue-600" size={24} />
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
          className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg transition disabled:opacity-50 disabled:cursor-not-allowed shadow-md hover:shadow-lg"
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
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
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
                  <th className="p-4 font-semibold">متوسط التقييم</th>
                  <th className="p-4 font-semibold">تاريخ الإضافة</th>
                  <th className="p-4 font-semibold text-center">إجراءات</th>
                </tr>
              </thead>
              <tbody>
                {techs.map((t, index) => {
                  const techId = t.id || t._id;
                  const techRating = ratings[techId];
                  const averageRating = techRating ? parseFloat(techRating.averageRating) : null;
                  const totalRatings = techRating ? techRating.totalRatings : 0;
                  
                  return (
                    <tr
                      key={techId || index}
                      className="border-b hover:bg-blue-50 transition-all duration-200"
                    >
                      <td className="p-4 font-medium">{t.name || 'غير محدد'}</td>
                      <td className="p-4">{t.phone || 'غير محدد'}</td>
                      <td className="p-4">
                        <span
                          className={`px-3 py-1.5 rounded-lg text-white text-sm font-medium ${
                            t.status === "active" || t.status === "available"
                              ? "bg-blue-600"
                              : "bg-gray-500"
                          }`}
                        >
                          {t.status === "active" || t.status === "available" ? "نشط" : "غير نشط"}
                        </span>
                      </td>
                      <td className="p-4">
                        {averageRating !== null && averageRating > 0 ? (
                          <div className="flex items-center gap-2">
                            <FiStar className="text-amber-500" size={18} />
                            <span className="font-semibold text-gray-800">
                              {averageRating.toFixed(1)}
                            </span>
                            <span className="text-sm text-gray-500">
                              ({totalRatings} {totalRatings === 1 ? 'تقييم' : 'تقييمات'})
                            </span>
                          </div>
                        ) : (
                          <span className="text-gray-400 text-sm">لا يوجد تقييمات</span>
                        )}
                      </td>
                      <td className="p-4 text-gray-600">{formatDate(t)}</td>
                      <td className="p-4 text-center">
                      <div className="flex items-center justify-center gap-2">
                        {/* زر عرض صفحة التقييمات الخاصة بالفني */}
                        <button
                          className="bg-blue-50 hover:bg-blue-100 text-blue-700 px-3 py-1.5 rounded-lg transition shadow-sm hover:shadow-md flex items-center gap-1 text-sm"
                          onClick={() => setSelectedTechForRatings({ tech: t, ratingData: techRating, techId })}
                        >
                          <FiStar size={14} className="text-amber-500" />
                          <span>عرض التقييمات</span>
                        </button>
                        {/* زر حذف الفني (كما هو سابقاً) */}
                        <button
                          className="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition shadow-sm hover:shadow-md flex items-center gap-2"
                          onClick={() => deleteTechnician(techId)}
                        >
                          <FiTrash2 size={16} />
                          حذف
                        </button>
                      </div>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* صفحة / نافذة التقييمات الخاصة بفني معيّن */}
      {selectedTechForRatings && (
        <div className="fixed inset-0 bg-black/40 z-40 flex items-center justify-center">
          <div className="bg-white rounded-2xl shadow-2xl max-w-4xl w-full mx-4 max-h-[80vh] overflow-hidden flex flex-col" dir="rtl">
            {/* Header */}
            <div className="px-6 py-4 border-b border-gray-200 flex items-center justify-between bg-gray-50">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center">
                  <FiUsers className="text-blue-600" size={20} />
                </div>
                <div>
                  <h3 className="text-xl font-bold text-gray-800">
                    تقييمات الفني: {selectedTechForRatings.tech?.name || "غير معروف"}
                  </h3>
                  <p className="text-sm text-gray-500">
                    رقم الجوال: {selectedTechForRatings.tech?.phone || "غير محدد"}
                  </p>
                </div>
              </div>
              <button
                onClick={() => setSelectedTechForRatings(null)}
                className="text-gray-500 hover:text-gray-700 transition-colors"
                title="إغلاق"
              >
                <FiX size={22} />
              </button>
            </div>

            {/* Content */}
            <div className="p-6 overflow-y-auto">
              {(!selectedTechForRatings.ratingData ||
                !selectedTechForRatings.ratingData.reviews ||
                selectedTechForRatings.ratingData.reviews.length === 0) && (
                <div className="text-center py-12 text-gray-400">
                  لا توجد تقييمات لهذا الفني حتى الآن.
                </div>
              )}

              {selectedTechForRatings.ratingData &&
                selectedTechForRatings.ratingData.reviews &&
                selectedTechForRatings.ratingData.reviews.length > 0 && (
                  <>
                    {/* ملخص عام */}
                    <div className="flex flex-wrap items-center gap-4 mb-6">
                      <div className="flex items-center gap-2 bg-blue-50 border border-blue-100 px-4 py-2 rounded-xl">
                        <FiStar className="text-amber-500" size={20} />
                        <span className="text-lg font-semibold text-gray-800">
                          متوسط التقييم:
                        </span>
                        <span className="text-xl font-bold text-gray-800">
                          {parseFloat(selectedTechForRatings.ratingData.averageRating).toFixed(1)}
                        </span>
                        <span className="text-sm text-gray-500">
                          ({selectedTechForRatings.ratingData.totalRatings} تقييم)
                        </span>
                      </div>
                    </div>

                    {/* جدول التقييمات */}
                    <div className="overflow-x-auto border border-gray-200 rounded-xl">
                      <table className="w-full text-right text-sm">
                        <thead className="bg-gray-50 text-gray-700">
                          <tr>
                            <th className="p-3 font-semibold">معرّف الطلب</th>
                            <th className="p-3 font-semibold">التقييم</th>
                            <th className="p-3 font-semibold">التعليق</th>
                            <th className="p-3 font-semibold">تاريخ التقييم</th>
                          </tr>
                        </thead>
                        <tbody>
                          {selectedTechForRatings.ratingData.reviews.map((r, idx) => {
                            let formattedDate = "غير محدد";
                            if (r.createdAt) {
                              const d = new Date(r.createdAt);
                              if (!isNaN(d.getTime())) {
                                formattedDate = d.toLocaleString("ar-SA");
                              }
                            }
                            return (
                              <tr
                                key={r.orderId || idx}
                                className="border-t border-gray-100 hover:bg-gray-50 transition-colors"
                              >
                                <td className="p-3 text-gray-700">
                                  <span className="font-mono text-xs bg-gray-100 px-2 py-1 rounded">
                                    {r.orderId || "غير معروف"}
                                  </span>
                                </td>
                                <td className="p-3">
                                  <div className="inline-flex items-center gap-1 bg-amber-50 px-2 py-1 rounded-lg border border-amber-100">
                                    <FiStar className="text-amber-500" size={14} />
                                    <span className="font-semibold text-gray-800">
                                      {r.rating}/5
                                    </span>
                                  </div>
                                </td>
                                <td className="p-3 text-gray-700">
                                  {r.review && r.review.trim() !== ""
                                    ? r.review
                                    : <span className="text-gray-400">لا يوجد تعليق</span>}
                                </td>
                                <td className="p-3 text-gray-600 text-xs">
                                  {formattedDate}
                                </td>
                              </tr>
                            );
                          })}
                        </tbody>
                      </table>
                    </div>
                  </>
                )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

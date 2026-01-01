const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");

const app = express();

// تحسين CORS للسماح بجميع المنشأ (للتطوير فقط)
app.use(cors({
  origin: '*', // في الإنتاج، استبدل بـ origin محدد
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: false
}));

// Logging middleware للطلبات
app.use((req, res, next) => {
  console.log(`📨 ${req.method} ${req.path} - ${new Date().toISOString()}`);
  next();
});

app.use(express.json());

// 1) تهيئة Firebase
let db;
try {
  let serviceAccount;
  
  // التحقق من وجود Firebase credentials في environment variables (للنشر على Cloud)
  // أو من ملف firebase-key.json (للتطوير المحلي)
  if (process.env.FIREBASE_PRIVATE_KEY) {
    // Production: استخدام environment variables
    serviceAccount = {
      type: "service_account",
      project_id: process.env.FIREBASE_PROJECT_ID,
      private_key_id: process.env.FIREBASE_PRIVATE_KEY_ID,
      private_key: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
      client_email: process.env.FIREBASE_CLIENT_EMAIL,
      client_id: process.env.FIREBASE_CLIENT_ID,
      auth_uri: "https://accounts.google.com/o/oauth2/auth",
      token_uri: "https://oauth2.googleapis.com/token",
      auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
      client_x509_cert_url: process.env.FIREBASE_CLIENT_X509_CERT_URL
    };
    console.log("🔧 Using Firebase credentials from environment variables");
  } else {
    // Development: استخدام ملف firebase-key.json
    serviceAccount = require("./firebase-key.json");
    console.log("🔧 Using Firebase credentials from firebase-key.json");
  }

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });

  db = admin.firestore();
  
  console.log("✅ Firebase Admin initialized successfully");
  console.log("📊 Project ID:", serviceAccount.project_id);
  
  // اختبار الاتصال بـ Firestore
  db.collection("_test").limit(1).get()
    .then(() => {
      console.log("✅ Firestore connection verified");
    })
    .catch((err) => {
      console.warn("⚠️  Firestore test query failed (this is normal if collection doesn't exist):", err.message);
    });
} catch (err) {
  console.error("❌ Firebase initialization failed:", err.message);
  console.error("   Make sure firebase-key.json exists (local) or environment variables are set (production)");
  process.exit(1);
}

// ==============================
// 2) الطلبات – Firestore
// ==============================

// استقبال طلب جديد
app.post("/new-request", async (req, res) => {
  try {
    console.log("📥 Received new request:", JSON.stringify(req.body, null, 2));

    // التحقق من البيانات المطلوبة
    const { serviceType, carModel, plateNumber, notes, latitude, longitude } = req.body;
    
    if (!serviceType || !carModel || !notes || latitude === undefined || longitude === undefined) {
      return res.status(400).json({
        success: false,
        error: "Missing required fields: serviceType, carModel, notes, latitude, longitude"
      });
    }

    const newReq = {
      serviceType,
      carModel,
      plateNumber: plateNumber || "",
      notes,
      latitude: Number(latitude),
      longitude: Number(longitude),
      status: "new",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    console.log("💾 Saving to Firestore...");
    const docRef = await db.collection("requests").add(newReq);

    console.log("✅ Request saved successfully with ID:", docRef.id);

    res.json({
      success: true,
      message: "تم إرسال الطلب بنجاح",
      id: docRef.id,
      data: {
        ...newReq,
        id: docRef.id,
        // createdAt سيتم إضافته من Firestore
      }
    });
  } catch (err) {
    console.error("❌ Error saving request:", err);
    console.error("Error details:", err.stack);
    res.status(500).json({ 
      success: false, 
      error: err.message || "فشل في حفظ الطلب"
    });
  }
});

// جميع الطلبات
app.get("/requests", async (req, res) => {
  try {
    console.log("📥 Fetching all requests...");
    
    const snap = await db.collection("requests")
      .orderBy("createdAt", "desc")
      .get();

    const list = snap.docs.map(doc => {
      const data = doc.data();
      // تحويل Firestore Timestamp إلى ISO string
      const createdAt = data.createdAt?.toDate?.()?.toISOString() || 
                        data.createdAt?.seconds ? 
                        new Date(data.createdAt.seconds * 1000).toISOString() : 
                        null;
      
      const result = {
        id: doc.id,
        ...data,
        createdAt: createdAt || data.createdAt,
      };
      
      // Log technicianId for debugging
      console.log(`📋 Request ${doc.id} - technicianId: ${result.technicianId || 'NULL/UNDEFINED'}, status: ${result.status}`);
      
      return result;
    });

    console.log(`✅ Found ${list.length} requests`);
    res.json(list);
  } catch (err) {
    console.error("❌ Error fetching requests:", err);
    res.status(500).json({ 
      success: false, 
      error: err.message || "فشل في جلب الطلبات"
    });
  }
});

// تحديث حالة الطلب
app.patch("/requests/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { status, technicianId } = req.body;

    const updateData = {
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    };

    if (status) {
      if (!["new", "in_progress", "completed", "cancelled"].includes(status)) {
        return res.status(400).json({
          success: false,
          error: "Invalid status. Must be: new, in_progress, completed, or cancelled"
        });
      }
      updateData.status = status;
    }

    if (technicianId !== undefined && technicianId !== null && technicianId !== '') {
      updateData.technicianId = technicianId;
      console.log(`👤 Setting technicianId to: ${technicianId} for request ${id}`);
      // إذا تم تعيين فني، قم بتغيير الحالة إلى "in_progress" تلقائيًا إذا لم يتم تحديد حالة أخرى
      if (technicianId && !status) {
        updateData.status = "in_progress";
      }
    } else if (technicianId === null || technicianId === '') {
      // إذا تم إرسال null أو string فارغ، قم بحذف technicianId من الطلب
      updateData.technicianId = admin.firestore.FieldValue.delete();
      console.log(`👤 Removing technicianId from request ${id}`);
    }

    console.log(`📝 Updating request ${id}:`, JSON.stringify(updateData, null, 2));

    await db.collection("requests").doc(id).update(updateData);

    // Verify the update by reading the document back
    const updatedDoc = await db.collection("requests").doc(id).get();
    const updatedData = updatedDoc.data();
    console.log(`✅ Request ${id} updated successfully. Current data:`, {
      technicianId: updatedData.technicianId,
      status: updatedData.status
    });
    res.json({
      success: true,
      message: "تم تحديث حالة الطلب بنجاح"
    });
  } catch (err) {
    console.error("❌ Error updating request:", err);
    res.status(500).json({
      success: false,
      error: err.message || "فشل في تحديث حالة الطلب"
    });
  }
});

// حذف طلب
app.delete("/requests/:id", async (req, res) => {
  console.log(`🔍 DELETE /requests/:id route hit! ID: ${req.params.id}`);
  try {
    const { id } = req.params;
    console.log(`🗑️  Deleting request ${id}`);

    if (!id || id === 'undefined' || id === 'null') {
      return res.status(400).json({
        success: false,
        error: "معرف الطلب غير صحيح"
      });
    }

    const docRef = db.collection("requests").doc(id);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.status(404).json({
        success: false,
        error: "الطلب غير موجود"
      });
    }

    await docRef.delete();

    console.log(`✅ Request ${id} deleted successfully`);
    res.json({
      success: true,
      message: "تم حذف الطلب بنجاح"
    });
  } catch (err) {
    console.error("❌ Error deleting request:", err);
    res.status(500).json({
      success: false,
      error: err.message || "فشل في حذف الطلب"
    });
  }
});

// حذف جميع الطلبات
app.delete("/requests", async (req, res) => {
  console.log(`🔍 DELETE /requests route hit! (Delete all requests)`);
  try {
    const snapshot = await db.collection("requests").get();
    
    if (snapshot.empty) {
      return res.json({
        success: true,
        message: "لا توجد طلبات للحذف",
        deletedCount: 0
      });
    }

    const batch = db.batch();
    let deletedCount = 0;

    snapshot.forEach((doc) => {
      batch.delete(doc.ref);
      deletedCount++;
    });

    await batch.commit();

    console.log(`✅ Deleted ${deletedCount} requests successfully`);
    res.json({
      success: true,
      message: `تم حذف ${deletedCount} طلب بنجاح`,
      deletedCount: deletedCount
    });
  } catch (err) {
    console.error("❌ Error deleting all requests:", err);
    res.status(500).json({
      success: false,
      error: err.message || "فشل في حذف الطلبات"
    });
  }
});

// ==============================
// الفنيين – Firestore
// ==============================

// إضافة فني
app.post("/technicians", async (req, res) => {
  try {
    const tech = {
      ...req.body,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      status: "available"
    };

    await db.collection("technicians").add(tech);

    res.json({ success: true, message: "Technician added" });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// عرض الفنيين
app.get("/technicians", async (req, res) => {
  try {
    const snap = await db.collection("technicians")
      .orderBy("createdAt", "desc")
      .get();

    const techList = snap.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));

    res.json(techList);
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// تسجيل دخول الفني
app.post("/technician-login", async (req, res) => {
  const { phone, password } = req.body;

  const snap = await db.collection("technicians")
    .where("phone", "==", phone)
    .where("password", "==", password)
    .get();

  if (snap.empty) {
    return res.status(401).json({ success: false, message: "Invalid login" });
  }

  const tech = snap.docs[0];
  res.json({
    success: true,
    id: tech.id,
    name: tech.data().name
  });
});

// حذف فني
app.delete("/technicians/:id", async (req, res) => {
  console.log(`🔍 DELETE /technicians/:id route hit! ID: ${req.params.id}`);
  try {
    const { id } = req.params;
    console.log(`🗑️  Deleting technician ${id}`);

    if (!id || id === 'undefined' || id === 'null') {
      return res.status(400).json({
        success: false,
        error: "معرف الفني غير صحيح"
      });
    }

    const docRef = db.collection("technicians").doc(id);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.status(404).json({
        success: false,
        error: "الفني غير موجود"
      });
    }

    await docRef.delete();

    console.log(`✅ Technician ${id} deleted successfully`);
    res.json({
      success: true,
      message: "تم حذف الفني بنجاح"
    });
  } catch (err) {
    console.error("❌ Error deleting technician:", err);
    res.status(500).json({
      success: false,
      error: err.message || "فشل في حذف الفني"
    });
  }
});

// ==============================
// Health Check Endpoint
// ==============================
app.get("/health", (req, res) => {
  res.json({
    server: "running",
    firebase: "connected",
    timestamp: new Date().toISOString(),
    endpoints: {
      newRequest: "/new-request",
      requests: "/requests",
      technicians: "/technicians"
    }
  });
});

// Handle preflight requests (OPTIONS)
app.use((req, res, next) => {
  if (req.method === 'OPTIONS') {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE, OPTIONS');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    return res.sendStatus(200);
  }
  next();
});

// 404 handler - يجب أن يكون بعد جميع الـ routes
app.use((req, res) => {
  console.log(`❌ 404 - Endpoint not found: ${req.method} ${req.path}`);
  res.status(404).json({
    success: false,
    error: `Endpoint not found: ${req.method} ${req.path}`
  });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error("❌ Global error handler:", err);
  res.status(err.status || 500).json({
    success: false,
    error: err.message || "Internal server error"
  });
});

// ==============================
// تشغيل السيرفر
// ==============================
// استخدام PORT من environment variable (للنشر على Cloud) أو 3000 (للتطوير المحلي)
const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '0.0.0.0'; // الاستماع على جميع الـ interfaces

app.listen(PORT, HOST, () => {
  console.log("🔥 SHM Backend + Firebase Running");
  console.log(`   Port: ${PORT}`);
  console.log(`   Environment: ${process.env.NODE_ENV || 'development'}`);
  if (process.env.RAILWAY_PUBLIC_DOMAIN) {
    console.log(`   Public URL: https://${process.env.RAILWAY_PUBLIC_DOMAIN}`);
  } else if (process.env.RENDER_EXTERNAL_URL) {
    console.log(`   Public URL: ${process.env.RENDER_EXTERNAL_URL}`);
  } else {
    console.log(`   Local: http://localhost:${PORT}`);
  }
  console.log(`   Health Check: /health`);
  console.log("✅ Ready to receive requests!");
  console.log("\n📋 Registered DELETE routes:");
  console.log("   DELETE /requests/:id");
  console.log("   DELETE /technicians/:id");
});

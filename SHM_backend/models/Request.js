const mongoose = require("mongoose");

const requestSchema = new mongoose.Schema({
  serviceType: { type: String, required: true }, // بنشر متنقل، بطارية متنقلة
  carModel: { type: String, required: true },
  plateNumber: { type: String, required: true },
  notes: { type: String, default: "" },
  latitude: { type: Number, required: true },
  longitude: { type: Number, required: true },
  status: { 
    type: String, 
    default: "new",
    enum: ["new", "in_progress", "completed", "cancelled"]
  },
  technicianId: { type: mongoose.Schema.Types.ObjectId, ref: "Technician", default: null }, // الفني المسؤول
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

// تحديث updatedAt قبل الحفظ
requestSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model("Request", requestSchema);


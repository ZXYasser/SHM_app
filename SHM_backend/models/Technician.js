const mongoose = require("mongoose");

const technicianSchema = new mongoose.Schema({
  name: String,
  phone: String,
  password: String,   // لاحقًا نضيف تشفير
  status: { type: String, default: "active" }, // active, inactive
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model("Technician", technicianSchema);

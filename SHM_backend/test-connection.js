// ملف اختبار بسيط للتحقق من اتصال MongoDB
const mongoose = require('mongoose');

const MONGODB_URI = "mongodb+srv://yasser:1017@cluster0.rxpvf2b.mongodb.net/shm?retryWrites=true&w=majority&appName=Cluster0";

console.log('🔄 Testing MongoDB Connection...');
console.log('📋 Connection String:', MONGODB_URI.replace(/\/\/.*@/, '//***:***@')); // إخفاء credentials

mongoose.connect(MONGODB_URI, {
  serverSelectionTimeoutMS: 15000,
  socketTimeoutMS: 45000,
  connectTimeoutMS: 15000,
})
  .then(() => {
    console.log('✅ Connection successful!');
    console.log('📊 Database:', mongoose.connection.db.databaseName);
    console.log('🌐 Host:', mongoose.connection.host);
    process.exit(0);
  })
  .catch((err) => {
    console.error('❌ Connection failed!');
    console.error('Error:', err.message);
    console.error('\n🔍 Possible issues:');
    console.error('1. Check username/password in connection string');
    console.error('2. Check IP whitelist in MongoDB Atlas');
    console.error('3. Check internet connection');
    console.error('4. Check firewall settings');
    process.exit(1);
  });



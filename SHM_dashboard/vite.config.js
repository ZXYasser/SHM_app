import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    host: true, // للسماح بالوصول من الشبكة
    open: false, // تعطيل الفتح التلقائي
    strictPort: false, // السماح باستخدام منفذ آخر إذا كان 5173 مشغولاً
  },
  build: {
    outDir: 'dist',
    sourcemap: false,
  },
})

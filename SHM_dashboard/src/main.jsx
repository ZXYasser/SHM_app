import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'

// Error boundary for better error handling
const rootElement = document.getElementById('root')
if (!rootElement) {
  throw new Error('Root element not found')
}

try {
  createRoot(rootElement).render(
    <StrictMode>
      <App />
    </StrictMode>,
  )
} catch (error) {
  console.error('Error rendering app:', error)
  rootElement.innerHTML = `
    <div style="padding: 20px; font-family: Arial; text-align: center;">
      <h1>خطأ في تحميل التطبيق</h1>
      <p>${error.message}</p>
      <p>يرجى التحقق من Console للأخطاء</p>
    </div>
  `
}

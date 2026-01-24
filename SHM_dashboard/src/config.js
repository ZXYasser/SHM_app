// API Configuration
// Railway URL
export const API_URL = import.meta.env.VITE_API_URL || 'https://shmapp-production.up.railway.app';

// Debug: Log API URL on import
console.log('🔧 API_URL configured:', API_URL);
console.log('🔧 VITE_API_URL env:', import.meta.env.VITE_API_URL);


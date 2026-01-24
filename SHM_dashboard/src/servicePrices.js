// Service Prices Configuration
// نظام تسعيرات الخدمات - متزامن مع Flutter App

export const servicePrices = {
  'بنشر متنقل': { price: 50, isVariable: false },
  'بطارية متنقلة': { price: 80, isVariable: false },
  'خلل كهربائي': { price: 100, isVariable: false },
  'إصلاح تكييف': { price: 120, isVariable: false },
  'تغيير زيت': { price: null, isVariable: true },
  'ميكانيكا': { price: 150, isVariable: false },
  'مفتاح': { price: 80, isVariable: false },
  'خلل آخر': { price: 100, isVariable: false },
  'تغيير إطارات': { price: null, isVariable: true },
  'فحص شامل': { price: 120, isVariable: false },
  'طوارئ 24/7': { price: 150, isVariable: false },
  'فحص قبل الشراء': { price: 100, isVariable: false },
  'خدمة السحب': { price: 150, isVariable: false },
};

/**
 * الحصول على سعر الخدمة
 * @param {string} serviceType - نوع الخدمة
 * @returns {number|null} - السعر بالريال أو null إذا كان متغير
 */
export function getServicePrice(serviceType) {
  const service = servicePrices[serviceType];
  return service ? service.price : null;
}

/**
 * التحقق من كون السعر متغير
 * @param {string} serviceType - نوع الخدمة
 * @returns {boolean} - true إذا كان السعر متغير
 */
export function isServicePriceVariable(serviceType) {
  const service = servicePrices[serviceType];
  return service ? service.isVariable : false;
}

/**
 * الحصول على نص السعر للعرض
 * @param {string} serviceType - نوع الخدمة
 * @param {number|null} storedPrice - السعر المحفوظ في الطلب (اختياري)
 * @returns {string} - نص السعر للعرض
 */
export function getServicePriceText(serviceType, storedPrice = null) {
  // إذا كان هناك سعر محفوظ في الطلب، استخدمه
  if (storedPrice !== null && storedPrice !== undefined) {
    return `${storedPrice} ريال`;
  }
  
  // إذا لم يكن هناك سعر محفوظ، استخدم السعر الافتراضي
  const service = servicePrices[serviceType];
  if (!service) {
    return 'غير محدد';
  }
  
  if (service.isVariable) {
    return 'حسب الكمية';
  }
  
  if (service.price !== null) {
    return `${service.price} ريال`;
  }
  
  return 'غير محدد';
}

/**
 * الحصول على السعر النهائي للعرض (مع أولوية السعر المحفوظ)
 * @param {object} order - الطلب
 * @returns {string} - نص السعر للعرض
 */
export function getOrderPriceText(order) {
  const serviceType = order.serviceType;
  const storedPrice = order.price;
  
  return getServicePriceText(serviceType, storedPrice);
}


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import '../models/request_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class RequestScreen extends StatefulWidget {
  final String serviceType;

  const RequestScreen({super.key, required this.serviceType});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final _carModelController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isSubmitting = false;
  String? _locationText; // نعرض نص مكان العميل

  // ✅ متغيرات الإحداثيات
  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    _carModelController.dispose();
    _plateNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _isGettingLocation = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // 1. التأكد من خدمة GPS
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _locationText = 'الرجاء تفعيل GPS من الإعدادات';
            _isGettingLocation = false;
          });
          _showErrorSnackBar('الرجاء تفعيل GPS من الإعدادات');
        }
        return;
      }

      // 2. فحص الصلاحيات
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _locationText = 'تم رفض إذن الموقع';
              _isGettingLocation = false;
            });
            _showErrorSnackBar('تم رفض إذن الموقع');
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _locationText = 'يجب تفعيل صلاحية الموقع يدويًا من الإعدادات';
            _isGettingLocation = false;
          });
          // عرض dialog مع زر لفتح الإعدادات
          _showSettingsDialog();
        }
        return;
      }

      // 3. الحصول على الإحداثيات
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final lat = position.latitude;
      final lng = position.longitude;

      if (mounted) {
        setState(() {
          _latitude = lat;
          _longitude = lng;
          _locationText = 'تم تحديد الموقع بنجاح ✓';
          _isGettingLocation = false;
        });
        _showSuccessSnackBar('تم تحديد موقعك بنجاح');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationText = 'حدث خطأ في تحديد الموقع';
          _isGettingLocation = false;
        });
        _showErrorSnackBar('حدث خطأ في تحديد الموقع');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تفعيل صلاحية الموقع'),
          content: const Text(
            'تم رفض صلاحية الموقع بشكل دائم.\n\n'
            'لتفعيلها:\n'
            '1. اذهب إلى إعدادات الجهاز\n'
            '2. ابحث عن "الموقع" أو "Location"\n'
            '3. ابحث عن اسم التطبيق\n'
            '4. فعّل صلاحية "الموقع" أو "Location"\n\n'
            'أو اضغط على الزر أدناه لفتح الإعدادات مباشرة.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // فتح إعدادات التطبيق
                await Geolocator.openAppSettings();
              },
              child: const Text('فتح الإعدادات'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    if (_latitude == null || _longitude == null) {
      _showErrorSnackBar('من فضلك حدّد موقعك أولاً');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // الحصول على سعر الخدمة
    final servicePrice = AppConstants.getServicePrice(widget.serviceType);

    // الحصول على معرف المستخدم الحالي (Firebase UID) إن وُجد
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    final request = ServiceRequest(
      serviceType: widget.serviceType,
      carModel: _carModelController.text.trim(),
      plateNumber: _plateNumberController.text.trim(),
      notes: _notesController.text.trim(),
      latitude: _latitude!,
      longitude: _longitude!,
      price: servicePrice, // إضافة السعر
      userId: userId,
    );

    final result = await ApiService.submitRequest(request);

    setState(() {
      _isSubmitting = false;
    });

    if (!mounted) return;

    if (result['success'] == true) {
      _showSuccess();
    } else {
      _showError(result['error'] ?? 'حدث خطأ غير معروف');
    }
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green[700],
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'تم إرسال الطلب بنجاح!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'شكراً لك، تم استلام طلب خدمة "${widget.serviceType}". سيتم التواصل معك قريباً.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(AppConstants.primaryColorValue),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('حسناً'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: Colors.red[700],
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'حدث خطأ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _submitRequest();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        AppConstants.primaryColorValue,
                      ),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('إعادة المحاولة'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(AppConstants.primaryColorValue);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        title: Text(widget.serviceType),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color,
                      color.withOpacity(0.85),
                      color.withOpacity(0.75),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.serviceType == AppConstants.serviceTire
                            ? Icons.build_circle_rounded
                            : Icons.battery_charging_full_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.serviceType,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.edit_note_rounded,
                                size: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'املأ التفاصيل أدناه لإرسال طلبك',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Car Model Field
              TextFormField(
                controller: _carModelController,
                decoration: InputDecoration(
                  labelText: 'نوع وموديل السيارة',
                  hintText: 'مثال: تويوتا كامري 2020',
                  prefixIcon: const Icon(Icons.directions_car),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'من فضلك أدخل نوع السيارة'
                    : null,
              ),
              const SizedBox(height: 16),

              // Plate Number Field
              TextFormField(
                controller: _plateNumberController,
                decoration: InputDecoration(
                  labelText: 'رقم اللوحة (اختياري)',
                  hintText: 'مثال: أ ب ج 1234',
                  prefixIcon: const Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),

              // Notes Field
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'وصف المشكلة / تفاصيل إضافية',
                  hintText: 'اكتب تفاصيل المشكلة هنا...',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'من فضلك صف مشكلتك باختصار'
                    : null,
              ),
              const SizedBox(height: 24),

              // Location Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue[50]!,
                      Colors.blue[100]!.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue[200]!, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Colors.blue[700],
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'الموقع',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isGettingLocation
                                ? null
                                : _getCurrentLocation,
                            icon: _isGettingLocation
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.my_location),
                            label: Text(
                              _isGettingLocation
                                  ? 'جاري التحديد...'
                                  : 'تحديد موقعي',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                              shadowColor: Colors.blue.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_locationText != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _latitude != null
                                ? Colors.green[200]!
                                : Colors.blue[200]!,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (_latitude != null
                                          ? Colors.green
                                          : Colors.blue)
                                      .withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _latitude != null
                                  ? Icons.check_circle
                                  : Icons.info_outline,
                              color: _latitude != null
                                  ? Colors.green
                                  : Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _locationText!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _latitude != null
                                      ? Colors.green[700]
                                      : Colors.blue[700],
                                  fontWeight: _latitude != null
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isSubmitting
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('جاري الإرسال...'),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'إرسال الطلب',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

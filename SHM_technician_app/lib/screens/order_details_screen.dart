import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/request_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;
  final VoidCallback onOrderUpdated;

  const OrderDetailsScreen({
    super.key,
    required this.order,
    required this.onOrderUpdated,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isUpdating = false;
  bool _isDeleting = false;
  bool _isUpdatingArrivalTime = false;
  bool _isCancelling = false;

  Future<void> _updateStatus(String newStatus) async {
    if (!mounted) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد'),
        content: Text('هل تريد تغيير حالة الطلب إلى "${_getStatusText(newStatus)}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppConstants.primaryColorValue),
            ),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isUpdating = true;
    });

    // الحصول على ID الفني
    final techData = await StorageService.getTechnicianData();
    final technicianId = techData['id'];

    final result = await ApiService.updateRequestStatus(
      widget.order.id,
      newStatus,
      technicianId: technicianId,
    );

    setState(() {
      _isUpdating = false;
    });

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'تم التحديث بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onOrderUpdated();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'فشل التحديث'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'new':
        return 'جديد';
      case 'in_progress':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  Future<void> _cancelOrder() async {
    if (!mounted) return;

    // طلب سبب الإلغاء
    final reasonController = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الطلب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('يرجى إدخال سبب الإلغاء:'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'مثال: عدم توفر قطع الغيار المطلوبة',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يرجى إدخال سبب الإلغاء'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('تأكيد الإلغاء'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isCancelling = true;
    });

    final result = await ApiService.updateRequestStatus(
      widget.order.id,
      'cancelled',
    );

    setState(() {
      _isCancelling = false;
    });

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'تم إلغاء الطلب بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onOrderUpdated();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'فشل إلغاء الطلب'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الطلب؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isDeleting = true;
    });

    final result = await ApiService.deleteRequest(widget.order.id);

    setState(() {
      _isDeleting = false;
    });

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'تم حذف الطلب بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onOrderUpdated();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'فشل حذف الطلب'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openMaps() async {
    final url = Uri.parse(
      'https://www.google.com/maps?q=${widget.order.latitude},${widget.order.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _setEstimatedArrivalTime() async {
    final color = const Color(AppConstants.primaryColorValue);
    int? selectedMinutes;

    final result = await showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('تحديد وقت الوصول المتوقع'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'اختر الوقت المتوقع للوصول إلى موقع العميل:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [5, 10, 15, 20, 30, 45, 60].map((minutes) {
                  final isSelected = selectedMinutes == minutes;
                  return ChoiceChip(
                    label: Text('$minutes دقيقة'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setDialogState(() {
                        selectedMinutes = selected ? minutes : null;
                      });
                    },
                    selectedColor: color.withOpacity(0.3),
                    checkmarkColor: color,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'أو أدخل عدد الدقائق يدوياً',
                  hintText: 'مثال: 25',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  final minutes = int.tryParse(value);
                  if (minutes != null && minutes > 0) {
                    setDialogState(() {
                      selectedMinutes = minutes;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: selectedMinutes != null
                  ? () => Navigator.pop(context, selectedMinutes)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
              ),
              child: const Text('تأكيد'),
            ),
          ],
        ),
      ),
    );

    if (result == null || result <= 0) return;

    setState(() {
      _isUpdatingArrivalTime = true;
    });

    final techData = await StorageService.getTechnicianData();
    final technicianId = techData['id'];

    final updateResult = await ApiService.updateEstimatedArrivalTime(
      widget.order.id,
      result,
      technicianId: technicianId,
    );

    setState(() {
      _isUpdatingArrivalTime = false;
    });

    if (!mounted) return;

    if (updateResult['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحديد وقت الوصول: $result دقيقة'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onOrderUpdated();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(updateResult['error'] ?? 'فشل التحديث'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'new':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(AppConstants.primaryColorValue);
    final order = widget.order;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطلب'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getStatusColor(order.status).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: _getStatusColor(order.status),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'حالة الطلب',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.statusText,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(order.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Order Details
            _buildDetailCard(
              'نوع الخدمة',
              order.serviceType,
              Icons.build_circle,
            ),
            const SizedBox(height: 12),
            _buildDetailCard(
              'نوع السيارة',
              order.carModel,
              Icons.directions_car,
            ),
            if (order.plateNumber.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildDetailCard(
                'رقم اللوحة',
                order.plateNumber,
                Icons.confirmation_number,
              ),
            ],
            const SizedBox(height: 12),
            _buildDetailCard(
              'الوصف',
              order.notes.isNotEmpty ? order.notes : 'لا يوجد وصف',
              Icons.description,
            ),
            const SizedBox(height: 12),
            _buildDetailCard(
              'الموقع',
              '${order.latitude.toStringAsFixed(6)}, ${order.longitude.toStringAsFixed(6)}',
              Icons.location_on,
            ),
            if (order.createdAt != null) ...[
              const SizedBox(height: 12),
              _buildDetailCard(
                'تاريخ الطلب',
                '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year} ${order.createdAt!.hour}:${order.createdAt!.minute.toString().padLeft(2, '0')}',
                Icons.calendar_today,
              ),
            ],

            const SizedBox(height: 24),

            // Actions
            // زر "بدء التنفيذ" - يظهر عندما يكون الفني معين والحالة "new"
            if (order.status == 'new' && order.technicianId != null && order.technicianId!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isUpdating
                      ? null
                      : () => _updateStatus('in_progress'),
                  icon: _isUpdating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow),
                  label: const Text(
                    'بدء التنفيذ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

            // Set/Update Estimated Arrival Time Button
            // زر "تحديد وقت الوصول" - يظهر عندما يكون الفني معين والحالة "new" أو "in_progress"
            if ((order.status == 'new' || order.status == 'in_progress') && order.technicianId != null && order.technicianId!.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isUpdatingArrivalTime ? null : _setEstimatedArrivalTime,
                  icon: _isUpdatingArrivalTime
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.access_time),
                  label: Text(
                    order.estimatedArrivalMinutes != null
                        ? 'تحديث وقت الوصول (${order.estimatedArrivalMinutes} دقيقة)'
                        : 'تحديد وقت الوصول المتوقع',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],

            if (order.status == 'in_progress') ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isUpdating
                      ? null
                      : () => _updateStatus('completed'),
                  icon: _isUpdating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle),
                  label: const Text(
                    'إكمال الطلب',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Cancel Order Button - للفني (مع سبب)
            if ((order.status == 'new' || order.status == 'in_progress') && order.technicianId != null && order.technicianId!.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isCancelling ? null : _cancelOrder,
                  icon: _isCancelling
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.cancel_outlined),
                  label: const Text(
                    'إلغاء الطلب',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],

            // Open Maps Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _openMaps,
                icon: const Icon(Icons.map),
                label: const Text(
                  'فتح الموقع في خرائط Google',
                  style: TextStyle(fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: color,
                  side: BorderSide(color: color, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Delete Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isDeleting ? null : _deleteOrder,
                icon: _isDeleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete),
                label: Text(
                  _isDeleting ? 'جاري الحذف...' : 'حذف الطلب',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(AppConstants.primaryColorValue).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(AppConstants.primaryColorValue),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

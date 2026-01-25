import 'package:flutter/material.dart';
import '../models/request_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import 'order_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<OrderModel> _orders = [];
  bool _isLoading = true;
  String _filterStatus = 'all';

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await ApiService.getRequests();
      // الحصول على ID الفني الحالي
      final techData = await StorageService.getTechnicianData();
      final currentTechnicianId = techData['id'];

      // فلترة الطلبات: عرض الطلبات المخصصة لهذا الفني فقط
      // الطلبات غير المعينة تبقى في Dashboard حتى يتم تعيينها
      final allOrders = data.map((json) => OrderModel.fromJson(json)).toList();
      final filteredOrders = allOrders.where((order) {
        // عرض الطلبات المخصصة لهذا الفني فقط
        if (order.technicianId == currentTechnicianId) return true;
        // لا نعرض الطلبات غير المعينة - تبقى في Dashboard فقط
        return false;
      }).toList();

      setState(() {
        _orders = filteredOrders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        _showError('فشل تحميل الطلبات');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteOrder(OrderModel order) async {
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

    final result = await ApiService.deleteRequest(order.id);

    if (!mounted) return;

    if (result['success'] == true) {
      _showSuccess(result['message'] ?? 'تم حذف الطلب بنجاح');
      _loadOrders();
    } else {
      _showError(result['error'] ?? 'فشل حذف الطلب');
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<OrderModel> get _filteredOrders {
    if (_filterStatus == 'all') return _orders;
    return _orders.where((o) => o.status == _filterStatus).toList();
  }

  Map<String, int> get _stats {
    return {
      'total': _orders.length,
      'new': _orders.where((o) => o.status == 'new').length,
      'in_progress': _orders.where((o) => o.status == 'in_progress').length,
      'completed': _orders.where((o) => o.status == 'completed').length,
    };
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
    final stats = _stats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلبات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Statistics Cards
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[50],
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'إجمالي',
                          stats['total']!,
                          Colors.blue,
                          Icons.list_alt,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'جديدة',
                          stats['new']!,
                          Colors.orange,
                          Icons.new_releases,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'قيد التنفيذ',
                          stats['in_progress']!,
                          Colors.purple,
                          Icons.hourglass_empty,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'مكتملة',
                          stats['completed']!,
                          Colors.green,
                          Icons.check_circle,
                        ),
                      ),
                    ],
                  ),
                ),

                // Filter Buttons
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterButton('all', 'الكل', _filterStatus == 'all'),
                        const SizedBox(width: 8),
                        _buildFilterButton('new', 'جديدة', _filterStatus == 'new'),
                        const SizedBox(width: 8),
                        _buildFilterButton(
                          'in_progress',
                          'قيد التنفيذ',
                          _filterStatus == 'in_progress',
                        ),
                        const SizedBox(width: 8),
                        _buildFilterButton(
                          'completed',
                          'مكتملة',
                          _filterStatus == 'completed',
                        ),
                      ],
                    ),
                  ),
                ),

                // Orders List
                Expanded(
                  child: _filteredOrders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 80,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'لا توجد طلبات',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadOrders,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredOrders.length,
                            itemBuilder: (context, index) {
                              final order = _filteredOrders[index];
                              return _buildOrderCard(order, color);
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String status, String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = status;
        });
      },
      selectedColor: const Color(AppConstants.primaryColorValue).withOpacity(0.2),
      checkmarkColor: const Color(AppConstants.primaryColorValue),
      labelStyle: TextStyle(
        color: isSelected
            ? const Color(AppConstants.primaryColorValue)
            : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailsScreen(
                  order: order,
                  onOrderUpdated: _loadOrders,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.statusText,
                        style: TextStyle(
                          color: _getStatusColor(order.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (order.technicianId != null)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person, size: 12, color: Colors.green[700]),
                            const SizedBox(width: 4),
                            Text(
                              'مخصص لك',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () => _deleteOrder(order),
                      tooltip: 'حذف الطلب',
                    ),
                    if (order.createdAt != null)
                      Text(
                        _formatDate(order.createdAt!),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      order.serviceType.contains('بنشر')
                          ? Icons.build_circle
                          : Icons.battery_charging_full,
                      color: color,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.serviceType,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.carModel,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'منذ ${difference.inMinutes} دقيقة';
      }
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

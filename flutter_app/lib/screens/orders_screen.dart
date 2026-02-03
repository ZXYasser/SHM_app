import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/request_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<OrderModel> _orders = [];
  List<OrderModel> _filteredOrders = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _selectedFilter = 'all'; // all, new, in_progress, completed, cancelled
  String _dateFilter = 'all'; // all, today, week, month

  @override
  void initState() {
    super.initState();
    _loadOrders(showLoading: true);
    // Check for status changes periodically
    _startStatusMonitoring();
  }

  void _startStatusMonitoring() {
    // Monitor order status changes every 5 seconds for better responsiveness
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _checkStatusChanges();
        _startStatusMonitoring();
      }
    });
  }

  final Map<String, String> _lastOrderStatuses = {};
  final Map<String, int?> _lastEstimatedArrivalMinutes = {};

  void _checkStatusChanges() {
    _loadOrders(showLoading: false).then((_) {
      if (!mounted) return;
      // Check for status changes and show notifications
      for (var order in _orders) {
        final orderId = order.id ?? '';
        if (orderId.isEmpty) continue;

        final lastStatus = _lastOrderStatuses[orderId];
        if (lastStatus != null && lastStatus != order.status) {
          if (order.status == 'in_progress') {
            _showStatusNotification(
              'تم قبول طلبك',
              'الفني في الطريق إلى موقعك',
            );
          } else if (order.status == 'completed') {
            _showStatusNotification(
              'تم إكمال طلبك',
              'شكراً لاستخدامك خدمات ${AppConstants.appName}',
            );
          } else if (order.status == 'cancelled') {
            _showStatusNotification('تم إلغاء الطلب', 'تم إلغاء طلبك بنجاح');
          }
        }
        _lastOrderStatuses[orderId] = order.status;

        // Check for estimated arrival time changes
        final lastArrivalMinutes = _lastEstimatedArrivalMinutes[orderId];
        final currentArrivalMinutes = order.estimatedArrivalMinutes;

        // Log for debugging
        if (currentArrivalMinutes != null &&
            currentArrivalMinutes != lastArrivalMinutes) {
          print(
            '🔔 Arrival time changed for order $orderId: $lastArrivalMinutes -> $currentArrivalMinutes',
          );
        }

        if (currentArrivalMinutes != null &&
            lastArrivalMinutes != currentArrivalMinutes) {
          _showStatusNotification(
            'تم تحديث وقت الوصول',
            'الفني سيصل خلال $currentArrivalMinutes دقيقة',
          );
        }
        _lastEstimatedArrivalMinutes[orderId] = currentArrivalMinutes;
      }
    });
  }

  void _showStatusNotification(String title, String body) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    body,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(AppConstants.primaryColorValue),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'عرض',
          textColor: Colors.white,
          onPressed: () {
            // Scroll to the order
          },
        ),
      ),
    );
  }

  Future<void> _loadOrders({bool showLoading = false}) async {
    if (showLoading) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    } else {
      setState(() {
        _hasError = false;
      });
    }

    try {
      final data = await ApiService.getRequests();
      if (mounted) {
        final parsedOrders = data.map((json) {
          final order = OrderModel.fromJson(json);
          // Debug: Log orders with estimatedArrivalMinutes
          if (order.estimatedArrivalMinutes != null) {
            print(
              '✅ Order ${order.id} has estimatedArrivalMinutes: ${order.estimatedArrivalMinutes}',
            );
          }
          return order;
        }).toList();

        setState(() {
          _orders = parsedOrders;
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error in _loadOrders: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilters() {
    List<OrderModel> filtered = List.from(_orders);

    // Filter by status
    if (_selectedFilter != 'all') {
      filtered = filtered
          .where((order) => order.status == _selectedFilter)
          .toList();
    }

    // Filter by date
    if (_dateFilter != 'all') {
      final now = DateTime.now();
      filtered = filtered.where((order) {
        if (order.createdAt == null) return false;
        final orderDate = order.createdAt!;
        switch (_dateFilter) {
          case 'today':
            return orderDate.year == now.year &&
                orderDate.month == now.month &&
                orderDate.day == now.day;
          case 'week':
            return now.difference(orderDate).inDays <= 7;
          case 'month':
            return orderDate.year == now.year && orderDate.month == now.month;
          default:
            return true;
        }
      }).toList();
    }

    setState(() {
      _filteredOrders = filtered;
    });
  }

  Map<String, dynamic> _getStatistics() {
    final totalOrders = _orders.length;
    final completedOrders = _orders
        .where((o) => o.status == 'completed')
        .length;
    final inProgressOrders = _orders
        .where((o) => o.status == 'in_progress')
        .length;
    // Assuming average order cost (you can calculate from actual data)
    final totalSpending = completedOrders * 150.0; // Example: 150 SAR per order

    return {
      'totalOrders': totalOrders,
      'completedOrders': completedOrders,
      'inProgressOrders': inProgressOrders,
      'totalSpending': totalSpending,
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

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'new':
        return Icons.new_releases;
      case 'in_progress':
        return Icons.hourglass_empty;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(AppConstants.primaryColorValue);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/icon/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox();
            },
          ),
        ),
        backgroundColor: color,
        foregroundColor: Colors.white,
        title: const Text(
          'طلباتي',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showFilterDialog,
            tooltip: 'فلترة',
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _loadOrders(showLoading: false),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ في تحميل الطلبات',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _loadOrders(showLoading: true),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 24),
                  Text(
                    'لا توجد طلبات حتى الآن',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ابدأ بإنشاء طلب جديد من الصفحة الرئيسية',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _loadOrders(showLoading: false),
              child: CustomScrollView(
                slivers: [
                  // Statistics Section
                  SliverToBoxAdapter(
                    child: _buildStatisticsSection(context, color),
                  ),
                  // Orders List
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: _filteredOrders.isEmpty
                        ? SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.filter_alt_off,
                                    size: 80,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'لا توجد طلبات مطابقة للفلتر',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'جرب تغيير الفلتر',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final order = _filteredOrders[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 15,
                                      offset: const Offset(0, 4),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      _showOrderDetails(order);
                                    },
                                    splashColor: color.withOpacity(0.1),
                                    highlightColor: color.withOpacity(0.05),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(
                                                    order.status,
                                                  ).withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  border: Border.all(
                                                    color: _getStatusColor(
                                                      order.status,
                                                    ).withOpacity(0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      _getStatusIcon(
                                                        order.status,
                                                      ),
                                                      size: 18,
                                                      color: _getStatusColor(
                                                        order.status,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      order.statusText,
                                                      style: TextStyle(
                                                        color: _getStatusColor(
                                                          order.status,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        letterSpacing: 0.3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              if (order.createdAt != null)
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .access_time_rounded,
                                                        size: 14,
                                                        color: Colors.grey[600],
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        _formatDate(
                                                          order.createdAt!,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[700],
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: color.withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  order.serviceType ==
                                                          AppConstants
                                                              .serviceTire
                                                      ? Icons
                                                            .build_circle_rounded
                                                      : Icons
                                                            .battery_charging_full_rounded,
                                                  color: color,
                                                  size: 28,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      order.serviceType,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.3,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    // Price Badge
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            bottom: 4,
                                                          ),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              order.price !=
                                                                  null
                                                              ? Colors.green[50]
                                                              : Colors
                                                                    .orange[50],
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          border: Border.all(
                                                            color:
                                                                order.price !=
                                                                    null
                                                                ? Colors
                                                                      .green[300]!
                                                                : Colors
                                                                      .orange[300]!,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          order.price != null
                                                              ? '${order.price} ريال'
                                                              : 'حسب الكمية',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                order.price !=
                                                                    null
                                                                ? Colors
                                                                      .green[700]
                                                                : Colors
                                                                      .orange[700],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // Estimated Arrival Time Badge
                                                    const SizedBox(height: 4),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            order.estimatedArrivalMinutes !=
                                                                null
                                                            ? Colors.blue[50]
                                                            : Colors.grey[50],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        border: Border.all(
                                                          color:
                                                              order.estimatedArrivalMinutes !=
                                                                  null
                                                              ? Colors
                                                                    .blue[300]!
                                                              : Colors
                                                                    .grey[300]!,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            order.estimatedArrivalMinutes !=
                                                                    null
                                                                ? Icons
                                                                      .access_time
                                                                : Icons
                                                                      .schedule,
                                                            size: 14,
                                                            color:
                                                                order.estimatedArrivalMinutes !=
                                                                    null
                                                                ? Colors
                                                                      .blue[700]
                                                                : Colors
                                                                      .grey[700],
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Builder(
                                                            builder: (context) {
                                                              // Debug: Log the value
                                                              if (order
                                                                      .estimatedArrivalMinutes !=
                                                                  null) {
                                                                print(
                                                                  '🎯 Displaying estimatedArrivalMinutes for order ${order.id}: ${order.estimatedArrivalMinutes}',
                                                                );
                                                              }
                                                              return Text(
                                                                order.estimatedArrivalMinutes !=
                                                                        null
                                                                    ? 'الوصول خلال ${order.estimatedArrivalMinutes} دقيقة'
                                                                    : 'سيتم تعيينه قريباً من الفني',
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      order.estimatedArrivalMinutes !=
                                                                          null
                                                                      ? Colors
                                                                            .blue[700]
                                                                      : Colors
                                                                            .grey[700],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .directions_car_rounded,
                                                          size: 16,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            order.carModel,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .grey[700],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons
                                                      .arrow_back_ios_new_rounded,
                                                  size: 16,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (order.plateNumber.isNotEmpty) ...[
                                            const SizedBox(height: 12),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[50],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .confirmation_number_rounded,
                                                    size: 16,
                                                    color: Colors.grey[600],
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'رقم اللوحة: ${order.plateNumber}',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey[700],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }, childCount: _filteredOrders.length),
                          ),
                  ),
                ],
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

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(order.status),
                            size: 18,
                            color: _getStatusColor(order.status),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            order.statusText,
                            style: TextStyle(
                              color: _getStatusColor(order.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Map Section
                if (order.status == 'in_progress' || order.status == 'new')
                  _buildMapSection(context, order),

                const SizedBox(height: 24),
                _buildDetailRow('نوع الخدمة', order.serviceType),
                const SizedBox(height: 16),
                // Price Card - Enhanced Design
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: order.price != null
                        ? Colors.green[50]
                        : Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: order.price != null
                          ? Colors.green[300]!
                          : Colors.orange[300]!,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'السعر',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        order.price != null
                            ? '${order.price} ريال'
                            : 'حسب الكمية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: order.price != null
                              ? Colors.green[700]
                              : Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                ),
                // Estimated Arrival Time Card
                if (order.status == 'new' || order.status == 'in_progress') ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: order.estimatedArrivalMinutes != null
                          ? Colors.blue[50]
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: order.estimatedArrivalMinutes != null
                            ? Colors.blue[300]!
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          order.estimatedArrivalMinutes != null
                              ? Icons.access_time
                              : Icons.schedule,
                          color: order.estimatedArrivalMinutes != null
                              ? Colors.blue[700]
                              : Colors.grey[700],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'وقت الوصول المتوقع',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order.estimatedArrivalMinutes != null
                                    ? 'الوصول خلال ${order.estimatedArrivalMinutes} دقيقة'
                                    : 'سيتم تعيينه قريباً من الفني',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: order.estimatedArrivalMinutes != null
                                      ? Colors.blue[700]
                                      : Colors.grey[700],
                                ),
                              ),
                              if (order.estimatedArrivalTimestamp != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'في الساعة ${order.estimatedArrivalTimestamp!.hour}:${order.estimatedArrivalTimestamp!.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                _buildDetailRow('نوع السيارة', order.carModel),
                if (order.plateNumber.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow('رقم اللوحة', order.plateNumber),
                ],
                const SizedBox(height: 16),
                _buildDetailRow(
                  'الوصف',
                  order.notes.isNotEmpty ? order.notes : 'لا يوجد وصف',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  'الموقع',
                  '${order.latitude.toStringAsFixed(6)}, ${order.longitude.toStringAsFixed(6)}',
                ),
                if (order.createdAt != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    'تاريخ الطلب',
                    '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year} ${order.createdAt!.hour}:${order.createdAt!.minute.toString().padLeft(2, '0')}',
                  ),
                ],

                // Cancel Order Button - فقط للطلبات قبل بدء التنفيذ
                if (order.status == 'new') ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _cancelOrder(order),
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text(
                        'إلغاء الطلب',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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

                // Rating Section - للطلبات المكتملة
                if (order.status == 'completed') ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber[700],
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              order.rating != null
                                  ? 'تم التقييم: ${order.rating}/5'
                                  : 'قيم خدمتك',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[900],
                              ),
                            ),
                          ],
                        ),
                        if (order.rating == null) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'كيف كانت تجربتك مع الخدمة؟',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _showRatingDialog(order),
                              icon: const Icon(Icons.star_rate),
                              label: const Text('قيم الخدمة'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber[600],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (order.review != null &&
                            order.review!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'تعليقك:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  order.review!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _cancelOrder(OrderModel order) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الإلغاء'),
        content: const Text('هل أنت متأكد من إلغاء هذا الطلب؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('تأكيد الإلغاء'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final result = await ApiService.updateRequestStatus(
        order.id!,
        'cancelled',
      );

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم إلغاء الطلب بنجاح'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _loadOrders(showLoading: false);
        Navigator.pop(context); // إغلاق dialog التفاصيل
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'فشل إلغاء الطلب'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showRatingDialog(OrderModel order) async {
    int selectedRating = 0;
    final reviewController = TextEditingController();
    bool isSubmitting = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('تقييم الخدمة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'كيف تقيم خدمتك؟',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedRating = starIndex;
                        });
                      },
                      child: Icon(
                        starIndex <= selectedRating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                const Text(
                  'تعليق (اختياري):',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: reviewController,
                  decoration: const InputDecoration(
                    hintText: 'شاركنا رأيك في الخدمة...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: isSubmitting || selectedRating == 0
                  ? null
                  : () async {
                      setDialogState(() {
                        isSubmitting = true;
                      });

                      try {
                        final result = await ApiService.submitRating(
                          order.id!,
                          selectedRating,
                          reviewController.text.trim().isEmpty
                              ? null
                              : reviewController.text.trim(),
                        );

                        if (!mounted) return;

                        if (result['success'] == true) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('شكراً لتقييمك!'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          _loadOrders(showLoading: false);
                          Navigator.pop(context); // إغلاق dialog التفاصيل
                        } else {
                          setDialogState(() {
                            isSubmitting = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                result['error'] ?? 'فشل إرسال التقييم',
                              ),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        setDialogState(() {
                          isSubmitting = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('حدث خطأ: $e'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[600],
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('إرسال التقييم'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection(BuildContext context, OrderModel order) {
    final color = const Color(AppConstants.primaryColorValue);
    final orderLocation = LatLng(order.latitude, order.longitude);
    // Simulated technician location (in real app, get from API)
    final technicianLocation = LatLng(
      order.latitude + 0.01,
      order.longitude + 0.01,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.map, color: color),
            const SizedBox(width: 8),
            const Text(
              'الموقع والتتبع',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: kIsWeb
                ? _buildWebMapAlternative(context, orderLocation, order, color)
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: orderLocation,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('order_location'),
                        position: orderLocation,
                        infoWindow: const InfoWindow(title: 'موقع الطلب'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue,
                        ),
                      ),
                      if (order.status == 'in_progress')
                        Marker(
                          markerId: const MarkerId('technician_location'),
                          position: technicianLocation,
                          infoWindow: const InfoWindow(title: 'موقع الفني'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueOrange,
                          ),
                        ),
                    },
                    polylines: order.status == 'in_progress'
                        ? {
                            Polyline(
                              polylineId: const PolylineId('route'),
                              points: [orderLocation, technicianLocation],
                              color: color,
                              width: 3,
                              patterns: [
                                PatternItem.dash(20),
                                PatternItem.gap(10),
                              ],
                            ),
                          }
                        : {},
                  ),
          ),
        ),
        if (order.status == 'in_progress') ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.directions_car, color: Colors.orange[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الفني في الطريق',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        order.estimatedArrivalMinutes != null
                            ? 'المسافة المتبقية: ${order.estimatedArrivalMinutes} دقيقة'
                            : 'سيتم تعيينه قريباً من الفني',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(BuildContext context, Color color) {
    final stats = _getStatistics();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إحصائياتي',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.receipt_long,
                  value: stats['totalOrders'].toString(),
                  label: 'إجمالي الطلبات',
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  value: stats['completedOrders'].toString(),
                  label: 'مكتملة',
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.hourglass_empty,
                  value: stats['inProgressOrders'].toString(),
                  label: 'قيد التنفيذ',
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.attach_money,
                  value: '${stats['totalSpending'].toStringAsFixed(0)} ر.س',
                  label: 'إجمالي الإنفاق',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'فلترة الطلبات',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'حسب الحالة:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    ['all', 'new', 'in_progress', 'completed', 'cancelled'].map(
                      (status) {
                        final isSelected = _selectedFilter == status;
                        return FilterChip(
                          label: Text(_getStatusText(status)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setModalState(() {
                              _selectedFilter = status;
                            });
                          },
                          selectedColor: const Color(
                            AppConstants.primaryColorValue,
                          ),
                          checkmarkColor: Colors.white,
                        );
                      },
                    ).toList(),
              ),
              const SizedBox(height: 24),
              const Text(
                'حسب التاريخ:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['all', 'today', 'week', 'month'].map((date) {
                  final isSelected = _dateFilter == date;
                  return FilterChip(
                    label: Text(_getDateFilterText(date)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() {
                        _dateFilter = date;
                      });
                    },
                    selectedColor: const Color(AppConstants.primaryColorValue),
                    checkmarkColor: Colors.white,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      AppConstants.primaryColorValue,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('تطبيق الفلتر'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'all':
        return 'الكل';
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

  String _getDateFilterText(String filter) {
    switch (filter) {
      case 'all':
        return 'الكل';
      case 'today':
        return 'اليوم';
      case 'week':
        return 'هذا الأسبوع';
      case 'month':
        return 'هذا الشهر';
      default:
        return filter;
    }
  }

  Widget _buildWebMapAlternative(
    BuildContext context,
    LatLng location,
    OrderModel order,
    Color color,
  ) {
    final googleMapsUrl =
        'https://www.google.com/maps?q=${location.latitude},${location.longitude}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'الموقع: ${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () async {
                final uri = Uri.parse(googleMapsUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('لا يمكن فتح الخريطة')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('فتح في Google Maps'),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

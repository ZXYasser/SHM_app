import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'type': 'card',
      'title': 'بطاقة ائتمانية',
      'details': '**** **** **** 1234',
      'isDefault': true,
    },
    {
      'type': 'mada',
      'title': 'مدى',
      'details': '**** **** **** 5678',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final color = const Color(AppConstants.primaryColorValue);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        title: const Text(
          'طرق الدفع',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showAddPaymentMethodDialog(context),
          ),
        ],
      ),
      body: _paymentMethods.isEmpty
          ? _buildEmptyState(context, color)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                return _buildPaymentMethodCard(
                    context, _paymentMethods[index], index, color);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'لا توجد طرق دفع محفوظة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'أضف طريقة دفعك الأولى',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _showAddPaymentMethodDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('إضافة طريقة دفع'),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(BuildContext context,
      Map<String, dynamic> method, int index, Color color) {
    IconData icon;
    Color iconColor;

    switch (method['type']) {
      case 'card':
        icon = Icons.credit_card;
        iconColor = Colors.blue;
        break;
      case 'mada':
        icon = Icons.account_balance_wallet;
        iconColor = Colors.green;
        break;
      default:
        icon = Icons.payment;
        iconColor = color;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        method['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (method['isDefault'] == true) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'افتراضي',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method['details'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('تعديل'),
                    ],
                  ),
                  onTap: () => _showEditPaymentMethodDialog(context, index),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        method['isDefault'] == true
                            ? Icons.star
                            : Icons.star_border,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(method['isDefault'] == true
                          ? 'إلغاء الافتراضي'
                          : 'تعيين كافتراضي'),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      for (var m in _paymentMethods) {
                        m['isDefault'] = false;
                      }
                      _paymentMethods[index]['isDefault'] = true;
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('حذف', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onTap: () => _showDeleteDialog(context, index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPaymentMethodDialog(BuildContext context) {
    // TODO: Implement add payment method dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ميزة إضافة طريقة دفع قيد التطوير')),
    );
  }

  void _showEditPaymentMethodDialog(BuildContext context, int index) {
    // TODO: Implement edit payment method dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ميزة تعديل طريقة دفع قيد التطوير')),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف طريقة الدفع'),
        content: const Text('هل أنت متأكد من حذف طريقة الدفع هذه؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _paymentMethods.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SavedCarsScreen extends StatefulWidget {
  const SavedCarsScreen({super.key});

  @override
  State<SavedCarsScreen> createState() => _SavedCarsScreenState();
}

class _SavedCarsScreenState extends State<SavedCarsScreen> {
  final List<Map<String, dynamic>> _cars = [
    {
      'model': 'تويوتا كامري',
      'plateNumber': 'أ ب ج 1234',
      'year': '2020',
      'color': 'أبيض',
      'isDefault': true,
    },
    {
      'model': 'هوندا أكورد',
      'plateNumber': 'د ه و 5678',
      'year': '2019',
      'color': 'أسود',
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
          'السيارات المحفوظة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showAddCarDialog(context),
          ),
        ],
      ),
      body: _cars.isEmpty
          ? _buildEmptyState(context, color)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cars.length,
              itemBuilder: (context, index) {
                return _buildCarCard(context, _cars[index], index, color);
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
            Icons.directions_car_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'لا توجد سيارات محفوظة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'أضف سيارتك الأولى',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _showAddCarDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('إضافة سيارة'),
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

  Widget _buildCarCard(
      BuildContext context, Map<String, dynamic> car, int index, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.directions_car, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            car['model'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (car['isDefault'] == true) ...[
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
                        '${car['year']} • ${car['color']}',
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
                      onTap: () => _showEditCarDialog(context, index),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            car['isDefault'] == true
                                ? Icons.star
                                : Icons.star_border,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(car['isDefault'] == true
                              ? 'إلغاء الافتراضي'
                              : 'تعيين كافتراضي'),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          for (var c in _cars) {
                            c['isDefault'] = false;
                          }
                          _cars[index]['isDefault'] = true;
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
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.confirmation_number, color: Colors.grey[700]),
                  const SizedBox(width: 8),
                  Text(
                    'رقم اللوحة: ${car['plateNumber']}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCarDialog(BuildContext context) {
    // TODO: Implement add car dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ميزة إضافة سيارة قيد التطوير')),
    );
  }

  void _showEditCarDialog(BuildContext context, int index) {
    // TODO: Implement edit car dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ميزة تعديل سيارة قيد التطوير')),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف السيارة'),
        content: const Text('هل أنت متأكد من حذف هذه السيارة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cars.removeAt(index);
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


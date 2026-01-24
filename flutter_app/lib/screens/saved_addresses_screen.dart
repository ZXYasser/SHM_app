import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final List<Map<String, dynamic>> _addresses = [
    {
      'title': 'المنزل',
      'address': 'حي النور، شارع الملك فهد، المدينة المنورة',
      'isDefault': true,
    },
    {
      'title': 'العمل',
      'address': 'حي العقيق، شارع الأمير محمد بن سلمان، المدينة المنورة',
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
          'العناوين المحفوظة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showAddAddressDialog(context),
          ),
        ],
      ),
      body: _addresses.isEmpty
          ? _buildEmptyState(context, color)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                return _buildAddressCard(
                    context, _addresses[index], index, color);
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
            Icons.location_on_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'لا توجد عناوين محفوظة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'أضف عنوانك الأول',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _showAddAddressDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('إضافة عنوان'),
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

  Widget _buildAddressCard(
      BuildContext context, Map<String, dynamic> address, int index, Color color) {
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
                  child: Icon(Icons.location_on, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (address['isDefault'] == true) ...[
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
                        address['address'],
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
                      onTap: () => _showEditAddressDialog(context, index),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            address['isDefault'] == true
                                ? Icons.star
                                : Icons.star_border,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(address['isDefault'] == true
                              ? 'إلغاء الافتراضي'
                              : 'تعيين كافتراضي'),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          for (var a in _addresses) {
                            a['isDefault'] = false;
                          }
                          _addresses[index]['isDefault'] = true;
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
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    // TODO: Implement add address dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ميزة إضافة عنوان قيد التطوير')),
    );
  }

  void _showEditAddressDialog(BuildContext context, int index) {
    // TODO: Implement edit address dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ميزة تعديل عنوان قيد التطوير')),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف العنوان'),
        content: const Text('هل أنت متأكد من حذف هذا العنوان؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _addresses.removeAt(index);
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


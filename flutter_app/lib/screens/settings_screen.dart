import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _orderNotifications = true;
  bool _promotionNotifications = false;
  String _selectedLanguage = 'العربية';

  @override
  Widget build(BuildContext context) {
    final color = const Color(AppConstants.primaryColorValue);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        title: const Text(
          'الإعدادات',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Section
            _buildSectionTitle('اللغة'),
            Card(
              child: ListTile(
                leading: Icon(Icons.language, color: color),
                title: const Text('اللغة'),
                subtitle: Text(_selectedLanguage),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showLanguageDialog(context),
              ),
            ),
            const SizedBox(height: 24),

            // Notifications Section
            _buildSectionTitle('الإشعارات'),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: Icon(Icons.notifications, color: color),
                    title: const Text('تفعيل الإشعارات'),
                    subtitle: const Text('استقبل إشعارات من التطبيق'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                        if (!value) {
                          _orderNotifications = false;
                          _promotionNotifications = false;
                        }
                      });
                    },
                  ),
                  if (_notificationsEnabled) ...[
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: Icon(Icons.shopping_cart, color: color),
                      title: const Text('إشعارات الطلبات'),
                      subtitle: const Text('إشعارات عن حالة طلباتك'),
                      value: _orderNotifications,
                      onChanged: (value) {
                        setState(() {
                          _orderNotifications = value;
                        });
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: Icon(Icons.local_offer, color: color),
                      title: const Text('إشعارات العروض'),
                      subtitle: const Text('إشعارات عن العروض والخصومات'),
                      value: _promotionNotifications,
                      onChanged: (value) {
                        setState(() {
                          _promotionNotifications = value;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // App Info Section
            _buildSectionTitle('معلومات التطبيق'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.info_outline, color: color),
                    title: const Text('عن التطبيق'),
                    subtitle: const Text('إصدار 1.0.0'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showAboutDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('العربية'),
              value: 'العربية',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('عن ${AppConstants.appName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppConstants.appName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(AppConstants.appTagline),
            const SizedBox(height: 16),
            const Text('الإصدار: 1.0.0'),
            const SizedBox(height: 8),
            const Text(
              'خدمة بنشر وبطاريات متنقلة في المدينة المنورة',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}

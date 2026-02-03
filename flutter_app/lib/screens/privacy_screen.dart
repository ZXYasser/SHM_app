import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// شاشة سياسة الخصوصية.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = const Color(AppConstants.primaryColorValue);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        title: const Text(
          'سياسة الخصوصية',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'سياسة خصوصية تطبيق ورشة SHM',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              '1. البيانات التي نجمعها',
              'نجمع البيانات اللازمة لتقديم الخدمة: مثل رقم الجوال أو البريد الإلكتروني عند التسجيل، والموقع عند طلب الخدمة، ومعلومات الطلب (نوع الخدمة، رقم اللوحة، إلخ).',
            ),
            _buildSection(
              '2. استخدام البيانات',
              'نستخدم البيانات لتقديم الخدمة، التواصل معك بخصوص الطلبات، وتحسين التطبيق. لا نبيع بياناتك الشخصية لأطراف ثالثة لأغراض تسويقية.',
            ),
            _buildSection(
              '3. مشاركة البيانات',
              'قد نشارك البيانات مع مقدمي الخدمة (مثل الفنيين) فقط بما يلزم لتنفيذ الطلب. قد نكشف عن بيانات إذا طُلب منا ذلك قانونياً.',
            ),
            _buildSection(
              '4. الأمان',
              'نحرص على حماية بياناتك عبر إجراءات تقنية ومنظمية مناسبة. الاتصال بالتطبيق يستخدم بروتوكولات آمنة حيثما أمكن.',
            ),
            _buildSection(
              '5. حقوقك',
              'يمكنك طلب الوصول إلى بياناتك أو تصحيحها أو حذفها عبر التواصل معنا من خلال التطبيق.',
            ),
            _buildSection(
              '6. التحديثات',
              'قد نحدّث سياسة الخصوصية من وقت لآخر. سنعلمك بأي تغيير جوهري عبر التطبيق أو البريد.',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

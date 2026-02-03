import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// شاشة الأحكام والشروط (شروط الاستخدام).
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = const Color(AppConstants.primaryColorValue);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        title: const Text(
          'الأحكام والشروط',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'شروط استخدام تطبيق ورشة SHM',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              '1. القبول',
              'باستخدامك تطبيق ورشة SHM فإنك توافق على هذه الأحكام والشروط. إذا كنت لا توافق عليها، يرجى عدم استخدام التطبيق.',
            ),
            _buildSection(
              '2. الخدمة',
              'التطبيق يوفّر طلب خدمات صيانة السيارات (بنشر، بطارية، مفتاح، إلخ) في الموقع الذي تحدّده. الخدمة الفعلية يقدّمها فنيون معتمدون وفقاً لمعايير ورشة SHM.',
            ),
            _buildSection(
              '3. الحساب والاستخدام',
              'أنت مسؤول عن حفظ بيانات الدخول وعدم مشاركتها. يُمنع استخدام التطبيق لأي غرض غير قانوني أو مخالف لهذه الشروط.',
            ),
            _buildSection(
              '4. الطلبات والدفع',
              'الأسعار المعروضة في التطبيق قد تتغير حسب نوع الخدمة والموقع. الدفع يتم وفق الطرق المتاحة في التطبيق أو عند الاستلام كما يُحدد عند الطلب.',
            ),
            _buildSection(
              '5. إلغاء الطلبات',
              'يمكنك إلغاء الطلب وفق السياسة المعروضة في التطبيق. قد تُطبّق رسوم إلغاء في حالات معينة.',
            ),
            _buildSection(
              '6. الخصوصية',
              'جمع واستخدام بياناتك يخضع لسياسة الخصوصية الخاصة بنا. ننصحك بقراءتها.',
            ),
            _buildSection(
              '7. التعديلات',
              'نحتفظ بحق تعديل هذه الأحكام في أي وقت. استمرار استخدامك للتطبيق بعد التعديل يعني موافقتك على النسخة المحدّثة.',
            ),
            _buildSection(
              '8. التواصل',
              'لأي استفسار حول هذه الشروط يمكنك التواصل معنا عبر قائمة "تواصل معنا" في التطبيق.',
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

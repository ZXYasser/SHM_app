import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// سياسة الاسترجاع — ورشة سهم.
class ReturnsPolicyScreen extends StatelessWidget {
  const ReturnsPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = const Color(AppConstants.primaryColorValue);
    final contactText = _buildContactText();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        title: const Text(
          'سياسة الاسترجاع',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ورشة سهم – خدمة ورشة سيارات متنقلة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'آخر تحديث: 2026-02',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            _buildSection(
              '1) نطاق السياسة',
              'تنطبق هذه السياسة على جميع المدفوعات التي تتم عبر تطبيق ورشة سهم باستخدام وسائل الدفع الإلكترونية المتاحة داخل التطبيق.',
            ),
            _buildSection(
              '2) الحالات التي يمكن فيها الاسترجاع',
              'يجوز طلب استرجاع المبلغ في الحالات التالية:\n'
              '• تم تحصيل مبلغ دون تنفيذ الخدمة.\n'
              '• تم خصم مبلغ مكرر بالخطأ.\n'
              '• تعذر تنفيذ الخدمة من طرف ورشة سهم بعد الدفع.\n'
              '• وجود خطأ واضح في احتساب السعر.',
            ),
            _buildSection(
              '3) الحالات التي لا يشملها الاسترجاع',
              'لا يتم استرجاع المبلغ في الحالات التالية:\n'
              '• تم تنفيذ الخدمة بالكامل وفق الطلب.\n'
              '• تم إلغاء الطلب بعد تحرك الفني ووصوله للموقع.\n'
              '• تأخر العميل أو تعذر الوصول إليه في الموقع المحدد.\n'
              '• سوء استخدام الخدمة أو تقديم معلومات غير صحيحة.',
            ),
            _buildSection(
              '4) آلية طلب الاسترجاع',
              'يمكن تقديم طلب الاسترجاع خلال مدة أقصاها 48 ساعة من وقت تنفيذ أو إلغاء الطلب عبر:\n\n'
              '$contactText\n\n'
              'يجب تزويدنا برقم الطلب وتفاصيل المشكلة.',
            ),
            _buildSection(
              '5) مدة معالجة الاسترجاع',
              'يتم مراجعة الطلب خلال 3–7 أيام عمل.\n\n'
              'في حال الموافقة، يتم إعادة المبلغ إلى نفس وسيلة الدفع المستخدمة.\n\n'
              'قد تستغرق البنوك من 5–14 يوم عمل لإظهار المبلغ في حسابك حسب سياسة الجهة المالية.',
            ),
            _buildSection(
              '6) أحكام عامة',
              'تحتفظ ورشة سهم بحق رفض طلب الاسترجاع إذا تبين إساءة استخدام الخدمة.\n\n'
              'أي استرجاع يتم وفق الأنظمة المعمول بها في المملكة العربية السعودية.',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static String _buildContactText() {
    final hasEmail = AppConstants.supportEmail.isNotEmpty;
    final hasPhone = AppConstants.supportPhone.isNotEmpty;
    if (hasEmail || hasPhone) {
      final parts = <String>[];
      if (hasEmail) parts.add('البريد: ${AppConstants.supportEmail}');
      if (hasPhone) parts.add('رقم التواصل: ${AppConstants.supportPhone}');
      return parts.join('\n');
    }
    return 'عبر قائمة «تواصل معنا» في التطبيق (اذكر رقم الطلب وتفاصيل المشكلة).';
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

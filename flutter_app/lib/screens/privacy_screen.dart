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
              'تطبيق ورشة SHM يقدّم خدمة ورشة سيارات متنقلة (نوصلك للحل). نجمّع فقط ما نحتاجه لتشغيل الخدمة ولا نبيع بياناتك لأي طرف.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.7,
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              'ما البيانات التي نجمعها؟',
              'عند تسجيل الدخول: البريد الإلكتروني أو تسجيل كضيف.\nعند طلب الخدمة: موقعك (إحداثيات GPS) حتى يصل الفني إليك، ونوع الخدمة، موديل السيارة، رقم اللوحة، وملاحظاتك. نستخدم أيضاً معرف المستخدم من نظام تسجيل الدخول لربط الطلبات بحسابك.',
            ),
            _buildSection(
              'لماذا نستخدمها؟',
              'لتوصيل طلبك للفني، التواصل معك بخصوص الطلب، وتحسين التطبيق. لا نبيع بياناتك الشخصية ولا نستخدمها للإعلان لجهات ثالثة.',
            ),
            _buildSection(
              'هل نشارك البيانات مع غيرنا؟',
              'نشارك مع الفنيين فقط ما يلزم لتنفيذ الطلب (مثل الموقع ونوع الخدمة). إذا طُلبت منا بيانات قانونياً نلتزم بالقانون.',
            ),
            _buildSection(
              'كيف نحمي بياناتك؟',
              'الاتصال بين التطبيق والخوادم يتم عبر بروتوكولات آمنة. نحرص على إجراءات مناسبة لحماية البيانات.',
            ),
            _buildSection(
              'ما حقوقك؟',
              'يمكنك طلب الاطلاع على بياناتك أو تصحيحها أو حذفها عبر التواصل معنا من داخل التطبيق (تواصل معنا / القائمة).',
            ),
            _buildSection(
              'تحديث السياسة',
              'قد نعدّل هذه السياسة لاحقاً. سنخبرك بأي تغيير مهم عبر التطبيق أو البريد.',
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

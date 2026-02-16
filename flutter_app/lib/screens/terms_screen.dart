import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// الشروط والأحكام — ورشة سهم / خدمة ورشة سيارات متنقلة.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = const Color(AppConstants.primaryColorValue);
    final contactText = _buildContactText();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        title: const Text(
          'الشروط والأحكام',
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
              '1) قبول الشروط',
              'باستخدامك لتطبيق/موقع ورشة سهم فإنك توافق على هذه الشروط والأحكام. إذا لم توافق، يرجى عدم استخدام الخدمة.\n'
              'يحق لنا تحديث هذه الشروط من وقت لآخر، ويُعد استمرار استخدامك للخدمة بعد التحديث موافقة على النسخة المحدّثة.',
            ),
            _buildSection(
              '2) التعريفات',
              'أنت / المستخدم: الشخص الذي يستخدم التطبيق أو يطلب خدمة.\n\n'
              'نحن / ورشة سهم: الجهة المالكة للتطبيق والمشغلة للخدمة.\n\n'
              'الخدمة: خدمات الورشة المتنقلة (مثل بطارية، إطارات، فتح/إقفال، تشخيص، سحب… إلخ).\n\n'
              'الفني: موظف تابع لـ ورشة سهم يقوم بتنفيذ الخدمة ميدانيًا.',
            ),
            _buildSection(
              '3) الأهلية وإنشاء الحساب',
              'يجب أن يكون عمرك 18 سنة فأكثر أو لديك موافقة ولي الأمر.\n\n'
              'يجب تزويدنا بمعلومات صحيحة ودقيقة عند التسجيل وطلب الخدمة.\n\n'
              'أنت مسؤول عن الحفاظ على سرية بيانات الدخول وأي استخدام يتم عبر حسابك يعد صادرًا منك.',
            ),
            _buildSection(
              '4) طلب الخدمة وتنفيذها',
              'يتطلب تقديم الخدمة تزويدنا بمعلومات مثل: رقم الجوال، الموقع، نوع المركبة، ووصف المشكلة.\n\n'
              'أنت مسؤول عن تحديد موقع صحيح وتمكين الفني من الوصول بأمان للموقع.\n\n'
              'قد تختلف مدة الوصول حسب الموقع والازدحام وتوفر الفنيين والظروف التشغيلية.',
            ),
            _buildSection(
              '5) الأسعار والدفع',
              'تظهر الأسعار داخل التطبيق قبل تأكيد الطلب، وقد تختلف حسب المنطقة/المسافة/وقت الطلب/نوع الخدمة.\n\n'
              'يتم الدفع عبر وسائل الدفع المتاحة داخل التطبيق.\n\n'
              'في حال احتاجت الخدمة تكلفة إضافية بعد المعاينة (مثل اكتشاف عطل مختلف)، سيتم إبلاغك وأخذ موافقتك قبل تنفيذ أي عمل إضافي.\n\n'
              'مهم: لا نقوم بتخزين بيانات بطاقتك البنكية؛ تتم معالجة المدفوعات عبر مزودي دفع إلكتروني معتمدين وآمنين.',
            ),
            _buildSection(
              '6) الإلغاء والرسوم',
              'يمكنك إلغاء الطلب قبل بدء التنفيذ وفق سياسة الإلغاء داخل التطبيق.\n\n'
              'في حال تم الإلغاء بعد تأكيد الطلب وبدء تجهيز/تحرك الفني، قد تُفرض رسوم إلغاء لتغطية تكاليف التشغيل.\n\n'
              'الرسوم الافتراضية (قابلة للتعديل): إذا تم إلغاء الطلب بعد بدء التنفيذ ومرور 5 دقائق من تأكيده، تُفرض رسوم 25 ريال سعودي.',
            ),
            _buildSection(
              '7) التزامات المستخدم',
              'يلتزم المستخدم بما يلي:\n'
              '• عدم إساءة استخدام التطبيق أو التسبب بأذى/مضايقة لأي شخص.\n'
              '• عدم استخدام الخدمة لأغراض غير قانونية.\n'
              '• تقديم معلومات صحيحة عن المركبة والموقع.\n'
              '• الالتزام بإرشادات السلامة أثناء تقديم الخدمة (مثل الوقوف بمكان آمن إن أمكن).',
            ),
            _buildSection(
              '8) حدود المسؤولية',
              'نبذل جهودًا معقولة لضمان جودة واستمرارية الخدمة، إلا أن الخدمة قد تتأثر بعوامل خارجة عن السيطرة مثل انقطاع الشبكات أو الأحوال الجوية أو الحوادث أو الظروف التشغيلية.\n\n'
              'لا نتحمل أي مسؤولية عن خسائر غير مباشرة أو تبعية (مثل فقدان وقت أو أرباح) ناتجة عن تأخر أو تعذر تقديم الخدمة لسبب خارج عن إرادتنا.\n\n'
              'أقصى مسؤولية مباشرة علينا—إن وجدت—تقتصر على قيمة الخدمة المدفوعة محل النزاع، وذلك وفق الأنظمة المعمول بها.',
            ),
            _buildSection(
              '9) الملكية الفكرية',
              'جميع الحقوق المتعلقة بالتطبيق والموقع (العلامة، المحتوى، التصميم، البرمجيات) مملوكة لـ ورشة سهم. لا يجوز نسخها أو إعادة استخدامها لأغراض تجارية دون إذن مكتوب.',
            ),
            _buildSection(
              '10) الخصوصية',
              'يخضع جمع واستخدام البيانات لـ سياسة الخصوصية الخاصة بورشة سهم، وتُعد جزءًا لا يتجزأ من هذه الشروط.',
            ),
            _buildSection(
              '11) تعليق أو إنهاء الحساب',
              'يحق لنا تعليق أو إنهاء حسابك أو رفض تقديم الخدمة في حال:\n'
              'مخالفة هذه الشروط، إساءة استخدام التطبيق، تقديم معلومات مضللة، أو أي سلوك قد يعرّض السلامة أو النظام التشغيلي للخطر.',
            ),
            _buildSection(
              '12) القانون والاختصاص',
              'تخضع هذه الشروط للأنظمة المعمول بها في المملكة العربية السعودية، وتكون المحاكم المختصة في المملكة هي المرجع في حال حدوث نزاع (ما لم ينص النظام على خلاف ذلك).',
            ),
            _buildSection(
              '13) التواصل',
              contactText,
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
    final hasWeb = AppConstants.supportWebsite.isNotEmpty;
    if (hasEmail || hasPhone || hasWeb) {
      final parts = <String>['للاستفسارات أو الشكاوى:'];
      if (hasEmail) parts.add('البريد: ${AppConstants.supportEmail}');
      if (hasPhone) parts.add('رقم التواصل: ${AppConstants.supportPhone}');
      if (hasWeb) parts.add('الموقع: ${AppConstants.supportWebsite}');
      return parts.join('\n');
    }
    return 'للاستفسارات أو الشكاوى: عبر قائمة «تواصل معنا» في التطبيق.';
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

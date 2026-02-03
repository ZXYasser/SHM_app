import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = const Color(AppConstants.primaryColorValue);

    final List<Map<String, dynamic>> faqs = [
      {
        'question': 'كيف أطلب خدمة؟',
        'answer':
            'يمكنك طلب الخدمة من خلال اختيار نوع الخدمة المطلوبة من الصفحة الرئيسية، ثم ملء البيانات المطلوبة وإرسال الطلب.',
      },
      {
        'question': 'كم يستغرق وصول الفني؟',
        'answer':
            'عادة ما يصل الفني خلال 30-60 دقيقة من وقت إرسال الطلب، حسب موقعك ومدى ازدحام الطرق.',
      },
      {
        'question': 'ما هي طرق الدفع المتاحة؟',
        'answer':
            'نقبل الدفع نقداً عند الاستلام، أو من خلال البطاقات الائتمانية ومدى المحفوظة في حسابك.',
      },
      {
        'question': 'هل يمكنني تتبع حالة طلبي؟',
        'answer': 'نعم، يمكنك تتبع حالة طلبك من خلال صفحة "طلباتي" في التطبيق.',
      },
      {
        'question': 'ماذا أفعل إذا لم يصل الفني؟',
        'answer': 'يمكنك التواصل معنا من خلال قائمة "تواصل معنا" في التطبيق.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        title: const Text(
          'مركز المساعدة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.support_agent, size: 60, color: color),
                    const SizedBox(height: 16),
                    const Text(
                      'اتصل بنا',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'نحن هنا لمساعدتك',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Implement phone call
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ميزة الاتصال قيد التطوير'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.phone),
                            label: const Text('اتصال'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Implement WhatsApp
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ميزة واتساب قيد التطوير'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat),
                            label: const Text('واتساب'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: color,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // FAQ Section
            const Text(
              'أسئلة شائعة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...faqs.asMap().entries.map((entry) {
              return _buildFAQCard(context, entry.value, entry.key, color);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard(
    BuildContext context,
    Map<String, dynamic> faq,
    int index,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.help_outline, color: color, size: 20),
        ),
        title: Text(
          faq['question'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              faq['answer'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

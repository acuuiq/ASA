import 'package:flutter/material.dart';

class SystemSupervisorWasteScreen extends StatelessWidget {
  final Color _primaryColor = const Color(0xFF4CAF50);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF212121);

  const SystemSupervisorWasteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'معلومات شاشة النفايات للمواطن',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات عامة عن قسم النفايات
            _buildSectionTitle('معلومات عامة عن قسم النفايات'),
            _buildInfoCard(
              icon: Icons.info,
              title: 'الخدمات المتاحة',
              items: [
                'دفع الرسوم - مع خصم الدفع المبكر',
                'أمر طارئ - لحالات الطوارئ',
                'جدول النظافة - مواعيد جمع النفايات',
                'الإبلاغ عن مشكلة - بلاغات الأعطال',
                'معلومات الفواتير - تفاصيل الفواتير والرسوم',
                'الهدايا والعروض - المكافآت والعروض الترويجية',
                'خدمات مميزة - خدمات إضافية مدفوعة'
              ],
            ),

            const SizedBox(height: 20),

            // تفاصيل الخدمات الرئيسية
            _buildSectionTitle('تفاصيل الخدمات الرئيسية'),
            
            _buildServiceDetailCard(
              serviceName: 'دفع الرسوم',
              description: 'المواطن يمكنه دفع رسوم خدمة النفايات',
              features: [
                'خصم 10% للدفع المبكر',
                'تجنب رسوم التأخير',
                'كسب نقاط مكافآت',
                'مشاركة في السحب على الجوائز'
              ],
              color: const Color(0xFF4CAF50),
            ),

            _buildServiceDetailCard(
              serviceName: 'أمر طارئ',
              description: 'لحالات الطوارئ المتعلقة بخدمة النفايات',
              features: [
                'بلاغات عربات النفايات',
                'مشاكل جمع النفايات',
                'حالات طارئة في أوقات غير الاعتيادية',
                'استجابة سريعة للشكاوى'
              ],
              color: const Color(0xFFFF9800),
            ),

            _buildServiceDetailCard(
              serviceName: 'جدول النظافة',
              description: 'مواعيد جمع النفايات حسب المناطق',
              features: [
                'جداول أسبوعية',
                'مواعيد ثابتة',
                'إشعارات بالتغييرات',
                'أحياء متعددة'
              ],
              color: const Color(0xFF2196F3),
            ),

            _buildServiceDetailCard(
              serviceName: 'الإبلاغ عن مشكلة',
              description: 'نظام بلاغات لأعطال خدمة النفايات',
              features: [
                'بلاغات عن عربات النفايات',
                'مشاكل في أوقات الجمع',
                'تقارير عن مناطق متأخرة',
                'متابعة حالة البلاغ'
              ],
              color: const Color(0xFFF44336),
            ),

            const SizedBox(height: 20),

            // معلومات الفواتير والرسوم
            _buildSectionTitle('معلومات الفواتير والرسوم'),
            _buildBillingInfoCard(),

            const SizedBox(height: 20),

            // نظام المكافآت والعروض
            _buildSectionTitle('نظام المكافآت والعروض'),
            _buildRewardsInfoCard(),

            const SizedBox(height: 20),

            // الخدمات المميزة
            _buildSectionTitle('الخدمات المميزة'),
            _buildPremiumServicesCard(),

            const SizedBox(height: 20),

            // البيانات التي يراها المواطن
            _buildSectionTitle('البيانات المعروضة للمواطن'),
            _buildUserDataCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<String> items,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: _primaryColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) => _buildListItem(item)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDetailCard({
    required String serviceName,
    required String description,
    required List<String> features,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.eco, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    serviceName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: _textColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature) => _buildFeatureItem(feature)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingInfoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تفاصيل نظام الفواتير',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildBillingItem('الدفع المبكر', 'خصم 10% + نقاط إضافية'),
            _buildBillingItem('الدفع في الموعد', 'تجنب رسوم التأخير'),
            _buildBillingItem('ضريبة التأخير', '5% من قيمة الفاتورة'),
            _buildBillingItem('انقطاع الخدمة', 'بعد 30 يوم من عدم الدفع'),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardsInfoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'نظام المكافآت والعروض',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildRewardItem('نقاط المكافآت', 'مع كل دفعة ناجحة'),
            _buildRewardItem('خصم الدفع المبكر', '10% على الرسوم'),
            _buildRewardItem('السحب على الجوائز', 'للمستخدمين الملتزمين'),
            _buildRewardItem('برنامج الولاء', 'مزايا للعملاء الدائمين'),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumServicesCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الخدمات المميزة المدفوعة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildPremiumItem('خدمات جمع إضافية', 'أيام إضافية'),
            _buildPremiumItem('جمع نفايات خاصة', 'نفايات طبية/صناعية'),
            _buildPremiumItem('تقارير استهلاك', 'تحليلات مفصلة'),
            _buildPremiumItem('دعم متميز', 'أولوية في الخدمة'),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDataCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'البيانات التي يراها المواطن',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDataItem('الاستهلاك اليومي', 'إحصائيات الاستهلاك'),
            _buildDataItem('الفواتير', 'الفواتير والرسوم'),
            _buildDataItem('جدول النظافة', 'مواعيد الجمع'),
            _buildDataItem('النقاط', 'رصيد نقاط المكافآت'),
            _buildDataItem('الإشعارات', 'تنبيهات ورسائل'),
            _buildDataItem('الأحداث', 'فعاليات وصيانة'),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: _textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, size: 18, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: _textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.star, size: 18, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: _textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.data_usage, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: _textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
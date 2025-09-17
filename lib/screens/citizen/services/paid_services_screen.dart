import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'payment_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaidServicesScreen extends StatefulWidget {
  static const String screenRoute = '/paid-services';

  final String serviceName;
  final Color serviceColor;
  final List<Color> serviceGradient;
  final String serviceTitle;

  const PaidServicesScreen({
    super.key,
    required this.serviceName,
    required this.serviceColor,
    required this.serviceGradient,
    required this.serviceTitle,
  });

  @override
  State<PaidServicesScreen> createState() => _PaidServicesScreenState();
}

// أضف هذا في بداية الملف بعد الاستيرادات
class ServiceItem {
  final String id;
  final String name;
  final double amount;
  final Color color;
  final List<Color> gradient;
  final String? additionalInfo;

  ServiceItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.color,
    required this.gradient,
    this.additionalInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'color': color.value.toString(),
      'gradient': gradient.map((c) => c.value.toString()).toList(),
      'additionalInfo': additionalInfo,
    };
  }
}

class _PaidServicesScreenState extends State<PaidServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: widget.serviceColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.serviceGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.serviceColor.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        title: Text(
          widget.serviceName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            shadows: [
              Shadow(
                blurRadius: 2,
                color: Colors.black12,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    if (widget.serviceName.contains('خدمات جانبية مدفوعة') ||
        widget.serviceName.contains('خدمات مميزة')) {
      return _buildPaidServicesContent();
    } else {
      return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 3,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: widget.serviceColor,
              size: 50,
            ),
            const SizedBox(height: 15),
            const Text(
              'تفاصيل الخدمة ستظهر هنا مع إمكانية تنفيذ الإجراء المطلوب مباشرة',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: widget.serviceColor,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildPaidServicesContent() {
    if (widget.serviceTitle.contains('الكهرباء')) {
      return _buildElectricityPaidServices();
    } else if (widget.serviceTitle.contains('الماء')) {
      return _buildWaterPaidServices();
    } else if (widget.serviceTitle.contains('النفايات')) {
      return _buildWastePaidServices();
    } else {
      return _buildDefaultPaidServices();
    }
  }

  Widget _buildElectricityPaidServices() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _buildSectionTitle('الخدمات المدفوعة - الكهرباء'),
      const SizedBox(height: 16),
      _buildPaidServiceCard(
        title: 'تركيب عدادات ذكية',
        description: 'تركيب عداد كهرباء ذكي لمراقبة الاستهلاك بدقة',
        detailedDescription:
            'تشمل هذه الخدمة تركيب عداد ذكي متصل بتطبيق الهاتف، تقارير استهلاك يومية، تنبيهات عند تجاوز الحدود، وإمكانية التحكم عن بعد. المعدات معتمدة وموثوقة مع ضمان لمدة سنتين.',
        price: '150 د.ع',
        duration: '2-4 ساعات',
        icon: Icons.electrical_services,
        gradient: [
          const Color(0xFF0D47A1),
          const Color(0xFF1976D2),
        ], // أزرق حكومي
      ),
      _buildPaidServiceCard(
        title: 'فحص وصيانة لوحة الكهرباء',
        description: 'فحص شامل للوحة الكهرباء الرئيسية وإصلاح الأعطال',
        detailedDescription:
            'تشمل الخدمة فحصاً شاملاً للوحة الكهرباء، اختبار القواطع، فحص التوصيلات، تنظيف المكونات، واستبدال الأجزاء التالفة. يشمل التقرير النهائي توصيات للسلامة الكهربائية.',
        price: '200 د.ع',
        duration: '3-5 ساعات',
        icon: Icons.construction,
          gradient: [
          const Color(0xFF0D47A1),
          const Color(0xFF1976D2),
        ], // أزرق حكومي
      ),
      _buildPaidServiceCard(
        title: 'تمديدات كهربائية إضافية',
        description: 'تركيب نقاط كهرباء إضافية في المنزل',
        detailedDescription:
            'خدمة تركيب نقاط كهرباء جديدة حسب احتياجاتك، مع استخدام أسلاك ومعايير السلامة المطلوبة. تشمل الخدمة التخطيط، التمديد، والتركيب النهائي مع اختبار كل نقطة.',
        price: '80 د.ع',
        duration: 'حسب الطلب',
        icon: Icons.extension,
        gradient: [
          const Color(0xFF0D47A1),
          const Color(0xFF1976D2),
        ], // أزرق حكومي
      ),
      _buildPaidServiceCard(
        title: 'تركيب أنظمة الطاقة الشمسية',
        description: 'تركيب نظام طاقة شمسية متكامل للمنازل',
        detailedDescription:
            'تشمل الخدمة دراسة الجدوى، تصميم النظام، تركيب الألواح الشمسية، الأنفيرتر، البطاريات، ونظام المراقبة. نوفر أنظمة متكاملة بضمان يصل إلى 25 سنة للألواح و5 سنوات للمكونات الإلكترونية.',
        price: 'يبدأ من 5000 د.ع',
        duration: '1-3 أيام',
        icon: Icons.solar_power,
     gradient: [
          const Color(0xFF0D47A1),
          const Color(0xFF1976D2),
        ], // أزرق حكومي
      ),
      _buildCustomServiceCard(),
    ],
  );
}

  Widget _buildWaterPaidServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('الخدمات المدفوعة - الماء'),
        const SizedBox(height: 16),
        _buildPaidServiceCard(
          title: 'تركيب عداد مياه إضافي',
          description: 'تركيب عداد مياه جديد للمنزل أو المزرعة',
          detailedDescription:
              'خدمة تركيب عداد مياه جديد مع توصيله بشبكة المياه الرئيسية. تشمل الخدمة الحصول على التصاريح اللازمة، الحفر، التركيب، والاختبار النهائي. العداد معتمد من الجهات الرسمية.',
          price: '250 د.ع',
          duration: '2-3 ساعات',
          icon: Icons.water_damage,
          gradient: [
            const Color(0xFF29B6F6),
            const Color(0xFF4FC3F7),
          ], // أزرق فاتح متدرج
        ),
        _buildPaidServiceCard(
          title: 'كشف تسربات المياه',
          description: 'فحص دقيق لكشف تسربات المياه باستخدام أحدث الأجهزة',
          detailedDescription:
              'نستخدم أحدث أجهزة كشف التسربات بالموجات الصوتية وكاميرات التصوير الحراري لتحديد مكان التسرب بدقة دون الحاجة إلى تكسير. تشمل الخدمة تقريراً مفصلاً عن مكان التسرب وطريقة الإصلاح المناسبة.',
          price: '150 د.ع',
          duration: '1-2 ساعة',
          icon: Icons.search,
          gradient: [
            const Color(0xFF29B6F6),
            const Color(0xFF4FC3F7),
          ], // أزرق فاتح متدرج
        ),
        _buildPaidServiceCard(
          title: 'تنظيف خزانات المياه',
          description: 'تنظيف وتعقيم خزانات المياه المنزلية',
          detailedDescription:
              'خدمة متكاملة لتنظيف وتعقيم خزانات المياه باستخدام معدات متخصصة ومواد معتمدة للتعقيم. تشمل الخدمة تفريغ الخزان، إزالة الرواسب، التنظيف بالفرشاة والضغط العالي، والتعقيم النهائي.',
          price: '300 د.ع',
          duration: '2-4 ساعات',
          icon: Icons.cleaning_services,
          gradient: [
            const Color(0xFF29B6F6),
            const Color(0xFF4FC3F7),
          ], // أزرق فاتح متدرج
        ),
        _buildPaidServiceCard(
          title: 'تركيب أنظمة الري الذكية',
          description: 'تصميم وتركيب أنظمة ري ذكية للمساحات الخضراء',
          detailedDescription:
              'نصمم وننفذ أنظمة ري ذكية تتكيف مع طبيعة النباتات والظروف الجوية. تشمل الخدمة تركيب حساسات رطوبة، أنظمة توقيت، مراقبة عن بعد، وتقارير استهلاك المياه. توفر حتى 40% من استهلاك المياه.',
          price: 'يبدأ من 1000 د.ع',
          duration: '1-2 يوم',
          icon: Icons.grass,
          gradient: [
            const Color(0xFF29B6F6),
            const Color(0xFF4FC3F7),
          ], // أزرق فاتح متدرج
        ),
        _buildCustomServiceCard(),
      ],
    );
  }

  Widget _buildWastePaidServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('الخدمات المدفوعة - النفايات'),
        const SizedBox(height: 16),
        _buildPaidServiceCard(
          title: 'إزالة نفايات البناء',
          description: 'إزالة نفايات البناء والهدم من الموقع',
          detailedDescription:
              'خدمة إزالة نفايات البناء باستخدام شاحنات مجهزة وسائقين مدربين. نوفر حاويات خاصة لنفايات البناء وننقلها إلى مواقع الطمر الصحي المعتمدة. نقدم شهادة التخلص الآمن من النفايات.',
          price: '500 د.ع/طن',
          duration: 'حسب الكمية',
          icon: Icons.construction,
          gradient: [
            const Color(0xFF388E3C),
            const Color(0xFF4CAF50),
          ], // أخضر متدرج
        ),
        _buildPaidServiceCard(
          title: 'تركيب حاويات نفايات كبيرة',
          description: 'توفير حاويات نفايات بسعات مختلفة للإيجار الشهري',
          detailedDescription:
              'نوفر حاويات نفايات بسعات مختلفة (1-10 أمتار مكعبة) للإيجار الشهري. تشمل الخدمة التوصيل، الاستبدال الدوري، والصيانة. الحاويات مصنوعة من مواد متينة ومقاومة للعوامل الجوية.',
          price: '200 د.ع/شهر',
          duration: 'عقد سنوي',
          icon: Icons.delete_outline,
          gradient: [
            const Color(0xFF388E3C),
            const Color(0xFF4CAF50),
          ], // أخضر متدرج
        ),
        _buildPaidServiceCard(
          title: 'تدوير النفايات المنزلية',
          description: 'خدمة فصل وإعادة تدوير النفايات المنزلية',
          detailedDescription:
              'خدمة أسبوعية لجمع النفايات القابلة للتدوير (بلاستيك، ورق، معدن، زجاج) من المنزل. نوفر حاويات فصل النفايات ونقوم بنقلها إلى مراكز التدوير المعتمدة. نسلم تقريراً دورياً عن كمية النفايات المعاد تدويرها.',
          price: '100 د.ع/شهر',
          duration: 'زيارة أسبوعية',
          icon: Icons.recycling,
          gradient: [
            const Color(0xFF388E3C),
            const Color(0xFF4CAF50),
          ], // أخضر متدرج
        ),
        _buildPaidServiceCard(
          title: 'تنظيف مواقع الأحداث',
          description: 'خدمة تنظيف كاملة بعد المناسبات والأحداث',
          detailedDescription:
              'خدمة متكاملة لتنظيف مواقع الأحداث والمناسبات. تشمل جمع النفايات، تنظيف الأرضيات، تنظيف المرافق، وإعادة المكان إلى حالته الأصلية. نعمل وفق بروتوكولات النظافة والصحة العامة.',
          price: 'يبدأ من 800 د.ع',
          duration: 'حسب المساحة',
          icon: Icons.event,
          gradient: [
            const Color(0xFF388E3C),
            const Color(0xFF4CAF50),
          ], // أخضر متدرج
        ),
        _buildCustomServiceCard(),
      ],
    );
  }

  Widget _buildDefaultPaidServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('الخدمات المدفوعة'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.credit_card, color: widget.serviceColor, size: 50),
              const SizedBox(height: 15),
              const Text(
                'الخدمات المدفوعة المتاحة تختلف حسب نوع الخدمة. الرجاء اختيار خدمة محددة لعرض الخيارات المتاحة.',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        _buildCustomServiceCard(),
      ],
    );
  }

  Widget _buildCustomServiceCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16, top: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.withOpacity(0.3)),
                  ),
                  child: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.purple,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'طلب خدمة مخصصة (دفع نقدي)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.purple,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'إذا لم تجد الخدمة التي تبحث عنها، يمكنك طلب خدمة مخصصة وإرفاق صور للعمل المطلوب والاستفسار عن السعر',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _showCustomServiceDialog(),
              child: const Text(
                'طلب خدمة مخصصة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaidServiceCard({
    required String title,
    required String description,
    required String detailedDescription,
    required String price,
    required String duration,
    required IconData icon,
    required List<Color> gradient,
  }) {
    // استخدام اللون الأول في التدرج كلون أساسي
    final Color primaryColor = gradient.first;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: Icon(icon, color: primaryColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                _showServiceDetailsDialog(title, detailedDescription);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'عرض التفاصيل الكاملة',
                    style: TextStyle(color: primaryColor, fontSize: 14),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.info_outline, color: primaryColor, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _showPaymentOptions(title, price),
                  child: const Text(
                    'طلب الخدمة',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                    Text(duration, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceDetailsDialog(String title, String details) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  details,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.serviceColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'موافق',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
void _showPaymentOptions(String serviceName, String price) {
  // تحويل السعر من نص إلى رقم
  double _getServicePrice(String serviceName) {
    final Map<String, double> servicePrices = {
      'تركيب عدادات ذكية': 150.0,
      'فحص وصيانة لوحة الكهرباء': 200.0,
      'تمديدات كهربائية إضافية': 80.0,
      'تركيب أنظمة الطاقة الشمسية': 5000.0,
      'تركيب عداد مياه إضافي': 250.0,
      'كشف تسربات المياه': 150.0,
      'تنظيف خزانات المياه': 300.0,
      'تركيب أنظمة الري الذكية': 1000.0,
      'إزالة نفايات البناء': 500.0,
      'تركيب حاويات نفايات كبيرة': 200.0,
      'تدوير النفايات المنزلية': 100.0,
      'تنظيف مواقع الأحداث': 800.0,
    };

    return servicePrices[serviceName] ?? 100.0;
  }
  
  // الحصول على سعر الخدمة
  double amount = _getServicePrice(serviceName);
  
  // إنشاء ServiceItem للخدمة المختارة
  ServiceItem serviceItem = ServiceItem(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: serviceName,
    amount: amount,
    color: widget.serviceColor,
    gradient: widget.serviceGradient,
    additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
  );

  // عرض صفحة اختيار طريقة الدفع
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.serviceColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.payment, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'اختر طريقة الدفع',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: PaymentMethodsDialog(
              services: [],
              primaryColor: widget.serviceColor,
              primaryGradient: widget.serviceGradient,
              finalAmount: amount,
              usePoints: false,
              pointsDiscount: 0.0,
              onPaymentSuccess: () {
                Navigator.pop(context);
                _showPaymentSuccessDialog(serviceName, price);
              },
            ),
          ),
        ],
      ),
    ),
  );
}
void _showPaymentSuccessDialog(String serviceName, String price) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 20),
              const Text(
                'تم الدفع بنجاح!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'تم دفع $price لخدمة $serviceName',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.serviceColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'حسناً',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
  void _showCashPaymentConfirmation(String serviceName, String price) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 50),
                const SizedBox(height: 16),
                Text(
                  'تم طلب خدمة: $serviceName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'السعر: $price',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'سيتم التواصل معك خلال 24 ساعة لتأكيد الموعد وموقع التنفيذ. الدفع نقداً عند استلام الخدمة.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'موافق',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToPaymentScreen(
    String serviceName,
    String price,
    String paymentMethod,
  ) {
    // تحويل السعر من نص إلى رقم
   
  }

  void _showCustomServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomServiceDialog(serviceColor: widget.serviceColor);
      },
    );
  }
}

class CustomServiceDialog extends StatefulWidget {
  final Color serviceColor;

  const CustomServiceDialog({super.key, required this.serviceColor});

  @override
  State<CustomServiceDialog> createState() => _CustomServiceDialogState();
}

class _CustomServiceDialogState extends State<CustomServiceDialog> {
  final TextEditingController _serviceDetailsController =
      TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  List<XFile> _selectedImages = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submitRequest() {
    if (_serviceDetailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال تفاصيل الخدمة المطلوبة')),
      );
      return;
    }

    // هنا سيتم إرسال الطلب إلى الخادم
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم إرسال طلب الخدمة المخصصة بنجاح، سيتم التواصل معك قريباً',
        ),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'طلب خدمة مخصصة (دفع نقدي)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.serviceColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'وصف الخدمة المطلوبة:',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _serviceDetailsController,
                maxLines: 4,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'أدخل تفاصيل الخدمة التي تحتاجها...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'معلومات التواصل:',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _contactInfoController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'رقم الهاتف أو البريد الإلكتروني',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'موقع التنفيذ:',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _locationController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'أدخل عنوان موقع تنفيذ الخدمة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'إرفاق صور (اختياري):',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              if (_selectedImages.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(
                                  File(_selectedImages[index].path),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.grey[800],
                ),
                icon: const Icon(Icons.camera_alt),
                label: const Text('إضافة صورة'),
              ),
              const SizedBox(height: 20),
              const Text(
                'ملاحظة: سيتم التواصل معك خلال 24 ساعة لتأكيد تفاصيل الخدمة والسعر المناسب.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.serviceColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'إرسال الطلب',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
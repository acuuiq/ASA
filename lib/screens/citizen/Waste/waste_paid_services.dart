import 'package:flutter/material.dart';

import '../Shared Services Citizen/paid_services_base.dart';
import '../services/payment_screen.dart' hide ServiceItem; // أخفِ ServiceItem من هذا الملف

class WastePaidServices extends PaidServicesScreen {
  const WastePaidServices({super.key})
    : super(
    serviceName: 'خدمات النفايات المدفوعة',
    serviceColor: const Color(0xFF388E3C),
    serviceGradient: const [
      Color(0xFF388E3C), // استخدم Color مباشرة مع hex
      Color(0xFF4CAF50),
    ],
    serviceTitle: 'النفايات',
  );


  @override
  State<WastePaidServices> createState() => _WastePaidServicesState();
}

class _WastePaidServicesState extends State<WastePaidServices> {
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
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 3,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                _buildTabItem('الخدمات المدفوعة', 0),
                _buildTabItem('الخدمات المطلوبة', 1),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child:
                      _buildWastePaidServices(), // تغيير اسم الدالة حسب الخدمة
                ),
                _buildRequestedServicesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _currentIndex = 0;

  Widget _buildTabItem(String title, int index) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? widget.serviceColor.withOpacity(0.1)
                : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? widget.serviceColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? widget.serviceColor : Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestedServicesTab() {
    return Container(child: Center(child: Text('قائمة الخدمات المطلوبة')));
  }

  void _requestService(ServiceItem service) {
    // تنفيذ طلب الخدمة
    print('طلب الخدمة: ${service.name}');
  }

  void _submitCustomRequest() {
    // تنفيذ طلب الخدمة المخصصة
    print('طلب خدمة مخصصة');
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
          gradient: [const Color(0xFF388E3C), const Color(0xFF4CAF50)],
        ),
        _buildPaidServiceCard(
          title: 'تركيب حاويات نفايات كبيرة',
          description: 'توفير حاويات نفايات بسعات مختلفة للإيجار الشهري',
          detailedDescription:
              'نوفر حاويات نفايات بسعات مختلفة (1-10 أمتار مكعبة) للإيجار الشهري. تشمل الخدمة التوصيل، الاستبدال الدوري، والصيانة. الحاويات مصنوعة من مواد متينة ومقاومة للعوامل الجوية.',
          price: '200 د.ع/شهر',
          duration: 'عقد سنوي',
          icon: Icons.delete_outline,
          gradient: [const Color(0xFF388E3C), const Color(0xFF4CAF50)],
        ),
        _buildPaidServiceCard(
          title: 'تدوير النفايات المنزلية',
          description: 'خدمة فصل وإعادة تدوير النفايات المنزلية',
          detailedDescription:
              'خدمة أسبوعية لجمع النفايات القابلة للتدوير (بلاستيك، ورق، معدن، زجاج) من المنزل. نوفر حاويات فصل النفايات ونقوم بنقلها إلى مراكز التدوير المعتمدة. نسلم تقريراً دورياً عن كمية النفايات المعاد تدويرها.',
          price: '100 د.ع/شهر',
          duration: 'زيارة أسبوعية',
          icon: Icons.recycling,
          gradient: [const Color(0xFF388E3C), const Color(0xFF4CAF50)],
        ),
        _buildPaidServiceCard(
          title: 'تنظيف مواقع الأحداث',
          description: 'خدمة تنظيف كاملة بعد المناسبات والأحداث',
          detailedDescription:
              'خدمة متكاملة لتنظيف مواقع الأحداث والمناسبات. تشمل جمع النفايات، تنظيف الأرضيات، تنظيف المرافق، وإعادة المكان إلى حالته الأصلية. نعمل وفق بروتوكولات النظافة والصحة العامة.',
          price: 'يبدأ من 800 د.ع',
          duration: 'حسب المساحة',
          icon: Icons.event,
          gradient: [const Color(0xFF388E3C), const Color(0xFF4CAF50)],
        ),
        _buildCustomServiceCard(),
      ],
    );
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

  Widget _buildPaidServiceCard({
    required String title,
    required String description,
    required String detailedDescription,
    required String price,
    required String duration,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _showServiceDetailsDialog(
          title: title,
          description: description,
          detailedDescription: detailedDescription,
          price: price,
          duration: duration,
          gradient: gradient,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                gradient[0].withOpacity(0.05),
                gradient[1].withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: gradient[0].withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: gradient[0].withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: gradient[0],
                          height: 1.3,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: gradient[0].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              duration,
                              style: TextStyle(
                                fontSize: 10,
                                color: gradient[0],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            price,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: gradient[0],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomServiceCard() {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF388E3C).withOpacity(0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF388E3C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFF388E3C).withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.design_services,
                      color: Color(0xFF388E3C),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'خدمة مخصصة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF388E3C),
                            height: 1.3,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'هل تحتاج إلى خدمة غير موجودة في القائمة؟',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF388E3C),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '• وصف الخدمة المطلوبة بدقة\n• تحديد الميزانية المتوقعة\n• الموقع والوقت المناسب\n• أي متطلبات خاصة',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Color(0xFF388E3C),
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF388E3C), // لون ثابت
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _submitCustomRequest, // استخدم الدالة المحلية
                  child: const Text(
                    'طلب خدمة مخصصة', // صحح النص
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showServiceDetailsDialog({
    required String title,
    required String description,
    required String detailedDescription,
    required String price,
    required String duration,
    required List<Color> gradient,
  }) {
    showDialog(
      context: context,
      builder: (context) => ServiceDetailsDialog(
        title: title,
        description: description,
        detailedDescription: detailedDescription,
        price: price,
        duration: duration,
        gradient: gradient,
        serviceColor: widget.serviceColor,
        onRequestService: () => _requestService(
          ServiceItem(
            id: 'service_${DateTime.now().millisecondsSinceEpoch}',
            name: title,
            amount: _extractPrice(price),
            color: gradient[0],
            gradient: gradient,
            additionalInfo: 'معلقة - في انتظار الموافقة',
          ),
        ),
      ),
    );
  }

  // أضف دالة استخراج السعر
  double _extractPrice(String priceText) {
    try {
      final numericText = priceText.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.parse(numericText);
    } catch (e) {
      return 0.0;
    }
  }
}

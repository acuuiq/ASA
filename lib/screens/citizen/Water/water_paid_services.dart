import 'package:flutter/material.dart';
import '../Shared Services Citizen/paid_services_base.dart';
import '../services/payment_screen.dart' hide ServiceItem; // أخفِ ServiceItem من هذا الملف

class WaterPaidServices extends PaidServicesScreen {
  const WaterPaidServices({super.key})
      : super(
          serviceName: 'خدمات المياه المدفوعة',
          serviceColor: const Color(0xFF29B6F6),
          serviceGradient: const [
            Color(0xFF29B6F6),
            Color(0xFF4FC3F7),
          ],
          serviceTitle: 'الماء',
        );

  @override
  State<WaterPaidServices> createState() => _WaterPaidServicesState();
}

class _WaterPaidServicesState extends State<WaterPaidServices> {
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
                  child: _buildWaterPaidServices(),
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
          gradient: const [Color(0xFF29B6F6), Color(0xFF4FC3F7)],
        ),
        _buildPaidServiceCard(
          title: 'كشف تسربات المياه',
          description: 'فحص دقيق لكشف تسربات المياه باستخدام أحدث الأجهزة',
          detailedDescription:
              'نستخدم أحدث أجهزة كشف التسربات بالموجات الصوتية وكاميرات التصوير الحراري لتحديد مكان التسرب بدقة دون الحاجة إلى تكسير. تشمل الخدمة تقريراً مفصلاً عن مكان التسرب وطريقة الإصلاح المناسبة.',
          price: '150 د.ع',
          duration: '1-2 ساعة',
          icon: Icons.search,
          gradient: const [Color(0xFF29B6F6), Color(0xFF4FC3F7)],
        ),
        _buildPaidServiceCard(
          title: 'تنظيف خزانات المياه',
          description: 'تنظيف وتعقيم خزانات المياه المنزلية',
          detailedDescription:
              'خدمة متكاملة لتنظيف وتعقيم خزانات المياه باستخدام معدات متخصصة ومواد معتمدة للتعقيم. تشمل الخدمة تفريغ الخزان، إزالة الرواسب، التنظيف بالفرشاة والضغط العالي، والتعقيم النهائي.',
          price: '300 د.ع',
          duration: '2-4 ساعات',
          icon: Icons.cleaning_services,
          gradient: const [Color(0xFF29B6F6), Color(0xFF4FC3F7)],
        ),
        _buildPaidServiceCard(
          title: 'تركيب أنظمة الري الذكية',
          description: 'تصميم وتركيب أنظمة ري ذكية للمساحات الخضراء',
          detailedDescription:
              'نصمم وننفذ أنظمة ري ذكية تتكيف مع طبيعة النباتات والظروف الجوية. تشمل الخدمة تركيب حساسات رطوبة، أنظمة توقيت، مراقبة عن بعد، وتقارير استهلاك المياه. توفر حتى 40% من استهلاك المياه.',
          price: 'يبدأ من 1000 د.ع',
          duration: '1-2 يوم',
          icon: Icons.grass,
          gradient: const [Color(0xFF29B6F6), Color(0xFF4FC3F7)],
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
          color: const Color(0xFFE1F5FE),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF29B6F6).withOpacity(0.2)),
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
                      color: const Color(0xFF29B6F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFF29B6F6).withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.design_services,
                      color: Color(0xFF29B6F6),
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
                            color: Color(0xFF29B6F6),
                            height: 1.3,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'هل تحتاج إلى خدمة غير موجودة في القائمة؟',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF29B6F6),
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
                  color: Color(0xFF29B6F6),
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF29B6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _submitCustomRequest,
                  child: const Text(
                    'طلب خدمة مخصصة',
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

  double _extractPrice(String priceText) {
    try {
      final numericText = priceText.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.parse(numericText);
    } catch (e) {
      return 0.0;
    }
  }
}
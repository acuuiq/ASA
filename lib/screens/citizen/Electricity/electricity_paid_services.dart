import 'package:flutter/material.dart';
import '../Shared Services Citizen/paid_services_base.dart';
import '../services/payment_screen.dart'
    hide ServiceItem; // أخفِ ServiceItem من هذا الملف

class ElectricityPaidServices extends PaidServicesScreen {
  const ElectricityPaidServices({super.key})
    : super(
        serviceName: 'خدمات الكهرباء المدفوعة',
        serviceColor: const Color(0xFF0D47A1),
        serviceGradient: const [Color(0xFF0D47A1), Color(0xFF1976D2)],
        serviceTitle: 'الكهرباء',
      );

  @override
  State<ElectricityPaidServices> createState() =>
      _ElectricityPaidServicesState();
}

class _ElectricityPaidServicesState extends State<ElectricityPaidServices> {
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
                  child: _buildElectricityPaidServices(),
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
    // الانتقال مباشرة إلى شاشة الدفع مع الخدمة المطلوبة
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          services: [], // إرسال الخدمة كقائمة
          primaryColor: widget.serviceColor,
          primaryGradient: widget.serviceGradient,
        ),
      ),
    );
  }

  void _submitCustomRequest() {
    // تنفيذ طلب الخدمة المخصصة
    print('طلب خدمة مخصصة');
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
          gradient: const [Color(0xFF0D47A1), Color(0xFF1976D2)],
        ),
        _buildPaidServiceCard(
          title: 'فحص وصيانة لوحة الكهرباء',
          description: 'فحص شامل للوحة الكهرباء الرئيسية وإصلاح الأعطال',
          detailedDescription:
              'تشمل الخدمة فحصاً شاملاً للوحة الكهرباء، اختبار القواطع، فحص التوصيلات، تنظيف المكونات، واستبدال الأجزاء التالفة. يشمل التقرير النهائي توصيات للسلامة الكهربائية.',
          price: '200 د.ع',
          duration: '3-5 ساعات',
          icon: Icons.construction,
          gradient: const [Color(0xFF0D47A1), Color(0xFF1976D2)],
        ),
        _buildPaidServiceCard(
          title: 'تمديدات كهربائية إضافية',
          description: 'تركيب نقاط كهرباء إضافية في المنزل',
          detailedDescription:
              'خدمة تركيب نقاط كهرباء جديدة حسب احتياجاتك، مع استخدام أسلاك ومعايير السلامة المطلوبة. تشمل الخدمة التخطيط، التمديد، والتركيب النهائي مع اختبار كل نقطة.',
          price: '80 د.ع',
          duration: 'حسب الطلب',
          icon: Icons.extension,
          gradient: const [Color(0xFF0D47A1), Color(0xFF1976D2)],
        ),
        _buildPaidServiceCard(
          title: 'تركيب أنظمة الطاقة الشمسية',
          description: 'تركيب نظام طاقة شمسية متكامل للمنازل',
          detailedDescription:
              'تشمل الخدمة دراسة الجدوى، تصميم النظام، تركيب الألواح الشمسية، الأنفيرتر، البطاريات، ونظام المراقبة. نوفر أنظمة متكاملة بضمان يصل إلى 25 سنة للألواح و5 سنوات للمكونات الإلكترونية.',
          price: 'يبدأ من 5000 د.ع',
          duration: '1-3 أيام',
          icon: Icons.solar_power,
          gradient: const [Color(0xFF0D47A1), Color(0xFF1976D2)],
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
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF0D47A1).withOpacity(0.2)),
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
                      color: const Color(0xFF0D47A1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFF0D47A1).withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.design_services,
                      color: Color(0xFF0D47A1),
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
                            color: Color(0xFF0D47A1),
                            height: 1.3,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'هل تحتاج إلى خدمة غير موجودة في القائمة؟',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0D47A1),
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
                  color: Color(0xFF0D47A1),
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
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
                  Icon(Icons.info_outline, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'تفاصيل الخدمة',
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
              child: _buildServiceDetailsContent(
                title: title,
                description: description,
                detailedDescription: detailedDescription,
                price: price,
                duration: duration,
                gradient: gradient,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDetailsContent({
    required String title,
    required String description,
    required String detailedDescription,
    required String price,
    required String duration,
    required List<Color> gradient,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Icon and Title
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.electrical_services,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: gradient[0],
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Detailed Description
          Text(
            'الوصف التفصيلي:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.serviceColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detailedDescription,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
            ),
            textAlign: TextAlign.right,
          ),

          const SizedBox(height: 24),

          // Service Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المدة:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      duration,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.serviceColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'السعر:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: widget.serviceColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Request Service Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.serviceColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // إغلاق الـ bottom sheet
                final service = ServiceItem(
                  id: 'service_${DateTime.now().millisecondsSinceEpoch}',
                  name: title,
                  amount: _extractPrice(price),
                  color: gradient[0],
                  gradient: gradient,
                  additionalInfo: detailedDescription,
                );
                _showPaymentMethodsForService(
                  service,
                ); // استخدام الدالة البديلة
              },
              child: const Text(
                'طلب الخدمة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodsForService(ServiceItem service) {
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

            // Payment Methods Content
            Expanded(
              child: PaymentMethodsDialog(
                services: [],
                primaryColor: widget.serviceColor,
                primaryGradient: widget.serviceGradient,
                finalAmount: service.amount,
                usePoints: false,
                pointsDiscount: 0.0,
                onPaymentSuccess: () {
                  // يمكنك إضافة أي إجراء إضافي هنا بعد نجاح الدفع
                  Navigator.pop(context); // إغلاق نافذة الدفع
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم طلب الخدمة "${service.name}" بنجاح'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
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

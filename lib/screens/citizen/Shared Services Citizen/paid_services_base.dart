import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/payment_screen.dart' as payment;

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

class ServiceItem {
  final String id;
  final String name;
  final double amount;
  final Color color;
  final List<Color> gradient;
  String? additionalInfo;
  Employee? selectedEmployee;

  ServiceItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.color,
    required this.gradient,
    this.additionalInfo,
    this.selectedEmployee,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'color': color.value.toString(),
      'gradient': gradient.map((c) => c.value.toString()).toList(),
      'additionalInfo': additionalInfo,
      'selectedEmployee': selectedEmployee?.toMap(),
    };
  }

  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    final bool isCustom =
        map['is_custom'] == true ||
        (map['name'] as String?)?.contains('مخصصة') == true;

    final double amount = isCustom ? 0.0 : (map['amount'] ?? 0).toDouble();

    return ServiceItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      amount: amount,
      color: Color(int.parse(map['color'] ?? '0xFF000000')),
      gradient:
          (map['gradient'] as List<dynamic>?)
              ?.map((c) => Color(int.parse(c.toString())))
              .toList() ??
          [Colors.blue, Colors.lightBlue],
      additionalInfo: map['additional_info'],
      selectedEmployee: map['employee_name'] != null
          ? Employee(
              id: '',
              name: map['employee_name']!,
              specialty: '',
              rating: 0.0,
              completedJobs: 0,
              imageUrl: '',
              skills: [],
              hourlyRate: 0.0,
            )
          : null,
    );
  }
}

class _PaidServicesScreenState extends State<PaidServicesScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<ServiceItem> _requestedServices = [];
  bool _isLoading = false;
  int _currentIndex = 0;
  List<ServiceItem> _availableServices = [];

  @override
  void initState() {
    super.initState();
    _loadRequestedServices();
    _initializeAvailableServices();
  }

  void _initializeAvailableServices() {
    _availableServices = [];
  }

  Future<void> _saveCustomServiceRequest(ServiceItem service) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase.from('requested_services').insert({
        'id': service.id,
        'user_id': user.id,
        'name': service.name,
        'amount': service.amount,
        'color': service.color.value.toString(),
        'gradient': service.gradient.map((c) => c.value.toString()).toList(),
        'additional_info': service.additionalInfo,
        'status': 'معلقة',
        'created_at': DateTime.now().toIso8601String(),
        'service_type': widget.serviceTitle,
        'employee_name': service.selectedEmployee?.name,
        'is_custom': true,
      });

      await _loadRequestedServices();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم إرسال طلب الخدمة المخصصة بنجاح! سيتم التواصل معك قريباً.',
          ),
        ),
      );
    } catch (e) {
      print('Error saving custom service request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ في حفظ الخدمة المخصصة')),
      );
    }
  }

  void _showRatingDialog(String serviceName, String employeeName) {
    showDialog(
      context: context,
      builder: (context) => ServiceRatingDialog(
        serviceName: serviceName,
        employeeName: employeeName,
        serviceColor: widget.serviceColor,
        onRatingSubmitted: (rating, comment) async {
          await _saveRating(serviceName, employeeName, rating, comment);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('شكراً لك على تقييم الخدمة!')),
          );
        },
      ),
    );
  }

  void _submitCustomRequest() {
    final customService = ServiceItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: 'خدمة مخصصة - ${widget.serviceTitle}',
      amount: 0.0,
      color: widget.serviceColor,
      gradient: widget.serviceGradient,
      additionalInfo:
          'خدمة مخصصة - ${widget.serviceTitle} - معلقة - في انتظار العروض',
      selectedEmployee: null,
    );

    _saveServiceRequest(customService, 'معلقة');
    _loadRequestedServices();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم إرسال طلب الخدمة المخصصة بنجاح! سيتم التواصل معك قريباً.',
        ),
      ),
    );

    Navigator.pop(context);
  }

  Future<void> _saveRating(
    String serviceName,
    String employeeName,
    double rating,
    String comment,
  ) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase.from('service_ratings').insert({
        'user_id': user.id,
        'service_name': serviceName,
        'employee_name': employeeName,
        'rating': rating,
        'comment': comment,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error saving rating: $e');
    }
  }

  Future<void> _loadRequestedServices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('requested_services')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      if (response != null && response.isNotEmpty) {
        print('Loaded ${response.length} services');
        setState(() {
          _requestedServices = (response as List<dynamic>)
              .map((item) => ServiceItem.fromMap(item))
              .toList();
        });
      } else {
        print('No services found');
        setState(() {
          _requestedServices = [];
        });
      }
    } catch (e) {
      print('Error loading requested services: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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

  Future<void> _saveServiceRequest(ServiceItem service, String status) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase.from('requested_services').insert({
        'id': service.id,
        'user_id': user.id,
        'name': service.name,
        'amount': service.amount,
        'color': service.color.value.toString(),
        'gradient': service.gradient.map((c) => c.value.toString()).toList(),
        'additional_info': service.additionalInfo,
        'status': status,
        'created_at': DateTime.now().toIso8601String(),
        'service_type': widget.serviceTitle,
        'employee_name': service.selectedEmployee?.name,
        'is_custom': service.additionalInfo?.contains('مخصصة') == true,
      });
    } catch (e) {
      print('Error saving service request: $e');
    }
  }

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
                  child: buildContent(),
                ),
                _buildRequestedServicesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
    print(
      'Building requested services tab with ${_requestedServices.length} services',
    );

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_requestedServices.isEmpty) {
      print('No services to display');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد خدمات مطلوبة بعد',
              style: TextStyle(fontSize: 18, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadRequestedServices,
              child: const Text('إعادة تحميل'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRequestedServices,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _requestedServices.length,
        itemBuilder: (context, index) {
          final service = _requestedServices[index];
          print('Service ${index + 1}: ${service.name}');
          return _buildRequestedServiceCard(service);
        },
      ),
    );
  }

  Widget _buildRequestedServiceCard(ServiceItem service) {
    final bool isCustomService =
        service.name.contains('مخصصة') ||
        service.additionalInfo?.contains('مخصصة') == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: service.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: service.color.withOpacity(0.3)),
                  ),
                  child: Icon(
                    isCustomService ? Icons.description : Icons.shopping_cart,
                    color: service.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isCustomService)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: Text(
                                'مخصصة',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (isCustomService) const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              service.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: service.color,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.additionalInfo ?? 'خدمة مدفوعة',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      if (service.selectedEmployee != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'الموظف: ${service.selectedEmployee!.name}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (_getStatusText(service.additionalInfo ?? 'معلقة') ==
                          'مكتملة')
                        const SizedBox(height: 12),
                      if (_getStatusText(service.additionalInfo ?? 'معلقة') ==
                          'مكتملة')
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              final employeeName =
                                  service.selectedEmployee?.name ?? 'الموظف';
                              _showRatingDialog(service.name, employeeName);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(color: widget.serviceColor),
                            ),
                            child: Text(
                              'تقييم الخدمة',
                              style: TextStyle(color: widget.serviceColor),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(service.additionalInfo ?? 'معلقة'),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(service.additionalInfo ?? 'معلقة'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  service.amount > 0
                      ? '${service.amount} د.ع'
                      : 'في انتظار العروض',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: service.amount > 0 ? service.color : Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'مكتملة':
        return Colors.green;
      case 'قيد التنفيذ':
        return Colors.orange;
      case 'ملغية':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    if (status.contains('مكتملة')) return 'مكتملة';
    if (status.contains('قيد')) return 'قيد التنفيذ';
    if (status.contains('ملغية')) return 'ملغية';
    return 'معلقة';
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
          ],
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
          ],
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
          ],
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
          ],
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
          ],
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
          ],
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
          ],
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
          ],
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
          ],
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
          ],
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
          ],
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
          ],
        ),
        _buildCustomServiceCard(),
      ],
    );
  }

  Widget _buildPremiumServiceCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.purple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
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
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.workspace_premium,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'الخدمة المميزة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.purple,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'اطلب خدمة مخصصة واحصل على عروض من عدة موظفين',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.purple,
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
                '• اختر من بين عروض متعددة\n• قارن الأسعار والخبرات\n• تواصل مباشر مع الموظفين\n• دفع آمن بعد إتمام العمل',
                style: TextStyle(fontSize: 14, height: 1.6),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _showPremiumServiceDialog(),
                  child: const Text(
                    'طلب خدمة مميزة',
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

  void _showPremiumServiceDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          PremiumServiceRequestDialog(serviceColor: widget.serviceColor),
    );
  }

  Widget _buildDefaultPaidServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('الخدمات المدفوعة'),
        const SizedBox(height: 16),
        _buildPremiumServiceCard(),

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
    Color primaryColor;
    Color backgroundColor;
    Color iconColor;
    Color textColor;

    if (widget.serviceTitle.contains('الكهرباء')) {
      primaryColor = const Color(0xFF0D47A1);
      backgroundColor = const Color(0xFFE3F2FD);
      iconColor = const Color(0xFF0D47A1);
      textColor = const Color(0xFF0D47A1);
    } else if (widget.serviceTitle.contains('الماء')) {
      primaryColor = const Color(0xFF29B6F6);
      backgroundColor = const Color(0xFFE1F5FE);
      iconColor = const Color(0xFF29B6F6);
      textColor = const Color(0xFF29B6F6);
    } else if (widget.serviceTitle.contains('النفايات')) {
      primaryColor = const Color(0xFF388E3C);
      backgroundColor = const Color(0xFFE8F5E8);
      iconColor = const Color(0xFF388E3C);
      textColor = const Color(0xFF388E3C);
    } else {
      primaryColor = Colors.purple;
      backgroundColor = Colors.purple.shade50;
      iconColor = Colors.purple;
      textColor = Colors.purple;
    }

    return Card(
      margin: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withOpacity(0.2)),
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
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: primaryColor.withOpacity(0.3)),
                    ),
                    child: Icon(
                      Icons.design_services,
                      color: iconColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'خدمة مخصصة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textColor,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'هل تحتاج إلى خدمة غير موجودة في القائمة؟',
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor,
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
              Text(
                '• وصف الخدمة المطلوبة بدقة\n• تحديد الميزانية المتوقعة\n• الموقع والوقت المناسب\n• أي متطلبات خاصة',
                style: TextStyle(fontSize: 14, height: 1.6, color: textColor),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
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
              colors: [gradient[0].withOpacity(0.05), gradient[1].withOpacity(0.05)],
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

  void _requestService(ServiceItem service) {
    Navigator.pop(context);
    _showEmployeeSelectionDialog(service);
  }

  void _showEmployeeSelectionDialog(ServiceItem service) {
    showDialog(
      context: context,
      builder: (context) => EmployeeSelectionDialog(
        service: service,
        serviceColor: widget.serviceColor,
        onEmployeeSelected: (employee) async {
          final updatedService = ServiceItem(
            id: service.id,
            name: service.name,
            amount: service.amount,
            color: service.color,
            gradient: service.gradient,
            additionalInfo: 'معلقة - في انتظار الموافقة',
            selectedEmployee: employee,
          );

          await _saveServiceRequest(updatedService, 'معلقة');
          await _loadRequestedServices();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم طلب خدمة $service.name بنجاح!'),
            ),
          );

          Navigator.pop(context);
        },
      ),
    );
  }
}

class ServiceDetailsDialog extends StatelessWidget {
  final String title;
  final String description;
  final String detailedDescription;
  final String price;
  final String duration;
  final List<Color> gradient;
  final Color serviceColor;
  final VoidCallback onRequestService;

  const ServiceDetailsDialog({
    super.key,
    required this.title,
    required this.description,
    required this.detailedDescription,
    required this.price,
    required this.duration,
    required this.gradient,
    required this.serviceColor,
    required this.onRequestService,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.construction,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'تفاصيل الخدمة:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    detailedDescription,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: gradient[0].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              duration,
                              style: TextStyle(
                                color: gradient[0],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: gradient[0],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(color: serviceColor),
                          ),
                          child: Text(
                            'إلغاء',
                            style: TextStyle(color: serviceColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onRequestService,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: serviceColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'طلب الخدمة',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }
}

class EmployeeSelectionDialog extends StatefulWidget {
  final ServiceItem service;
  final Color serviceColor;
  final Function(Employee) onEmployeeSelected;

  const EmployeeSelectionDialog({
    super.key,
    required this.service,
    required this.serviceColor,
    required this.onEmployeeSelected,
  });

  @override
  State<EmployeeSelectionDialog> createState() =>
      _EmployeeSelectionDialogState();
}

class _EmployeeSelectionDialogState extends State<EmployeeSelectionDialog> {
  List<Employee> _employees = [];
  bool _isLoading = true;
  Employee? _selectedEmployee;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _employees = [
        Employee(
          id: '1',
          name: 'أحمد محمد',
          specialty: 'فني كهرباء',
          rating: 4.8,
          completedJobs: 124,
          imageUrl: '',
          skills: ['التركيب', 'الصيانة', 'الفحص'],
          hourlyRate: 25.0,
        ),
        Employee(
          id: '2',
          name: 'محمود علي',
          specialty: 'مهندس كهرباء',
          rating: 4.9,
          completedJobs: 89,
          imageUrl: '',
          skills: ['التصميم', 'الاستشارات', 'الفحص الشامل'],
          hourlyRate: 35.0,
        ),
        Employee(
          id: '3',
          name: 'سامي كريم',
          specialty: 'فني تركيب',
          rating: 4.7,
          completedJobs: 156,
          imageUrl: '',
          skills: ['التركيب السريع', 'خدمة العملاء'],
          hourlyRate: 20.0,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.serviceColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.person_search, color: Colors.white, size: 40),
                  const SizedBox(height: 12),
                  const Text(
                    'اختر الموظف المناسب',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.service.name,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _employees.length,
                  itemBuilder: (context, index) {
                    final employee = _employees[index];
                    return _buildEmployeeCard(employee);
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: widget.serviceColor),
                      ),
                      child: Text(
                        'إلغاء',
                        style: TextStyle(color: widget.serviceColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedEmployee == null
                          ? null
                          : () {
                              widget.onEmployeeSelected(_selectedEmployee!);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.serviceColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: const Text(
                        'تأكيد الاختيار',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(Employee employee) {
    final isSelected = _selectedEmployee?.id == employee.id;

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? widget.serviceColor : Colors.transparent,
          width: 2,
        ),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _selectedEmployee = employee;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: widget.serviceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.person,
                  color: widget.serviceColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employee.specialty,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${employee.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${employee.completedJobs} مهمة',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: widget.serviceColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Employee {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int completedJobs;
  final String imageUrl;
  final List<String> skills;
  final double hourlyRate;

  Employee({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.completedJobs,
    required this.imageUrl,
    required this.skills,
    required this.hourlyRate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'completedJobs': completedJobs,
      'imageUrl': imageUrl,
      'skills': skills,
      'hourlyRate': hourlyRate,
    };
  }
}

class PremiumServiceRequestDialog extends StatefulWidget {
  final Color serviceColor;

  const PremiumServiceRequestDialog({super.key, required this.serviceColor});

  @override
  State<PremiumServiceRequestDialog> createState() =>
      _PremiumServiceRequestDialogState();
}

class _PremiumServiceRequestDialogState
    extends State<PremiumServiceRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  final _serviceDescriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<XFile> _selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.serviceColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.workspace_premium, color: Colors.white, size: 40),
                    SizedBox(height: 12),
                    Text(
                      'طلب خدمة مميزة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'أدخل تفاصيل الخدمة المطلوبة للحصول على عروض من الموظفين',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildImageUploadSection(),
                      const SizedBox(height: 16),
                      _buildFormField(
                        controller: _serviceDescriptionController,
                        label: 'وصف الخدمة المطلوبة',
                        hintText: 'صف الخدمة التي تحتاجها بدقة...',
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال وصف الخدمة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFormField(
                        controller: _budgetController,
                        label: 'الميزانية المتوقعة (دينار عراقي)',
                        hintText: 'أدخل الميزانية المتوقعة للخدمة',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال الميزانية المتوقعة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFormField(
                        controller: _locationController,
                        label: 'موقع الخدمة',
                        hintText: 'أدخل العنوان التفصيلي',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال موقع الخدمة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDateTimeSection(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: widget.serviceColor),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(color: widget.serviceColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.serviceColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'إرسال الطلب',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'صور توضيحية (اختياري)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
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
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(File(_selectedImages[index].path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            left: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImages.removeAt(index);
                                });
                              },
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton.icon(
                  onPressed: _pickImages,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: widget.serviceColor),
                  ),
                  icon: Icon(Icons.add_photo_alternate, color: widget.serviceColor),
                  label: Text(
                    'إضافة صور',
                    style: TextStyle(color: widget.serviceColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    int? maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.serviceColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'الوقت والتاريخ المناسب',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _selectDate,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: widget.serviceColor),
                ),
                icon: Icon(Icons.calendar_today, color: widget.serviceColor),
                label: Text(
                  _selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                      : 'اختر التاريخ',
                  style: TextStyle(color: widget.serviceColor),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _selectTime,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: widget.serviceColor),
                ),
                icon: Icon(Icons.access_time, color: widget.serviceColor),
                label: Text(
                  _selectedTime != null
                      ? _selectedTime!.format(context)
                      : 'اختر الوقت',
                  style: TextStyle(color: widget.serviceColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال طلب الخدمة بنجاح! سيتم التواصل معك قريباً.'),
        ),
      );
    }
  }
}

class ServiceRatingDialog extends StatefulWidget {
  final String serviceName;
  final String employeeName;
  final Color serviceColor;
  final Function(double rating, String comment) onRatingSubmitted;

  const ServiceRatingDialog({
    super.key,
    required this.serviceName,
    required this.employeeName,
    required this.serviceColor,
    required this.onRatingSubmitted,
  });

  @override
  State<ServiceRatingDialog> createState() => _ServiceRatingDialogState();
}

class _ServiceRatingDialogState extends State<ServiceRatingDialog> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.star_rate_rounded,
                color: widget.serviceColor,
                size: 50,
              ),
              const SizedBox(height: 16),
              Text(
                'تقييم الخدمة',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: widget.serviceColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.serviceName,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'الموظف: ${widget.employeeName}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _rating = (index + 1).toDouble();
                      });
                    },
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _commentController,
                maxLines: 3,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: 'تعليقك (اختياري)',
                  labelStyle: TextStyle(color: widget.serviceColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: widget.serviceColor),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: widget.serviceColor),
                      ),
                      child: Text(
                        'إلغاء',
                        style: TextStyle(color: widget.serviceColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _rating == 0
                          ? null
                          : () {
                              widget.onRatingSubmitted(
                                _rating,
                                _commentController.text,
                              );
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.serviceColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: const Text(
                        'إرسال التقييم',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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

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

class ServiceItem {
  final String id;
  final String name;
  final double amount;
  final Color color;
  final List<Color> gradient;
  String? additionalInfo;
  Employee? selectedEmployee; // ✅ سيتم إدارته لكل خدمة على حدة

  ServiceItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.color,
    required this.gradient,
    this.additionalInfo,
    this.selectedEmployee, // ✅ إضافة هنا
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'color': color.value.toString(),
      'gradient': gradient.map((c) => c.value.toString()).toList(),
      'additionalInfo': additionalInfo,
      'selectedEmployee': selectedEmployee?.toMap(), // ✅ حفظ الموظف
    };
  }

  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    // تحديد إذا كانت خدمة مخصصة
    final bool isCustom =
        map['is_custom'] == true ||
        (map['name'] as String?)?.contains('مخصصة') == true;

    // إذا كانت خدمة مخصصة، استخدم سعر 0.0
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
    _initializeAvailableServices(); // ✅ تهيئة الخدمات المتاحة
  }

  // ✅ دالة لتهيئة الخدمات المتاحة
  void _initializeAvailableServices() {
    _availableServices = [
      // خدمات الكهرباء
      ServiceItem(
        id: 'smart_meters_${DateTime.now().millisecondsSinceEpoch}1',
        name: 'تركيب عدادات ذكية',
        amount: _getServicePrice('تركيب عدادات ذكية'),
        color: const Color(0xFF0D47A1),
        gradient: [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
        additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
      ),
      ServiceItem(
        id: 'electrical_maintenance_${DateTime.now().millisecondsSinceEpoch}2',
        name: 'فحص وصيانة لوحة الكهرباء',
        amount: _getServicePrice('فحص وصيانة لوحة الكهرباء'),
        color: const Color(0xFF0D47A1),
        gradient: [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
        additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
      ),
      ServiceItem(
        id: 'electrical_extensions_${DateTime.now().millisecondsSinceEpoch}3',
        name: 'تمديدات كهربائية إضافية',
        amount: _getServicePrice('تمديدات كهربائية إضافية'),
        color: const Color(0xFF0D47A1),
        gradient: [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
        additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
      ),
      ServiceItem(
        id: 'solar_systems_${DateTime.now().millisecondsSinceEpoch}4',
        name: 'تركيب أنظمة الطاقة الشمسية',
        amount: _getServicePrice('تركيب أنظمة الطاقة الشمسية'),
        color: const Color(0xFF0D47A1),
        gradient: [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
        additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
      ),

      // خدمات المياه
      ServiceItem(
        id: 'water_meter_${DateTime.now().millisecondsSinceEpoch}5',
        name: 'تركيب عداد مياه إضافي',
        amount: _getServicePrice('تركيب عداد مياه إضافي'),
        color: const Color(0xFF29B6F6),
        gradient: [const Color(0xFF29B6F6), const Color(0xFF4FC3F7)],
        additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
      ),
      ServiceItem(
        id: 'water_leakage_${DateTime.now().millisecondsSinceEpoch}6',
        name: 'كشف تسربات المياه',
        amount: _getServicePrice('كشف تسربات المياه'),
        color: const Color(0xFF29B6F6),
        gradient: [const Color(0xFF29B6F6), const Color(0xFF4FC3F7)],
        additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
      ),
      ServiceItem(
        id: 'water_tank_cleaning_${DateTime.now().millisecondsSinceEpoch}7',
        name: 'تنظيف خزانات المياه',
        amount: _getServicePrice('تنظيف خزانات المياه'),
        color: const Color(0xFF29B6F6),
        gradient: [const Color(0xFF29B6F6), const Color(0xFF4FC3F7)],
        additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
      ),
      ServiceItem(
        id: 'smart_irrigation_${DateTime.now().millisecondsSinceEpoch}8',
        name: 'تركيب أنظمة الري الذكية',
        amount: _getServicePrice('تركيب أنظمة الري الذكية'),
        color: const Color(0xFF29B6F6),
        gradient: [const Color(0xFF29B6F6), const Color(0xFF4FC3F7)],
        additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
      ),

      // خدمات النفايات
      ServiceItem(
        id: 'construction_waste_${DateTime.now().millisecondsSinceEpoch}9',
        name: 'إزالة نفايات البناء',
        amount: _getServicePrice('إزالة نفايات البناء'),
        color: const Color(0xFF388E3C),
        gradient: [const Color(0xFF388E3C), const Color(0xFF4CAF50)],
        additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
      ),
      ServiceItem(
        id: 'waste_containers_${DateTime.now().millisecondsSinceEpoch}10',
        name: 'تركيب حاويات نفايات كبيرة',
        amount: _getServicePrice('تركيب حاويات نفايات كبيرة'),
        color: const Color(0xFF388E3C),
        gradient: [const Color(0xFF388E3C), const Color(0xFF4CAF50)],
        additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
      ),
      ServiceItem(
        id: 'recycling_${DateTime.now().millisecondsSinceEpoch}11',
        name: 'تدوير النفايات المنزلية',
        amount: _getServicePrice('تدوير النفايات المنزلية'),
        color: const Color(0xFF388E3C),
        gradient: [const Color(0xFF388E3C), const Color(0xFF4CAF50)],
        additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
      ),
      ServiceItem(
        id: 'event_cleaning_${DateTime.now().millisecondsSinceEpoch}12',
        name: 'تنظيف مواقع الأحداث',
        amount: _getServicePrice('تنظيف مواقع الأحداث'),
        color: const Color(0xFF388E3C),
        gradient: [const Color(0xFF388E3C), const Color(0xFF4CAF50)],
        additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
      ),
    ];
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
        'is_custom': true, // تمييز الخدمة كخدمة مخصصة
      });

      // تحديث القائمة فوراً
      await _loadRequestedServices();

      // إظهار رسالة نجاح
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

  // أضف هذه الدالة في _PaidServicesScreenState
  void _showRatingDialog(String serviceName, String employeeName) {
    showDialog(
      context: context,
      builder: (context) => ServiceRatingDialog(
        serviceName: serviceName,
        employeeName: employeeName,
        serviceColor: widget.serviceColor,
        onRatingSubmitted: (rating, comment) async {
          // حفظ التقييم في قاعدة البيانات
          await _saveRating(serviceName, employeeName, rating, comment);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('شكراً لك على تقييم الخدمة!')),
          );
        },
      ),
    );
  }

  void _submitCustomRequest() {
    // إنشاء ServiceItem للخدمة المخصصة
    final customService = ServiceItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: 'خدمة مخصصة - ${widget.serviceTitle}',
      amount: 0.0, // سيتم تحديد السعر لاحقاً من خلال العروض
      color: widget.serviceColor,
      gradient: widget.serviceGradient,
      additionalInfo:
          'خدمة مخصصة - ${widget.serviceTitle} - معلقة - في انتظار العروض',
      selectedEmployee: null, // سيتم اختيار الموظف لاحقاً
    );

    // حفظ الخدمة المخصصة
    _saveServiceRequest(customService, 'معلقة');

    // تحديث القائمة
    _loadRequestedServices();

    // إظهار رسالة نجاح
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
        print('Loaded ${response.length} services'); // Debug print
        setState(() {
          _requestedServices = (response as List<dynamic>)
              .map((item) => ServiceItem.fromMap(item))
              .toList();
        });
      } else {
        print('No services found'); // Debug print
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
        // إضافة العمود الجديد
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
          // Tab Bar
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
                // تم حذف تبويب "طلباتي المخصصة"
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                // Services Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: buildContent(),
                ),
                // Requested Services Tab (سيشمل الآن الخدمات المخصصة)
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
    ); // Debug

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_requestedServices.isEmpty) {
      print('No services to display'); // Debug
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
          print('Service ${index + 1}: ${service.name}'); // Debug
          return _buildRequestedServiceCard(service);
        },
      ),
    );
  }

  Widget _buildRequestedServiceCard(ServiceItem service) {
    // تحديد إذا كانت الخدمة مخصصة
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
                      // إظهار زر التقييم للخدمات المكتملة فقط
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

  // ✅ أضف هذه الدالة في _PaidServicesScreenState
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

  // ✅ أضف هذه الدالة أيضًا
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
    // تحديد الألوان حسب نوع الخدمة
    Color primaryColor;
    Color backgroundColor;
    Color iconColor;
    Color textColor;

    if (widget.serviceTitle.contains('الكهرباء')) {
      primaryColor = const Color(0xFF0D47A1); // أزرق
      backgroundColor = const Color(0xFFE3F2FD); // أزرق فاتح
      iconColor = const Color(0xFF0D47A1);
      textColor = const Color(0xFF0D47A1);
    } else if (widget.serviceTitle.contains('الماء')) {
      primaryColor = const Color(0xFF29B6F6); // أزرق مائي
      backgroundColor = const Color(0xFFE1F5FE); // أزرق مائي فاتح
      iconColor = const Color(0xFF29B6F6);
      textColor = const Color(0xFF29B6F6);
    } else if (widget.serviceTitle.contains('النفايات')) {
      primaryColor = const Color(0xFF388E3C); // أخضر
      backgroundColor = const Color(0xFFE8F5E8); // أخضر فاتح
      iconColor = const Color(0xFF388E3C);
      textColor = const Color(0xFF388E3C);
    } else {
      // لون افتراضي للخدمات الأخرى
      primaryColor = const Color(0xFF8E8E93); // رمادي
      backgroundColor = const Color(0xFFF2F2F7); // رمادي فاتح
      iconColor = const Color(0xFF8E8E93);
      textColor = const Color(0xFF8E8E93);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16, top: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
        ),
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
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor.withOpacity(0.3)),
                    ),
                    child: Icon(
                      Icons.add_circle_outline,
                      color: iconColor,
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
                        color: textColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'إذا لم تجد الخدمة التي تبحث عنها، يمكنك طلب خدمة مخصصة وإرفاق صور للعمل المطلوب والاستفسار عن السعر',
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.8),
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                onPressed: () => _showCustomServiceDialog(),
                child: const Text(
                  'طلب خدمة مخصصة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
    final Color primaryColor = gradient.first;

    // ✅ البحث عن ServiceItem المناسب من القائمة
    ServiceItem? serviceItem = _availableServices.firstWhere(
      (service) => service.name == title,
      orElse: () => ServiceItem(
        id: '${title}_${DateTime.now().millisecondsSinceEpoch}',
        name: title,
        amount: _getServicePrice(title),
        color: primaryColor,
        gradient: gradient,
        additionalInfo: 'خدمة مدفوعة - ${widget.serviceTitle}',
      ),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: primaryColor,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ✅ قسم اختيار الموظف - باستخدام ServiceItem من القائمة
              _buildEmployeeSelectionSection(serviceItem),

              const SizedBox(height: 16),

              // Price and Duration Section
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'السعر',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          price,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action Buttons Section
              Row(
                children: [
                  // Request Service Button
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 0,
                          ),
                        ),
                        onPressed: () => _showPaymentOptions(serviceItem),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_checkout,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'طلب الخدمة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Details Button
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 0,
                          ),
                        ),
                        onPressed: () {
                          _showServiceDetailsDialog(title, detailedDescription);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'التفاصيل',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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

  Widget _buildEmployeeSelectionSection(ServiceItem serviceItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'اختر الموظف',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            GestureDetector(
              onTap: () => _showEmployeeSelectionBottomSheet(serviceItem),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color.fromARGB(255, 221, 217, 217),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: widget.serviceColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      serviceItem.selectedEmployee?.name ?? 'اختر موظف',
                      style: TextStyle(
                        fontSize: 12,
                        color: serviceItem.selectedEmployee != null
                            ? widget.serviceColor
                            : Colors.grey[600],
                        fontWeight: serviceItem.selectedEmployee != null
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_drop_down,
                      color: widget.serviceColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (serviceItem.selectedEmployee != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.serviceColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: widget.serviceColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: widget.serviceColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.person,
                    color: widget.serviceColor,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceItem.selectedEmployee!.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: widget.serviceColor,
                        ),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index <
                                      serviceItem.selectedEmployee!.rating
                                          .floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 12,
                            );
                          }),
                          const SizedBox(width: 4),
                          Text(
                            '(${serviceItem.selectedEmployee!.rating})',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      serviceItem.selectedEmployee = null;
                      serviceItem.additionalInfo =
                          'خدمة مدفوعة - ${widget.serviceTitle}';
                    });
                  },
                  child: Icon(Icons.close, color: Colors.grey[500], size: 16),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _showEmployeeSelectionBottomSheet(ServiceItem serviceItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
                  const Icon(
                    Icons.person_search,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'اختر الموظف المناسب',
                    style: TextStyle(
                      fontSize: 18,
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
            Expanded(child: _buildEmployeeList(serviceItem)),
          ],
        ),
      ),
    ).then((_) {
      // ✅ هذا يضمن تحديث الواجهة بعد اختيار الموظف
      setState(() {});
    });
  }

  // في دالة _buildEmployeeList في _PaidServicesScreenState
  Widget _buildEmployeeList(ServiceItem serviceItem) {
    List<Employee> employees = [];

    // تحديد الموظفين حسب نوع الخدمة
    if (widget.serviceTitle.contains('الكهرباء')) {
      employees = [
        Employee(
          id: '1',
          name: 'أحمد محمد',
          specialty: 'فني كهرباء',
          rating: 4.8,
          completedJobs: 127,
          imageUrl: '',
          skills: ['تركيب عدادات', 'صيانة لوحات', 'تمديدات'],
          hourlyRate: 25.0,
        ),
        Employee(
          id: '2',
          name: 'خالد إبراهيم',
          specialty: 'فني كهرباء متقدم',
          rating: 4.9,
          completedJobs: 203,
          imageUrl: '',
          skills: ['أنظمة الطاقة الشمسية', 'التحكم الذكي', 'الصيانة الوقائية'],
          hourlyRate: 35.0,
        ),
        Employee(
          id: '3',
          name: 'محمود علي',
          specialty: 'فني كهرباء منزلي',
          rating: 4.6,
          completedJobs: 89,
          imageUrl: '',
          skills: ['تركيب نقاط كهرباء', 'إصلاح أعطال', 'استشارات فنية'],
          hourlyRate: 20.0,
        ),
        Employee(
          id: '4',
          name: 'سعيد حسن',
          specialty: 'فني كهرباء صناعي',
          rating: 4.7,
          completedJobs: 156,
          imageUrl: '',
          skills: ['المحركات الصناعية', 'أنظمة التحكم', 'الصيانة الدورية'],
          hourlyRate: 30.0,
        ),
        Employee(
          id: '5',
          name: 'علي كريم',
          specialty: 'فني إنارة',
          rating: 4.5,
          completedJobs: 78,
          imageUrl: '',
          skills: ['تصميم الإنارة', 'تركيب الثريات', 'أنظمة الإضاءة الذكية'],
          hourlyRate: 22.0,
        ),
      ];
    } else if (widget.serviceTitle.contains('الماء')) {
      employees = [
        Employee(
          id: 'w1',
          name: 'محمد عبدالله',
          specialty: 'فني سباكة متخصص',
          rating: 4.8,
          completedJobs: 145,
          imageUrl: '',
          skills: ['تركيب عدادات المياه', 'كشف التسربات', 'تنظيف الخزانات'],
          hourlyRate: 28.0,
        ),
        Employee(
          id: 'w2',
          name: 'ياسر أحمد',
          specialty: 'خبير أنظمة المياه',
          rating: 4.9,
          completedJobs: 189,
          imageUrl: '',
          skills: ['أنظمة الري الذكية', 'تحلية المياه', 'معالجة المياه'],
          hourlyRate: 35.0,
        ),
        Employee(
          id: 'w3',
          name: 'حسن علي',
          specialty: 'فني صيانة خزانات',
          rating: 4.7,
          completedJobs: 112,
          imageUrl: '',
          skills: ['تعقيم الخزانات', 'عزل الخزانات', 'صيانة المضخات'],
          hourlyRate: 25.0,
        ),
        Employee(
          id: 'w4',
          name: 'عمر محمد',
          specialty: 'فني أنظمة الري',
          rating: 4.6,
          completedJobs: 98,
          imageUrl: '',
          skills: ['تصميم أنظمة الري', 'تركيب الرشاشات', 'صيانة الأنظمة'],
          hourlyRate: 22.0,
        ),
        Employee(
          id: 'w5',
          name: 'خالد سعيد',
          specialty: 'فني كشف تسربات',
          rating: 4.8,
          completedJobs: 167,
          imageUrl: '',
          skills: ['كشف التسربات بالأجهزة', 'إصلاح التسربات', 'تقارير فنية'],
          hourlyRate: 30.0,
        ),
      ];
    } else if (widget.serviceTitle.contains('النفايات')) {
      employees = [
        Employee(
          id: 't1',
          name: 'ماجد راشد',
          specialty: 'خبير إدارة النفايات',
          rating: 4.7,
          completedJobs: 134,
          imageUrl: '',
          skills: ['إدارة النفايات', 'التدوير', 'النظافة العامة'],
          hourlyRate: 32.0,
        ),
        Employee(
          id: 't2',
          name: 'ناصر خليفة',
          specialty: 'فني نظافة متخصص',
          rating: 4.6,
          completedJobs: 178,
          imageUrl: '',
          skills: ['تنظيف المواقع', 'إزالة النفايات', 'التعقيم'],
          hourlyRate: 26.0,
        ),
        Employee(
          id: 't3',
          name: 'راشد سالم',
          specialty: 'فني تدوير النفايات',
          rating: 4.8,
          completedJobs: 95,
          imageUrl: '',
          skills: ['فصل النفايات', 'عمليات التدوير', 'التوعية البيئية'],
          hourlyRate: 28.0,
        ),
        Employee(
          id: 't4',
          name: 'سالم أحمد',
          specialty: 'مشرف نظافة',
          rating: 4.5,
          completedJobs: 156,
          imageUrl: '',
          skills: ['إدارة الفرق', 'التخطيط', 'الرقابة'],
          hourlyRate: 30.0,
        ),
        Employee(
          id: 't5',
          name: 'عبدالله محمد',
          specialty: 'فني معالجة النفايات',
          rating: 4.7,
          completedJobs: 122,
          imageUrl: '',
          skills: ['المعالجة البيئية', 'التخلص الآمن', 'الالتزام البيئي'],
          hourlyRate: 29.0,
        ),
      ];
    } else {
      // موظفين افتراضيين للخدمات الأخرى
      employees = [
        Employee(
          id: 'g1',
          name: 'فني متعدد التخصصات',
          specialty: 'فني خدمات عامة',
          rating: 4.5,
          completedJobs: 100,
          imageUrl: '',
          skills: ['خدمات متنوعة', 'صيانة عامة', 'إصلاحات'],
          hourlyRate: 20.0,
        ),
      ];
    }

    return EmployeeSearchList(
      employees: employees,
      serviceItem: serviceItem,
      serviceColor: widget.serviceColor,
    );
  }

  Widget _buildEmployeeListItem(Employee employee, ServiceItem serviceItem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: widget.serviceColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.person, color: widget.serviceColor),
        ),
        title: Text(
          employee.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(employee.specialty),
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < employee.rating.floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 14,
                  );
                }),
                const SizedBox(width: 4),
                Text(
                  '(${employee.rating})',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: Text(
          '${employee.hourlyRate} د.ع/ساعة',
          style: TextStyle(
            color: widget.serviceColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          // ✅ تحديث حالة الخدمة الحالية فقط
          setState(() {
            serviceItem.selectedEmployee = employee;
            serviceItem.additionalInfo =
                'خدمة مدفوعة - ${widget.serviceTitle} - مع الموظف: ${employee.name} - معلقة';
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showServiceDetailsDialog(String title, String details) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
                  const Icon(Icons.info_outline, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Text(
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        details,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Features Section
                    _buildFeaturesSection(),
                    const SizedBox(height: 20),

                    // Benefits Section
                    _buildBenefitsSection(),
                  ],
                ),
              ),
            ),

            // Footer Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.serviceColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المميزات:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.serviceColor,
          ),
        ),
        const SizedBox(height: 12),
        _buildFeatureItem('خدمة معتمدة وموثوقة'),
        _buildFeatureItem('فريق عمل محترف'),
        _buildFeatureItem('ضمان على الخدمة'),
        _buildFeatureItem('دعم فني متواصل'),
      ],
    );
  }

  // دالة لبناء عنصر الميزة
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // دالة لبناء قسم الفوائد
  Widget _buildBenefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الفوائد:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.serviceColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.serviceColor.withOpacity(0.1),
                widget.serviceColor.withOpacity(0.05),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.serviceColor.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              _buildBenefitItem('توفير الوقت والجهد'),
              _buildBenefitItem('جودة عالية في التنفيذ'),
              _buildBenefitItem('أسعار تنافسية'),
              _buildBenefitItem('خدمة ما بعد البيع'),
            ],
          ),
        ),
      ],
    );
  }

  // دالة لبناء عنصر الفائدة
  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.amber, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentOptions(ServiceItem serviceItem) {
    if (serviceItem.selectedEmployee == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى اختيار موظف أولاً')));
      return;
    }

    // ✅ إنشاء نسخة جديدة من ServiceItem مع البيانات المحدثة
    ServiceItem updatedService = ServiceItem(
      id: serviceItem.id,
      name: serviceItem.name,
      amount: serviceItem.amount,
      color: serviceItem.color,
      gradient: serviceItem.gradient,
      additionalInfo:
          'خدمة مدفوعة - ${widget.serviceTitle} - مع الموظف: ${serviceItem.selectedEmployee!.name} - معلقة',
      selectedEmployee: serviceItem.selectedEmployee,
    );

    _showPaymentBottomSheet(updatedService);
  }

  void _showEmployeeSelectionDialog(
    String serviceName,
    String price,
    double amount,
    ServiceItem serviceItem,
  ) {
    showDialog(
      context: context,
      builder: (context) => EmployeeSelectionDialog(
        serviceName: serviceName,
        serviceColor: widget.serviceColor,
        serviceGradient: widget.serviceGradient,
        onEmployeeSelected: (employee) {
          setState(() {
            serviceItem.selectedEmployee = employee;
          });

          // تحديث معلومات الخدمة بعد اختيار الموظف
          serviceItem.additionalInfo =
              'خدمة مدفوعة - ${widget.serviceTitle} - مع الموظف: ${employee.name} - معلقة';

          // بعد اختيار الموظف، اعرض خيارات الدفع
          _showPaymentBottomSheet(serviceItem);
        },
      ),
    );
  }

  void _showPaymentBottomSheet(ServiceItem serviceItem) {
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
            Expanded(
              child: PaymentMethodsDialog(
                services: [],
                primaryColor: widget.serviceColor,
                primaryGradient: widget.serviceGradient,
                finalAmount: serviceItem.amount,
                usePoints: false,
                pointsDiscount: 0.0,
                onPaymentSuccess: () async {
                  // حفظ الخدمة في قاعدة البيانات عند نجاح الدفع
                  await _saveServiceRequest(serviceItem, 'معلقة');
                  await _loadRequestedServices(); // تحديث القائمة

                  Navigator.pop(context);
                  _showPaymentSuccessDialog(
                    serviceItem.name,
                    '${serviceItem.amount} د.ع',
                    serviceItem.selectedEmployee!,
                  );

                  // الانتقال تلقائياً إلى تبويب الخدمات المطلوبة
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentSuccessDialog(
    String serviceName,
    String price,
    Employee employee,
  ) {
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
<<<<<<< Updated upstream

=======
void _showPaymentOptions(String serviceName, String price) {
  // تحويل السعر من نص إلى رقم
  double getServicePrice(String serviceName) {
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
  double amount = getServicePrice(serviceName);
  
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
>>>>>>> Stashed changes
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
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
        child: CustomServiceDialog(
          serviceColor: widget.serviceColor,
          serviceType: widget.serviceTitle,
        ),
      ),
    );
  }
}

class EmployeeSearchList extends StatefulWidget {
  final List<Employee> employees;
  final ServiceItem serviceItem;
  final Color serviceColor;

  const EmployeeSearchList({
    super.key,
    required this.employees,
    required this.serviceItem,
    required this.serviceColor,
  });

  @override
  State<EmployeeSearchList> createState() => _EmployeeSearchListState();
}

class _EmployeeSearchListState extends State<EmployeeSearchList> {
  final TextEditingController _searchController = TextEditingController();
  List<Employee> _filteredEmployees = [];
  List<Employee> _searchedEmployees = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredEmployees = widget.employees;
    _searchedEmployees = [];
  }

  void _searchEmployees(String query) {
    setState(() {
      _searchQuery = query;

      if (query.isEmpty) {
        _searchedEmployees = [];
        _filteredEmployees = widget.employees;
      } else {
        _searchedEmployees = widget.employees
            .where(
              (employee) =>
                  employee.name.toLowerCase().contains(query.toLowerCase()) ||
                  employee.specialty.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  employee.skills.any(
                    (skill) =>
                        skill.toLowerCase().contains(query.toLowerCase()),
                  ),
            )
            .toList();

        // إظهار الموظفين الذين تم البحث عنهم في الأعلى
        _filteredEmployees = [..._searchedEmployees];

        // إضافة باقي الموظفين بعد النتائج
        final otherEmployees = widget.employees
            .where((employee) => !_searchedEmployees.contains(employee))
            .toList();
        _filteredEmployees.addAll(otherEmployees);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // شريط البحث
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(Icons.search, color: Colors.grey[500], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _searchEmployees,
                          decoration: const InputDecoration(
                            hintText: 'ابحث عن موظف بالاسم أو التخصص...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.grey[500],
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _searchEmployees('');
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // عدد النتائج
        if (_searchQuery.isNotEmpty && _searchedEmployees.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.blue[50],
            child: Row(
              children: [
                Icon(Icons.search, color: widget.serviceColor, size: 16),
                const SizedBox(width: 8),
                Text(
                  'تم العثور على ${_searchedEmployees.length} موظف',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.serviceColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

        // قائمة الموظفين
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredEmployees.length,
            itemBuilder: (context, index) {
              final employee = _filteredEmployees[index];
              final isSearched = _searchedEmployees.contains(employee);

              return _buildEmployeeListItem(
                employee,
                widget.serviceItem,
                isSearched: isSearched,
                searchQuery: _searchQuery,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeListItem(
    Employee employee,
    ServiceItem serviceItem, {
    bool isSearched = false,
    String searchQuery = '',
  }) {
    final bool isHighlighted = isSearched && searchQuery.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isHighlighted ? Colors.blue[50] : Colors.white,
      elevation: isHighlighted ? 3 : 2,
      child: Container(
        decoration: isHighlighted
            ? BoxDecoration(
                border: Border.all(color: widget.serviceColor, width: 2),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isHighlighted
                  ? widget.serviceColor.withOpacity(0.2)
                  : widget.serviceColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: isHighlighted
                  ? Border.all(color: widget.serviceColor, width: 1.5)
                  : null,
            ),
            child: Icon(
              Icons.person,
              color: isHighlighted ? widget.serviceColor : widget.serviceColor,
            ),
          ),
          title: Row(
            children: [
              if (isHighlighted)
                Icon(Icons.verified, color: widget.serviceColor, size: 16),
              if (isHighlighted) const SizedBox(width: 4),
              Expanded(
                child: Text(
                  employee.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isHighlighted ? widget.serviceColor : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.specialty,
                style: TextStyle(
                  color: isHighlighted ? widget.serviceColor : Colors.grey[600],
                ),
              ),
              Row(
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      index < employee.rating.floor()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 14,
                    );
                  }),
                  const SizedBox(width: 4),
                  Text(
                    '(${employee.rating})',
                    style: TextStyle(
                      fontSize: 12,
                      color: isHighlighted ? widget.serviceColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${employee.hourlyRate} د.ع/ساعة',
                style: TextStyle(
                  color: widget.serviceColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                '${employee.completedJobs} مهمة',
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              serviceItem.selectedEmployee = employee;
              serviceItem.additionalInfo =
                  'خدمة مدفوعة - ${widget.serviceItem.additionalInfo?.split(' - ')[1] ?? ''} - مع الموظف: ${employee.name} - معلقة';
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

// واجهة اختيار الموظف
class EmployeeSelectionDialog extends StatefulWidget {
  final String serviceName;
  final Color serviceColor;
  final List<Color> serviceGradient;
  final Function(Employee) onEmployeeSelected;

  const EmployeeSelectionDialog({
    super.key,
    required this.serviceName,
    required this.serviceColor,
    required this.serviceGradient,
    required this.onEmployeeSelected,
  });

  @override
  State<EmployeeSelectionDialog> createState() =>
      _EmployeeSelectionDialogState();
}

class _EmployeeSelectionDialogState extends State<EmployeeSelectionDialog> {
  List<Employee> _employees = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    // بيانات تجريبية للموظفين
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _employees = [
        Employee(
          id: '1',
          name: 'أحمد محمد',
          specialty: 'فني كهرباء',
          rating: 4.8,
          completedJobs: 127,
          imageUrl: '',
          skills: ['تركيب عدادات', 'صيانة لوحات', 'تمديدات'],
          hourlyRate: 25.0,
        ),
        Employee(
          id: '2',
          name: 'خالد إبراهيم',
          specialty: 'فني كهرباء متقدم',
          rating: 4.9,
          completedJobs: 203,
          imageUrl: '',
          skills: ['أنظمة الطاقة الشمسية', 'التحكم الذكي', 'الصيانة الوقائية'],
          hourlyRate: 35.0,
        ),
        Employee(
          id: '3',
          name: 'محمود علي',
          specialty: 'فني كهرباء منزلي',
          rating: 4.6,
          completedJobs: 89,
          imageUrl: '',
          skills: ['تركيب نقاط كهرباء', 'إصلاح أعطال', 'استشارات فنية'],
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
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'اختر الموظف المناسب',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.serviceColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'لخدمة: ${widget.serviceName}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _employees.length,
                  itemBuilder: (context, index) {
                    return _buildEmployeeCard(_employees[index]);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(Employee employee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                // صورة الموظف
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: widget.serviceColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: widget.serviceColor.withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    color: widget.serviceColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        employee.specialty,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      _buildRatingStars(employee.rating),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // المهارات
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: employee.skills
                  .map(
                    (skill) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.serviceColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.serviceColor,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 12),

            // الإحصائيات
            Row(
              children: [
                _buildStatItem('${employee.completedJobs}', 'مهمة مكتملة'),
                _buildStatItem('${employee.hourlyRate} د.ع/ساعة', 'السعر'),
              ],
            ),

            const SizedBox(height: 12),

            // زر الاختيار
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.serviceColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  widget.onEmployeeSelected(employee);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'اختيار هذا الموظف',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: [
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 4),
        ...List.generate(5, (index) {
          return Icon(
            index < rating.floor() ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 16,
          );
        }),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

// واجهة تقييم الموظف
class EmployeeRatingDialog extends StatefulWidget {
  final String employeeName;
  final String serviceName;
  final Color serviceColor;

  const EmployeeRatingDialog({
    super.key,
    required this.employeeName,
    required this.serviceName,
    required this.serviceColor,
  });

  @override
  State<EmployeeRatingDialog> createState() => _EmployeeRatingDialogState();
}

class _EmployeeRatingDialogState extends State<EmployeeRatingDialog> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'تقييم الخدمة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.serviceColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'كيف كانت تجربتك مع ${widget.employeeName}؟',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // النجوم
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                    icon: Icon(
                      index < _rating.floor() ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // التعليق
            const Text(
              'تعليقك (اختياري):',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 3,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'اكتب تعليقك عن الخدمة...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // الأزرار
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
                    child: const Text('تخطي'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _rating > 0 ? _submitRating : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.serviceColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'إرسال التقييم',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating() {
    // حفظ التقييم في قاعدة البيانات
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('شكراً لك على تقييمك!')));
    Navigator.of(context).pop();
  }
}

// واجهة طلب الخدمة المميزة
class PremiumServiceRequestDialog extends StatefulWidget {
  final Color serviceColor;

  const PremiumServiceRequestDialog({super.key, required this.serviceColor});

  @override
  State<PremiumServiceRequestDialog> createState() =>
      _PremiumServiceRequestDialogState();
}

class _PremiumServiceRequestDialogState
    extends State<PremiumServiceRequestDialog> {
  final TextEditingController _serviceDescriptionController =
      TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
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

  void _submitPremiumRequest() {
    if (_serviceDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال وصف الخدمة المطلوبة')),
      );
      return;
    }

    // حفظ طلب الخدمة المميزة
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال طلبك! سيقدم الموظفون عروضهم خلال 24 ساعة.'),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'طلب خدمة مميزة',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: widget.serviceColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'صف الخدمة التي تحتاجها وسيقدم الموظفون عروضهم لك',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'وصف الخدمة المطلوبة:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _serviceDescriptionController,
                      maxLines: 5,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'صف بالتفصيل الخدمة التي تحتاجها...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'ميزانيتك التقريبية (اختياري):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _budgetController,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'المبلغ المتوقع',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixText: 'د.ع',
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
                      'إرفاق صور (للمساعدة في فهم المطلوب):',
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

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.serviceColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: widget.serviceColor.withOpacity(0.2),
                        ),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                            size: 30,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'كيف تعمل الخدمة المميزة:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '1. ستصل طلباتك للموظفين المختصين\n'
                            '2. سيقدم كل موظف عرضاً بالسعر والمدة\n'
                            '3. ستستلم العروض وتختار المناسب لك\n'
                            '4. الدفع بعد إتمام الخدمة بشكل مرضٍ',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                    onPressed: _submitPremiumRequest,
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
    );
  }
}

// نماذج البيانات للموظفين والتقييمات
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

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      completedJobs: map['completedJobs'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      hourlyRate: (map['hourlyRate'] ?? 0.0).toDouble(),
    );
  }
}

class EmployeeReview {
  final String id;
  final String employeeId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;
  final String serviceName;

  EmployeeReview({
    required this.id,
    required this.employeeId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.serviceName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'serviceName': serviceName,
    };
  }

  factory EmployeeReview.fromMap(Map<String, dynamic> map) {
    return EmployeeReview(
      id: map['id'] ?? '',
      employeeId: map['employeeId'] ?? '',
      userName: map['userName'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      serviceName: map['serviceName'] ?? '',
    );
  }
}

class PremiumServiceRequest {
  final String id;
  final String userId;
  final String serviceDescription;
  final String contactInfo;
  final String location;
  final List<String> images;
  final DateTime createdAt;
  final String status;
  final List<EmployeeOffer>? offers;

  PremiumServiceRequest({
    required this.id,
    required this.userId,
    required this.serviceDescription,
    required this.contactInfo,
    required this.location,
    required this.images,
    required this.createdAt,
    this.status = 'pending',
    this.offers,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'service_description': serviceDescription,
      'contact_info': contactInfo,
      'location': location,
      'images': images,
      'created_at': createdAt.toIso8601String(),
      'status': status,
      'offers': offers?.map((offer) => offer.toMap()).toList(),
    };
  }

  factory PremiumServiceRequest.fromMap(Map<String, dynamic> map) {
    return PremiumServiceRequest(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      serviceDescription: map['service_description'] ?? '',
      contactInfo: map['contact_info'] ?? '',
      location: map['location'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      createdAt: DateTime.parse(
        map['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      status: map['status'] ?? 'pending',
      offers: (map['offers'] as List<dynamic>?)
          ?.map((offer) => EmployeeOffer.fromMap(offer))
          .toList(),
    );
  }
}

class EmployeeOffer {
  final String id;
  final String employeeId;
  final String employeeName;
  final double price;
  final String duration;
  final String description;
  final DateTime createdAt;
  final String status;

  EmployeeOffer({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.price,
    required this.duration,
    required this.description,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'price': price,
      'duration': duration,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory EmployeeOffer.fromMap(Map<String, dynamic> map) {
    return EmployeeOffer(
      id: map['id'] ?? '',
      employeeId: map['employeeId'] ?? '',
      employeeName: map['employeeName'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      duration: map['duration'] ?? '',
      description: map['description'] ?? '',
      createdAt: DateTime.parse(
        map['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      status: map['status'] ?? 'pending',
    );
  }
}

class CustomServiceDialog extends StatefulWidget {
  final Color serviceColor;
  final String serviceType;

  const CustomServiceDialog({
    super.key,
    required this.serviceColor,
    required this.serviceType,
  });

  @override
  State<CustomServiceDialog> createState() => _CustomServiceDialogState();
}

class _CustomServiceDialogState extends State<CustomServiceDialog> {
  final TextEditingController _serviceDetailsController =
      TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
<<<<<<< Updated upstream
  final TextEditingController _budgetController = TextEditingController();
  List<XFile> _selectedImages = [];
=======
  final List<XFile> _selectedImages = [];

>>>>>>> Stashed changes
  final ImagePicker _picker = ImagePicker();

  List<Employee> _selectedEmployees = [];
  List<Employee> _availableEmployees = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableEmployees();
  }

  void _loadAvailableEmployees() {
    // تحميل الموظفين حسب نوع الخدمة
    if (widget.serviceType.contains('الكهرباء')) {
      _availableEmployees = [
        Employee(
          id: '1',
          name: 'أحمد محمد',
          specialty: 'فني كهرباء',
          rating: 4.8,
          completedJobs: 127,
          imageUrl: '',
          skills: ['تركيب عدادات', 'صيانة لوحات', 'تمديدات'],
          hourlyRate: 25.0,
        ),
        Employee(
          id: '2',
          name: 'خالد إبراهيم',
          specialty: 'فني كهرباء متقدم',
          rating: 4.9,
          completedJobs: 203,
          imageUrl: '',
          skills: ['أنظمة الطاقة الشمسية', 'التحكم الذكي', 'الصيانة الوقائية'],
          hourlyRate: 35.0,
        ),
        Employee(
          id: '3',
          name: 'محمود علي',
          specialty: 'فني كهرباء منزلي',
          rating: 4.6,
          completedJobs: 89,
          imageUrl: '',
          skills: ['تركيب نقاط كهرباء', 'إصلاح أعطال', 'استشارات فنية'],
          hourlyRate: 20.0,
        ),
        Employee(
          id: '4',
          name: 'سعيد حسن',
          specialty: 'فني كهرباء صناعي',
          rating: 4.7,
          completedJobs: 156,
          imageUrl: '',
          skills: ['المحركات الصناعية', 'أنظمة التحكم', 'الصيانة الدورية'],
          hourlyRate: 30.0,
        ),
        Employee(
          id: '5',
          name: 'علي كريم',
          specialty: 'فني إنارة',
          rating: 4.5,
          completedJobs: 78,
          imageUrl: '',
          skills: ['تصميم الإنارة', 'تركيب الثريات', 'أنظمة الإضاءة الذكية'],
          hourlyRate: 22.0,
        ),
      ];
    } else if (widget.serviceType.contains('الماء')) {
      _availableEmployees = [
        Employee(
          id: 'w1',
          name: 'محمد عبدالله',
          specialty: 'فني سباكة متخصص',
          rating: 4.8,
          completedJobs: 145,
          imageUrl: '',
          skills: ['تركيب عدادات المياه', 'كشف التسربات', 'تنظيف الخزانات'],
          hourlyRate: 28.0,
        ),
        Employee(
          id: 'w2',
          name: 'ياسر أحمد',
          specialty: 'خبير أنظمة المياه',
          rating: 4.9,
          completedJobs: 189,
          imageUrl: '',
          skills: ['أنظمة الري الذكية', 'تحلية المياه', 'معالجة المياه'],
          hourlyRate: 35.0,
        ),
        Employee(
          id: 'w3',
          name: 'حسن علي',
          specialty: 'فني صيانة خزانات',
          rating: 4.7,
          completedJobs: 112,
          imageUrl: '',
          skills: ['تعقيم الخزانات', 'عزل الخزانات', 'صيانة المضخات'],
          hourlyRate: 25.0,
        ),
        Employee(
          id: 'w4',
          name: 'عمر محمد',
          specialty: 'فني أنظمة الري',
          rating: 4.6,
          completedJobs: 98,
          imageUrl: '',
          skills: ['تصميم أنظمة الري', 'تركيب الرشاشات', 'صيانة الأنظمة'],
          hourlyRate: 22.0,
        ),
        Employee(
          id: 'w5',
          name: 'خالد سعيد',
          specialty: 'فني كشف تسربات',
          rating: 4.8,
          completedJobs: 167,
          imageUrl: '',
          skills: ['كشف التسربات بالأجهزة', 'إصلاح التسربات', 'تقارير فنية'],
          hourlyRate: 30.0,
        ),
      ];
    } else if (widget.serviceType.contains('النفايات')) {
      _availableEmployees = [
        Employee(
          id: 't1',
          name: 'ماجد راشد',
          specialty: 'خبير إدارة النفايات',
          rating: 4.7,
          completedJobs: 134,
          imageUrl: '',
          skills: ['إدارة النفايات', 'التدوير', 'النظافة العامة'],
          hourlyRate: 32.0,
        ),
        Employee(
          id: 't2',
          name: 'ناصر خليفة',
          specialty: 'فني نظافة متخصص',
          rating: 4.6,
          completedJobs: 178,
          imageUrl: '',
          skills: ['تنظيف المواقع', 'إزالة النفايات', 'التعقيم'],
          hourlyRate: 26.0,
        ),
        Employee(
          id: 't3',
          name: 'راشد سالم',
          specialty: 'فني تدوير النفايات',
          rating: 4.8,
          completedJobs: 95,
          imageUrl: '',
          skills: ['فصل النفايات', 'عمليات التدوير', 'التوعية البيئية'],
          hourlyRate: 28.0,
        ),
        Employee(
          id: 't4',
          name: 'سالم أحمد',
          specialty: 'مشرف نظافة',
          rating: 4.5,
          completedJobs: 156,
          imageUrl: '',
          skills: ['إدارة الفرق', 'التخطيط', 'الرقابة'],
          hourlyRate: 30.0,
        ),
        Employee(
          id: 't5',
          name: 'عبدالله محمد',
          specialty: 'فني معالجة النفايات',
          rating: 4.7,
          completedJobs: 122,
          imageUrl: '',
          skills: ['المعالجة البيئية', 'التخلص الآمن', 'الالتزام البيئي'],
          hourlyRate: 29.0,
        ),
      ];
    } else {
      // موظفين افتراضيين للخدمات الأخرى
      _availableEmployees = [
        Employee(
          id: 'g1',
          name: 'فني متعدد التخصصات',
          specialty: 'فني خدمات عامة',
          rating: 4.5,
          completedJobs: 100,
          imageUrl: '',
          skills: ['خدمات متنوعة', 'صيانة عامة', 'إصلاحات'],
          hourlyRate: 20.0,
        ),
        Employee(
          id: 'g2',
          name: 'محمد أحمد',
          specialty: 'فني خدمات متكاملة',
          rating: 4.6,
          completedJobs: 85,
          imageUrl: '',
          skills: ['صيانة منزلية', 'تركيب', 'إصلاح'],
          hourlyRate: 22.0,
        ),
      ];
    }
  }

  void _showEmployeeSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
        child: EmployeeSelectionBottomSheet(
          availableEmployees: _availableEmployees,
          selectedEmployees: _selectedEmployees,
          serviceColor: widget.serviceColor,
          onEmployeesSelected: (List<Employee> employees) {
            setState(() {
              _selectedEmployees = employees;
            });
            Navigator.pop(context); // إغلاق الـ Bottom Sheet
          },
        ),
      ),
    );
  }

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

    // إنشاء ServiceItem للخدمة المخصصة
    final customService = ServiceItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: 'خدمة مخصصة - ${widget.serviceType}',
      amount: 0.0, // سيتم تحديد السعر لاحقاً من خلال العروض
      color: widget.serviceColor,
      gradient: [widget.serviceColor, widget.serviceColor.withOpacity(0.7)],
      additionalInfo:
          'خدمة مخصصة - ${widget.serviceType} - معلقة - في انتظار العروض',
      selectedEmployee: null, // سيتم اختيار الموظف لاحقاً
    );

    // الحصول على Parent State لحفظ الخدمة
    final parentState = context
        .findAncestorStateOfType<_PaidServicesScreenState>();
    if (parentState != null) {
      parentState._saveCustomServiceRequest(customService);
    }

    Navigator.of(context).pop();
  }

  Widget _buildEmployeeSelectionButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'اختر الموظفين:',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _showEmployeeSelection,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: widget.serviceColor,
                ),
                Text(
                  _selectedEmployees.isEmpty
                      ? 'اختر الموظفين (حتى 5)'
                      : 'تم اختيار ${_selectedEmployees.length} موظف',
                  style: TextStyle(
                    color: _selectedEmployees.isEmpty
                        ? Colors.grey[600]
                        : widget.serviceColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.group, color: widget.serviceColor),
              ],
            ),
          ),
        ),
        if (_selectedEmployees.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'سيتم إرسال طلبك إلى ${_selectedEmployees.length} موظف',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              const Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'طلب خدمة مخصصة (دفع نقدي)',
                style: TextStyle(
                  fontSize: 18,
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

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'اختر الموظفين الذين تريد إرسال طلب الخدمة لهم',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // زر اختيار الموظفين
                _buildEmployeeSelectionButton(),
                const SizedBox(height: 20),

                // وصف الخدمة
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
                    hintText: 'صف بالتفصيل الخدمة التي تحتاجها...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'ميزانيتك التقريبية (اختياري):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _budgetController,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'المبلغ المتوقع',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixText: 'د.ع',
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
                  'إرفاق صور (للمساعدة في فهم المطلوب):',
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.serviceColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: widget.serviceColor.withOpacity(0.2),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 30),
                      SizedBox(height: 8),
                      Text(
                        'كيف تعمل الخدمة المخصصة:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '1. اختر حتى 5 موظفين ليرسل لهم طلبك\n'
                        '2. سيقدم كل موظف عرضاً بالسعر والمدة\n'
                        '3. ستستلم العروض وتختار المناسب لك\n'
                        '4. الدفع نقداً بعد إتمام الخدمة بشكل مرضٍ',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Footer Buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'إرسال الطلب',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EmployeeSelectionBottomSheet extends StatefulWidget {
  final List<Employee> availableEmployees;
  final List<Employee> selectedEmployees;
  final Color serviceColor;
  final Function(List<Employee>) onEmployeesSelected;

  const EmployeeSelectionBottomSheet({
    super.key,
    required this.availableEmployees,
    required this.selectedEmployees,
    required this.serviceColor,
    required this.onEmployeesSelected,
  });

  @override
  State<EmployeeSelectionBottomSheet> createState() =>
      _EmployeeSelectionBottomSheetState();
}

class _EmployeeSelectionBottomSheetState
    extends State<EmployeeSelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Employee> _filteredEmployees = [];
  List<Employee> _tempSelectedEmployees = [];

  @override
  void initState() {
    super.initState();
    _filteredEmployees = widget.availableEmployees;
    _tempSelectedEmployees = List.from(widget.selectedEmployees);
  }

  void _searchEmployees(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredEmployees = widget.availableEmployees;
      } else {
        _filteredEmployees = widget.availableEmployees
            .where(
              (employee) =>
                  employee.name.toLowerCase().contains(query.toLowerCase()) ||
                  employee.specialty.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  employee.skills.any(
                    (skill) =>
                        skill.toLowerCase().contains(query.toLowerCase()),
                  ),
            )
            .toList();
      }
    });
  }

  void _toggleEmployeeSelection(Employee employee) {
    setState(() {
      if (_tempSelectedEmployees.contains(employee)) {
        _tempSelectedEmployees.remove(employee);
      } else if (_tempSelectedEmployees.length < 5) {
        _tempSelectedEmployees.add(employee);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يمكنك اختيار 5 موظفين كحد أقصى')),
        );
      }
    });
  }

  void _confirmSelection() {
    widget.onEmployeesSelected(_tempSelectedEmployees);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              const Icon(Icons.group, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text(
                'اختر الموظفين',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '${_tempSelectedEmployees.length}/5',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        // Search Bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(Icons.search, color: Colors.grey[500], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _searchEmployees,
                          decoration: const InputDecoration(
                            hintText: 'ابحث عن موظف بالاسم أو التخصص...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.grey[500],
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _searchEmployees('');
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Selected Employees Count
        if (_tempSelectedEmployees.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.blue[50],
            child: Row(
              children: [
                Icon(Icons.check_circle, color: widget.serviceColor, size: 16),
                const SizedBox(width: 8),
                Text(
                  'تم اختيار ${_tempSelectedEmployees.length} موظف',
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.serviceColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

        // Employees List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredEmployees.length,
            itemBuilder: (context, index) {
              final employee = _filteredEmployees[index];
              final isSelected = _tempSelectedEmployees.contains(employee);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? widget.serviceColor : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                color: isSelected
                    ? widget.serviceColor.withOpacity(0.05)
                    : Colors.white,
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? widget.serviceColor.withOpacity(0.2)
                          : widget.serviceColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: widget.serviceColor, width: 1.5)
                          : null,
                    ),
                    child: Icon(
                      Icons.person,
                      color: isSelected
                          ? widget.serviceColor
                          : widget.serviceColor,
                    ),
                  ),
                  title: Text(
                    employee.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? widget.serviceColor : Colors.black,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.specialty,
                        style: TextStyle(
                          color: isSelected
                              ? widget.serviceColor
                              : Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < employee.rating.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 14,
                            );
                          }),
                          Text(
                            '(${employee.rating})',
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? widget.serviceColor
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${employee.hourlyRate} د.ع/ساعة',
                        style: TextStyle(
                          color: widget.serviceColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${employee.completedJobs} مهمة',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  onTap: () => _toggleEmployeeSelection(employee),
                ),
              );
            },
          ),
        ),

        // Confirm Button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _confirmSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.serviceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _tempSelectedEmployees.isEmpty
                    ? 'تخطي'
                    : 'تم الاختيار (${_tempSelectedEmployees.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// واجهة تقييم الخدمة بعد التنفيذ
class ServiceRatingDialog extends StatefulWidget {
  final String serviceName;
  final String employeeName;
  final Color serviceColor;
  final Function(double, String) onRatingSubmitted;

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
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.serviceColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 40),
                  const SizedBox(height: 10),
                  const Text(
                    'كيف كانت تجربتك؟',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'مع ${widget.employeeName}',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Service Info
            Text(
              'خدمة: ${widget.serviceName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Rating Stars
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                    icon: Icon(
                      index < _rating.floor() ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 10),
            Text(
              _rating == 0
                  ? 'اضغط على النجوم للتقييم'
                  : 'تقييمك: $_rating نجوم',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Comment
            const Text(
              'تعليقك (اختياري):',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 3,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'اكتب تعليقك عن الخدمة...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('تخطي'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _rating > 0 ? _submitRating : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.serviceColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'إرسال التقييم',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating() {
    widget.onRatingSubmitted(_rating, _commentController.text);
    Navigator.of(context).pop();
  }
}

// واجهة طلبات الخدمة المخصصة والرسائل
class CustomRequestsScreen extends StatefulWidget {
  final Color serviceColor;

  const CustomRequestsScreen({super.key, required this.serviceColor});

  @override
  State<CustomRequestsScreen> createState() => _CustomRequestsScreenState();
}

class _CustomRequestsScreenState extends State<CustomRequestsScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<CustomServiceRequest> _customRequests = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCustomRequests();
  }

  Future<void> _loadCustomRequests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('custom_service_requests')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      if (response != null) {
        setState(() {
          _customRequests = (response as List<dynamic>)
              .map((item) => CustomServiceRequest.fromMap(item))
              .toList();
        });
      }
    } catch (e) {
      print('Error loading custom requests: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: widget.serviceColor,
        title: const Text('طلباتي المخصصة'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _customRequests.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.request_quote, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد طلبات مخصصة',
                    style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadCustomRequests,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _customRequests.length,
                itemBuilder: (context, index) {
                  return _buildRequestCard(_customRequests[index]);
                },
              ),
            ),
    );
  }

  Widget _buildRequestCard(CustomServiceRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Request Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.serviceColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.serviceColor.withOpacity(0.3),
                    ),
                  ),
                  child: Icon(Icons.description, color: widget.serviceColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.serviceDescription.length > 30
                            ? '${request.serviceDescription.substring(0, 30)}...'
                            : request.serviceDescription,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${request.offers.length} عروض',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(request.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Offers List
            if (request.offers.isNotEmpty) ...[
              const Text(
                'العروض المستلمة:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...request.offers.take(2).map((offer) => _buildOfferItem(offer)),
              if (request.offers.length > 2)
                TextButton(
                  onPressed: () => _showAllOffers(request),
                  child: Text('عرض ${request.offers.length - 2} عرض إضافي'),
                ),
            ],

            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showRequestDetails(request),
                    child: const Text('عرض التفاصيل'),
                  ),
                ),
                const SizedBox(width: 8),
                if (request.status == 'pending')
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.serviceColor,
                      ),
                      onPressed: () => _showOffersScreen(request),
                      child: const Text(
                        'عرض العروض',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferItem(EmployeeOffer offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: widget.serviceColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.person, color: widget.serviceColor, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.employeeName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${offer.price} د.ع - ${offer.duration}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          if (offer.status == 'accepted')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'مقبول',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'accepted':
        return 'مقبول';
      case 'pending':
        return 'قيد الانتظار';
      case 'completed':
        return 'مكتمل';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'غير معروف';
    }
  }

  void _showAllOffers(CustomServiceRequest request) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'جميع العروض (${request.offers.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...request.offers.map((offer) => _buildDetailedOfferItem(offer)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedOfferItem(EmployeeOffer offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.serviceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.person, color: widget.serviceColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.employeeName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      offer.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${offer.price} د.ع',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                offer.duration,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          if (offer.status == 'accepted')
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'مقبول',
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  void _showRequestDetails(CustomServiceRequest request) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'تفاصيل الطلب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                request.serviceDescription,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
              if (request.budget != null) ...[
                Text(
                  'الميزانية: ${request.budget} د.ع',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
              ],
              Text(
                'موقع التنفيذ: ${request.location}',
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOffersScreen(CustomServiceRequest request) {
    // سيتم تنفيذ شاشة عرض العروض وقبولها
  }
}

// نموذج طلب الخدمة المخصصة
class CustomServiceRequest {
  final String id;
  final String userId;
  final String serviceDescription;
  final String contactInfo;
  final String location;
  final double? budget;
  final List<String> images;
  final List<EmployeeOffer> offers;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CustomServiceRequest({
    required this.id,
    required this.userId,
    required this.serviceDescription,
    required this.contactInfo,
    required this.location,
    this.budget,
    required this.images,
    required this.offers,
    this.status = 'pending',
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'service_description': serviceDescription,
      'contact_info': contactInfo,
      'location': location,
      'budget': budget,
      'images': images,
      'offers': offers.map((offer) => offer.toMap()).toList(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory CustomServiceRequest.fromMap(Map<String, dynamic> map) {
    return CustomServiceRequest(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      serviceDescription: map['service_description'] ?? '',
      contactInfo: map['contact_info'] ?? '',
      location: map['location'] ?? '',
      budget: map['budget']?.toDouble(),
      images: List<String>.from(map['images'] ?? []),
      offers:
          (map['offers'] as List<dynamic>?)
              ?.map((offer) => EmployeeOffer.fromMap(offer))
              .toList() ??
          [],
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(
        map['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }
}

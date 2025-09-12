import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mang_mu/screens/citizen/screens/user_main_screen.dart';

// نموذج بيانات الخدمة
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

  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    return ServiceItem(
      id: map['id'].toString(),
      name: map['name'].toString(),
      amount: (map['amount'] is int)
          ? (map['amount'] as int).toDouble()
          : (map['amount'] as double),
      color: Color(
        map['color'] is String
            ? int.parse(map['color'])
            : (map['color'] as int),
      ),
      gradient: (map['gradient'] as List).map((c) {
        if (c is String) {
          return Color(int.parse(c));
        } else if (c is int) {
          return Color(c);
        } else {
          return Colors.blue;
        }
      }).toList(),
      additionalInfo: map['additionalInfo']?.toString(),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final List<ServiceItem> services;
  final Color primaryColor;
  final List<Color> primaryGradient;

  const PaymentScreen({
    super.key,
    required this.services,
    required this.primaryColor,
    required this.primaryGradient,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _serviceNameController = TextEditingController();
  final _serviceAmountController = TextEditingController();
  final _serviceInfoController = TextEditingController();

  // متغيرات جديدة لإدارة الخدمات
  bool _showAddServiceForm = false;
  List<ServiceItem> _allServices = [];
  List<ServiceItem> _selectedServices = [];

  // نظام النقاط
  final int _userPoints = 500;
  final double _pointsRate = 0.01;
  bool _usePoints = false;
  double _pointsDiscount = 0.0;
  double _finalAmount = 0.0;
  final DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _selectedServices = List.from(widget.services);
    _loadServicesFromSupabase();
    _finalAmount = _calculateTotalAmount();
    _calculatePointsDiscount();
  }

  // دالة لتحميل الخدمات من Supabase
  Future<void> _loadServicesFromSupabase() async {
    try {
      final response = await Supabase.instance.client
          .from('services')
          .select()
          .order('created_at', ascending: false);

      if (response != null && response is List) {
        setState(() {
          _allServices = response
              .map((item) => ServiceItem.fromMap(item))
              .toList();
        });
      }
    } catch (e) {
      print('Exception loading services: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل في تحميل الخدمات: $e')));
    }
  }

  Future<void> _saveServiceToSupabase(ServiceItem service) async {
    try {
      final response = await Supabase.instance.client
          .from('services')
          .insert(service.toMap());

      if (response != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم حفظ الخدمة بنجاح')));
        _loadServicesFromSupabase();
      } else {
        print('Error: Insert returned null');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل في حفظ الخدمة')));
      }
    } catch (e) {
      print('Exception saving service: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل في حفظ الخدمة: $e')));
    }
  }

  double _calculateTotalAmount() {
    return _selectedServices.fold(0.0, (sum, service) => sum + service.amount);
  }

  void _calculatePointsDiscount() {
    _pointsDiscount = _userPoints * _pointsRate;
    if (_pointsDiscount > _calculateTotalAmount()) {
      _pointsDiscount = _calculateTotalAmount();
    }
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _serviceAmountController.dispose();
    _serviceInfoController.dispose();
    super.dispose();
  }

  void _updateFinalAmount() {
    double amount = _calculateTotalAmount();

    if (_usePoints) {
      amount -= _pointsDiscount;
      if (amount < 0) amount = 0;
    }

    setState(() {
      _finalAmount = amount;
    });
  }

  // دالة لإضافة خدمة جديدة
  void _addNewService() {
    final name = _serviceNameController.text.trim();
    final amountText = _serviceAmountController.text.trim();
    final info = _serviceInfoController.text.trim();

    if (name.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال اسم الخدمة والمبلغ')),
      );
      return;
    }

    final amount = double.tryParse(amountText) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('المبلغ يجب أن يكون أكبر من صفر')),
      );
      return;
    }

    final newService = ServiceItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      amount: amount,
      color: Colors.blue,
      gradient: [Colors.blue, Colors.lightBlue],
      additionalInfo: info.isNotEmpty ? info : null,
    );

    // حفظ الخدمة في Supabase
    _saveServiceToSupabase(newService);

    // إضافة الخدمة إلى القائمة المختارة
    setState(() {
      _selectedServices.add(newService);
      _showAddServiceForm = false;
      _serviceNameController.clear();
      _serviceAmountController.clear();
      _serviceInfoController.clear();
      _updateFinalAmount();
    });
  }

  // دالة لإزالة خدمة من القائمة المختارة
  void _removeService(ServiceItem service) {
    setState(() {
      _selectedServices.remove(service);
      _updateFinalAmount();
    });
  }

  // دالة لاختيار خدمة من القائمة المتاحة
  void _selectService(ServiceItem service) {
    setState(() {
      if (!_selectedServices.contains(service)) {
        _selectedServices.add(service);
        _updateFinalAmount();
      }
    });
  }

  // دالة جديدة لحذف الخدمة من Supabase
  Future<void> _deleteServiceFromSupabase(ServiceItem service) async {
    try {
      final response = await Supabase.instance.client
          .from('services')
          .delete()
          .eq('id', service.id);

      if (response != null) {
        // إعادة تحميل الخدمات لتحديث القائمة
        _loadServicesFromSupabase();
      }
    } catch (e) {
      print('Exception deleting service: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل في حذف الخدمة: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق'),
        backgroundColor: widget.primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عرض قائمة الخدمات في السلة
            _buildServicesList(),
            const SizedBox(height: 20),

            // زر إضافة خدمة جديدة
            _buildAddServiceSection(),

            // زر الانتقال إلى شاشة الدفع
            _buildProceedToPaymentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 16.0, bottom: 16.0),
          child: Text(
            'سلة الخدمات',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),

        if (_allServices.isNotEmpty) ...[
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _allServices.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final service = _allServices[index];
              final isSelected = _selectedServices.contains(service);

              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    _removeService(service);
                  } else {
                    _selectService(service);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: 130,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? service.color.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? service.color : Colors.grey[200]!,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // التصميم الدائري الخلفي
                      Positioned(
                        left: -25,
                        top: 20,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: service.color.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      // الشريط الجانبي الملون مع تأثير متدرج
                      Positioned(
                        right: 1.1,
                        top: 1,
                        bottom: 2,
                        child: Container(
                          width: 10,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                service.color.withOpacity(0.8),
                                service.color,
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),

                      // محتوى البطاقة
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            // أيقونة الخدمة مع تأثير الظل
                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: service.color.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _getServiceIcon(service.name),
                                color: service.color,
                                size: 30,
                              ),
                            ),

                            const SizedBox(width: 18),

                            // معلومات الخدمة
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    service.name,
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey[800],
                                      letterSpacing: -0.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    '${service.amount.toStringAsFixed(2)} د.ع',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: service.color,
                                    ),
                                  ),

                                  if (service.additionalInfo != null) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      service.additionalInfo!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        height: 1.1,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // زر التحديد مع تأثير الظل
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? service.color
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? service.color
                                      : Colors.grey[400]!,
                                  width: isSelected ? 0 : 2,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: service.color.withOpacity(0.5),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ] else ...[
          // تصميم السلة الفارغة
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // أيقونة السلة الفارغة
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 50,
                    color: Colors.deepPurple[300],
                  ),
                ),

                const SizedBox(height: 20),

                // نص السلة الفارغة
                const Text(
                  'سلة الخدمات فارغة',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 10),

                // نص توضيحي
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    'لم تقم بإضافة أي خدمة بعد. قم باختيار الخدمات التي تحتاجها من القائمة أعلاه',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // دالة مساعدة للحصول على الأيقونة المناسبة لكل خدمة
  IconData _getServiceIcon(String serviceName) {
    if (serviceName.contains('عدادات')) return Icons.speed;
    if (serviceName.contains('نفايات')) return Icons.delete;
    if (serviceName.contains('تدوير')) return Icons.recycling;
    if (serviceName.contains('تنظيف')) return Icons.clean_hands;
    return Icons.home_repair_service;
  }

  Widget _buildServicesList() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الخدمات المختارة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (_selectedServices.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'لا توجد خدمات مختارة',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ..._selectedServices
                .map((service) => _buildServiceItem(service))
                .toList(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الإجمالي:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_calculateTotalAmount().toStringAsFixed(2)} د.ع',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(ServiceItem service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: service.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: service.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: service.color,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (service.additionalInfo != null)
                  Text(
                    service.additionalInfo!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
          Text(
            '${service.amount.toStringAsFixed(2)} د.ع',
            style: TextStyle(fontWeight: FontWeight.bold, color: service.color),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: () => _removeService(service),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountOption({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: value ? color : Colors.grey[300]!, width: 1),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: value ? color : Colors.black,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: color,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? widget.primaryColor : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProceedToPaymentButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        onPressed: () {
          if (_selectedServices.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('الرجاء إضافة خدمة على الأقل')),
            );
            return;
          }

          // الانتقال إلى شاشة الدفع
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentMethodsScreen(
                services: _selectedServices,
                primaryColor: widget.primaryColor,
                primaryGradient: widget.primaryGradient,
                finalAmount: _finalAmount,
                usePoints: _usePoints,
                pointsDiscount: _pointsDiscount,
                onPaymentSuccess: () {
                  // عند نجاح الدفع، نعيد تحميل الخدمات لتحديث القائمة
                  _loadServicesFromSupabase();
                  setState(() {
                    _selectedServices.clear();
                  });
                },
              ),
            ),
          );
        },
        child: const Text(
          'الانتقال إلى الدفع',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

// شاشة جديدة لاختيار طريقة الدفع
class PaymentMethodsScreen extends StatefulWidget {
  final List<ServiceItem> services;
  final Color primaryColor;
  final List<Color> primaryGradient;
  final double finalAmount;
  final bool usePoints;
  final double pointsDiscount;
  final VoidCallback? onPaymentSuccess;

  const PaymentMethodsScreen({
    super.key,
    required this.services,
    required this.primaryColor,
    required this.primaryGradient,
    required this.finalAmount,
    required this.usePoints,
    required this.pointsDiscount,
    this.onPaymentSuccess,
  });

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selectedMethod = '';

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'visa',
      'name': 'بطاقة فيزا',
      'icon': Icons.credit_card,
      'color': Colors.blue,
      'type': 'card',
    },
    {
      'id': 'mastercard',
      'name': 'بطاقة ماستركارد',
      'icon': Icons.credit_card,
      'color': Colors.red,
      'type': 'card',
    },
    {
      'id': 'asiapay',
      'name': 'AsiaPay',
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
      'type': 'wallet',
    },
    {
      'id': 'zain_cash',
      'name': 'زين كاش',
      'icon': Icons.phone_iphone,
      'color': Colors.purple,
      'type': 'wallet',
    },
    {
      'id': 'bank_transfer',
      'name': 'التحويل البنكي',
      'icon': Icons.account_balance,
      'color': Colors.blueGrey,
      'type': 'bank',
    },
    {
      'id': 'alrafidain',
      'name': 'الرافدين',
      'icon': Icons.account_balance,
      'color': Colors.orange,
      'type': 'bank',
    },
    {
      'id': 'alrasheed',
      'name': 'الرشيد',
      'icon': Icons.account_balance,
      'color': Colors.teal,
      'type': 'bank',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طرق الدفع'),
        backgroundColor: widget.primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ملخص الطلب
          _buildOrderSummary(),

          // قائمة طرق الدفع
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('البطاقات المصرفية'),
                  _buildPaymentMethodsGrid('card'),

                  const SizedBox(height: 24),
                  _buildSectionTitle('المحافظ الإلكترونية'),
                  _buildPaymentMethodsGrid('wallet'),

                  const SizedBox(height: 24),
                  _buildSectionTitle('الدفع الرقمي'),
                  _buildPaymentMethodsGrid('digital'),

                  const SizedBox(height: 24),
                  _buildSectionTitle('طرق الدفع الأخرى'),
                  _buildOtherPaymentMethods(),
                ],
              ),
            ),
          ),

          // زر تأكيد الدفع
          _buildPayButton(),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.shopping_cart,
              color: widget.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المبلغ الإجمالي',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  '${widget.finalAmount.toStringAsFixed(2)} د.ع',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${widget.services.length} خدمة',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsGrid(String type) {
    final filteredMethods = _paymentMethods
        .where((method) => method['type'] == type)
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: filteredMethods.length,
      itemBuilder: (context, index) {
        final method = filteredMethods[index];
        return _buildPaymentMethodCard(method);
      },
    );
  }

  Widget _buildOtherPaymentMethods() {
    return Column(
      children: [
        _buildPaymentMethodListTile(
          title: 'التحويل البنكي',
          subtitle: 'تحويل مباشر إلى حسابنا',
          icon: Icons.account_balance,
          color: Colors.blueGrey,
          methodId: 'bank_transfer',
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final isSelected = _selectedMethod == method['id'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = method['id'];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected
              ? widget.primaryColor.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? widget.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // محتوى البطاقة في منتصف الحاوية
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: method['color'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      method['icon'],
                      color: method['color'],
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      method['name'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? widget.primaryColor
                            : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // أيقونة الاختيار في الزاوية
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: widget.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String methodId,
  }) {
    final isSelected = _selectedMethod == methodId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = methodId;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? widget.primaryColor.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? widget.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? widget.primaryColor : Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: isSelected ? widget.primaryColor : Colors.grey[600],
            ),
          ),
          trailing: isSelected
              ? Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: widget.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 16, color: Colors.white),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
          ),
          onPressed: _selectedMethod.isEmpty
              ? null
              : () {
                  _processPayment();
                },
          child: const Text(
            'تأكيد الدفع',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _processPayment() {
    if (_selectedMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار طريقة الدفع')),
      );
      return;
    }

    // الانتقال إلى شاشة تفاصيل الدفع حسب الطريقة المختارة
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentDetailsScreen(
          paymentMethod: _paymentMethods.firstWhere(
            (method) => method['id'] == _selectedMethod,
          ),
          services: widget.services,
          finalAmount: widget.finalAmount,
          primaryColor: widget.primaryColor,
          primaryGradient: widget.primaryGradient,
          onPaymentSuccess: widget.onPaymentSuccess,
          usePoints: widget.usePoints, // إضافة هذا
          pointsDiscount: widget.pointsDiscount, // إضافة هذا
          userPoints: 500, // يمكنك استبدال هذا بقيمة حقيقية من قاعدة البيانات
        ),
      ),
    );
  }
}

// شاشة تفاصيل الدفع
class PaymentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> paymentMethod;
  final List<ServiceItem> services;
  final double finalAmount;
  final Color primaryColor;
  final List<Color> primaryGradient;
  final VoidCallback? onPaymentSuccess;
  final bool usePoints;
  final double pointsDiscount;
  final int userPoints;

  const PaymentDetailsScreen({
    super.key,
    required this.paymentMethod,
    required this.services,
    required this.finalAmount,
    required this.primaryColor,
    required this.primaryGradient,
    this.onPaymentSuccess,
    required this.usePoints,
    required this.pointsDiscount,
    required this.userPoints,
  });

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الدفع بـ ${widget.paymentMethod['name']}'),
        backgroundColor: widget.primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ملخص الطلب
            _buildOrderSummary(),

            const SizedBox(height: 24),

            // نموذج الدفع
            _buildPaymentForm(),

            const SizedBox(height: 24),

            // زر تأكيد الدفع
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملخص الطلب',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...widget.services.map(
              (service) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(service.name),
                    Text('${service.amount.toStringAsFixed(2)} د.ع'),
                  ],
                ),
              ),
            ),
            const Divider(),
            if (widget.usePoints) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('خصم النقاط (${widget.userPoints} نقطة)'),
                  Text('-${widget.pointsDiscount.toStringAsFixed(2)} د.ع'),
                ],
              ),
              const Divider(),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'المبلغ الإجمالي:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${widget.finalAmount.toStringAsFixed(2)} د.ع',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    final methodType = widget.paymentMethod['type'];

    if (methodType == 'card') {
      return _buildCardForm();
    } else if (methodType == 'wallet') {
      return _buildWalletForm();
    } else if (methodType == 'bank') {
      return _buildBankTransferForm();
    } else {
      return _buildDigitalForm();
    }
  }

  Widget _buildCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'معلومات البطاقة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cardNumberController,
          decoration: const InputDecoration(
            labelText: 'رقم البطاقة',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.credit_card),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'تاريخ الانتهاء (MM/YY)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'اسم حامل البطاقة',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'معلومات المحفظة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'رقم الهاتف',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'البريد الإلكتروني',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildBankTransferForm() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معلومات التحويل البنكي',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        ListTile(
          leading: Icon(Icons.info, color: Colors.blue),
          title: Text('اسم البنك: الرافدين'),
          subtitle: Text('رقم الحساب: 1234567890'),
        ),
        ListTile(
          leading: Icon(Icons.info, color: Colors.blue),
          title: Text('اسم المستفيد: بلدية الكوت'),
          subtitle: Text('IBAN: IQ12 RAFD 1234 5678 9012 3456'),
        ),
      ],
    );
  }

  Widget _buildDigitalForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'معلومات الدفع',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'رقم الهاتف',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'البريد الإلكتروني',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        onPressed: _isProcessing ? null : _processPayment,
        child: _isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'تأكيد الدفع',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // محاكاة عملية الدفع
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
    });

    // عرض الفاتورة في شاشة منبثقة
    _showInvoiceDialog();
  }

  void _showInvoiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // رأس الفاتورة
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'تم الدفع بنجاح',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(),

                // تفاصيل الفاتورة
                const Text(
                  'تفاصيل الفاتورة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                // رقم الفاتورة
                _buildInvoiceDetailRow(
                  'رقم الفاتورة',
                  '#${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                ),

                // تاريخ الدفع
                _buildInvoiceDetailRow(
                  'تاريخ الدفع',
                  DateFormat('yyyy/MM/dd - HH:mm').format(DateTime.now()),
                ),

                // طريقة الدفع
                _buildInvoiceDetailRow(
                  'طريقة الدفع',
                  widget.paymentMethod['name'],
                ),

                const SizedBox(height: 16),
                const Divider(),

                // المبلغ الإجمالي
                _buildInvoiceDetailRow(
                  'المبلغ الإجمالي',
                  '${widget.finalAmount.toStringAsFixed(2)} د.ع',
                  isTotal: true,
                ),

                const SizedBox(height: 24),

                // زر الموافقة
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (widget.onPaymentSuccess != null) {
                        widget.onPaymentSuccess!();
                      }
                      Navigator.pushReplacementNamed(
                        context,
                        UserMainScreen.screenRoot,
                      );
                    },
                    child: const Text(
                      'حسناً',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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

  Widget _buildInvoiceDetailRow(
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? widget.primaryColor : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: PaymentScreen(
        services: [
          ServiceItem(
            id: '1',
            name: 'خدمة المياه',
            amount: 25000,
            color: Colors.blue,
            gradient: [Colors.blue, Colors.lightBlue],
          ),
          ServiceItem(
            id: '2',
            name: 'خدمة الكهرباء',
            amount: 35000,
            color: Colors.orange,
            gradient: [Colors.orange, Colors.deepOrange],
          ),
        ],
        primaryColor: Colors.blue,
        primaryGradient: [Colors.blue, Colors.lightBlue],
      ),
    ),
  );
}

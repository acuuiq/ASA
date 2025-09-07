import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      // حول قيمة اللون من رقم إلى نص
      'color': color.value.toString(), // التغيير هنا
      'gradient': gradient
          .map((c) => c.value.toString())
          .toList(), // والتغيير هنا أيضًا
      'additionalInfo': additionalInfo,
    };
  }

  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    return ServiceItem(
      id: map['id'].toString(), // تأكد من تحويل إلى نص
      name: map['name'].toString(),
      amount: (map['amount'] is int)
          ? (map['amount'] as int).toDouble()
          : (map['amount'] as double),
      // التعامل مع قيم اللون سواء كانت نصاً أو رقماً
      color: Color(
        map['color'] is String
            ? int.parse(map['color'])
            : (map['color'] as int),
      ),
      // التعامل مع قائمة التدرج بأنواع مختلفة
      gradient: (map['gradient'] as List).map((c) {
        if (c is String) {
          return Color(int.parse(c));
        } else if (c is int) {
          return Color(c);
        } else {
          return Colors.blue; // قيمة افتراضية في حالة الخطأ
        }
      }).toList(),
      additionalInfo: map['additionalInfo']?.toString(),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final List<ServiceItem> services; // قائمة الخدمات بدلاً من خدمة واحدة
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
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ibanController = TextEditingController();
  final _friendIdController = TextEditingController();

  // متحكمات جديدة لإضافة الخدمات يدوياً
  final _serviceNameController = TextEditingController();
  final _serviceAmountController = TextEditingController();
  final _serviceInfoController = TextEditingController();

  // متغيرات الدفع عن صديق
  bool _payForFriend = false;
  String _friendName = '';
  bool _isFriendVerified = false;
  String _selectedPaymentMethod = '';
  String _selectedPaymentOption = '';
  bool _showPaymentForm = false;
  bool _isEarlyPayment = false;
  bool _usePoints = false;
  double _discountAmount = 0.0;
  double _pointsDiscount = 0.0;
  double _finalAmount = 0.0;
  final DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  // متغيرات جديدة لإدارة الخدمات
  bool _showAddServiceForm = false;
  List<ServiceItem> _allServices = []; // جميع الخدمات المتاحة
  List<ServiceItem> _selectedServices = []; // الخدمات المختارة

  // نظام النقاط
  final int _userPoints = 500;
  final double _pointsRate = 0.01;

  // تعريف قائمة فئات الدفع
  final List<Map<String, dynamic>> _paymentCategories = [
    {
      'title': 'البطاقات المصرفية',
      'icon': Icons.credit_card,
      'options': [
        {
          'name': 'بطاقة فيزا',
          'icon': Icons.credit_card,
          'color': Colors.blue,
          'form': 'credit_card',
        },
        {
          'name': 'بطاقة ماستركارد',
          'icon': Icons.credit_card,
          'color': Colors.red,
          'form': 'credit_card',
        },
      ],
    },
    {
      'title': 'المحافظ الإلكترونية',
      'icon': Icons.account_balance_wallet,
      'options': [
        {
          'name': 'زين كاش',
          'icon': Icons.phone_android,
          'color': Colors.purple,
          'form': 'wallet',
        },
        {
          'name': 'AsiaPay',
          'icon': Icons.payment,
          'color': Colors.green,
          'form': 'wallet',
        },
      ],
    },
    {
      'title': 'التحويل البنكي',
      'icon': Icons.account_balance,
      'options': [
        {
          'name': 'الرافدين',
          'icon': Icons.account_balance,
          'color': Colors.orange,
          'form': 'bank_transfer',
        },
        {
          'name': 'الرشيد',
          'icon': Icons.account_balance,
          'color': Colors.blueGrey,
          'form': 'bank_transfer',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedServices = List.from(widget.services);
    _loadServicesFromSupabase();
    _finalAmount = _calculateTotalAmount();
    _calculatePointsDiscount();
  }

  // دالة لتحميل الخدمات من Supabase - الإصدار المصحح
  // دالة لتحميل الخدمات من Supabase - بدون execute
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

      // في الإصدارات الحديثة، الإدراج الناجح يرجع البيانات المُدرجة
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
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _accountNumberController.dispose();
    _ibanController.dispose();
    _friendIdController.dispose();
    _serviceNameController.dispose();
    _serviceAmountController.dispose();
    _serviceInfoController.dispose();
    super.dispose();
  }

  void _verifyFriend() async {
    if (_friendIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقم هاتف الصديق')),
      );
      return;
    }

    // محاكاة التحقق من الخادم
    setState(() {
      _isFriendVerified = true;
      _friendName = 'أحمد محمد'; // سيتم استبدالها بالقيمة الفعلية من API
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تم التحقق من $_friendName')));
  }

  void _updateFinalAmount() {
    double amount = _calculateTotalAmount();

    if (_isEarlyPayment) {
      amount -= _discountAmount;
    }

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
      color: Colors.blue, // لون افتراضي
      gradient: [Colors.blue, Colors.lightBlue], // تدرج افتراضي
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

  @override
  Widget build(BuildContext context) {
    final totalAmount = _calculateTotalAmount();

    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق والدفع'),
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

            _buildInvoiceSummary(totalAmount),
            const SizedBox(height: 30),

            if (!_showPaymentForm) ...[
              const Text(
                'اختر طريقة الدفع',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'اختر طريقة الدفع المفضلة لديك',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              _buildPaymentMethods(),
            ],

            if (_showPaymentForm) ...[
              InkWell(
                onTap: () {
                  setState(() {
                    _showPaymentForm = false;
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: widget.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'العودة لطرق الدفع',
                      style: TextStyle(
                        color: widget.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'معلومات الدفع عبر $_selectedPaymentOption',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'الرجاء إدخال المعلومات المطلوبة للدفع',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              _buildPaymentForm(),
              const SizedBox(height: 30),
              _buildPayButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عرض الخدمات المتاحة للاختيار
        if (_allServices.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'الخدمات المتاحة',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _allServices.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
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
                child: Container(
                  height: 100, // ارتفاع أكبر للمستطيل
                  decoration: BoxDecoration(
                    color: isSelected
                        ? service.color.withOpacity(0.15)
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? service.color : Colors.grey[300]!,
                      width: isSelected ? 2.0 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // تدرج لوني خلفي - تم تكبيره وتمديده
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 100, // عرض أكبر للتدرج
                          height: 100, // ارتفاع مساوي لارتفاع المستطيل
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            gradient: LinearGradient(
                              colors: service.gradient,
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          service.name,
                                          style: TextStyle(
                                            fontSize: 18, // حجم نص أكبر
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? service.color
                                                : Colors.grey[800],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          color: service.color,
                                          size: 24, // حجم أيقونة أكبر
                                        ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    '${service.amount.toStringAsFixed(2)} د.ع',
                                    style: TextStyle(
                                      fontSize: 20, // حجم نص أكبر للسعر
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? service.color
                                          : widget.primaryColor,
                                    ),
                                  ),

                                  if (service.additionalInfo != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      service.additionalInfo!,
                                      style: TextStyle(
                                        fontSize:
                                            16, // حجم نص أكبر للمعلومات الإضافية
                                        color: Colors.grey[600],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ],
                              ),
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
          const SizedBox(height: 20),
        ],
      ],
    );
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
            child: Icon(Icons.check, color: Colors.white, size: 20),
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

  Widget _buildInvoiceSummary(double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            widget.primaryColor.withOpacity(0.1),
            widget.primaryGradient[1].withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المبلغ المستحق:', style: TextStyle(fontSize: 16)),
              Text(
                '${totalAmount.toStringAsFixed(2)} د.ع',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: widget.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(height: 1),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('عدد الخدمات:'),
              Text(
                '${_selectedServices.length} خدمة',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('تاريخ الاستحقاق:'),
              Text(
                DateFormat('yyyy-MM-dd').format(_dueDate),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // خيارات الخصم والدفع بالنقاط
          if (_userPoints > 0) ...[
            const SizedBox(height: 15),
            const Divider(height: 1),
            const SizedBox(height: 15),

            // خيار الدفع المبكر لجميع الخدمات
            _buildDiscountOption(
              title: 'الدفع المبكر (خصم 10%)',
              value: _isEarlyPayment,
              onChanged: (value) {
                setState(() {
                  _isEarlyPayment = value!;
                  if (_isEarlyPayment) {
                    _discountAmount = totalAmount * 0.1;
                  } else {
                    _discountAmount = 0.0;
                  }
                  _updateFinalAmount();
                });
              },
              icon: Icons.alarm,
              color: Colors.blue,
            ),

            // خيار الدفع بالنقاط
            _buildDiscountOption(
              title:
                  'استخدام النقاط (${_pointsDiscount.toStringAsFixed(2)} د.ع)',
              subtitle: 'لديك $_userPoints نقطة',
              value: _usePoints,
              onChanged: (value) {
                setState(() {
                  _usePoints = value!;
                  _updateFinalAmount();
                });
              },
              icon: Icons.star,
              color: Colors.amber,
            ),
          ],

          const SizedBox(height: 15),
          const Divider(height: 1),
          const SizedBox(height: 15),

          // تحسين واجهة الدفع عن صديق
          _buildPayForFriendSection(),

          const Divider(height: 1),
          const SizedBox(height: 15),

          // تفاصيل الخصومات
          if (_isEarlyPayment)
            _buildDetailRow(
              'خصم الدفع المبكر',
              '-${_discountAmount.toStringAsFixed(2)} د.ع',
            ),

          if (_usePoints)
            _buildDetailRow(
              'خصم النقاط',
              '-${_pointsDiscount.toStringAsFixed(2)} د.ع',
            ),

          // المبلغ النهائي
          _buildDetailRow(
            'المبلغ النهائي',
            '${_finalAmount.toStringAsFixed(2)} د.ع',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPayForFriendSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDiscountOption(
          title: 'الدفع عن صديق',
          value: _payForFriend,
          onChanged: (value) {
            setState(() {
              _payForFriend = value!;
              if (!_payForFriend) {
                _friendName = '';
                _isFriendVerified = false;
              }
            });
          },
          icon: Icons.group,
          color: const Color.fromARGB(255, 0, 86, 156),
        ),

        if (_payForFriend) ...[
          const SizedBox(height: 15),
          Text(
            'معلومات الصديق',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _friendIdController,
                  decoration: InputDecoration(
                    labelText: 'رقم هاتف أو معرف الصديق',
                    hintText: 'أدخل رقم الهاتف المسجل',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                onPressed: _verifyFriend,
                child: const Text('بحث', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),

          if (_isFriendVerified) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green[100]!),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _friendName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'رقم الهاتف: ${_friendIdController.text}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _isFriendVerified = false;
                        _friendName = '';
                      });
                    },
                  ),
                ],
              ),
            ),
          ] else if (_friendIdController.text.isNotEmpty &&
              !_isFriendVerified) ...[
            const SizedBox(height: 10),
            Text(
              'لم يتم العثور على صديق بهذا الرقم',
              style: TextStyle(color: Colors.red[600], fontSize: 14),
            ),
          ],

          const SizedBox(height: 10),
          Text(
            'سيتم خصم المبلغ من حسابك وإضافته لرصيد صديقك',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ],
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

  Widget _buildPaymentMethods() {
    return Column(
      children: _paymentCategories.map((category) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Icon(category['icon'], color: widget.primaryColor),
                  const SizedBox(width: 10),
                  Text(
                    category['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: category['options'].length,
              itemBuilder: (context, index) {
                final option = category['options'][index];
                return _buildPaymentOption(option);
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPaymentOption(Map<String, dynamic> option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = option['form'];
          _selectedPaymentOption = option['name'];
          _showPaymentForm = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: option['color'].withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(option['icon'], color: option['color']),
            ),
            const SizedBox(height: 8),
            Text(
              option['name'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    switch (_selectedPaymentMethod) {
      case 'credit_card':
        return _buildCreditCardForm();
      case 'wallet':
        return _buildWalletForm();
      case 'bank_transfer':
        return _buildBankTransferForm();
      default:
        return _buildCreditCardForm();
    }
  }

  Widget _buildCreditCardForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _cardNumberController,
            decoration: InputDecoration(
              labelText: 'رقم البطاقة',
              hintText: '1234 5678 9012 3456',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.credit_card),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال رقم البطاقة';
              }
              if (value.length < 16) {
                return 'رقم البطاقة يجب أن يكون 16 رقم';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _cardHolderController,
            decoration: InputDecoration(
              labelText: 'اسم صاحب البطاقة',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال اسم صاحب البطاقة';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(
                    labelText: 'تاريخ الانتهاء (MM/YY)',
                    hintText: '12/25',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال تاريخ الانتهاء';
                    }
                    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                      return 'الصيغة MM/YY';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال CVV';
                    }
                    if (value.length < 3) {
                      return 'CVV يجب أن يكون 3 أو 4 أرقام';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'رقم الهاتف',
              hintText: '07XX XXX XXXX',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال رقم الهاتف';
              }
              if (value.length < 10) {
                return 'رقم الهاتف يجب أن يكون 10 أرقام';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'كلمة المرور',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال كلمة المرور';
              }
              if (value.length < 6) {
                return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBankTransferForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _accountNumberController,
            decoration: InputDecoration(
              labelText: 'رقم الحساب',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.numbers),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال رقم الحساب';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _ibanController,
            decoration: InputDecoration(
              labelText: 'رقم IBAN',
              hintText: 'IQXX XXXX XXXX XXXX XXXX XXXX',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.code),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال رقم IBAN';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
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
        onPressed: _processPayment,
        child: const Text(
          'تأكيد الدفع',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  void _processPayment() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_payForFriend && !_isFriendVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء التحقق من هوية الصديق أولاً')),
        );
        return;
      }
      _showPaymentConfirmation();
    }
  }

  void _showPaymentConfirmation() {
    int pointsUsed = _usePoints ? (_pointsDiscount / _pointsRate).ceil() : 0;
    int pointsEarned =
        (_isEarlyPayment ? 100 : 50) + (_finalAmount * 0.1).ceil();
    if (_payForFriend && _isFriendVerified) {
      pointsEarned += 100; // نقاط إضافية للإحالة
    }
    int newPoints = _userPoints - pointsUsed + pointsEarned;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 5,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Icon(Icons.verified, size: 60, color: widget.primaryColor),
              const SizedBox(height: 20),
              const Text(
                'تأكيد الدفع',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'سيتم خصم مبلغ ${_finalAmount.toStringAsFixed(2)} د.ع عبر $_selectedPaymentOption',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('طريقة الدفع', _selectedPaymentOption),
                    const Divider(height: 15),
                    _buildDetailRow(
                      'المبلغ الأصلي',
                      '${_calculateTotalAmount().toStringAsFixed(2)} د.ع',
                    ),
                    if (_isEarlyPayment)
                      _buildDetailRow(
                        'خصم الدفع المبكر',
                        '-${_discountAmount.toStringAsFixed(2)} د.ع',
                      ),
                    if (_usePoints)
                      _buildDetailRow(
                        'خصم النقاط',
                        '-${_pointsDiscount.toStringAsFixed(2)} د.ع',
                      ),
                    if (_payForFriend && _isFriendVerified)
                      _buildDetailRow('الدفع عن', _friendName),
                    const Divider(height: 15),
                    _buildDetailRow(
                      'المبلغ النهائي',
                      '${_finalAmount.toStringAsFixed(2)} د.ع',
                      isTotal: true,
                    ),
                    if (_usePoints) ...[
                      const Divider(height: 15),
                      _buildDetailRow('النقاط المستخدمة', '$pointsUsed نقطة'),
                    ],
                    const Divider(height: 15),
                    _buildDetailRow(
                      'التاريخ',
                      DateFormat('yyyy-MM-dd – hh:mm a').format(DateTime.now()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: widget.primaryColor),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'إلغاء',
                        style: TextStyle(
                          color: widget.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _showPaymentSuccess(
                          newPoints,
                          pointsEarned,
                          pointsUsed,
                        );
                      },
                      child: const Text(
                        'تأكيد الدفع',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentSuccess(int newPoints, int pointsEarned, int pointsUsed) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 50, color: Colors.green),
                ),
                const SizedBox(height: 20),
                const Text(
                  'تم الدفع بنجاح',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'تم دفع ${_finalAmount.toStringAsFixed(2)} د.ع بنجاح',
                  style: const TextStyle(fontSize: 16),
                ),
                if (_isEarlyPayment)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'وفرت ${_discountAmount.toStringAsFixed(2)} د.ع بخصم الدفع المبكر',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (_usePoints)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'وفرت ${_pointsDiscount.toStringAsFixed(2)} د.ع باستخدام النقاط',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (_payForFriend && _isFriendVerified)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'تم الدفع عن $_friendName',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'ربحت $pointsEarned نقطة جديدة!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('طريقة الدفع', _selectedPaymentOption),
                      const Divider(height: 15),
                      _buildDetailRow(
                        'رقم المرجع',
                        'PAY-${DateTime.now().millisecondsSinceEpoch}',
                      ),
                      if (_usePoints) ...[
                        const Divider(height: 15),
                        _buildDetailRow('النقاط المستخدمة', '$pointsUsed نقطة'),
                      ],
                      if (_payForFriend && _isFriendVerified) ...[
                        const Divider(height: 15),
                        _buildDetailRow('مكافأة الإحالة', '+100 نقطة'),
                      ],
                      const Divider(height: 15),
                      _buildDetailRow('النقاط المكتسبة', '+$pointsEarned نقطة'),
                      const Divider(height: 15),
                      _buildDetailRow(
                        'النقاط الإجمالية',
                        '$newPoints نقطة',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
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
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mang_mu/screens/citizen/screens/user_main_screen.dart';
import 'points_service.dart'; // Make sure this import is correct
import 'dart:async'; // أضف هذا الاستيراد

// نموذج بيانات الخدمة
class ServiceItem {
  final String id;
  final String name;
  final double amount;
  final Color color;
  final List<Color> gradient;
  final String? additionalInfo;
  bool isSelected;

  ServiceItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.color,
    required this.gradient,
    this.additionalInfo,
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'color': color.value.toString(),
      'gradient': gradient.map((c) => c.value.toString()).toList(),
      'additionalInfo': additionalInfo,
      'isSelected': isSelected,
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
      isSelected: map['isSelected'] ?? false,
    );
  }
}

class PaymentScreen extends StatefulWidget {
  static const String screen = 'payment_screen';

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

  // نظام النقاط - تم التحديث
  final PointsService _pointsService = PointsService();
  int _userPoints = 0;
  final double _pointsRate = 0.01;
  bool _usePoints = false;
  double _pointsDiscount = 0.0;
  double _finalAmount = 0.0;
  final DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  StreamSubscription<int>? _pointsSubscription;

  // قائمة الفواتير الافتراضية
  final List<ServiceItem> _defaultBills = [
    ServiceItem(
      id: '1',
      name: 'فاتورة المياه',
      amount: 25000.0,
      color: Colors.blue,
      gradient: [Colors.blue, Colors.lightBlue],
      additionalInfo: 'فاتورة استهلاك المياه للشهر الحالي',
    ),
    ServiceItem(
      id: '2',
      name: 'فاتورة الكهرباء',
      amount: 35000.0,
      color: Colors.amber,
      gradient: [Colors.amber, Colors.orange],
      additionalInfo: 'فاتورة استهلاك الكهرباء للشهر الحالي',
    ),
    ServiceItem(
      id: '3',
      name: 'فاتورة النفايات',
      amount: 10000.0,
      color: Colors.green,
      gradient: [Colors.green, Colors.lightGreen],
      additionalInfo: 'رسوم جمع النفايات للشهر الحالي',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _finalAmount = _calculateTotalAmount();
    _loadUserPoints();
    _subscribeToPointsChanges();
  }

  void _subscribeToPointsChanges() {
    _pointsSubscription = _pointsService.getUserPointsStream().listen((points) {
      if (mounted) {
        setState(() {
          _userPoints = points;
          _calculatePointsDiscount();
          _updateFinalAmount();
        });
      }
    }, onError: (error) {
      print('Error in points stream: $error');
    });
  }

  Future<void> _loadUserPoints() async {
    try {
      final points = await _pointsService.getUserPoints();
      setState(() {
        _userPoints = points;
        _calculatePointsDiscount();
        _updateFinalAmount();
      });
    } catch (e) {
      print('Error loading points: $e');
    }
  }

  double _calculateTotalAmount() {
    return _defaultBills
        .where((bill) => bill.isSelected)
        .fold(0.0, (sum, service) => sum + service.amount);
  }

  void _calculatePointsDiscount() {
    _pointsDiscount = _userPoints * _pointsRate;
    if (_pointsDiscount > _calculateTotalAmount()) {
      _pointsDiscount = _calculateTotalAmount();
    }
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

  @override
  void dispose() {
    _pointsSubscription?.cancel();
    _serviceNameController.dispose();
    _serviceAmountController.dispose();
    _serviceInfoController.dispose();
    super.dispose();
  }

  void _showPaymentMethodsDialog() {
    final selectedBills = _defaultBills.where((bill) => bill.isSelected).toList();
    
    if (selectedBills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى اختيار فاتورة واحدة على الأقل للدفع'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
                color: widget.primaryColor,
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
                services: selectedBills,
                primaryColor: widget.primaryColor,
                primaryGradient: widget.primaryGradient,
                finalAmount: _finalAmount,
                usePoints: _usePoints,
                pointsDiscount: _pointsDiscount,
                onPaymentSuccess: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صفحة الدفع'),
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
        actions: [
          // زر الفواتير المدفوعة
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.receipt, color: Colors.white),
                // مؤشر للإشعارات إذا كانت هناك فواتير جديدة
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const Text(
                      '',
                      style: TextStyle(color: Colors.white, fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaidInvoicesScreen(
                    primaryColor: widget.primaryColor,
                    primaryGradient: widget.primaryGradient,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عرض الفواتير المتاحة
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الفواتير المتاحة للدفع',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ..._defaultBills
                    .map(
                      (bill) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: bill.gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getBillIcon(bill.name),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(bill.name),
                          subtitle: Text(
                            '${bill.amount.toStringAsFixed(2)} د.ع',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.info_outline),
                                onPressed: () {
                                  _showServiceDetailsDialog(bill);
                                },
                              ),
                              Checkbox(
                                value: bill.isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    bill.isSelected = value!;
                                    _updateFinalAmount();
                                  });
                                },
                                activeColor: widget.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                const SizedBox(height: 20),
              ],
            ),

            // عرض الخدمات المختارة
            if (_defaultBills.any((bill) => bill.isSelected))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الخدمات المختارة',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ..._defaultBills
                      .where((bill) => bill.isSelected)
                      .map(
                        (service) => Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          color: Colors.grey[100],
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: service.gradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getBillIcon(service.name),
                                color: Colors.white,
                              ),
                            ),
                            title: Text(service.name),
                            subtitle: Text(
                              '${service.amount.toStringAsFixed(2)} د.ع',
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  service.isSelected = false;
                                  _updateFinalAmount();
                                });
                              },
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 20),
                ],
              ),

            // خيار استخدام النقاط
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.loyalty, color: widget.primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نقاط الولاء: $_userPoints نقطة',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'يمكنك خصم ${_pointsDiscount.toStringAsFixed(2)} د.ع',
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _usePoints,
                      onChanged: (value) {
                        setState(() {
                          _usePoints = value;
                          _updateFinalAmount();
                        });
                      },
                      activeColor: widget.primaryColor,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // المبلغ الإجمالي
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المبلغ الإجمالي:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_finalAmount.toStringAsFixed(2)} د.ع',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: widget.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // زر الانتقال إلى الدفع
            _buildProceedToPaymentButton(),
          ],
        ),
      ),
    );
  }

  IconData _getBillIcon(String billName) {
    if (billName.contains('مياه')) {
      return Icons.water_drop;
    } else if (billName.contains('كهرباء')) {
      return Icons.bolt;
    } else if (billName.contains('نفايات')) {
      return Icons.delete;
    }
    return Icons.receipt;
  }

  void _showServiceDetailsDialog(ServiceItem service) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: service.gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_getBillIcon(service.name), color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        service.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'تفاصيل الخدمة:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  service.additionalInfo ?? 'لا توجد معلومات إضافية',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'سعر الخدمة:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${service.amount.toStringAsFixed(2)} د.ع',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primaryColor,
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
          _showPaymentMethodsDialog();
        },
        child: const Text(
          'الانتقال إلى الدفع',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

// شاشة منبثقة لاختيار طريقة الدفع
class PaymentMethodsDialog extends StatefulWidget {
  final List<ServiceItem> services;
  final Color primaryColor;
  final List<Color> primaryGradient;
  final double finalAmount;
  final bool usePoints;
  final double pointsDiscount;
  final VoidCallback? onPaymentSuccess;

  const PaymentMethodsDialog({
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
  State<PaymentMethodsDialog> createState() => _PaymentMethodsDialogState();
}

class _PaymentMethodsDialogState extends State<PaymentMethodsDialog> {
  String _selectedMethod = '';

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'visa',
      'name': 'بطاقة فيزا',
      'icon': Icons.credit_card,
      'color': Colors.blue,
      'type': 'card',
      'details': 'ادخل معلومات بطاقتك البنكية لإتمام عملية الدفع',
      'formFields': [
        {
          'label': 'رقم البطاقة',
          'type': 'number',
          'hint': '1234 5678 9012 3456',
        },
        {'label': 'اسم حامل البطاقة', 'type': 'text', 'hint': 'John Doe'},
        {'label': 'تاريخ الانتهاء', 'type': 'text', 'hint': 'MM/YY'},
        {'label': 'CVV', 'type': 'number', 'hint': '123'},
      ],
    },
    {
      'id': 'mastercard',
      'name': 'بطاقة ماستركارد',
      'icon': Icons.credit_card,
      'color': Colors.red,
      'type': 'card',
      'details': 'ادخل معلومات بطاقتك البنكية لإتمام عملية الدفع',
      'formFields': [
        {
          'label': 'رقم البطاقة',
          'type': 'number',
          'hint': '1234 5678 9012 3456',
        },
        {'label': 'اسم حامل البطاقة', 'type': 'text', 'hint': 'John Doe'},
        {'label': 'تاريخ الانتهاء', 'type': 'text', 'hint': 'MM/YY'},
        {'label': 'CVV', 'type': 'number', 'hint': '123'},
      ],
    },
    {
      'id': 'asiapay',
      'name': 'AsiaPay',
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
      'type': 'wallet',
      'details': 'سيتم توجيهك إلى تطبيق AsiaPay لإتمام عملية الدفع',
      'formFields': [
        {'label': 'رقم الهاتف', 'type': 'phone', 'hint': '07XX XXX XXXX'},
        {
          'label': 'كلمة المرور',
          'type': 'password',
          'hint': 'أدخل كلمة المرور',
        },
      ],
    },
    {
      'id': 'zain_cash',
      'name': 'زين كاش',
      'icon': Icons.phone_iphone,
      'color': Colors.purple,
      'type': 'wallet',
      'details': 'أدخل معلومات زين كاش لإتمام عملية الدفع',
      'formFields': [
        {'label': 'رقم الهاتف', 'type': 'phone', 'hint': '07XX XXX XXXX'},
        {'label': 'رقم PIN', 'type': 'password', 'hint': 'أدخل الرقم السري'},
      ],
    },
    {
      'id': 'bank_transfer',
      'name': 'التحويل البنكي',
      'icon': Icons.account_balance,
      'color': Colors.blueGrey,
      'type': 'bank',
      'details': 'سيتم تزويدك بمعلومات الحساب البنكي لإتمام التحويل',
      'formFields': [
        {'label': 'اسم البنك', 'type': 'text', 'hint': 'اسم البنك المحول منه'},
        {'label': 'رقم الحساب', 'type': 'text', 'hint': 'رقم حسابك'},
        {'label': 'رقم المرجع', 'type': 'text', 'hint': 'رقم المرجع للتحويل'},
      ],
    },
    {
      'id': 'alrafidain',
      'name': 'الرافدين',
      'icon': Icons.account_balance,
      'color': Colors.orange,
      'type': 'bank',
      'details': 'سيتم توجيهك إلى بوابة بنك الرافدين لإتمام عملية الدفع',
      'formFields': [
        {'label': 'رقم الحساب', 'type': 'text', 'hint': 'رقم حساب الرافدين'},
        {
          'label': 'اسم المستخدم',
          'type': 'text',
          'hint': 'اسم المستخدم للإنترنت البنكي',
        },
        {
          'label': 'كلمة المرور',
          'type': 'password',
          'hint': 'كلمة المرور للإنترنت البنكي',
        },
      ],
    },
    {
      'id': 'alrasheed',
      'name': 'الرشيد',
      'icon': Icons.account_balance,
      'color': Colors.teal,
      'type': 'bank',
      'details': 'سيتم توجيهك إلى بوابة بنك الرشيد لإتمام عملية الدفع',
      'formFields': [
        {'label': 'رقم الحساب', 'type': 'text', 'hint': 'رقم حساب الرشيد'},
        {
          'label': 'اسم المستخدم',
          'type': 'text',
          'hint': 'اسم المستخدم للإنترنت البنكي',
        },
        {
          'label': 'كلمة المرور',
          'type': 'password',
          'hint': 'كلمة المرور للإنترنت البنكي',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عرض الخدمات المختارة
          if (widget.services.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الخدمات المختارة:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...widget.services
                    .map(
                      (service) => Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 16),
                            const SizedBox(width: 8),
                            Text(service.name),
                            const Spacer(),
                            Text('${service.amount.toStringAsFixed(2)} د.ع'),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                const SizedBox(height: 15),
              ],
            ),

          // المبلغ الإجمالي
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'المبلغ الإجمالي:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${widget.finalAmount.toStringAsFixed(2)} د.ع',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'طرق الدفع المتاحة:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // خيارات الدفع
          ..._paymentMethods.map((method) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _selectedMethod == method['id']
                      ? widget.primaryColor
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: method['color'],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(method['icon'], color: Colors.white, size: 20),
                ),
                title: Text(
                  method['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _selectedMethod == method['id']
                        ? widget.primaryColor
                        : Colors.black,
                  ),
                ),
                subtitle: Text(
                  method['details'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                trailing: _selectedMethod == method['id']
                    ? Icon(Icons.check_circle, color: widget.primaryColor)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedMethod = method['id'];
                  });

                  // عرض تفاصيل الدفع بعد اختيار طريقة الدفع باستخدام Bottom Sheet
                  _showPaymentDetailsBottomSheet(method);
                },
              ),
            );
          }).toList(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showPaymentDetailsBottomSheet(Map<String, dynamic> paymentMethod) {
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
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(paymentMethod['icon'], color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    paymentMethod['name'],
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
              child: PaymentDetailsForm(
                paymentMethod: paymentMethod,
                services: widget.services,
                primaryColor: widget.primaryColor,
                primaryGradient: widget.primaryGradient,
                finalAmount: widget.finalAmount,
                usePoints: widget.usePoints,
                pointsDiscount: widget.pointsDiscount,
                onPaymentSuccess: widget.onPaymentSuccess,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// نموذج تفاصيل الدفع
class PaymentDetailsForm extends StatefulWidget {
  final Map<String, dynamic> paymentMethod;
  final List<ServiceItem> services;
  final Color primaryColor;
  final List<Color> primaryGradient;
  final double finalAmount;
  final bool usePoints;
  final double pointsDiscount;
  final VoidCallback? onPaymentSuccess;

  const PaymentDetailsForm({
    super.key,
    required this.paymentMethod,
    required this.services,
    required this.primaryColor,
    required this.primaryGradient,
    required this.finalAmount,
    required this.usePoints,
    required this.pointsDiscount,
    this.onPaymentSuccess,
  });

  @override
  State<PaymentDetailsForm> createState() => _PaymentDetailsFormState();
}

class _PaymentDetailsFormState extends State<PaymentDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final PointsService _pointsService = PointsService(); // Add this
  final double _pointsRate = 0.01; // Add points rate
  final DateTime _dueDate = DateTime.now().add(
    const Duration(days: 7),
  ); // Add due date

  @override
  void initState() {
    super.initState();
    // إنشاء متحكمات النص لكل حقل
    for (var field in widget.paymentMethod['formFields']) {
      _controllers[field['label']] = TextEditingController();
    }
  }

  @override
  void dispose() {
    // التخلص من المتحكمات عند إغلاق النموذج
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // تفاصيل طريقة الدفع
          Text(
            widget.paymentMethod['details'],
            style: TextStyle(color: Colors.grey[600]),
          ),

          const SizedBox(height: 20),

          // المبلغ الإجمالي
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'المبلغ المستحق:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${widget.finalAmount.toStringAsFixed(2)} د.ع',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // حقول الإدخال
          Form(
            key: _formKey,
            child: Column(
              children: widget.paymentMethod['formFields'].map<Widget>((field) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    controller: _controllers[field['label']],
                    decoration: InputDecoration(
                      labelText: field['label'],
                      hintText: field['hint'],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    obscureText: field['type'] == 'password',
                    keyboardType: _getKeyboardType(field['type']),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى ملء هذا الحقل';
                      }
                      return null;
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // أزرار الإجراء
          Row(
            children: [
              // زر الإلغاء
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // زر الدفع
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _processPayment();
                    }
                  },
                  child: const Text(
                    'دفع الآن',
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
  }

  TextInputType _getKeyboardType(String type) {
    switch (type) {
      case 'number':
        return TextInputType.number;
      case 'phone':
        return TextInputType.phone;
      case 'datetime':
        return TextInputType.datetime;
      default:
        return TextInputType.text;
    }
  }

  // في payment_screen.dart

  void _processPayment() async {
    try {
      // عند الدفع الناجح
      if (widget.usePoints) {
        // خصم النقاط المستخدمة
        await _pointsService.usePoints(
          points: (widget.pointsDiscount / _pointsRate)
              .round(), // تحويل المبلغ إلى نقاط
          reason: 'خصم من فاتورة',
          referenceId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      // منح نقاط للدفع في الموعد/مبكر
      final now = DateTime.now();
      final dueDate = _dueDate;
      final daysEarly = dueDate.difference(now).inDays;

      if (daysEarly >= 0) {
        // الدفع في الموعد أو مبكرًا
        final pointsToAdd = (widget.finalAmount * 0.02).round();
        await _pointsService.addPoints(
          points: pointsToAdd,
          reason: 'دفع مبكر للفاتورة',
          referenceId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم الدفع بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );

      // إغلاق النموذج
      Navigator.of(context).pop();

      // إغلاق شاشة الدفع
      if (widget.onPaymentSuccess != null) {
        widget.onPaymentSuccess!();
      }
    } catch (e) {
      // إظهار رسالة خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء عملية الدفع: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// شاشة الفواتير المدفوعة
class PaidInvoicesScreen extends StatelessWidget {
  final Color primaryColor;
  final List<Color> primaryGradient;

  const PaidInvoicesScreen({
    super.key,
    required this.primaryColor,
    required this.primaryGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفواتير المدفوعة'),
        backgroundColor: primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // يمكنك إضافة قائمة بالفواتير المدفوعة هنا
          Text(
            'قائمة الفواتير المدفوعة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // يمكنك إضافة عناصر الفواتير المدفوعة هنا
          // مثال:
          // PaidInvoiceItem(...),
          // PaidInvoiceItem(...),
        ],
      ),
    );
  }
}
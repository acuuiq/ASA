import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'invoices_service.dart'; // أضف هذا الاستيراد
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mang_mu/screens/citizen/screens/user_main_screen.dart';
import 'points_service.dart'; // Make sure this import is correct
import 'dart:async'; // أضف هذا الاستيراد
import 'package:flutter/services.dart'; // لإضافة Clipboard

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

// نموذج بيانات الفاتورة المدفوعة
class PaidInvoice {
  final String id;
  final String referenceNumber;
  final List<ServiceItem> services;
  final double totalAmount;
  final double pointsDiscount;
  final double finalAmount;
  final String paymentMethod;
  final DateTime paymentDate;
  final int pointsUsed;
  final int pointsEarned;

  PaidInvoice({
    required this.id,
    required this.referenceNumber,
    required this.services,
    required this.totalAmount,
    required this.pointsDiscount,
    required this.finalAmount,
    required this.paymentMethod,
    required this.paymentDate,
    required this.pointsUsed,
    required this.pointsEarned,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'referenceNumber': referenceNumber,
      'services': services.map((service) => service.toMap()).toList(),
      'totalAmount': totalAmount,
      'pointsDiscount': pointsDiscount,
      'finalAmount': finalAmount,
      'paymentMethod': paymentMethod,
      'paymentDate': paymentDate.toIso8601String(),
      'pointsUsed': pointsUsed,
      'pointsEarned': pointsEarned,
    };
  }

  factory PaidInvoice.fromMap(Map<String, dynamic> map) {
    return PaidInvoice(
      id: map['id'].toString(),
      referenceNumber: map['referenceNumber'].toString(),
      services: (map['services'] as List)
          .map((service) => ServiceItem.fromMap(service))
          .toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      pointsDiscount: (map['pointsDiscount'] as num).toDouble(),
      finalAmount: (map['finalAmount'] as num).toDouble(),
      paymentMethod: map['paymentMethod'].toString(),
      paymentDate: DateTime.parse(map['paymentDate']),
      pointsUsed: map['pointsUsed'] as int,
      pointsEarned: map['pointsEarned'] as int,
    );
  }
}

// خدمة إدارة الفواتير المدفوعة
class PaidInvoicesService {
  final List<PaidInvoice> _paidInvoices = [];

  List<PaidInvoice> get paidInvoices => _paidInvoices;

  void addPaidInvoice(PaidInvoice invoice) {
    _paidInvoices.insert(0, invoice); // إضافة في البداية لعرض الأحدث أولاً
  }

  double getTotalPaidAmount() {
    return _paidInvoices.fold(0.0, (sum, invoice) => sum + invoice.finalAmount);
  }

  int getTotalInvoicesCount() {
    return _paidInvoices.length;
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
  final InvoicesService _invoicesService = InvoicesService();
  final NewInvoicesService _newInvoicesService = NewInvoicesService();
  final _serviceNameController = TextEditingController();
  final _serviceAmountController = TextEditingController();
  final _serviceInfoController = TextEditingController();

  // نظام النقاط - تم التحديث
  final PointsService _pointsService = PointsService();
  final PaidInvoicesService _paidInvoicesService =
      PaidInvoicesService(); // أضف هذا
  int _userPoints = 0;
  final double _pointsRate = 0.01; // كل نقطة = 0.01 دينار
  bool _usePoints = false;
  double _pointsDiscount = 0.0;
  double _finalAmount = 0.0;
  final DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  StreamSubscription<int>? _pointsSubscription;
  StreamSubscription<List<Map<String, dynamic>>>? _invoicesSubscription;
  List<Map<String, dynamic>> _userInvoices = [];
  bool _hasNewInvoices = false;

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
    //!colorrrrrrrrrrrrr
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
    _checkForNewInvoices(); // إضافة هذا
    _subscribeToNewInvoices(); // إضافة هذا
    _setupInvoicesListener(); // إضافة هذا
    _subscribeToInvoicesChanges(); // أضف هذا السطر
  }

  // أضف هذه الدالة للاشتراك في تغييرات الفواتير
  void _subscribeToInvoicesChanges() {
    _invoicesSubscription = _invoicesService.getInvoicesStream().listen(
      (invoices) {
        if (mounted) {
          setState(() {
            _userInvoices = invoices;
            _checkForNewInvoices(); // تحقق من الفواتير الجديدة عند كل تحديث
          });
        }
      },
      onError: (error) {
        print('Error in invoices stream: $error');
      },
    );
  }

  Future<void> _checkForNewInvoices() async {
    try {
      final hasNew = await _invoicesService.hasNewInvoices();
      if (mounted) {
        setState(() {
          _hasNewInvoices = hasNew;
        });
      }
    } catch (e) {
      print('Error checking new invoices: $e');
    }
  }

  void _setupInvoicesListener() {
    // يمكنك إضافة أي listeners إضافية هنا
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForNewInvoices();
  }

  // الاشتراك في تغييرات الفواتير الجديدة
  void _subscribeToNewInvoices() {
    // يمكنك إضافة listener هنا إذا كان لديك نظام للإشعارات
  }

  // دالة عند الضغط على زر الفواتير المدفوعة
  // دالة عند الضغط على زر الفواتير المدفوعة - النسخة المعدلة
  void _onPaidInvoicesPressed() async {
    // تحديث حالة النقطة الحمراء فوراً
    setState(() {
      _hasNewInvoices = false;
    });

    // الانتقال إلى الشاشة
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaidInvoicesScreen(
          primaryColor: widget.primaryColor,
          primaryGradient: widget.primaryGradient,
        ),
      ),
    ).then((_) {
      // عند العودة من شاشة الفواتير، تحقق مرة أخرى من الفواتير الجديدة
      _checkForNewInvoices();
    });
  }

  void _subscribeToPointsChanges() {
    _pointsSubscription = _pointsService.getUserPointsStream().listen(
      (points) {
        if (mounted) {
          setState(() {
            _userPoints = points;
            _calculatePointsDiscount();
            _updateFinalAmount();
          });
        }
      },
      onError: (error) {
        print('Error in points stream: $error');
      },
    );
  }

  Future<void> _loadUserPoints() async {
    try {
      final points = await _pointsService.getUserPoints();
      setState(() {
        _userPoints = points;
        // حساب الخصم فقط إذا كانت هناك فواتير مختارة
        if (_defaultBills.any((bill) => bill.isSelected)) {
          _calculatePointsDiscount();
          _updateFinalAmount();
        }
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
    // حساب الخصم فقط إذا كانت هناك فواتير مختارة
    if (_defaultBills.any((bill) => bill.isSelected)) {
      double totalAmount = _calculateTotalAmount();
      double maxDiscount = _userPoints * _pointsRate;

      // التأكد من أن الخصم لا يتجاوز المبلغ الإجمالي
      _pointsDiscount = maxDiscount > totalAmount ? totalAmount : maxDiscount;

      print('Points Discount Calculated: $_pointsDiscount'); // للت Debug
    } else {
      _pointsDiscount = 0.0; // إعادة تعيين إذا لم تكن هناك فواتير مختارة
    }
  }

  void _updateFinalAmount() {
    double amount = _calculateTotalAmount();

    // حساب الخصم فقط إذا تم اختيار فواتير واستخدام النقاط
    if (_usePoints && _defaultBills.any((bill) => bill.isSelected)) {
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
    _invoicesSubscription?.cancel(); // أضف هذا السطر
    _serviceNameController.dispose();
    _serviceAmountController.dispose();
    _serviceInfoController.dispose();
    super.dispose();
  }

  void _showPaymentMethodsDialog() {
    final selectedBills = _defaultBills
        .where((bill) => bill.isSelected)
        .toList();

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
                onPaymentSuccess: _onPaymentSuccess, // أضف هذا
              ),
            ),
          ],
        ),
      ),
    );
  }

  // أضف هذه الدالة
  void _onPaymentSuccess() {
    // إعادة تعيين جميع الخدمات المختارة
    for (var bill in _defaultBills) {
      bill.isSelected = false;
    }

    // إعادة تعيين النقاط
    _usePoints = false;
    _pointsDiscount = 0.0;

    // إعادة حساب المبالغ
    _updateFinalAmount();

    // إعادة تحميل النقاط
    _loadUserPoints();

    // التحقق من الفواتير الجديدة
    _checkForNewInvoices();

    // تحديث الواجهة
    setState(() {});
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
          // في دالة build، داخل AppBar actions:
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.receipt_long, color: Colors.white),
                // مؤشر للإشعارات إذا كانت هناك فواتير جديدة
                if (_hasNewInvoices)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _onPaidInvoicesPressed, // استخدام الدالة الجديدة
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
                                    // إعادة حساب الخصم وتحديث المبلغ
                                    _calculatePointsDiscount();
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
            // خيار استخدام النقاط - يظهر فقط عند اختيار فاتورة
            if (_defaultBills.any((bill) => bill.isSelected))
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
                            _calculatePointsDiscount(); // إعادة حساب الخصم
                            _updateFinalAmount(); // تحديث المبلغ النهائي
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
                      child: Icon(
                        _getBillIcon(service.name),
                        color: Colors.white,
                      ),
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

// weeeeeeeeeeeeeeeee
// خدمة متابعة الفواتير الجديدة
class NewInvoicesService {
  static final NewInvoicesService _instance = NewInvoicesService._internal();
  factory NewInvoicesService() => _instance;
  NewInvoicesService._internal();

  bool _hasNewInvoices = false;
  final List<VoidCallback> _listeners = [];

  bool get hasNewInvoices => _hasNewInvoices;

  void markAsRead() {
    _hasNewInvoices = false;
    _notifyListeners();
  }

  void markAsNew() {
    _hasNewInvoices = true;
    _notifyListeners();
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
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
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
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
  final InvoicesService _invoicesService = InvoicesService(); // أضف هذا السطر

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
                    // إخفاء لوحة المفاتيح عند الضغط على الزر
                    FocusScope.of(context).unfocus();

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
    FocusScope.of(context).unfocus();

    int pointsUsed = 0;
    int pointsEarned = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
              ),
              SizedBox(height: 16),
              Text('جاري معالجة الدفع...'),
            ],
          ),
        );
      },
    );

    try {
      if (widget.usePoints && widget.pointsDiscount > 0) {
        pointsUsed = (widget.pointsDiscount / _pointsRate).round();
        await _pointsService.usePoints(
          points: pointsUsed,
          reason: 'خصم من فاتورة',
          referenceId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      final now = DateTime.now();
      final dueDate = _dueDate;
      final daysEarly = dueDate.difference(now).inDays;

      if (daysEarly >= 0 && widget.finalAmount > 0) {
        pointsEarned = (widget.finalAmount * 0.02).round();
        if (pointsEarned > 0) {
          await _pointsService.addPoints(
            points: pointsEarned,
            reason: 'مكافأة دفع مبكر',
            referenceId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
          );
        }
      }

      await _invoicesService.saveInvoice(
        amount: widget.finalAmount,
        paymentMethod: widget.paymentMethod['name'],
        services: widget.services.map((service) => service.toMap()).toList(),
        status: 'paid',
        pointsUsed: pointsUsed,
        pointsEarned: pointsEarned,
        pointsDiscount: widget.pointsDiscount,
      );

      // إغلاق دائرة التحميل
      Navigator.of(context).pop();

      // إعادة تعيين حالة الخدمات المختارة
      _resetSelectedServices();

      // إظهار نجاح الدفع
      _showPaymentSuccessDialog(pointsUsed, pointsEarned);
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء عملية الدفع: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // أضف دالة لإعادة تعيين الخدمات المختارة
  void _resetSelectedServices() {
    // هذه الدالة ستعيد تعيين جميع الخدمات المختارة
    // سنحتاج لجعل _defaultBills متاحة من هنا
    // أو نستخدم callback لتحديث الشاشة الرئيسية
  }

  void _showPaymentSuccessDialog(int pointsUsed, int pointsEarned) {
    final paidInvoice = PaidInvoice(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      referenceNumber: 'INV-${DateTime.now().millisecondsSinceEpoch}',
      services: widget.services,
      totalAmount: widget.finalAmount + widget.pointsDiscount,
      pointsDiscount: widget.pointsDiscount,
      finalAmount: widget.finalAmount,
      paymentMethod: widget.paymentMethod['name'],
      paymentDate: DateTime.now(),
      pointsUsed: pointsUsed,
      pointsEarned: pointsEarned,
    );

    final paidInvoicesService = PaidInvoicesService();
    paidInvoicesService.addPaidInvoice(paidInvoice);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('تم الدفع بنجاح', style: TextStyle(color: Colors.green)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'تفاصيل الفاتورة:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                ...widget.services
                    .map(
                      (service) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(service.name),
                            Text('${service.amount.toStringAsFixed(2)} د.ع'),
                          ],
                        ),
                      ),
                    )
                    .toList(),

                Divider(),

                if (widget.usePoints && pointsUsed > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('الخصم من النقاط:'),
                        Text(
                          '-${widget.pointsDiscount.toStringAsFixed(2)} د.ع',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المبلغ الإجمالي:',
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

                // عرض معلومات النقاط
                if (pointsUsed > 0 || pointsEarned > 0) ...[
                  Divider(),
                  Text(
                    'معلومات النقاط:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                ],

                if (pointsUsed > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('النقاط المستخدمة:'),
                        Text(
                          '-$pointsUsed نقطة',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),

                if (pointsEarned > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('النقاط المكتسبة:'),
                        Text(
                          '+$pointsEarned نقطة',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 10),
                Text(
                  'رقم المرجع: ${paidInvoice.referenceNumber}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'تاريخ الدفع: ${DateFormat('yyyy/MM/dd - HH:mm').format(DateTime.now())}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // العودة للشاشة الرئيسية مع تحديث كامل
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text(
                'العودة للرئيسية',
                style: TextStyle(color: widget.primaryColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
              ),
              onPressed: () {
                // إغلاق جميع النوافذ والعودة لشاشة الدفع مع التحديث
                Navigator.of(context).pop(); // إغلاق dialog
                Navigator.of(context).pop(); // إغلاق payment details
                Navigator.of(context).pop(); // إغلاق payment methods

                // إعادة تحميل البيانات
                if (widget.onPaymentSuccess != null) {
                  widget.onPaymentSuccess!();
                }

                // إرسال إشعار لتحديث الشاشة
                _invoicesService.markInvoicesAsSeen();
              },
              child: Text('موافق', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

// شاشة الفواتير المدفوعة
class PaidInvoicesScreen extends StatefulWidget {
  final Color primaryColor;
  final List<Color> primaryGradient;

  const PaidInvoicesScreen({
    super.key,
    required this.primaryColor,
    required this.primaryGradient,
  });

  @override
  State<PaidInvoicesScreen> createState() => _PaidInvoicesScreenState();
}

class _PaidInvoicesScreenState extends State<PaidInvoicesScreen> {
  final InvoicesService _invoicesService = InvoicesService();
  List<Map<String, dynamic>> _invoices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
    _markAsSeenOnEnter(); // تأكد من استدعاء هذه الدالة
  }

  Future<void> _markAsSeenOnEnter() async {
    try {
      print('🚀 Marking invoices as seen on screen enter...');
      await _invoicesService.markInvoicesAsSeen();

      // يمكنك أيضاً إرسال إشعار لتحديث النقطة الحمراء في الشاشة الرئيسية
      if (mounted) {
        // أضف أي تحديثات إضافية هنا إذا needed
      }
    } catch (e) {
      print('❌ Error marking as seen on enter: $e');
    }
  }

  Future<void> _loadInvoices() async {
    try {
      final invoices = await _invoicesService.getUserInvoices();
      setState(() {
        _invoices = invoices;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading invoices: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // دالة حذف فاتورة
  Future<void> _deleteInvoice(String invoiceId) async {
    try {
      await _invoicesService.deleteInvoice(invoiceId);
      // إعادة تحميل القائمة بعد الحذف
      await _loadInvoices();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حذف الفاتورة بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء حذف الفاتورة: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // دالة حذف جميع الفواتير
  Future<void> _deleteAllInvoices() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text(
            'هل أنت متأكد من أنك تريد حذف جميع الفواتير؟ لا يمكن التراجع عن هذا الإجراء.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _invoicesService.deleteAllUserInvoices();
                  setState(() {
                    _invoices = [];
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم حذف جميع الفواتير بنجاح'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('حدث خطأ أثناء حذف الفواتير: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('حذف الكل', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // دالة نسخ تفاصيل الفاتورة
  void _copyInvoiceDetails(Map<String, dynamic> invoice) {
    final paymentDate = DateTime.parse(invoice['payment_date']);
    final services = (invoice['services'] as List).cast<Map<String, dynamic>>();

    String invoiceDetails =
        '''
فاتورة #${invoice['id']}
طريقة الدفع: ${invoice['payment_method']}
المبلغ: ${invoice['amount'].toStringAsFixed(2)} د.ع
تاريخ الدفع: ${DateFormat('yyyy/MM/dd - HH:mm').format(paymentDate)}
الخدمات:
${services.map((service) => '• ${service['name']} - ${service['amount']} د.ع').join('\n')}
    ''';

    // نسخ النص إلى الحافظة
    Clipboard.setData(ClipboardData(text: invoiceDetails));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ تفاصيل الفاتورة إلى الحافظة'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفواتير المدفوعة'),
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
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: widget.primaryColor))
          : _invoices.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد فواتير مدفوعة',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // معلومات عن عدد الفواتير
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.grey[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'عدد الفواتير: ${_invoices.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.primaryColor,
                        ),
                      ),
                      InkWell(
                        onTap: _deleteAllInvoices,
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_sweep,
                              color: Colors.red,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'حذف الكل',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = _invoices[index];
                      return _buildInvoiceCard(invoice);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> invoice) {
    final paymentDate = DateTime.parse(invoice['payment_date']);
    final services = (invoice['services'] as List).cast<Map<String, dynamic>>();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'فاتورة #${invoice['id']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: widget.primaryColor,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'مدفوعة',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'طريقة الدفع: ${invoice['payment_method']}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              'المبلغ: ${invoice['amount'].toStringAsFixed(2)} د.ع',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'تاريخ الدفع: ${DateFormat('yyyy/MM/dd - HH:mm').format(paymentDate)}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            if (services.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                'الخدمات:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              ...services
                  .take(2)
                  .map(
                    (service) => Text(
                      '• ${service['name']} - ${service['amount']} د.ع',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
              if (services.length > 2)
                Text(
                  'و ${services.length - 2} خدمة أخرى',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],

            // أزرار الحذف والنسخ
            SizedBox(height: 12),
            Row(
              children: [
                // زر النسخ
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.content_copy, size: 18),
                    label: Text('نسخ'),
                    onPressed: () => _copyInvoiceDetails(invoice),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: widget.primaryColor,
                      side: BorderSide(color: widget.primaryColor),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // زر الحذف
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.delete, size: 18),
                    label: Text('حذف'),
                    onPressed: () {
                      _showDeleteConfirmationDialog(invoice);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
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

  // دالة لعرض تأكيد الحذف
  void _showDeleteConfirmationDialog(Map<String, dynamic> invoice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text(
            'هل أنت متأكد من أنك تريد حذف الفاتورة #${invoice['id']}؟ لا يمكن التراجع عن هذا الإجراء.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteInvoice(invoice['id'].toString());
              },
              child: Text('حذف', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

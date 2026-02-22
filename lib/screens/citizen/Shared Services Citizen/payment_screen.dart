import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'invoices_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/user_main_screen.dart';
import 'points_service.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'payment_process_screen.dart';


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
  final PaidInvoicesService _paidInvoicesService = PaidInvoicesService();
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
    _checkForNewInvoices();
    _subscribeToNewInvoices();
    _setupInvoicesListener();
    _subscribeToInvoicesChanges();
  }

  void _subscribeToInvoicesChanges() {
    _invoicesSubscription = _invoicesService.getInvoicesStream().listen(
      (invoices) {
        if (mounted) {
          setState(() {
            _userInvoices = invoices;
            _checkForNewInvoices();
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

  void _subscribeToNewInvoices() {
    // يمكنك إضافة listener هنا إذا كان لديك نظام للإشعارات
  }

  void _onPaidInvoicesPressed() async {
    setState(() {
      _hasNewInvoices = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaidInvoicesScreen(
          primaryColor: widget.primaryColor,
          primaryGradient: widget.primaryGradient,
        ),
      ),
    ).then((_) {
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
    if (_defaultBills.any((bill) => bill.isSelected)) {
      double totalAmount = _calculateTotalAmount();
      double maxDiscount = _userPoints * _pointsRate;
      _pointsDiscount = maxDiscount > totalAmount ? totalAmount : maxDiscount;
      print('Points Discount Calculated: $_pointsDiscount');
    } else {
      _pointsDiscount = 0.0;
    }
  }

  void _updateFinalAmount() {
    double amount = _calculateTotalAmount();

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
    _invoicesSubscription?.cancel();
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
            Expanded(
              child: PaymentMethodsDialog(
                services: selectedBills,
                primaryColor: widget.primaryColor,
                primaryGradient: widget.primaryGradient,
                finalAmount: _finalAmount,
                usePoints: _usePoints,
                pointsDiscount: _pointsDiscount,
                onPaymentSuccess: _onPaymentSuccess,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPaymentSuccess() {
    for (var bill in _defaultBills) {
      bill.isSelected = false;
    }

    _usePoints = false;
    _pointsDiscount = 0.0;
    _updateFinalAmount();
    _loadUserPoints();
    _checkForNewInvoices();
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
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.receipt_long, color: Colors.white),
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
            onPressed: _onPaidInvoicesPressed,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 20),
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

  // أضف هذه الدالة المساعدة في _PaidInvoicesScreenState
  String _getServiceNameFromJson(dynamic serviceData) {
    try {
      if (serviceData is Map<String, dynamic>) {
        // إذا كانت البيانات Map مباشرة
        return serviceData['name'] ??
            serviceData['title'] ??
            serviceData['serviceName'] ??
            'خدمة غير محددة';
      } else if (serviceData is String) {
        // إذا كانت البيانات نص JSON
        final parsed = json.decode(serviceData);
        return parsed['name'] ??
            parsed['title'] ??
            parsed['serviceName'] ??
            'خدمة غير محددة';
      }
    } catch (e) {
      print('Error parsing service name: $e');
    }
    return 'خدمة غير محددة';
  }

  String _getServiceAmountFromJson(dynamic serviceData) {
    try {
      if (serviceData is Map<String, dynamic>) {
        final amount = serviceData['amount'];
        if (amount is double) return amount.toStringAsFixed(2);
        if (amount is int) return amount.toDouble().toStringAsFixed(2);
        if (amount is String) return amount;
      } else if (serviceData is String) {
        final parsed = json.decode(serviceData);
        final amount = parsed['amount'];
        if (amount is double) return amount.toStringAsFixed(2);
        if (amount is int) return amount.toDouble().toStringAsFixed(2);
        if (amount is String) return amount;
      }
    } catch (e) {
      print('Error parsing service amount: $e');
    }
    return '0.00';
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
 

  // دالة نسخ تفاصيل الفاتورة
  void _copyInvoiceDetails(Map<String, dynamic> invoice) {
    final paymentDate = DateTime.parse(invoice['payment_date']);
    final servicesData = invoice['services'];

    String invoiceDetails =
        '''فاتورة #${invoice['id']}
طريقة الدفع: ${invoice['payment_method']}
المبلغ الإجمالي: ${invoice['amount'].toStringAsFixed(2)} د.ع
تاريخ الدفع: ${DateFormat('yyyy/MM/dd - HH:mm').format(paymentDate)}

الخدمات:''';

    try {
      List<dynamic> servicesList = [];

      if (servicesData is List) {
        servicesList = servicesData;
      } else if (servicesData is String) {
        servicesList = json.decode(servicesData);
      }

      for (int i = 0; i < servicesList.length; i++) {
        final service = servicesList[i];
        final serviceName = _getServiceNameFromJson(service);
        final serviceAmount = _getServiceAmountFromJson(service);

        invoiceDetails += '\n${i + 1}. $serviceName - $serviceAmount د.ع';
      }
    } catch (e) {
      invoiceDetails += '\nخطأ في عرض تفاصيل الخدمات';
    }

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
    final servicesData = invoice['services']; // هذا هو الـ JSONB

    // استخراج اسم الخدمة الأولى
    String firstServiceName = 'خدمة غير محددة';
    if (servicesData != null) {
      try {
        if (servicesData is List && servicesData.isNotEmpty) {
          firstServiceName = _getServiceNameFromJson(servicesData[0]);
        } else if (servicesData is String) {
          final parsed = json.decode(servicesData);
          if (parsed is List && parsed.isNotEmpty) {
            firstServiceName = _getServiceNameFromJson(parsed[0]);
          }
        }
      } catch (e) {
        print('Error getting first service name: $e');
      }
    }

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'فاتورة #${invoice['id']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: widget.primaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        firstServiceName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
            SizedBox(height: 12),
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

            // عرض جميع الخدمات
            if (servicesData != null) ...[
              SizedBox(height: 12),
              Text(
                'الخدمات المدفوعة:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 8),
              ..._buildServicesList(servicesData),
            ],

            // أزرار الحذف والنسخ
            SizedBox(height: 16),
            Row(
              children: [
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
              
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildServicesList(dynamic servicesData) {
    final List<Widget> serviceWidgets = [];

    try {
      List<dynamic> servicesList = [];

      if (servicesData is List) {
        servicesList = servicesData;
      } else if (servicesData is String) {
        servicesList = json.decode(servicesData);
      }

      for (int i = 0; i < servicesList.length; i++) {
        final service = servicesList[i];
        final serviceName = _getServiceNameFromJson(service);
        final serviceAmount = _getServiceAmountFromJson(service);

        serviceWidgets.add(
          Container(
            margin: EdgeInsets.only(bottom: 6),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${i + 1}. $serviceName',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Text(
                  '$serviceAmount د.ع',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      print('Error building services list: $e');
      serviceWidgets.add(
        Text('خطأ في عرض الخدمات', style: TextStyle(color: Colors.red)),
      );
    }

    return serviceWidgets;
  }

  String _getServiceAmount(Map<String, dynamic> service) {
    try {
      if (service['amount'] != null) {
        if (service['amount'] is double) {
          return service['amount'].toStringAsFixed(2);
        } else if (service['amount'] is int) {
          return service['amount'].toDouble().toStringAsFixed(2);
        } else if (service['amount'] is String) {
          return double.parse(service['amount']).toStringAsFixed(2);
        }
      }
      return '0.00';
    } catch (e) {
      return '0.00';
    }
  }

  // دالة لعرض تأكيد الحذف
  
}
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

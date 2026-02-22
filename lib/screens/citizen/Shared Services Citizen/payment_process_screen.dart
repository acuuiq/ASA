import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'invoices_service.dart';
import 'points_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// شاشة منبثقة لاختيار طريقة الدفع
class PaymentMethodsDialog extends StatefulWidget {
  final List<ServiceItem> services;
  final Color primaryColor;
  final List<Color> primaryGradient;
  final double finalAmount;
  final bool usePoints;
  final double pointsDiscount;
  final VoidCallback? onPaymentSuccess;
  final bool isPremiumService; // أضف هذا
  final Map<String, dynamic>? premiumServiceData; // أضف هذا

  const PaymentMethodsDialog({
    super.key,
    required this.services,
    required this.primaryColor,
    required this.primaryGradient,
    required this.finalAmount,
    required this.usePoints,
    required this.pointsDiscount,
    this.onPaymentSuccess,
    this.isPremiumService = false, // قيمة افتراضية
    this.premiumServiceData, // قيمة افتراضية
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
            // في _PaymentMethodsDialogState، في دالة _showPaymentDetailsBottomSheet
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
                isPremiumService: widget.isPremiumService, // أضف هذا
                premiumServiceData: widget.premiumServiceData, // أضف هذا
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
  final bool isPremiumService; // إضافة هذا الحقل الجديد
  final Map<String, dynamic>?
  premiumServiceData; // بيانات إضافية للخدمات المميزة

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
    this.isPremiumService = false, // قيمة افتراضية
    this.premiumServiceData, // بيانات إضافية
  });

  @override
  State<PaymentDetailsForm> createState() => _PaymentDetailsFormState();
}

class _PaymentDetailsFormState extends State<PaymentDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final PointsService _pointsService = PointsService();
  final InvoicesService _invoicesService = InvoicesService();

  final double _pointsRate = 0.01;
  final DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

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
                Expanded(
                  // أضف هذا
                  child: Text(
                    'المبلغ المستحق:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  // أضف هذا
                  child: Text(
                    '${widget.finalAmount.toStringAsFixed(2)} د.ع',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.primaryColor,
                    ),
                    textAlign: TextAlign.left, // أضف هذا
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
  String _getServiceTableName() {
  // 🔥 تحقق من وجود البيانات الأساسية أولاً
  if (!widget.isPremiumService || widget.premiumServiceData == null) {
    print('⚠️ ليس خدمة مميزة أو بيانات مفقودة - استخدام الجدول الافتراضي');
    return 'electric_services_invoices';
  }

  final serviceType = widget.premiumServiceData?['serviceType'];
  
  // 🔥 تحقق من أن serviceType ليس null وفعلاً string
  if (serviceType == null || serviceType is! String) {
    print('⚠️ serviceType غير صالح: $serviceType - استخدام الجدول الافتراضي');
    return 'electric_services_invoices';
  }

  // 🔥 تحويل إلى lowercase لتجنب مشاكل الحروف
  final type = serviceType.toLowerCase().trim();
  
  print('🎯 تحديد الجدول لـ serviceType: $type');

  switch (type) {
    case 'water':
    case 'مياه':
      print('✅ تم تحديد جدول المياه');
      return 'water_services_invoices';
      
    case 'waste':
    case 'نفايات':
      print('✅ تم تحديد جدول النفايات');
      return 'waste_services_invoices';
      
    case 'electricity':
    case 'كهرباء':
      print('✅ تم تحديد جدول الكهرباء');
      return 'electric_services_invoices';
      
    default:
      print('⚠️ نوع خدمة غير معروف: $type - استخدام الجدول الافتراضي');
      return 'electric_services_invoices';
  }
}

// تحديث دالة _savePremiumServiceInvoice
Future<void> _savePremiumServiceInvoice() async {
  try {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) throw Exception('يجب تسجيل الدخول أولاً');

    final tableName = _getServiceTableName();

    // ✅ تحقق أقوى من الازدواجية قبل الإدراج
    final existingServices = await supabase
        .from(tableName)
        .select()
        .eq('user_id', user.id)
        .eq('service_name', widget.services.first.name)
        .inFilter('status', ['pending', 'in_progress', 'completed'])
        .gte('created_at', DateTime.now().subtract(Duration(hours: 1)).toIso8601String());

    if (existingServices.isNotEmpty) {
      print('⚠️ الخدمة موجودة مسبقاً في آخر ساعة، تم تجنب الازدواجية');
      
      // تحديث الخدمة الموجودة بدلاً من إنشاء جديدة
      await supabase
          .from(tableName)
          .update({
            'status': 'completed',
            'payment_method': widget.paymentMethod['name'],
            'payment_date': DateTime.now().toIso8601String(),
            'amount': widget.finalAmount,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', existingServices.first['id']);

      print('✅ تم تحديث الخدمة الموجودة في جدول $tableName');
      return;
    }

    // ✅ إنشاء خدمة جديدة إذا لم توجد
    await supabase.from(tableName).insert({
      'user_id': user.id,
      'service_name': widget.services.first.name,
      'service_description': widget.services.first.additionalInfo ?? 'خدمة مميزة',
      'amount': widget.finalAmount,
      'payment_method': widget.paymentMethod['name'],
      'payment_date': DateTime.now().toIso8601String(),
      'employee_name': widget.premiumServiceData?['employeeName'],
      'employee_specialty': widget.premiumServiceData?['employeeSpecialty'],
      'is_custom': widget.premiumServiceData?['isCustom'] ?? false,
      'custom_details': widget.premiumServiceData?['customDetails'],
      'reference_number': 'PS-${DateTime.now().millisecondsSinceEpoch}',
      'created_at': DateTime.now().toIso8601String(),
      'status': 'completed',
      'service_type': widget.premiumServiceData?['serviceType'] ?? 'electricity',
    });
    
    print('✅ تم إنشاء خدمة جديدة بحالة completed في جدول $tableName');

  } catch (e) {
    print('❌ خطأ في حفظ فاتورة الخدمة المميزة: $e');
    throw e;
  }
}
  // أضف هذه الدالة في _PaymentDetailsFormState
  void _showRegularInvoiceSuccessDialog(int pointsUsed, int pointsEarned) {
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
      if (widget.isPremiumService) {
        // حفظ فاتورة الخدمات المميزة
        await _savePremiumServiceInvoice();

        // إغلاق دائرة التحميل
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }


        // إظهار نجاح الدفع للخدمات المميزة
        _showPremiumServiceSuccessDialog();

        // 🔥 استدعاء callback النجاح لتحديث الواجهة
        if (widget.onPaymentSuccess != null) {
          widget.onPaymentSuccess!();
        }

        return;
      }

      // 🔥 الكود الأصلي للفواتير العادية فقط
      // معالجة النقاط (للفواتير العادية فقط)
      if (widget.usePoints && widget.pointsDiscount > 0) {
        pointsUsed = (widget.pointsDiscount / _pointsRate).round();
        await _pointsService.usePoints(
          points: pointsUsed,
          reason: 'خصم من فاتورة',
          referenceId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      // حساب النقاط المكتسبة (للفواتير العادية فقط)
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

      // حفظ الفاتورة العادية
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
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // إعادة تعيين حالة الخدمات المختارة (للفواتير العادية فقط)
      _resetSelectedServices();

      // إظهار نجاح الدفع للفواتير العادية
      _showRegularInvoiceSuccessDialog(pointsUsed, pointsEarned);
    } catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء عملية الدفع: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  // خدمة إدارة فواتير الخدمات المميزة

  void _resetSelectedServices() {
    // هذه الدالة ستعيد تعيين جميع الخدمات المختارة
    // سيتم التعامل معها من خلال callback
  }

  void _showPaymentSuccessDialog(int pointsUsed, int pointsEarned) {
    if (widget.isPremiumService) {
      _showPremiumServiceSuccessDialog(); // ✅ خدمات مميزة
    } else {
      _showRegularInvoiceSuccessDialog(
        pointsUsed,
        pointsEarned,
      ); // ✅ فواتير عادية
    }
  }

  //custom_service_requests هذي الدالة الخاصة ب تيبل هذاالي تعرض الحدمات المطلوبة والتغيير
  void _showPremiumServiceSuccessDialog() {
    final premiumInvoice = PremiumServiceInvoice(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      referenceNumber: 'PS-${DateTime.now().millisecondsSinceEpoch}',
      serviceName: widget.services.first.name,
      serviceDescription: widget.services.first.additionalInfo ?? 'خدمة مميزة',
      amount: widget.finalAmount,
      paymentMethod: widget.paymentMethod['name'],
      paymentDate: DateTime.now(),
      employeeName: widget.premiumServiceData?['employeeName'],
      employeeSpecialty: widget.premiumServiceData?['employeeSpecialty'],
      isCustom: widget.premiumServiceData?['isCustom'] ?? false,
      customDetails: widget.premiumServiceData?['customDetails'],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          'تم طلب الخدمة بنجاح',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Service Details
                  _buildDetailRow('اسم الخدمة', premiumInvoice.serviceName),
                  _buildDetailRow(
                    'المبلغ',
                    '${premiumInvoice.amount.toStringAsFixed(2)} د.ع',
                  ),
                  _buildDetailRow('طريقة الدفع', premiumInvoice.paymentMethod),

                  // Employee Info if exists
                  if (premiumInvoice.employeeName != null)
                    _buildDetailRow('الفني', premiumInvoice.employeeName!),

                  if (premiumInvoice.employeeSpecialty != null)
                    _buildDetailRow(
                      'التخصص',
                      premiumInvoice.employeeSpecialty!,
                    ),

                  // Custom Details if exists
                  if (premiumInvoice.isCustom &&
                      premiumInvoice.customDetails != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'التفاصيل المخصصة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        premiumInvoice.customDetails!,
                        style: TextStyle(fontSize: 12, height: 1.4),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Reference and Date
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'رقم المرجع: ${premiumInvoice.referenceNumber}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'تاريخ الطلب: ${DateFormat('yyyy/MM/dd - HH:mm').format(DateTime.now())}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: widget.primaryColor,
                            side: BorderSide(color: widget.primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
                          child: Text('العودة للرئيسية'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // في _PaymentDetailsFormState، في دالة _showPremiumServiceSuccessDialog
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // إغلاق dialog
                            Navigator.of(context).pop(); // إغلاق dialog
                            Navigator.of(context).pop(); // إغلاق dialog

                            // 🔥 استدعاء callback التحديث إذا كان موجوداً
                            if (widget.onPaymentSuccess != null) {
                              widget.onPaymentSuccess!();
                            }
                          },
                          child: Text(
                            'موافق',
                            style: TextStyle(color: Colors.white),
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
      },
    );
  }

  // دالة مساعدة لعرض الصفوف بشكل منظم
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumServiceDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value),
          Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // دالة الفاتورة العادية (نفس الكود السابق)
  // ... الكود الأصي لـ _showPaymentSuccessDialog
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

// شاشة الفواتير المدفوعة الأساسية
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
      body: const Center(child: Text('شاشة الفواتير المدفوعة - تحت التطوير')),
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

// نموذج فاتورة اخدمات المميزة
class PremiumServiceInvoice {
  final String id;
  final String referenceNumber;
  final String serviceName;
  final String serviceDescription;
  final double amount;
  final String paymentMethod;
  final DateTime paymentDate;
  final String? employeeName;
  final String? employeeSpecialty;
  final bool isCustom;
  final String? customDetails;

  PremiumServiceInvoice({
    required this.id,
    required this.referenceNumber,
    required this.serviceName,
    required this.serviceDescription,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDate,
    this.employeeName,
    this.employeeSpecialty,
    this.isCustom = false,
    this.customDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'referenceNumber': referenceNumber,
      'serviceName': serviceName,
      'serviceDescription': serviceDescription,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paymentDate': paymentDate.toIso8601String(),
      'employeeName': employeeName,
      'employeeSpecialty': employeeSpecialty,
      'isCustom': isCustom,
      'customDetails': customDetails,
    };
  }

  factory PremiumServiceInvoice.fromMap(Map<String, dynamic> map) {
    return PremiumServiceInvoice(
      id: map['id'].toString(),
      referenceNumber: map['referenceNumber'].toString(),
      serviceName: map['serviceName'].toString(),
      serviceDescription: map['serviceDescription'].toString(),
      amount: (map['amount'] as num).toDouble(),
      paymentMethod: map['paymentMethod'].toString(),
      paymentDate: DateTime.parse(map['paymentDate']),
      employeeName: map['employeeName']?.toString(),
      employeeSpecialty: map['employeeSpecialty']?.toString(),
      isCustom: map['isCustom'] as bool? ?? false,
      customDetails: map['customDetails']?.toString(),
    );
  }
}

class PremiumInvoicesService {
  final List<PremiumServiceInvoice> _premiumInvoices = [];

  List<PremiumServiceInvoice> get premiumInvoices => _premiumInvoices;

  void addPremiumInvoice(PremiumServiceInvoice invoice) {
    _premiumInvoices.insert(0, invoice);
  }

  double getTotalPremiumAmount() {
    return _premiumInvoices.fold(0.0, (sum, invoice) => sum + invoice.amount);
  }

  int getTotalInvoicesCount() {
    return _premiumInvoices.length;
  }

  List<PremiumServiceInvoice> getInvoicesByService(String serviceName) {
    return _premiumInvoices
        .where((invoice) => invoice.serviceName == serviceName)
        .toList();
  }
}

// إنشاء instance عامة
// استبدل السطر الأخير في الملف بهذا:
final PremiumInvoicesService _premiumInvoicesService = PremiumInvoicesService();

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
  bool isSelected = false; // أضف هذا
  final bool isCustom; // 🔥 أضف هذا

  ServiceItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.color,
    required this.gradient,
    this.additionalInfo,
    this.selectedEmployee,
    this.isSelected = false, // أضف هذا في constructor
    this.isCustom = false, // 🔥 قيمة افتراضية

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

//???????????????????????????????????????????????????
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

  // أضف هذه الدوال للمقارنة بين الموظفين
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Employee && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Employee{id: $id, name: $name}';
  }


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

class _PaidServicesScreenState extends State<PaidServicesScreen> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.serviceColor,
        title: Text(widget.serviceTitle),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.serviceName),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () {}, child: const Text('Continue')),
          ],
        ),
      ),
    );
  }
}

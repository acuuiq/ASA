import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';

class BillingAccountantScreen extends StatefulWidget {
  static const String screenRoute = '/billing-accountant';
  
  const BillingAccountantScreen({super.key});

  @override
  BillingAccountantScreenState createState() => BillingAccountantScreenState();
}

class BillingAccountantScreenState extends State<BillingAccountantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentCitizenTab = 0;
  int _currentPaymentTab = 0;
  String _billFilter = 'الكل';
  // إضافة متغيرات البحث
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  // إضافة متغيرات البحث للتحويلات
  String _transferSearchQuery = '';
  final TextEditingController _transferSearchController = TextEditingController();
  String _selectedPaymentMethodFilter = 'الكل'; // فلتر طريقة الدفع

    // متغيرات التقارير الجديدة
  String _selectedReportType = 'اليومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;
  List<Map<String, dynamic>> _filteredReports = [];

  // الألوان الحكومية (أخضر وذهبي وبني)
  final Color _primaryColor = Color.fromARGB(255, 46, 30, 169); // أخضر حكومي
  final Color _secondaryColor = Color(0xFFD4AF37); // ذهبي
  final Color _accentColor = Color(0xFF8D6E63); // بني
  final Color _backgroundColor = Color(0xFFF5F5F5); // خلفية فاتحة
  final Color _textColor = Color(0xFF212121);
  final Color _textSecondaryColor = Color(0xFF757575);
  final Color _successColor = Color(0xFF2E7D32);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _errorColor = Color(0xFFD32F2F);
  final Color _borderColor = Color(0xFFE0E0E0);
  final Color _cardColor = Color(0xFFFFFFFF);

  // ألوان الوضع الداكن
  final Color _darkPrimaryColor = Color(0xFF1B5E20);
  final Color _darkBackgroundColor = Color(0xFF121212);
  final Color _darkCardColor = Color(0xFF1E1E1E);
  final Color _darkTextColor = Color(0xFFFFFFFF);
  final Color _darkTextSecondaryColor = Color(0xFFB0B0B0);

  String _formatCurrency(dynamic amount) {
    double numericAmount = 0.0;
    if (amount is int) {
      numericAmount = amount.toDouble();
    } else if (amount is double) {
      numericAmount = amount;
    } else if (amount is String) {
      numericAmount = double.tryParse(amount) ?? 0.0;
    }
    
    return '${NumberFormat('#,##0').format(numericAmount)} ';
  }

  // بيانات المواطنين
  final List<Map<String, dynamic>> citizens = [
    {
      'id': 'CIT-2024-001',
      'name': 'أحمد محمد',
      'nationalId': '1234567890',
      'phone': '077235477514',
      'address': 'حي الرياض - شارع الملك فهد',
      'subscriptionType': 'سكني',
      'meterNumber': 'MTR-001234',
      'status': 'active',
      'joinDate': DateTime.now().subtract(Duration(days: 120)),
    },
    {
      'id': 'CIT-2024-002',
      'name': 'فاطمة علي',
      'nationalId': '0987654321',
      'phone': '07827534903',
      'address': 'حي النخيل - شارع الأمير محمد',
      'subscriptionType': 'سكني',
      'meterNumber': 'MTR-001235',
      'status': 'active',
      'joinDate': DateTime.now().subtract(Duration(days: 90)),
    },
    {
      'id': 'CIT-2024-003',
      'name': 'خالد إبراهيم',
      'nationalId': '1122334455',
      'phone': '07758888999',
      'address': 'حي العليا - شارع العروبة',
      'subscriptionType': 'تجاري',
      'meterNumber': 'MTR-001236',
      'status': 'active',
      'joinDate': DateTime.now().subtract(Duration(days: 60)),
    },
  ];

  // بيانات الفواتير
  final List<Map<String, dynamic>> bills = [
    {
      'id': 'INV-2024-001',
      'citizenId': 'CIT-2024-001',
      'citizenName': 'أحمد محمد',
      'amount': 185.75,
      'amountIQD': 91018,
      'dueDate': DateTime.now().add(Duration(days: 5)),
      'status': 'unpaid',
      'consumption': '250 ك.و.س',
      'previousReading': '1250',
      'currentReading': '1500',
      'billingDate': DateTime.now().subtract(Duration(days: 5)),
    },
    {
      'id': 'INV-2024-002',
      'citizenId': 'CIT-2024-002',
      'citizenName': 'فاطمة علي',
      'amount': 230.50,
      'amountIQD': 112945,
      'dueDate': DateTime.now().subtract(Duration(days: 3)),
      'status': 'overdue',
      'consumption': '320 ك.و.س',
      'previousReading': '2100',
      'currentReading': '2420',
      'billingDate': DateTime.now().subtract(Duration(days: 10)),
    },
    {
      'id': 'INV-2024-003',
      'citizenId': 'CIT-2024-003',
      'citizenName': 'خالد إبراهيم',
      'amount': 315.25,
      'amountIQD': 154473,
      'dueDate': DateTime.now().add(Duration(days: 2)),
      'status': 'unpaid',
      'consumption': '280 ك.و.س',
      'previousReading': '3200',
      'currentReading': '3480',
      'billingDate': DateTime.now().subtract(Duration(days: 7)),
    },
  ];

  // بيانات التقارير
  final List<Map<String, dynamic>> reports = [
    {
      'id': 'REP-2024-001',
      'title': 'تقرير الإيرادات الشهري',
      'type': 'مالي',
      'period': 'يناير 2024',
      'generatedDate': DateTime.now().subtract(Duration(days: 2)),
      'totalRevenue': 2500000,
      'totalBills': 150,
      'paidBills': 120,
      'status': 'مكتمل',
      'date': '2024-01-15',
      'time': '10:30 ص',
    },
    {
      'id': 'REP-2024-002',
      'title': 'تقرير الاستهلاك',
      'type': 'فني',
      'period': 'الربع الأول 2024',
      'generatedDate': DateTime.now().subtract(Duration(days: 5)),
      'totalConsumption': '45000 ك.و.س',
      'averageConsumption': '300 ك.و.س/عميل',
      'status': 'قيد المعالجة',
      'date': '2024-01-20',
      'time': '02:15 م',
    },
    {
      'id': 'REP-2024-003',
      'title': 'تقرير المدفوعات المتأخرة',
      'type': 'متابعة',
      'period': 'الشهر الحالي',
      'generatedDate': DateTime.now().subtract(Duration(days: 1)),
      'overdueAmount': 450000,
      'overdueBills': 15,
      'status': 'لم يتم المعالجة',
      'date': '2024-01-25',
      'time': '09:45 ص',
    },
  ];



   // بيانات طرق الدفع  
  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'visa',
      'name': 'بطاقة فيزا',
      'type': 'الكتروني',
      'status': 'active',
      'description': 'الدفع عبر البطاقات الإئتمانية والإنترنت',
      'icon': Icons.credit_card_rounded,
      'color': Colors.blue,
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
      'type': 'الكتروني',
      'status': 'active',
      'description': 'الدفع عبر البطاقات الإئتمانية والإنترنت',
      'icon': Icons.credit_card_rounded,
      'color': Colors.red,
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
      'type': 'الكتروني',
      'status': 'active',
      'description': 'الدفع عبر تطبيقات المحافظ الإلكترونية',
      'icon': Icons.account_balance_wallet_rounded,
      'color': Colors.green,
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
      'type': 'الكتروني',
      'status': 'active',
      'description': 'الدفع عبر تطبيقات المحافظ الإلكترونية',
      'icon': Icons.phone_iphone_rounded,
      'color': Colors.purple,
      'formFields': [
        {'label': 'رقم الهاتف', 'type': 'phone', 'hint': '07XX XXX XXXX'},
        {'label': 'رقم PIN', 'type': 'password', 'hint': 'أدخل الرقم السري'},
      ],
    },
    {
      'id': 'bank_transfer',
      'name': 'التحويل البنكي',
      'type': 'بنكي',
      'status': 'active',
      'description': 'التحويل المباشر عبر فروع البنوك',
      'icon': Icons.account_balance_rounded,
      'color': Colors.blueGrey,
      'formFields': [
        {'label': 'اسم البنك', 'type': 'text', 'hint': 'اسم البنك المحول منه'},
        {'label': 'رقم الحساب', 'type': 'text', 'hint': 'رقم حسابك'},
        {'label': 'رقم المرجع', 'type': 'text', 'hint': 'رقم المرجع للتحويل'},
      ],
    },
    {
      'id': 'alrafidain',
      'name': 'الرافدين',
      'type': 'بنكي',
      'status': 'active',
      'description': 'الدفع عبر فروع بنك الرافدين',
      'icon': Icons.account_balance_rounded,
      'color': Colors.orange,
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
      'type': 'بنكي',
      'status': 'active',
      'description': 'الدفع عبر فروع بنك الرشيد',
      'icon': Icons.account_balance_rounded,
      'color': Colors.teal,
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
    // بيانات الحسابات البنكية الرسمية للوزارة
  final List<Map<String, dynamic>> bankAccounts = [
    {
      'id': 'ACC-001',
      'bankName': 'البنك المركزي العراقي',
      'accountNumber': 'IQ100100100100100100',
      'accountName': 'وزارة الكهرباء - الإيرادات',
      'branch': 'بغداد - الرصافة',
      'currency': 'دينار عراقي',
      'status': 'active',
      'paymentMethods': ['visa', 'mastercard', 'bank_transfer']
    },
    {
      'id': 'ACC-002',
      'bankName': 'بنك الرافدين',
      'accountNumber': '123456789012',
      'accountName': 'وزارة الكهرباء - فواتير',
      'branch': 'بغداد - الكرخ',
      'currency': 'دينار عراقي',
      'status': 'active',
      'paymentMethods': ['alrafidain', 'bank_transfer']
    },
    {
      'id': 'ACC-003', 
      'bankName': 'بنك الرشيد',
      'accountNumber': '987654321098',
      'accountName': 'وزارة الكهرباء - خدمات',
      'branch': 'بغداد - المنصور',
      'currency': 'دينار عراقي',
      'status': 'active',
      'paymentMethods': ['alrasheed', 'bank_transfer']
    },
    {
      'id': 'ACC-004',
      'bankName': 'زين كاش',
      'accountNumber': '9647901234567',
      'accountName': 'وزارة الكهرباء',
      'branch': 'الخدمة الإلكترونية',
      'currency': 'دينار عراقي', 
      'status': 'active',
      'paymentMethods': ['zain_cash']
    },
    {
      'id': 'ACC-005',
      'bankName': 'AsiaPay',
      'accountNumber': 'MOE-ELECTRIC-001',
      'accountName': 'Ministry of Electricity',
      'branch': 'Electronic Payment',
      'currency': 'دينار عراقي',
      'status': 'active',
      'paymentMethods': ['asiapay']
    },
    {
      'id': 'ACC-006',
      'bankName': 'الخزينة العامة',
      'accountNumber': 'CASH-001',
      'accountName': 'وزارة الكهرباء - المبالغ النقدية',
      'branch': 'مكاتب الخدمة',
      'currency': 'دينار عراقي',
      'status': 'active',
      'paymentMethods': ['cash']
    }
  ];
  // بيانات التحويلات لكل طريقة دفع
  final List<Map<String, dynamic>> paymentTransfers = [
    {
      'id': 'TRF-2024-001',
      'paymentMethodId': 'visa',
      'citizenName': 'أحمد محمد',
      'amount': 185750,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(days: 2)),
      'status': 'مكتمل',
      'referenceNumber': 'REF-001234',
      'bankName': 'البنك المركزي العراقي',
      'accountNumber': '1234567890',
    },
    {
      'id': 'TRF-2024-002', 
      'paymentMethodId': 'mastercard',
      'citizenName': 'فاطمة علي',
      'amount': 230500,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(days: 1)),
      'status': 'مكتمل',
      'referenceNumber': 'REF-001235',
      'bankName': 'الرشيد',
      'accountNumber': '0987654321',
    },
    {
      'id': 'TRF-2024-003',
      'paymentMethodId': 'asiapay',
      'citizenName': 'خالد إبراهيم', 
      'amount': 315250,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(days: 3)),
      'status': 'معلق',
      'referenceNumber': 'REF-001236',
      'bankName': 'البلاد',
      'accountNumber': '1122334455',
    },
    {
      'id': 'TRF-2024-004',
      'paymentMethodId': 'zain_cash',
      'citizenName': 'سارة عبدالله',
      'amount': 150000,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(hours: 5)),
      'status': 'مكتمل',
      'referenceNumber': 'REF-001237',
      'paymentLocation': 'فرع الوزارة - بغداد',
    },
    {
      'id': 'TRF-2024-005',
      'paymentMethodId': 'alrafidain',
      'citizenName': 'محمد حسن',
      'amount': 275000,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(days: 4)),
      'status': 'مكتمل',
      'referenceNumber': 'REF-001238',
      'bankName': 'الرافدين',
      'accountNumber': '5566778899',
    },
    {
      'id': 'TRF-2024-006',
      'paymentMethodId': 'alrasheed',
      'citizenName': 'ليلى أحمد',
      'amount': 189000,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(days: 2)),
      'status': 'معلق',
      'referenceNumber': 'REF-001239',
      'bankName': 'الرشيد',
      'accountNumber': '3344556677',
    },
    {
      'id': 'TRF-2024-007',
      'paymentMethodId': 'cash',
      'citizenName': 'علي كريم',
      'amount': 95000,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(hours: 2)),
      'status': 'مكتمل',
      'referenceNumber': 'REF-001240',
      'paymentLocation': 'مكتب الخدمة - الكرخ',
    },
  ];

  // دالة للبحث في المواطنين
  List<Map<String, dynamic>> get filteredCitizens {
    if (_searchQuery.isEmpty) {
      return citizens;
    }
    
    return citizens.where((citizen) {
      return citizen['name'].contains(_searchQuery) ||
             citizen['nationalId'].contains(_searchQuery) ||
             citizen['phone'].contains(_searchQuery) ||
             citizen['address'].contains(_searchQuery) ||
             citizen['meterNumber'].contains(_searchQuery);
    }).toList();
  }
  
  // دالة للبحث في التحويلات
  List<Map<String, dynamic>> get filteredTransfers {
    List<Map<String, dynamic>> allTransfers = paymentTransfers;
    
    // تطبيق فلتر طريقة الدفع أولاً
    if (_selectedPaymentMethodFilter != 'الكل') {
      String methodId = paymentMethods.firstWhere(
        (method) => method['name'] == _selectedPaymentMethodFilter,
        orElse: () => {'id': ''}
      )['id'];
      
      allTransfers = allTransfers.where((transfer) => transfer['paymentMethodId'] == methodId).toList();
    }
    
    // ثم تطبيق البحث النصي
    if (_transferSearchQuery.isEmpty) {
      return allTransfers;
    }
    
    return allTransfers.where((transfer) {
      return transfer['citizenName'].contains(_transferSearchQuery) ||
             transfer['referenceNumber'].contains(_transferSearchQuery) ||
             transfer['bankName']?.contains(_transferSearchQuery) == true ||
             transfer['paymentLocation']?.contains(_transferSearchQuery) == true ||
             transfer['status'].contains(_transferSearchQuery) ||
             _formatCurrency(transfer['amount']).contains(_transferSearchQuery);
    }).toList();
  }

  // دالة لتصفية الفواتير حسب التبويب المختار
  List<Map<String, dynamic>> _getFilteredBills() {
    switch (_billFilter) {
      case 'مدفوعة':
        return bills.where((bill) => bill['status'] == 'paid').toList();
      case 'غير مدفوعة':
        return bills.where((bill) => bill['status'] == 'unpaid').toList();
      case 'متأخرة':
        return bills.where((bill) => bill['status'] == 'overdue').toList();
      case 'الكل':
      default:
        return bills;
    }
  }

  // دالة للحصول على التحويلات حسب طريقة الدفع
  List<Map<String, dynamic>> _getTransfersByPaymentMethod(String paymentMethodId) {
    return paymentTransfers.where((transfer) => transfer['paymentMethodId'] == paymentMethodId).toList();
  }

  // دالة لحساب إجمالي المبالغ المحولة
  double _getTotalTransfersAmount(List<Map<String, dynamic>> transfers) {
    return transfers.fold(0.0, (sum, transfer) => sum + (transfer['amount'] ?? 0));
  }

  // دالة لتحديث البحث
  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // دالة لمسح البحث
  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  // دالة لتحديث بحث التحويلات
  void _updateTransferSearchQuery(String query) {
    setState(() {
      _transferSearchQuery = query;
    });
  }

  // دالة لمسح بحث التحويلات
  void _clearTransferSearch() {
    setState(() {
      _transferSearchQuery = '';
      _transferSearchController.clear();
    });
  }

  // دالة لتغيير فلتر طريقة الدفع
  void _changePaymentMethodFilter(String method) {
    setState(() {
      _selectedPaymentMethodFilter = method;
    });
  }

  // دالة للحصول على الحسابات البنكية المرتبطة بطريقة دفع معينة
  List<Map<String, dynamic>> _getBankAccountsForPaymentMethod(String paymentMethodId) {
    return bankAccounts.where((account) => 
      account['paymentMethods'].contains(paymentMethodId)
    ).toList();
  }

    // ========== دوال التقارير الجديدة ==========

  void _filterReports() {
    setState(() {
      if (_selectedReportType == 'اليومي') {
        if (_selectedDates.isNotEmpty) {
          _filteredReports = reports.where((report) {
            final reportDate = DateTime.parse(report['date']);
            return _selectedDates.any((selectedDate) =>
              reportDate.year == selectedDate.year &&
              reportDate.month == selectedDate.month &&
              reportDate.day == selectedDate.day);
          }).toList();
        } else {
          _filteredReports = reports;
        }
      }
      else if (_selectedReportType == 'الأسبوعي' && _selectedWeek != null) {
        _filteredReports = reports;
      }
      else if (_selectedReportType == 'الشهري' && _selectedMonth != null) {
        _filteredReports = reports;
      }
      else {
        _filteredReports = reports;
      }
    });
  }

  void _showMultiDatePicker() async {
    final List<DateTime>? picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiDatePickerDialog(
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime.now(),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDates = picked;
        _filterReports();
      });
    }
  }

  String _getFilterTitle() {
    switch (_selectedReportType) {
      case 'اليومي':
        return _selectedDates.isNotEmpty 
            ? '${_selectedDates.length} يوم مختار'
            : 'جميع الأيام';
      case 'الأسبوعي':
        return _selectedWeek ?? 'جميع الأسابيع';
      case 'الشهري':
        return _selectedMonth ?? 'جميع الأشهر';
      default:
        return 'الكل';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'لم يتم المعالجة':
        return _errorColor;
      case 'قيد المعالجة':
        return _warningColor;
      case 'مكتمل':
        return _successColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getReportTypeIcon(String type) {
    switch (type) {
      case 'مالي':
        return Icons.attach_money_rounded;
      case 'فني':
        return Icons.engineering_rounded;
      case 'متابعة':
        return Icons.track_changes_rounded;
      default:
        return Icons.description_rounded;
    }
  }

  Color _getReportTypeColor(String type) {
    switch (type) {
      case 'مالي':
        return _successColor;
      case 'فني':
        return _primaryColor;
      case 'متابعة':
        return _warningColor;
      default:
        return _accentColor;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _transferSearchController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final isDarkMode = themeProvider.isDarkMode;
  
  return Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _secondaryColor, width: 2),
            ),
            child: Icon(Icons.bolt_rounded, color: _primaryColor, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'وزارة الكهرباء - نظام الفواتير',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: isDarkMode ? _darkPrimaryColor : _primaryColor,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: _secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsScreen()),
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? _darkPrimaryColor : _primaryColor,
            border: Border(
              bottom: BorderSide(color: _secondaryColor, width: 2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left:0, right:0), // تقليل الهوامش الجانبية
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 4, color: _secondaryColor),
                ),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              padding: EdgeInsets.zero, // إزالة الباددنج الداخلي
              labelPadding: EdgeInsets.symmetric(horizontal:5), // تباعد مناسب بين التبويبات
              tabs: [
                Tab(
                  icon: Icon(Icons.people_alt_rounded, size: 22),
                  text: 'المواطنين',
                ),
                Tab(
                  icon: Icon(Icons.receipt_long_rounded, size: 22),
                  text: 'الفواتير',
                ),
                Tab(
                  icon: Icon(Icons.analytics_rounded, size: 22),
                  text: 'التقارير',
                ),
                Tab(
                  icon: Icon(Icons.payment_rounded, size: 22),
                  text: 'طرق الدفع',
                ),
              ],
            ),
          ),
        ),
      ),
    ),
      body: Container(
        width: double.infinity, // ⬅️ التصحيح هنا
       height: double.infinity, // ⬅️ التصحيح هنا
        decoration: BoxDecoration(
          gradient: isDarkMode 
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_darkBackgroundColor, Color(0xFF1A1A1A)],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_backgroundColor, Color(0xFFE8F5E8)],
                ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // تحديد حجم الشاشة بناءً على حجم الجهاز
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            
            return TabBarView(
              controller: _tabController,
              children: [
                _buildCitizensView(isDarkMode, screenWidth, screenHeight),
                _buildBillsView(isDarkMode, screenWidth, screenHeight),
                _buildReportsView(isDarkMode, screenWidth, screenHeight),
                _buildPaymentMethodsView(isDarkMode, screenWidth, screenHeight),
              ],
            );
          },
        ),
      ),
      drawer: _buildGovernmentDrawer(context, isDarkMode),
    );
  }

  Widget _buildCitizensView(bool isDarkMode, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            _buildSearchBar(isDarkMode, 'ابحث عن مواطن...'),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                'سجل المواطنين',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? _darkTextColor : _primaryColor,
                ),
              ),
            ),
            SizedBox(height: 12),
            if (filteredCitizens.isEmpty && _searchQuery.isNotEmpty)
              _buildNoResults(isDarkMode)
            else
              ...filteredCitizens.map((citizen) => _buildCitizenCard(citizen, isDarkMode)),
          ],
        ),
      ),
    );
  }

  Widget _buildBillsView(bool isDarkMode, double screenWidth, double screenHeight) {
    List<Map<String, dynamic>> filteredBills = _getFilteredBills();

    return Container(
      width: screenWidth,
      height: screenHeight,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBillsStatsCard(isDarkMode),
            SizedBox(height: 20),
            _buildBillsFilterRow(isDarkMode),
            SizedBox(height: 20),
            Text(
              'الفواتير الحالية',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? _darkTextColor : _primaryColor,
              ),
            ),
            SizedBox(height: 16),
            if (filteredBills.isEmpty)
              _buildNoBillsMessage(isDarkMode)
            else
              ...filteredBills.map((bill) => _buildBillCard(bill, isDarkMode)),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsView(bool isDarkMode, double screenWidth, double screenHeight) {
  return SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // بطاقة العنوان الرئيسية
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor, _secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
            ],
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
                child: Icon(Icons.analytics, size: 30, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'نظام التقارير المتقدم',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'تصفية وعرض التقارير حسب الفترة الزمنية',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        SizedBox(height: 20),

        // بطاقة الفلترة الزمنية
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode ? _darkCardColor : _cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.filter_alt, color: _primaryColor),
                  SizedBox(width: 8),
                  Text(
                    'الفلترة الزمنية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? _darkTextColor : _textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // أزرار نوع التقرير
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildReportTypeButton('اليومي', Icons.today, _primaryColor, isDarkMode),
                    SizedBox(width: 8),
                    _buildReportTypeButton('الأسبوعي', Icons.calendar_view_week, _secondaryColor, isDarkMode),
                    SizedBox(width: 8),
                    _buildReportTypeButton('الشهري', Icons.calendar_today, _accentColor, isDarkMode),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // واجهة الفلترة حسب النوع المختار
              _buildDateFilterInterface(isDarkMode),
            ],
          ),
        ),

        SizedBox(height: 20),

        // بطاقة الإحصائيات
        _buildStatisticsCard(isDarkMode),

        SizedBox(height: 20),

        // قائمة التقارير المفلترة
        _buildFilteredReportsList(isDarkMode),

        SizedBox(height: 20),
      ],
    ),
  );
 }
 Widget _buildReportTypeButton(String title, IconData icon, Color color, bool isDarkMode) {
  bool isSelected = _selectedReportType == title;
  return ElevatedButton(
    onPressed: () {
      setState(() {
        _selectedReportType = title;
        _selectedDates = [];
        _selectedWeek = null;
        _selectedMonth = null;
        _filterReports();
      });
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: isSelected ? color : (isDarkMode ? _darkCardColor : _cardColor),
      foregroundColor: isSelected ? Colors.white : color,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? color : (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
          width: 2,
        ),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
 }
 Widget _buildDateFilterInterface(bool isDarkMode) {
  switch (_selectedReportType) {
    case 'اليومي':
      return _buildDailyFilter(isDarkMode);
    case 'الأسبوعي':
      return _buildWeeklyFilter(isDarkMode);
    case 'الشهري':
      return _buildMonthlyFilter(isDarkMode);
    default:
      return _buildDailyFilter(isDarkMode);
  }
} 
Widget _buildDailyFilter(bool isDarkMode) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'اختر التاريخ:',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? _darkTextColor : _textColor,
        ),
      ),
      SizedBox(height: 12),
      
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
        ),
        child: ListTile(
          leading: Icon(Icons.calendar_today, color: _primaryColor),
          title: Text(
            _selectedDates.isNotEmpty 
                ? '${_selectedDates.length} يوم مختار'
                : 'اختر التاريخ',
            style: TextStyle(
              color: isDarkMode ? _darkTextColor : _textColor,
            ),
          ),
          trailing: Icon(Icons.arrow_drop_down),
          onTap: _showMultiDatePicker,
        ),
      ),
      
      if (_selectedDates.isNotEmpty) ...[
        SizedBox(height: 12),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black12 : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _primaryColor.withOpacity(0.3)),
          ),
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: _selectedDates.length,
            itemBuilder: (context, index) {
              final date = _selectedDates[index];
              return ListTile(
                leading: Icon(Icons.event, color: _primaryColor),
                title: Text(
                  DateFormat('yyyy-MM-dd').format(date),
                  style: TextStyle(
                    color: isDarkMode ? _darkTextColor : _textColor,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.close, color: _errorColor, size: 18),
                  onPressed: () {
                    setState(() {
                      _selectedDates.removeAt(index);
                      _filterReports();
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
      
      SizedBox(height: 12),
      if (_selectedDates.isNotEmpty)
        ElevatedButton(
          onPressed: _filterReports,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'عرض التقارير للفترة المختارة',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
    ],
  );
}

Widget _buildWeeklyFilter(bool isDarkMode) {
  List<String> weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'اختر الأسبوع:',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? _darkTextColor : _textColor,
        ),
      ),
      SizedBox(height: 12),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: weeks.map((week) {
          bool isSelected = _selectedWeek == week;
          return FilterChip(
            label: Text(week),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedWeek = selected ? week : null;
                _filterReports();
              });
            },
            selectedColor: _secondaryColor,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : (isDarkMode ? _darkTextColor : _textColor),
            ),
          );
        }).toList(),
      ),
    ],
  );
}

Widget _buildMonthlyFilter(bool isDarkMode) {
  List<String> months = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'اختر الشهر:',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? _darkTextColor : _textColor,
        ),
      ),
      SizedBox(height: 12),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: months.map((month) {
          bool isSelected = _selectedMonth == month;
          return FilterChip(
            label: Text(month),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedMonth = selected ? month : null;
                _filterReports();
              });
            },
            selectedColor: _accentColor,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : (isDarkMode ? _darkTextColor : _textColor),
            ),
          );
        }).toList(),
      ),
    ],
  );
}
Widget _buildStatisticsCard(bool isDarkMode) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDarkMode ? _darkCardColor : _cardColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bar_chart, color: _primaryColor),
            SizedBox(width: 8),
            Text(
              'الإحصائيات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
            Spacer(),
            Text(
              _getFilterTitle(),
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _buildStatItem('إجمالي التقارير', _filteredReports.length.toString(), 
                Icons.description, _primaryColor, isDarkMode),
            _buildStatItem('لم تتم المعالجة', 
                _filteredReports.where((r) => r['status'] == 'لم يتم المعالجة').length.toString(),
                Icons.pending_actions, _errorColor, isDarkMode),
            _buildStatItem('قيد المعالجة', 
                _filteredReports.where((r) => r['status'] == 'قيد المعالجة').length.toString(),
                Icons.hourglass_bottom, _warningColor, isDarkMode),
            _buildStatItem('مكتمل', 
                _filteredReports.where((r) => r['status'] == 'مكتمل').length.toString(),
                Icons.check_circle, _successColor, isDarkMode),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildPaymentMethodsView(bool isDarkMode, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentMethodsSummaryCard(isDarkMode),
            SizedBox(height: 20),
            Text(
              'طرق الدفع المتاحة',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? _darkTextColor : _primaryColor,
              ), 
            ),
            SizedBox(height: 16),
            ...paymentMethods.map((method) => _buildPaymentMethodCard(method, isDarkMode)),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, 
               size: 64, 
               color: _textSecondaryColor),
          SizedBox(height: 16),
          Text(
            'لا توجد نتائج للبحث',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لم نتمكن من العثور على أي مواطن يطابق "$_searchQuery"',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textSecondaryColor,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _clearSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('مسح البحث'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoBillsMessage(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, 
               size: 64, 
               color: _textSecondaryColor),
          SizedBox(height: 16),
          Text(
            'لا توجد فواتير',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لا توجد فواتير تطابق التصفية المختارة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsStatsCard(bool isDarkMode) {
    int paidBills = bills.where((bill) => bill['status'] == 'paid').length;
    int unpaidBills = bills.where((bill) => bill['status'] == 'unpaid').length;
    int overdueBills = bills.where((bill) => bill['status'] == 'overdue').length;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? _darkCardColor : _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBillStat('إجمالي الفواتير', bills.length.toString(), Icons.receipt_rounded, _primaryColor),
            _buildBillStat('مدفوعة', paidBills.toString(), Icons.check_circle_rounded, _successColor),
            _buildBillStat('غير مدفوعة', unpaidBills.toString(), Icons.pending_rounded, _warningColor),
            _buildBillStat('متأخرة', overdueBills.toString(), Icons.warning_rounded, _errorColor),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsSummaryCard(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? _darkCardColor : _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.analytics_rounded, color: _primaryColor, size: 28),
                ),
                SizedBox(width: 12),
                Text(
                  'ملخص التقارير',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? _darkTextColor : _primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildReportStat('مالية', '2', _primaryColor),
                _buildReportStat('فنية', '1', _accentColor),
                _buildReportStat('متابعة', '1', _secondaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsSummaryCard(bool isDarkMode) {
    int activeMethods = paymentMethods.where((method) => method['status'] == 'active').length;
    int inactiveMethods = paymentMethods.where((method) => method['status'] == 'inactive').length;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? _darkCardColor : _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildPaymentMethodStat('طرق الدفع', paymentMethods.length.toString(), Icons.payment_rounded, _primaryColor),
            _buildPaymentMethodStat('نشطة', activeMethods.toString(), Icons.check_circle_rounded, _successColor),
            _buildPaymentMethodStat('غير نشطة', inactiveMethods.toString(), Icons.pause_circle_rounded, _warningColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCitizenCard(Map<String, dynamic> citizen, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? _darkCardColor : _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: _primaryColor, width: 1),
          ),
          child: Icon(Icons.person_rounded, color: _primaryColor, size: 24),
        ),
        title: Text(
          citizen['name'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: isDarkMode ? _darkTextColor : _textColor,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'الرقم الوطني: ${citizen['nationalId']}',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 2),
            Text(
              'رقم العداد: ${citizen['meterNumber']}',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          constraints: BoxConstraints(
            minWidth: 50,
            maxWidth: 70,
          ),
          decoration: BoxDecoration(
            color: _successColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _successColor.withOpacity(0.3)),
          ),
          child: Text(
            'نشط',
            style: TextStyle(
              fontSize: 12,
              color: _successColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        onTap: () {
          _showCitizenDetails(citizen, isDarkMode);
        },
      ),
    );
  }

  Widget _buildBillCard(Map<String, dynamic> bill, bool isDarkMode) {
    Color statusColor = _getBillStatusColor(bill['status']);
    String statusText = _getBillStatusText(bill['status']);
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? _darkCardColor : _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.receipt_long_rounded, color: statusColor, size: 24),
        ),
        title: Text(
          'فاتورة #${bill['id']}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: isDarkMode ? _darkTextColor : _textColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              bill['citizenName'],
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
              ),
            ),
            SizedBox(height: 2),
            Text(
              '${_formatCurrency(bill['amountIQD'])} - ${bill['consumption']}',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          _showBillDetails(bill, isDarkMode);
        },
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report, bool isDarkMode) {
  Color statusColor = _getStatusColor(report['status']);
  
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDarkMode ? Colors.white10 : _cardColor,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getReportTypeColor(report['type']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getReportTypeIcon(report['type']),
            color: _getReportTypeColor(report['type']),
            size: 24,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                report['title'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? _darkTextColor : _textColor,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${report['type']} - ${report['period']}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 12, color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor),
                  SizedBox(width: 4),
                  Text(
                    report['date'],
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.access_time, size: 12, color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor),
                  SizedBox(width: 4),
                  Text(
                    report['time'],
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            report['status'],
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ),
      ],
    ),
  );
 }
 Widget _buildEmptyState(bool isDarkMode) {
  return Container(
    padding: EdgeInsets.all(40),
    child: Column(
      children: [
        Icon(Icons.inbox, size: 60, color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor),
        SizedBox(height: 16),
        Text(
          'لا توجد تقارير',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'لم يتم العثور على تقارير تطابق معايير البحث الحالية',
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

  Widget _buildPaymentMethodCard(Map<String, dynamic> method, bool isDarkMode) {
    bool isActive = method['status'] == 'active';
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? _darkCardColor : _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isActive ? _primaryColor.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(method['icon'], color: isActive ? _primaryColor : Colors.grey, size: 24),
        ),
        title: Text(
          method['name'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: isDarkMode ? _darkTextColor : _textColor,
          ),
        ),
        subtitle: Text(
          method['description'],
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? _successColor.withOpacity(0.1) : _warningColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isActive ? _successColor.withOpacity(0.3) : _warningColor.withOpacity(0.3)),
          ),
          child: Text(
            isActive ? 'نشط' : 'غير نشط',
            style: TextStyle(
              fontSize: 12,
              color: isActive ? _successColor : _warningColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          _showPaymentMethodDetails(method, isDarkMode);
        },
      ),
    );
  }

  Widget _buildBillStat(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildReportStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: _textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodStat(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(bool isDarkMode, String hintText) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? _darkCardColor : _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _updateSearchQuery,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(Icons.search_rounded, color: _textSecondaryColor),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: _textSecondaryColor),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // شريط البحث للتحويلات
  Widget _buildTransferSearchBar(bool isDarkMode, String hintText) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? _darkCardColor : _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : _borderColor,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _transferSearchController,
        onChanged: _updateTransferSearchQuery,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(Icons.search_rounded, color: _textSecondaryColor),
          suffixIcon: _transferSearchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: _textSecondaryColor),
                  onPressed: _clearTransferSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  // صف أزرار التصفية للتحويلات
  Widget _buildTransferFilterRow(bool isDarkMode) {
    List<String> paymentMethodsNames = ['الكل'] + paymentMethods.map((method) => method['name'] as String).toList();
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: paymentMethodsNames.map((method) {
          return _buildTransferFilterChip(method, isDarkMode);
        }).toList(),
      ),
    );
  }

  // زر التصفية للتحويلات
  Widget _buildTransferFilterChip(String method, bool isDarkMode) {
    bool isSelected = _selectedPaymentMethodFilter == method;
    return Container(
      margin: EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: () => _changePaymentMethodFilter(method),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor : (isDarkMode ? _darkCardColor : _cardColor),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? _primaryColor : (isDarkMode ? Colors.grey[700]! : _borderColor),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (method != 'الكل')
                Icon(
                  paymentMethods.firstWhere(
                    (m) => m['name'] == method,
                    orElse: () => {'icon': Icons.payment_rounded}
                  )['icon'],
                  size: 14,
                  color: isSelected ? Colors.white : _primaryColor,
                ),
              if (method != 'الكل') SizedBox(width: 4),
              Text(
                method,
                style: TextStyle(
                  color: isSelected ? Colors.white : (isDarkMode ? _darkTextColor : _textColor),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // إحصائيات مصغرة للتحويلات
  Widget _buildTransferMiniStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor,
          ),
        ),
      ],
    );
  }

  // رسالة عدم وجود تحويلات
  Widget _buildNoTransfersMessageForMethod(bool isDarkMode, String methodName) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.payment_rounded, 
             size: 64, 
             color: _textSecondaryColor),
        SizedBox(height: 16),
        Text(
          'لا توجد تحويلات',
          style: TextStyle(
            fontSize: 18,
            color: _textSecondaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'لم يتم العثور على أي تحويلات لطريقة الدفع\n$methodName',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textSecondaryColor,
          ),
        ),
      ],
    ),
  );
}


  Widget _buildBillsFilterRow(bool isDarkMode) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildBillFilterChip('الكل', 'الكل', isDarkMode),
          SizedBox(width: 8),
          _buildBillFilterChip('مدفوعة', 'مدفوعة', isDarkMode),
          SizedBox(width: 8),
          _buildBillFilterChip('غير مدفوعة', 'غير مدفوعة', isDarkMode),
          SizedBox(width: 8),
          _buildBillFilterChip('متأخرة', 'متأخرة', isDarkMode),
        ],
      ),
    );
  }

  Widget _buildBillFilterChip(String label, String filter, bool isDarkMode) {
    bool isSelected = _billFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _billFilter = filter;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : (isDarkMode ? _darkCardColor : _cardColor),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _primaryColor : (isDarkMode ? Colors.grey[700]! : _borderColor),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDarkMode ? _darkTextColor : _textColor),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getBillStatusColor(String status) {
    switch (status) {
      case 'paid':
        return _successColor;
      case 'unpaid':
        return _warningColor;
      case 'overdue':
        return _errorColor;
      default:
        return _textSecondaryColor;
    }
  }

  String _getBillStatusText(String status) {
    switch (status) {
      case 'paid':
        return 'مدفوعة';
      case 'unpaid':
        return 'غير مدفوعة';
      case 'overdue':
        return 'متأخرة';
      default:
        return 'غير معروف';
    }
  }

  // بناء القائمة المنسدلة - محدثة لتكون مطابقة للصورة
Widget _buildGovernmentDrawer(BuildContext context, bool isDarkMode) {
  return Drawer(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode 
              ? [_darkPrimaryColor, Color(0xFF0D1B0E)]
              : [_primaryColor, Color(0xFF4CAF50)],
        ),
      ),
      child: Column(
        children: [
          // رأس الملف الشخصي - مطابق للصورة
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDarkMode 
                    ? [_darkPrimaryColor, Color(0xFF1B5E20)]
                    : [_primaryColor, Color(0xFF388E3C)],
              ),
            ),
            child: Column(
              children: [
                // الصورة الرمزية
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),
                // الاسم والوظيفة
                Text(
                  "محاسب الفواتير",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "محاسب - قسم المحاسبة",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                // المنطقة
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "المنطقة الوسطى",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // القائمة الرئيسية - مطابقة للصورة
          Expanded(
            child: Container(
              color: isDarkMode ? Color(0xFF0D1B0E) : Color(0xFFE8F5E9),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 20),
                  // الإعدادات
                  _buildDrawerMenuItem(
                    icon: Icons.settings_rounded,
                    title: 'الإعدادات',
                    onTap: () {
                      Navigator.pop(context);
                      _showSettingsScreen(context, isDarkMode);
                    },
                    isDarkMode: isDarkMode,
                  ),
                  
                  // المساعدة والدعم
                  _buildDrawerMenuItem(
                    icon: Icons.help_rounded,
                    title: 'المساعدة والدعم',
                    onTap: () {
                      Navigator.pop(context);
                      _showHelpSupportScreen(context, isDarkMode);
                    },
                    isDarkMode: isDarkMode,
                  ),

                  SizedBox(height: 30),
                  
                  // تسجيل الخروج
                  _buildDrawerMenuItem(
                    icon: Icons.logout_rounded,
                    title: 'تسجيل الخروج',
                    onTap: () {
                      _showLogoutConfirmation(context, isDarkMode);
                    },
                    isDarkMode: isDarkMode,
                    isLogout: true,
                  ),

                  SizedBox(height: 40),
                  
                  // معلومات النسخة - في الأسفل
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Divider(
                          color: isDarkMode ? Colors.white24 : Colors.grey[400],
                          height: 1,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'وزارة الكهرباء - نظام الفواتير',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'الإصدار 1.0.0',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white54 : Colors.grey[600],
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// دالة مساعدة لبناء عناصر القائمة - مطابقة للتصميم في الصورة
Widget _buildDrawerMenuItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  required bool isDarkMode,
  bool isLogout = false,
}) {
  final Color textColor = isDarkMode ? Colors.white : Colors.black87;
  final Color iconColor = isLogout 
      ? Colors.red 
      : (isDarkMode ? Colors.white70 : Colors.grey[700]!);

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: isLogout ? Colors.red.withOpacity(0.1) : Colors.transparent,
    ),
    child: ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isLogout 
              ? Colors.red.withOpacity(0.2)
              : (isDarkMode ? Colors.white12 : Colors.grey[100]),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_left_rounded,
        color: isLogout ? Colors.red : (isDarkMode ? Colors.white54 : Colors.grey[500]),
        size: 24,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
    ),
  );
}
void _showLogoutConfirmation(BuildContext context, bool isDarkMode) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.logout_rounded, color: _errorColor),
          SizedBox(width: 8),
          Text('تأكيد تسجيل الخروج'),
        ],
      ),
      content: Text(
        'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
        style: TextStyle(
          color: isDarkMode ? _darkTextColor : _textColor,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // إغلاق حوار التأكيد
            Navigator.pushReplacementNamed(context, EsigninScreen.screenroot);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _errorColor,
            foregroundColor: Colors.white,
          ),
          child: Text('تسجيل الخروج'),
        ),
      ],
    ),
  );
}
 // دوال العرض التفصيلي
  void _showCitizenDetails(Map<String, dynamic> citizen, bool isDarkMode) {
  // الحصول على فواتير المواطن
  List<Map<String, dynamic>> citizenBills = bills.where((bill) => bill['citizenId'] == citizen['id']).toList();
  
  // تصنيف الفواتير حسب التبويبات المطلوبة
  List<Map<String, dynamic>> paidBills = citizenBills.where((bill) => bill['status'] == 'paid').toList();
  List<Map<String, dynamic>> unpaidBills = citizenBills.where((bill) => bill['status'] == 'unpaid').toList();
  List<Map<String, dynamic>> completedBills = citizenBills.where((bill) => bill['status'] == 'paid').toList();
  List<Map<String, dynamic>> earlyPaymentBills = citizenBills.where((bill) => bill['status'] == 'paid' && bill['paidDate'] != null && bill['paidDate'].isBefore(bill['dueDate'])).toList();
  List<Map<String, dynamic>> onTimePaymentBills = citizenBills.where((bill) => bill['status'] == 'paid' && bill['paidDate'] != null && _isSameDay(bill['paidDate'], bill['dueDate'])).toList();
  List<Map<String, dynamic>> latePaymentBills = citizenBills.where((bill) => bill['status'] == 'overdue').toList();

  // بيانات الخدمات الإضافية
  List<Map<String, dynamic>> citizenServices = [
    {
      'id': 'SRV-001',
      'name': 'تركيب عداد ذكي',
      'purchaseDate': DateTime.now().subtract(Duration(days: 30)),
      'amount': 150000.0,
      'status': 'مكتمل',
      'paymentMethod': 'الدفع الإلكتروني',
      'paymentDate': DateTime.now().subtract(Duration(days: 30)),
    },
    {
      'id': 'SRV-002', 
      'name': 'صيانة دورية',
      'purchaseDate': DateTime.now().subtract(Duration(days: 15)),
      'amount': 75000.0,
      'status': 'مكتمل',
      'paymentMethod': 'التحويل البنكي',
      'paymentDate': DateTime.now().subtract(Duration(days: 15)),
    }
  ];

  // إضافة بيانات الدفع للفواتير المدفوعة
  paidBills = paidBills.map((bill) {
    return {
      ...bill,
      'paidDate': bill['dueDate']?.subtract(Duration(days: 2)) ?? DateTime.now().subtract(Duration(days: 2)),
      'paymentMethod': 'الدفع الإلكتروني'
    };
  }).toList();

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(0), // ⬅️ هذا مهم
          child: Container(
            width: MediaQuery.of(context).size.width, // ⬅️ عرض كامل
            height: MediaQuery.of(context).size.height, // ⬅️ طول كامل
            child: Column(
              children: [
                // الهيدر
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'تفاصيل المواطن - ${citizen['name']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // التبويبات
                Container(
                  height: 50,
                  color: isDarkMode ? _darkCardColor : _cardColor,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildTabButton('المعلومات', 0, setState, isDarkMode),
                      _buildTabButton('المدفوعة', 1, setState, isDarkMode),
                      _buildTabButton('غير المدفوعة', 2, setState, isDarkMode),
                      _buildTabButton('المكتملة', 3, setState, isDarkMode),
                      _buildTabButton('الدفع المبكر', 4, setState, isDarkMode),
                      _buildTabButton('الدفع بالموعد', 5, setState, isDarkMode),
                      _buildTabButton('المتأخرة', 6, setState, isDarkMode),
                      _buildTabButton('الخدمات', 7, setState, isDarkMode),
                    ],
                  ),
                ),
                
                // المحتوى
                Expanded(
                  child: Container(
                    color: isDarkMode ? _darkBackgroundColor : _backgroundColor,
                    child: _buildTabContent(_currentCitizenTab, citizen, citizenBills, paidBills, unpaidBills, completedBills, earlyPaymentBills, onTimePaymentBills, latePaymentBills, citizenServices, isDarkMode, setState),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildTabButton(String title, int tabIndex, StateSetter setState, bool isDarkMode) {
  bool isSelected = _currentCitizenTab == tabIndex;
  return GestureDetector(
    onTap: () {
      setState(() {
        _currentCitizenTab = tabIndex;
      });
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? _primaryColor : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: isSelected ? _secondaryColor : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : (isDarkMode ? _darkTextColor : _textColor),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    ),
  );
}

Widget _buildTabContent(
  int tabIndex, 
  Map<String, dynamic> citizen, 
  List<Map<String, dynamic>> allBills,
  List<Map<String, dynamic>> paidBills,
  List<Map<String, dynamic>> unpaidBills,
  List<Map<String, dynamic>> completedBills,
  List<Map<String, dynamic>> earlyPaymentBills,
  List<Map<String, dynamic>> onTimePaymentBills,
  List<Map<String, dynamic>> latePaymentBills,
  List<Map<String, dynamic>> services,
  bool isDarkMode,
  StateSetter setState,
) {
  switch (tabIndex) {
    case 0: // المعلومات
      return _buildInfoTab(citizen, isDarkMode);
    case 1: // المدفوعة
      return _buildBillsTab(paidBills, 'الفواتير المدفوعة', _successColor, isDarkMode, true);
    case 2: // غير المدفوعة
      return _buildBillsTab(unpaidBills, 'الفواتير غير المدفوعة', _warningColor, isDarkMode, false);
    case 3: // المكتملة
      return _buildBillsTab(completedBills, 'الفواتير المكتملة', _successColor, isDarkMode, true);
    case 4: // الدفع المبكر
      return _buildBillsTab(earlyPaymentBills, 'الدفع المبكر', _successColor, isDarkMode, true);
    case 5: // الدفع بالموعد
      return _buildBillsTab(onTimePaymentBills, 'الدفع بالموعد', _primaryColor, isDarkMode, true);
    case 6: // المتأخرة
      return _buildBillsTab(latePaymentBills, 'الفواتير المتأخرة', _errorColor, isDarkMode, false);
    case 7: // الخدمات
      return _buildServicesTab(services, isDarkMode);
    default:
      return _buildInfoTab(citizen, isDarkMode);
  }
}

Widget _buildInfoTab(Map<String, dynamic> citizen, bool isDarkMode) {
  return SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المعلومات الأساسية',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? _darkTextColor : _primaryColor,
          ),
        ),
        SizedBox(height: 16),
        _buildInfoRow('الاسم:', citizen['name'], isDarkMode),
        _buildInfoRow('الرقم الوطني:', citizen['nationalId'], isDarkMode),
        _buildInfoRow('رقم الهاتف:', citizen['phone'], isDarkMode),
        _buildInfoRow('العنوان:', citizen['address'], isDarkMode),
        _buildInfoRow('نوع الاشتراك:', citizen['subscriptionType'], isDarkMode),
        _buildInfoRow('رقم العداد:', citizen['meterNumber'], isDarkMode),
        _buildInfoRow('الحالة:', 'نشط', isDarkMode),
        _buildInfoRow('تاريخ الانضمام:', DateFormat('yyyy-MM-dd').format(citizen['joinDate']), isDarkMode),
      ],
    ),
  );
}

Widget _buildBillsTab(List<Map<String, dynamic>> bills, String title, Color color, bool isDarkMode, bool isPaid) {
  return Column(
    children: [
      // الهيدر
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border(bottom: BorderSide(color: color.withOpacity(0.3))),
        ),
        child: Row(
          children: [
            Icon(Icons.receipt_long_rounded, color: color),
            SizedBox(width: 8),
            Text(
              '$title (${bills.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
      
      // قائمة الفواتير
      Expanded(
        child: bills.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 64, color: _textSecondaryColor),
                    SizedBox(height: 16),
                    Text(
                      'لا توجد فواتير',
                      style: TextStyle(
                        fontSize: 16,
                        color: _textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  return _buildBillItem(bills[index], isDarkMode, isPaid, color);
                },
              ),
      ),
    ],
  );
}

Widget _buildServicesTab(List<Map<String, dynamic>> services, bool isDarkMode) {
  return Column(
    children: [
      // الهيدر
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _accentColor.withOpacity(0.1),
          border: Border(bottom: BorderSide(color: _accentColor.withOpacity(0.3))),
        ),
        child: Row(
          children: [
            Icon(Icons.build_rounded, color: _accentColor),
            SizedBox(width: 8),
            Text(
              'الخدمات المشتراة (${services.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _accentColor,
              ),
            ),
          ],
        ),
      ),
      
      // قائمة الخدمات
      Expanded(
        child: services.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.build_outlined, size: 64, color: _textSecondaryColor),
                    SizedBox(height: 16),
                    Text(
                      'لا توجد خدمات مشتراة',
                      style: TextStyle(
                        fontSize: 16,
                        color: _textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return _buildServiceItem(services[index], isDarkMode);
                },
              ),
      ),
    ],
  );
}

Widget _buildBillItem(Map<String, dynamic> bill, bool isDarkMode, bool isPaid, Color color) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: isDarkMode ? Colors.white10 : _cardColor,
      border: Border.all(color: color.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'فاتورة #${bill['id']}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isPaid ? 'مدفوعة' : 'غير مدفوعة',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildBillDetailRow('الاستهلاك:', bill['consumption'], isDarkMode),
        _buildBillDetailRow('المبلغ:', _formatCurrency(bill['amountIQD']), isDarkMode),
        _buildBillDetailRow('القراءة السابقة:', bill['previousReading'], isDarkMode),
        _buildBillDetailRow('القراءة الحالية:', bill['currentReading'], isDarkMode),
        _buildBillDetailRow('تاريخ الفاتورة:', DateFormat('yyyy-MM-dd').format(bill['billingDate']), isDarkMode),
        _buildBillDetailRow('تاريخ الاستحقاق:', DateFormat('yyyy-MM-dd').format(bill['dueDate']), isDarkMode),
        if (isPaid) ...[
          _buildBillDetailRow('طريقة الدفع:', bill['paymentMethod'] ?? 'غير محدد', isDarkMode),
          _buildBillDetailRow('تاريخ الدفع:', DateFormat('yyyy-MM-dd').format(bill['paidDate'] ?? DateTime.now()), isDarkMode),
        ],
      ],
    ),
  );
}

Widget _buildServiceItem(Map<String, dynamic> service, bool isDarkMode) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: isDarkMode ? Colors.white10 : _cardColor,
      border: Border.all(color: _accentColor.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              service['name'],
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                service['status'],
                style: TextStyle(
                  fontSize: 12,
                  color: _successColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildBillDetailRow('المبلغ:', _formatCurrency(service['amount']), isDarkMode),
        _buildBillDetailRow('طريقة الدفع:', service['paymentMethod'], isDarkMode),
        _buildBillDetailRow('تاريخ الشراء:', DateFormat('yyyy-MM-dd').format(service['purchaseDate']), isDarkMode),
        _buildBillDetailRow('تاريخ الدفع:', DateFormat('yyyy-MM-dd').format(service['paymentDate']), isDarkMode),
      ],
    ),
  );
}

Widget _buildInfoRow(String label, String value, bool isDarkMode) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              color: isDarkMode ? _darkTextColor : _textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildBillDetailRow(String label, String value, bool isDarkMode) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? _darkTextColor : _textColor,
            ),
          ),
        ),
      ],
    ),
  );
}

bool _isSameDay(DateTime? date1, DateTime? date2) {
  if (date1 == null || date2 == null) return false;
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

  void _showBillDetails(Map<String, dynamic> bill, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.receipt_long_rounded, color: _primaryColor),
            SizedBox(width: 8),
            Text('تفاصيل الفاتورة'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('رقم الفاتورة:', bill['id']),
              _buildDetailRow('المواطن:', bill['citizenName']),
              _buildDetailRow('المبلغ:', _formatCurrency(bill['amountIQD'])),
              _buildDetailRow('الاستهلاك:', bill['consumption']),
              _buildDetailRow('القراءة السابقة:', bill['previousReading']),
              _buildDetailRow('القراءة الحالية:', bill['currentReading']),
              _buildDetailRow('تاريخ الفاتورة:', DateFormat('yyyy-MM-dd').format(bill['billingDate'])),
              _buildDetailRow('تاريخ الاستحقاق:', DateFormat('yyyy-MM-dd').format(bill['dueDate'])),
              _buildDetailRow('الحالة:', _getBillStatusText(bill['status'])),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _primaryColor)),
          ),
        ],
      ),
    );
  }

  void _showReportDetails(Map<String, dynamic> report, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.description_rounded, color: _primaryColor),
            SizedBox(width: 8),
            Text('تفاصيل التقرير'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('العنوان:', report['title']),
              _buildDetailRow('النوع:', report['type']),
              _buildDetailRow('الفترة:', report['period']),
              _buildDetailRow('تاريخ الإنشاء:', DateFormat('yyyy-MM-dd').format(report['generatedDate'])),
              if (report['totalRevenue'] != null)
                _buildDetailRow('إجمالي الإيرادات:', _formatCurrency(report['totalRevenue'])),
              if (report['totalConsumption'] != null)
                _buildDetailRow('إجمالي الاستهلاك:', report['totalConsumption']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _primaryColor)),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodDetails(Map<String, dynamic> method, bool isDarkMode) {
  List<Map<String, dynamic>> methodTransfers = _getTransfersByPaymentMethod(method['id']);
  double totalAmount = _getTotalTransfersAmount(methodTransfers);
  List<Map<String, dynamic>> methodBankAccounts = _getBankAccountsForPaymentMethod(method['id']);

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: isDarkMode ? _darkCardColor : _cardColor,
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              children: [
                // الهيدر
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 8,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                       ),
                       Center(
                         child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             SizedBox(height: MediaQuery.of(context).padding.top + 2),
                             Text(
                               'تفاصيل ${method['name']}',
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 22,
                                 fontWeight: FontWeight.w700,
                               ),
                             ),
                             SizedBox(height: 8),
                             Text(
                               '${methodTransfers.length} تحويل - ${_formatCurrency(totalAmount)}',
                               style: TextStyle(
                                 color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                               ),
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                 ),
 
                 // التبويبات
                 Container(
                   height: 50,
                   decoration: BoxDecoration(
                     border: Border(bottom: BorderSide(color: _borderColor)),
                   ),
                   child: Row(
                     children: [
                       _buildPaymentTabButton('المعلومات', 0, setState, isDarkMode),
                       _buildPaymentTabButton('الحسابات', 1, setState, isDarkMode),
                       _buildPaymentTabButton('التحويلات', 2, setState, isDarkMode),
                       _buildPaymentTabButton('الإحصائيات', 3, setState, isDarkMode),
                     ],
                   ),
                 ),
 
                 // المحتوى
                 Expanded(
                   child: _buildPaymentTabContent(_currentPaymentTab, method, methodTransfers, totalAmount, methodBankAccounts, isDarkMode),
                 ),
               ],
             ),
           ),
         );
       },
     ),
   );
 }
 Widget _buildPaymentTabButton(String title, int tabIndex, StateSetter setState, bool isDarkMode) {
    bool isSelected = _currentPaymentTab == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentPaymentTab = tabIndex;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? _secondaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : (isDarkMode ? _darkTextColor : _textColor),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentTabContent(int tabIndex, Map<String, dynamic> method, List<Map<String, dynamic>> transfers, double totalAmount, List<Map<String, dynamic>> bankAccounts, bool isDarkMode) {
    switch (tabIndex) {
     case 0: // المعلومات
       return _buildPaymentInfoTab(method, isDarkMode);
     case 1: // الحسابات البنكية
       return _buildBankAccountsTab(bankAccounts, method['name'], isDarkMode);
     case 2: // التحويلات - معدلة لعرض تحويلات الطريقة فقط
       return _buildPaymentTransfersTab(transfers, isDarkMode, method['name']);
     case 3: // الإحصائيات
       return _buildPaymentStatsTab(method, transfers, totalAmount, isDarkMode);
     default:
       return _buildPaymentInfoTab(method, isDarkMode);
   }
 }

  Widget _buildPaymentInfoTab(Map<String, dynamic> method, bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(method['icon'], color: _primaryColor, size: 40),
            ),
          ),
          SizedBox(height: 20),
          _buildPaymentInfoRow('اسم طريقة الدفع:', method['name'], isDarkMode),
          _buildPaymentInfoRow('النوع:', method['type'], isDarkMode),
          _buildPaymentInfoRow('الوصف:', method['description'], isDarkMode),
          _buildPaymentInfoRow('الحالة:', method['status'] == 'active' ? 'نشط' : 'غير نشط', isDarkMode),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // تبويب الحسابات البنكية الجديد
  Widget _buildBankAccountsTab(List<Map<String, dynamic>> accounts, String methodName, bool isDarkMode) {
    return Column(
      children: [
        // عنوان التبويب
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.05),
            border: Border(bottom: BorderSide(color: _primaryColor.withOpacity(0.2))),
          ),
          child: Row(
            children: [
              Icon(Icons.account_balance_rounded, color: _primaryColor),
              SizedBox(width: 8),
              Text(
                'الحسابات البنكية الرسمية - $methodName',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? _darkTextColor : _primaryColor,
                ),
              ),
              Spacer(),
              Text(
                '${accounts.length} حساب',
                style: TextStyle(
                  color: _textSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        
        // قائمة الحسابات البنكية
        Expanded(
          child: accounts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_outlined, size: 64, color: _textSecondaryColor),
                      SizedBox(height: 16),
                      Text(
                        'لا توجد حسابات بنكية',
                        style: TextStyle(
                          fontSize: 18,
                          color: _textSecondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'لم يتم العثور على حسابات بنكية رسمية\nلطريقة الدفع $methodName',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    return _buildBankAccountItem(accounts[index], isDarkMode);
                  },
                ),
        ),
      ],
    );
  }

  // عنصر الحساب البنكي
  Widget _buildBankAccountItem(Map<String, dynamic> account, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? Colors.white10 : _cardColor,
        border: Border.all(color: _primaryColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  account['bankName'],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: isDarkMode ? _darkTextColor : _textColor,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'نشط',
                  style: TextStyle(
                    fontSize: 12,
                    color: _successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildBankAccountDetailRow('اسم الحساب:', account['accountName'], isDarkMode),
          _buildBankAccountDetailRow('رقم الحساب:', account['accountNumber'], isDarkMode),
          _buildBankAccountDetailRow('الفرع:', account['branch'], isDarkMode),
          _buildBankAccountDetailRow('العملة:', account['currency'], isDarkMode),
        ],
      ),
    );
  }

  Widget _buildBankAccountDetailRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? _darkTextColor : _textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTransfersTab(List<Map<String, dynamic>> transfers, bool isDarkMode, String methodName) {
  return Column(
    children: [
      // عنوان التبويب مع اسم طريقة الدفع
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.05),
          border: Border(bottom: BorderSide(color: _primaryColor.withOpacity(0.2))),
        ),
        child: Row(
          children: [
            Icon(Icons.filter_alt_rounded, color: _primaryColor),
            SizedBox(width: 8),
            Text(
              'تحويلات $methodName',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? _darkTextColor : _primaryColor,
              ),
            ),
            Spacer(),
            Text(
              '${transfers.length} تحويل',
              style: TextStyle(
                color: _textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      
      // إحصائيات سريعة
      if (transfers.isNotEmpty)
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black12 : Colors.grey[50],
            border: Border(bottom: BorderSide(color: _borderColor)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTransferMiniStat('الإجمالي', transfers.length.toString(), _primaryColor),
              _buildTransferMiniStat('المبلغ', _formatCurrency(_getTotalTransfersAmount(transfers)), _successColor),
              _buildTransferMiniStat('مكتمل', '${transfers.where((t) => t['status'] == 'مكتمل').length}', _successColor),
              _buildTransferMiniStat('معلق', '${transfers.where((t) => t['status'] == 'معلق').length}', _warningColor),
            ],
          ),
        ),
      
      // قائمة التحويلات
      Expanded(
        child: transfers.isEmpty
            ? _buildNoTransfersMessageForMethod(isDarkMode, methodName)
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: transfers.length,
                itemBuilder: (context, index) {
                  return _buildTransferItem(transfers[index], isDarkMode);
                },
              ),
      ),
    ],
  );
}
  Widget _buildPaymentStatsTab(Map<String, dynamic> method, List<Map<String, dynamic>> transfers, double totalAmount, bool isDarkMode) {
  int completedTransfers = transfers.where((t) => t['status'] == 'مكتمل').length;
  int pendingTransfers = transfers.where((t) => t['status'] == 'معلق').length;
  
  return SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black12 : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor),
          ),
          child: Column(
            children: [
              Text(
                'نظرة عامة على التحويلات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? _darkTextColor : _primaryColor,
                ),
              ),
              SizedBox(height: 20),
              _buildStatItem('إجمالي التحويلات', transfers.length.toString(), 
                  Icons.list_alt_rounded, _primaryColor, isDarkMode), // ⬅️ إضافة isDarkMode
              _buildStatItem('المبلغ الإجمالي', _formatCurrency(totalAmount), 
                  Icons.attach_money_rounded, _successColor, isDarkMode), // ⬅️ إضافة isDarkMode
              _buildStatItem('تحويلات مكتملة', completedTransfers.toString(), 
                  Icons.check_circle_rounded, _successColor, isDarkMode), // ⬅️ إضافة isDarkMode
              _buildStatItem('تحويلات معلقة', pendingTransfers.toString(), 
                  Icons.pending_rounded, _warningColor, isDarkMode), // ⬅️ إضافة isDarkMode
            ],
          ),
        ),
        
        SizedBox(height: 20),
        
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black12 : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'التوزيع الشهري',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? _darkTextColor : _primaryColor,
                ),
              ),
              SizedBox(height: 15),
              _buildMonthStat('يناير 2024', 4500000, isDarkMode),
              _buildMonthStat('فبراير 2024', 5200000, isDarkMode),
              _buildMonthStat('مارس 2024', 3800000, isDarkMode),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildTransferItem(Map<String, dynamic> transfer, bool isDarkMode) {
  Color statusColor = transfer['status'] == 'مكتمل' ? _successColor : _warningColor;
  
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: isDarkMode ? Colors.white10 : _cardColor,
      border: Border.all(color: statusColor.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'تحويل #${transfer['id']}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                transfer['status'],
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildTransferDetailRow('المواطن:', transfer['citizenName'], isDarkMode),
        _buildTransferDetailRow('المبلغ:', _formatCurrency(transfer['amount']), isDarkMode),
        _buildTransferDetailRow('رقم المرجع:', transfer['referenceNumber'], isDarkMode),
        _buildTransferDetailRow('التاريخ:', DateFormat('yyyy-MM-dd').format(transfer['transferDate']), isDarkMode),
        if (transfer['bankName'] != null)
          _buildTransferDetailRow('اسم البنك:', transfer['bankName'], isDarkMode),
        if (transfer['accountNumber'] != null)
          _buildTransferDetailRow('رقم الحساب:', transfer['accountNumber'], isDarkMode),
        if (transfer['paymentLocation'] != null)
          _buildTransferDetailRow('موقع الدفع:', transfer['paymentLocation'], isDarkMode),
      ],
    ),
  );
}
  // دوال مساعدة
  Widget _buildTransferStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfoRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: isDarkMode ? _darkTextColor : _textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferDetailRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFilteredReportsList(bool isDarkMode) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDarkMode ? _darkCardColor : _cardColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.list_alt, color: _accentColor),
            SizedBox(width: 8),
            Text(
              'التقارير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
            Spacer(),
            Chip(
              label: Text(
                '${_filteredReports.length} تقرير',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              backgroundColor: _accentColor,
            ),
          ],
        ),
        SizedBox(height: 16),

        if (_filteredReports.isEmpty)
          _buildEmptyState(isDarkMode)
        else
          Column(
            children: _filteredReports.map((report) {
              return _buildReportCard(report, isDarkMode);
            }).toList(),
          ),
      ],
    ),
  );
}


  // تحديث تعريف الدالة لقبول isDarkMode
Widget _buildStatItem(String title, String value, IconData icon, Color color, bool isDarkMode) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: isDarkMode ? _darkCardColor : _cardColor,
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

  Widget _buildMonthStat(String month, double amount, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            month,
            style: TextStyle(
              color: isDarkMode ? _darkTextColor : _textColor,
            ),
          ),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: _successColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _textSecondaryColor,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل التقرير: ${report['title']}'),
        backgroundColor: _successColor,
      ),
    );
  }
  
  // شاشة الإعدادات
void _showSettingsScreen(BuildContext context, bool isDarkMode) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SettingsScreen(
        primaryColor: _primaryColor,
        secondaryColor: _secondaryColor,
        accentColor: _accentColor,
        darkCardColor: _darkCardColor,
        cardColor: _cardColor,
        darkTextColor: _darkTextColor,
        textColor: _textColor,
        darkTextSecondaryColor: _darkTextSecondaryColor,
        textSecondaryColor: _textSecondaryColor,
        onSettingsChanged: (settings) {
          // معالجة تغييرات الإعدادات هنا
          print('الإعدادات المحدثة: $settings');
        },
      ),
    ),
  );
}

// شاشة المساعدة والدعم
void _showHelpSupportScreen(BuildContext context, bool isDarkMode) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HelpSupportScreen(
        isDarkMode: isDarkMode,
        primaryColor: _primaryColor,
        secondaryColor: _secondaryColor,
        accentColor: _accentColor,
        darkCardColor: _darkCardColor,
        cardColor: _cardColor,
        darkTextColor: _darkTextColor,
        textColor: _textColor,
        darkTextSecondaryColor: _darkTextSecondaryColor,
        textSecondaryColor: _textSecondaryColor,
      ),
    ),
  );
}
}

// شاشة الإعدادات الكاملة
class SettingsScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color darkCardColor;
  final Color cardColor;
  final Color darkTextColor;
  final Color textColor;
  final Color darkTextSecondaryColor;
  final Color textSecondaryColor;
  final Function(Map<String, dynamic>) onSettingsChanged;

  const SettingsScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.darkCardColor,
    required this.cardColor,
    required this.darkTextColor,
    required this.textColor,
    required this.darkTextSecondaryColor,
    required this.textSecondaryColor,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = false;
  bool _autoBackup = true;
  bool _biometricAuth = false;
  bool _autoSync = true;
  String _language = 'العربية';
  final List<String> _languages = ['العربية', 'English'];

  void _saveSettings() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final Map<String, dynamic> settings = {
      'notificationsEnabled': _notificationsEnabled,
      'soundEnabled': _soundEnabled,
      'vibrationEnabled': _vibrationEnabled,
      'darkMode': themeProvider.isDarkMode,
      'autoBackup': _autoBackup,
      'biometricAuth': _biometricAuth,
      'autoSync': _autoSync,
      'language': _language,
    };
    
    widget.onSettingsChanged(settings);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حفظ الإعدادات بنجاح'),
        backgroundColor: widget.primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        return AlertDialog(
          backgroundColor: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.restart_alt_rounded, color: widget.primaryColor),
              SizedBox(width: 8),
              Text('إعادة التعيين'),
            ],
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد إعادة جميع الإعدادات إلى القيم الافتراضية؟',
            style: TextStyle(
              color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء', style: TextStyle(color: widget.textSecondaryColor)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _notificationsEnabled = true;
                  _soundEnabled = true;
                  _vibrationEnabled = false;
                  _autoBackup = true;
                  _biometricAuth = false;
                  _autoSync = true;
                  _language = 'العربية';
                });
                
                // إعادة تعيين الوضع المظلم إلى الوضع الفاتح
                themeProvider.toggleTheme(false);
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إعادة التعيين إلى الإعدادات الافتراضية'),
                    backgroundColor: widget.primaryColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: widget.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            _saveSettings();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_rounded, color: Colors.white),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: themeProvider.isDarkMode
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                    )
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF5F5F5), Color(0xFFE8F5E8)],
                    ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingsSection('الإشعارات', Icons.notifications_rounded, themeProvider),
                  _buildSettingSwitch(
                    'تفعيل الإشعارات',
                    'استلام إشعارات حول الفواتير والتحديثات',
                    _notificationsEnabled,
                    (bool value) => setState(() => _notificationsEnabled = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'الصوت',
                    'تشغيل صوت للإشعارات الواردة',
                    _soundEnabled,
                    (bool value) => setState(() => _soundEnabled = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'الاهتزاز',
                    'اهتزاز الجهاز عند استلام الإشعارات',
                    _vibrationEnabled,
                    (bool value) => setState(() => _vibrationEnabled = value),
                    themeProvider,
                  ),

                  SizedBox(height: 24),
                  _buildSettingsSection('المظهر', Icons.palette_rounded, themeProvider),
                  
                  // زر الوضع المظلم - محدث ليعمل مع ThemeProvider
                  _buildDarkModeSwitch(themeProvider),
                  
                  _buildSettingDropdown(
                    'اللغة',
                    _language,
                    _languages,
                    (String? value) => setState(() => _language = value!),
                    themeProvider,
                  ),
                  
                  SizedBox(height: 24),
                  _buildSettingsSection('حول التطبيق', Icons.info_rounded, themeProvider),
                  _buildAboutCard(themeProvider),

                  SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _saveSettings,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('حفظ الإعدادات'),
                        ),
                        SizedBox(height: 12),
                        TextButton(
                          onPressed: _resetToDefaults,
                          child: Text(
                            'إعادة التعيين إلى الإعدادات الافتراضية',
                            style: TextStyle(color: widget.textSecondaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // زر الوضع المظلم المحدث
  Widget _buildDarkModeSwitch(ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة الوضع المظلم
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: themeProvider.isDarkMode ? Colors.amber : Colors.grey,
              size: 22,
            ),
          ),
          SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الوضع الداكن',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  themeProvider.isDarkMode ? 'مفعل - استمتع بتجربة مريحة للعين' : 'معطل - استمتع بالمظهر الافتراضي',
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // زر التبديل
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            activeColor: Colors.amber,
            activeTrackColor: Colors.amber.withOpacity(0.5),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: widget.primaryColor, size: 22),
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch(String title, String subtitle, bool value, Function(bool) onChanged, ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: widget.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingDropdown(String title, String value, List<String> items, Function(String?) onChanged, ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode ? Colors.white10 : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: widget.primaryColor.withOpacity(0.3)),
            ),
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
                    ),
                  ),
                );
              }).toList(),
              underline: SizedBox(),
              icon: Icon(Icons.arrow_drop_down_rounded, color: widget.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(ThemeProvider themeProvider) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAboutRow('الإصدار', '1.0.0', themeProvider),
          _buildAboutRow('تاريخ البناء', '2024-03-20', themeProvider),
          _buildAboutRow('المطور', 'وزارة الكهرباء - العراق', themeProvider),
          _buildAboutRow('رقم الترخيص', 'MOE-2024-001', themeProvider),
          _buildAboutRow('آخر تحديث', '2024-03-15', themeProvider),
          _buildAboutRow('البريد الإلكتروني', 'support@electric.gov.iq', themeProvider),
        ],
      ),
    );
  }

  Widget _buildAboutRow(String title, String value, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: themeProvider.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
// شاشة الاشعارات  
class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Color _primaryColor = Color(0xFF2E7D32);
  final Color _secondaryColor = Color(0xFFD4AF37);
  final Color _backgroundColor = Color(0xFFF5F5F5);
  final Color _cardColor = Color(0xFFFFFFFF);
  final Color _textColor = Color(0xFF212121);
  final Color _textSecondaryColor = Color(0xFF757575);
  final Color _borderColor = Color(0xFFE0E0E0);

  int _selectedTab = 0;
  final List<String> _tabs = ['الوسائل', 'الطلبات', 'الوظائف', 'الكل'];
  final List<Map<String, dynamic>> _allNotifications = [
    // تبويب الوسائل
    {
      'id': '1',
      'type': 'message',
      'title': 'رسالة جديدة',
      'description': 'لديك رسالة من الإدارة بخصوص تحديث نظام الفواتير',
      'time': 'منذ 3 ساعات',
      'read': true,
      'tab': 0, // الوسائل
    },
    {
      'id': '2',
      'type': 'system',
      'title': 'تحديث النظام',
      'description': 'تم تحديث نظام الفواتير إلى الإصدار 2.1.0',
      'time': 'منذ يوم',
      'read': true,
      'tab': 0, // الوسائل
    },
    {
      'id': '3',
      'type': 'announcement',
      'title': 'إعلان هام',
      'description': 'اجتماع طارئ لموظفي قسم المحاسبة يوم الخميس القادم',
      'time': 'منذ يومين',
      'read': true,
      'tab': 0, // الوسائل
    },

    // تبويب الطلبات
    {
      'id': '4',
      'type': 'payment',
      'title': 'طلب دفع جديد',
      'description': 'طلب دفع جديد من المواطن أحمد محمد بقيمة 185,750 دينار',
      'time': 'منذ 5 دقائق',
      'read': false,
      'tab': 1, // الطلبات
    },
    {
      'id': '5',
      'type': 'complaint',
      'title': 'شكوى جديدة',
      'description': 'شكوى من المواطن فاطمة علي بخصوص فاتورة الكهرباء',
      'time': 'منذ ساعة',
      'read': false,
      'tab': 1, // الطلبات
    },
    {
      'id': '6',
      'type': 'service',
      'title': 'طلب خدمة جديد',
      'description': 'طلب تركيب عداد جديد من المواطن خالد إبراهيم',
      'time': 'منذ ساعتين',
      'read': false,
      'tab': 1, // الطلبات
    },

    // تبويب الفواتير
    {
      'id': '7',
      'type': 'bill',
      'title': 'فاتورة جديدة',
      'description': 'تم إنشاء فاتورة جديدة للمواطن سارة عبدالله بقيمة 150,000 دينار',
      'time': 'منذ 10 دقائق',
      'read': false,
      'tab': 2, // الفواتير
    },
    {
      'id': '8',
      'type': 'overdue',
      'title': 'فاتورة متأخرة',
      'description': 'فاتورة رقم INV-2024-002 للمواطن فاطمة علي متأخرة الدفع',
      'time': 'منذ 3 أيام',
      'read': true,
      'tab': 2, // الفواتير
    },
    {
      'id': '9',
      'type': 'payment_success',
      'title': 'دفع ناجح',
      'description': 'تم دفع فاتورة رقم INV-2024-003 بنجاح من المواطن خالد إبراهيم',
      'time': 'منذ 30 دقيقة',
      'read': true,
      'tab': 2, // الفواتير
    },
    {
      'id': '10',
      'type': 'reading',
      'title': 'قراءة عداد جديدة',
      'description': 'تم تسجيل قراءة عداد جديدة للمواطن أحمد محمد',
      'time': 'منذ ساعة',
      'read': true,
      'tab': 2, // الفواتير
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedTab == 3) { // الكل
      return _allNotifications;
    }
    return _allNotifications.where((notification) => notification['tab'] == _selectedTab).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'الإشعارات',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // تبويبات الإشعارات - مطابقة تمامًا للصورة
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: _cardColor,
              border: Border(
                bottom: BorderSide(color: _borderColor),
              ),
            ),
            child: Row(
              children: [
                for (int i = 0; i < _tabs.length; i++)
                  _buildTabButton(_tabs[i], i),
              ],
            ),
          ),

          // خط فاصل تحت التبويبات
          Container(
            height: 1,
            color: _borderColor,
          ),

          // قائمة الإشعارات
          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? _secondaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isSelected ? _primaryColor : _textSecondaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Column(
      children: [
        // محتوى الإشعار
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان
              Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: _textColor,
                ),
              ),
              SizedBox(height: 8),
              // الوصف
              Text(
                notification['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: _textSecondaryColor,
                ),
              ),
              SizedBox(height: 8),
              // الوقت
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    notification['time'],
                    style: TextStyle(
                      fontSize: 12,
                      color: _textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // خط فاصل - مطابق للصورة
        Container(
          height: 1,
          color: _borderColor,
          margin: EdgeInsets.symmetric(horizontal: 16),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 64,
            color: _textSecondaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لا توجد إشعارات في التبويب المحدد',
            style: TextStyle(
              color: _textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
// شاشة المساعدة والدعم الكاملة
class HelpSupportScreen extends StatelessWidget {
  final bool isDarkMode;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color darkCardColor;
  final Color cardColor;
  final Color darkTextColor;
  final Color textColor;
  final Color darkTextSecondaryColor;
  final Color textSecondaryColor;

  const HelpSupportScreen({
    Key? key,
    required this.isDarkMode,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.darkCardColor,
    required this.cardColor,
    required this.darkTextColor,
    required this.textColor,
    required this.darkTextSecondaryColor,
    required this.textSecondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المساعدة والدعم',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F5F5), Color(0xFFE8F5E8)],
                ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // بطاقة جهات الاتصال
              _buildContactCard(context),

              SizedBox(height: 24),

              // الأسئلة الشائعة
              _buildSectionTitle('الأسئلة الشائعة'),
              ..._buildFAQItems(),

              SizedBox(height: 24),
              // معلومات التطبيق
              _buildSectionTitle('معلومات التطبيق'),
              _buildAppInfoCard(),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // بطاقة جهات الاتصال
  // في شاشة المساعدة والدعم - تحديث بطاقة جهات الاتصال
 Widget _buildContactCard(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: isDarkMode ? darkCardColor : cardColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.support_agent_rounded, color: primaryColor, size: 28),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'مركز الدعم الفني',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? darkTextColor : textColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        _buildContactItem(Icons.phone_rounded, 'رقم الدعم الفني', '07725252103', true, context),
        _buildContactItem(Icons.phone_rounded, 'رقم الطوارئ', '07862268894', true, context),
        _buildContactItem(Icons.email_rounded, 'البريد الإلكتروني', 'fadhilali402@gmail.com', false, context),
        _buildContactItem(Icons.access_time_rounded, 'ساعات العمل', '8:00 ص - 4:00 م', false, context),
        _buildContactItem(Icons.location_on_rounded, 'العنوان', 'بغداد - وزارة الكهرباء', false, context),
        SizedBox(height: 16),
        
        // أزرار الاتصال - محدثة مع إضافة زر المراسلة
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _makePhoneCall('07725252103', context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                icon: Icon(Icons.phone_rounded, size: 20),
                label: Text('اتصال فوري'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _openSupportChat(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                icon: Icon(Icons.chat_rounded, size: 20),
                label: Text('مراسلة الدعم'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
 }

 // دالة فتح محادثة الدعم
 void _openSupportChat(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SupportChatScreen(
        isDarkMode: isDarkMode,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        accentColor: accentColor,
        darkCardColor: darkCardColor,
        cardColor: cardColor,
        darkTextColor: darkTextColor,
        textColor: textColor,
        darkTextSecondaryColor: darkTextSecondaryColor,
        textSecondaryColor: textSecondaryColor,
      ),
    ),
  );
 }


  // عنصر جهة اتصال
  Widget _buildContactItem(IconData icon, String title, String value, bool isPhone, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? darkTextColor : textColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: isPhone ? () => _makePhoneCall(value, context) : null,
              child: Text(
                value,
                style: TextStyle(
                  color: isPhone ? primaryColor : (isDarkMode ? darkTextSecondaryColor : textSecondaryColor),
                  decoration: isPhone ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDarkMode ? darkTextColor : textColor,
        ),
      ),
    );
  }

  // الأسئلة الشائعة
  List<Widget> _buildFAQItems() {
    List<Map<String, String>> faqs = [
      {
        'question': 'كيف يمكنني إضافة فاتورة جديدة؟',
        'answer': 'اذهب إلى قسم الفواتير → انقر على زر "إضافة فاتورة" → املأ البيانات المطلوبة (اسم المواطن، المبلغ، الاستهلاك) → اضغط على زر "حفظ"'
      },
      {
        'question': 'كيف أعرض تقرير الإيرادات الشهري؟',
        'answer': 'انتقل إلى قسم التقارير → اختر "تقرير الإيرادات" → حدد الفترة الزمنية المطلوبة → انقر على "عرض التقرير"'
      },
      {
        'question': 'كيف أعدل بيانات مواطن مسجل؟',
        'answer': 'اذهب إلى قسم المواطنين → انقر على المواطن المطلوب → اختر "تعديل البيانات" → قم بالتعديلات المطلوبة → اضغط على "حفظ التغييرات"'
      },
      {
        'question': 'كيف أتحقق من حالة الدفع للفواتير؟',
        'answer': 'انتقل إلى قسم الفواتير → استخدم فلتر الحالة → اختر "مدفوعة" أو "غير مدفوعة" أو "متأخرة" → سيتم عرض الفواتير حسب الحالة المختارة'
      },
      {
        'question': 'كيف أقوم بعمل نسخة احتياطية للبيانات؟',
        'answer': 'اذهب إلى الإعدادات → اختر "التخزين والبيانات" → انقر على "إنشاء نسخة احتياطية" → اختر موقع الحفظ → اضغط على "تأكيد"'
      },
    ];

    return faqs.map((faq) {
      return _buildExpandableItem(faq['question']!, faq['answer']!);
    }).toList();
  }
  // عنصر قابل للتمديد (للأسئلة الشائعة)
  Widget _buildExpandableItem(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? darkCardColor : cardColor,
      ),
      child: ExpansionTile(
        leading: Icon(Icons.help_outline_rounded, color: primaryColor),
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDarkMode ? darkTextColor : textColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                color: isDarkMode ? darkTextSecondaryColor : textSecondaryColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }  
  // بطاقة معلومات التطبيق
  Widget _buildAppInfoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? darkCardColor : cardColor,
      ),
      child: Column(
        children: [
          _buildInfoRow('الإصدار', '1.0.0'),
          _buildInfoRow('تاريخ البناء', '2024-03-20'),
          _buildInfoRow('المطور', 'وزارة الكهرباء'),
          _buildInfoRow('رقم الترخيص', 'MOE-2024-001'),
          _buildInfoRow('آخر تحديث', '2024-03-15'),
        ],
      ),
    );
  }

  // صف معلومات
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? darkTextColor : textColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDarkMode ? darkTextSecondaryColor : textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // ========== دوال التفاعل ==========

  // الاتصال الهاتفي
  void _makePhoneCall(String phoneNumber, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري الاتصال بـ $phoneNumber'),
        backgroundColor: primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
     launch('tel:9647862268894');
  }
}
// شاشة محادثة الدعم
class SupportChatScreen extends StatefulWidget {
  final bool isDarkMode;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color darkCardColor;
  final Color cardColor;
  final Color darkTextColor;
  final Color textColor;
  final Color darkTextSecondaryColor;
  final Color textSecondaryColor;

  const SupportChatScreen({
    Key? key,
    required this.isDarkMode,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.darkCardColor,
    required this.cardColor,
    required this.darkTextColor,
    required this.textColor,
    required this.darkTextSecondaryColor,
    required this.textSecondaryColor,
  }) : super(key: key);

  @override
  _SupportChatScreenState createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'مرحباً! كيف يمكنني مساعدتك اليوم؟',
      'isUser': false,
      'time': 'الآن',
      'sender': 'موظف الدعم'
    }
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isUser': true,
        'time': 'الآن',
        'sender': 'أنت'
      });
    });

    _messageController.clear();

    // محاكاة رد الدعم بعد ثانيتين
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text': 'شكراً لتواصلكم. سأقوم بمساعدتك في حل هذه المشكلة. هل يمكنك تقديم مزيد من التفاصيل؟',
            'isUser': false,
            'time': 'الآن',
            'sender': 'موظف الدعم'
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'محادثة الدعم الفني',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'متصل الآن',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: widget.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: Colors.white),
            onSelected: (value) {
              if (value == 'end_chat') {
                _endChat(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'end_chat',
                child: Row(
                  children: [
                    Icon(Icons.close_rounded, color: Colors.red),
                    SizedBox(width: 8),
                    Text('إنهاء المحادثة'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // معلومات الدعم
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(color: widget.primaryColor.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.support_agent_rounded, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'فاضل علي - موظف الدعم',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
                        ),
                      ),
                      Text(
                        'متخصص في نظام الفواتير والمحاسبة',
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'متصل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // قائمة الرسائل
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // حقل إدخال الرسالة
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
              border: Border(
                top: BorderSide(color: widget.primaryColor.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isDarkMode ? Colors.white10 : Colors.grey[50],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالتك هنا...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.attach_file_rounded, color: widget.primaryColor),
                          onPressed: () => _showAttachmentOptions(context),
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: widget.primaryColor,
                  child: IconButton(
                    icon: Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final bool isUser = message['isUser'] as bool;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: widget.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.support_agent_rounded, color: Colors.white, size: 16),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isUser)
                  Text(
                    message['sender'],
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser 
                        ? widget.primaryColor 
                        : (widget.isDarkMode ? Colors.white10 : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message['text'],
                    style: TextStyle(
                      color: isUser ? Colors.white : (widget.isDarkMode ? widget.darkTextColor : widget.textColor),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message['time'],
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (isUser)
            SizedBox(width: 8),
          if (isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: widget.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded, color: Colors.white, size: 16),
            ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'إرفاق ملف',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
            SizedBox(height: 16),
            _buildAttachmentOption(Icons.photo_rounded, 'صورة', () {}),
            _buildAttachmentOption(Icons.description_rounded, 'ملف', () {}),
            _buildAttachmentOption(Icons.receipt_rounded, 'فاتورة', () {}),
            _buildAttachmentOption(Icons.location_on_rounded, 'موقع', () {}),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: widget.primaryColor),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _endChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.close_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('إنهاء المحادثة'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد إنهاء المحادثة؟',
          style: TextStyle(
            color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('البقاء في المحادثة'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق حوار التأكيد
              Navigator.pop(context); // العودة للشاشة السابقة
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إنهاء المحادثة بنجاح'),
                  backgroundColor: widget.primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('إنهاء المحادثة'),
          ),
        ],
      ),
    );
  }
}
class MultiDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const MultiDatePickerDialog({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  }) : super(key: key);

  @override
  _MultiDatePickerDialogState createState() => _MultiDatePickerDialogState();
}

class _MultiDatePickerDialogState extends State<MultiDatePickerDialog> {
  List<DateTime> _selectedDates = [];

  @override
  Widget build(BuildContext context) {
    // إنشاء قائمة بالأيام من 1 إلى 30 للشهر الحالي
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    
    List<DateTime> days = List.generate(30, (index) {
      return DateTime(currentYear, currentMonth, index + 1);
    });

    return AlertDialog(
      title: Text('اختر التاريخ', textAlign: TextAlign.center),
      content: Container(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
          itemCount: days.length,
          itemBuilder: (context, index) {
            final date = days[index];
            final isSelected = _selectedDates.any((selectedDate) =>
                selectedDate.year == date.year &&
                selectedDate.month == date.month &&
                selectedDate.day == date.day);
            
            return CheckboxListTile(
              title: Text(
                '${date.day} ${_getMonthName(date.month)} ${date.year} - ${_getDayName(date.weekday)}',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedDates.add(date);
                  } else {
                    _selectedDates.removeWhere((selectedDate) =>
                        selectedDate.year == date.year &&
                        selectedDate.month == date.month &&
                        selectedDate.day == date.day);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _selectedDates),
          child: Text('تأكيد'),
        ),
      ],
    );
  }

  // دالة للحصول على اسم الشهر بالعربية
  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'يناير';
      case 2: return 'فبراير';
      case 3: return 'مارس';
      case 4: return 'أبريل';
      case 5: return 'مايو';
      case 6: return 'يونيو';
      case 7: return 'يوليو';
      case 8: return 'أغسطس';
      case 9: return 'سبتمبر';
      case 10: return 'أكتوبر';
      case 11: return 'نوفمبر';
      case 12: return 'ديسمبر';
      default: return '';
    }
  }

  // دالة للحصول على اسم اليوم بالعربية
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'الاثنين';
      case 2: return 'الثلاثاء';
      case 3: return 'الأربعاء';
      case 4: return 'الخميس';
      case 5: return 'الجمعة';
      case 6: return 'السبت';
      case 7: return 'الأحد';
      default: return '';
    }
  }
}
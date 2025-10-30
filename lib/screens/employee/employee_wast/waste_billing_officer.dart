import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';

class WasteBillingOfficerScreen extends StatefulWidget {
  static const String screenRoute = '/waste-billing-officer';
  
  const WasteBillingOfficerScreen({super.key});

  @override
  WasteBillingOfficerScreenState createState() => WasteBillingOfficerScreenState();
}

class WasteBillingOfficerScreenState extends State<WasteBillingOfficerScreen>
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

  // الألوان الحكومية (أخضر وذهبي وبني)
  final Color _primaryColor = Color(0xFF2E7D32); // أخضر حكومي
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

  // بيانات المواطنين - محدثة لمجال النفايات
  final List<Map<String, dynamic>> citizens = [
    {
      'id': 'CIT-2024-001',
      'name': 'أحمد محمد',
      'nationalId': '1234567890',
      'phone': '077235477514',
      'address': 'حي الرياض - شارع الملك فهد',
      'subscriptionType': 'سكني',
      'binNumber': 'BIN-001234',
      'wasteType': 'منزلي',
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
      'binNumber': 'BIN-001235',
      'wasteType': 'منزلي',
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
      'binNumber': 'BIN-001236',
      'wasteType': 'تجاري',
      'status': 'active',
      'joinDate': DateTime.now().subtract(Duration(days: 60)),
    },
  ];

  // بيانات الفواتير - محدثة لمجال النفايات
  final List<Map<String, dynamic>> bills = [
    {
      'id': 'INV-2024-001',
      'citizenId': 'CIT-2024-001',
      'citizenName': 'أحمد محمد',
      'amount': 85000,
      'dueDate': DateTime.now().add(Duration(days: 5)),
      'status': 'unpaid',
      'wasteType': 'منزلي',
      'collectionFrequency': 'يومي',
      'binCapacity': '120 لتر',
      'billingDate': DateTime.now().subtract(Duration(days: 5)),
    },
    {
      'id': 'INV-2024-002',
      'citizenId': 'CIT-2024-002',
      'citizenName': 'فاطمة علي',
      'amount': 75000,
      'dueDate': DateTime.now().subtract(Duration(days: 3)),
      'status': 'overdue',
      'wasteType': 'منزلي',
      'collectionFrequency': 'يومي',
      'binCapacity': '120 لتر',
      'billingDate': DateTime.now().subtract(Duration(days: 10)),
    },
    {
      'id': 'INV-2024-003',
      'citizenId': 'CIT-2024-003',
      'citizenName': 'خالد إبراهيم',
      'amount': 150000,
      'dueDate': DateTime.now().add(Duration(days: 2)),
      'status': 'unpaid',
      'wasteType': 'تجاري',
      'collectionFrequency': 'يومي',
      'binCapacity': '240 لتر',
      'billingDate': DateTime.now().subtract(Duration(days: 7)),
    },
  ];

  // بيانات التقارير - محدثة لمجال النفايات
 final List<Map<String, dynamic>> reports = [
  {
    'id': 'REP-2024-001',
    'title': 'تقرير الإيرادات الشهري للنفايات',
    'type': 'مالي',
    'period': 'يناير 2024',
    'generatedDate': DateTime.now().subtract(Duration(days: 2)),
    'totalRevenue': 5000000, // الإيراد الكلي
    'totalBills': 200, // إجمالي الفواتير
    'paidBills': 180, // الفواتير المدفوعة
  },
  {
    'id': 'REP-2024-002',
    'title': 'تقرير الفواتير المستلمة',
    'type': 'مالي',
    'period': 'يناير 2024', // نفس الفترة
    'generatedDate': DateTime.now().subtract(Duration(days: 5)),
    'receivedInvoices': '180 فاتورة', // نفس paidBills من التقرير الأول
    'totalReceivedAmount': '4,500,000 درهم', // جزء من الإيراد الكلي
    'averageReceivedAmount': '25,000 درهم/فاتورة'
  },
  {
    'id': 'REP-2024-003',
    'title': 'تقرير المدفوعات المتأخرة',
    'type': 'متابعة',
    'period': 'يناير 2024', // نفس الفترة
    'generatedDate': DateTime.now().subtract(Duration(days: 1)),
    'overdueAmount': 500000, // المتبقي ليكمل الإيراد الكلي
    'overdueBills': 20, // نفس (totalBills - paidBills)
  },
];

void compareReports() {
  // البحث عن التقارير المطلوبة
  final revenueReport = reports[0];
  final receivedReport = reports[1];
  final overdueReport = reports[2];

  // استخراج البيانات من التقارير
  final totalRevenue = revenueReport['totalRevenue'] as int;
  final totalBills = revenueReport['totalBills'] as int;
  final paidBills = revenueReport['paidBills'] as int;
  
  // تحويل البيانات من التقرير الثاني
  final receivedInvoicesStr = receivedReport['receivedInvoices'] as String;
  final receivedInvoices = int.parse(receivedInvoicesStr.replaceAll(RegExp(r'[^0-9]'), ''));
  
  final totalReceivedAmountStr = receivedReport['totalReceivedAmount'] as String;
  final totalReceivedAmount = int.parse(totalReceivedAmountStr.replaceAll(RegExp(r'[^0-9]'), ''));
  
  final overdueAmount = overdueReport['overdueAmount'] as int;
  final overdueBills = overdueReport['overdueBills'] as int;

  // الحسابات
  final unpaidBills = totalBills - paidBills;
  final calculatedRevenue = totalReceivedAmount + overdueAmount;
  final calculatedBills = receivedInvoices + overdueBills;

  // المقارنات
  print('=== مقارنة التقارير ===');
  print('📊 التقرير 1 - الإيرادات الشهرية: ${_formatNumber(totalRevenue)} درهم');
  print('📄 التقرير 2 - الفواتير المستلمة: ${_formatNumber(totalReceivedAmount)} درهم');
  print('⏰ التقرير 3 - المدفوعات المتأخرة: ${_formatNumber(overdueAmount)} درهم');
  print('🧮 المجموع المحسوب (مستلمة + متأخرة): ${_formatNumber(calculatedRevenue)} درهم');
  print('---');
  
  print('📊 التقرير 1 - إجمالي الفواتير: ${_formatNumber(totalBills)} فاتورة');
  print('📄 التقرير 2 - الفواتير المستلمة: ${_formatNumber(receivedInvoices)} فاتورة');
  print('⏰ التقرير 3 - الفواتير المتأخرة: ${_formatNumber(overdueBills)} فاتورة');
  print('🧮 المجموع المحسوب (مستلمة + متأخرة): ${_formatNumber(calculatedBills)} فاتورة');
  print('---');

  // التحقق من المطابقة
  final revenueMatch = totalRevenue == calculatedRevenue;
  final billsMatch = totalBills == calculatedBills;

  print('📈 نتائج المقارنة:');
  print('${revenueMatch ? '✅' : '❌'} الإيرادات ${revenueMatch ? 'مطابقة' : 'غير مطابقة'}');
  print('${billsMatch ? '✅' : '❌'} عدد الفواتير ${billsMatch ? 'مطابق' : 'غير مطابق'}');
  
  if (revenueMatch && billsMatch) {
    print('\n🎉 جميع البيانات متطابقة تماماً!');
    print('💰 معادلة الإيرادات: ${_formatNumber(totalReceivedAmount)} + ${_formatNumber(overdueAmount)} = ${_formatNumber(totalRevenue)}');
    print('📋 معادلة الفواتير: ${_formatNumber(receivedInvoices)} + ${_formatNumber(overdueBills)} = ${_formatNumber(totalBills)}');
  } else {
    if (!revenueMatch) {
      print('💸 الفرق في الإيرادات: ${_formatNumber((totalRevenue - calculatedRevenue).abs())} درهم');
    }
    if (!billsMatch) {
      print('📝 الفرق في عدد الفواتير: ${_formatNumber((totalBills - calculatedBills).abs())} فاتورة');
    }
  }
  
  // عرض تفاصيل إضافية
  print('\n📖 ملخص البيانات:');
  print('• الفواتير المدفوعة (من التقرير الأول): ${_formatNumber(paidBills)} فاتورة');
  print('• الفواتير غير المدفوعة (من التقرير الأول): ${_formatNumber(unpaidBills)} فاتورة');
  print('• متوسط قيمة الفاتورة المستلمة: ${_formatNumber(totalReceivedAmount ~/ receivedInvoices)} درهم');
}

// دالة لتنسيق الأرقام بفواصل
String _formatNumber(int number) {
  return number.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
}

// دالة لعرض معلومات عن التقارير
void displayReportsInfo() {
  print('📑 التقارير المتاحة:');
  for (var report in reports) {
    print('\n--- ${report['title']} ---');
    print('🆔 الرقم: ${report['id']}');
    print('📁 النوع: ${report['type']}');
    print('📅 الفترة: ${report['period']}');
    print('🗓️ تاريخ الإنشاء: ${_formatDate(report['generatedDate'] as DateTime)}');
    
    // عرض الحقول المختلفة حسب نوع التقرير
    if (report['id'] == 'REP-2024-001') {
      print('💰 الإيراد الكلي: ${_formatNumber(report['totalRevenue'] as int)} درهم');
      print('📋 إجمالي الفواتير: ${_formatNumber(report['totalBills'] as int)} فاتورة');
      print('✅ الفواتير المدفوعة: ${_formatNumber(report['paidBills'] as int)} فاتورة');
    } else if (report['id'] == 'REP-2024-002') {
      print('📥 الفواتير المستلمة: ${report['receivedInvoices']}');
      print('💳 إجمالي المبلغ المستلم: ${report['totalReceivedAmount']}');
      print('📊 متوسط المبلغ: ${report['averageReceivedAmount']}');
    } else if (report['id'] == 'REP-2024-003') {
      print('⚠️  المبلغ المتأخر: ${_formatNumber(report['overdueAmount'] as int)} درهم');
      print('⏰ الفواتير المتأخرة: ${_formatNumber(report['overdueBills'] as int)} فاتورة');
    }
  }
}

// دالة لتنسيق التاريخ
String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

// الدالة الرئيسية
void main() {
  print('🏢 نظام مقارنة تقارير الإيرادات والفواتير\n');
  
  // عرض معلومات التقارير
  displayReportsInfo();
  
  print('\n' + '='*50 + '\n');
  
  // إجراء المقارنة
  compareReports();
  
  print('\n' + '='*50);
  print('تمت المقارنة بنجاح 🎯');
}

  // بيانات طرق الدفع
 final List<Map<String, dynamic>> paymentMethods = [
  {
    'id': 'PM-001',
    'name': 'بطاقة فيزا',
    'type': 'الكتروني',
    'status': 'active',
    'description': 'الدفع عبر بطاقات فيزا الائتمانية',
    'icon': Icons.credit_card_rounded,
  },
  {
    'id': 'PM-002',
    'name': 'بطاقة ماستركارد',
    'type': 'الكتروني',
    'status': 'active',
    'description': 'الدفع عبر بطاقات ماستركارد الائتمانية',
    'icon': Icons.credit_card_rounded,
  },
  {
    'id': 'PM-003',
    'name': 'Asiapay',
    'type': 'الكتروني',
    'status': 'active',
    'description': 'نظام الدفع الإلكتروني Asiapay',
    'icon': Icons.payment_rounded,
  },
  {
    'id': 'PM-004',
    'name': 'زين كاش',
    'type': 'الكتروني',
    'status': 'active',
    'description': 'الدفع عبر محفظة زين كاش الإلكترونية',
    'icon': Icons.phone_iphone_rounded,
  },
  {
    'id': 'PM-005',
    'name': 'التحويل البنكي',
    'type': 'بنكي',
    'status': 'active',
    'description': 'التحويل المباشر عبر فروع البنوك',
    'icon': Icons.account_balance_rounded,
  },
  {
    'id': 'PM-006',
    'name': 'بنك الرافدين',
    'type': 'بنكي',
    'status': 'active',
    'description': 'الدفع عبر فروع بنك الرافدين',
    'icon': Icons.account_balance_rounded,
  },
  {
    'id': 'PM-007',
    'name': 'بنك الرشيد',
    'type': 'بنكي',
    'status': 'active',
    'description': 'الدفع عبر فروع بنك الرشيد',
    'icon': Icons.account_balance_rounded,
  },
];

  // بيانات التحويلات لكل طريقة دفع - محدثة للنفايات
  final List<Map<String, dynamic>> paymentTransfers = [
    {
      'id': 'TRF-2024-001',
      'paymentMethodId': 'PM-001',
      'citizenName': 'أحمد محمد',
      'amount': 85000,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(days: 2)),
      'status': 'مكتمل',
      'referenceNumber': 'REF-001234',
      'bankName': 'البنك المركزي العراقي',
      'accountNumber': '1234567890',
    },
    {
      'id': 'TRF-2024-002', 
      'paymentMethodId': 'PM-002',
      'citizenName': 'فاطمة علي',
      'amount': 75000,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(days: 1)),
      'status': 'مكتمل',
      'referenceNumber': 'REF-001235',
      'bankName': 'الرشيد',
      'accountNumber': '0987654321',
    },
    {
      'id': 'TRF-2024-003',
      'paymentMethodId': 'PM-001',
      'citizenName': 'خالد إبراهيم', 
      'amount': 150000,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(days: 3)),
      'status': 'معلق',
      'referenceNumber': 'REF-001236',
      'bankName': 'البلاد',
      'accountNumber': '1122334455',
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
             citizen['binNumber'].contains(_searchQuery);
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

            child: Icon(Icons.recycling,  size: 25),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'نظام فواتير النفايات',
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 10, color: _secondaryColor),
          ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.7),
        labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
        tabs: [
          Tab(
            icon: Icon(Icons.people_alt_rounded, size: 22),
            text: 'المشتركين',
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
        width: double.infinity,
        height: double.infinity,
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
            _buildSearchBar(isDarkMode, 'ابحث عن مشترك...'),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                'سجل المشتركين',
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
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportsSummaryCard(isDarkMode),
            SizedBox(height: 20),
            Text(
              'التقارير المتاحة',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? _darkTextColor : _primaryColor,
              ),
            ),
            SizedBox(height: 16),
            ...reports.map((report) => _buildReportCard(report, isDarkMode)),
          ],
        ),
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
            'لم نتمكن من العثور على أي مشترك يطابق "$_searchQuery"',
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
                _buildReportStat('مالية', '1', _accentColor),
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
              'رقم الحاوية: ${citizen['binNumber']}',
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
              '${_formatCurrency(bill['amount'])} - ${bill['wasteType']}',
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
            color: _accentColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.description_rounded, color: _accentColor, size: 24),
        ),
        title: Text(
          report['title'],
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
              'النوع: ${report['type']}',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'الفترة: ${report['period']}',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.download_rounded, color: _primaryColor),
          onPressed: () {
            _downloadReport(report);
          },
        ),
        onTap: () {
          _showReportDetails(report, isDarkMode);
        },
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

  // بناء القائمة المنسدلة - محدثة لموظف النفايات
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
          // رأس الملف الشخصي - محدث لموظف النفايات
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
                    Icons.recycling,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),
                // الاسم والوظيفة
                Text(
                  "موظف فواتير النفايات",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "محاسب - قسم النفايات",
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

          // القائمة الرئيسية
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
                          'وزارة البلديات - نظام فواتير النفايات',
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

// دالة مساعدة لبناء عناصر القائمة
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
            Navigator.pop(context);
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

 // دوال العرض التفصيلي - محدثة للنفايات
  void _showCitizenDetails(Map<String, dynamic> citizen, bool isDarkMode) {
  // الحصول على فواتير المشترك
  List<Map<String, dynamic>> citizenBills = bills.where((bill) => bill['citizenId'] == citizen['id']).toList();
  
  // تصنيف الفواتير حسب التبويبات المطلوبة
  List<Map<String, dynamic>> paidBills = citizenBills.where((bill) => bill['status'] == 'paid').toList();
  List<Map<String, dynamic>> unpaidBills = citizenBills.where((bill) => bill['status'] == 'unpaid').toList();
  List<Map<String, dynamic>> completedBills = citizenBills.where((bill) => bill['status'] == 'paid').toList();
  List<Map<String, dynamic>> earlyPaymentBills = citizenBills.where((bill) => bill['status'] == 'paid' && bill['paidDate'] != null && bill['paidDate'].isBefore(bill['dueDate'])).toList();
  List<Map<String, dynamic>> onTimePaymentBills = citizenBills.where((bill) => bill['status'] == 'paid' && bill['paidDate'] != null && _isSameDay(bill['paidDate'], bill['dueDate'])).toList();
  List<Map<String, dynamic>> latePaymentBills = citizenBills.where((bill) => bill['status'] == 'overdue').toList();

  // بيانات الخدمات الإضافية - محدثة للنفايات
  List<Map<String, dynamic>> citizenServices = [
    {
      'id': 'SRV-001',
      'name': 'تركيب حاوية إضافية',
      'purchaseDate': DateTime.now().subtract(Duration(days: 30)),
      'amount': 50000.0,
      'status': 'مكتمل',
      'paymentMethod': 'الدفع الإلكتروني',
      'paymentDate': DateTime.now().subtract(Duration(days: 30)),
    },
    {
      'id': 'SRV-002', 
      'name': 'خدمة جمع إضافية',
      'purchaseDate': DateTime.now().subtract(Duration(days: 15)),
      'amount': 25000.0,
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
          insetPadding: EdgeInsets.all(0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
                          'تفاصيل المشترك - ${citizen['name']}',
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
        _buildInfoRow('رقم الحاوية:', citizen['binNumber'], isDarkMode),
        _buildInfoRow('نوع النفايات:', citizen['wasteType'], isDarkMode),
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
        _buildBillDetailRow('نوع النفايات:', bill['wasteType'], isDarkMode),
        _buildBillDetailRow('المبلغ:', _formatCurrency(bill['amount']), isDarkMode),
        _buildBillDetailRow('تكرار الجمع:', bill['collectionFrequency'], isDarkMode),
        _buildBillDetailRow('سعة الحاوية:', bill['binCapacity'], isDarkMode),
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
              _buildDetailRow('المشترك:', bill['citizenName']),
              _buildDetailRow('المبلغ:', _formatCurrency(bill['amount'])),
              _buildDetailRow('نوع النفايات:', bill['wasteType']),
              _buildDetailRow('تكرار الجمع:', bill['collectionFrequency']),
              _buildDetailRow('سعة الحاوية:', bill['binCapacity']),
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
              if (report['totalWaste'] != null)
                _buildDetailRow('إجمالي النفايات:', report['totalWaste']),
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
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
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
                            SizedBox(height: MediaQuery.of(context).padding.top + 20),
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
                      _buildPaymentTabButton('التحويلات', 1, setState, isDarkMode),
                      _buildPaymentTabButton('الإحصائيات', 2, setState, isDarkMode),
                    ],
                  ),
                ),

                // المحتوى
                Expanded(
                  child: _buildPaymentTabContent(_currentPaymentTab, method, methodTransfers, totalAmount, isDarkMode),
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

  Widget _buildPaymentTabContent(int tabIndex, Map<String, dynamic> method, List<Map<String, dynamic>> transfers, double totalAmount, bool isDarkMode) {
  switch (tabIndex) {
    case 0: // المعلومات
      return _buildPaymentInfoTab(method, isDarkMode);
    case 1: // التحويلات
      return _buildPaymentTransfersTab(transfers, isDarkMode, method['name']);
    case 2: // الإحصائيات
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
                _buildStatItem('إجمالي التحويلات', transfers.length.toString(), Icons.list_alt_rounded, _primaryColor),
                _buildStatItem('المبلغ الإجمالي', _formatCurrency(totalAmount), Icons.attach_money_rounded, _successColor),
                _buildStatItem('تحويلات مكتملة', completedTransfers.toString(), Icons.check_circle_rounded, _successColor),
                _buildStatItem('تحويلات معلقة', pendingTransfers.toString(), Icons.pending_rounded, _warningColor),
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
        _buildTransferDetailRow('المشترك:', transfer['citizenName'], isDarkMode),
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

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        value,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
      subtitle: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: _textSecondaryColor,
        ),
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
                  
                  // زر الوضع المظلم
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
          _buildAboutRow('المطور', 'وزارة البلديات - العراق', themeProvider),
          _buildAboutRow('رقم الترخيص', 'MUN-2024-001', themeProvider),
          _buildAboutRow('آخر تحديث', '2024-03-15', themeProvider),
          _buildAboutRow('البريد الإلكتروني', 'support@municipality.gov.iq', themeProvider),
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
  final List<String> _tabs = ['الوسائل', 'الطلبات', 'الفواتير', 'الكل'];
  final List<Map<String, dynamic>> _allNotifications = [
    // تبويب الوسائل
    {
      'id': '1',
      'type': 'message',
      'title': 'رسالة جديدة',
      'description': 'لديك رسالة من الإدارة بخصوص تحديث نظام فواتير النفايات',
      'time': 'منذ 3 ساعات',
      'read': true,
      'tab': 0, // الوسائل
    },
    {
      'id': '2',
      'type': 'system',
      'title': 'تحديث النظام',
      'description': 'تم تحديث نظام فواتير النفايات إلى الإصدار 2.1.0',
      'time': 'منذ يوم',
      'read': true,
      'tab': 0, // الوسائل
    },
    {
      'id': '3',
      'type': 'announcement',
      'title': 'إعلان هام',
      'description': 'اجتماع طارئ لموظفي قسم النفايات يوم الخميس القادم',
      'time': 'منذ يومين',
      'read': true,
      'tab': 0, // الوسائل
    },

    // تبويب الطلبات
    {
      'id': '4',
      'type': 'payment',
      'title': 'طلب دفع جديد',
      'description': 'طلب دفع جديد من المشترك أحمد محمد بقيمة 85,000 دينار',
      'time': 'منذ 5 دقائق',
      'read': false,
      'tab': 1, // الطلبات
    },
    {
      'id': '5',
      'type': 'complaint',
      'title': 'شكوى جديدة',
      'description': 'شكوى من المشترك فاطمة علي بخصوص فاتورة النفايات',
      'time': 'منذ ساعة',
      'read': false,
      'tab': 1, // الطلبات
    },
    {
      'id': '6',
      'type': 'service',
      'title': 'طلب خدمة جديد',
      'description': 'طلب تركيب حاوية إضافية من المشترك خالد إبراهيم',
      'time': 'منذ ساعتين',
      'read': false,
      'tab': 1, // الطلبات
    },

    // تبويب الفواتير
    {
      'id': '7',
      'type': 'bill',
      'title': 'فاتورة جديدة',
      'description': 'تم إنشاء فاتورة جديدة للمشترك سارة عبدالله بقيمة 75,000 دينار',
      'time': 'منذ 10 دقائق',
      'read': false,
      'tab': 2, // الفواتير
    },
    {
      'id': '8',
      'type': 'overdue',
      'title': 'فاتورة متأخرة',
      'description': 'فاتورة رقم INV-2024-002 للمشترك فاطمة علي متأخرة الدفع',
      'time': 'منذ 3 أيام',
      'read': true,
      'tab': 2, // الفواتير
    },
    {
      'id': '9',
      'type': 'payment_success',
      'title': 'دفع ناجح',
      'description': 'تم دفع فاتورة رقم INV-2024-003 بنجاح من المشترك خالد إبراهيم',
      'time': 'منذ 30 دقيقة',
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
          // تبويبات الإشعارات
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
        // خط فاصل
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
        _buildContactItem(Icons.email_rounded, 'البريد الإلكتروني', 'support@municipality.gov.iq', false, context),
        _buildContactItem(Icons.access_time_rounded, 'ساعات العمل', '8:00 ص - 4:00 م', false, context),
        _buildContactItem(Icons.location_on_rounded, 'العنوان', 'بغداد - وزارة البلديات', false, context),
        SizedBox(height: 16),
        
        // أزرار الاتصال
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
        'question': 'كيف يمكنني إضافة فاتورة نفايات جديدة؟',
        'answer': 'اذهب إلى قسم الفواتير → انقر على زر "إضافة فاتورة" → املأ البيانات المطلوبة (اسم المشترك، المبلغ، نوع النفايات) → اضغط على زر "حفظ"'
      },
      {
        'question': 'كيف أعرض تقرير الإيرادات الشهري للنفايات؟',
        'answer': 'انتقل إلى قسم التقارير → اختر "تقرير الإيرادات" → حدد الفترة الزمنية المطلوبة → انقر على "عرض التقرير"'
      },
      {
        'question': 'كيف أعدل بيانات مشترك مسجل؟',
        'answer': 'اذهب إلى قسم المشتركين → انقر على المشترك المطلوب → اختر "تعديل البيانات" → قم بالتعديلات المطلوبة → اضغط على "حفظ التغييرات"'
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
          _buildInfoRow('المطور', 'وزارة البلديات'),
          _buildInfoRow('رقم الترخيص', 'MUN-2024-001'),
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
                        'متخصص في نظام فواتير النفايات',
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
              Navigator.pop(context);
              Navigator.pop(context);
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
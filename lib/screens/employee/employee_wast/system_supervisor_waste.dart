import 'package:flutter/material.dart';

class SystemSupervisorWasteScreen extends StatefulWidget {
  const SystemSupervisorWasteScreen({super.key});

  @override
  State<SystemSupervisorWasteScreen> createState() =>
      _SystemSupervisorWasteScreenState();
}

class _SystemSupervisorWasteScreenState
    extends State<SystemSupervisorWasteScreen> {
  // الألوان الأساسية
  final Color _primaryColor = const Color(0xFF2E7D32);
  final Color _secondaryColor = const Color(0xFF4CAF50);
  final Color _accentColor = const Color(0xFF8BC34A);
  final Color _warningColor = const Color(0xFFFF9800);
  final Color _dangerColor = const Color(0xFFD32F2F);
  final Color _infoColor = const Color(0xFF2196F3);
  final Color _backgroundGradientStart = const Color(0xFFF8FFF9);
  final Color _backgroundGradientEnd = const Color(0xFFE8F5E9);
  final Color _darkBackgroundStart = const Color(0xFF1B5E20);
  final Color _darkBackgroundEnd = const Color(0xFF0D1B0E);
  final Color _darkPrimaryColor = const Color(0xFF1B5E20);
  
  int _selectedTab = 0;
  final PageController _pageController = PageController();
  
  // متغيرات الفلترة
  String _selectedPriority = 'الكل';
  String _selectedStatus = 'الكل';
  String _selectedReportType = 'الكل';
  
  // متغيرات تفاعلية
  Map<String, dynamic>? _selectedRouteForDetails;
  Map<String, dynamic>? _selectedReportForUpdate;
  bool _showImagePreview = false;
  String? _selectedImageForPreview;
  bool _isLoading = false;
  
  // متغيرات نموذج طلب التقرير
  String _selectedEmployeeId = '';
  String _selectedReportTypeForRequest = 'تقرير يومي';
  String _selectedPriorityForRequest = 'متوسطة';
  final TextEditingController _notesController = TextEditingController();
  
  // متغيرات لاختيار التاريخ اليدوي
  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;
  
  // قائمة الأيام والشهور والسنوات
  final List<String> _days = List.generate(31, (index) => (index + 1).toString());
  final List<String> _months = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];
  final List<String> _years = ['2024', '2025', '2026', '2027', '2028'];
  
  // متغير التحكم في عرض شاشة اختيار التاريخ
  bool _showDatePickerScreen = false;
  
  // المتغيرات الجديدة لاختيار التاريخ
  DateTime? _selectedDate;
  
  // متغيرات مؤقتة لتحويل التواريخ
  final Map<int, String> _monthNames = {
    1: 'يناير',
    2: 'فبراير',
    3: 'مارس',
    4: 'أبريل',
    5: 'مايو',
    6: 'يونيو',
    7: 'يوليو',
    8: 'أغسطس',
    9: 'سبتمبر',
    10: 'أكتوبر',
    11: 'نوفمبر',
    12: 'ديسمبر'
  };
  
  final Map<int, String> _dayNames = {
    1: 'الاثنين',
    2: 'الثلاثاء',
    3: 'الأربعاء',
    4: 'الخميس',
    5: 'الجمعة',
    6: 'السبت',
    7: 'الأحد'
  };

  // === متغيرات الإعدادات ===
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'العربية';
  final List<String> _languages = ['العربية', 'English', 'Français', 'Español'];
  
  // === البيانات الوهمية ===
  
  // البيانات الوهمية للمسارات (مختصرة)
  final List<Map<String, dynamic>> _routesData = [
    {
      'id': 'RT-001',
      'name': 'مسار النهضة',
      'driver': 'أحمد محمد',
      'driverPhone': '0551234567',
      'vehicle': 'شاحنة 10',
      'progress': 0.65,
      'status': 'قيد التنفيذ',
      'statusColor': Colors.orange,
      'icon': Icons.directions_car,
      'color': Colors.orange,
      'wasteCollected': '12.5 طن',
      'totalWaste': '19 طن',
      'stopsCompleted': 15,
      'totalStops': 23,
      'efficiency': '85%',
    },
    {
      'id': 'RT-002',
      'name': 'مسار السلام',
      'driver': 'سعيد علي',
      'driverPhone': '0557654321',
      'vehicle': 'شاحنة 05',
      'progress': 1.0,
      'status': 'مكتمل',
      'statusColor': Colors.green,
      'icon': Icons.check_circle,
      'color': Colors.green,
      'wasteCollected': '8.2 طن',
      'totalWaste': '8.2 طن',
      'stopsCompleted': 18,
      'totalStops': 18,
      'efficiency': '95%',
    },
  ];

  // البيانات الوهمية للبلاغات (مختصرة)
  List<Map<String, dynamic>> _reportsData = [
    {
      'id': 'RP-001',
      'type': 'انسداد طريق',
      'description': 'حاويات نفايات تعيق حركة المرور',
      'location': 'شارع الملك فهد',
      'time': '10:30 ص',
      'date': '15/01',
      'reporter': 'مواطن',
      'reporterPhone': '0558889999',
      'icon': Icons.block,
      'color': Colors.red,
      'priority': 'عالية',
      'status': 'قيد المعالجة',
      'statusColor': Colors.orange,
      'assignedTo': 'فريق الصيانة 2',
      'sender': 'مشرف النظام',
      'receiver': 'فريق الصيانة',
      'isReceived': false,
    },
    {
      'id': 'RP-002',
      'type': 'حاوية ممتلئة',
      'description': 'حاوية نفايات ممتلئة بشكل زائد',
      'location': 'حي الخليج',
      'time': '03:20 م',
      'date': '15/01',
      'reporter': 'ساكن',
      'reporterPhone': '0557776666',
      'icon': Icons.delete,
      'color': Colors.orange,
      'priority': 'متوسطة',
      'status': 'معلقة',
      'statusColor': Colors.yellow,
      'assignedTo': 'شاحنة 05',
      'sender': 'بلدية المنطقة',
      'receiver': 'مشرف النظام',
      'isReceived': true,
    },
    {
      'id': 'RP-003',
      'type': 'تسرب نفايات',
      'description': 'تسرب سوائل يسبب روائح كريهة',
      'location': 'حي الورود',
      'time': '08:15 ص',
      'date': '15/01',
      'reporter': 'مراقب بيئي',
      'reporterPhone': '0552223333',
      'icon': Icons.warning,
      'color': Colors.red,
      'priority': 'عالية',
      'status': 'قيد المعالجة',
      'statusColor': Colors.orange,
      'assignedTo': 'فريق النظافة 3',
      'sender': 'وزارة البيئة',
      'receiver': 'مشرف النظام',
      'isReceived': true,
    },
  ];

  // البيانات الوهمية للتقارير الخاصة بالمشرف (مختصرة) - تم حذف تقرير الصيانة وتقرير الأداء
  final List<Map<String, dynamic>> _supervisorReports = [
    {
      'id': 'SR-001',
      'title': 'تقرير الأداء الشهري',
      'description': 'تقرير شامل عن أداء عمليات جمع النفايات',
      'type': 'تقرير أداء',
      'sender': 'مدير الإدارة',
      'receiver': 'مشرف النظام',
      'date': '10/01',
      'status': 'تم المراجعة',
      'priority': 'عالية',
      'icon': Icons.assessment,
      'color': Colors.blue,
      'actionRequired': true,
    },
    {
      'id': 'SR-002',
      'title': 'تقرير المخالفات',
      'description': 'تقرير عن المخالفات البيئية المسجلة',
      'type': 'تقرير مخالفات',
      'sender': 'مشرف النظام',
      'receiver': 'وزارة البيئة',
      'date': '14/01',
      'status': 'مُرسل',
      'priority': 'عالية',
      'icon': Icons.gavel,
      'color': Colors.red,
      'actionRequired': false,
    },
  ];

  // البيانات الوهمية للموظفين الذين يمكن طلب التقارير منهم
  final List<Map<String, dynamic>> _employees = [
    {
      'id': 'EMP-001',
      'name': 'محمد علي',
      'position': 'مراقب النفايات',
      'phone': '0551112222',
      'icon': Icons.engineering,
      'color': Colors.blue,
      'email': 'mohammed@waste.com',
    },
    {
      'id': 'EMP-002',
      'name': 'فهد سعود',
      'position': 'مسؤول الصيانة',
      'phone': '0553334444',
      'icon': Icons.build,
      'color': Colors.orange,
      'email': 'fahad@waste.com',
    },
    {
      'id': 'EMP-003',
      'name': 'سارة أحمد',
      'position': 'مشرفة النظافة',
      'phone': '0555556666',
      'icon': Icons.cleaning_services,
      'color': Colors.green,
      'email': 'sara@waste.com',
    },
    {
      'id': 'EMP-004',
      'name': 'خالد حسن',
      'position': 'مدير العمليات',
      'phone': '0557778888',
      'icon': Icons.business,
      'color': Colors.purple,
      'email': 'khaled@waste.com',
    },
  ];

  // قائمة طلبات التقارير المرسلة
  List<Map<String, dynamic>> _reportRequests = [
    {
      'id': 'RR-001',
      'employeeId': 'EMP-001',
      'employeeName': 'محمد علي',
      'reportType': 'تقرير يومي',
      'period': '1 يوم',
      'requestDate': '2024-01-15',
      'dueDate': '2024-01-16',
      'status': 'معلقة',
      'statusColor': Colors.orange,
      'priority': 'متوسطة',
      'notes': 'مطلوب تقرير مفصل عن كمية النفايات المجمعة',
      'icon': Icons.today,
      'color': Colors.blue,
    },
    {
      'id': 'RR-002',
      'employeeId': 'EMP-003',
      'employeeName': 'سارة أحمد',
      'reportType': 'تقرير أسبوعي',
      'period': '7 أيام',
      'requestDate': '2024-01-10',
      'dueDate': '2024-01-17',
      'status': 'مستلمة',
      'statusColor': Colors.green,
      'priority': 'عالية',
      'notes': 'تقرير شامل عن النظافة في المنطقة الشرقية',
      'icon': Icons.calendar_view_week,
      'color': Colors.green,
    },
    {
      'id': 'RR-003',
      'employeeId': 'EMP-002',
      'employeeName': 'فهد سعود',
      'reportType': 'تقرير صيانة',
      'period': '4 أيام',
      'requestDate': '2024-01-12',
      'dueDate': '2024-01-16',
      'status': 'قيد الإعداد',
      'statusColor': Colors.blue,
      'priority': 'عالية',
      'notes': 'تقرير عن حالات الصيانة العاجلة للمركبات',
      'icon': Icons.build,
      'color': Colors.orange,
    },
  ];

  // البيانات الوهمية للأسئلة الشائعة
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'كيف يمكنني طلب تقرير جديد؟',
      'answer': 'يمكنك طلب تقرير جديد من خلال الذهاب إلى تبويب "تقاريري" ثم الضغط على زر الإضافة (+) وملء النموذج.',
    },
    {
      'question': 'كيف أتتبع حالة البلاغات؟',
      'answer': 'يمكنك تتبع حالة البلاغات من خلال تبويب "البلاغات" حيث يمكنك تصفية البلاغات حسب حالتها.',
    },
    {
      'question': 'كيف أتواصل مع الدعم الفني؟',
      'answer': 'يمكنك التواصل مع الدعم الفني من خلال زر "اتصل بنا" في قسم المساعدة والدعم.',
    },
    {
      'question': 'كيف أغير اللغة في التطبيق؟',
      'answer': 'يمكنك تغيير اللغة من خلال الإعدادات ثم اختيار اللغة المناسبة من القائمة.',
    },
    {
      'question': 'هل يمكنني إيقاف الإشعارات؟',
      'answer': 'نعم، يمكنك إيقاف الإشعارات من خلال الإعدادات وإيقاف تفعيل الإشعارات.',
    },
  ];

  @override
  void initState() {
    super.initState();
    // تعيين التاريخ الحالي كقيمة افتراضية
    _selectedDate = DateTime.now();
    // تعيين القيم الافتراضية لاختيار التاريخ اليدوي
    _selectedDay = DateTime.now().day.toString();
    _selectedMonth = _months[DateTime.now().month - 1];
    _selectedYear = DateTime.now().year.toString();
  }

  // الحصول على البلاغات المصفاة
  List<Map<String, dynamic>> get _filteredReports {
    List<Map<String, dynamic>> filtered = _reportsData;
    
    if (_selectedPriority != 'الكل') {
      filtered = filtered.where((report) => report['priority'] == _selectedPriority).toList();
    }
    
    if (_selectedStatus != 'الكل') {
      filtered = filtered.where((report) => report['status'] == _selectedStatus).toList();
    }
    
    return filtered;
  }

  // الحصول على التقارير المصفاة
  List<Map<String, dynamic>> get _filteredSupervisorReports {
    List<Map<String, dynamic>> filtered = _supervisorReports;
    
    if (_selectedReportType == 'مستلمة') {
      filtered = filtered.where((report) => report['receiver'] == 'مشرف النظام').toList();
    } else if (_selectedReportType == 'مرسلة') {
      filtered = filtered.where((report) => report['sender'] == 'مشرف النظام').toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildGovernmentDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: _darkModeEnabled
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_darkBackgroundStart, _darkBackgroundEnd],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_backgroundGradientStart, _backgroundGradientEnd],
                ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // المحتوى الرئيسي
              Column(
                children: [
                  // App Bar مخصص ومبسط
                  _buildSimplifiedAppBar(),
                  
                  // شريط تبويب مبسط
                  _buildSimplifiedTabBar(),
                  
                  // المحتوى الرئيسي
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedTab = index;
                        });
                      },
                      children: [
                        _buildDashboardView(),
                        _buildRoutesView(),
                        _buildReportsView(),
                        _buildSupervisorReportsView(),
                      ],
                    ),
                  ),
                ],
              ),
              
              // شاشة اختيار التاريخ (تظهر فوق كل شيء)
              if (_showDatePickerScreen)
                _buildDatePickerScreen(),
            ],
          ),
        ),
      ),
    );
  }

  // ========== القائمة المنسدلة (Drawer) ==========
  Widget _buildGovernmentDrawer(BuildContext context) {
    final isDarkMode = _darkModeEnabled;
    
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
                      Icons.supervisor_account_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 16),
                  // الاسم والوظيفة
                  Text(
                    "مشرف النظام",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "مشرف - قسم إدارة النفايات",
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
                        _showSettingsScreen(context);
                      },
                      isDarkMode: isDarkMode,
                    ),
                    
                    // المساعدة والدعم
                    _buildDrawerMenuItem(
                      icon: Icons.help_rounded,
                      title: 'المساعدة والدعم',
                      onTap: () {
                        Navigator.pop(context);
                        _showHelpSupportScreen(context);
                      },
                      isDarkMode: isDarkMode,
                    ),

                    SizedBox(height: 30),
                    
                    // تسجيل الخروج
                    _buildDrawerMenuItem(
                      icon: Icons.logout_rounded,
                      title: 'تسجيل الخروج',
                      onTap: () {
                        _showLogoutConfirmation(context);
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
                            'نظام إدارة النفايات',
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

  void _showLogoutConfirmation(BuildContext context) {
    final isDarkMode = _darkModeEnabled;
    final _errorColor = Colors.red;
    final _textSecondaryColor = Colors.grey;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
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
            color: isDarkMode ? Colors.white : Colors.black,
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
              Navigator.pop(context); // إغلاق القائمة المنسدلة
              _showSuccessMessage('تم تسجيل الخروج بنجاح');
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

  void _showSettingsScreen(BuildContext context) {
    final isDarkMode = _darkModeEnabled;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300]!,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // عنوان الشاشة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الإعدادات',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: isDarkMode ? Colors.white : Colors.black),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // تفعيل الإشعارات
              _buildSettingsItem(
                icon: Icons.notifications,
                title: 'تفعيل الإشعارات',
                subtitle: 'تلقي إشعارات حول البلاغات والتقارير',
                isDarkMode: isDarkMode,
                isSwitch: true,
                switchValue: _notificationsEnabled,
                onSwitchChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              
              SizedBox(height: 15),
              
              // تفعيل الصوت
              _buildSettingsItem(
                icon: Icons.volume_up,
                title: 'تفعيل الصوت',
                subtitle: 'تشغيل أصوات التنبيهات',
                isDarkMode: isDarkMode,
                isSwitch: true,
                switchValue: _soundEnabled,
                onSwitchChanged: (value) {
                  setState(() {
                    _soundEnabled = value;
                  });
                },
              ),
              
              SizedBox(height: 15),
              
              // تفعيل الاهتزاز
              _buildSettingsItem(
                icon: Icons.vibration,
                title: 'تفعيل الاهتزاز',
                subtitle: 'تفعيل الاهتزاز عند التنبيهات',
                isDarkMode: isDarkMode,
                isSwitch: true,
                switchValue: _vibrationEnabled,
                onSwitchChanged: (value) {
                  setState(() {
                    _vibrationEnabled = value;
                  });
                },
              ),
              
              SizedBox(height: 15),
              
              // الوضع الداكن
              _buildSettingsItem(
                icon: Icons.dark_mode,
                title: 'الوضع الداكن',
                subtitle: 'تفعيل المظهر الداكن للتطبيق',
                isDarkMode: isDarkMode,
                isSwitch: true,
                switchValue: _darkModeEnabled,
                onSwitchChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
              ),
              
              SizedBox(height: 15),
              
              // اختيار اللغة
              _buildSettingsItem(
                icon: Icons.language,
                title: 'اختيار اللغة',
                subtitle: _selectedLanguage,
                isDarkMode: isDarkMode,
                isDropdown: true,
                dropdownValue: _selectedLanguage,
                dropdownItems: _languages,
                onDropdownChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
              
              SizedBox(height: 30),
              
              // معلومات حول التطبيق
              _buildSettingsItem(
                icon: Icons.info,
                title: 'معلومات حول التطبيق',
                subtitle: 'عرض معلومات عن التطبيق',
                isDarkMode: isDarkMode,
                onTap: () {
                  _showAppInfoDialog(context);
                },
              ),
              
              SizedBox(height: 30),
              
              // زر حفظ الإعدادات
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _saveSettings();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'حفظ الإعدادات',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
    bool isSwitch = false,
    bool isDropdown = false,
    bool switchValue = false,
    String dropdownValue = '',
    List<String> dropdownItems = const [],
    ValueChanged<bool>? onSwitchChanged,
    ValueChanged<String?>? onDropdownChanged,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: _primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: isSwitch
            ? Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
                activeColor: _primaryColor,
              )
            : isDropdown
                ? DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down, color: _primaryColor),
                    underline: Container(),
                    onChanged: onDropdownChanged,
                    items: dropdownItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                : Icon(Icons.arrow_forward_ios, size: 16, color: _primaryColor),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    final isDarkMode = _darkModeEnabled;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.info, color: _primaryColor),
            SizedBox(width: 10),
            Text(
              'معلومات حول التطبيق',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نظام إدارة النفايات الذكي',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            _buildInfoItem('الإصدار:', '1.0.0', isDarkMode),
            _buildInfoItem('تاريخ الإصدار:', 'يناير 2024', isDarkMode),
            _buildInfoItem('المطور:', 'فريق تطوير النظم', isDarkMode),
            _buildInfoItem('الهدف:', 'إدارة عمليات جمع النفايات بكفاءة', isDarkMode),
            SizedBox(height: 15),
            Text(
              'هذا التطبيق يساعد في إدارة عمليات جمع النفايات وتتبع المسارات والبلاغات وإعداد التقارير.',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
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

  Widget _buildInfoItem(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[700],
              fontSize: 14,
            ),
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    _showSuccessMessage('تم حفظ الإعدادات بنجاح');
    
    // تسجيل الإعدادات الحالية
    print('=== الإعدادات المحفوظة ===');
    print('الإشعارات: $_notificationsEnabled');
    print('الصوت: $_soundEnabled');
    print('الاهتزاز: $_vibrationEnabled');
    print('الوضع الداكن: $_darkModeEnabled');
    print('اللغة: $_selectedLanguage');
    print('========================');
  }

  void _showHelpSupportScreen(BuildContext context) {
    final isDarkMode = _darkModeEnabled;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300]!,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // عنوان الشاشة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المساعدة والدعم',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: isDarkMode ? Colors.white : Colors.black),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // مركز الدعم الفني
              _buildHelpSupportItem(
                icon: Icons.support_agent,
                title: 'مركز الدعم الفني',
                subtitle: 'تواصل مع فريق الدعم الفني',
                isDarkMode: isDarkMode,
                onTap: () {
                  _showSupportContactDialog(context);
                },
              ),
              
              SizedBox(height: 15),
              
              // الأسئلة الشائعة
              _buildHelpSupportItem(
                icon: Icons.question_answer,
                title: 'الأسئلة الشائعة',
                subtitle: 'إجابات على الأسئلة المتكررة',
                isDarkMode: isDarkMode,
                onTap: () {
                  _showFAQsDialog(context);
                },
              ),
              
              SizedBox(height: 15),
              
              // معلومات عن التطبيق
              _buildHelpSupportItem(
                icon: Icons.info_outline,
                title: 'معلومات عن التطبيق',
                subtitle: 'تعرف على التطبيق ومميزاته',
                isDarkMode: isDarkMode,
                onTap: () {
                  _showAppInfoDialog(context);
                },
              ),
              
              SizedBox(height: 30),
              
              // قسم اتصل بنا
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primaryColor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تواصل معنا',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : _primaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildContactInfo(
                      icon: Icons.phone,
                      text: '920020000',
                      isDarkMode: isDarkMode,
                    ),
                    _buildContactInfo(
                      icon: Icons.email,
                      text: 'support@waste-system.com',
                      isDarkMode: isDarkMode,
                    ),
                    _buildContactInfo(
                      icon: Icons.access_time,
                      text: 'من الأحد إلى الخميس | 8 ص - 4 م',
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // زر إرسال استفسار
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _showSendInquiryDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primaryColor,
                    side: BorderSide(color: _primaryColor),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'إرسال استفسار',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSupportItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: _primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: _primaryColor),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String text,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _primaryColor),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSupportContactDialog(BuildContext context) {
    final isDarkMode = _darkModeEnabled;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.support_agent, color: _primaryColor),
            SizedBox(width: 10),
            Text(
              'مركز الدعم الفني',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'فريق الدعم الفني جاهز لمساعدتك في أي وقت',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 15),
            
            _buildSupportOption(
              icon: Icons.phone,
              title: 'الاتصال الهاتفي',
              subtitle: '920020000',
              color: Colors.green,
              onTap: () {
                _makePhoneCall('920020000');
              },
              isDarkMode: isDarkMode,
            ),
            
            SizedBox(height: 10),
            
            _buildSupportOption(
              icon: Icons.email,
              title: 'البريد الإلكتروني',
              subtitle: 'support@waste-system.com',
              color: Colors.blue,
              onTap: () {
                _sendEmail('support@waste-system.com');
              },
              isDarkMode: isDarkMode,
            ),
            
            SizedBox(height: 10),
            
            _buildSupportOption(
              icon: Icons.chat,
              title: 'الدردشة المباشرة',
              subtitle: 'متاح خلال ساعات العمل',
              color: Colors.orange,
              onTap: () {
                _startChatSupport();
              },
              isDarkMode: isDarkMode,
            ),
          ],
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

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: color),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
    );
  }

  void _showFAQsDialog(BuildContext context) {
    final isDarkMode = _darkModeEnabled;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // رأس الشاشة
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : _primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الأسئلة الشائعة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _faqs.length,
                itemBuilder: (context, index) {
                  final faq = _faqs[index];
                  return _buildFAQItem(
                    question: faq['question'] as String,
                    answer: faq['answer'] as String,
                    isDarkMode: isDarkMode,
                    index: index + 1,
                  );
                },
              ),
            ),
            
            // زر مساعدة إضافية
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                children: [
                  Icon(Icons.help_outline, color: _primaryColor),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'لم تجد إجابتك؟ تواصل مع الدعم الفني',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showSupportContactDialog(context);
                    },
                    child: Text('اتصل الآن', style: TextStyle(color: _primaryColor)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
    required bool isDarkMode,
    required int index,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          radius: 15,
          backgroundColor: _primaryColor,
          child: Text(
            '$index',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        iconColor: _primaryColor,
        collapsedIconColor: _primaryColor,
      ),
    );
  }

  void _showSendInquiryDialog(BuildContext context) {
    final isDarkMode = _darkModeEnabled;
    final TextEditingController inquiryController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.email, color: _primaryColor),
            SizedBox(width: 10),
            Text(
              'إرسال استفسار',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اكتب استفسارك وسيقوم فريق الدعم بالرد عليك خلال 24 ساعة',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 15),
            
            TextField(
              controller: inquiryController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'اكتب استفسارك هنا...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              ),
            ),
            
            SizedBox(height: 15),
            
            Text(
              'سيتم الرد على بريدك الإلكتروني المسجل في النظام',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (inquiryController.text.trim().isEmpty) {
                _showErrorMessage('يرجى كتابة الاستفسار');
                return;
              }
              
              Navigator.pop(context);
              _showSuccessMessage('تم إرسال الاستفسار بنجاح');
              
              // محاكاة إرسال الاستفسار
              print('=== استفسار جديد ===');
              print('الاستفسار: ${inquiryController.text}');
              print('===================');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('إرسال'),
          ),
        ],
      ),
    );
  }

  // === دوال محاكاة الاتصال ===
  
  void _makePhoneCall(String phoneNumber) {
    _showSuccessMessage('جاري الاتصال بـ $phoneNumber');
  }
  
  void _sendEmail(String email) {
    _showSuccessMessage('جاري فتح بريد إلكتروني إلى $email');
  }
  
  void _startChatSupport() {
    _showSuccessMessage('جاري فتح الدردشة مع الدعم الفني');
  }

  // ========== باقي كود الشاشة ==========

  Widget _buildSimplifiedAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: _darkModeEnabled ? _darkPrimaryColor : _primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر القائمة المنسدلة (هامبرجر)
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu, color: Colors.white),
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
              const Text(
                'مشرف النظام',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimplifiedTabBar() {
    final List<Map<String, dynamic>> tabs = [
      {'icon': Icons.dashboard, 'label': 'الرئيسية'},
      {'icon': Icons.route, 'label': 'المسارات'},
      {'icon': Icons.report_problem, 'label': 'البلاغات'},
      {'icon': Icons.description, 'label': 'تقاريري'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: _darkModeEnabled ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_darkModeEnabled ? 0.3 : 0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (index) {
          bool isSelected = _selectedTab == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTab = index;
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tabs[index]['icon'] as IconData,
                    color: isSelected ? Colors.white : (_darkModeEnabled ? Colors.grey[400] : Colors.grey),
                    size: 18,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tabs[index]['label'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : (_darkModeEnabled ? Colors.grey[400] : Colors.grey),
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // بطاقات الإحصاءات (مبسطة)
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
            children: [
              _buildSimpleStatCard(
                icon: Icons.delete_sweep,
                title: 'النفايات',
                value: '2,450 طن',
                color: Colors.green,
              ),
              _buildSimpleStatCard(
                icon: Icons.timer,
                title: 'الكفاءة',
                value: '92%',
                color: Colors.blue,
              ),
              _buildSimpleStatCard(
                icon: Icons.warning_amber,
                title: 'البلاغات',
                value: '${_reportsData.length}',
                color: Colors.orange,
              ),
              _buildSimpleStatCard(
                icon: Icons.description,
                title: 'تقاريري',
                value: '${_supervisorReports.length}',
                color: Colors.purple,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // المسارات النشطة
          _buildSectionHeader(
            title: 'المسارات النشطة',
            icon: Icons.route,
            onSeeAll: () => _pageController.jumpToPage(1),
          ),
          
          _buildCompactActiveRoutesList(),
          
          const SizedBox(height: 20),
          
          // البلاغات الحديثة
          _buildSectionHeader(
            title: 'آخر البلاغات',
            icon: Icons.report,
            onSeeAll: () => _pageController.jumpToPage(2),
          ),
          
          _buildCompactRecentReportsList(),
          
          const SizedBox(height: 20),
          
          // آخر التقارير
          _buildSectionHeader(
            title: 'آخر التقارير',
            icon: Icons.description,
            onSeeAll: () => _pageController.jumpToPage(3),
          ),
          
          _buildCompactRecentSupervisorReportsList(),
          
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSimpleStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _darkModeEnabled ? Colors.grey[800] : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[700],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    VoidCallback? onSeeAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: _primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _darkModeEnabled ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              foregroundColor: _primaryColor,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
            child: const Text('المزيد', style: TextStyle(fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildCompactActiveRoutesList() {
    return Column(
      children: _routesData.take(2).map((route) => _buildCompactRouteCard(route)).toList(),
    );
  }

  Widget _buildCompactRouteCard(Map<String, dynamic> route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _darkModeEnabled ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_darkModeEnabled ? 0.3 : 0.1),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: route['color'] as Color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(route['icon'] as IconData, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route['name'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: _darkModeEnabled ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${route['driver']} • ${route['vehicle']}',
                  style: TextStyle(
                    color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (route['statusColor'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  route['status'] as String,
                  style: TextStyle(
                    color: route['statusColor'] as Color,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(route['progress'] * 100).toInt()}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: _darkModeEnabled ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactRecentReportsList() {
    return Column(
      children: _reportsData.take(3).map((report) => _buildCompactReportCard(report)).toList(),
    );
  }

  Widget _buildCompactReportCard(Map<String, dynamic> report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _darkModeEnabled ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_darkModeEnabled ? 0.3 : 0.1),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: (report['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              report['icon'] as IconData,
              color: report['color'] as Color,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report['type'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: _darkModeEnabled ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  report['location'] as String,
                  style: TextStyle(
                    color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600], 
                    fontSize: 11
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${report['time']} - ${report['date']}',
                  style: TextStyle(
                    color: _darkModeEnabled ? Colors.grey[500] : Colors.grey[500], 
                    fontSize: 10
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (report['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              report['priority'] as String,
              style: TextStyle(
                color: report['color'] as Color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactRecentSupervisorReportsList() {
    return Column(
      children: _supervisorReports.take(2).map((report) => _buildCompactSupervisorReportCard(report)).toList(),
    );
  }

  Widget _buildCompactSupervisorReportCard(Map<String, dynamic> report) {
    final bool isReceived = report['receiver'] == 'مشرف النظام';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _darkModeEnabled ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_darkModeEnabled ? 0.3 : 0.1),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: (report['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              report['icon'] as IconData,
              color: report['color'] as Color,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report['title'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: _darkModeEnabled ? Colors.white : Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  isReceived ? 'من: ${report['sender']}' : 'إلى: ${report['receiver']}',
                  style: TextStyle(
                    color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600], 
                    fontSize: 11
                  ),
                ),
                Text(
                  report['date'] as String,
                  style: TextStyle(
                    color: _darkModeEnabled ? Colors.grey[500] : Colors.grey[500], 
                    fontSize: 10
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isReceived ? Colors.blue.withOpacity(0.1) : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isReceived ? 'مستلم' : 'مرسل',
              style: TextStyle(
                color: isReceived ? Colors.blue : Colors.green,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutesView() {
    return Column(
      children: [
        // عنوان القسم
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          color: _darkModeEnabled ? Colors.grey[900] : Colors.white,
          child: Row(
            children: [
              Icon(Icons.route, color: _primaryColor, size: 22),
              const SizedBox(width: 10),
              Text(
                'المسارات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _darkModeEnabled ? Colors.white : Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                '${_routesData.length} مسار',
                style: TextStyle(
                  color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        // قائمة المسارات
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _routesData.length,
            itemBuilder: (context, index) {
              return _buildCompactDetailedRouteCard(_routesData[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCompactDetailedRouteCard(Map<String, dynamic> route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _darkModeEnabled ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_darkModeEnabled ? 0.3 : 0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // رأس البطاقة
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: route['color'] as Color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(route['icon'] as IconData, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route['name'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'رقم: ${route['id']}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    route['status'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // محتوى البطاقة
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // معلومات السائق والمركبة
                Row(
                  children: [
                    Icon(Icons.person, color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600], size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        route['driver'] as String,
                        style: TextStyle(
                          color: _darkModeEnabled ? Colors.white : Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Icon(Icons.local_shipping, color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600], size: 16),
                    const SizedBox(width: 6),
                    Text(
                      route['vehicle'] as String,
                      style: TextStyle(
                        color: _darkModeEnabled ? Colors.white : Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // معدل الإنجاز
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'معدل الإنجاز',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: _darkModeEnabled ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          '${(route['progress'] * 100).toInt()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: route['color'] as Color,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: route['progress'] as double,
                      backgroundColor: _darkModeEnabled ? Colors.grey[700] : Colors.grey[200],
                      color: route['color'] as Color,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${route['stopsCompleted']}/${route['totalStops']} محطة',
                          style: TextStyle(
                            color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600], 
                            fontSize: 11
                          ),
                        ),
                        Text(
                          route['efficiency'] as String,
                          style: TextStyle(
                            color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600], 
                            fontSize: 11
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // إحصائيات سريعة
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _darkModeEnabled ? Colors.grey[900] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.delete, color: route['color'] as Color, size: 18),
                          const SizedBox(height: 4),
                          Text(
                            route['wasteCollected'] as String,
                            style: TextStyle(
                              color: route['color'] as Color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'نفايات',
                            style: TextStyle(
                              color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600], 
                              fontSize: 10
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.info, color: route['color'] as Color, size: 18),
                          const SizedBox(height: 4),
                          Text(
                            'معلومات',
                            style: TextStyle(
                              color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600], 
                              fontSize: 10
                            ),
                          ),
                          Text(
                            route['driverPhone'] as String,
                            style: TextStyle(
                              color: route['color'] as Color,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // أزرار الإجراءات - تفاصيل فقط
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showRouteDetails(route),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: route['color'] as Color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'عرض التفاصيل',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsView() {
    return Column(
      children: [
        // عنوان القسم
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          color: _darkModeEnabled ? Colors.grey[900] : Colors.white,
          child: Row(
            children: [
              Icon(Icons.report_problem, color: _primaryColor, size: 22),
              const SizedBox(width: 10),
              Text(
                'البلاغات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _darkModeEnabled ? Colors.white : Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                '${_filteredReports.length} بلاغ',
                style: TextStyle(
                  color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => _showFiltersDialog(context),
                icon: Icon(Icons.filter_list, color: _primaryColor, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        
        // شريط الفلترة السريعة
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: _darkModeEnabled ? Colors.grey[900] : Colors.grey[50],
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSimpleFilterChip('الكل', _selectedPriority == 'الكل' && _selectedStatus == 'الكل', _primaryColor, () {
                  setState(() {
                    _selectedPriority = 'الكل';
                    _selectedStatus = 'الكل';
                  });
                }),
                _buildSimpleFilterChip('عالية', _selectedPriority == 'عالية', Colors.red, () {
                  setState(() {
                    _selectedPriority = 'عالية';
                    _selectedStatus = 'الكل';
                  });
                }),
                _buildSimpleFilterChip('متوسطة', _selectedPriority == 'متوسطة', Colors.orange, () {
                  setState(() {
                    _selectedPriority = 'متوسطة';
                    _selectedStatus = 'الكل';
                  });
                }),
                _buildSimpleFilterChip('قيد المعالجة', _selectedStatus == 'قيد المعالجة', Colors.blue, () {
                  setState(() {
                    _selectedPriority = 'الكل';
                    _selectedStatus = 'قيد المعالجة';
                  });
                }),
                _buildSimpleFilterChip('تم الحل', _selectedStatus == 'تم الحل', Colors.green, () {
                  setState(() {
                    _selectedPriority = 'الكل';
                    _selectedStatus = 'تم الحل';
                  });
                }),
              ],
            ),
          ),
        ),
        
        // قائمة البلاغات
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _filteredReports.length,
                  itemBuilder: (context, index) {
                    return _buildCompactDetailedReportCard(_filteredReports[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSupervisorReportsView() {
    return Column(
      children: [
        // عنوان القسم
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          color: _darkModeEnabled ? Colors.grey[900] : Colors.white,
          child: Row(
            children: [
              Icon(Icons.description, color: _primaryColor, size: 22),
              const SizedBox(width: 10),
              Text(
                'تقاريري',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _darkModeEnabled ? Colors.white : Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                '${_filteredSupervisorReports.length} تقرير',
                style: TextStyle(
                  color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => _showSupervisorReportFiltersDialog(context),
                icon: Icon(Icons.filter_list, color: _primaryColor, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 10),
              // زر طلب تقرير جديد
              IconButton(
                onPressed: () => _showRequestReportDialog(context),
                icon: Icon(Icons.add, color: _primaryColor, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        
        // شريط الفلترة السريعة
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: _darkModeEnabled ? Colors.grey[900] : Colors.grey[50],
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSimpleReportFilterChip('الكل', _selectedReportType == 'الكل', _primaryColor, () {
                  setState(() {
                    _selectedReportType = 'الكل';
                  });
                }),
                _buildSimpleReportFilterChip('مستلمة', _selectedReportType == 'مستلمة', Colors.blue, () {
                  setState(() {
                    _selectedReportType = 'مستلمة';
                  });
                }),
                _buildSimpleReportFilterChip('مرسلة', _selectedReportType == 'مرسلة', Colors.green, () {
                  setState(() {
                    _selectedReportType = 'مرسلة';
                  });
                }),
                _buildSimpleReportFilterChip('طلبات التقارير', _selectedReportType == 'طلبات', Colors.purple, () {
                  setState(() {
                    _selectedReportType = 'طلبات';
                  });
                }),
              ],
            ),
          ),
        ),
        
        // قائمة التقارير أو الطلبات حسب التصفية
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _selectedReportType == 'طلبات'
                  ? _buildReportRequestsList()
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _filteredSupervisorReports.length,
                      itemBuilder: (context, index) {
                        return _buildCompactDetailedSupervisorReportCard(_filteredSupervisorReports[index]);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildReportRequestsList() {
    if (_reportRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.request_page, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'لا توجد طلبات تقارير',
              style: TextStyle(
                fontSize: 16,
                color: _darkModeEnabled ? Colors.grey[400] : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'يمكنك طلب تقرير جديد باستخدام زر الإضافة',
              style: TextStyle(
                fontSize: 14,
                color: _darkModeEnabled ? Colors.grey[500] : Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _reportRequests.length,
      itemBuilder: (context, index) {
        return _buildReportRequestCard(_reportRequests[index]);
      },
    );
  }

  Widget _buildReportRequestCard(Map<String, dynamic> request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _darkModeEnabled ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_darkModeEnabled ? 0.3 : 0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // رأس البطاقة
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: request['color'] as Color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(request['icon'] as IconData, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['reportType'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'طلب: ${request['id']}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request['status'] as String,
                    style: TextStyle(
                      color: request['statusColor'] as Color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // محتوى البطاقة
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // معلومات الموظف
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: request['color'] as Color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request['employeeName'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _darkModeEnabled ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'مطلوب منه التقرير',
                            style: TextStyle(
                              color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // تفاصيل الطلب
                _buildRequestDetailItem('المدة:', request['period'] as String),
                _buildRequestDetailItem('تاريخ الطلب:', request['requestDate'] as String),
                _buildRequestDetailItem('تاريخ التسليم:', request['dueDate'] as String),
                _buildRequestDetailItem('الأولوية:', request['priority'] as String),
                
                const SizedBox(height: 12),
                
                // ملاحظات
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _darkModeEnabled ? Colors.grey[900] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ملاحظات:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _darkModeEnabled ? Colors.grey[300] : Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request['notes'] as String,
                        style: TextStyle(
                          color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // أزرار الإجراءات
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _viewReportRequestDetails(request),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: request['color'] as Color,
                          side: BorderSide(color: request['color'] as Color),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(
                          'تفاصيل',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _sendReminder(request),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: request['color'] as Color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(
                          'تذكير',
                          style: TextStyle(fontSize: 13, color: Colors.white),
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
    );
  }

  Widget _buildRequestDetailItem(String label, String value) {
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
                color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _darkModeEnabled ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleFilterChip(String label, bool selected, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : (_darkModeEnabled ? Colors.grey[800] : Colors.white),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : (_darkModeEnabled ? Colors.grey[400] : color),
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleReportFilterChip(String label, bool selected, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : (_darkModeEnabled ? Colors.grey[800] : Colors.white),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : (_darkModeEnabled ? Colors.grey[400] : color),
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCompactDetailedReportCard(Map<String, dynamic> report) {
    final bool isReceived = report['receiver'] == 'مشرف النظام';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _darkModeEnabled ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_darkModeEnabled ? 0.3 : 0.1),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // رأس البلاغ
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: report['color'] as Color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    report['icon'] as IconData,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report['type'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${report['date']} - ${report['time']}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    report['priority'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // محتوى البلاغ
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // نوع البلاغ (مستلم/مرسل)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isReceived ? Colors.blue.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isReceived ? 'مستلم من ${report['sender']}' : 'مرسل إلى ${report['receiver']}',
                    style: TextStyle(
                      color: isReceived ? Colors.blue : Colors.green,
                      fontSize: 11,
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // وصف البلاغ
                Text(
                  report['description'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: _darkModeEnabled ? Colors.white : Colors.black,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // معلومات الموقع والمبلغ
                Row(
                  children: [
                    Icon(Icons.location_on, color: report['color'] as Color, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        report['location'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: _darkModeEnabled ? Colors.grey[300] : Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 6),
                
                Row(
                  children: [
                    Icon(Icons.person, color: report['color'] as Color, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      report['reporter'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: _darkModeEnabled ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 10),
                
                // الحالة والمكلف
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الحالة:',
                          style: TextStyle(
                            fontSize: 11,
                            color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (report['statusColor'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            report['status'] as String,
                            style: TextStyle(
                              color: report['statusColor'] as Color,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'المكلف:',
                          style: TextStyle(
                            fontSize: 11,
                            color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        Text(
                          report['assignedTo'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _darkModeEnabled ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // أزرار الإجراءات - تم حذف زر الاتصال هنا
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showUpdateStatusDialog(report),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: report['color'] as Color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'تحديث الحالة',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDetailedSupervisorReportCard(Map<String, dynamic> report) {
    final bool isReceived = report['receiver'] == 'مشرف النظام';
    final bool actionRequired = report['actionRequired'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _darkModeEnabled ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_darkModeEnabled ? 0.3 : 0.1),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // رأس التقرير
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: report['color'] as Color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    report['icon'] as IconData,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report['title'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        report['date'] as String,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (actionRequired)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Icon(
                      Icons.warning,
                      size: 14,
                      color: Colors.orange,
                    ),
                  ),
              ],
            ),
          ),
          
          // محتوى التقرير
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // نوع التقرير (مستلم/مرسل)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isReceived ? Colors.blue.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isReceived ? 'مستلم من ${report['sender']}' : 'مرسل إلى ${report['receiver']}',
                    style: TextStyle(
                      color: isReceived ? Colors.blue : Colors.green,
                      fontSize: 11,
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // وصف التقرير
                Text(
                  report['description'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: _darkModeEnabled ? Colors.white : Colors.black,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // الحالة والنوع
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الحالة:',
                          style: TextStyle(
                            fontSize: 11,
                            color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (report['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            report['status'] as String,
                            style: TextStyle(
                              color: report['color'] as Color,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'النوع:',
                          style: TextStyle(
                            fontSize: 11,
                            color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        Text(
                          report['type'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _darkModeEnabled ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // أزرار الإجراءات
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _viewReportDetails(report),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: report['color'] as Color,
                          side: BorderSide(color: report['color'] as Color),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                        ),
                        child: const Text(
                          'عرض',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isReceived && actionRequired
                            ? () => _takeActionOnReport(report)
                            : () => _replyToReport(report),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: report['color'] as Color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                        ),
                        child: Text(
                          isReceived && actionRequired ? 'إجراء' : 'رد',
                          style: const TextStyle(fontSize: 12, color: Colors.white),
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
    );
  }

  // === شاشة اختيار التاريخ ===
  Widget _buildDatePickerScreen() {
    return Positioned.fill(
      child: Container(
        color: _darkModeEnabled ? Colors.grey[900] : Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // شريط العنوان
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showDatePickerScreen = false;
                        });
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'اختر التاريخ المطلوب',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // محتوى شاشة التاريخ
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // عرض التاريخ المحدد حالياً
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: _primaryColor),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'التاريخ المحدد حالياً:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _darkModeEnabled ? Colors.grey[400] : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _getSelectedDateString(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // اختيار اليوم
                      _buildDateSelectionSection(
                        title: 'اختر اليوم',
                        currentValue: _selectedDay,
                        values: _days,
                        onChanged: (value) {
                          setState(() {
                            _selectedDay = value;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // اختيار الشهر
                      _buildDateSelectionSection(
                        title: 'اختر الشهر',
                        currentValue: _selectedMonth,
                        values: _months,
                        onChanged: (value) {
                          setState(() {
                            _selectedMonth = value;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // اختيار السنة
                      _buildDateSelectionSection(
                        title: 'اختر السنة',
                        currentValue: _selectedYear,
                        values: _years,
                        onChanged: (value) {
                          setState(() {
                            _selectedYear = value;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // عرض النتيجة النهائية
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'التاريخ الذي اخترته:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _darkModeEnabled ? Colors.grey[400] : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _getSelectedDateString(),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // أزرار الإجراءات
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _showDatePickerScreen = false;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(color: _primaryColor),
                              ),
                              child: Text(
                                'إلغاء',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _showDatePickerScreen = false;
                                  _showSuccessMessage('تم اختيار التاريخ بنجاح');
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'تأكيد الاختيار',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelectionSection({
    required String title,
    required String? currentValue,
    required List<String> values,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _darkModeEnabled ? Colors.grey[400] : Colors.grey,
          ),
        ),
        const SizedBox(height: 15),
        
        // عرض القيمة المحددة حالياً
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: _darkModeEnabled ? Colors.grey[800] : _primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المحدد: ${currentValue ?? 'لم يتم الاختيار'}',
                style: TextStyle(
                  fontSize: 16,
                  color: currentValue != null ? _primaryColor : (_darkModeEnabled ? Colors.grey[400] : Colors.grey),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.check_circle,
                color: currentValue != null ? Colors.green : (_darkModeEnabled ? Colors.grey[600] : Colors.grey),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // شبكة الخيارات
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5,
          ),
          itemCount: values.length,
          itemBuilder: (context, index) {
            final value = values[index];
            final isSelected = currentValue == value;
            
            return GestureDetector(
              onTap: () {
                onChanged(value);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? _primaryColor : (_darkModeEnabled ? Colors.grey[800] : Colors.white),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? _primaryColor : Colors.grey.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                ),
                child: Center(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : (_darkModeEnabled ? Colors.grey[300] : Colors.grey[700]),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // === الوظائف المساعدة ===
  
  void _showRouteDetails(Map<String, dynamic> route) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _darkModeEnabled ? Colors.grey[900] : Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  route['name'] as String,
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: _darkModeEnabled ? Colors.white : Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: _darkModeEnabled ? Colors.white : Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildRouteDetailItem('رقم المسار:', route['id'] as String),
            _buildRouteDetailItem('السائق:', route['driver'] as String),
            _buildRouteDetailItem('رقم هاتف السائق:', route['driverPhone'] as String),
            _buildRouteDetailItem('المركبة:', route['vehicle'] as String),
            _buildRouteDetailItem('الحالة:', route['status'] as String),
            _buildRouteDetailItem('النفايات المجمعة:', route['wasteCollected'] as String),
            _buildRouteDetailItem('إجمالي النفايات:', route['totalWaste'] as String),
            _buildRouteDetailItem('المحطات المكتملة:', '${route['stopsCompleted']}/${route['totalStops']}'),
            _buildRouteDetailItem('الكفاءة:', route['efficiency'] as String),
            _buildRouteDetailItem('معدل الإنجاز:', '${(route['progress'] * 100).toInt()}%'),
            
            const SizedBox(height: 20),
            
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _darkModeEnabled ? Colors.grey[700] : Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: route['progress'] as double,
                child: Container(
                  decoration: BoxDecoration(
                    color: route['color'] as Color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: route['color'] as Color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'إغلاق',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: _darkModeEnabled ? Colors.grey[300] : Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                color: _darkModeEnabled ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateStatusDialog(Map<String, dynamic> report) {
    String newStatus = report['status'] as String;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _darkModeEnabled ? Colors.grey[900] : Colors.white,
        title: Text(
          'تحديث حالة البلاغ',
          style: TextStyle(color: _darkModeEnabled ? Colors.white : Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: newStatus,
              decoration: InputDecoration(
                labelText: 'الحالة الجديدة',
                labelStyle: TextStyle(color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[700]),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: _darkModeEnabled ? Colors.grey[800] : Colors.grey[100],
              ),
              items: ['قيد المعالجة', 'معلقة', 'تم الحل']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(
                          status,
                          style: TextStyle(color: _darkModeEnabled ? Colors.white : Colors.black),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                newStatus = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: _darkModeEnabled ? Colors.grey[400] : Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // تحديث حالة البلاغ
              setState(() {
                final index = _reportsData.indexWhere((r) => r['id'] == report['id']);
                if (index != -1) {
                  _reportsData[index]['status'] = newStatus;
                  _reportsData[index]['statusColor'] = _getStatusColor(newStatus);
                }
              });
              Navigator.pop(context);
              _showSuccessMessage('تم تحديث الحالة بنجاح');
            },
            child: const Text('تحديث'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'قيد المعالجة':
        return Colors.orange;
      case 'معلقة':
        return Colors.yellow;
      case 'تم الحل':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showFiltersDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _darkModeEnabled ? Colors.grey[900] : Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'تصفية البلاغات',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: _darkModeEnabled ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'الأولوية:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _darkModeEnabled ? Colors.white : Colors.black,
              ),
            ),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChipOption('الكل', _selectedPriority == 'الكل', () {
                  setState(() => _selectedPriority = 'الكل');
                  Navigator.pop(context);
                }),
                _buildFilterChipOption('عالية', _selectedPriority == 'عالية', () {
                  setState(() => _selectedPriority = 'عالية');
                  Navigator.pop(context);
                }),
                _buildFilterChipOption('متوسطة', _selectedPriority == 'متوسطة', () {
                  setState(() => _selectedPriority = 'متوسطة');
                  Navigator.pop(context);
                }),
                _buildFilterChipOption('منخفضة', _selectedPriority == 'منخفضة', () {
                  setState(() => _selectedPriority = 'منخفضة');
                  Navigator.pop(context);
                }),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'الحالة:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _darkModeEnabled ? Colors.white : Colors.black,
              ),
            ),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChipOption('الكل', _selectedStatus == 'الكل', () {
                  setState(() => _selectedStatus = 'الكل');
                  Navigator.pop(context);
                }),
                _buildFilterChipOption('قيد المعالجة', _selectedStatus == 'قيد المعالجة', () {
                  setState(() => _selectedStatus = 'قيد المعالجة');
                  Navigator.pop(context);
                }),
                _buildFilterChipOption('معلقة', _selectedStatus == 'معلقة', () {
                  setState(() => _selectedStatus = 'معلقة');
                  Navigator.pop(context);
                }),
                _buildFilterChipOption('تم الحل', _selectedStatus == 'تم الحل', () {
                  setState(() => _selectedStatus = 'تم الحل');
                  Navigator.pop(context);
                }),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedPriority = 'الكل';
                  _selectedStatus = 'الكل';
                });
                Navigator.pop(context);
              },
              child: const Text('إعادة التعيين'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChipOption(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : (_darkModeEnabled ? Colors.grey[300] : Colors.grey[700]),
        ),
      ),
      selected: selected,
      onSelected: (value) => onTap(),
      selectedColor: _primaryColor,
      backgroundColor: _darkModeEnabled ? Colors.grey[800] : Colors.grey[200],
    );
  }

  void _showSupervisorReportFiltersDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _darkModeEnabled ? Colors.grey[900] : Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'تصفية التقارير',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: _darkModeEnabled ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'نوع التقرير:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _darkModeEnabled ? Colors.white : Colors.black,
              ),
            ),
            Wrap(
              spacing: 8,
              children: [
                _buildReportFilterChipOption('الكل', _selectedReportType == 'الكل', () {
                  setState(() => _selectedReportType = 'الكل');
                  Navigator.pop(context);
                }),
                _buildReportFilterChipOption('مستلمة', _selectedReportType == 'مستلمة', () {
                  setState(() => _selectedReportType = 'مستلمة');
                  Navigator.pop(context);
                }),
                _buildReportFilterChipOption('مرسلة', _selectedReportType == 'مرسلة', () {
                  setState(() => _selectedReportType = 'مرسلة');
                  Navigator.pop(context);
                }),
                _buildReportFilterChipOption('طلبات التقارير', _selectedReportType == 'طلبات', () {
                  setState(() => _selectedReportType = 'طلبات');
                  Navigator.pop(context);
                }),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() => _selectedReportType = 'الكل');
                Navigator.pop(context);
              },
              child: const Text('إعادة التعيين'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportFilterChipOption(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : (_darkModeEnabled ? Colors.grey[300] : Colors.grey[700]),
        ),
      ),
      selected: selected,
      onSelected: (value) => onTap(),
      selectedColor: _primaryColor,
      backgroundColor: _darkModeEnabled ? Colors.grey[800] : Colors.grey[200],
    );
  }

  void _viewReportDetails(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _darkModeEnabled ? Colors.grey[900] : Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report['title'] as String,
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: _darkModeEnabled ? Colors.white : Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: _darkModeEnabled ? Colors.white : Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              report['description'] as String,
              style: TextStyle(
                fontSize: 14, 
                height: 1.5,
                color: _darkModeEnabled ? Colors.grey[300] : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailItem('المرسل:', report['sender'] as String),
            _buildDetailItem('المستلم:', report['receiver'] as String),
            _buildDetailItem('التاريخ:', report['date'] as String),
            _buildDetailItem('الحالة:', report['status'] as String),
            _buildDetailItem('النوع:', report['type'] as String),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 13,
              color: _darkModeEnabled ? Colors.grey[300] : Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                color: _darkModeEnabled ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      )
    );
  }

  void _takeActionOnReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _darkModeEnabled ? Colors.grey[900] : Colors.white,
        title: Text(
          'اتخاذ إجراء',
          style: TextStyle(color: _darkModeEnabled ? Colors.white : Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow, size: 40, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'سيتم اتخاذ الإجراء على التقرير',
              style: TextStyle(color: _darkModeEnabled ? Colors.grey[300] : Colors.black),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: _darkModeEnabled ? Colors.grey[400] : Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('تم اتخاذ الإجراء');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _replyToReport(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _darkModeEnabled ? Colors.grey[900] : Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'الرد على التقرير',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: _darkModeEnabled ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'اكتب ردك هنا...',
                labelStyle: TextStyle(color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[700]),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: _darkModeEnabled ? Colors.grey[800] : Colors.grey[100],
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showSuccessMessage('تم إرسال الرد');
                    },
                    child: const Text('إرسال'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestReportDialog(BuildContext context) {
    // إعادة تعيين البيانات
    _selectedEmployeeId = '';
    _selectedReportTypeForRequest = 'تقرير يومي';
    _selectedPriorityForRequest = 'متوسطة';
    _notesController.clear();
    
    // تعيين القيم الافتراضية للتاريخ إذا كانت فارغة
    if (_selectedDay == null) _selectedDay = DateTime.now().day.toString();
    if (_selectedMonth == null) _selectedMonth = _months[DateTime.now().month - 1];
    if (_selectedYear == null) _selectedYear = DateTime.now().year.toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _darkModeEnabled ? Colors.grey[900] : Colors.white,
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'طلب تقرير جديد',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: _darkModeEnabled ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              
              // اختيار الموظف
              Text(
                'اختر الموظف:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _darkModeEnabled ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'اختر الموظف',
                  hintStyle: TextStyle(color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[700]),
                  filled: true,
                  fillColor: _darkModeEnabled ? Colors.grey[800] : Colors.grey[100],
                ),
                value: _selectedEmployeeId.isNotEmpty ? _selectedEmployeeId : null,
                items: _employees.map((employee) {
                  return DropdownMenuItem(
                    value: employee['id'] as String,
                    child: Text(
                      employee['name'] as String,
                      style: TextStyle(color: _darkModeEnabled ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEmployeeId = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // نوع التقرير
              Text(
                'نوع التقرير:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _darkModeEnabled ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'اختر نوع التقرير',
                  hintStyle: TextStyle(color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[700]),
                  filled: true,
                  fillColor: _darkModeEnabled ? Colors.grey[800] : Colors.grey[100],
                ),
                value: _selectedReportTypeForRequest,
                items: ['تقرير يومي', 'تقرير أسبوعي', 'تقرير شهري']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(color: _darkModeEnabled ? Colors.white : Colors.black),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedReportTypeForRequest = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // اختيار اليوم
              Text(
                'اختر اليوم المطلوب:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _darkModeEnabled ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              
              // زر اختيار التاريخ الجديد
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _showDatePickerScreen = true;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: _darkModeEnabled ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: _primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _getSelectedDateString(),
                          style: TextStyle(
                            color: _darkModeEnabled ? Colors.grey[300] : Colors.grey[800],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey[500],
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              
              // عرض تفاصيل التاريخ المختار
              if (_selectedDay != null && _selectedMonth != null && _selectedYear != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _darkModeEnabled ? Colors.grey[800] : _primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _primaryColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'التاريخ المختار:',
                            style: TextStyle(
                              fontSize: 12,
                              color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          Text(
                            _getSelectedDateString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => _clearSelectedDate(),
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              
              // الأولوية
              Text(
                'الأولوية:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _darkModeEnabled ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'اختر الأولوية',
                  hintStyle: TextStyle(color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[700]),
                  filled: true,
                  fillColor: _darkModeEnabled ? Colors.grey[800] : Colors.grey[100],
                ),
                value: _selectedPriorityForRequest,
                items: ['عالية', 'متوسطة', 'منخفضة']
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(
                            p,
                            style: TextStyle(color: _darkModeEnabled ? Colors.white : Colors.black),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriorityForRequest = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // ملاحظات
              Text(
                'ملاحظات:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _darkModeEnabled ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'أضف ملاحظات إضافية...',
                  hintStyle: TextStyle(color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[700]),
                  filled: true,
                  fillColor: _darkModeEnabled ? Colors.grey[800] : Colors.grey[100],
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 20),
              
              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedEmployeeId.isEmpty) {
                          _showErrorMessage('يرجى اختيار الموظف');
                          return;
                        }
                        
                        // التحقق من اختيار التاريخ
                        if (_selectedDay == null || _selectedMonth == null || _selectedYear == null) {
                          _showErrorMessage('يرجى اختيار اليوم');
                          return;
                        }
                        
                        _sendReportRequest();
                        Navigator.pop(context);
                      },
                      child: const Text('إرسال الطلب'),
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

  // دالة للحصول على نص التاريخ المختار
  String _getSelectedDateString() {
    if (_selectedDay != null && _selectedMonth != null && _selectedYear != null) {
      return '$_selectedDay $_selectedMonth $_selectedYear';
    }
    return 'انقر لاختيار التاريخ';
  }

  // دالة لمسح التاريخ المختار
  void _clearSelectedDate() {
    setState(() {
      _selectedDay = null;
      _selectedMonth = null;
      _selectedYear = null;
    });
  }

  void _sendReportRequest() {
    final employee = _employees.firstWhere((emp) => emp['id'] == _selectedEmployeeId);
    final now = DateTime.now();
    
    // بناء نص الفترة حسب الاختيار
    String periodText = _getSelectedDateString();
    
    // حساب تاريخ التسليم بناءً على نوع التقرير
    Duration dueDuration = Duration(days: 1); // افتراضي يوم واحد
    if (_selectedReportTypeForRequest.contains('أسبوعي')) {
      dueDuration = Duration(days: 7);
    } else if (_selectedReportTypeForRequest.contains('شهري')) {
      dueDuration = Duration(days: 30);
    }
    
    final dueDate = now.add(dueDuration);
    
    // تحويل التاريخ المختار إلى DateTime
    DateTime? selectedDateTime;
    try {
      int monthIndex = _months.indexOf(_selectedMonth!) + 1;
      selectedDateTime = DateTime(
        int.parse(_selectedYear!),
        monthIndex,
        int.parse(_selectedDay!),
      );
    } catch (e) {
      selectedDateTime = DateTime.now();
    }
    
    final newRequest = {
      'id': 'RR-${_reportRequests.length + 1}',
      'employeeId': _selectedEmployeeId,
      'employeeName': employee['name'] as String,
      'reportType': _selectedReportTypeForRequest,
      'period': periodText,
      'selectedDate': selectedDateTime?.toIso8601String(),
      'selectedDay': _selectedDay,
      'selectedMonth': _selectedMonth,
      'selectedYear': _selectedYear,
      'requestDate': '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      'dueDate': '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}',
      'status': 'معلقة',
      'statusColor': Colors.orange,
      'priority': _selectedPriorityForRequest,
      'notes': _notesController.text,
      'icon': _getReportTypeIcon(_selectedReportTypeForRequest),
      'color': _getReportTypeColor(_selectedReportTypeForRequest),
      'employeeEmail': employee['email'] as String,
      'employeePhone': employee['phone'] as String,
    };
    
    setState(() {
      _reportRequests.insert(0, newRequest);
    });
    
    // إرسال الإشعار والبريد الإلكتروني
    _sendNotificationAndEmail(newRequest, employee);
    
    _showSuccessMessage('تم إرسال طلب التقرير بنجاح');
  }

  void _sendNotificationAndEmail(Map<String, dynamic> request, Map<String, dynamic> employee) {
    // محاكاة إرسال إشعار
    _showSuccessMessage('تم إرسال إشعار إلى ${employee['name']}');
    
    // محاكاة إرسال بريد إلكتروني
    final emailContent = '''
موضوع: طلب تقرير جديد

السيد/ ${employee['name']}
${employee['position']}

تحية طيبة،

نود إعلامكم بأنه تم طلب تقرير جديد من قبل مشرف النظام.

تفاصيل الطلب:
- نوع التقرير: ${request['reportType']}
- الفترة المطلوبة: ${request['period']}
- تاريخ التسليم: ${request['dueDate']}
- الأولوية: ${request['priority']}
- ملاحظات: ${request['notes']}

يرجى العمل على إعداد التقرير وتسليمه في الموعد المحدد.

مع تحياتنا،
مشرف النظام
نظام إدارة النفايات
    ''';
    
    print('=== إرسال بريد إلكتروني ===');
    print('إلى: ${employee['email']}');
    print('المحتوى:\n$emailContent');
    print('========================');
    
    // إضافة إشعار في قائمة الإشعارات
    _addNotificationToEmployee(employee['id'] as String, employee['name'] as String, request);
  }

  void _addNotificationToEmployee(String employeeId, String employeeName, Map<String, dynamic> request) {
    // في تطبيق حقيقي، هنا ستقوم بإرسال إشعار فعلي للموظف
    print('تم إرسال إشعار إلى الموظف: $employeeName');
    print('تفاصيل الطلب: ${request['reportType']} - ${request['period']}');
  }

  IconData _getReportTypeIcon(String type) {
    switch (type) {
      case 'تقرير يومي':
        return Icons.today;
      case 'تقرير أسبوعي':
        return Icons.calendar_view_week;
      case 'تقرير شهري':
        return Icons.calendar_today;
      default:
        return Icons.description;
    }
  }

  Color _getReportTypeColor(String type) {
    switch (type) {
      case 'تقرير يومي':
        return Colors.blue;
      case 'تقرير أسبوعي':
        return Colors.green;
      case 'تقرير شهري':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _viewReportRequestDetails(Map<String, dynamic> request) {
    final employee = _employees.firstWhere((emp) => emp['id'] == request['employeeId']);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _darkModeEnabled ? Colors.grey[900] : Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request['reportType'] as String,
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: _darkModeEnabled ? Colors.white : Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: _darkModeEnabled ? Colors.white : Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // معلومات الموظف
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _darkModeEnabled ? Colors.grey[800] : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: request['color'] as Color,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      employee['icon'] as IconData,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee['name'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _darkModeEnabled ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          employee['position'] as String,
                          style: TextStyle(
                            color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'الهاتف: ${employee['phone']}',
                          style: TextStyle(
                            color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'البريد: ${employee['email']}',
                          style: TextStyle(
                            color: _darkModeEnabled ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildRequestDetailItemLarge('رقم الطلب:', request['id'] as String),
            _buildRequestDetailItemLarge('نوع التقرير:', request['reportType'] as String),
            _buildRequestDetailItemLarge('الفترة المطلوبة:', request['period'] as String),
            
            // إظهار تفاصيل الفترة المحددة
            if (request['selectedDate'] != null)
              _buildRequestDetailItemLarge('التاريخ المحدد:', 
                  '${request['selectedDay']} ${request['selectedMonth']} ${request['selectedYear']}'),
            
            _buildRequestDetailItemLarge('تاريخ الطلب:', request['requestDate'] as String),
            _buildRequestDetailItemLarge('تاريخ التسليم:', request['dueDate'] as String),
            _buildRequestDetailItemLarge('الحالة:', request['status'] as String),
            _buildRequestDetailItemLarge('الأولوية:', request['priority'] as String),
            
            const SizedBox(height: 16),
            
            Text(
              'ملاحظات:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _darkModeEnabled ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _darkModeEnabled ? Colors.grey[800] : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                request['notes'] as String,
                style: TextStyle(
                  fontSize: 14,
                  color: _darkModeEnabled ? Colors.grey[300] : Colors.black,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _editReportRequest(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: request['color'] as Color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'تعديل',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'إغلاق',
                      style: TextStyle(fontSize: 14),
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

  Widget _buildRequestDetailItemLarge(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: _darkModeEnabled ? Colors.grey[300] : Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                color: _darkModeEnabled ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      )
    );
  }

  // دوال محاكاة الإجراءات
  void _sendReminder(Map<String, dynamic> request) {
    // إرسال تذكير للموظف
    _showSuccessMessage('تم إرسال تذكير للموظف: ${request['employeeName']}');
  }
  
  void _editReportRequest(Map<String, dynamic> request) {
    _showSuccessMessage('تعديل طلب التقرير: ${request['id']}');
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

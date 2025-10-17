import 'package:flutter/material.dart';

class ReportingOfficerWasteScreen extends StatefulWidget {
  @override
  _ReportingOfficerWasteScreenState createState() => _ReportingOfficerWasteScreenState();
}

class _ReportingOfficerWasteScreenState extends State<ReportingOfficerWasteScreen> 
    with TickerProviderStateMixin {
  
  late TabController _mainTabController;
  late TabController _wasteTabController;
  late TabController _employeeTabController;
  late TabController _appProblemTabController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  String _selectedProblem = '';
  String _problemDescription = '';
  String _problemImage = '';
  bool _showDetails = false;
  String _selectedReportType = 'اليوم';
  List<dynamic> _filteredReports = [];
  TextEditingController _searchController = TextEditingController();

  // ألوان عالمية متناسقة
  final Color _primaryColor = Color(0xFF2E7D32);
  final Color _secondaryColor = Color(0xFF4CAF50);
  final Color _accentColor = Color(0xFF2196F3);
  final Color _warningColor = Color(0xFFFF9800);
  final Color _dangerColor = Color(0xFFF44336);
  final Color _infoColor = Color(0xFF00BCD4);
  final Color _darkColor = Color(0xFF333333);
  final Color _lightColor = Color(0xFFF5F5F5);

  // بيانات المشاكل لعدم جمع النفايات
  final List<WasteProblem> _wasteProblems = [
    WasteProblem(
      employeeName: 'أحمد محمد',
      employeeId: 'EMP-001',
      problemType: 'عدم جمع النفايات',
      location: 'حي السلام - شارع الملك فهد',
      date: '2024-01-15',
      time: '08:30 ص',
      description: 'لم يتم جمع النفايات من المنطقة المخصصة صباح اليوم رغم مرور موعد الجمع المعتاد. يوجد تراكم كبير للنفايات أمام المنازل.',
      imageAsset: 'assets/waste1.jpg',
      status: 'لم يتم المعالجة',
    ),
    WasteProblem(
      employeeName: 'خالد عبدالله',
      employeeId: 'EMP-002',
      problemType: 'عدم جمع النفايات',
      location: 'حي النزهة - شارع الأمير محمد',
      date: '2024-01-26',
      time: '09:00 ص',
      description: 'لم يتم جمع النفايات من المنطقة رغم مرور الموعد المحدد. يوجد تراكم كبير وقد بدأت الروائح الكريهة تنتشر.',
      imageAsset: 'assets/waste2.jpg',
      status: 'قيد المعالجة',
    ),
    WasteProblem(
      employeeName: 'سعيد علي',
      employeeId: 'EMP-003',
      problemType: 'عدم جمع النفايات',
      location: 'حي الروضة - شارع الخليج',
      date: '2024-01-25',
      time: '08:45 ص',
      description: 'تأخر في جمع النفايات لمدة ساعتين عن الموعد المعتاد. المواطنون يشكون من الانتظار.',
      imageAsset: 'assets/waste3.jpg',
      status: 'تم المعالجة',
    ),
  ];

  // بيانات المشاكل لتسرب من الحاويات
  final List<LeakageProblem> _leakageProblems = [
    LeakageProblem(
      citizenName: 'فاطمة أحمد',
      location: 'حي المصيف - شارع البحيرة',
      area: 'حي المصيف',
      date: '2024-01-16',
      time: '07:30 ص',
      description: 'تسرب شديد من حاوية النفايات أمام المبنى رقم ٤٥. السائل المتسرب ينتشر على الرصيف ويسبب انزلاق للمارة ورائحة كريهة. الحاوية قديمة ومصدئة وتحتاج للاستبدال.',
      imageAsset: 'assets/leakage1.jpg',
      status: 'لم يتم المعالجة',
    ),
    LeakageProblem(
      citizenName: 'نورة أحمد',
      location: 'حي العليا - شارع الملك عبدالله',
      area: 'حي العليا',
      date: '2024-01-27',
      time: '10:00 ص',
      description: 'تسرب مستمر من حاوية النفايات أمام العمارة رقم ١٢. السائل المتسرب يسبب انزلاق للسيارات والمشاة.',
      imageAsset: 'assets/leakage2.jpg',
      status: 'لم يتم المعالجة',
    ),
  ];

  // بيانات المشاكل لروائح كريهة
  final List<OdorProblem> _odorProblems = [
    OdorProblem(
      citizenName: 'سالم علي',
      location: 'حي الخليج - شارع البحيرة',
      area: 'حي الخليج',
      date: '2024-01-17',
      time: '02:30 م',
      description: 'روائح كريهة شديدة تنبعث من حاوية النفايات أمام العمارة رقم ٣٢. الرائحة نفاذة وتسبب إزعاجاً للسكان وخاصة في أوقات المساء. يبدو أن النفايات متراكمة منذ عدة أيام وتحتوي على مواد عضوية متحللة.',
      imageAsset: 'assets/odor1.jpg',
      status: 'لم يتم المعالجة',
    ),
    OdorProblem(
      citizenName: 'عبدالرحمن محمد',
      location: 'حي السلام - شارع الصناعية',
      area: 'حي السلام',
      date: '2024-01-26',
      time: '03:00 م',
      description: 'روائح كريهة شديدة تنبعث من موقع تجميع النفايات. الرائحة تصل إلى المنازل المجاورة وتسبب إزعاجاً للسكان.',
      imageAsset: 'assets/odor2.jpg',
      status: 'قيد المعالجة',
    ),
  ];

  // بيانات المشاكل لحاويات تالفة
  final List<DamagedContainerProblem> _damagedContainerProblems = [
    DamagedContainerProblem(
      citizenName: 'علي سعيد',
      location: 'حي الربيع - شارع النخيل',
      area: 'حي الربيع',
      date: '2024-01-18',
      time: '08:00 ص',
      description: 'حاوية نفايات تالفة بالكامل مع وجود صدأ شديد في القاعدة والجوانب. الغطاء مفقود والحاوية مائلة على جانبها مما يجعلها غير قابلة للاستخدام. تحتاج إلى استبدال فوري.',
      imageAsset: 'assets/damaged1.jpg',
      status: 'لم يتم المعالجة',
    ),
  ];

  // بيانات جديدة لمشاكل تراكم النفايات من المواطنين
  final List<WasteAccumulationProblem> _wasteAccumulationProblems = [
    WasteAccumulationProblem(
      citizenName: 'فهد العتيبي',
      area: 'حي العليا',
      location: 'شارع الملك عبدالعزيز - مقابل المدرسة الثانوية',
      date: '2024-01-20',
      time: '09:15 ص',
      description: 'تراكم كبير للنفايات أمام العمارة رقم ٣٤ منذ ثلاثة أيام. النفايات تشمل بقايا طعام وأكياس بلاستيكية وورق مقوى. أدى هذا التراكم إلى انتشار القوارض والحشرات الطائرة مما يشكل خطراً على صحة السكان خاصة الأطفال.',
      imageAsset: 'assets/accumulation1.jpg',
      status: 'لم يتم المعالجة',
    ),
  ];

  // بيانات جديدة لمشاكل أخرى متنوعة
  final List<OtherProblem> _otherProblems = [
    OtherProblem(
      citizenName: 'سارة عبدالله',
      area: 'حي الروضة',
      location: 'شارع الأمير سلطان - بجوار المركز الصحي',
      date: '2024-01-22',
      time: '10:30 ص',
      description: 'وجود حيوانات ضالة تتغذى على النفايات المتراكمة في المنطقة. هذه الحيوانات تشكل خطراً على الأطفال والمارة وتنقل الأمراض. توجد مجموعة من القطط والكلاب الضالة تتجمع حول حاويات النفايات ليلاً ونهاراً.',
      imageAsset: 'assets/other1.jpg',
      problemType: 'حيوانات ضالة',
      status: 'لم يتم المعالجة',
    ),
  ];

  // بيانات مشاكل موظف الفواتير
  final List<BillingEmployeeProblem> _billingEmployeeProblems = [
    BillingEmployeeProblem(
      citizenName: 'محمد أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'خطأ في فاتورة الشهر الحالي حيث تم احتساب مبلغ ٢٥٠ ريال بدلاً من ١٥٠ ريال. الفاتورة تحتوي على أخطاء في الحساب وتحتاج إلى مراجعة فورية.',
      imageAsset: 'assets/billing1.jpg',
      problemType: 'خطأ في الفاتورة',
      status: 'لم يتم المعالجة',
    ),
  ];

  // بيانات مشاكل موظف النظافة - جديدة
  final List<CleaningEmployeeProblem> _cleaningEmployeeProblems = [
    CleaningEmployeeProblem(
      citizenName: 'علي أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مقابل المسجد',
      date: '2024-01-25',
      time: '08:15 ص',
      description: 'لم يقم موظف النظافة بجمع النفايات من أمام المنزل رغم مرور موعد الجمع المعتاد. النفايات متراكمة منذ يومين وتسبب روائح كريهة وجذب الحشرات.',
      imageAsset: 'assets/cleaning1.jpg',
      problemType: 'عدم جمع النفايات',
      status: 'لم يتم المعالجة',
    ),
  ];

  // بيانات مشاكل تعطيل التطبيق - إضافة جديدة
  final List<AppCrashProblem> _appCrashProblems = [
    AppCrashProblem(
      citizenName: 'محمد أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'التطبيق يتعطل بشكل متكرر عند محاولة الدخول إلى قسم الفواتير. بعد فتح القسم بثوانٍ، يظهر رسالة خطأ ويغلق التطبيق تلقائياً. هذه المشكلة تمنعني من دفع الفاتورة الشهرية.',
      imageAsset: 'assets/app_crash1.jpg',
      problemType: 'تعطيل في التطبيق',
      status: 'لم يتم المعالجة',
    ),
  ];

  // بيانات جديدة لمشاكل الدفع
  final List<PaymentProblem> _paymentProblems = [
    PaymentProblem(
      citizenName: 'أحمد محمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'عند محاولة دفع الفاتورة عبر البطاقة الائتمانية، تظهر رسالة خطأ "عملية الدفع فشلت" رغم أن الرصيد كافي والبطاقة سارية. جربت أكثر من مرة ولكن المشكلة ما زالت مستمرة.',
      imageAsset: 'assets/payment1.jpg',
      problemType: 'فشل في عملية الدفع',
      status: 'لم يتم المعالجة',
    ),
  ];

  // بيانات جديدة لمشاكل واجهة المستخدم
  final List<UserInterfaceProblem> _userInterfaceProblems = [
    UserInterfaceProblem(
      citizenName: 'محمد أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'واجهة المستخدم غير واضحة وصعبة الاستخدام. الأزرار صغيرة جداً ولا يمكن الضغط عليها بسهولة. الألوان غير متناسقة وتسبب إرهاقاً للعين. النصوص صغيرة الحجم ويصعب قراءتها خاصة لكبار السن.',
      imageAsset: 'assets/ui1.jpg',
      problemType: 'صعوبة في الاستخدام',
      status: 'لم يتم المعالجة',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 4, vsync: this);
    _wasteTabController = TabController(length: 6, vsync: this);
    _employeeTabController = TabController(length: 3, vsync: this);
    _appProblemTabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _filterReports();
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _wasteTabController.dispose();
    _employeeTabController.dispose();
    _appProblemTabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterReports() {
    final now = DateTime.now();
    final searchQuery = _searchController.text.toLowerCase();
    
    setState(() {
      List<dynamic> allProblems = _getAllProblems();
      
      if (_selectedReportType == 'اليوم') {
        _filteredReports = allProblems.where((problem) {
          final problemDate = DateTime.parse(problem.date);
          final matchesDate = problemDate.year == now.year &&
                 problemDate.month == now.month &&
                 problemDate.day == now.day;
          final matchesSearch = _problemMatchesSearch(problem, searchQuery);
          return matchesDate && matchesSearch;
        }).toList();
      } else if (_selectedReportType == 'الأسبوع') {
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        _filteredReports = allProblems.where((problem) {
          final problemDate = DateTime.parse(problem.date);
          final matchesDate = problemDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
                 problemDate.isBefore(now.add(Duration(days: 1)));
          final matchesSearch = _problemMatchesSearch(problem, searchQuery);
          return matchesDate && matchesSearch;
        }).toList();
      } else if (_selectedReportType == 'الشهر') {
        _filteredReports = allProblems.where((problem) {
          final problemDate = DateTime.parse(problem.date);
          final matchesDate = problemDate.year == now.year &&
                 problemDate.month == now.month;
          final matchesSearch = _problemMatchesSearch(problem, searchQuery);
          return matchesDate && matchesSearch;
        }).toList();
      }
    });
  }

  bool _problemMatchesSearch(dynamic problem, String searchQuery) {
    if (searchQuery.isEmpty) return true;
    
    String name = '';
    String type = '';
    String location = '';
    String date = '';
    String time = '';
    String status = '';

    if (problem is WasteProblem) {
      name = problem.employeeName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is LeakageProblem) {
      name = problem.citizenName;
      type = 'تسرب من الحاويات';
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is OdorProblem) {
      name = problem.citizenName;
      type = 'روائح كريهة';
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is DamagedContainerProblem) {
      name = problem.citizenName;
      type = 'حاويات تالفة';
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is WasteAccumulationProblem) {
      name = problem.citizenName;
      type = 'تراكم النفايات';
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is OtherProblem) {
      name = problem.citizenName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is BillingEmployeeProblem) {
      name = problem.citizenName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is CleaningEmployeeProblem) {
      name = problem.citizenName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is AppCrashProblem) {
      name = problem.citizenName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is PaymentProblem) {
      name = problem.citizenName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is UserInterfaceProblem) {
      name = problem.citizenName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    }

    return name.toLowerCase().contains(searchQuery) ||
           type.toLowerCase().contains(searchQuery) ||
           location.toLowerCase().contains(searchQuery) ||
           date.contains(searchQuery) ||
           time.contains(searchQuery) ||
           status.toLowerCase().contains(searchQuery);
  }

  List<dynamic> _getAllProblems() {
    return [
      ..._wasteProblems,
      ..._leakageProblems,
      ..._odorProblems,
      ..._damagedContainerProblems,
      ..._wasteAccumulationProblems,
      ..._otherProblems,
      ..._billingEmployeeProblems,
      ..._cleaningEmployeeProblems,
      ..._appCrashProblems,
      ..._paymentProblems,
      ..._userInterfaceProblems,
    ];
  }

  // إحصائيات مفصلة عن البلاغات
  Map<String, dynamic> _getDetailedStatistics() {
    final allProblems = _getAllProblems();
    
    return {
      'total': allProblems.length,
      'not_processed': allProblems.where((p) => p.status == 'لم يتم المعالجة').length,
      'in_progress': allProblems.where((p) => p.status == 'قيد المعالجة').length,
      'processed': allProblems.where((p) => p.status == 'تم المعالجة').length,
      
      // إحصائيات حسب النوع
      'by_type': {
        'عدم جمع النفايات': allProblems.where((p) => p is WasteProblem).length,
        'تسرب من الحاويات': allProblems.where((p) => p is LeakageProblem).length,
        'روائح كريهة': allProblems.where((p) => p is OdorProblem).length,
        'حاويات تالفة': allProblems.where((p) => p is DamagedContainerProblem).length,
        'تراكم النفايات': allProblems.where((p) => p is WasteAccumulationProblem).length,
        'موظف الفواتير': allProblems.where((p) => p is BillingEmployeeProblem).length,
        'موظف النظافة': allProblems.where((p) => p is CleaningEmployeeProblem).length,
        'مشاكل التطبيق': allProblems.where((p) => p is AppCrashProblem || p is PaymentProblem || p is UserInterfaceProblem).length,
      },
      
      // إحصائيات حسب المنطقة
      'by_area': _getProblemsByArea(),
      
      // إحصائيات حسب التاريخ
      'by_date': _getProblemsByDate(),
    };
  }

  // تجميع البلاغات حسب المنطقة
  Map<String, int> _getProblemsByArea() {
    final allProblems = _getAllProblems();
    Map<String, int> areaCount = {};
    
    for (var problem in allProblems) {
      String area = '';
      
      if (problem is WasteProblem) area = _extractAreaFromLocation(problem.location);
      else if (problem is LeakageProblem) area = problem.area;
      else if (problem is OdorProblem) area = problem.area;
      else if (problem is DamagedContainerProblem) area = problem.area;
      else if (problem is WasteAccumulationProblem) area = problem.area;
      else if (problem is OtherProblem) area = problem.area;
      else if (problem is BillingEmployeeProblem) area = problem.area;
      else if (problem is CleaningEmployeeProblem) area = problem.area;
      else if (problem is AppCrashProblem) area = problem.area;
      else if (problem is PaymentProblem) area = problem.area;
      else if (problem is UserInterfaceProblem) area = problem.area;
      
      areaCount[area] = (areaCount[area] ?? 0) + 1;
    }
    
    return areaCount;
  }

  // استخراج اسم المنطقة من الموقع
  String _extractAreaFromLocation(String location) {
    if (location.contains('حي السلام')) return 'حي السلام';
    if (location.contains('حي المصيف')) return 'حي المصيف';
    if (location.contains('حي الخليج')) return 'حي الخليج';
    if (location.contains('حي الربيع')) return 'حي الربيع';
    if (location.contains('حي العليا')) return 'حي العليا';
    if (location.contains('حي الروضة')) return 'حي الروضة';
    if (location.contains('حي النزهة')) return 'حي النزهة';
    return 'مناطق أخرى';
  }

  // تجميع البلاغات حسب التاريخ
  Map<String, int> _getProblemsByDate() {
    final allProblems = _getAllProblems();
    Map<String, int> dateCount = {};
    
    for (var problem in allProblems) {
      dateCount[problem.date] = (dateCount[problem.date] ?? 0) + 1;
    }
    
    return dateCount;
  }

  // إنشاء تقرير مفصل
  void _generateDetailedReport() {
    final stats = _getDetailedStatistics();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.analytics, color: _primaryColor),
              SizedBox(width: 8),
              Text('التقرير التفصيلي', style: TextStyle(fontFamily: 'Cairo')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatItem('إجمالي البلاغات', stats['total'].toString(), Icons.report_problem),
                _buildStatItem('لم تتم المعالجة', stats['not_processed'].toString(), Icons.pending_actions),
                _buildStatItem('قيد المعالجة', stats['in_progress'].toString(), Icons.hourglass_bottom),
                _buildStatItem('تمت المعالجة', stats['processed'].toString(), Icons.check_circle),
                
                SizedBox(height: 16),
                Text('التوزيع حسب النوع:', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                ..._buildTypeStats(stats['by_type']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('إغلاق', style: TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: _primaryColor),
      title: Text(title, style: TextStyle(fontFamily: 'Cairo')),
      trailing: Text(value, style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
    );
  }

  List<Widget> _buildTypeStats(Map<String, dynamic> typeStats) {
    return typeStats.entries.map((entry) {
      return ListTile(
        title: Text(entry.key, style: TextStyle(fontFamily: 'Cairo', fontSize: 12)),
        trailing: Text(entry.value.toString(), style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
      );
    }).toList();
  }

  Color _getProblemColor(dynamic problem) {
    if (problem is WasteProblem) return _primaryColor;
    if (problem is LeakageProblem) return _warningColor;
    if (problem is OdorProblem) return _dangerColor;
    if (problem is DamagedContainerProblem) return _infoColor;
    if (problem is WasteAccumulationProblem) return _darkColor;
    if (problem is OtherProblem) return _secondaryColor;
    if (problem is BillingEmployeeProblem) return _accentColor;
    if (problem is CleaningEmployeeProblem) return _warningColor;
    if (problem is AppCrashProblem) return _dangerColor;
    if (problem is PaymentProblem) return _primaryColor;
    if (problem is UserInterfaceProblem) return _infoColor;
    return _darkColor;
  }

  IconData _getProblemIcon(dynamic problem) {
    if (problem is WasteProblem) return Icons.delete;
    if (problem is LeakageProblem) return Icons.water_damage;
    if (problem is OdorProblem) return Icons.air;
    if (problem is DamagedContainerProblem) return Icons.breakfast_dining;
    if (problem is WasteAccumulationProblem) return Icons.clean_hands;
    if (problem is OtherProblem) return Icons.more_horiz;
    if (problem is BillingEmployeeProblem) return Icons.receipt_long;
    if (problem is CleaningEmployeeProblem) return Icons.cleaning_services;
    if (problem is AppCrashProblem) return Icons.error_outline;
    if (problem is PaymentProblem) return Icons.payment;
    if (problem is UserInterfaceProblem) return Icons.phone_iphone;
    return Icons.report_problem;
  }

  void _showProblemDetails(WasteProblem problem) {
    setState(() {
      _selectedProblem = problem.problemType;
      _problemDescription = _buildProblemDetailsText(problem);
      _problemImage = problem.imageAsset;
      _showDetails = true;
    });
    _animationController.forward();
  }

  void _showLeakageProblemDetails(LeakageProblem problem) {
    setState(() {
      _selectedProblem = 'تسرب من الحاويات';
      _problemDescription = _buildLeakageProblemDetailsText(problem);
      _problemImage = problem.imageAsset;
      _showDetails = true;
    });
    _animationController.forward();
  }

  void _showOdorProblemDetails(OdorProblem problem) {
    setState(() {
      _selectedProblem = 'روائح كريهة';
      _problemDescription = _buildOdorProblemDetailsText(problem);
      _problemImage = problem.imageAsset;
      _showDetails = true;
    });
    _animationController.forward();
  }

  void _showDamagedContainerProblemDetails(DamagedContainerProblem problem) {
    setState(() {
      _selectedProblem = 'حاويات تالفة';
      _problemDescription = _buildDamagedContainerProblemDetailsText(problem);
      _problemImage = problem.imageAsset;
      _showDetails = true;
    });
    _animationController.forward();
  }

  void _showWasteAccumulationProblemDetails(WasteAccumulationProblem problem) {
    setState(() {
      _selectedProblem = 'تراكم النفايات';
      _problemDescription = _buildWasteAccumulationProblemDetailsText(problem);
      _problemImage = problem.imageAsset;
      _showDetails = true;
    });
    _animationController.forward();
  }

  void _showOtherProblemDetails(OtherProblem problem) {
    setState(() {
      _selectedProblem = problem.problemType;
      _problemDescription = _buildOtherProblemDetailsText(problem);
      _problemImage = problem.imageAsset;
      _showDetails = true;
    });
    _animationController.forward();
  }

  void _showBillingEmployeeProblemDetails(BillingEmployeeProblem problem) {
    setState(() {
      _selectedProblem = problem.problemType;
      _problemDescription = _buildBillingEmployeeProblemDetailsText(problem);
      _problemImage = problem.imageAsset;
      _showDetails = true;
    });
    _animationController.forward();
  }

  void _showCleaningEmployeeProblemDetails(CleaningEmployeeProblem problem) {
    setState(() {
      _selectedProblem = problem.problemType;
      _problemDescription = _buildCleaningEmployeeProblemDetailsText(problem);
      _problemImage = problem.imageAsset;
      _showDetails = true;
    });
    _animationController.forward();
  }

  void _showAppCrashProblemDetails(AppCrashProblem problem) {
    setState(() {
      _selectedProblem = problem.problemType;
      _problemDescription = _buildAppCrashProblemDetailsText(problem);
      _problemImage = problem.imageAsset;
      _showDetails = true;
    });
    _animationController.forward();
  }

  void _showPaymentProblemDetails(PaymentProblem problem) {
    setState(() {
      _selectedProblem = problem.problemType;
      _problemDescription = _buildPaymentProblemDetailsText(problem);
      _problemImage = problem.imageAsset;
      _showDetails = true;
    });
    _animationController.forward();
  }

  void _showUserInterfaceProblemDetails(UserInterfaceProblem problem) {
    setState(() {
      _selectedProblem = problem.problemType;
      _problemDescription = _buildUserInterfaceProblemDetailsText(problem);
      _problemImage = problem.imageAsset;
      _showDetails = true;
    });
    _animationController.forward();
  }

  String _buildProblemDetailsText(WasteProblem problem) {
    return '''
الموظف: ${problem.employeeName}
رقم الموظف: ${problem.employeeId}
نوع المشكلة: ${problem.problemType}
المكان: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
  }

  String _buildLeakageProblemDetailsText(LeakageProblem problem) {
    return '''
المبلغ: ${problem.citizenName}
المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
  }

  String _buildOdorProblemDetailsText(OdorProblem problem) {
    return '''
المبلغ: ${problem.citizenName}
المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
  }

  String _buildDamagedContainerProblemDetailsText(DamagedContainerProblem problem) {
    return '''
المبلغ: ${problem.citizenName}
المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
  }

  String _buildWasteAccumulationProblemDetailsText(WasteAccumulationProblem problem) {
    return '''
المبلغ: ${problem.citizenName}
المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
  }

  String _buildOtherProblemDetailsText(OtherProblem problem) {
    return '''
المبلغ: ${problem.citizenName}
المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
نوع المشكلة: ${problem.problemType}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
  }

  String _buildBillingEmployeeProblemDetailsText(BillingEmployeeProblem problem) {
    return '''
المبلغ: ${problem.citizenName}
المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
نوع المشكلة: ${problem.problemType}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
  }

  String _buildCleaningEmployeeProblemDetailsText(CleaningEmployeeProblem problem) {
    return '''
المبلغ: ${problem.citizenName}
المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
نوع المشكلة: ${problem.problemType}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
  }

  String _buildAppCrashProblemDetailsText(AppCrashProblem problem) {
    return '''
المبلغ: ${problem.citizenName}
المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
نوع المشكلة: ${problem.problemType}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
  }

  String _buildPaymentProblemDetailsText(PaymentProblem problem) {
    return '''
المبلغ: ${problem.citizenName}
المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
نوع المشكلة: ${problem.problemType}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
  }

  String _buildUserInterfaceProblemDetailsText(UserInterfaceProblem problem) {
    return '''
المبلغ: ${problem.citizenName}
المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
نوع المشكلة: ${problem.problemType}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
  }

  void _hideDetails() {
    _animationController.reverse().then((value) {
      setState(() {
        _showDetails = false;
      });
    });
  }

  void _showShareDialog(WasteProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: _primaryColor),
              SizedBox(width: 8),
              Text(
                'مشاركة البلاغ',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سيتم مشاركة هذا البلاغ مع:',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _primaryColor,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مسؤول جدولة النظافة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                          Text(
                            'Cleaning Schedule Manager',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'تأكيد مشاركة بلاغ ${problem.problemType}؟',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تأكيد المشاركة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showShareLeakageDialog(LeakageProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: _warningColor),
              SizedBox(width: 8),
              Text(
                'مشاركة بلاغ التسرب',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: _warningColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سيتم مشاركة هذا البلاغ مع:',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _warningColor,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مسؤول جدولة النفايات',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: _warningColor,
                            ),
                          ),
                          Text(
                            'Waste Schedule Manager',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'تأكيد مشاركة بلاغ تسرب من الحاويات؟',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _warningColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تأكيد المشاركة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showShareOdorDialog(OdorProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: _dangerColor),
              SizedBox(width: 8),
              Text(
                'مشاركة بلاغ الروائح',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: _dangerColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سيتم مشاركة هذا البلاغ مع:',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _dangerColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _dangerColor,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مسؤول جدولة النفايات',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: _dangerColor,
                            ),
                          ),
                          Text(
                            'Waste Schedule Manager',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'تأكيد مشاركة بلاغ روائح كريهة؟',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _dangerColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تأكيد المشاركة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showShareDamagedContainerDialog(DamagedContainerProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: _infoColor),
              SizedBox(width: 8),
              Text(
                'مشاركة بلاغ الحاويات التالفة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: _infoColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سيتم مشاركة هذا البلاغ مع:',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _infoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _infoColor,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مسؤول جدولة النفايات',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: _infoColor,
                            ),
                          ),
                          Text(
                            'Waste Schedule Manager',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'تأكيد مشاركة بلاغ حاويات تالفة؟',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _infoColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تأكيد المشاركة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showShareWasteAccumulationDialog(WasteAccumulationProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: _darkColor),
              SizedBox(width: 8),
              Text(
                'مشاركة بلاغ تراكم النفايات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: _darkColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سيتم مشاركة هذا البلاغ مع:',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _darkColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _darkColor,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مسؤول جدولة النفايات',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: _darkColor,
                            ),
                          ),
                          Text(
                            'Waste Schedule Manager',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'تأكيد مشاركة بلاغ تراكم النفايات؟',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _darkColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تأكيد المشاركة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showShareBillingEmployeeDialog(BillingEmployeeProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: _accentColor),
              SizedBox(width: 8),
              Text(
                'مشاركة بلاغ موظف الفواتير',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: _accentColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سيتم مشاركة هذا البلاغ مع:',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _accentColor,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'فريق المبرمجين',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: _accentColor,
                            ),
                          ),
                          Text(
                            'Development Team',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 8),
              Text(
                'تأكيد مشاركة بلاغ ${problem.problemType}؟',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تأكيد المشاركة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showShareCleaningEmployeeDialog(CleaningEmployeeProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: _warningColor),
              SizedBox(width: 8),
              Text(
                'مشاركة بلاغ موظف النظافة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: _warningColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سيتم مشاركة هذا البلاغ مع:',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _warningColor,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مسؤول جدولة النفايات',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: _warningColor,
                            ),
                          ),
                          Text(
                            'Waste Schedule Manager',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 8),
              Text(
                'تأكيد مشاركة بلاغ ${problem.problemType}؟',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _warningColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تأكيد المشاركة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showShareAppCrashDialog(AppCrashProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: _dangerColor),
              SizedBox(width: 8),
              Text(
                'مشاركة بلاغ تعطيل التطبيق',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: _dangerColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سيتم مشاركة هذا البلاغ مع:',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _dangerColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _dangerColor,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'فريق المبرمجين',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: _dangerColor,
                            ),
                          ),
                          Text(
                            'Development Team',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 8),
              Text(
                'تأكيد مشاركة بلاغ ${problem.problemType}؟',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _dangerColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تأكيد المشاركة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSharePaymentDialog(PaymentProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: _primaryColor),
              SizedBox(width: 8),
              Text(
                'مشاركة بلاغ مشكلة الدفع',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سيتم مشاركة هذا البلاغ مع:',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _primaryColor,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'فريق المبرمجين',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                          Text(
                            'Development Team',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 8),
              Text(
                'تأكيد مشاركة بلاغ ${problem.problemType}؟',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تأكيد المشاركة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showShareUserInterfaceDialog(UserInterfaceProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: _infoColor),
              SizedBox(width: 8),
              Text(
                'مشاركة بلاغ واجهة المستخدم',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: _infoColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سيتم مشاركة هذا البلاغ مع:',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _infoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _infoColor,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'فريق المبرمجين',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: _infoColor,
                            ),
                          ),
                          Text(
                            'Development Team',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 8),
              Text(
                'تأكيد مشاركة بلاغ ${problem.problemType}؟',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _infoColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تأكيد المشاركة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showShareSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: _primaryColor, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'تم مشاركة البلاغ بنجاح',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نظام الإبلاغ عن المشاكل',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: _primaryColor,
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(2),
          ),
        ),
        bottom: TabBar(
          controller: _mainTabController,
          indicatorColor: Colors.white,
          indicatorWeight: 4,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: [
            Tab(
              icon: Icon(Icons.delete_outlined, size: 20),
              text: 'بلاغ عن النفايات',
            ),
            Tab(
              icon: Icon(Icons.people_outline, size: 20),
              text: 'تقصير الموظفين',
            ),
            Tab(
              icon: Icon(Icons.bug_report_outlined, size: 20),
              text: 'مشاكل التطبيق',
            ),
            Tab(
              icon: Icon(Icons.analytics_outlined, size: 20),
              text: 'التقارير',
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _lightColor,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 6),
            Expanded(
              child: Stack(
                children: [
                  TabBarView(
                    controller: _mainTabController,
                    children: [
                      _buildWasteReportSection(),
                      _buildEmployeeReportSection(),
                      _buildAppProblemSection(),
                      _buildReportsSection(),
                    ],
                  ),
                  
                  if (_showDetails)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        child: FadeTransition(
                          opacity: _animation,
                          child: ScaleTransition(
                            scale: _animation,
                            child: Center(
                              child: _buildProblemDetailsCard(),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_infoColor, _accentColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.analytics, size: 40, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'بوابة التقارير الإحصائية',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'تقارير شاملة عن جميع البلاغات والمشاكل',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'فلترة التقارير',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _darkColor,
                  ),
                ),
                SizedBox(height: 12),
                
                TextField(
                  controller: _searchController,
                  onChanged: (value) => _filterReports(),
                  decoration: InputDecoration(
                    hintText: 'ابحث في البلاغات...',
                    hintStyle: TextStyle(fontFamily: 'Cairo'),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                
                SizedBox(height: 12),
                
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['اليوم', 'الأسبوع', 'الشهر'].map((type) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(
                            type,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: _selectedReportType == type 
                                  ? Colors.white 
                                  : _infoColor,
                            ),
                          ),
                          selected: _selectedReportType == type,
                          selectedColor: _infoColor,
                          backgroundColor: Colors.grey[100],
                          onSelected: (selected) {
                            setState(() {
                              _selectedReportType = type;
                              _filterReports();
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إحصائيات سريعة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _darkColor,
                  ),
                ),
                SizedBox(height: 12),
                
                Row(
                  children: [
                    _buildStatCard(
                      'إجمالي البلاغات',
                      _filteredReports.length.toString(),
                      Icons.report_problem,
                      _primaryColor,
                    ),
                    SizedBox(width: 12),
                    _buildStatCard(
                      'لم تتم المعالجة',
                      _filteredReports.where((p) => p.status == 'لم يتم المعالجة').length.toString(),
                      Icons.pending_actions,
                      _dangerColor,
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                Row(
                  children: [
                    _buildStatCard(
                      'قيد المعالجة',
                      _filteredReports.where((p) => p.status == 'قيد المعالجة').length.toString(),
                      Icons.hourglass_bottom,
                      _warningColor,
                    ),
                    SizedBox(width: 12),
                    _buildStatCard(
                      'تمت المعالجة',
                      _filteredReports.where((p) => p.status == 'تم المعالجة').length.toString(),
                      Icons.check_circle,
                      _secondaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          // قسم التحليلات المتقدمة
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.analytics, color: _infoColor),
                    SizedBox(width: 8),
                    Text(
                      'تحليلات متقدمة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _darkColor,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.refresh, color: _infoColor),
                      onPressed: _filterReports,
                      tooltip: 'تحديث البيانات',
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // مخطط بياني مبسط للإحصائيات
                _buildStatisticsChart(),
                
                SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _generateDetailedReport,
                        icon: Icon(Icons.analytics, size: 20),
                        label: Text(
                          'التقرير التفصيلي',
                          style: TextStyle(fontFamily: 'Cairo'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _infoColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showExportDialog();
                        },
                        icon: Icon(Icons.download, size: 20),
                        label: Text(
                          'تصدير البيانات',
                          style: TextStyle(fontFamily: 'Cairo'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.list_alt, color: _infoColor),
                    SizedBox(width: 8),
                    Text(
                      'التقرير التفصيلي',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _darkColor,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '${_filteredReports.length} بلاغ',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: _infoColor,
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                if (_filteredReports.isEmpty)
                  Container(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.inbox, size: 60, color: Colors.grey.shade300),
                        SizedBox(height: 12),
                        Text(
                          'لا توجد بلاغات',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'لم يتم العثور على بلاغات تطابق معايير البحث',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ..._filteredReports.map((problem) {
                    return _buildReportListItem(problem);
                  }).toList(),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showExportDialog();
                    },
                    icon: Icon(Icons.download),
                    label: Text(
                      'تصدير التقرير',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showShareReportDialog();
                    },
                    icon: Icon(Icons.share),
                    label: Text(
                      'مشاركة',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatisticsChart() {
    final stats = _getDetailedStatistics();
    final typeStats = stats['by_type'] as Map<String, dynamic>;
    
    // حساب المجموع الكلي للبلاغات
    int total = 0;
    typeStats.forEach((key, value) {
      total += value as int;
    });
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'توزيع البلاغات حسب النوع:',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: _darkColor,
            ),
          ),
          SizedBox(height: 12),
          ...typeStats.entries.map((entry) {
            return _buildChartRow(entry.key, entry.value as int, total);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildChartRow(String type, int count, int total) {
    double percentage = total > 0 ? (count / total) * 100 : 0;
    Color color = _getColorForType(type);
    
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                type,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: _darkColor,
                ),
              ),
            ),
            Text(
              '$count',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _darkColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'عدم جمع النفايات': return _primaryColor;
      case 'تسرب من الحاويات': return _warningColor;
      case 'روائح كريهة': return _dangerColor;
      case 'حاويات تالفة': return _infoColor;
      case 'تراكم النفايات': return _darkColor;
      case 'موظف الفواتير': return _accentColor;
      case 'موظف النظافة': return _warningColor;
      case 'مشاكل التطبيق': return _secondaryColor;
      default: return Colors.grey;
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportListItem(dynamic problem) {
    Color statusColor = Colors.grey;
    if (problem.status == 'لم يتم المعالجة') {
      statusColor = _dangerColor;
    } else if (problem.status == 'قيد المعالجة') {
      statusColor = _warningColor;
    } else if (problem.status == 'تم المعالجة') {
      statusColor = _primaryColor;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getProblemColor(problem).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getProblemIcon(problem),
              color: _getProblemColor(problem),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getProblemTitle(problem),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _darkColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _getProblemSubtitle(problem),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      '${problem.date} - ${problem.time}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              problem.status,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getProblemTitle(dynamic problem) {
    if (problem is WasteProblem) return problem.employeeName;
    if (problem is LeakageProblem) return problem.citizenName;
    if (problem is OdorProblem) return problem.citizenName;
    if (problem is DamagedContainerProblem) return problem.citizenName;
    if (problem is WasteAccumulationProblem) return problem.citizenName;
    if (problem is OtherProblem) return problem.citizenName;
    if (problem is BillingEmployeeProblem) return problem.citizenName;
    if (problem is CleaningEmployeeProblem) return problem.citizenName;
    if (problem is AppCrashProblem) return problem.citizenName;
    if (problem is PaymentProblem) return problem.citizenName;
    if (problem is UserInterfaceProblem) return problem.citizenName;
    return 'بلاغ';
  }

  String _getProblemSubtitle(dynamic problem) {
    if (problem is WasteProblem) return problem.problemType;
    if (problem is LeakageProblem) return 'تسرب من الحاويات';
    if (problem is OdorProblem) return 'روائح كريهة';
    if (problem is DamagedContainerProblem) return 'حاويات تالفة';
    if (problem is WasteAccumulationProblem) return 'تراكم النفايات';
    if (problem is OtherProblem) return problem.problemType;
    if (problem is BillingEmployeeProblem) return problem.problemType;
    if (problem is CleaningEmployeeProblem) return problem.problemType;
    if (problem is AppCrashProblem) return problem.problemType;
    if (problem is PaymentProblem) return problem.problemType;
    if (problem is UserInterfaceProblem) return problem.problemType;
    return 'مشكلة';
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.download, color: _primaryColor),
              SizedBox(width: 8),
              Text(
                'تصدير التقرير',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختر صيغة التصدير:',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              _buildExportOption('PDF', Icons.picture_as_pdf, _dangerColor),
              SizedBox(height: 8),
              _buildExportOption('Excel', Icons.table_chart, _secondaryColor),
              SizedBox(height: 8),
              _buildExportOption('Word', Icons.description, _accentColor),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showExportSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تأكيد التصدير',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExportOption(String title, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16, color: color),
        ],
      ),
    );
  }

  void _showShareReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: _accentColor),
              SizedBox(width: 8),
              Text(
                'مشاركة التقرير',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: _accentColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختر طريقة المشاركة:',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              _buildShareOption('البريد الإلكتروني', Icons.email, _infoColor),
              SizedBox(height: 8),
              _buildShareOption('الواتساب', Icons.phone, _secondaryColor),
              SizedBox(height: 8),
              _buildShareOption('التليجرام', Icons.send, _accentColor),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تأكيد المشاركة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShareOption(String title, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16, color: color),
        ],
      ),
    );
  }

  void _showExportSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: _primaryColor, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'تم تصدير التقرير بنجاح',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // باقي دوال الواجهات (نفس الكود السابق)
  Widget _buildWasteReportSection() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _wasteTabController,
            isScrollable: true,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: _primaryColor,
            labelStyle: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
            ),
            tabs: [
              Tab(text: 'عدم جمع النفايات'),
              Tab(text: 'تسرب من الحاويات'),
              Tab(text: 'روائح كريهة'),
              Tab(text: 'حاويات تالفة'),
              Tab(text: 'تراكم النفايات'),
              Tab(text: 'أخرى'),
            ],
          ),
        ),
        
        Expanded(
          child: TabBarView(
            controller: _wasteTabController,
            children: [
              _buildNoCollectionContent(),
              _buildLeakageContent(),
              _buildOdorContent(),
              _buildDamagedContainerContent(),
              _buildWasteAccumulationContent(),
              _buildOtherContent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoCollectionContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.warning_amber, color: _warningColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات عدم جمع النفايات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_wasteProblems.length} بلاغ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _primaryColor,
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _wasteProblems.length,
            itemBuilder: (context, index) {
              final problem = _wasteProblems[index];
              return _buildProblemCard(problem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLeakageContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.water_damage, color: _infoColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات تسرب من الحاويات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _infoColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_leakageProblems.length} بلاغ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _infoColor,
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _leakageProblems.length,
            itemBuilder: (context, index) {
              final problem = _leakageProblems[index];
              return _buildLeakageProblemCard(problem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOdorContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.air, color: _dangerColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات الروائح الكريهة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _dangerColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_odorProblems.length} بلاغ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _dangerColor,
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _odorProblems.length,
            itemBuilder: (context, index) {
              final problem = _odorProblems[index];
              return _buildOdorProblemCard(problem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDamagedContainerContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.breakfast_dining, color: _warningColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات حاويات تالفة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _warningColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_damagedContainerProblems.length} بلاغ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _warningColor,
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _damagedContainerProblems.length,
            itemBuilder: (context, index) {
              final problem = _damagedContainerProblems[index];
              return _buildDamagedContainerProblemCard(problem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWasteAccumulationContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.clean_hands, color: _darkColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات تراكم النفايات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _darkColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_wasteAccumulationProblems.length} بلاغ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _darkColor,
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _wasteAccumulationProblems.length,
            itemBuilder: (context, index) {
              final problem = _wasteAccumulationProblems[index];
              return _buildWasteAccumulationProblemCard(problem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOtherContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.more_horiz, color: _secondaryColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات أخرى متنوعة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _secondaryColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_otherProblems.length} بلاغ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _secondaryColor,
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _otherProblems.length,
            itemBuilder: (context, index) {
              final problem = _otherProblems[index];
              return _buildOtherProblemCard(problem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeReportSection() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _employeeTabController,
            isScrollable: true,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [_accentColor, _infoColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: _accentColor,
            labelStyle: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
            ),
            tabs: [
              Tab(text: 'موظف الفواتير'),
              Tab(text: 'موظف النظافة'),
              Tab(text: 'أخرى'),
            ],
          ),
        ),
        
        Expanded(
          child: TabBarView(
            controller: _employeeTabController,
            children: [
              _buildBillingEmployeeContent(),
              _buildCleaningEmployeeContent(),
              _buildEmptyEmployeeContent(
                'أخرى',
                Icons.more_horiz,
                _secondaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBillingEmployeeContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.receipt_long, color: _accentColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات مشاكل موظف الفواتير',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _accentColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_billingEmployeeProblems.length} بلاغ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _accentColor,
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _billingEmployeeProblems.length,
            itemBuilder: (context, index) {
              final problem = _billingEmployeeProblems[index];
              return _buildBillingEmployeeProblemCard(problem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCleaningEmployeeContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.cleaning_services, color: _warningColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات مشاكل موظف النظافة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _warningColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_cleaningEmployeeProblems.length} بلاغ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _warningColor,
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _cleaningEmployeeProblems.length,
            itemBuilder: (context, index) {
              final problem = _cleaningEmployeeProblems[index];
              return _buildCleaningEmployeeProblemCard(problem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppProblemSection() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _appProblemTabController,
            isScrollable: true,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [_dangerColor, _warningColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: _dangerColor,
            labelStyle: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
            ),
            tabs: [
              Tab(text: 'تعطيل في التطبيق'),
              Tab(text: 'مشكلة في الدفع'),
              Tab(text: 'واجهة المستخدم'),
              Tab(text: 'أخرى'),
            ],
          ),
        ),
        
        Expanded(
          child: TabBarView(
            controller: _appProblemTabController,
            children: [
              _buildAppCrashContent(),
              _buildPaymentProblemContent(),
              _buildUserInterfaceContent(),
              _buildEmptyAppProblemContent(
                'أخرى',
                Icons.more_horiz,
                _secondaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppCrashContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: _dangerColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات تعطيل التطبيق',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _dangerColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_appCrashProblems.length} بلاغ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _dangerColor,
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _appCrashProblems.length,
            itemBuilder: (context, index) {
              final problem = _appCrashProblems[index];
              return _buildAppCrashProblemCard(problem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentProblemContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.payment, color: _primaryColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات مشاكل الدفع',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_paymentProblems.length} بلاغ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _primaryColor,
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _paymentProblems.length,
            itemBuilder: (context, index) {
              final problem = _paymentProblems[index];
              return _buildPaymentProblemCard(problem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserInterfaceContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.phone_iphone, color: _infoColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات مشاكل واجهة المستخدم',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _infoColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_userInterfaceProblems.length} بلاغ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _infoColor,
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _userInterfaceProblems.length,
            itemBuilder: (context, index) {
              final problem = _userInterfaceProblems[index];
              return _buildUserInterfaceProblemCard(problem);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProblemCard(WasteProblem problem) {
    return _buildGenericProblemCard(
      problem,
      _primaryColor,
      Icons.person,
      problem.employeeName,
      problem.employeeId,
      () => _showProblemDetails(problem),
      onShare: () => _showShareDialog(problem),
    );
  }

  Widget _buildLeakageProblemCard(LeakageProblem problem) {
    return _buildGenericProblemCard(
      problem,
      _warningColor,
      Icons.person,
      problem.citizenName,
      problem.area,
      () => _showLeakageProblemDetails(problem),
      onShare: () => _showShareLeakageDialog(problem),
    );
  }

  Widget _buildOdorProblemCard(OdorProblem problem) {
    return _buildGenericProblemCard(
      problem,
      _dangerColor,
      Icons.person,
      problem.citizenName,
      problem.area,
      () => _showOdorProblemDetails(problem),
      onShare: () => _showShareOdorDialog(problem),
    );
  }

  Widget _buildDamagedContainerProblemCard(DamagedContainerProblem problem) {
    return _buildGenericProblemCard(
      problem,
      _infoColor,
      Icons.person,
      problem.citizenName,
      problem.area,
      () => _showDamagedContainerProblemDetails(problem),
      onShare: () => _showShareDamagedContainerDialog(problem),
    );
  }

  Widget _buildWasteAccumulationProblemCard(WasteAccumulationProblem problem) {
    return _buildGenericProblemCard(
      problem,
      _darkColor,
      Icons.person,
      problem.citizenName,
      problem.area,
      () => _showWasteAccumulationProblemDetails(problem),
      onShare: () => _showShareWasteAccumulationDialog(problem),
    );
  }

  Widget _buildOtherProblemCard(OtherProblem problem) {
    return _buildGenericProblemCard(
      problem,
      _secondaryColor,
      Icons.person,
      problem.citizenName,
      problem.area,
      () => _showOtherProblemDetails(problem),
      onShare: () => _showShareBillingEmployeeDialog(problem as BillingEmployeeProblem),
      showProblemType: true,
    );
  }

  Widget _buildBillingEmployeeProblemCard(BillingEmployeeProblem problem) {
    return _buildGenericProblemCard(
      problem,
      _accentColor,
      Icons.person,
      problem.citizenName,
      problem.area,
      () => _showBillingEmployeeProblemDetails(problem),
      onShare: () => _showShareBillingEmployeeDialog(problem),
      showProblemType: true,
    );
  }

  Widget _buildCleaningEmployeeProblemCard(CleaningEmployeeProblem problem) {
    return _buildGenericProblemCard(
      problem,
      _warningColor,
      Icons.person,
      problem.citizenName,
      problem.area,
      () => _showCleaningEmployeeProblemDetails(problem),
      onShare: () => _showShareCleaningEmployeeDialog(problem),
      showProblemType: true,
    );
  }

  Widget _buildAppCrashProblemCard(AppCrashProblem problem) {
    return _buildGenericProblemCard(
      problem,
      _dangerColor,
      Icons.person,
      problem.citizenName,
      problem.area,
      () => _showAppCrashProblemDetails(problem),
      onShare: () => _showShareAppCrashDialog(problem),
      showProblemType: true,
    );
  }

  Widget _buildPaymentProblemCard(PaymentProblem problem) {
    return _buildGenericProblemCard(
      problem,
      _primaryColor,
      Icons.person,
      problem.citizenName,
      problem.area,
      () => _showPaymentProblemDetails(problem),
      onShare: () => _showSharePaymentDialog(problem),
      showProblemType: true,
    );
  }

  Widget _buildUserInterfaceProblemCard(UserInterfaceProblem problem) {
    return _buildGenericProblemCard(
      problem,
      _infoColor,
      Icons.person,
      problem.citizenName,
      problem.area,
      () => _showUserInterfaceProblemDetails(problem),
      onShare: () => _showShareUserInterfaceDialog(problem),
      showProblemType: true,
    );
  }

  Widget _buildGenericProblemCard(
    dynamic problem,
    Color color,
    IconData icon,
    String name,
    String subtitle,
    VoidCallback onTap, {
    required VoidCallback onShare,
    bool showProblemType = false,
  }) {
    Color statusColor = Colors.grey;
    if (problem.status == 'لم يتم المعالجة') {
      statusColor = _dangerColor;
    } else if (problem.status == 'قيد المعالجة') {
      statusColor = _warningColor;
    } else if (problem.status == 'تم المعالجة') {
      statusColor = _primaryColor;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.1),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      problem.status,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              
              if (showProblemType && problem is OtherProblem) ...[
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    problem.problemType,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
              
              SizedBox(height: 12),
              
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      problem.location,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 4),
              
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    problem.date,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    problem.time,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              Text(
                problem.description.length > 100 
                    ? '${problem.description.substring(0, 100)}...' 
                    : problem.description,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[800],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 8),
              
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Icon(
                  Icons.photo_camera,
                  size: 40,
                  color: Colors.grey[400],
                ),
              ),

              SizedBox(height: 8),
              // زر المشاركة في الجهة اليسرى
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: onShare,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _accentColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.share,
                          size: 14,
                          color: _accentColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'مشاركة',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: _accentColor,
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
        ),
      ),
    );
  }

  Widget _buildEmptyEmployeeContent(String title, IconData icon, Color color) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: color.withOpacity(0.6),
            ),
            SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'سيتم إضافة محتوى هذا القسم قريباً',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAppProblemContent(String title, IconData icon, Color color) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: color.withOpacity(0.6),
            ),
            SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'سيتم إضافة محتوى هذه المشكلة قريباً',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemDetailsCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.report_problem, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text(
                  _selectedProblem,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.image,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey[200]!,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          _problemDescription,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _hideDetails,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.grey[700],
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _hideDetails();
                            _showSuccessMessage();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: _primaryColor.withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'تأكيد الإبلاغ',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: _primaryColor, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'تم الإبلاغ عن المشكلة بنجاح',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }
}

// نماذج البيانات...
class WasteProblem {
  final String employeeName;
  final String employeeId;
  final String problemType;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;

  WasteProblem({
    required this.employeeName,
    required this.employeeId,
    required this.problemType,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
  });
}

class LeakageProblem {
  final String citizenName;
  final String location;
  final String area;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;

  LeakageProblem({
    required this.citizenName,
    required this.location,
    required this.area,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
  });
}

class OdorProblem {
  final String citizenName;
  final String location;
  final String area;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;

  OdorProblem({
    required this.citizenName,
    required this.location,
    required this.area,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
  });
}

class DamagedContainerProblem {
  final String citizenName;
  final String location;
  final String area;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;

  DamagedContainerProblem({
    required this.citizenName,
    required this.location,
    required this.area,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
  });
}

class WasteAccumulationProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;

  WasteAccumulationProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
  });
}

class OtherProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;

  OtherProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
  });
}

class BillingEmployeeProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;

  BillingEmployeeProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
  });
}

class CleaningEmployeeProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;

  CleaningEmployeeProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
  });
}

class AppCrashProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;

  AppCrashProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
  });
}

class PaymentProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;

  PaymentProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
  });
}

class UserInterfaceProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;

  UserInterfaceProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
  });
} 

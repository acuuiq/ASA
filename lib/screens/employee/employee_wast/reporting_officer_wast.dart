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
    _mainTabController = TabController(length: 3, vsync: this);
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

  // بناء القائمة المنسدلة - مطابقة لتلك الموجودة في المحاسب
  Widget _buildGovernmentDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_primaryColor, Color(0xFF4CAF50)],
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
                  colors: [_primaryColor, Color(0xFF388E3C)],
                ),
              ),
              child: Column(
                children: [
                  // الصورة الرمزية
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.report_problem_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 16),
                  // الاسم والوظيفة
                  Text(
                    "مسؤول الإبلاغات",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "مسؤول - قسم الإبلاغات والمشاكل",
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
                color: Color(0xFFE8F5E9),
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
                    ),
                    
                    // المساعدة والدعم
                    _buildDrawerMenuItem(
                      icon: Icons.help_rounded,
                      title: 'المساعدة والدعم',
                      onTap: () {
                        Navigator.pop(context);
                        _showHelpSupportScreen(context);
                      },
                    ),

                    SizedBox(height: 30),
                    
                    // تسجيل الخروج
                    _buildDrawerMenuItem(
                      icon: Icons.logout_rounded,
                      title: 'تسجيل الخروج',
                      onTap: () {
                        _showLogoutConfirmation(context);
                      },
                      isLogout: true,
                    ),

                    SizedBox(height: 40),
                    
                    // معلومات النسخة - في الأسفل
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Divider(
                            color: Colors.grey[400],
                            height: 1,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'وزارة الكهرباء - نظام الإبلاغات',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'الإصدار 1.0.0',
                            style: TextStyle(
                              color: Colors.grey[600],
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
    bool isLogout = false,
  }) {
    final Color textColor = Colors.black87;
    final Color iconColor = isLogout 
        ? Colors.red 
        : Colors.grey[700]!;

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
                : Colors.grey[100],
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
          color: isLogout ? Colors.red : Colors.grey[500],
          size: 24,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: _dangerColor),
            SizedBox(width: 8),
            Text('تأكيد تسجيل الخروج'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق حوار التأكيد
              // إضافة عملية تسجيل الخروج هنا
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _dangerColor,
              foregroundColor: Colors.white,
            ),
            child: Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  // ========== دوال الإعدادات والمساعدة والدعم ==========

  // شاشة الإعدادات
  void _showSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          darkCardColor: _darkColor,
          cardColor: _lightColor,
          darkTextColor: Colors.white,
          textColor: _darkColor,
          darkTextSecondaryColor: Colors.white70,
          textSecondaryColor: Colors.grey[700]!,
          onSettingsChanged: (settings) {
            // معالجة تغييرات الإعدادات هنا
            print('الإعدادات المحدثة: $settings');
          },
        ),
      ),
    );
  }

  // شاشة المساعدة والدعم
  void _showHelpSupportScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpSupportScreen(
          isDarkMode: false,
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          darkCardColor: _darkColor,
          cardColor: _lightColor,
          darkTextColor: Colors.white,
          textColor: _darkColor,
          darkTextSecondaryColor: Colors.white70,
          textSecondaryColor: Colors.grey[700]!,
        ),
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
        // إضافة زر القائمة المنسدلة على اليمين
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
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
    child: Column(
      children: [
        Icon(Icons.delete_outlined, size: 20),
        SizedBox(height: 4),
        Text('النفايات', style: TextStyle(fontSize: 12)),
      ],
    ),
  ),
  Tab(
    child: Column(
      children: [
        Icon(Icons.people_outlined, size: 20),
        SizedBox(height: 4),
        Text('الموظفين', style: TextStyle(fontSize: 12)),
      ],
    ),
  ),
  Tab(
    child: Column(
      children: [
        Icon(Icons.bug_report_outlined, size: 20),
        SizedBox(height: 4),
        Text('المشاكل', style: TextStyle(fontSize: 12)),
      ],
    ),
  ),
],
        ),
      ),
      // إضافة القائمة المنسدلة
      drawer: _buildGovernmentDrawer(context),
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

  // باقي دوال بناء الواجهات...
  Widget _buildWasteReportSection() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8),
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
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('عدم جمع النفايات'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('تسرب من الحاويات'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('روائح كريهة'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('حاويات تالفة'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('تراكم النفايات'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('أخرى'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _wasteTabController,
            children: [
              _buildWasteContent(),
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

  Widget _buildWasteContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.delete, color: _primaryColor, size: 24),
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
              Icon(Icons.water_damage, color: _warningColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات تسرب من الحاويات',
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
                  '${_leakageProblems.length} بلاغ',
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
              Icon(Icons.breakfast_dining, color: _infoColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات حاويات تالفة',
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
                  '${_damagedContainerProblems.length} بلاغ',
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
          margin: EdgeInsets.only(bottom: 8),
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
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('موظف الفواتير'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('موظف النظافة'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('أخرى'),
                ),
              ),
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
          margin: EdgeInsets.only(bottom: 8),
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
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('تعطيل في التطبيق'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('مشكلة في الدفع'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('واجهة المستخدم'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('أخرى'),
                ),
              ),
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

// ========== شاشة الإعدادات ==========
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
    final Map<String, dynamic> settings = {
      'notificationsEnabled': _notificationsEnabled,
      'soundEnabled': _soundEnabled,
      'vibrationEnabled': _vibrationEnabled,
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
        return AlertDialog(
          backgroundColor: widget.cardColor,
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
              color: widget.textColor,
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
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
              _buildSettingsSection('الإشعارات', Icons.notifications_rounded),
              _buildSettingSwitch(
                'تفعيل الإشعارات',
                'استلام إشعارات حول البلاغات والتحديثات',
                _notificationsEnabled,
                (bool value) => setState(() => _notificationsEnabled = value),
              ),
              _buildSettingSwitch(
                'الصوت',
                'تشغيل صوت للإشعارات الواردة',
                _soundEnabled,
                (bool value) => setState(() => _soundEnabled = value),
              ),
              _buildSettingSwitch(
                'الاهتزاز',
                'اهتزاز الجهاز عند استلام الإشعارات',
                _vibrationEnabled,
                (bool value) => setState(() => _vibrationEnabled = value),
              ),

              SizedBox(height: 24),
              _buildSettingsSection('المظهر', Icons.palette_rounded),
              
              _buildSettingDropdown(
                'اللغة',
                _language,
                _languages,
                (String? value) => setState(() => _language = value!),
              ),
              
              SizedBox(height: 24),
              _buildSettingsSection('الأمان', Icons.security_rounded),
              _buildSettingSwitch(
                'النسخ الاحتياطي التلقائي',
                'نسخ البيانات تلقائياً بشكل دوري',
                _autoBackup,
                (bool value) => setState(() => _autoBackup = value),
              ),
              _buildSettingSwitch(
                'المصادقة البيومترية',
                'استخدام البصمة أو التعرف على الوجه',
                _biometricAuth,
                (bool value) => setState(() => _biometricAuth = value),
              ),
              _buildSettingSwitch(
                'المزامنة التلقائية',
                'مزامنة البيانات مع السحابة تلقائياً',
                _autoSync,
                (bool value) => setState(() => _autoSync = value),
              ),

              SizedBox(height: 24),
              _buildSettingsSection('حول التطبيق', Icons.info_rounded),
              _buildAboutCard(),

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
      ),
    );
  }

  Widget _buildSettingsSection(String title, IconData icon) {
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
              color: widget.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.cardColor,
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
                    color: widget.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.textSecondaryColor,
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

  Widget _buildSettingDropdown(String title, String value, List<String> items, Function(String?) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.cardColor,
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
                color: widget.textColor,
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
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
                      color: widget.textColor,
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

  Widget _buildAboutCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.cardColor,
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
          _buildAboutRow('الإصدار', '1.0.0'),
          _buildAboutRow('تاريخ البناء', '2024-03-20'),
          _buildAboutRow('المطور', 'وزارة الكهرباء - العراق'),
          _buildAboutRow('رقم الترخيص', 'MOE-2024-001'),
          _buildAboutRow('آخر تحديث', '2024-03-15'),
          _buildAboutRow('البريد الإلكتروني', 'support@electric.gov.iq'),
        ],
      ),
    );
  }

  Widget _buildAboutRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: widget.textColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: widget.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ========== شاشة المساعدة والدعم ==========
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
          gradient: LinearGradient(
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
        color: cardColor,
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
                    color: textColor,
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
                color: textColor,
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
                  color: isPhone ? primaryColor : textSecondaryColor,
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
          color: textColor,
        ),
      ),
    );
  }

  // الأسئلة الشائعة
  List<Widget> _buildFAQItems() {
    List<Map<String, String>> faqs = [
      {
        'question': 'كيف يمكنني إضافة بلاغ جديد؟',
        'answer': 'اذهب إلى قسم البلاغات → اختر نوع البلاغ → انقر على زر "إضافة بلاغ" → املأ البيانات المطلوبة → اضغط على زر "حفظ"'
      },
      {
        'question': 'كيف أعرض تقرير البلاغات الشهري؟',
        'answer': 'انتقل إلى قسم التقارير → اختر "تقرير البلاغات" → حدد الفترة الزمنية المطلوبة → انقر على "عرض التقرير"'
      },
      {
        'question': 'كيف أعدل بيانات بلاغ مسجل؟',
        'answer': 'اذهب إلى قسم البلاغات → انقر على البلاغ المطلوب → اختر "تعديل البيانات" → قم بالتعديلات المطلوبة → اضغط على "حفظ التغييرات"'
      },
      {
        'question': 'كيف أتحقق من حالة البلاغات؟',
        'answer': 'انتقل إلى قسم البلاغات → استخدم فلتر الحالة → اختر "لم تتم المعالجة" أو "قيد المعالجة" أو "تم المعالجة" → سيتم عرض البلاغات حسب الحالة المختارة'
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
        color: cardColor,
      ),
      child: ExpansionTile(
        leading: Icon(Icons.help_outline_rounded, color: primaryColor),
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: textColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                color: textSecondaryColor,
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
        color: cardColor,
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
              color: textColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textSecondaryColor,
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
    // launch('tel:$phoneNumber');
  }
}

// ========== شاشة محادثة الدعم ==========
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
                          color: widget.textColor,
                        ),
                      ),
                      Text(
                        'متخصص في نظام البلاغات والمشاكل',
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.textSecondaryColor,
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
              color: widget.cardColor,
              border: Border(
                top: BorderSide(color: widget.primaryColor.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
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
                      color: widget.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser 
                        ? widget.primaryColor 
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message['text'],
                    style: TextStyle(
                      color: isUser ? Colors.white : widget.textColor,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message['time'],
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.textSecondaryColor,
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
      backgroundColor: widget.cardColor,
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
                color: widget.textColor,
              ),
            ),
            SizedBox(height: 16),
            _buildAttachmentOption(Icons.photo_rounded, 'صورة', () {}),
            _buildAttachmentOption(Icons.description_rounded, 'ملف', () {}),
            _buildAttachmentOption(Icons.receipt_rounded, 'بلاغ', () {}),
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
        backgroundColor: widget.cardColor,
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
            color: widget.textColor,
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

// ========== نماذج البيانات ==========
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
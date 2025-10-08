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
      location: 'حي الروضة - شارع الأمير سلطان',
      date: '2024-01-14',
      time: '09:15 ص',
      description: 'تأخر في جمع النفايات لمدة ساعتين عن الموعد المحدد. أدى هذا إلى انتشار الروائح الكريهة وتجمع الحشرات.',
      imageAsset: 'assets/waste2.jpg',
      status: 'قيد المعالجة',
    ),
    WasteProblem(
      employeeName: 'محمد علي',
      employeeId: 'EMP-003',
      problemType: 'عدم جمع النفايات',
      location: 'حي العليا - شارع العروبة',
      date: '2024-01-13',
      time: '10:00 ص',
      description: 'لم يمر موظف جمع النفايات على المنطقة اليوم. النفايات متراكمة منذ يومين وتسبب إزعاجاً للسكان.',
      imageAsset: 'assets/waste3.jpg',
      status: 'تم المعالجة',
    ),
    WasteProblem(
      employeeName: 'سعيد حسن',
      employeeId: 'EMP-004',
      problemType: 'عدم جمع النفايات',
      location: 'حي النزهة - شارع الخليج',
      date: '2024-01-12',
      time: '07:45 ص',
      description: 'جمع جزئي للنفايات حيث تم ترك بعض الحاويات دون جمع. يحتاج لمتابعة عاجلة.',
      imageAsset: 'assets/waste4.jpg',
      status: 'لم يتم المعالجة',
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
      citizenName: 'عبدالرحمن سعيد',
      location: 'حي الروابي - شارع الجامعة',
      area: 'حي الروابي',
      date: '2024-01-15',
      time: '03:15 م',
      description: 'تسرب مستمر من حاوية النفايات قرب المسجد. السائل المتسرب لونه بني داكن ورائحته نفاذة. يشكل خطراً على صحة المصلين والأطفال في المنطقة.',
      imageAsset: 'assets/leakage2.jpg',
      status: 'قيد المعالجة',
    ),
    LeakageProblem(
      citizenName: 'نورة خالد',
      location: 'حي الضباب - شارع الربيع',
      area: 'حي الضباب',
      date: '2024-01-14',
      time: '10:45 ص',
      description: 'تسرب من قاع حاوية النفايات بسبب صدأ المعدن. السائل يتجمع حول الحاوية ويجذب الحشرات والحيوانات الضالة. يحتاج تدخل سريع.',
      imageAsset: 'assets/leakage3.jpg',
      status: 'لم يتم المعالجة',
    ),
    LeakageProblem(
      citizenName: 'ياسر عبدالله',
      location: 'حي الورود - شارع الخزامى',
      area: 'حي الورود',
      date: '2024-01-13',
      time: '06:20 م',
      description: 'تسرب من غطاء حاوية النفايات أثناء الأمطار. المياه المختلطة بالنفايات تنتشر في الشارع وتسبب تلوث بيئي.',
      imageAsset: 'assets/leakage4.jpg',
      status: 'تم المعالجة',
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
      citizenName: 'مريم عبدالله',
      location: 'حي النزهة - شارع الورود',
      area: 'حي النزهة',
      date: '2024-01-16',
      time: '10:15 ص',
      description: 'روائح كريهة مستمرة من موقع تجميع النفايات خلف المركز التجاري. الرائحة تنتشر لمسافات بعيدة وتؤثر على المحلات التجارية المجاورة والمقاهي. يحتاج الأمر إلى تدخل عاجل لتنظيف الموقع.',
      imageAsset: 'assets/odor2.jpg',
      status: 'قيد المعالجة',
    ),
    OdorProblem(
      citizenName: 'خالد محمد',
      location: 'حي السلام - شارع الملك فيصل',
      area: 'حي السلام',
      date: '2024-01-15',
      time: '06:45 م',
      description: 'روائح كريهة تنبعث من حاوية النفايات المقابلة للمسجد. الرائحة تزداد سوءاً مع ارتفاع درجة الحرارة وتسبب إزعاجاً للمصلين خاصة في أوقات الصلاة. يلاحظ وجود حشرات طائرة حول الحاوية.',
      imageAsset: 'assets/odor3.jpg',
      status: 'لم يتم المعالجة',
    ),
    OdorProblem(
      citizenName: 'فاطمة ناصر',
      location: 'حي الروضة - شارع الأمير محمد',
      area: 'حي الروضة',
      date: '2024-01-14',
      time: '04:20 م',
      description: 'روائح كريهة قوية من حاوية النفايات المجاورة للمدرسة. الرائحة تؤثر على الطلاب أثناء الدخول والخروج وقد تسبب مشاكل صحية. الحاوية ممتلئة بشكل زائد وتحتاج إلى إفراغ عاجل.',
      imageAsset: 'assets/odor4.jpg',
      status: 'تم المعالجة',
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
    DamagedContainerProblem(
      citizenName: 'هدى محمد',
      location: 'حي الفيصلية - شارع الملك عبدالله',
      area: 'حي الفيصلية',
      date: '2024-01-17',
      time: '03:45 م',
      description: 'حاوية النفايات تعرضت للتخريب حيث تم قطع جزء كبير من الجانب الأيمن. الحاوية لا تحتفظ بالنفايات بداخلها وتسقط على الأرض. تشكل خطراً على المارة.',
      imageAsset: 'assets/damaged2.jpg',
      status: 'قيد المعالجة',
    ),
    DamagedContainerProblem(
      citizenName: 'راشد العتيبي',
      location: 'حي العزيزية - شارع الأمير نايف',
      area: 'حي العزيزية',
      date: '2024-01-16',
      time: '11:20 ص',
      description: 'حاوية النفايات بها كسر كبير في القاعدة مما يسمح بتسرب السوائل والنفايات. العجلات تالفة وغير قابلة للحركة. تحتاج إلى إصلاح عاجل.',
      imageAsset: 'assets/damaged3.jpg',
      status: 'لم يتم المعالجة',
    ),
    DamagedContainerProblem(
      citizenName: 'لطيفة القحطاني',
      location: 'حي الشفا - شارع الريان',
      area: 'حي الشفا',
      date: '2024-01-15',
      time: '05:30 م',
      description: 'حاوية النفايات محروقة جزئياً بسبب حريق متعمد. البلاستيك منصهر والهيكل مشوه. تشوه المظهر العام للمنطقة وتحتاج لإزالة فورية.',
      imageAsset: 'assets/damaged4.jpg',
      status: 'تم المعالجة',
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
    WasteAccumulationProblem(
      citizenName: 'نورة السعد',
      area: 'حي الروضة',
      location: 'شارع الأمير محمد - بجوار المركز التجاري',
      date: '2024-01-19',
      time: '03:45 م',
      description: 'تراكم نفايات بناء ومواد خشبية وأثاث قديم في الساحة الخلفية للمجمع السكني. هذه النفايات متراكمة منذ أسبوع وتشوه المظهر العام للمنطقة. يلاحظ وجود روائح كريهة تنبعث من الموقع خاصة في فترة المساء.',
      imageAsset: 'assets/accumulation2.jpg',
      status: 'قيد المعالجة',
    ),
    WasteAccumulationProblem(
      citizenName: 'خالد الحربي',
      area: 'حي السلام',
      location: 'شارع الخزان - أمام مسجد الفرقان',
      date: '2024-01-18',
      time: '11:30 ص',
      description: 'تراكم نفايات منزلية بشكل غير منظم أمام كل منزل في الشارع. الحاويات ممتلئة بشكل زائد والنفايات منتشرة على الرصيف. هذا التراكم يجذب الحيوانات الضالة ويسبب إزعاجاً للمارة والمصلين في المسجد المجاور.',
      imageAsset: 'assets/accumulation3.jpg',
      status: 'لم يتم المعالجة',
    ),
    WasteAccumulationProblem(
      citizenName: 'الجوهرة القحطاني',
      area: 'حي النزهة',
      location: 'شارع الورود - بين العمارتين ٥٦ و٥٨',
      date: '2024-01-17',
      time: '06:20 م',
      description: 'تراكم نفايات حدائق وأعشاب جافة وأغصان أشجار في الركن الشمالي من الحي. هذه النفايات ناتجة عن تقليم الأشجار ولم يتم جمعها منذ عشرة أيام. بدأت تظهر عليها علامات التحلل وتنبعث منها روائح كريهة.',
      imageAsset: 'assets/accumulation4.jpg',
      status: 'تم المعالجة',
    ),
    WasteAccumulationProblem(
      citizenName: 'محمد الشمري',
      area: 'حي المصيف',
      location: 'شارع الكورنيش - قريب من الشاطئ',
      date: '2024-01-16',
      time: '04:10 م',
      description: 'تراكم نفايات بلاستيكية وزجاجية وعلب معدنية على طول الشاطئ. هذه النفايات تشكل خطراً على البيئة البحرية والزوار. يلاحظ أن بعض النفايات تحمل علامات المطاعم والمقاهي القريبة من المنطقة.',
      imageAsset: 'assets/accumulation5.jpg',
      status: 'قيد المعالجة',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 3, vsync: this);
    _wasteTabController = TabController(length: 6, vsync: this);
    _employeeTabController = TabController(length: 4, vsync: this);
    _appProblemTabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _wasteTabController.dispose();
    _employeeTabController.dispose();
    _appProblemTabController.dispose();
    _animationController.dispose();
    super.dispose();
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

  // دالة جديدة لعرض تفاصيل تراكم النفايات
  void _showWasteAccumulationProblemDetails(WasteAccumulationProblem problem) {
    setState(() {
      _selectedProblem = 'تراكم النفايات';
      _problemDescription = _buildWasteAccumulationProblemDetailsText(problem);
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

  // دالة جديدة لبناء تفاصيل تراكم النفايات
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
              Icon(Icons.share, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'مشاركة البلاغ',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
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
                  color: Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF2E7D32),
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
                              color: Color(0xFF2E7D32),
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
                backgroundColor: Color(0xFF2E7D32),
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

  void _showLeakageShareDialog(LeakageProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: Color(0xFFFF9800)),
              SizedBox(width: 8),
              Text(
                'مشاركة البلاغ',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9800),
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
                  color: Color(0xFFFF9800).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFFF9800),
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
                              color: Color(0xFFFF9800),
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
                backgroundColor: Color(0xFFFF9800),
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

  void _showOdorShareDialog(OdorProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: Color(0xFF795548)),
              SizedBox(width: 8),
              Text(
                'مشاركة البلاغ',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF795548),
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
                  color: Color(0xFF795548).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF795548),
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
                              color: Color(0xFF795548),
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
                backgroundColor: Color(0xFF795548),
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

  void _showDamagedContainerShareDialog(DamagedContainerProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: Color(0xFF7B1FA2)),
              SizedBox(width: 8),
              Text(
                'مشاركة البلاغ',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7B1FA2),
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
                  color: Color(0xFF7B1FA2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF7B1FA2),
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
                              color: Color(0xFF7B1FA2),
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
                backgroundColor: Color(0xFF7B1FA2),
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

  // دالة جديدة لمشاركة بلاغات تراكم النفايات
  void _showWasteAccumulationShareDialog(WasteAccumulationProblem problem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: Color(0xFFF57C00)),
              SizedBox(width: 8),
              Text(
                'مشاركة البلاغ',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF57C00),
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
                  color: Color(0xFFF57C00).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFF57C00),
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
                              color: Color(0xFFF57C00),
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
                backgroundColor: Color(0xFFF57C00),
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
              Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'تم مشاركة البلاغ مع مسؤول جدولة النظافة بنجاح',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
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
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: Color(0xFF2E7D32),
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
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
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E8),
              Color(0xFFF1F8E9),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 6),
            // TabBarView
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
                  
                  // تفاصيل المشكلة (تظهر عند الضغط)
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

  // قسم بلاغ عن النفايات مع التبويبات الأفقية
  Widget _buildWasteReportSection() {
    return Column(
      children: [
        // تبويبات النفايات
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
                colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFF2E7D32),
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
              Tab(text: 'عدم جمع النفايات'),
              Tab(text: 'تسرب من الحاويات'),
              Tab(text: 'روائح كريهة'),
              Tab(text: 'حاويات تالفة'),
              Tab(text: 'تراكم النفايات'),
              Tab(text: 'أخرى'),
            ],
          ),
        ),
        
        // محتوى تبويبات النفايات
        Expanded(
          child: TabBarView(
            controller: _wasteTabController,
            children: [
              _buildNoCollectionContent(),
              _buildLeakageContent(),
              _buildOdorContent(),
              _buildDamagedContainerContent(),
              _buildWasteAccumulationContent(), // القسم الجديد
              _buildWasteProblemContent(
                'أخرى',
                Icons.more_horiz,
                Color(0xFF607D8B),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // محتوى خاص بعدم جمع النفايات
  Widget _buildNoCollectionContent() {
    return Column(
      children: [
        // رأس القسم
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات عدم جمع النفايات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
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
                backgroundColor: Color(0xFF2E7D32),
              ),
            ],
          ),
        ),
        
        // قائمة المشاكل
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

  // محتوى خاص بتسرب من الحاويات
  Widget _buildLeakageContent() {
    return Column(
      children: [
        // رأس القسم
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.water_damage, color: Color(0xFFFF9800), size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات تسرب من الحاويات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9800),
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
                backgroundColor: Color(0xFFFF9800),
              ),
            ],
          ),
        ),
        
        // قائمة مشاكل التسرب
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

  // محتوى خاص بروائح كريهة
  Widget _buildOdorContent() {
    return Column(
      children: [
        // رأس القسم
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.air, color: Color(0xFF795548), size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات الروائح الكريهة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF795548),
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
                backgroundColor: Color(0xFF795548),
              ),
            ],
          ),
        ),
        
        // قائمة مشاكل الروائح
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

  // محتوى خاص بحاويات تالفة
  Widget _buildDamagedContainerContent() {
    return Column(
      children: [
        // رأس القسم
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.breakfast_dining, color: Color(0xFF7B1FA2), size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات حاويات تالفة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7B1FA2),
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
                backgroundColor: Color(0xFF7B1FA2),
              ),
            ],
          ),
        ),
        
        // قائمة مشاكل الحاويات التالفة
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

  // محتوى خاص بتراكم النفايات - جديد
  Widget _buildWasteAccumulationContent() {
    return Column(
      children: [
        // رأس القسم
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.clean_hands, color: Color(0xFFF57C00), size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات تراكم النفايات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF57C00),
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
                backgroundColor: Color(0xFFF57C00),
              ),
            ],
          ),
        ),
        
        // قائمة مشاكل تراكم النفايات
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

  // بطاقة عرض مشكلة التسرب
  Widget _buildLeakageProblemCard(LeakageProblem problem) {
    Color statusColor = Colors.grey;
    if (problem.status == 'لم يتم المعالجة') {
      statusColor = Colors.red;
    } else if (problem.status == 'قيد المعالجة') {
      statusColor = Colors.orange;
    } else if (problem.status == 'تم المعالجة') {
      statusColor = Colors.green;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _showLeakageProblemDetails(problem),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFFF9800).withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFFFF9800),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          problem.citizenName,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9800),
                          ),
                        ),
                        Text(
                          problem.area,
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
              
              SizedBox(height: 12),
              
              // معلومات المشكلة
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
              
              // وصف مختصر
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
              
              // صورة المشكلة
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

              // علامة المشاركة - في الأسفل من الجهة اليسرى
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => _showLeakageShareDialog(problem),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.share,
                          size: 14,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'مشاركة',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: Colors.blue,
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

  // بطاقة عرض مشكلة الروائح
  Widget _buildOdorProblemCard(OdorProblem problem) {
    Color statusColor = Colors.grey;
    if (problem.status == 'لم يتم المعالجة') {
      statusColor = Colors.red;
    } else if (problem.status == 'قيد المعالجة') {
      statusColor = Colors.orange;
    } else if (problem.status == 'تم المعالجة') {
      statusColor = Colors.green;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _showOdorProblemDetails(problem),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF795548).withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF795548),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          problem.citizenName,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF795548),
                          ),
                        ),
                        Text(
                          problem.area,
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
              
              SizedBox(height: 12),
              
              // معلومات المشكلة
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
              
              // وصف مختصر
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
              
              // صورة المشكلة
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

              // علامة المشاركة - في الأسفل من الجهة اليسرى
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => _showOdorShareDialog(problem),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.share,
                          size: 14,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'مشاركة',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: Colors.blue,
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

  // بطاقة عرض مشكلة الحاويات التالفة
  Widget _buildDamagedContainerProblemCard(DamagedContainerProblem problem) {
    Color statusColor = Colors.grey;
    if (problem.status == 'لم يتم المعالجة') {
      statusColor = Colors.red;
    } else if (problem.status == 'قيد المعالجة') {
      statusColor = Colors.orange;
    } else if (problem.status == 'تم المعالجة') {
      statusColor = Colors.green;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _showDamagedContainerProblemDetails(problem),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF7B1FA2).withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF7B1FA2),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          problem.citizenName,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7B1FA2),
                          ),
                        ),
                        Text(
                          problem.area,
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
              
              SizedBox(height: 12),
              
              // معلومات المشكلة
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
              
              // وصف مختصر
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
              
              // صورة المشكلة
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

              // علامة المشاركة - في الأسفل من الجهة اليسرى
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => _showDamagedContainerShareDialog(problem),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.share,
                          size: 14,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'مشاركة',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: Colors.blue,
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

  // بطاقة عرض مشكلة تراكم النفايات - جديد
  Widget _buildWasteAccumulationProblemCard(WasteAccumulationProblem problem) {
    Color statusColor = Colors.grey;
    if (problem.status == 'لم يتم المعالجة') {
      statusColor = Colors.red;
    } else if (problem.status == 'قيد المعالجة') {
      statusColor = Colors.orange;
    } else if (problem.status == 'تم المعالجة') {
      statusColor = Colors.green;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _showWasteAccumulationProblemDetails(problem),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFF57C00).withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFFF57C00),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          problem.citizenName,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF57C00),
                          ),
                        ),
                        Text(
                          problem.area,
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
              
              SizedBox(height: 12),
              
              // معلومات المشكلة
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
              
              // وصف مختصر
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
              
              // صورة المشكلة
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

              // علامة المشاركة الصغيرة في الأسفل من الجهة اليسرى
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => _showWasteAccumulationShareDialog(problem),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.share,
                          size: 14,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'مشاركة',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: Colors.blue,
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

  // بطاقة عرض المشكلة
  Widget _buildProblemCard(WasteProblem problem) {
    Color statusColor = Colors.grey;
    if (problem.status == 'لم يتم المعالجة') {
      statusColor = Colors.red;
    } else if (problem.status == 'قيد المعالجة') {
      statusColor = Colors.orange;
    } else if (problem.status == 'تم المعالجة') {
      statusColor = Colors.green;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _showProblemDetails(problem),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF2E7D32).withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF2E7D32),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          problem.employeeName,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        Text(
                          problem.employeeId,
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
              
              SizedBox(height: 12),
              
              // معلومات المشكلة
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
              
              // وصف مختصر
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
              
              // صورة المشكلة
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

              // علامة المشاركة - في الأسفل من الجهة اليسرى
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => _showShareDialog(problem),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.share,
                          size: 14,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'مشاركة',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: Colors.blue,
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

  // محتوى كل مشكلة نفايات (للتبويبات الأخرى)
  Widget _buildWasteProblemContent(String title, IconData icon, Color color) {
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

  // قسم تقصير الموظفين مع التبويبات الأفقية
  Widget _buildEmployeeReportSection() {
    return Column(
      children: [
        // تبويبات الموظفين
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
                colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFF1976D2),
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
              Tab(text: 'موظف الاستقبال'),
              Tab(text: 'موظف النظافة'),
              Tab(text: 'أخرى'),
            ],
          ),
        ),
        
        // محتوى تبويبات الموظفين
        Expanded(
          child: TabBarView(
            controller: _employeeTabController,
            children: [
              _buildEmptyEmployeeContent(
                'موظف الفواتير',
                Icons.receipt_long,
                Color(0xFF388E3C),
              ),
              _buildEmptyEmployeeContent(
                'موظف الاستقبال',
                Icons.support_agent,
                Color(0xFF0097A7),
              ),
              _buildEmptyEmployeeContent(
                'موظف النظافة',
                Icons.cleaning_services,
                Color(0xFFFBC02D),
              ),
              _buildEmptyEmployeeContent(
                'أخرى',
                Icons.more_horiz,
                Color(0xFF607D8B),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // محتوى فارغ لكل تبويب من تبويبات الموظفين
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

  // قسم مشاكل التطبيق
  Widget _buildAppProblemSection() {
    return Column(
      children: [
        // تبويبات مشاكل التطبيق
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
                colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFF9C27B0),
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
        
        // محتوى تبويبات مشاكل التطبيق
        Expanded(
          child: TabBarView(
            controller: _appProblemTabController,
            children: [
              _buildEmptyAppProblemContent(
                'تعطيل في التطبيق',
                Icons.error_outline,
                Color(0xFFD32F2F),
              ),
              _buildEmptyAppProblemContent(
                'مشكلة في الدفع',
                Icons.payment,
                Color(0xFFF57C00),
              ),
              _buildEmptyAppProblemContent(
                'واجهة المستخدم',
                Icons.phone_iphone,
                Color(0xFF1976D2),
              ),
              _buildEmptyAppProblemContent(
                'أخرى',
                Icons.more_horiz,
                Color(0xFF607D8B),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // محتوى فارغ لكل مشكلة تطبيق في التبويبات
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

  // بطاقة تفاصيل المشكلة
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
          // العنوان
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
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
                  // الصورة
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
                  
                  // الوصف
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
                  
                  // أزرار الإجراء
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
                            backgroundColor: Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: Colors.green.withOpacity(0.3),
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
              Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'تم الإبلاغ عن المشكلة بنجاح',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
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

// نموذج بيانات المشكلة
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

// نموذج بيانات مشكلة التسرب
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

// نموذج بيانات مشكلة الروائح
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

// نموذج بيانات مشكلة حاويات تالفة
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

// نموذج بيانات جديد لمشكلة تراكم النفايات
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
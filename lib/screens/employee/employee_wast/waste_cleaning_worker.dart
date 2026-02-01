import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';

void main() {
  runApp(const MaterialApp(
    home: WasteCleaningWorkerScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class WasteCleaningWorkerScreen extends StatefulWidget {
  const WasteCleaningWorkerScreen({super.key});

  @override
  State<WasteCleaningWorkerScreen> createState() =>
      _WasteCleaningWorkerScreenState();
}

class _WasteCleaningWorkerScreenState
    extends State<WasteCleaningWorkerScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late TabController _tabController;

  // ========== نظام التقارير الجديد ==========
  String _selectedArea = 'جميع المناطق';
  String _selectedReportTypeSystem = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;
  DateTime? _lastSelectedDate; // Track last clicked date for highlighting
  final List<String> _areas = ['جميع المناطق', 'حي الرياض', 'حي النخيل', 'حي العليا', 'حي الصفا'];
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

  // ========== بيانات البلاغات (الشكاوى) ==========
  final List<Map<String, dynamic>> complaints = [
    {
      'id': 'COMP-2024-001',
      'citizenId': 'CIT-2024-001',
      'citizenName': 'أحمد محمد',
      'phone': '077235477514',
      'address': 'حي الرياض - شارع الملك فهد',
      'type': 'جمع غير منتظم',
      'description': 'تأخر جمع النفايات لمدة 3 أيام متتالية، مما أدى إلى تراكم النفايات ورائحة كريهة',
      'priority': 'عالية',
      'status': 'قيد المعالجة',
      'submittedDate': DateTime.now().subtract(Duration(days: 2, hours: 5)),
      'images': [
        'https://images.unsplash.com/photo-1562071707-7249ab429b2a?w=400&h=300&fit=crop',
        'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400&h=300&fit=crop',
      ],
      'location': '33.3152, 44.3661',
      'assignedTo': 'فريق الجمع 3',
      'notes': 'تم التواصل مع فريق الجمع، سيتم المعالجة خلال 24 ساعة',
      'lastUpdate': DateTime.now().subtract(Duration(hours: 12)),
    },
    {
      'id': 'COMP-2024-002',
      'citizenId': 'CIT-2024-002',
      'citizenName': 'فاطمة علي',
      'phone': '07827534903',
      'address': 'حي النخيل - شارع الأمير محمد',
      'type': 'حاوية تالفة',
      'description': 'حاوية النفايات رقم BIN-001235 مكسورة وتحتاج إلى استبدال',
      'priority': 'متوسطة',
      'status': 'مكتمل',
      'submittedDate': DateTime.now().subtract(Duration(days: 5, hours: 10)),
      'images': [
        'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&h=300&fit=crop',
      ],
      'location': '33.3125, 44.3689',
      'assignedTo': 'فريق الصيانة 1',
      'notes': 'تم استبدال الحاوية بنجاح',
      'lastUpdate': DateTime.now().subtract(Duration(days: 2)),
      'completionDate': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'id': 'COMP-2024-003',
      'citizenId': 'CIT-2024-003',
      'citizenName': 'خالد إبراهيم',
      'phone': '07758888999',
      'address': 'حي العليا - شارع العروبة',
      'type': 'تدوير غير صحيح',
      'description': 'فريق التدوير لا يفصل النفايات بشكل صحيح، يتم خلط المواد القابلة لإعادة التدوير مع النفايات العادية',
      'priority': 'عالية',
      'status': 'جديد',
      'submittedDate': DateTime.now().subtract(Duration(hours: 3)),
      'images': [
        'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400&h=300&fit=crop',
        'https://images.unsplash.com/photo-1562071707-7249ab429b2a?w=400&h=300&fit=crop',
      ],
      'location': '33.3189, 44.3623',
      'assignedTo': 'لم يتم التخصيص',
      'notes': 'في انتظار المراجعة',
      'lastUpdate': DateTime.now().subtract(Duration(hours: 3)),
    },
    {
      'id': 'COMP-2024-004',
      'citizenId': 'CIT-2024-001',
      'citizenName': 'أحمد محمد',
      'phone': '077235477514',
      'address': 'حي الرياض - شارع الملك فهد',
      'type': 'رائحة كريهة',
      'description': 'رائحة كريهة قوية تخرج من موقع تجميع النفايات بالقرب من المنزل',
      'priority': 'عالية',
      'status': 'قيد المعالجة',
      'submittedDate': DateTime.now().subtract(Duration(days: 1, hours: 8)),
      'images': [],
      'location': '33.3155, 44.3658',
      'assignedTo': 'فريق التعقيم 2',
      'notes': 'تم جدولة عملية التعقيم والتطهير',
      'lastUpdate': DateTime.now().subtract(Duration(hours: 6)),
    },
    {
      'id': 'COMP-2024-005',
      'citizenId': 'CIT-2024-002',
      'citizenName': 'فاطمة علي',
      'phone': '07827534903',
      'address': 'حي النخيل - شارع الأمير محمد',
      'type': 'حصيلة غير صحيحة',
      'description': 'المبلغ المطلوب في الفاتورة لا يتوافق مع كمية النفايات المجمعة',
      'priority': 'منخفضة',
      'status': 'ملغى',
      'submittedDate': DateTime.now().subtract(Duration(days: 7, hours: 15)),
      'images': [
        'https://images.unsplash.com/photo-1603791445824-0040c5198b38?w=400&h=300&fit=crop',
      ],
      'location': '33.3122, 44.3692',
      'assignedTo': 'فريق الفواتير',
      'notes': 'تم التحقق من الفاتورة وهي صحيحة، تم إغلاق البلاغ',
      'lastUpdate': DateTime.now().subtract(Duration(days: 5)),
      'completionDate': DateTime.now().subtract(Duration(days: 5)),
    },
  ];

  // دالة للحصول على البلاغات حسب الحالة
  List<Map<String, dynamic>> _getFilteredComplaints() {
    switch (_currentComplaintTab) {
      case 0: // الكل
        return complaints;
      case 1: // جديد
        return complaints.where((complaint) => complaint['status'] == 'جديد').toList();
      case 2: // قيد المعالجة
        return complaints.where((complaint) => complaint['status'] == 'قيد المعالجة').toList();
      case 3: // مكتمل
        return complaints.where((complaint) => complaint['status'] == 'مكتمل').toList();
      case 4: // ملغى
        return complaints.where((complaint) => complaint['status'] == 'ملغى').toList();
      default:
        return complaints;
    }
  }

  // تبويبات البلاغات
  int _currentComplaintTab = 0;

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

  // بيانات المهام
  final List<CleanTask> _todayTasks = [
    CleanTask(
      id: 1,
      areaName: 'حي السلام - المنطقة A',
      truckNumber: 'شاحنة 101',
      workers: ['أحمد محمد', 'خالد علي'],
      startTime: '08:00',
      endTime: '12:00',
      date: DateTime.now(),
      isCompleted: true,
      status: 'مكتمل',
    ),
    CleanTask(
      id: 2,
      areaName: 'حي النهضة - المنطقة B',
      truckNumber: 'شاحنة 102',
      workers: ['محمود حسن', 'سعيد عبدالله'],
      startTime: '13:00',
      endTime: '16:00',
      date: DateTime.now(),
      isCompleted: false,
      status: 'قيد التنفيذ',
    ),
    CleanTask(
      id: 3,
      areaName: 'حي الورود - المنطقة C',
      truckNumber: 'شاحنة 103',
      workers: ['علي كمال', 'فارس ناصر'],
      startTime: '17:00',
      endTime: '19:00',
      date: DateTime.now(),
      isCompleted: false,
      status: 'مخطط',
    ),
  ];

  // العمال المتاحين
  final List<Worker> _availableWorkers = [
    Worker(id: 1, name: 'أحمد محمد', phone: '0551234567', isOnDuty: false),
    Worker(id: 2, name: 'خالد علي', phone: '0552345678', isOnDuty: true),
    Worker(id: 3, name: 'محمود حسن', phone: '0553456789', isOnDuty: false),
    Worker(id: 4, name: 'سعيد عبدالله', phone: '0554567890', isOnDuty: true),
    Worker(id: 5, name: 'علي كمال', phone: '0555678901', isOnDuty: false),
  ];

  // أسماء الأيام والشهور العربية
  final Map<String, String> _arabicDays = {
    'Monday': 'الاثنين',
    'Tuesday': 'الثلاثاء',
    'Wednesday': 'الأربعاء',
    'Thursday': 'الخميس',
    'Friday': 'الجمعة',
    'Saturday': 'السبت',
    'Sunday': 'الأحد',
  };

  final Map<String, String> _arabicMonths = {
    'January': 'يناير',
    'February': 'فبراير',
    'March': 'مارس',
    'April': 'أبريل',
    'May': 'مايو',
    'June': 'يونيو',
    'July': 'يوليو',
    'August': 'أغسطس',
    'September': 'سبتمبر',
    'October': 'أكتوبر',
    'November': 'نوفمبر',
    'December': 'ديسمبر',
  };

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

  // دالة لتنسيق التاريخ والوقت بدقة
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (date == today) {
      return 'اليوم ${DateFormat('h:mm a').format(dateTime)}';
    } else if (date == yesterday) {
      return 'أمس ${DateFormat('h:mm a').format(dateTime)}';
    } else {
      return DateFormat('yyyy/MM/dd - h:mm a').format(dateTime);
    }
  }

  Color _getComplaintStatusColor(String status) {
    switch (status) {
      case 'جديد':
        return _errorColor;
      case 'قيد المعالجة':
        return _warningColor;
      case 'مكتمل':
        return _successColor;
      case 'ملغى':
        return _textSecondaryColor;
      default:
        return _textSecondaryColor;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عالية':
        return _errorColor;
      case 'متوسطة':
        return _warningColor;
      case 'منخفضة':
        return _successColor;
      default:
        return _textSecondaryColor;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _tabController = TabController(length: 5, vsync: this); // تغيير إلى 5 أقسام
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('عامل النظافة'),
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.home), text: 'الرئيسية'),
          Tab(icon: Icon(Icons.calendar_today), text: 'الجداول'),
          Tab(icon: Icon(Icons.assignment), text: 'الطلبات'),
          Tab(icon: Icon(Icons.report_problem), text: 'البلاغات'), // إضافة تبويب البلاغات
          Tab(icon: Icon(Icons.report), text: 'التقارير'),
        ],
      ),
    ),
    body: TabBarView(
      controller: _tabController,
      children: [
        _buildDashboard(),
        _buildSchedule(),
        _buildRequests(),
        _buildComplaintsView(), // إضافة شاشة البلاغات
        _buildReportsView(),
      ],
    ),
    floatingActionButton: _currentIndex == 4
        ? FloatingActionButton(
            onPressed: _showMultiDatePicker,
            backgroundColor: Colors.green,
            child: const Icon(Icons.add, color: Colors.white),
          )
        : null,
  );
}

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة ترحيب
          Card(
            elevation: 3,
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.work, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'مرحباً، عامل النظافة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'مهام اليوم: ${_todayTasks.where((task) => !task.isCompleted).length}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'التاريخ: ${_getArabicDate(DateTime.now())}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // المهام اليومية
          const Text(
            'المهام اليومية',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ..._todayTasks.map((task) => _buildTaskCard(task)).toList(),

          const SizedBox(height: 20),

          // إحصائيات
          const Text(
            'الإحصائيات',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'المكتمل',
                  value: _todayTasks.where((task) => task.isCompleted).length.toString(),
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  title: 'قيد التنفيذ',
                  value: _todayTasks.where((task) => task.status == 'قيد التنفيذ').length.toString(),
                  color: Colors.orange,
                  icon: Icons.autorenew,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  title: 'المخطط',
                  value: _todayTasks.where((task) => task.status == 'مخطط').length.toString(),
                  color: Colors.blue,
                  icon: Icons.schedule,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(CleanTask task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: task.isCompleted ? Colors.green[100] : Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    task.isCompleted ? Icons.check : Icons.cleaning_services,
                    color: task.isCompleted ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.areaName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الشاحنة: ${task.truckNumber}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                task.isCompleted
                    ? const Icon(Icons.check_circle, color: Colors.green, size: 30)
                    : ElevatedButton(
                        onPressed: () => _completeTask(task.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: const Text('إكمال'),
                      ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${task.startTime} - ${task.endTime}'),
                const SizedBox(width: 16),
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    task.workers.join('، '),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: task.status == 'مكتمل'
                        ? Colors.green[100]
                        : task.status == 'قيد التنفيذ'
                            ? Colors.orange[100]
                            : Colors.blue[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.status,
                    style: TextStyle(
                      color: task.status == 'مكتمل'
                          ? Colors.green[800]
                          : task.status == 'قيد التنفيذ'
                              ? Colors.orange[800]
                              : Colors.blue[800],
                      fontSize: 12,
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedule() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'جدول المهام',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TableCalendar(
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.red[400]),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  formatButtonTextStyle: const TextStyle(color: Colors.white),
                  titleTextStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.green),
                  rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.green),
                ),
                // تحويل أسماء الأيام إلى عربي
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  weekendStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                // تخصيص أسماء الأيام
                daysOfWeekHeight: 40,
                // تخصيص أيام الأسبوع
                calendarBuilders: CalendarBuilders(
                  headerTitleBuilder: (context, day) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _getArabicMonthYear(day),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                  dowBuilder: (context, day) {
                    final dayName = DateFormat('EEEE').format(day);
                    return Center(
                      child: Text(
                        _arabicDays[dayName] ?? dayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isWeekend(day) ? Colors.red : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'مهام ${_getArabicDate(_selectedDay)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ..._todayTasks.where((task) {
            return isSameDay(task.date, _selectedDay);
          }).map((task) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          task.areaName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: task.isCompleted
                                ? Colors.green[100]
                                : task.status == 'قيد التنفيذ'
                                    ? Colors.orange[100]
                                    : Colors.blue[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            task.status,
                            style: TextStyle(
                              color: task.isCompleted
                                  ? Colors.green[800]
                                  : task.status == 'قيد التنفيذ'
                                      ? Colors.orange[800]
                                      : Colors.blue[800],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.local_shipping,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(' ${task.truckNumber}'),
                        const SizedBox(width: 16),
                        Icon(Icons.access_time,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(' ${task.startTime} - ${task.endTime}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.people, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            task.workers.join('، '),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          if (_todayTasks
              .where((task) => isSameDay(task.date, _selectedDay))
              .isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'لا توجد مهام في هذا اليوم',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRequests() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الطلبات'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.beach_access), text: 'طلب إجازة'),
              Tab(icon: Icon(Icons.swap_horiz), text: 'استبدال عامل'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLeaveRequest(),
            _buildReplacementRequest(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveRequest() {
    DateTime? startDate;
    DateTime? endDate;
    String? selectedLeaveType;
    final reasonController = TextEditingController();
    final leaveTypes = ['إجازة سنوية', 'إجازة مرضية', 'إجازة عارضة', 'إجازة رسمية'];

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'طلب إجازة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // نوع الإجازة
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'نوع الإجازة',
                  border: OutlineInputBorder(),
                ),
                value: selectedLeaveType,
                items: leaveTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLeaveType = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              // تاريخ البدء
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    setState(() {
                      startDate = date;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'تاريخ البدء',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        startDate != null
                            ? _getArabicDate(startDate!)
                            : 'اختر التاريخ',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // تاريخ الانتهاء
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    setState(() {
                      endDate = date;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'تاريخ الانتهاء',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        endDate != null
                            ? _getArabicDate(endDate!)
                            : 'اختر التاريخ',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // السبب
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'سبب الإجازة',
                  border: OutlineInputBorder(),
                  hintText: 'أدخل سبب طلب الإجازة...',
                ),
                maxLines: 4,
              ),

              const SizedBox(height: 20),

              if (startDate != null && endDate != null)
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'عدد الأيام: ${endDate!.difference(startDate!).inDays + 1} يوم',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedLeaveType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('الرجاء اختيار نوع الإجازة')),
                      );
                      return;
                    }
                    if (startDate == null || endDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('الرجاء اختيار التاريخ')),
                      );
                      return;
                    }
                    if (reasonController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('الرجاء إدخال السبب')),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('تأكيد طلب الإجازة'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('النوع: $selectedLeaveType'),
                            Text('من: ${_getArabicDate(startDate!)}'),
                            Text('إلى: ${_getArabicDate(endDate!)}'),
                            Text('المدة: ${endDate!.difference(startDate!).inDays + 1} يوم'),
                            Text('السبب: ${reasonController.text}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('إلغاء'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم إرسال طلب الإجازة')),
                              );
                          
                            },
                            child: const Text('تأكيد'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'إرسال الطلب',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReplacementRequest() {
    DateTime? replacementDate;
    String? selectedWorker;
    final reasonController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'طلب استبدال عامل ليوم واحد',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // التاريخ
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    setState(() {
                      replacementDate = date;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'تاريخ الاستبدال',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        replacementDate != null
                            ? _getArabicDate(replacementDate!)
                            : 'اختر التاريخ',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // العامل البديل
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'العامل البديل',
                  border: OutlineInputBorder(),
                ),
                value: selectedWorker,
                items: _availableWorkers.where((w) => !w.isOnDuty).map((worker) {
                  return DropdownMenuItem(
                    value: worker.name,
                    child: Text(worker.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedWorker = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              // السبب
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'سبب الاستبدال',
                  border: OutlineInputBorder(),
                  hintText: 'أدخل سبب طلب الاستبدال...',
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              if (selectedWorker != null)
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'معلومات العامل:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('الاسم: $selectedWorker'),
                        Text('الهاتف: ${_availableWorkers.firstWhere((w) => w.name == selectedWorker).phone}'),
                        Text('الحالة: متاح'),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (replacementDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('الرجاء اختيار التاريخ')),
                      );
                      return;
                    }
                    if (selectedWorker == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('الرجاء اختيار عامل بديل')),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('تأكيد طلب الاستبدال'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('التاريخ: ${_getArabicDate(replacementDate!)}'),
                            Text('العامل البديل: $selectedWorker'),
                            Text('السبب: ${reasonController.text}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('إلغاء'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم إرسال طلب الاستبدال')),
                              );
                            },
                            child: const Text('تأكيد'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'إرسال الطلب',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ========== شاشة البلاغات ==========
  Widget _buildComplaintsView() {
    List<Map<String, dynamic>> filteredComplaints = _getFilteredComplaints();
    
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          // إحصائيات البلاغات
          _buildComplaintsStatsCard(),
          
          // تبويبات التصفية
          _buildComplaintsFilterRow(),
          
          // قائمة البلاغات
          Expanded(
            child: filteredComplaints.isEmpty
                ? _buildNoComplaintsMessage()
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredComplaints.length,
                    itemBuilder: (context, index) {
                      return _buildComplaintCard(filteredComplaints[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintsStatsCard() {
    int newComplaints = complaints.where((c) => c['status'] == 'جديد').length;
    int inProgress = complaints.where((c) => c['status'] == 'قيد المعالجة').length;
    int completed = complaints.where((c) => c['status'] == 'مكتمل').length;
    int cancelled = complaints.where((c) => c['status'] == 'ملغى').length;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildComplaintStat('إجمالي البلاغات', complaints.length.toString(), Icons.report_problem_rounded, _primaryColor),
            _buildComplaintStat('جديدة', newComplaints.toString(), Icons.new_releases_rounded, _errorColor),
            _buildComplaintStat('قيد المعالجة', inProgress.toString(), Icons.sync_rounded, _warningColor),
            _buildComplaintStat('مكتملة', completed.toString(), Icons.check_circle_rounded, _successColor),
            _buildComplaintStat('ملغية', cancelled.toString(), Icons.cancel_rounded, _textSecondaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintsFilterRow() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border(
          bottom: BorderSide(color: _borderColor),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildComplaintFilterChip('الكل', 0),
          _buildComplaintFilterChip('جديدة', 1),
          _buildComplaintFilterChip('قيد المعالجة', 2),
          _buildComplaintFilterChip('مكتملة', 3),
          _buildComplaintFilterChip('ملغية', 4),
        ],
      ),
    );
  }

  Widget _buildComplaintFilterChip(String label, int tabIndex) {
    bool isSelected = _currentComplaintTab == tabIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentComplaintTab = tabIndex;
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
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : _textColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintCard(Map<String, dynamic> complaint) {
    Color statusColor = _getComplaintStatusColor(complaint['status']);
    String priority = complaint['priority'];
    Color priorityColor = _getPriorityColor(priority);
    List<String> images = (complaint['images'] as List<dynamic>).cast<String>();
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor,
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
          child: Icon(Icons.report_problem_rounded, color: statusColor, size: 24),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'بلاغ #${complaint['id']}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: _textColor,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: priorityColor),
              ),
              child: Text(
                priority,
                style: TextStyle(
                  fontSize: 10,
                  color: priorityColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              complaint['citizenName'],
              style: TextStyle(
                fontSize: 14,
                color: _textSecondaryColor,
              ),
            ),
            SizedBox(height: 2),
            Text(
              complaint['type'],
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor,
              ),
            ),
            SizedBox(height: 8),
            // عرض الصور المصغرة إذا كانت موجودة
            if (images.isNotEmpty)
              Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDateTime(complaint['submittedDate'] as DateTime),
                  style: TextStyle(
                    fontSize: 10,
                    color: _textSecondaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    complaint['status'],
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          _showComplaintDetails(complaint);
        },
      ),
    );
  }

  Widget _buildComplaintStat(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        SizedBox(height: 8),
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

  Widget _buildNoComplaintsMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.report_off_rounded, 
               size: 64, 
               color: _textSecondaryColor),
          SizedBox(height: 16),
          Text(
            'لا توجد بلاغات',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لا توجد بلاغات في التبويب المحدد',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showComplaintDetails(Map<String, dynamic> complaint) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // الهيدر
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
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
                        'تفاصيل البلاغ #${complaint['id']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        complaint['status'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // المحتوى
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // المعلومات الأساسية
                    Text(
                      'المعلومات الأساسية',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _primaryColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildComplaintDetailRow('المواطن:', complaint['citizenName']),
                    _buildComplaintDetailRow('رقم الهاتف:', complaint['phone']),
                    _buildComplaintDetailRow('العنوان:', complaint['address']),
                    _buildComplaintDetailRow('نوع البلاغ:', complaint['type']),
                    _buildComplaintDetailRow('الأولوية:', complaint['priority']),
                    _buildComplaintDetailRow('تم التخصيص إلى:', complaint['assignedTo']),
                    
                    SizedBox(height: 16),
                    
                    // الوصف
                    Text(
                      'وصف البلاغ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        complaint['description'],
                        style: TextStyle(
                          color: _textColor,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // الصور
                    if ((complaint['images'] as List).isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الصور المرفقة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: complaint['images'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 8),
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(complaint['images'][index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    
                    // المعلومات الزمنية
                    Text(
                      'المعلومات الزمنية',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _primaryColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildComplaintDetailRow('تاريخ الإرسال:', _formatDateTime(complaint['submittedDate'] as DateTime)),
                    _buildComplaintDetailRow('آخر تحديث:', _formatDateTime(complaint['lastUpdate'] as DateTime)),
                    if (complaint['completionDate'] != null)
                      _buildComplaintDetailRow('تاريخ الإكمال:', _formatDateTime(complaint['completionDate'] as DateTime)),
                    
                    SizedBox(height: 16),
                    
                    // الملاحظات
                    Text(
                      'ملاحظات',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        complaint['notes'],
                        style: TextStyle(
                          color: _textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildComplaintDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== نظام التقارير الجديد ==========
  Widget _buildReportsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.assignment, color: _primaryColor, size: 24),
              ),
              const SizedBox(width: 8),
              Text(
                'نظام التقارير المتقدم',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildReportTypeFilter(),
          const SizedBox(height: 20),
          _buildReportOptions(),
          const SizedBox(height: 20),
          _buildGenerateReportButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildReportTypeFilter() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نوع التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _reportTypes.map((type) {
                  final isSelected = _selectedReportTypeSystem == type;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedReportTypeSystem = type;
                          _selectedDates.clear();
                          _selectedWeek = null;
                          _selectedMonth = null;
                        });
                      },
                      selectedColor: _primaryColor.withOpacity(0.2),
                      checkmarkColor: _primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? _primaryColor : _textColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: isSelected ? _primaryColor : Colors.grey[300]!),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportOptions() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خيارات التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedReportTypeSystem == 'يومي') _buildDailyOptions(),
            if (_selectedReportTypeSystem == 'أسبوعي') _buildWeeklyOptions(),
            if (_selectedReportTypeSystem == 'شهري') _buildMonthlyOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyOptions() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _showMultiDatePicker,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 8),
              Text('فتح التقويم واختيار التواريخ'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedDates.isNotEmpty) ...[
          Text(
            'التواريخ المختارة:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedDates.map((date) {
              return Chip(
                backgroundColor: _primaryColor.withOpacity(0.1),
                label: Text(DateFormat('yyyy-MM-dd').format(date), style: TextStyle(color: _primaryColor)),
                deleteIconColor: _primaryColor,
                onDeleted: () {
                  setState(() {
                    _selectedDates.remove(date);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${_selectedDates.length}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    const Text('يوم مختار'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd').format(_selectedDates.first),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                    const Text('التاريخ المختار'),
                  ],
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[400], size: 48),
                const SizedBox(height: 8),
                Text(
                  'لم يتم اختيار أي تواريخ',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'انقر على الزر أعلاه لفتح التقويم واختيار التواريخ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWeeklyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الأسبوع',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _weeks.map((week) {
            final isSelected = _selectedWeek == week;
            return FilterChip(
              label: Text(
                week,
                style: TextStyle(fontSize: 12),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedWeek = selected ? week : null;
                });
              },
              selectedColor: _primaryColor.withOpacity(0.2),
              checkmarkColor: _primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? _primaryColor : _textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : Colors.grey[300]!),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonthlyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الشهر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _months.map((month) {
            final isSelected = _selectedMonth == month;
            return FilterChip(
              label: Text(
                month,
                style: TextStyle(fontSize: 12),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedMonth = selected ? month : null;
                });
              },
              selectedColor: _primaryColor.withOpacity(0.2),
              checkmarkColor: _primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? _primaryColor : _textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : Colors.grey[300]!),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenerateReportButton() {
    bool isFormValid = false;
    
    switch (_selectedReportTypeSystem) {
      case 'يومي':
        isFormValid = _selectedDates.isNotEmpty;
        break;
      case 'أسبوعي':
        isFormValid = _selectedWeek != null;
        break;
      case 'شهري':
        isFormValid = _selectedMonth != null;
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isFormValid ? _generateReport : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid ? _primaryColor : Colors.grey[400],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.summarize),
            const SizedBox(width: 8),
            Text(
              'إنشاء التقرير ${_selectedReportTypeSystem == 'يومي' && _selectedDates.isNotEmpty ? '(${_selectedDates.length} يوم)' : ''}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showMultiDatePicker() {
    // Keep original selection for cancel
    final List<DateTime> originalSelection = List.from(_selectedDates);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          // Function for dialog date selection
          void toggleDateInDialog(DateTime date) {
            setState(() {
              bool isAlreadySelected = _selectedDates.any((selectedDate) =>
                  selectedDate.year == date.year &&
                  selectedDate.month == date.month &&
                  selectedDate.day == date.day);
              
              if (isAlreadySelected) {
                _selectedDates.removeWhere((selectedDate) =>
                    selectedDate.year == date.year &&
                    selectedDate.month == date.month &&
                    selectedDate.day == date.day);
              } else {
                _selectedDates.clear();
                _selectedDates.add(date);
              }
            });
          }
          
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('اختر التواريخ', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  TableCalendar(
                    firstDay: DateTime.now().subtract(Duration(days: 365)),
                    lastDay: DateTime.now().add(Duration(days: 365)),
                    focusedDay: DateTime.now(),
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {CalendarFormat.month: 'شهري'},
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
                      leftChevronIcon: Icon(Icons.chevron_left, color: _primaryColor),
                      rightChevronIcon: Icon(Icons.chevron_right, color: _primaryColor),
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(color: _primaryColor, shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(color: _accentColor, shape: BoxShape.circle),
                      weekendTextStyle: TextStyle(color: _errorColor),
                      defaultTextStyle: TextStyle(color: _textColor),
                      holidayTextStyle: TextStyle(color: _warningColor),
                    ),
                    selectedDayPredicate: (day) {
                      return _lastSelectedDate != null &&
                          _lastSelectedDate!.year == day.year &&
                          _lastSelectedDate!.month == day.month &&
                          _lastSelectedDate!.day == day.day;
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() { // This setState is from the dialog's StatefulBuilder
                        // Same logic as above but for dialog
                        bool isInList = _selectedDates.any((selectedDate) =>
                            selectedDate.year == selectedDay.year &&
                            selectedDate.month == selectedDay.month &&
                            selectedDate.day == selectedDay.day);
                        
                        if (!isInList) {
                          _selectedDates.add(selectedDay);
                        }
                        
                        _lastSelectedDate = selectedDay;
                      });
                    },
                  ),
                  if (_selectedDates.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'التاريخ المختار:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedDates.map((date) {
                            return Chip(
                              backgroundColor: _primaryColor.withOpacity(0.1),
                              label: Text(DateFormat('yyyy-MM-dd').format(date), style: TextStyle(color: _primaryColor)),
                              deleteIconColor: _primaryColor,
                              onDeleted: () {
                                setState(() {
                                  _selectedDates.remove(date);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey[400], size: 48),
                          const SizedBox(height: 8),
                          Text(
                            'لم يتم اختيار أي تاريخ',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'انقر على التاريخ لاختياره',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Restore original selection on cancel
                  _selectedDates.clear();
                  _selectedDates.addAll(originalSelection);
                  Navigator.pop(context);
                },
                child: Text('إلغاء', style: TextStyle(color: Colors.grey[600])),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Save the selection and trigger parent rebuild
                  Navigator.pop(context);
                  // Trigger parent widget rebuild
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: const Text('تم'),
              ),
            ],
          );
        },
      ),
    ).then((_) {
      // This ensures parent widget rebuilds after dialog closes
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _toggleDateSelection(DateTime date) {
    setState(() {
      // Check if date is already in our collection list
      bool isInList = _selectedDates.any((selectedDate) =>
          selectedDate.year == date.year &&
          selectedDate.month == date.month &&
          selectedDate.day == date.day);
      
      // If NOT in list, add it (collect all clicked dates)
      if (!isInList) {
        _selectedDates.add(date);
      }
      
      // Track the last clicked date for visual highlighting
      _lastSelectedDate = date;
    });
  }

  void _generateReport() {
    if (_selectedReportTypeSystem == 'يومي' && _selectedDates.isEmpty) {
      _showErrorSnackbar('يرجى اختيار تواريخ أولاً');
      return;
    }

    String reportPeriod = '';
    
    switch (_selectedReportTypeSystem) {
      case 'يومي':
        if (_selectedDates.isNotEmpty) {
          final sortedDates = List<DateTime>.from(_selectedDates)..sort();
          if (_selectedDates.length == 1) {
            reportPeriod = DateFormat('yyyy-MM-dd').format(_selectedDates.first);
          } else {
            reportPeriod = '${DateFormat('yyyy-MM-dd').format(sortedDates.first)} إلى ${DateFormat('yyyy-MM-dd').format(sortedDates.last)}';
          }
        }
        break;
      case 'أسبوعي':
        reportPeriod = _selectedWeek ?? 'غير محدد';
        break;
      case 'شهري':
        reportPeriod = _selectedMonth ?? 'غير محدد';
        break;
    }

    _showSuccessSnackbar('تم إنشاء التقرير لـ ${_selectedDates.length} يوم بنجاح');
    _showGeneratedReport(reportPeriod);
  }

  void _showGeneratedReport(String period) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('التقرير $period', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('نوع التقرير: $_selectedReportTypeSystem', style: TextStyle(color: _textColor)),
              if (_selectedReportTypeSystem == 'يومي' && _selectedDates.isNotEmpty)
                Text('عدد الأيام: ${_selectedDates.length}', style: TextStyle(color: _textColor)),
              if (_selectedWeek != null)
                Text('الأسبوع: $_selectedWeek', style: TextStyle(color: _textColor)),
              if (_selectedMonth != null)
                Text('الشهر: $_selectedMonth', style: TextStyle(color: _textColor)),
              const SizedBox(height: 16),
              Text('ملخص التقرير:', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              Text('- إجمالي الفواتير: ${reports.length}', style: TextStyle(color: _textColor)),
              Text('- الفواتير المدفوعة: ${reports.where((report) => report['type'] == 'مالي').length}', style: TextStyle(color: _textColor)),
              Text('- الفواتير غير المدفوعة: ${reports.where((report) => report['type'] == 'متابعة').length}', style: TextStyle(color: _textColor)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _generatePdfReport(period);
            },
            child: const Text('تصدير PDF'),
          ),
        ],
      ),
    );
  }

  Future<void> _generatePdfReport(String period) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              _buildPdfHeader(period),
              pw.SizedBox(height: 20),
              
              pw.SizedBox(height: 20),
              _buildPdfReportsDetails(),
            ];
          },
        ),
      );

      final Uint8List pdfBytes = await pdf.save();
      await _sharePdfFile(pdfBytes, period);

    } catch (e) {
      _showErrorSnackbar('خطأ في تصدير التقرير: $e');
    }
  }

  pw.Widget _buildPdfHeader(String period) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'وزارة البلديات',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green,
              ),
            ),
            pw.Text(
              'تقرير نظام النفايات',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            pw.Text(
              'نوع التقرير: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(_selectedReportTypeSystem),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            pw.Text(
              'الفترة: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(period),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            pw.Text(
              'تاريخ الإنشاء: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPdfSummary() {
    final totalReports = reports.length;
    final financialReports = reports.where((report) => report['type'] == 'مالي').length;
    final followupReports = reports.where((report) => report['type'] == 'متابعة').length;
    
    int totalRevenue = 0;
    int totalBills = 0;
    
    for (var report in reports) {
      if (report['totalRevenue'] != null) {
        totalRevenue += report['totalRevenue'] as int;
      }
      if (report['totalBills'] != null) {
        totalBills += report['totalBills'] as int;
      }
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.green),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ملخص التقرير',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('إجمالي التقارير:'),
              pw.Text('${NumberFormat('#,##0').format(totalReports)}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('تقارير مالية:'),
              pw.Text('${NumberFormat('#,##0').format(financialReports)}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('تقارير متابعة:'),
              pw.Text('${NumberFormat('#,##0').format(followupReports)}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('إجمالي الإيرادات:'),
              pw.Text('${NumberFormat('#,##0').format(totalRevenue)} دينار'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('إجمالي الفواتير:'),
              pw.Text('${NumberFormat('#,##0').format(totalBills)}'),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfReportsDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'تفاصيل التقارير',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.green,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.green100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('رقم التقرير', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('العنوان', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('النوع', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الفترة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('تاريخ الإنشاء', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ...reports.map((report) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(report['id']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(report['title']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(report['type']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(report['period']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(DateFormat('yyyy-MM-dd').format(report['generatedDate'])),
                ),
              ],
            )).toList(),
          ],
        ),
      ],
    );
  }

  Future<void> _sharePdfFile(Uint8List pdfBytes, String period) async {
    try {
      final fileName = 'تقرير_النفايات_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      await Share.shareXFiles(
        [
          XFile.fromData(
            pdfBytes,
            name: fileName,
            mimeType: 'application/pdf',
          )
        ],
        subject: 'تقرير النفايات - $period',
        text: 'مرفق تقرير النفايات للفترة $period',
      );

      _showSuccessSnackbar('تم تصدير التقرير بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في مشاركة الملف: $e');
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _successColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _errorColor,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _completeTask(int taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إكمال المهمة'),
        content: const Text('هل أنت متأكد من إكمال هذه المهمة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var task in _todayTasks) {
                  if (task.id == taskId) {
                    task.isCompleted = true;
                    task.status = 'مكتمل';
                    break;
                  }
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إكمال المهمة بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _showReportMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('بلاغ عن مواطن'),
              onTap: () {
                Navigator.pop(context);
                _showCitizenReport();
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning, color: Colors.red),
              title: const Text('تبليغ عن أمر طارئ'),
              onTap: () {
                Navigator.pop(context);
                _showEmergencyReport();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.orange),
              title: const Text('طلب مساعدة'),
              onTap: () {
                Navigator.pop(context);
                _showHelpRequest();
              },
            )
          ],
        ),
      ),
    );
  }

  void _showCitizenReport() {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController violationController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController detailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('بلاغ عن مواطن'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المواطن',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: violationController,
                decoration: const InputDecoration(
                  labelText: 'نوع المخالفة',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'الموقع',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(
                  labelText: 'تفاصيل البلاغ',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال البلاغ'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyReport() {
    TextEditingController emergencyTypeController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController detailsController = TextEditingController();
    List<bool> selectedWorkers = List.filled(_availableWorkers.length, false);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('تبليغ عن أمر طارئ'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emergencyTypeController,
                    decoration: const InputDecoration(
                      labelText: 'نوع الطارئ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'الموقع',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: detailsController,
                    decoration: const InputDecoration(
                      labelText: 'تفاصيل الطارئ',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  const Text('اختر فريق العمل:'),
                  ..._availableWorkers.asMap().entries.map((entry) {
                    int index = entry.key;
                    Worker worker = entry.value;
                    return CheckboxListTile(
                      title: Text(worker.name),
                      subtitle: Text(worker.phone),
                      value: selectedWorkers[index],
                      onChanged: (value) {
                        setState(() {
                          selectedWorkers[index] = value!;
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إرسال البلاغ الطارئ'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('إرسال'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showHelpRequest() {
    TextEditingController helpTypeController = TextEditingController();
    TextEditingController detailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('طلب مساعدة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: helpTypeController,
                decoration: const InputDecoration(
                  labelText: 'نوع المساعدة',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(
                  labelText: 'تفاصيل الطلب',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال طلب المساعدة'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  // دالة للحصول على التاريخ بالعربي
  String _getArabicDate(DateTime date) {
    final dayName = DateFormat('EEEE').format(date);
    final monthName = DateFormat('MMMM').format(date);
    
    return '${_arabicDays[dayName] ?? dayName} ${date.day} ${_arabicMonths[monthName] ?? monthName} ${date.year}';
  }

  // دالة للحصول على الشهر والسنة بالعربي
  String _getArabicMonthYear(DateTime date) {
    final monthName = DateFormat('MMMM').format(date);
    return '${_arabicMonths[monthName] ?? monthName} ${date.year}';
  }

  // دالة للتحقق إذا كان اليوم عطلة نهاية الأسبوع
  bool _isWeekend(DateTime day) {
    return day.weekday == DateTime.friday || day.weekday == DateTime.saturday;
  }
}

class CleanTask {
  final int id;
  final String areaName;
  final String truckNumber;
  final List<String> workers;
  final String startTime;
  final String endTime;
  final DateTime date;
  bool isCompleted;
  String status;

  CleanTask({
    required this.id,
    required this.areaName,
    required this.truckNumber,
    required this.workers,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.isCompleted,
    required this.status,
  });
}

class Worker {
  final int id;
  final String name;
  final String phone;
  final bool isOnDuty;

  Worker({
    required this.id,
    required this.name,
    required this.phone,
    required this.isOnDuty,
  });
}

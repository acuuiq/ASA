import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';

class QualityAuditorScreen extends StatefulWidget {
  const QualityAuditorScreen({super.key});

  @override
  State<QualityAuditorScreen> createState() => _QualityAuditorScreenState();
}

class _QualityAuditorScreenState extends State<QualityAuditorScreen> {
  int _currentIndex = 0;
  
  // بيانات الإنذارات
  final List<Map<String, dynamic>> _activeAlarms = [
    {
      'type': 'انخفاض الجهد',
      'location': 'محطة التحويل الرئيسية - المنطقة الشرقية',
      'time': '10:30:15',
      'severity': 'حرج',
      'value': '195V'
    },
    {
      'type': 'انخفاض التردد',
      'location': 'محطة الغربية - القطاع 5',
      'time': '10:25:43',
      'severity': 'عالي',
      'value': '49.2 Hz'
    },
    {
      'type': 'ارتفاع التيار',
      'location': 'محطة الجنوب - المنطقة الصناعية',
      'time': '09:45:12',
      'severity': 'متوسط',
      'value': '450A'
    },
  ];

  // بيانات البلاغات
  final List<Map<String, dynamic>> _recentComplaints = [
    {
      'id': 'COMP-2024-001',
      'time': '10:15:00',
      'location': 'حي السلام - شارع 10',
      'type': 'رفرفة في الإضاءة',
      'status': 'قيد المراجعة'
    },
    {
      'id': 'COMP-2024-002',
      'time': '09:30:00',
      'location': 'حي النهضة - مجمع 3',
      'type': 'انقطاع متكرر',
      'status': 'تحت التفحص'
    },
  ];

  // بيانات الإشعارات
  final List<Map<String, dynamic>> _allNotifications = [
    {
      'id': '1',
      'type': 'انخفاض الجهد',
      'title': 'إنذار انخفاض الجهد',
      'description': 'تم رصد انخفاض في الجهد الكهربائي في محطة التحويل الرئيسية - المنطقة الشرقية',
      'time': 'منذ 5 دقائق',
      'read': false,
      'tab': 0,
      'priority': 'عالي',
      'area': 'المنطقة الشرقية',
      'location': 'محطة التحويل الرئيسية',
      'value': '195V',
    },
    {
      'id': '2',
      'type': 'انخفاض التردد',
      'title': 'إنذار انخفاض التردد',
      'description': 'تم رصد انخفاض في التردد في محطة الغربية - القطاع 5',
      'time': 'منذ ساعة',
      'read': false,
      'tab': 0,
      'priority': 'متوسط',
      'area': 'المنطقة الغربية',
      'location': 'محطة الغربية',
      'value': '49.2 Hz',
    },
    {
      'id': '3',
      'type': 'ارتفاع التيار',
      'title': 'إنذار ارتفاع التيار',
      'description': 'تم رصد ارتفاع في التيار الكهربائي في محطة الجنوب - المنطقة الصناعية',
      'time': 'منذ 3 ساعات',
      'read': true,
      'tab': 0,
      'priority': 'عالي',
      'area': 'المنطقة الجنوبية',
      'location': 'محطة الجنوب',
      'value': '450A',
    },
    {
      'id': '4',
      'type': 'تقرير جودة',
      'title': 'تقرير الجودة الشهري جاهز',
      'description': 'تم إنشاء تقرير جودة الكهرباء الشهري لشهر يناير 2024 بنجاح',
      'time': 'منذ يوم',
      'read': true,
      'tab': 1,
      'priority': 'منخفض',
      'area': 'جميع المناطق',
      'reportType': 'شهري',
    },
    {
      'id': '5',
      'type': 'تقرير إنذارات',
      'title': 'تقرير الإنذارات الأسبوعي',
      'description': 'تم إنشاء تقرير الإنذارات للأسبوع الحالي - 8 إنذارات جديدة',
      'time': 'منذ يومين',
      'read': true,
      'tab': 1,
      'priority': 'متوسط',
      'area': 'المنطقة الوسطى',
      'reportType': 'أسبوعي',
    },
    {
      'id': '6',
      'type': 'بلاغ جديد',
      'title': 'بلاغ من المواطنين',
      'description': 'تم استلام بلاغ جديد من حي السلام بخصوص رفرفة في الإضاءة',
      'time': 'منذ 30 دقيقة',
      'read': false,
      'tab': 2,
      'priority': 'متوسط',
      'area': 'حي السلام',
      'complaintType': 'رفرفة في الإضاءة',
    },
  ];

  // متغيرات التقارير
  String _selectedArea = 'جميع المناطق';
  String _selectedReportType = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;

  final List<String> _areas = ['جميع المناطق', 'حي الرياض', 'حي النخيل', 'حي العليا', 'حي الصفا'];
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

  // الألوان الحكومية
  final Color _primaryColor = Color(0xFF2E5B96);
  final Color _secondaryColor = Color(0xFFD4AF37);
  final Color _accentColor = Color(0xFF8D6E63);
  final Color _backgroundColor = Color(0xFFF5F5F5);
  final Color _textColor = Color(0xFF212121);
  final Color _textSecondaryColor = Color(0xFF757575);
  final Color _successColor = Color(0xFF2E7D32);
  final Color _errorColor = Color(0xFFD32F2F);
  final Color _borderColor = Color(0xFFE0E0E0);
  final Color _cardColor = Color(0xFFFFFFFF);

  // ألوان الوضع الداكن
  final Color _darkPrimaryColor = Color(0xFF1B5E20);
  final Color _darkBackgroundColor = Color(0xFF121212);
  final Color _darkCardColor = Color(0xFF1E1E1E);
  final Color _darkTextColor = Color(0xFFFFFFFF);
  final Color _darkTextSecondaryColor = Color(0xFFB0B0B0);

  // دوال الإشعارات
  int _getUnreadNotificationsCount() {
    return _allNotifications.where((notification) => !notification['read']).length;
  }

  void _showNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QualityNotificationsScreen()),
    );
  }

  Widget _buildNotificationButton() {
    final unreadCount = _getUnreadNotificationsCount();
    
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
          onPressed: _showNotifications,
        ),
        if (unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                unreadCount > 9 ? '9+' : unreadCount.toString(),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDarkMode ? _darkBackgroundColor : _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'نظام مراقبة جودة الكهرباء',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _primaryColor,
        centerTitle: true,
        elevation: 0,
        actions: [
          _buildNotificationButton(),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: _buildTopTabBar(),
        ),
      ),
      body: _buildCurrentScreen(),
      drawer: _buildGovernmentDrawer(context, isDarkMode),
    );
  }

  // تبويبات الأعلى
  Widget _buildTopTabBar() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: _primaryColor,
        border: Border(
          bottom: BorderSide(color: _secondaryColor, width: 2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: [
            _buildTopTabItem('الرئيسية', 0, Icons.dashboard, isDarkMode),
            _buildTopTabItem('المراقبة', 1, Icons.monitor_heart, isDarkMode),
            _buildTopTabItem('الإنذارات', 2, Icons.warning, isDarkMode),
            _buildTopTabItem('التقارير', 3, Icons.assignment, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTabItem(String title, int index, IconData icon, bool isDarkMode) {
    bool isSelected = _currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? _secondaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildMonitoring();
      case 2:
        return _buildAlarms();
      case 3:
        return _buildReportsView();
      default:
        return _buildDashboard();
    }
  }

  // ========== الشاشة الرئيسية ==========
  Widget _buildDashboard() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKPISection(isDarkMode),
          const SizedBox(height: 20),
          _buildMapSection(isDarkMode),
          const SizedBox(height: 20),
          _buildActiveAlarmsSection(isDarkMode),
          const SizedBox(height: 20),
          _buildRecentComplaintsSection(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildKPISection(bool isDarkMode) {
    return Card(
      elevation: 2,
      color: isDarkMode ? _darkCardColor : _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'مؤشرات الأداء الرئيسية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? _darkTextColor : _primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildKPIItem('البلاغات النشطة', '15', Icons.report_problem, Colors.orange, isDarkMode),
                _buildKPIItem('مناطق تحت المراقبة', '8', Icons.location_on, Colors.green, isDarkMode),
                _buildKPIItem('معدل الجودة', '94.5%', Icons.analytics, Colors.blue, isDarkMode),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPIItem(String title, String value, IconData icon, Color color, bool isDarkMode) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: isDarkMode ? _darkTextSecondaryColor : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection(bool isDarkMode) {
    return Card(
      elevation: 2,
      color: isDarkMode ? _darkCardColor : _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خريطة حالة الشبكة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? _darkTextColor : _primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 50, color: isDarkMode ? Colors.grey : Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'خريطة تفاعلية لحالة جودة الكهرباء',
                      style: TextStyle(color: isDarkMode ? _darkTextSecondaryColor : Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildLegendItem('جيد', Colors.green, isDarkMode),
                _buildLegendItem('تحت المراقبة', Colors.orange, isDarkMode),
                _buildLegendItem('حرج', Colors.red, isDarkMode),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: isDarkMode ? _darkTextColor : _textColor)),
        ],
      ),
    );
  }

  Widget _buildActiveAlarmsSection(bool isDarkMode) {
    return Card(
      elevation: 2,
      color: isDarkMode ? _darkCardColor : _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'الإنذارات النشطة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? _darkTextColor : _primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _activeAlarms.length.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._activeAlarms.map((alarm) => _buildAlarmItem(alarm, isDarkMode)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmItem(Map<String, dynamic> alarm, bool isDarkMode) {
    Color severityColor = Colors.grey;
    switch (alarm['severity']) {
      case 'حرج':
        severityColor = Colors.red;
        break;
      case 'عالي':
        severityColor = Colors.orange;
        break;
      case 'متوسط':
        severityColor = Colors.yellow;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: severityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: severityColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: severityColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alarm['type'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: severityColor,
                  ),
                ),
                Text(alarm['location'], style: TextStyle(fontSize: 12, color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor)),
                Text('القيمة: ${alarm['value']}', style: TextStyle(fontSize: 12, color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor)),
              ],
            ),
          ),
          Column(
            children: [
              Text(alarm['time'], style: TextStyle(fontSize: 12, color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor)),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: const Text('معالجة', style: TextStyle(fontSize: 12,color: Color.fromARGB(255, 255, 255, 255),)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentComplaintsSection(bool isDarkMode) {
    return Card(
      elevation: 2,
      color: isDarkMode ? _darkCardColor : _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'آخر البلاغات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? _darkTextColor : _primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ..._recentComplaints.map((complaint) => _buildComplaintItem(complaint, isDarkMode)),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintItem(Map<String, dynamic> complaint, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.report, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(complaint['id'], style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? _darkTextColor : _textColor)),
                Text(complaint['location'], style: TextStyle(fontSize: 12, color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor)),
                Text(complaint['type'], style: TextStyle(fontSize: 12, color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(complaint['time'], style: TextStyle(fontSize: 12, color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  complaint['status'],
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========== شاشة المراقبة ==========
  Widget _buildMonitoring() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMonitoringCard('الجهد الكهربائي', '230V', '220V - 240V', Icons.bolt, Colors.green, isDarkMode),
          _buildMonitoringCard('التردد', '50.1 Hz', '49.8 - 50.2 Hz', Icons.speed, Colors.blue, isDarkMode),
          _buildMonitoringCard('معامل القدرة', '0.95', '> 0.9', Icons.show_chart, Colors.orange, isDarkMode),
          _buildMonitoringCard('درجة الحرارة', '45°C', '< 60°C', Icons.thermostat, Colors.purple, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildMonitoringCard(String title, String value, String range, IconData icon, Color color, bool isDarkMode) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isDarkMode ? _darkCardColor : _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDarkMode ? _darkTextColor : _textColor)),
                  Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
                  Text('النطاق المسموح: $range', style: TextStyle(fontSize: 12, color: isDarkMode ? _darkTextSecondaryColor : Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }

  // ========== شاشة الإنذارات ==========
  Widget _buildAlarms() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ..._activeAlarms.map((alarm) => _buildDetailedAlarmItem(alarm, isDarkMode)),
      ],
    );
  }

  Widget _buildDetailedAlarmItem(Map<String, dynamic> alarm, bool isDarkMode) {
    Color severityColor = Colors.red;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDarkMode ? _darkCardColor : _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: severityColor),
                const SizedBox(width: 8),
                Text(
                  alarm['type'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: severityColor),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: severityColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    alarm['severity'],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('الموقع: ${alarm['location']}', style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
            Text('الوقت: ${alarm['time']}', style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
            Text('القيمة المسجلة: ${alarm['value']}', style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
                  child: const Text('معالجة الإنذار',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),),),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: Text('تأجيل', style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ========== شاشة التقارير ==========
  Widget _buildReportsView() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

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
                'نظام التقارير - جودة الكهرباء',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? _darkTextColor : _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildAreaFilter(isDarkMode),
          const SizedBox(height: 20),

          _buildReportTypeFilter(isDarkMode),
          const SizedBox(height: 20),

          _buildReportOptions(isDarkMode),
          const SizedBox(height: 20),

          _buildGenerateReportButton(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildAreaFilter(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? _darkCardColor : _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? Colors.white24 : _borderColor),
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
              'المنطقة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white10 : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _primaryColor.withOpacity(0.3)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedArea,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: _primaryColor),
                  items: _areas.map((String area) {
                    return DropdownMenuItem<String>(
                      value: area,
                      child: Text(area, style: TextStyle(
                        color: isDarkMode ? _darkTextColor : _textColor
                      )),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedArea = newValue!;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeFilter(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? _darkCardColor : _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? Colors.white24 : _borderColor),
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
                color: isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _reportTypes.map((type) {
                  final isSelected = _selectedReportType == type;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedReportType = type;
                          _selectedDates.clear();
                          _selectedWeek = null;
                          _selectedMonth = null;
                        });
                      },
                      selectedColor: _primaryColor.withOpacity(0.2),
                      checkmarkColor: _primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? _primaryColor : (isDarkMode ? _darkTextColor : _textColor),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: isSelected ? _primaryColor : (isDarkMode ? Colors.white24 : _borderColor)),
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

  Widget _buildReportOptions(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? _darkCardColor : _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? Colors.white24 : _borderColor),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'خيارات التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedReportType == 'يومي') _buildDailyOptions(isDarkMode),
            if (_selectedReportType == 'أسبوعي') _buildWeeklyOptions(isDarkMode),
            if (_selectedReportType == 'شهري') _buildMonthlyOptions(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyOptions(bool isDarkMode) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _primaryColor.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: _successColor),
                    SizedBox(width: 8),
                    Text(
                      'تم اختيار ${_selectedDates.length} يوم',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'من ${DateFormat('yyyy-MM-dd').format(_selectedDates.reduce((a, b) => a.isBefore(b) ? a : b))} '
                  'إلى ${DateFormat('yyyy-MM-dd').format(_selectedDates.reduce((a, b) => a.isAfter(b) ? a : b))}',
                  style: TextStyle(
                    color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          Text(
            'التواريخ المحددة:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? _darkTextColor : _textColor,
            ),
          ),
          SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 120),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedDates.map((date) {
                  return Chip(
                    backgroundColor: _primaryColor,
                    label: Text(
                      DateFormat('yyyy-MM-dd').format(date),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    deleteIcon: Icon(Icons.close, color: Colors.white, size: 16),
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
              color: isDarkMode ? Colors.white10 : _backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDarkMode ? Colors.white24 : _borderColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined, 
                    color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor, 
                    size: 48),
                SizedBox(height: 12),
                Text(
                  'لم يتم اختيار أي تواريخ',
                  style: TextStyle(
                    color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'انقر على الزر أعلاه لفتح التقويم\nواختيار التواريخ المطلوبة للتقرير',
                  style: TextStyle(
                    color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                    fontSize: 14,
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

  Widget _buildWeeklyOptions(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الأسبوع',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? _darkTextColor : _textColor,
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
                color: isSelected ? _primaryColor : (isDarkMode ? _darkTextColor : _textColor),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : (isDarkMode ? Colors.white24 : _borderColor)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonthlyOptions(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الشهر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? _darkTextColor : _textColor,
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
                color: isSelected ? _primaryColor : (isDarkMode ? _darkTextColor : _textColor),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : (isDarkMode ? Colors.white24 : _borderColor)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenerateReportButton(bool isDarkMode) {
    bool isFormValid = false;
    
    switch (_selectedReportType) {
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
          backgroundColor: isFormValid ? _primaryColor : _textSecondaryColor,
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
              'إنشاء التقرير ${_selectedReportType == 'يومي' && _selectedDates.isNotEmpty ? '(${_selectedDates.length} يوم)' : ''}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showMultiDatePicker() {
    List<DateTime> tempSelectedDates = List.from(_selectedDates);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: _primaryColor),
                        SizedBox(width: 8),
                        Text('اختر التواريخ', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    if (tempSelectedDates.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _primaryColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: _primaryColor, size: 16),
                            SizedBox(width: 8),
                            Text(
                              '${tempSelectedDates.length} يوم محدد',
                              style: TextStyle(
                                color: _primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    Expanded(
                      child: SingleChildScrollView(
                        child: TableCalendar(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: DateTime.now(),
                          
                          onDaySelected: (selectedDay, focusedDay) {
                            final date = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                            
                            setStateDialog(() {
                              if (tempSelectedDates.any((d) => 
                                  d.year == date.year && d.month == date.month && d.day == date.day)) {
                                tempSelectedDates.removeWhere((d) => 
                                    d.year == date.year && d.month == date.month && d.day == date.day);
                              } else {
                                tempSelectedDates.add(date);
                              }
                              tempSelectedDates.sort((a, b) => a.compareTo(b));
                            });
                          },
                          
                          selectedDayPredicate: (day) {
                            return tempSelectedDates.any((selectedDate) =>
                                selectedDate.year == day.year &&
                                selectedDate.month == day.month &&
                                selectedDate.day == day.day);
                          },
                          
                          calendarStyle: CalendarStyle(
                            selectedDecoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _primaryColor, width: 2),
                            ),
                            todayDecoration: BoxDecoration(
                              color: _accentColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            selectedTextStyle: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
                            todayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
                            leftChevronIcon: Icon(Icons.chevron_left, color: _primaryColor),
                            rightChevronIcon: Icon(Icons.chevron_right, color: _primaryColor),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    if (tempSelectedDates.isNotEmpty) ...[
                      Text(
                        'التواريخ المختارة:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 100),
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: tempSelectedDates.map((date) {
                              return Chip(
                                backgroundColor: _primaryColor,
                                label: Text(
                                  DateFormat('yyyy-MM-dd').format(date),
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                deleteIcon: Icon(Icons.close, color: Colors.white, size: 16),
                                onDeleted: () {
                                  setStateDialog(() {
                                    tempSelectedDates.remove(date);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                    
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _errorColor,
                              side: BorderSide(color: _errorColor),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text('إلغاء'),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedDates = List.from(tempSelectedDates);
                              });
                              Navigator.pop(context);
                              _showSuccessSnackbar('تم اختيار ${_selectedDates.length} يوم');
                            },
                            child: Text('تم الاختيار'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _generateReport() {
    if (_selectedReportType == 'يومي' && _selectedDates.isEmpty) {
      _showErrorSnackbar('يرجى اختيار تواريخ أولاً');
      return;
    }

    String reportPeriod = '';
    
    switch (_selectedReportType) {
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
        backgroundColor: _cardColor,
        title: Text('التقرير $period', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('نوع التقرير: $_selectedReportType', style: TextStyle(color: _textColor)),
              if (_selectedReportType == 'يومي' && _selectedDates.isNotEmpty)
                Text('عدد الأيام: ${_selectedDates.length}', style: TextStyle(color: _textColor)),
              if (_selectedWeek != null)
                Text('الأسبوع: $_selectedWeek', style: TextStyle(color: _textColor)),
              if (_selectedMonth != null)
                Text('الشهر: $_selectedMonth', style: TextStyle(color: _textColor)),
              const SizedBox(height: 16),
              Text('ملخص التقرير:', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              Text('- إجمالي الإنذارات: ${_activeAlarms.length}', style: TextStyle(color: _textColor)),
              Text('- البلاغات النشطة: ${_recentComplaints.length}', style: TextStyle(color: _textColor)),
              Text('- معدل الجودة: 94.5%', style: TextStyle(color: _textColor)),
              Text('- مناطق تحت المراقبة: 8', style: TextStyle(color: _textColor)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _textSecondaryColor)),
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

  // ========== دوال PDF والتقارير ==========
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
              _buildPdfSummary(),
              pw.SizedBox(height: 20),
              _buildPdfAlarmsDetails(),
              pw.SizedBox(height: 20),
              _buildPdfComplaintsDetails(),
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

  Future<void> _sharePdfFile(Uint8List pdfBytes, String period) async {
    try {
      final fileName = 'تقرير_جودة_الكهرباء_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      await Share.shareXFiles(
        [
          XFile.fromData(
            pdfBytes,
            name: fileName,
            mimeType: 'application/pdf',
          )
        ],
        subject: 'تقرير جودة الكهرباء - $period',
        text: 'مرفق تقرير جودة الكهرباء للفترة $period',
      );

      _showSuccessSnackbar('تم تصدير التقرير بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في مشاركة الملف: $e');
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
              'وزارة الكهرباء',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
            pw.Text(
              'تقرير مراقبة الجودة',
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
            pw.Text(_selectedReportType),
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
              'المنطقة: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(_selectedArea),
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
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blue),
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
              color: PdfColors.blue,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('إجمالي الإنذارات:'),
              pw.Text('${_activeAlarms.length}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('البلاغات النشطة:'),
              pw.Text('${_recentComplaints.length}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('معدل الجودة:'),
              pw.Text('94.5%'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('مناطق تحت المراقبة:'),
              pw.Text('8'),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfAlarmsDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'تفاصيل الإنذارات',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.blue100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('نوع الإنذار', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الموقع', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الحدة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('القيمة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ..._activeAlarms.map((alarm) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(alarm['type']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(alarm['location']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(alarm['severity']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(alarm['value']),
                ),
              ],
            )).toList(),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPdfComplaintsDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'تفاصيل البلاغات',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.blue100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('رقم البلاغ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الموقع', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('النوع', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الحالة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ..._recentComplaints.map((complaint) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(complaint['id']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(complaint['location']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(complaint['type']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(complaint['status']),
                ),
              ],
            )).toList(),
          ],
        ),
      ],
    );
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

  // ========== القائمة الجانبية ==========
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
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.engineering_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "مدقق جودة الكهرباء",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "مهندس - قسم الجودة",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
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

            Expanded(
              child: Container(
                color: isDarkMode ? Color(0xFF0D1B0E) : Color(0xFFE8F5E9),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(height: 20),
                    
                    _buildDrawerMenuItem(
                      icon: Icons.settings_rounded,
                      title: 'الإعدادات',
                      onTap: () {
                        Navigator.pop(context);
                        _showSettingsScreen(context, isDarkMode);
                      },
                      isDarkMode: isDarkMode,
                    ),
                    
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
                            'وزارة الكهرباء - نظام مراقبة الجودة',
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
            Text('تأكيد تسجيل الخروج',
                style: TextStyle(
                  color: isDarkMode ? _darkTextColor : _textColor
                )),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          style: TextStyle(
            color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'esignin_screen',
                (route) => false,
              );
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

// ========== شاشة الإشعارات ==========
class QualityNotificationsScreen extends StatefulWidget {
  static const String routeName = '/quality-notifications';

  @override
  _QualityNotificationsScreenState createState() => _QualityNotificationsScreenState();
}

class _QualityNotificationsScreenState extends State<QualityNotificationsScreen> {
  final Color _primaryColor = Color(0xFF2E5B96);
  final Color _secondaryColor = Color(0xFFD4AF37);
  final Color _successColor = Color(0xFF2E7D32);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _errorColor = Color(0xFFD32F2F);
  
  Color _backgroundColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFF121212) : Color(0xFFF5F5F5);
  }
  
  Color _cardColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
  }
  
  Color _textColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white : Color(0xFF212121);
  }
  
  Color _textSecondaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFFB0B0B0) : Color(0xFF757575);
  }
  
  Color _borderColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0);
  }

  int _selectedTab = 0;
  final List<String> _tabs = ['الإنذارات', 'التقارير', 'البلاغات', 'الكل'];

  // بيانات الإشعارات (يتم مشاركتها من الشاشة الرئيسية)
  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedTab == 3) {
      return _allNotifications;
    }
    return _allNotifications.where((notification) => notification['tab'] == _selectedTab).toList();
  }

  // نسخة من البيانات للإستخدام المحلي
  final List<Map<String, dynamic>> _allNotifications = [
    {
      'id': '1',
      'type': 'انخفاض الجهد',
      'title': 'إنذار انخفاض الجهد',
      'description': 'تم رصد انخفاض في الجهد الكهربائي في محطة التحويل الرئيسية - المنطقة الشرقية',
      'time': 'منذ 5 دقائق',
      'read': false,
      'tab': 0,
      'priority': 'عالي',
      'area': 'المنطقة الشرقية',
      'location': 'محطة التحويل الرئيسية',
      'value': '195V',
    },
    {
      'id': '2',
      'type': 'انخفاض التردد',
      'title': 'إنذار انخفاض التردد',
      'description': 'تم رصد انخفاض في التردد في محطة الغربية - القطاع 5',
      'time': 'منذ ساعة',
      'read': false,
      'tab': 0,
      'priority': 'متوسط',
      'area': 'المنطقة الغربية',
      'location': 'محطة الغربية',
      'value': '49.2 Hz',
    },
    {
      'id': '3',
      'type': 'ارتفاع التيار',
      'title': 'إنذار ارتفاع التيار',
      'description': 'تم رصد ارتفاع في التيار الكهربائي في محطة الجنوب - المنطقة الصناعية',
      'time': 'منذ 3 ساعات',
      'read': true,
      'tab': 0,
      'priority': 'عالي',
      'area': 'المنطقة الجنوبية',
      'location': 'محطة الجنوب',
      'value': '450A',
    },
    {
      'id': '4',
      'type': 'تقرير جودة',
      'title': 'تقرير الجودة الشهري جاهز',
      'description': 'تم إنشاء تقرير جودة الكهرباء الشهري لشهر يناير 2024 بنجاح',
      'time': 'منذ يوم',
      'read': true,
      'tab': 1,
      'priority': 'منخفض',
      'area': 'جميع المناطق',
      'reportType': 'شهري',
    },
    {
      'id': '5',
      'type': 'تقرير إنذارات',
      'title': 'تقرير الإنذارات الأسبوعي',
      'description': 'تم إنشاء تقرير الإنذارات للأسبوع الحالي - 8 إنذارات جديدة',
      'time': 'منذ يومين',
      'read': true,
      'tab': 1,
      'priority': 'متوسط',
      'area': 'المنطقة الوسطى',
      'reportType': 'أسبوعي',
    },
    {
      'id': '6',
      'type': 'بلاغ جديد',
      'title': 'بلاغ من المواطنين',
      'description': 'تم استلام بلاغ جديد من حي السلام بخصوص رفرفة في الإضاءة',
      'time': 'منذ 30 دقيقة',
      'read': false,
      'tab': 2,
      'priority': 'متوسط',
      'area': 'حي السلام',
      'complaintType': 'رفرفة في الإضاءة',
    },
  ];

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عالي':
        return _errorColor;
      case 'متوسط':
        return _warningColor;
      case 'منخفض':
        return _successColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'انخفاض الجهد':
        return Icons.bolt_rounded;
      case 'انخفاض التردد':
        return Icons.speed_rounded;
      case 'ارتفاع التيار':
        return Icons.power_rounded;
      case 'تقرير جودة':
      case 'تقرير إنذارات':
        return Icons.assignment_rounded;
      case 'بلاغ جديد':
      case 'بلاغ متكرر':
        return Icons.report_problem_rounded;
      case 'صيانة وقائية':
        return Icons.engineering_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final notification = _allNotifications.firstWhere((n) => n['id'] == notificationId);
      notification['read'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        notification['read'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تعيين جميع الإشعارات كمقروءة'),
        backgroundColor: _primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteNotification(String notificationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_rounded, color: _errorColor),
            SizedBox(width: 8),
            Text('حذف الإشعار', style: TextStyle(color: _textColor(context))),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد حذف هذا الإشعار؟',
          style: TextStyle(color: _textColor(context)),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor(context))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allNotifications.removeWhere((n) => n['id'] == notificationId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حذف الإشعار بنجاح'),
                  backgroundColor: _primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
              foregroundColor: Colors.white,
            ),
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getNotificationIcon(notification['type']),
                        color: _primaryColor,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _textColor(context),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            notification['type'],
                            style: TextStyle(
                              color: _textSecondaryColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem('الوصف', notification['description']),
                    _buildDetailItem('المنطقة', notification['area']),
                    _buildDetailItem('الوقت', notification['time']),
                    _buildDetailItem('الأولوية', notification['priority']),
                    
                    if (notification['location'] != null)
                      _buildDetailItem('الموقع', notification['location']),
                    
                    if (notification['value'] != null)
                      _buildDetailItem('القيمة', notification['value']),
                    
                    if (notification['reportType'] != null)
                      _buildDetailItem('نوع التقرير', notification['reportType']),
                    
                    if (notification['complaintType'] != null)
                      _buildDetailItem('نوع البلاغ', notification['complaintType']),
                    
                    SizedBox(height: 20),
                    
                    Row(
                      children: [
                        if (!notification['read'])
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _markAsRead(notification['id']);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: Icon(Icons.check_rounded, size: 20),
                              label: Text('تعيين كمقروء'),
                            ),
                          ),
                        
                        if (!notification['read']) SizedBox(width: 8),
                        
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _deleteNotification(notification['id']),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _errorColor,
                              side: BorderSide(color: _errorColor),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: Icon(Icons.delete_rounded, size: 20),
                            label: Text('حذف'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textColor(context),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: _textSecondaryColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor(context),
      appBar: AppBar(
        title: Text(
          'الإشعارات - مراقبة الجودة',
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
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: Colors.white),
            onSelected: (value) {
              if (value == 'mark_all_read') {
                _markAllAsRead();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read_rounded, color: _primaryColor),
                    SizedBox(width: 8),
                    Text('تعيين الكل كمقروء'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: _cardColor(context),
              border: Border(
                bottom: BorderSide(color: _borderColor(context)),
              ),
            ),
            child: Row(
              children: [
                for (int i = 0; i < _tabs.length; i++)
                  _buildTabButton(_tabs[i], i),
              ],
            ),
          ),

          Container(
            height: 1,
            color: _borderColor(context),
          ),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(color: _borderColor(context)),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.notifications_active_rounded, color: _primaryColor, size: 20),
                SizedBox(width: 8),
                Text(
                  'الإشعارات غير المقروءة: ',
                  style: TextStyle(
                    color: _textColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _filteredNotifications.where((n) => !n['read']).length.toString(),
                  style: TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                if (_filteredNotifications.where((n) => !n['read']).length > 0)
                  TextButton(
                    onPressed: _markAllAsRead,
                    child: Text(
                      'تعيين الكل كمقروء',
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),

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
    final unreadCount = _allNotifications
        .where((n) => n['tab'] == index && !n['read'])
        .length;

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isSelected ? _primaryColor : _textSecondaryColor(context),
                  ),
                ),
                if (unreadCount > 0) ...[
                  SizedBox(width: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardColor(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getNotificationIcon(notification['type']),
                      color: _primaryColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: _textColor(context),
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(notification['priority']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _getPriorityColor(notification['priority']).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                notification['priority'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getPriorityColor(notification['priority']),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: _textSecondaryColor(context),
                            ),
                            SizedBox(width: 4),
                            Text(
                              notification['area'],
                              style: TextStyle(
                                fontSize: 12,
                                color: _textSecondaryColor(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        notification['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: _textSecondaryColor(context),
                        ),
                      ),
                      SizedBox(height: 4),
                      if (!notification['read'])
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              Text(
                notification['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: _textSecondaryColor(context),
                  height: 1.4,
                ),
              ),
              
              SizedBox(height: 8),
              
              if (notification['location'] != null)
                Row(
                  children: [
                    Icon(Icons.place_outlined, size: 14, color: _textSecondaryColor(context)),
                    SizedBox(width: 4),
                    Text(
                      'الموقع: ${notification['location']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              
              if (notification['value'] != null)
                Row(
                  children: [
                    Icon(Icons.speed_outlined, size: 14, color: _textSecondaryColor(context)),
                    SizedBox(width: 4),
                    Text(
                      'القيمة: ${notification['value']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              
              if (notification['reportType'] != null)
                Row(
                  children: [
                    Icon(Icons.description_outlined, size: 14, color: _textSecondaryColor(context)),
                    SizedBox(width: 4),
                    Text(
                      'نوع التقرير: ${notification['reportType']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              
              if (notification['complaintType'] != null)
                Row(
                  children: [
                    Icon(Icons.report_gmailerrorred_outlined, size: 14, color: _textSecondaryColor(context)),
                    SizedBox(width: 4),
                    Text(
                      'نوع البلاغ: ${notification['complaintType']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              
              SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showNotificationDetails(notification),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primaryColor,
                        side: BorderSide(color: _primaryColor),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text('عرض التفاصيل'),
                    ),
                  ),
                  SizedBox(width: 8),
                  if (!notification['read'])
                    IconButton(
                      onPressed: () => _markAsRead(notification['id']),
                      icon: Icon(Icons.check_rounded, color: _successColor),
                      tooltip: 'تعيين كمقروء',
                    ),
                  IconButton(
                    onPressed: () => _deleteNotification(notification['id']),
                    icon: Icon(Icons.delete_outline_rounded, color: _errorColor),
                    tooltip: 'حذف الإشعار',
                  ),
                ],
              ),
            ],
          ),
        ),
        
        Container(
          height: 1,
          color: _borderColor(context),
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
            color: _textSecondaryColor(context),
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لا توجد إشعارات في التبويب المحدد',
            style: TextStyle(
              color: _textSecondaryColor(context),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedTab = 3;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('عرض جميع الإشعارات'),
          ),
        ],
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
                  SizedBox(height: 24),
                  _buildSettingsSection('المظهر', Icons.palette_rounded, themeProvider),
                  
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
              _buildContactCard(context),

              SizedBox(height: 24),

              _buildSectionTitle('الأسئلة الشائعة'),
              ..._buildFAQItems(),

              SizedBox(height: 24),
              _buildSectionTitle('معلومات التطبيق'),
              _buildAppInfoCard(),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

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
          _buildContactItem(Icons.phone_rounded, 'رقم الدعم الفني', '07701234567', true, context),
          _buildContactItem(Icons.phone_rounded, 'رقم الطوارئ', '07801234567', true, context),
          _buildContactItem(Icons.email_rounded, 'البريد الإلكتروني', 'support@electric.gov.iq', false, context),
          _buildContactItem(Icons.access_time_rounded, 'ساعات العمل', '8:00 ص - 4:00 م', false, context),
          _buildContactItem(Icons.location_on_rounded, 'العنوان', 'بغداد - وزارة الكهرباء', false, context),
          SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _makePhoneCall('07701234567', context),
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
                  onPressed: () => _sendEmail(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.email_rounded, size: 20),
                  label: Text('إرسال بريد'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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

  List<Widget> _buildFAQItems() {
    List<Map<String, String>> faqs = [
      {
        'question': 'كيف يمكنني التعامل مع الإنذارات الحرجة؟',
        'answer': 'اذهب إلى قسم الإنذارات → انقر على الإنذار الحرج → اضغط على زر "معالجة" → اتبع الإجراءات المحددة في دليل التشغيل'
      },
      {
        'question': 'كيف أعرض تقرير جودة الكهرباء الشهري؟',
        'answer': 'انتقل إلى قسم التقارير → اختر "تقرير الجودة" → حدد الفترة الزمنية المطلوبة → انقر على "عرض التقرير"'
      },
      {
        'question': 'كيف أتحقق من حالة الشبكة الكهربائية؟',
        'answer': 'اذهب إلى قسم المراقبة → استعرض مؤشرات الجودة (الجهد، التردد، معامل القدرة) → تحقق من الخريطة التفاعلية'
      },
      {
        'question': 'كيف أتعامل مع بلاغات المواطنين؟',
        'answer': 'انتقل إلى قسم البلاغات → استعرض البلاغات الجديدة → انقر على البلاغ → اضغط على "تحديث الحالة" → اختر الإجراء المناسب'
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
          _buildInfoRow('البريد الإلكتروني', 'support@electric.gov.iq'),
        ],
      ),
    );
  }

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

  void _makePhoneCall(String phoneNumber, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري الاتصال بـ $phoneNumber'),
        backgroundColor: primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _sendEmail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري فتح تطبيق البريد الإلكتروني'),
        backgroundColor: primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

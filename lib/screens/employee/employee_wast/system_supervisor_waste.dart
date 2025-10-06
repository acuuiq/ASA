import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SystemSupervisorWasteScreen extends StatefulWidget {
  const SystemSupervisorWasteScreen({super.key});

  @override
  State<SystemSupervisorWasteScreen> createState() => _SystemSupervisorWasteScreenState();
}

class _SystemSupervisorWasteScreenState extends State<SystemSupervisorWasteScreen> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _systemMetrics = [
    {'title': 'الحاويات النشطة', 'value': '147', 'icon': Icons.delete, 'color': Colors.green},
    {'title': 'الحاويات الكاملة', 'value': '23', 'icon': Icons.warning, 'color': Colors.orange},
    {'title': 'الحاويات المعطلة', 'value': '5', 'icon': Icons.error, 'color': Colors.red},
    {'title': 'معدل التجميع', 'value': '92%', 'icon': Icons.trending_up, 'color': Colors.blue},
  ];

<<<<<<< Updated upstream
  final List<Map<String, dynamic>> _recentAlerts = [
    {'time': '10:30 ص', 'message': 'الحاوية #45 وصلت إلى السعة القصوى', 'type': 'warning'},
    {'time': '09:15 ص', 'message': 'خلل في نظام التتبع للحاوية #12', 'type': 'error'},
    {'time': '08:45 ص', 'message': 'انتهت الصيانة الدورية للحاوية #78', 'type': 'info'},
    {'time': '07:30 ص', 'message': 'بدء عملية التجميع في المنطقة الشمالية', 'type': 'info'},
  ];
=======
  // بيانات التطبيق
  final int _totalReports = 187;
  final int _pendingReports = 32;
  final int _resolvedReports = 155;
  final int _activeTeams = 12;
  final int _totalContainers = 420;
  
  late TabController _tabController;
>>>>>>> Stashed changes

  // البيانات الخاصة بشاشة التقارير
  final List<Map<String, dynamic>> _reports = [
    {'title': 'تقرير الأداء اليومي', 'date': '2024-01-15', 'type': 'daily'},
    {'title': 'تقرير الأسبوعي للحاويات', 'date': '2024-01-14', 'type': 'weekly'},
    {'title': 'تقرير الصيانة الشهري', 'date': '2024-01-10', 'type': 'monthly'},
    {'title': 'تقرير الطوارئ', 'date': '2024-01-08', 'type': 'emergency'},
  ];

  // الإعدادات
  bool _notificationsEnabled = true;
  bool _autoBackupEnabled = false;
  bool _systemMonitoringEnabled = true;
  String _selectedLanguage = 'العربية';
  String _selectedTheme = 'تلقائي';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A0E21) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 17, 126, 117),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: _currentIndex == 0 ? [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotifications,
          ),
        ] : null,
      ),
      body: _buildCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedLabelStyle: const TextStyle(fontFamily: 'Tajawal'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Tajawal'),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'التقارير',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'لوحة تحكم مشرف النظام - النفايات';
      case 1:
        return 'التقارير والإحصائيات';
      case 2:
        return 'إعدادات النظام';
      default:
        return 'لوحة التحكم';
    }
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboardScreen();
      case 1:
        return _buildReportsScreen();
      case 2:
        return _buildSettingsScreen();
      default:
        return _buildDashboardScreen();
    }
  }

  // شاشة الرئيسية
  Widget _buildDashboardScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 20),
          const Text(
            'مؤشرات النظام',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 10),
          _buildMetricsGrid(),
          const SizedBox(height: 20),
          _buildAlertsSection(),
          const SizedBox(height: 20),
          _buildQuickActions(),
        ],
      ),
    );
  }

  // شاشة التقارير
  Widget _buildReportsScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // إحصائيات سريعة
          _buildReportsStats(),
          const SizedBox(height: 20),
          
          // أنواع التقارير
          const Text(
            'أنواع التقارير',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 10),
          _buildReportTypes(),
          const SizedBox(height: 20),
          
          // التقارير الحديثة
          const Text(
            'التقارير الحديثة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 10),
          _buildRecentReports(),
        ],
      ),
    );
  }

  // شاشة الإعدادات
  Widget _buildSettingsScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // إعدادات النظام
          _buildSystemSettings(),
          const SizedBox(height: 20),
          
          // إعدادات المظهر
          _buildAppearanceSettings(),
          const SizedBox(height: 20),
          
          // إعدادات الخصوصية
          _buildPrivacySettings(),
          const SizedBox(height: 20),
          
          // إجراءات النظام
          _buildSystemActions(),
        ],
      ),
    );
  }

  Widget _buildReportsStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 74, 20, 140),
            Color.fromARGB(255, 142, 45, 226),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('24', 'تقرير هذا الشهر', Icons.description),
          _buildStatItem('8', 'تقارير الطوارئ', Icons.warning),
          _buildStatItem('95%', 'معدل الإنجاز', Icons.trending_up),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _buildReportTypes() {
    final List<Map<String, dynamic>> reportTypes = [
      {'type': 'daily', 'title': 'التقارير اليومية', 'icon': Icons.today, 'color': Colors.blue},
      {'type': 'weekly', 'title': 'التقارير الأسبوعية', 'icon': Icons.date_range, 'color': Colors.green},
      {'type': 'monthly', 'title': 'التقارير الشهرية', 'icon': Icons.calendar_month, 'color': Colors.orange},
      {'type': 'emergency', 'title': 'تقارير الطوارئ', 'icon': Icons.emergency, 'color': Colors.red},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: reportTypes.length,
      itemBuilder: (context, index) {
        final type = reportTypes[index];
        return Card(
          elevation: 3,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _generateReport(type['type']),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(type['icon'], color: type['color'], size: 35),
                const SizedBox(height: 8),
                Text(
                  type['title'],
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentReports() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _reports.length,
      itemBuilder: (context, index) {
        final report = _reports[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: _getReportIcon(report['type']),
            title: Text(
              report['title'],
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            subtitle: Text(
              report['date'],
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _downloadReport(report),
            ),
            onTap: () => _viewReport(report),
          ),
        );
      },
    );
  }

  Widget _buildSystemSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إعدادات النظام',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 15),
            _buildSettingSwitch(
              'التنبيهات والإشعارات',
              _notificationsEnabled,
              (value) => setState(() => _notificationsEnabled = value),
              Icons.notifications,
            ),
            _buildSettingSwitch(
              'النسخ الاحتياطي التلقائي',
              _autoBackupEnabled,
              (value) => setState(() => _autoBackupEnabled = value),
              Icons.backup,
            ),
            _buildSettingSwitch(
              'مراقبة النظام التلقائية',
              _systemMonitoringEnabled,
              (value) => setState(() => _systemMonitoringEnabled = value),
              Icons.monitor_heart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إعدادات المظهر',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 15),
            _buildSettingDropdown(
              'اللغة',
              _selectedLanguage,
              ['العربية', 'English', 'Français'],
              Icons.language,
              (value) => setState(() => _selectedLanguage = value!),
            ),
            _buildSettingDropdown(
              'المظهر',
              _selectedTheme,
              ['تلقائي', 'مضيء', 'مظلم'],
              Icons.palette,
              (value) => setState(() => _selectedTheme = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الخصوصية والأمان',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 15),
            // تم حذف تغيير كلمة المرور من هنا
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('سجل النشاطات', style: TextStyle(fontFamily: 'Tajawal')),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showActivityLog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إجراءات النظام',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 15),
            _buildActionButton('نسخ احتياطي للنظام', Icons.backup, Colors.blue, _backupSystem),
            _buildActionButton('استعادة النظام', Icons.restore, Colors.orange, _restoreSystem),
            _buildActionButton('مسح ذاكرة التخزين', Icons.cleaning_services, Colors.red, _clearCache),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSwitch(String title, bool value, Function(bool) onChanged, IconData icon) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontFamily: 'Tajawal')),
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon),
    );
  }

  Widget _buildSettingDropdown(String title, String value, List<String> items, IconData icon, Function(String?) onChanged) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontFamily: 'Tajawal')),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(fontFamily: 'Tajawal')),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, Function onPressed) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(fontFamily: 'Tajawal')),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: () => onPressed(),
      ),
      onTap: () => onPressed(),
    );
  }

  Icon _getReportIcon(String type) {
    switch (type) {
      case 'daily':
        return const Icon(Icons.today, color: Colors.blue);
      case 'weekly':
        return const Icon(Icons.date_range, color: Colors.green);
      case 'monthly':
        return const Icon(Icons.calendar_month, color: Colors.orange);
      case 'emergency':
        return const Icon(Icons.emergency, color: Colors.red);
      default:
        return const Icon(Icons.description);
    }
  }

  void _generateReport(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري إنشاء تقرير ${_getReportTypeName(type)}...', style: const TextStyle(fontFamily: 'Tajawal')),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _downloadReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل ${report['title']}...', style: const TextStyle(fontFamily: 'Tajawal')),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _viewReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report['title'], style: const TextStyle(fontFamily: 'Tajawal')),
        content: Text('عرض تفاصيل ${report['title']}...', style: const TextStyle(fontFamily: 'Tajawal')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  String _getReportTypeName(String type) {
    switch (type) {
      case 'daily':
        return 'يومي';
      case 'weekly':
        return 'أسبوعي';
      case 'monthly':
        return 'شهري';
      case 'emergency':
        return 'طوارئ';
      default:
        return '';
    }
  }

  void _showActivityLog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('سجل النشاطات', style: TextStyle(fontFamily: 'Tajawal')),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: const [
              ListTile(
                title: Text('تسجيل دخول - 10:30 ص', style: TextStyle(fontFamily: 'Tajawal')),
                subtitle: Text('تم تسجيل الدخول بنجاح', style: TextStyle(fontFamily: 'Tajawal')),
              ),
              ListTile(
                title: Text('إنشاء تقرير - 09:15 ص', style: TextStyle(fontFamily: 'Tajawal')),
                subtitle: Text('تم إنشاء تقرير الأداء اليومي', style: TextStyle(fontFamily: 'Tajawal')),
              ),
              ListTile(
                title: Text('تعديل إعدادات - 08:45 ص', style: TextStyle(fontFamily: 'Tajawal')),
                subtitle: Text('تم تحديث إعدادات النظام', style: TextStyle(fontFamily: 'Tajawal')),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  void _backupSystem() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري إنشاء نسخة احتياطية للنظام...', style: TextStyle(fontFamily: 'Tajawal')),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _restoreSystem() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري استعادة النظام من النسخة الاحتياطية...', style: TextStyle(fontFamily: 'Tajawal')),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح ذاكرة التخزين', style: TextStyle(fontFamily: 'Tajawal')),
        content: const Text('هل أنت متأكد من رغبتك في مسح ذاكرة التخزين المؤقت؟', style: TextStyle(fontFamily: 'Tajawal')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم مسح ذاكرة التخزين بنجاح', style: TextStyle(fontFamily: 'Tajawal')),
                ),
              );
            },
            child: const Text('تأكيد', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  // الدوال الموجودة سابقاً (للشاشة الرئيسية)
  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 17, 126, 117),
            Color.fromARGB(255, 16, 78, 88),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.supervisor_account,
              color: Color.fromARGB(255, 17, 126, 117),
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مرحباً بك، مشرف النظام',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'النظام يعمل بشكل طبيعي - آخر تحديث: ${_getCurrentTime()}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: _systemMetrics.length,
      itemBuilder: (context, index) {
        final metric = _systemMetrics[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                metric['icon'],
                size: 40,
                color: metric['color'],
              ),
              const SizedBox(height: 8),
              Text(
                metric['value'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: metric['color'],
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                metric['title'],
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Tajawal',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAlertsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'التنبيهات الحديثة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._recentAlerts.map((alert) => _buildAlertItem(alert)),
        ],
      ),
    );
  }

  Widget _buildAlertItem(Map<String, dynamic> alert) {
    Color alertColor = Colors.blue;
    if (alert['type'] == 'warning') alertColor = Colors.orange;
    if (alert['type'] == 'error') alertColor = Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: alertColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: alertColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            alert['type'] == 'error' ? Icons.error : 
            alert['type'] == 'warning' ? Icons.warning : Icons.info,
            color: alertColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['message'],
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: alertColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert['time'],
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: alertColor.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final List<Map<String, dynamic>> actions = [
      {'icon': Icons.analytics, 'title': 'تقارير الأداء', 'color': Colors.purple},
      {'icon': Icons.settings, 'title': 'إعدادات النظام', 'color': Colors.blue},
      {'icon': Icons.backup, 'title': 'نسخ احتياطي', 'color': Colors.orange},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الإجراءات السريعة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return Card(
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _handleQuickAction(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(action['icon'], color: action['color'], size: 30),
                    const SizedBox(height: 8),
                    Text(
                      action['title'],
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('التنبيهات', style: TextStyle(fontFamily: 'Tajawal')),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _recentAlerts.length,
            itemBuilder: (context, index) {
              final alert = _recentAlerts[index];
              return ListTile(
                leading: Icon(
                  alert['type'] == 'error' ? Icons.error : 
                  alert['type'] == 'warning' ? Icons.warning : Icons.info,
                  color: alert['type'] == 'error' ? Colors.red : 
                         alert['type'] == 'warning' ? Colors.orange : Colors.blue,
                ),
                title: Text(alert['message'], style: const TextStyle(fontFamily: 'Tajawal')),
                subtitle: Text(alert['time'], style: const TextStyle(fontFamily: 'Tajawal')),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  void _handleQuickAction(int index) {
    switch (index) {
      case 0: // تقارير الأداء
        setState(() {
          _currentIndex = 1;
        });
        break;
      case 1: // إعدادات النظام
        setState(() {
          _currentIndex = 2;
        });
        break;
      case 2: // نسخ احتياطي
        _showBackupDialog();
        break;
    }
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('نسخ احتياطي للنظام', style: TextStyle(fontFamily: 'Tajawal')),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.backup, size: 50, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              'هل تريد إنشاء نسخة احتياطية كاملة للنظام؟',
              style: TextStyle(fontFamily: 'Tajawal'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performBackup();
            },
            child: const Text('تأكيد', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  void _performBackup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري إنشاء نسخة احتياطية...', style: TextStyle(fontFamily: 'Tajawal')),
        duration: Duration(seconds: 2),
      ),
    );
    
    // محاكاة عملية النسخ الاحتياطي
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إنشاء النسخة الاحتياطية بنجاح', style: TextStyle(fontFamily: 'Tajawal')),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    });
  }
}
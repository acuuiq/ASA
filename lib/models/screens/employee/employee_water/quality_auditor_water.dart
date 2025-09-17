import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// شاشة مخصصة لموظف مراقبة جودة المياه
class QualityAuditorWaterScreen extends StatefulWidget {
  static const String screenRoute = 'quality_auditor_water';

  const QualityAuditorWaterScreen({super.key});

  @override
  _QualityAuditorWaterScreenState createState() =>
      _QualityAuditorWaterScreenState();
}

class _QualityAuditorWaterScreenState extends State<QualityAuditorWaterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  bool _isLoading = true;
  Map<String, dynamic>? _userProfile;

  // الألوان المميزة لموضوع جودة المياه
  final Color _primaryColor = const Color(0xFF0063B3); // أزرق مائي رسمي
  final Color _secondaryColor = const Color(0xFF0096D6);
  final Color _accentColor = const Color(0xFF00B8D4);
  final Color _backgroundColor = const Color(0xFFF5F9FC);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _borderColor = const Color(0xFFE0E0E0);

  // القوائم والخدمات الخاصة بموظف مراقبة جودة المياه
  final List<Map<String, dynamic>> _tabs = [
    {'title': 'العينات', 'icon': Icons.science, 'color': Color(0xFF0063B3)},
    {'title': 'التقارير', 'icon': Icons.assessment, 'color': Color(0xFF0096D6)},
    {'title': 'المناطق', 'icon': Icons.location_on, 'color': Color(0xFF00B8D4)},
  ];

  final List<Map<String, dynamic>> _samples = [
    {
      'id': 'SAM-001',
      'location': 'حي الرياض - محطة التوزيع الرئيسية',
      'date': DateTime.now().subtract(Duration(hours: 2)),
      'status': 'pending',
      'ph': 7.2,
      'turbidity': 0.8,
      'chlorine': 0.5,
      'temperature': 25.0,
    },
    {
      'id': 'SAM-002',
      'location': 'حي المصيف - خزان العلوي',
      'date': DateTime.now().subtract(Duration(days: 1)),
      'status': 'approved',
      'ph': 7.5,
      'turbidity': 0.5,
      'chlorine': 0.6,
      'temperature': 26.0,
    },
    {
      'id': 'SAM-003',
      'location': 'حي المنتزه - محطة المعالجة',
      'date': DateTime.now().subtract(Duration(days: 2)),
      'status': 'rejected',
      'ph': 6.8,
      'turbidity': 1.2,
      'chlorine': 0.3,
      'temperature': 24.0,
    },
  ];

  final List<Map<String, dynamic>> _reports = [
    {
      'title': 'تقرير الجودة الأسبوعي',
      'date': DateTime.now().subtract(Duration(days: 1)),
      'status': 'مكتمل',
      'type': 'أسبوعي',
    },
    {
      'title': 'تقرير المشاكل الفنية',
      'date': DateTime.now().subtract(Duration(days: 3)),
      'status': 'قيد المراجعة',
      'type': 'فني',
    },
    {
      'title': 'تقرير الصيانة الدورية',
      'date': DateTime.now().subtract(Duration(days: 5)),
      'status': 'مكتمل',
      'type': 'دوري',
    },
  ];

  final List<Map<String, dynamic>> _areas = [
    {
      'name': 'حي الرياض',
      'status': 'جيد',
      'lastCheck': DateTime.now().subtract(Duration(hours: 4)),
      'samplesCount': 12,
    },
    {
      'name': 'حي المصيف',
      'status': 'ممتاز',
      'lastCheck': DateTime.now().subtract(Duration(hours: 6)),
      'samplesCount': 8,
    },
    {
      'name': 'حي المنتزه',
      'status': 'تحت المراقبة',
      'lastCheck': DateTime.now().subtract(Duration(hours: 1)),
      'samplesCount': 5,
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  Future<void> _checkUserStatus() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          'signin_screen', // تم التصحيح هنا
          (route) => false,
        );
        return;
      }

      final userData = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        _userProfile = userData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error checking user status: $e');
      Navigator.pushNamedAndRemoveUntil(
        context,
        'signin_screen', // تم التصحيح هنا
        (route) => false,
      );
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: _backgroundColor,
        body: Center(child: CircularProgressIndicator(color: _primaryColor)),
      );
    }

    final currentTab = _tabs[_currentIndex];
    final tabColor = currentTab['color'] as Color;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: _primaryColor,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.water_drop, size: 32, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'مراقبة جودة المياه',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        leading: _buildProfileButton(),
        actions: [
          _buildNotificationButton(),
          IconButton(
            icon: Icon(Icons.add, size: 28, color: Colors.white),
            onPressed: _addNewSample,
            tooltip: 'إضافة عينة جديدة',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: _borderColor, width: 1)),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                border: Border(bottom: BorderSide(width: 3, color: tabColor)),
              ),
              labelColor: tabColor,
              unselectedLabelColor: _textSecondaryColor,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: _tabs.map((tab) {
                return Tab(
                  icon: Icon(tab['icon'], size: 22),
                  text: tab['title'],
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildSamplesTab(), _buildReportsTab(), _buildAreasTab()],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: _addNewSample,
        child: Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }

  // باقي الكود بدون تغيير...
  Widget _buildSamplesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatsCard(),
          SizedBox(height: 20),
          ..._samples.map((sample) => _buildSampleCard(sample)).toList(),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildQuickActions(),
          SizedBox(height: 20),
          ..._reports.map((report) => _buildReportCard(report)).toList(),
        ],
      ),
    );
  }

  Widget _buildAreasTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMapOverview(),
          SizedBox(height: 20),
          ..._areas.map((area) => _buildAreaCard(area)).toList(),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_primaryColor.withOpacity(0.8), _primaryColor],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              Icons.science,
              'العينات',
              '${_samples.length}',
              Colors.white,
            ),
            _buildStatItem(Icons.check_circle, 'المقبولة', '1', Colors.green),
            _buildStatItem(Icons.warning, 'المرفوضة', '1', Colors.orange),
            _buildStatItem(Icons.schedule, 'قيد الانتظار', '1', Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildSampleCard(Map<String, dynamic> sample) {
    Color statusColor;
    String statusText;

    switch (sample['status']) {
      case 'approved':
        statusColor = _successColor;
        statusText = 'مقبولة';
        break;
      case 'rejected':
        statusColor = _errorColor;
        statusText = 'مرفوضة';
        break;
      default:
        statusColor = _warningColor;
        statusText = 'قيد الانتظار';
    }

    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _showSampleDetails(sample),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sample['id'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor, width: 1),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                sample['location'],
                style: TextStyle(fontSize: 14, color: _textSecondaryColor),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: _textSecondaryColor,
                  ),
                  SizedBox(width: 4),
                  Text(
                    DateFormat('yyyy-MM-dd - HH:mm').format(sample['date']),
                    style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildParameterItem('pH', '${sample['ph']}', Icons.science),
                  _buildParameterItem(
                    'العكورة',
                    '${sample['turbidity']} NTU',
                    Icons.opacity,
                  ),
                  _buildParameterItem(
                    'الكلور',
                    '${sample['chlorine']} mg/L',
                    Icons.clean_hands,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParameterItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: _primaryColor),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(title, style: TextStyle(fontSize: 10, color: _textSecondaryColor)),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإجراءات السريعة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.add, 'عينة جديدة', _addNewSample),
                _buildActionButton(
                  Icons.assessment,
                  'تقرير جديد',
                  _createNewReport,
                ),
                _buildActionButton(Icons.notifications, 'تنبيهات', _showAlerts),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String text,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 24, color: _primaryColor),
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: _primaryColor.withOpacity(0.1),
            padding: EdgeInsets.all(12),
          ),
        ),
        SizedBox(height: 4),
        Text(text, style: TextStyle(fontSize: 12, color: _textSecondaryColor)),
      ],
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report['title'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(report['type'], style: TextStyle(fontSize: 12)),
                  backgroundColor: _primaryColor.withOpacity(0.1),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: _textSecondaryColor,
                ),
                SizedBox(width: 4),
                Text(
                  DateFormat('yyyy-MM-dd').format(report['date']),
                  style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                ),
                Spacer(),
                Text(
                  report['status'],
                  style: TextStyle(
                    fontSize: 12,
                    color: report['status'] == 'مكتمل'
                        ? _successColor
                        : _warningColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _viewReport(report),
                  child: Text(
                    'عرض التقرير',
                    style: TextStyle(color: _primaryColor),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _downloadReport(report),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text('تحميل', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapOverview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 200,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _primaryColor.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خريطة المناطق',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Center(
              child: Icon(
                Icons.map,
                size: 64,
                color: _primaryColor.withOpacity(0.3),
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: Text(
                'خريطة تفاعلية للمناطق الخاضعة للمراقبة',
                style: TextStyle(fontSize: 12, color: _textSecondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaCard(Map<String, dynamic> area) {
    Color statusColor;
    switch (area['status']) {
      case 'ممتاز':
        statusColor = _successColor;
        break;
      case 'جيد':
        statusColor = Colors.green;
        break;
      case 'تحت المراقبة':
        statusColor = _warningColor;
        break;
      default:
        statusColor = _textSecondaryColor;
    }

    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  area['name'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    area['status'],
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: _textSecondaryColor,
                ),
                SizedBox(width: 4),
                Text(
                  'آخر فحص: ${DateFormat('yyyy-MM-dd - HH:mm').format(area['lastCheck'])}',
                  style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.science, size: 14, color: _textSecondaryColor),
                SizedBox(width: 4),
                Text(
                  'عدد العينات: ${area['samplesCount']}',
                  style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                ),
              ],
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: area['status'] == 'ممتاز'
                  ? 0.9
                  : area['status'] == 'جيد'
                  ? 0.7
                  : 0.4,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton() {
    return IconButton(
      icon: Icon(Icons.person, color: Colors.white, size: 24),
      onPressed: _showProfileDialog,
      tooltip: 'الملف الشخصي',
    );
  }

  Widget _buildNotificationButton() {
    return IconButton(
      icon: Icon(Icons.notifications, color: Colors.white, size: 24),
      onPressed: _showNotifications,
      tooltip: 'الإشعارات',
    );
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الملف الشخصي - مراقب الجودة'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: _primaryColor.withOpacity(0.1),
                child: Icon(Icons.person, size: 40, color: _primaryColor),
              ),
              SizedBox(height: 16),
              Text(
                _userProfile?['full_name'] ?? 'مراقب الجودة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                _userProfile?['email'] ?? 'quality@water.gov.sa',
                style: TextStyle(fontSize: 14, color: _textSecondaryColor),
              ),
              SizedBox(height: 16),
              Divider(),
              ListTile(
                leading: Icon(Icons.work, color: _primaryColor),
                title: Text('مراقب جودة المياه'),
                subtitle: Text('إدارة جودة المياه'),
              ),
              ListTile(
                leading: Icon(Icons.phone, color: _primaryColor),
                title: Text('هاتف العمل'),
                subtitle: Text('+966 11 123 4567'),
              ),
              ListTile(
                leading: Icon(Icons.date_range, color: _primaryColor),
                title: Text('تاريخ التعيين'),
                subtitle: Text('2023-01-15'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'إشعارات الجودة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildNotificationItem(
                    'عينة جديدة مطلوبة',
                    'مطلوب أخذ عينة من حي المنتزه',
                    Icons.science,
                    Colors.blue,
                  ),
                  _buildNotificationItem(
                    'تقرير جودة أسبوعي',
                    'حان وقت إعداد التقرير الأسبوعي',
                    Icons.assessment,
                    Colors.green,
                  ),
                  _buildNotificationItem(
                    'تنبيه جودة',
                    'انخفاض في مستوى الكلور بحي الرياض',
                    Icons.warning,
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String message,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(message),
      trailing: Text(
        '2h',
        style: TextStyle(fontSize: 12, color: _textSecondaryColor),
      ),
      onTap: () {},
    );
  }

  void _addNewSample() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إضافة عينة جديدة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'موقع العينة')),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: 'رقم العينة')),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: 'درجة الحرارة')),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: 'مستوى pH')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إضافة العينة بنجاح'),
                  backgroundColor: _successColor,
                ),
              );
            },
            child: Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showSampleDetails(Map<String, dynamic> sample) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل العينة ${sample['id']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الموقع: ${sample['location']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'التاريخ: ${DateFormat('yyyy-MM-dd - HH:mm').format(sample['date'])}',
              ),
              SizedBox(height: 16),
              Divider(),
              Text('القياسات:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildMeasurementItem(
                'درجة الحموضة (pH)',
                '${sample['ph']}',
                '6.5-8.5',
              ),
              _buildMeasurementItem(
                'العكورة',
                '${sample['turbidity']} NTU',
                '<1.0 NTU',
              ),
              _buildMeasurementItem(
                'الكلور المتبقي',
                '${sample['chlorine']} mg/L',
                '0.2-0.5 mg/L',
              ),
              _buildMeasurementItem(
                'درجة الحرارة',
                '${sample['temperature']}°C',
                '<30°C',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () => _editSample(sample),
            child: Text('تعديل'),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementItem(
    String parameter,
    String value,
    String standard,
  ) {
    bool isWithinStandard =
        true; // This would be calculated based on actual values
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isWithinStandard ? Icons.check_circle : Icons.warning,
        color: isWithinStandard ? _successColor : _errorColor,
      ),
      title: Text(parameter),
      subtitle: Text('$value (المعيار: $standard)'),
    );
  }

  void _editSample(Map<String, dynamic> sample) {
    // Implementation for editing sample
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم فتح نموذج التعديل'),
        backgroundColor: _primaryColor,
      ),
    );
  }

  void _createNewReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إنشاء تقرير جديد'),
        backgroundColor: _successColor,
      ),
    );
  }

  void _showAlerts() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('عرض التنبيهات'), backgroundColor: _warningColor),
    );
  }

  void _viewReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('عرض التقرير: ${report['title']}'),
        backgroundColor: _primaryColor,
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
}

// يجب إضافة هذا في ملف الملاحة الرئيسي أو ملف التوجيه
class NavigationHelper {
  static void navigateToQualityAuditor(BuildContext context) {
    Navigator.pushNamed(context, QualityAuditorWaterScreen.screenRoute);
  }
}

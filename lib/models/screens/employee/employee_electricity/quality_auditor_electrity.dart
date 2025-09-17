import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QualityAuditorScreen extends StatefulWidget {
  @override
  _QualityAuditorScreenState createState() => _QualityAuditorScreenState();
}

class _QualityAuditorScreenState extends State<QualityAuditorScreen> {
  final List<Map<String, dynamic>> qualityMetrics = [
    {
      'metric': 'جودة الخدمة',
      'score': '94%',
      'target': '90%',
      'trend': Icons.trending_up,
      'color': Color(0xFF2E7D32),
      'icon': Icons.engineering,
    },
    {
      'metric': 'وقت الاستجابة',
      'score': '2.1 ساعة',
      'target': '2.5 ساعة',
      'trend': Icons.trending_up,
      'color': Color(0xFF2E7D32),
      'icon': Icons.access_time,
    },
    {
      'metric': 'رضا العملاء',
      'score': '91%',
      'target': '88%',
      'trend': Icons.trending_up,
      'color': Color(0xFF2E7D32),
      'icon': Icons.people,
    },
    {
      'metric': 'معدل الأخطاء',
      'score': '2.3%',
      'target': '1.5%',
      'trend': Icons.trending_down,
      'color': Color(0xFFD32F2F),
      'icon': Icons.warning,
    },
  ];

  final List<Map<String, dynamic>> auditTasks = [
    {
      'id': 'AUDIT-001',
      'department': 'خدمة العملاء',
      'type': 'مراجعة جودة المكالمات',
      'dueDate': DateTime.now().add(Duration(days: 3)),
      'status': 'مخطط',
      'priority': 'medium',
    },
    {
      'id': 'AUDIT-002',
      'department': 'الفنيين',
      'type': 'تدقيق أعمال الصيانة',
      'dueDate': DateTime.now().add(Duration(days: 1)),
      'status': 'عاجل',
      'priority': 'high',
    },
    {
      'id': 'AUDIT-003',
      'department': 'المحاسبة',
      'type': 'مراجعة الفواتير',
      'dueDate': DateTime.now().subtract(Duration(days: 2)),
      'status': 'متأخر',
      'priority': 'critical',
    },
  ];

  final List<Map<String, dynamic>> allCompletedAudits = [
    {
      'id': 'AUDIT-004',
      'department': 'خدمة العملاء',
      'type': 'مراجعة الشكاوى',
      'completionDate': DateTime.now().subtract(Duration(days: 5)),
      'result': 'ممتاز',
      'score': '95%',
      'color': Color(0xFF2E7D32),
    },
    {
      'id': 'AUDIT-005',
      'department': 'الفنيين',
      'type': 'فحص الجودة الميداني',
      'completionDate': DateTime.now().subtract(Duration(days: 3)),
      'result': 'جيد جداً',
      'score': '88%',
      'color': Color(0xFF1976D2),
    },
    {
      'id': 'AUDIT-006',
      'department': 'الدعم الفني',
      'type': 'مراجعة وقت الاستجابة',
      'completionDate': DateTime.now().subtract(Duration(days: 1)),
      'result': 'مقبول',
      'score': '76%',
      'color': Color(0xFFF57C00),
    },
    {
      'id': 'AUDIT-007',
      'department': 'خدمة العملاء',
      'type': 'مراجعة الاستبيانات',
      'completionDate': DateTime.now().subtract(Duration(days: 40)),
      'result': 'جيد',
      'score': '82%',
      'color': Color(0xFF1976D2),
    },
    {
      'id': 'AUDIT-008',
      'department': 'المبيعات',
      'type': 'مراجعة العقود',
      'completionDate': DateTime.now().subtract(Duration(days: 100)),
      'result': 'ممتاز',
      'score': '96%',
      'color': Color(0xFF2E7D32),
    },
  ];

  List<Map<String, dynamic>> completedAudits = [];

  // متغيرات الفلترة
  final List<String> filterOptions = [
    'آخر 30 يوم',
    'آخر أسبوع',
    'آخر 3 أشهر',
    'هذا العام',
    'الكل',
  ];
  String selectedFilter = 'آخر 30 يوم';

  // الألوان المستوحاة من التصميم الحكومي
  final Color _primaryColor = const Color(0xFF0D47A1);
  final Color _secondaryColor = const Color(0xFF1976D2);
  final Color _accentColor = const Color(0xFF64B5F6);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _borderColor = const Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    _filterCompletedAudits();
  }

  // دالة التصفية
  void _filterCompletedAudits() {
    DateTime now = DateTime.now();
    setState(() {
      if (selectedFilter == 'آخر أسبوع') {
        completedAudits = allCompletedAudits.where((audit) {
          return audit['completionDate'].isAfter(
            now.subtract(Duration(days: 7)),
          );
        }).toList();
      } else if (selectedFilter == 'آخر 30 يوم') {
        completedAudits = allCompletedAudits.where((audit) {
          return audit['completionDate'].isAfter(
            now.subtract(Duration(days: 30)),
          );
        }).toList();
      } else if (selectedFilter == 'آخر 3 أشهر') {
        completedAudits = allCompletedAudits.where((audit) {
          return audit['completionDate'].isAfter(
            now.subtract(Duration(days: 90)),
          );
        }).toList();
      } else if (selectedFilter == 'هذا العام') {
        completedAudits = allCompletedAudits.where((audit) {
          return audit['completionDate'].year == now.year;
        }).toList();
      } else {
        // الكل
        completedAudits = List.from(allCompletedAudits);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('نظام إدارة الجودة والتدقيق'),
          backgroundColor: _primaryColor,
          elevation: 2,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'نظرة عامة'),
              Tab(text: 'مهام التدقيق'),
              Tab(text: 'التقارير'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, size: 24),
              onPressed: () {},
            ),
            IconButton(icon: Icon(Icons.search, size: 24), onPressed: () {}),
          ],
        ),
        body: TabBarView(
          children: [
            // النظرة العامة
            _buildOverviewTab(),
            // مهام التدقيق
            _buildAuditTasksTab(),
            // التقارير
            _buildReportsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showNewAuditDialog(context);
          },
          child: Icon(Icons.add, size: 28),
          backgroundColor: _primaryColor,
          elevation: 3,
        ),
        drawer: _buildDrawer(context),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة ترحيب
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [_primaryColor, _secondaryColor],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحباً بك، مدقق الجودة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'لديك ${auditTasks.length} مهام تدقيق تحتاج إلى مراجعة',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // مؤشرات الجودة
          Text(
            'مؤشرات الجودة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: qualityMetrics.length,
            itemBuilder: (context, index) {
              return _buildQualityMetricCard(qualityMetrics[index]);
            },
          ),
          SizedBox(height: 20),

          // مهام التدقيق القادمة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مهام التدقيق القادمة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('عرض الكل', style: TextStyle(color: _primaryColor)),
              ),
            ],
          ),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: auditTasks.length > 3 ? 3 : auditTasks.length,
            itemBuilder: (context, index) {
              return _buildAuditTaskCard(auditTasks[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAuditTasksTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // فلترة المهام
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: _borderColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'ابحث في مهام التدقيق...',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: _textSecondaryColor,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list, size: 18, color: _primaryColor),
                        SizedBox(width: 4),
                        Text('فلترة', style: TextStyle(color: _primaryColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // قائمة مهام التدقيق
          Expanded(
            child: ListView.builder(
              itemCount: auditTasks.length,
              itemBuilder: (context, index) {
                return _buildAuditTaskCard(auditTasks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رؤوس التقارير
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التدقيقات المكتملة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${completedAudits.length} تدقيق',
                  style: TextStyle(color: _primaryColor, fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // فلترة التقارير - محسنة
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderColor, width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      isExpanded: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: _textSecondaryColor,
                      ),
                      items: filterOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: _textSecondaryColor,
                              ),
                              SizedBox(width: 8),
                              Text(value, style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedFilter = newValue;
                          });
                          _filterCompletedAudits();
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.file_download, size: 18, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 16),

          // قائمة التقارير
          Expanded(
            child: completedAudits.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: _textSecondaryColor),
                        SizedBox(height: 16),
                        Text(
                          'لا توجد تدقيقات في الفترة المحددة',
                          style: TextStyle(
                            fontSize: 16,
                            color: _textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: completedAudits.length,
                    itemBuilder: (context, index) {
                      return _buildCompletedAuditCard(completedAudits[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityMetricCard(Map<String, dynamic> metric) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: metric['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(metric['icon'], color: metric['color'], size: 18),
                ),
                Icon(metric['trend'], color: metric['color'], size: 20),
              ],
            ),
            SizedBox(height: 8),
            Text(
              metric['metric'],
              style: TextStyle(fontSize: 12, color: _textSecondaryColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              metric['score'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: metric['color'],
              ),
            ),
            SizedBox(height: 2),
            Text(
              'الهدف: ${metric['target']}',
              style: TextStyle(fontSize: 10, color: _textSecondaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditTaskCard(Map<String, dynamic> task) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.circle;

    if (task['status'] == 'عاجل') {
      statusColor = _errorColor;
      statusIcon = Icons.error;
    } else if (task['status'] == 'متأخر') {
      statusColor = _warningColor;
      statusIcon = Icons.warning;
    } else if (task['status'] == 'مخطط') {
      statusColor = _secondaryColor;
      statusIcon = Icons.schedule;
    }

    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(statusIcon, color: statusColor, size: 20),
        ),
        title: Text(
          task['department'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(task['type'], style: TextStyle(fontSize: 14)),
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
                  DateFormat('yyyy-MM-dd').format(task['dueDate']),
                  style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                task['status'],
                style: TextStyle(color: statusColor, fontSize: 12),
              ),
            ),
            SizedBox(height: 4),
            Text(
              task['id'],
              style: TextStyle(fontSize: 10, color: _textSecondaryColor),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildCompletedAuditCard(Map<String, dynamic> audit) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: audit['color'].withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.verified, color: audit['color'], size: 20),
        ),
        title: Text(
          audit['department'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(audit['type'], style: TextStyle(fontSize: 14)),
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
                  DateFormat('yyyy-MM-dd').format(audit['completionDate']),
                  style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: audit['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                audit['result'],
                style: TextStyle(color: audit['color'], fontSize: 12),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'نتيجة: ${audit['score']}',
              style: TextStyle(fontSize: 12, color: _textSecondaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [_primaryColor, _secondaryColor],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30, color: _primaryColor),
                ),
                SizedBox(height: 12),
                Text(
                  'مدقق الجودة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'quality.auditor@example.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: _primaryColor),
            title: Text('لوحة التحكم'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.assignment, color: _primaryColor),
            title: Text('مهام التدقيق'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.analytics, color: _primaryColor),
            title: Text('التقارير والإحصائيات'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.people, color: _primaryColor),
            title: Text('فرق التدقيق'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: _textSecondaryColor),
            title: Text('الإعدادات'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help, color: _textSecondaryColor),
            title: Text('المساعدة والدعم'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: _errorColor),
            title: Text('تسجيل الخروج'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showNewAuditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Container(
            width: double.infinity, // تأكد من استخدام العرض الكامل
            child: Row(
              mainAxisSize: MainAxisSize.min, // استخدم أقل حجم ممكن
              children: [
                Icon(Icons.add_circle, color: _primaryColor),
                SizedBox(width: 8),
                Expanded(
                  // أضف Expanded للنص ليأخذ المساحة المتبقية
                  child: Text(
                    'إنشاء مهمة تدقيق جديدة',
                    style: TextStyle(
                      fontSize: 18,
                    ), // تقليل حجم الخط إذا لزم الأمر
                    overflow: TextOverflow.ellipsis, // إضافة تقصير النص إذا زاد
                  ),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ... باقي المحتوى بدون تغيير
              TextField(
                decoration: InputDecoration(
                  labelText: 'عنوان المهمة',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'القسم',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'خدمة العملاء',
                    child: Text('خدمة العملاء'),
                  ),
                  DropdownMenuItem(value: 'الفنيين', child: Text('الفنيين')),
                  DropdownMenuItem(value: 'المحاسبة', child: Text('المحاسبة')),
                ],
                onChanged: (value) {},
              ),
              SizedBox(height: 12),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'نوع التدقيق',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'مراجعة جودة',
                    child: Text('مراجعة جودة'),
                  ),
                  DropdownMenuItem(
                    value: 'تدقيق أعمال',
                    child: Text('تدقيق أعمال'),
                  ),
                  DropdownMenuItem(
                    value: 'مراجعة فواتير',
                    child: Text('مراجعة فواتير'),
                  ),
                ],
                onChanged: (value) {},
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
                style: TextStyle(color: _textSecondaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إنشاء مهمة التدقيق بنجاح'),
                    backgroundColor: _successColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
              child: Text('إنشاء'),
            ),
          ],
        );
      },
    );
  }
}

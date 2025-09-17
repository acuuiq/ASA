import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SystemSupervisorWasteScreen extends StatefulWidget {
  static const String screenRoute = 'system_supervisor_waste_screen';

  const SystemSupervisorWasteScreen({super.key});

  @override
  State<SystemSupervisorWasteScreen> createState() => _SystemSupervisorWasteScreenState();
}

class _SystemSupervisorWasteScreenState extends State<SystemSupervisorWasteScreen> with SingleTickerProviderStateMixin {
  // نظام ألوان متكامل ومتناسق
  final Color _primaryColor = const Color(0xFF2C6975);
  final Color _secondaryColor = const Color(0xFF68B2A0);
  final Color _accentColor = const Color(0xFFCDE0C9);
  final Color _successColor = const Color(0xFF4CAF50);
  final Color _warningColor = const Color(0xFFFF9800);
  final Color _errorColor = const Color(0xFFF44336);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF37474F);
  final Color _textSecondaryColor = const Color(0xFF78909C);
  final Color _backgroundColor = const Color(0xFFF5F7F9);
  final Color _dividerColor = const Color(0xFFE0E0E0);

  // بيانات التطبيق
  int _totalReports = 187;
  int _pendingReports = 32;
  int _resolvedReports = 155;
  int _activeTeams = 12;
  int _totalContainers = 420;
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('نظام إدارة النفايات الذكي',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: _accentColor,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'لوحة التحكم'),
            Tab(icon: Icon(Icons.report_problem), text: 'إدارة البلاغات'),
            Tab(icon: Icon(Icons.group_work), text: 'فرق العمل'),
            Tab(icon: Icon(Icons.delete), text: 'إدارة الحاويات'),
            Tab(icon: Icon(Icons.analytics), text: 'التقارير'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboard(),
          _buildReportsManagement(),
          _buildTeamsManagement(),
          _buildContainersManagement(),
          _buildReportsAnalytics(),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقات الإحصائيات
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard('إجمالي البلاغات', _totalReports, Icons.report_problem, _primaryColor),
              _buildStatCard('البلاغات المعلقة', _pendingReports, Icons.pending_actions, _warningColor),
              _buildStatCard('البلاغات المنجزة', _resolvedReports, Icons.check_circle, _successColor),
              _buildStatCard('فرق العمل النشطة', _activeTeams, Icons.group_work, _secondaryColor),
              _buildStatCard('إجمالي الحاويات', _totalContainers, Icons.delete, _accentColor),
              _buildStatCard('معدل الاستجابة', '92%', Icons.timer, Color(0xFF7E57C2)),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // مخططات الأداء
          Text('أداء النظام', style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textColor,
          )),
          
          const SizedBox(height: 16),
          
          _buildPerformanceCharts(),
          
          const SizedBox(height: 24),
          
          // الإشعارات الحديثة
          Text('آخر التحديثات', style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textColor,
          )),
          
          const SizedBox(height: 16),
          
          _buildRecentNotifications(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, dynamic value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 24, color: color),
                ),
              ],
            ),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$value', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                )),
                
                const SizedBox(height: 4),
                
                Text(title, style: TextStyle(
                  color: _textSecondaryColor,
                  fontSize: 14,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCharts() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('معدل الإنجاز', style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      )),
                      
                      const SizedBox(height: 8),
                      
                      LinearProgressIndicator(
                        value: 0.75,
                        backgroundColor: _backgroundColor,
                        valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 8,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text('75% من المخطط اليومي', style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor,
                      )),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // مخطط دائري مبسط
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: 0.92,
                        strokeWidth: 8,
                        backgroundColor: _backgroundColor,
                        valueColor: AlwaysStoppedAnimation<Color>(_secondaryColor),
                      ),
                    ),
                    Text('92%', style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    )),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Divider(color: _dividerColor, height: 1),
            
            const SizedBox(height: 16),
            
            // وسوم الأداء
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPerformanceTag('مكتمل', '82%', _successColor),
                _buildPerformanceTag('قيد المعالجة', '10%', _warningColor),
                _buildPerformanceTag('متأخر', '8%', _errorColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTag(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        
        const SizedBox(height: 4),
        
        Text(label, style: TextStyle(
          fontSize: 12,
          color: _textColor,
        )),
        
        Text(value, style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _textSecondaryColor,
        )),
      ],
    );
  }

  Widget _buildRecentNotifications() {
    final notifications = [
      {'text': 'تم معالجة بلاغ حي الرياض بنجاح', 'icon': Icons.check_circle, 'color': _successColor, 'time': '5 د'},
      {'text': 'بلاغ جديد في حي النخيل يحتاج معالجة', 'icon': Icons.warning, 'color': _warningColor, 'time': '12 د'},
      {'text': 'تقرير الأداء الشهري جاهز', 'icon': Icons.analytics, 'color': _primaryColor, 'time': '1 س'},
      {'text': 'حاوية في حي الصناعية تحتاج صيانة', 'icon': Icons.build, 'color': _errorColor, 'time': '2 س'},
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Divider(color: _dividerColor, height: 1),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (notification['color'] as Color).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(notification['icon'] as IconData, size: 20, color: notification['color'] as Color),
            ),
            title: Text(notification['text'] as String, style: TextStyle(
              color: _textColor,
              fontSize: 14,
            )),
            trailing: Text(notification['time'] as String, style: TextStyle(
              color: _textSecondaryColor,
              fontSize: 12,
            )),
          );
        },
      ),
    );
  }

  Widget _buildReportsManagement() {
    final reports = [
      {'title': 'حاوية ممتلئة - حي الرياض', 'status': 'قيد المعالجة', 'icon': Icons.delete, 'color': _warningColor},
      {'title': 'حاوية تالفة - حي النخيل', 'status': 'جديد', 'icon': Icons.broken_image, 'color': _secondaryColor},
      {'title': 'نفايات مبعثرة - حي العليا', 'status': 'تم الحل', 'icon': Icons.clean_hands, 'color': _successColor},
      {'title': 'روائح كريهة - حي الورود', 'status': 'قيد المعالجة', 'icon': Icons.air, 'color': _warningColor},
      {'title': 'حاوية مسروقة - حي الصناعية', 'status': 'جديد', 'icon': Icons.warning, 'color': _secondaryColor},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'ابحث في البلاغات...',
              prefixIcon: Icon(Icons.search, color: _textSecondaryColor),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),
        ),
        
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: reports.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final report = reports[index];
              return _buildReportItem(
                report['title'] as String, 
                report['status'] as String, 
                report['icon'] as IconData, 
                report['color'] as Color
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTeamsManagement() {
    final teams = [
      {'name': 'الفريق الشمالي', 'tasks': 5, 'status': 'نشط', 'icon': Icons.directions_car, 'color': _successColor},
      {'name': 'الفريق الجنوبي', 'tasks': 3, 'status': 'نشط', 'icon': Icons.local_shipping, 'color': _successColor},
      {'name': 'الفريق الشرقي', 'tasks': 2, 'status': 'في الاستراحة', 'icon': Icons.coffee, 'color': _warningColor},
      {'name': 'الفريق الغربي', 'tasks': 4, 'status': 'نشط', 'icon': Icons.electric_car, 'color': _successColor},
      {'name': 'فريق الطوارئ', 'tasks': 1, 'status': 'جاهز', 'icon': Icons.emergency, 'color': _accentColor},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث في الفرق...',
                    prefixIcon: Icon(Icons.search, color: _textSecondaryColor),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              Container(
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: teams.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final team = teams[index];
              return _buildTeamCard(
                team['name'] as String, 
                team['tasks'] as int, 
                team['status'] as String, 
                team['icon'] as IconData, 
                team['color'] as Color
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContainersManagement() {
    final containers = [
      {'type': 'حاوية 120 لتر', 'location': 'حي الرياض', 'condition': 'جيدة', 'icon': Icons.check_circle, 'color': _successColor},
      {'type': 'حاوية 240 لتر', 'location': 'حي النخيل', 'condition': 'تحتاج صيانة', 'icon': Icons.build, 'color': _warningColor},
      {'type': 'حاوية 360 لتر', 'location': 'حي العليا', 'condition': 'جيدة', 'icon': Icons.check_circle, 'color': _successColor},
      {'type': 'حاوية 120 لتر', 'location': 'حي الصناعية', 'condition': 'تالفة', 'icon': Icons.error, 'color': _errorColor},
      {'type': 'حاوية 240 لتر', 'location': 'حي الورود', 'condition': 'جيدة', 'icon': Icons.check_circle, 'color': _successColor},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث في الحاويات...',
                    prefixIcon: Icon(Icons.search, color: _textSecondaryColor),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: containers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final container = containers[index];
              return _buildContainerInfo(
                container['type'] as String, 
                container['location'] as String, 
                container['condition'] as String, 
                container['icon'] as IconData, 
                container['color'] as Color
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReportsAnalytics() {
    final reports = [
      {'title': 'تقرير الأداء اليومي', 'icon': Icons.today, 'subtitle': 'تم إنشاؤه اليوم 08:00 ص'},
      {'title': 'تقرير كميات النفايات', 'icon': Icons.bar_chart, 'subtitle': 'آخر تحديث أمس'},
      {'title': 'تقرير رضا العملاء', 'icon': Icons.sentiment_satisfied, 'subtitle': 'شهري - جاهز للتحميل'},
      {'title': 'تقرير التكاليف', 'icon': Icons.attach_money, 'subtitle': 'ربع سنوي - قيد الإعداد'},
      {'title': 'تقرير البيئة', 'icon': Icons.eco, 'subtitle': 'سنوي - متوفر للتحميل'},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('التقارير المتاحة', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              )),
              
              Container(
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: reports.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final report = reports[index];
              return _buildAnalyticsCard(
                report['title'] as String, 
                report['icon'] as IconData, 
                report['subtitle'] as String
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReportItem(String title, String status, IconData icon, Color statusColor) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: statusColor),
        ),
        title: Text(title, style: TextStyle(
          fontWeight: FontWeight.w500,
          color: _textColor,
          fontSize: 14,
        )),
        subtitle: Text('تم الإبلاغ: ${DateFormat('dd MMM yyyy').format(DateTime.now())}', style: TextStyle(
          color: _textSecondaryColor,
          fontSize: 12,
        )),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Text(status, style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          )),
        ),
      ),
    );
  }

  Widget _buildTeamCard(String teamName, int activeTasks, String status, IconData icon, Color statusColor) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _secondaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: _secondaryColor),
        ),
        title: Text(teamName, style: TextStyle(
          fontWeight: FontWeight.w500,
          color: _textColor,
          fontSize: 14,
        )),
        subtitle: Text('$activeTasks مهام نشطة', style: TextStyle(
          color: _textSecondaryColor,
          fontSize: 12,
        )),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Text(status, style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          )),
        ),
      ),
    );
  }

  Widget _buildContainerInfo(String type, String location, String condition, IconData icon, Color conditionColor) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: _accentColor),
        ),
        title: Text(type, style: TextStyle(
          fontWeight: FontWeight.w500,
          color: _textColor,
          fontSize: 14,
        )),
        subtitle: Text(location, style: TextStyle(
          color: _textSecondaryColor,
          fontSize: 12,
        )),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: conditionColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: conditionColor.withOpacity(0.3)),
          ),
          child: Text(condition, style: TextStyle(
            color: conditionColor,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          )),
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, IconData icon, String subtitle) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: _primaryColor),
        ),
        title: Text(title, style: TextStyle(
          fontWeight: FontWeight.w500,
          color: _textColor,
          fontSize: 14,
        )),
        subtitle: Text(subtitle, style: TextStyle(
          color: _textSecondaryColor,
          fontSize: 12,
        )),
        trailing: IconButton(
          icon: Icon(Icons.download, size: 20, color: _primaryColor),
          onPressed: () {
            // تحميل التقرير
          },
        ),
      ),
    );
  }
}
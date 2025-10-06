// فني الصيانة - كهرباء (محسّنة)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MaintenanceTechnicianScreen extends StatefulWidget {
  const MaintenanceTechnicianScreen({super.key});

  @override
  _MaintenanceTechnicianScreenState createState() =>
      _MaintenanceTechnicianScreenState();
}

class _MaintenanceTechnicianScreenState
    extends State<MaintenanceTechnicianScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  // الألوان الجديدة للتصميم المحسّن
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

  final List<Map<String, dynamic>> activeTasks = [
    {
      'id': 'TASK-001',
      'location': 'شارع الملك فهد، الرياض',
      'type': 'عطل في العداد',
      'priority': 'عالي',
      'assignedDate': DateTime.now().subtract(Duration(hours: 1)),
      'estimatedTime': '2 ساعة',
      'status': 'قيد التنفيذ',
      'customerName': 'أحمد محمد',
      'customerPhone': '0551234567',
      'meterNumber': 'MTR-2023-001',
      'consumption': '250 ك.و.س',
      'notes': 'العميل يطلب الزيارة في الفترة الصباحية',
    },
    {
      'id': 'TASK-002',
      'location': 'حي النخيل، جدة',
      'type': 'انقطاع تيار',
      'priority': 'عاجل',
      'assignedDate': DateTime.now().subtract(Duration(minutes: 30)),
      'estimatedTime': '4 ساعات',
      'status': 'معلقة',
      'customerName': 'سارة عبدالله',
      'customerPhone': '0557654321',
      'meterNumber': 'MTR-2023-045',
      'consumption': '180 ك.و.س',
      'notes': 'يوجد كلب حراسة في الموقع - الاتصال قبل الزيارة',
    },
  ];

  final List<Map<String, dynamic>> completedTasks = [
    {
      'id': 'TASK-003',
      'location': 'حي العليا، الرياض',
      'type': 'صيانة وقائية',
      'completionDate': DateTime.now().subtract(Duration(days: 1)),
      'duration': '3 ساعات',
      'rating': 4.5,
      'customerName': 'خالد إبراهيم',
      'meterNumber': 'MTR-2023-078',
      'partsUsed': ['عداد جديد', 'أسلاك توصيل'],
      'cost': '350 ريال',
      'customerFeedback': 'خدمة ممتازة ومحترفة، شكراً لكم',
    },
    {
      'id': 'TASK-004',
      'location': 'حي السلام، الدمام',
      'type': 'استبدال عداد',
      'completionDate': DateTime.now().subtract(Duration(days: 3)),
      'duration': '2.5 ساعة',
      'rating': 4.8,
      'customerName': 'فاطمة علي',
      'meterNumber': 'MTR-2023-112',
      'partsUsed': ['عداد ذكي'],
      'cost': '520 ريال',
      'customerFeedback': 'الفني كان محترفاً وأنهى العمل بسرعة',
    },
  ];

  final List<Map<String, dynamic>> delayedTasks = [
    {
      'id': 'TASK-005',
      'location': 'حي الورود، الخبر',
      'type': 'إصلاح خط كهرباء',
      'priority': 'عالي',
      'assignedDate': DateTime.now().subtract(Duration(days: 2)),
      'estimatedTime': '5 ساعات',
      'status': 'متأخرة',
      'delayReason': 'انتظار قطع الغيار',
      'customerName': 'محمد حسن',
      'customerPhone': '0559876543',
      'meterNumber': 'MTR-2023-087',
      'expectedPartsArrival': DateTime.now().add(Duration(days: 1)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: Text(
          'لوحة تحكم فني الصيانة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: _primaryColor,
        elevation: 2,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications, color: Colors.white, size: 26),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '3',
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
            ),
            onPressed: () {
              _showNotifications(context);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 3, color: _primaryColor),
                ),
              ),
              labelColor: _primaryColor,
              unselectedLabelColor: _textSecondaryColor,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: [
                Tab(text: 'المهام النشطة (${activeTasks.length})'),
                Tab(text: 'المكتملة (${completedTasks.length})'),
                Tab(text: 'المتأخرة (${delayedTasks.length})'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveTasksView(),
          _buildCompletedTasksView(),
          _buildDelayedTasksView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTaskUpdateDialog(context);
        },
        backgroundColor: _primaryColor,
        elevation: 4,
        child: Icon(Icons.add_task, size: 28),
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildActiveTasksView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTechnicianInfoCard(),
          SizedBox(height: 20),
          _buildStatsRow(),
          SizedBox(height: 20),
          Text(
            'المهام النشطة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          SizedBox(height: 12),
          ...activeTasks.map((task) => _buildActiveTaskCard(task)),
        ],
      ),
    );
  }

  Widget _buildCompletedTasksView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerformanceCard(),
          SizedBox(height: 20),
          Text(
            'المهام المنتهية',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          SizedBox(height: 12),
          ...completedTasks
              .map((task) => _buildCompletedTaskCard(task))
              ,
        ],
      ),
    );
  }

  Widget _buildDelayedTasksView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDelayAnalysisCard(),
          SizedBox(height: 20),
          Text(
            'المهام المتأخرة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _errorColor,
            ),
          ),
          SizedBox(height: 12),
          ...delayedTasks.map((task) => _buildDelayedTaskCard(task)),
        ],
      ),
    );
  }

  Widget _buildTechnicianInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: _primaryColor.withOpacity(0.2),
              child: Icon(Icons.person, color: _primaryColor, size: 32),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'فادي أحمد',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'فني كهرباء - المنطقة الوسطى',
                    style: TextStyle(fontSize: 14, color: _textSecondaryColor),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 4),
                      Text(
                        '4.7/5',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.assignment, color: _primaryColor, size: 18),
                      SizedBox(width: 4),
                      Text(
                        '${activeTasks.length + completedTasks.length} مهمة هذا الأسبوع',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard(
          'المهام النشطة',
          activeTasks.length.toString(),
          Icons.assignment,
          _primaryColor,
        ),
        SizedBox(width: 8),
        _buildStatCard(
          'مكتملة',
          completedTasks.length.toString(),
          Icons.check_circle,
          _successColor,
        ),
        SizedBox(width: 8),
        _buildStatCard(
          'متأخرة',
          delayedTasks.length.toString(),
          Icons.warning,
          _errorColor,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTaskCard(Map<String, dynamic> task) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getPriorityColor(task['priority']).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.build,
            color: _getPriorityColor(task['priority']),
            size: 22,
          ),
        ),
        title: Text(
          task['type'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(task['location'], style: TextStyle(fontSize: 13)),
            SizedBox(height: 2),
            Text(
              'العميل: ${task['customerName']}',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            task['status'],
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: _getStatusColor(task['status']),
          side: BorderSide.none,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildDetailRow('رقم المهمة:', task['id']),
                SizedBox(height: 8),
                _buildDetailRow('رقم العداد:', task['meterNumber']),
                SizedBox(height: 8),
                _buildDetailRow('هاتف العميل:', task['customerPhone']),
                SizedBox(height: 8),
                _buildDetailRow('الاستهلاك:', task['consumption']),
                SizedBox(height: 8),
                _buildDetailRow('الوقت المقدر:', task['estimatedTime']),
                SizedBox(height: 8),
                if (task['notes'] != null)
                  _buildDetailRow('ملاحظات:', task['notes']),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _startTask(task);
                      },
                      icon: Icon(Icons.play_arrow, size: 18),
                      label: Text('بدء العمل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _successColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _delayTask(task);
                      },
                      icon: Icon(Icons.schedule, size: 18),
                      label: Text('تأجيل'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _warningColor,
                        side: BorderSide(color: _warningColor),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _contactCustomer(task);
                      },
                      icon: Icon(Icons.phone, size: 18),
                      label: Text('اتصال'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primaryColor,
                        side: BorderSide(color: _primaryColor),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    _navigateToCustomer(task);
                  },
                  icon: Icon(Icons.directions, size: 18),
                  label: Text('التوجيه إلى الموقع'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _secondaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTaskCard(Map<String, dynamic> task) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _successColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_circle, color: _successColor, size: 24),
        ),
        title: Text(
          task['type'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            Text(task['location'], style: TextStyle(fontSize: 13)),
            SizedBox(height: 4),
            Text(
              'العميل: ${task['customerName']}',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 4),
            Text('التكلفة: ${task['cost']}', style: TextStyle(fontSize: 13)),
            SizedBox(height: 6),
            if (task['customerFeedback'] != null)
              Text(
                'تعليق العميل: ${task['customerFeedback']}',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: _textSecondaryColor,
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RatingBarIndicator(
              rating: task['rating'].toDouble(),
              itemBuilder: (context, index) =>
                  Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 16,
              direction: Axis.horizontal,
            ),
            SizedBox(height: 6),
            Text(
              DateFormat('yyyy-MM-dd').format(task['completionDate']),
              style: TextStyle(fontSize: 11, color: _textSecondaryColor),
            ),
          ],
        ),
        onTap: () {
          _showTaskDetails(task, true);
        },
      ),
    );
  }

  Widget _buildDelayedTaskCard(Map<String, dynamic> task) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      color: _errorColor.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _errorColor.withOpacity(0.2), width: 1),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _errorColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.warning, color: _errorColor, size: 24),
        ),
        title: Text(
          task['type'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            Text(task['location'], style: TextStyle(fontSize: 13)),
            SizedBox(height: 4),
            Text(
              'سبب التأخير: ${task['delayReason']}',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 4),
            if (task['expectedPartsArrival'] != null)
              Text(
                'موعد وصول القطعة: ${DateFormat('yyyy-MM-dd').format(task['expectedPartsArrival'])}',
                style: TextStyle(fontSize: 12, color: _textSecondaryColor),
              ),
          ],
        ),
        trailing: Chip(
          label: Text(
            task['status'],
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: _errorColor,
          side: BorderSide.none,
        ),
        onTap: () {
          _showTaskDetails(task, false);
        },
      ),
    );
  }

  Widget _buildPerformanceCard() {
    double avgRating = completedTasks.isNotEmpty
        ? completedTasks.map((task) => task['rating']).reduce((a, b) => a + b) /
              completedTasks.length
        : 0;

    int totalTasks = completedTasks.length;
    int onTimeTasks = (totalTasks * 0.85)
        .round(); // Assuming 85% on-time completion

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أداء هذا الأسبوع',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPerformanceIndicator(
                  'المهام المكتملة',
                  '$totalTasks',
                  Icons.assignment_turned_in,
                  _successColor,
                ),
                _buildPerformanceIndicator(
                  'التقييم',
                  avgRating.toStringAsFixed(1),
                  Icons.star,
                  Colors.amber,
                ),
                _buildPerformanceIndicator(
                  'في الموعد',
                  '$onTimeTasks',
                  Icons.timer,
                  _primaryColor,
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: onTimeTasks / totalTasks,
              backgroundColor: _backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(_successColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            SizedBox(height: 8),
            Text(
              'نسبة الإنجاز في الوقت المحدد: ${((onTimeTasks / totalTasks) * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 12, color: _textSecondaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceIndicator(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 12, color: _textSecondaryColor)),
      ],
    );
  }

  Widget _buildDelayAnalysisCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تحليل التأخيرات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            SizedBox(height: 16),
            _buildDelayReason('انتظار قطع الغيار', 3, 6),
            SizedBox(height: 12),
            _buildDelayReason('ظروف الطقس', 1, 6),
            SizedBox(height: 12),
            _buildDelayReason('تعقيد المهمة', 2, 6),
            SizedBox(height: 16),
            Text(
              'إجمالي ساعات التأخير: 18 ساعة',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDelayReason(String reason, int count, int hours) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(reason, style: TextStyle(fontSize: 14))),
        Expanded(
          flex: 1,
          child: Text(
            '$count مرات',
            style: TextStyle(fontSize: 14, color: _textSecondaryColor),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '$hours ساعات',
            style: TextStyle(fontSize: 14, color: _errorColor),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(value, style: TextStyle(fontSize: 14, color: _textSecondaryColor)),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: _primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(Icons.person, color: Colors.white, size: 32),
                ),
                SizedBox(height: 12),
                Text(
                  'فادي أحمد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'فني كهرباء - المنطقة الوسطى',
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
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.schedule, color: _primaryColor),
            title: Text('جدول المهام'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.analytics, color: _primaryColor),
            title: Text('الإحصائيات والأداء'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory, color: _primaryColor),
            title: Text('إدارة المخزون'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: _primaryColor),
            title: Text('الإعدادات'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.help, color: _primaryColor),
            title: Text('المساعدة والدعم'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: _errorColor),
            title: Text('تسجيل الخروج'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عاجل':
        return _errorColor;
      case 'عالي':
        return _warningColor;
      default:
        return _primaryColor;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'قيد التنفيذ':
        return _primaryColor;
      case 'معلقة':
        return _warningColor;
      case 'متأخرة':
        return _errorColor;
      case 'مكتملة':
        return _successColor;
      default:
        return Colors.grey;
    }
  }

  void _startTask(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('بدء المهمة'),
        content: Text(
          'هل تريد بدء مهمة ${task['type']} عند ${task['location']}?',
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
                  content: Text('تم بدء المهمة بنجاح'),
                  backgroundColor: _successColor,
                ),
              );
            },
            child: Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _delayTask(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأجيل المهمة'),
        content: Text('حدد سبب تأجيل مهمة ${task['type']}:'),
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
                  content: Text('تم تأجيل المهمة'),
                  backgroundColor: _warningColor,
                ),
              );
            },
            child: Text('تأكيد التأجيل'),
          ),
        ],
      ),
    );
  }

  void _contactCustomer(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الاتصال بالعميل'),
        content: Text(
          'الاتصال بالعميل ${task['customerName']} على الرقم ${task['customerPhone']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you would implement the actual calling functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('جاري الاتصال بالعميل...'),
                  backgroundColor: _primaryColor,
                ),
              );
            },
            child: Text('اتصال'),
          ),
        ],
      ),
    );
  }

  void _navigateToCustomer(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('التوجيه إلى الموقع'),
        content: Text('فتح خرائط Google للذهاب إلى ${task['location']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you would implement the actual navigation functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('جاري فتح التطبيق للتنقل...'),
                  backgroundColor: _primaryColor,
                ),
              );
            },
            child: Text('فتح الخرائط'),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(Map<String, dynamic> task, bool isCompleted) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل المهمة'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('نوع المهمة:', task['type']),
              SizedBox(height: 8),
              _buildDetailRow('الموقع:', task['location']),
              SizedBox(height: 8),
              _buildDetailRow('العميل:', task['customerName']),
              SizedBox(height: 8),
              _buildDetailRow('رقم العداد:', task['meterNumber']),
              if (isCompleted) ...[
                SizedBox(height: 8),
                _buildDetailRow('التكلفة:', task['cost']),
                SizedBox(height: 8),
                _buildDetailRow('التقييم:', '${task['rating']}/5'),
              ],
              if (!isCompleted && task['delayReason'] != null) ...[
                SizedBox(height: 8),
                _buildDetailRow('سبب التأخير:', task['delayReason']),
              ],
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

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الإشعارات'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNotificationItem(
                'مهمة جديدة',
                'تم تعيين مهمة جديدة لك في حي العليا',
                Icons.assignment,
                _primaryColor,
              ),
              SizedBox(height: 12),
              _buildNotificationItem(
                'تذكير',
                'مهمة TASK-002 لم تبدأ بعد',
                Icons.notifications_active,
                _warningColor,
              ),
              SizedBox(height: 12),
              _buildNotificationItem(
                'تحديث',
                'تم تحديث جدول الصيانة',
                Icons.update,
                _secondaryColor,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('تم الفهم'),
          ),
        ],
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
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(message, style: TextStyle(fontSize: 12)),
    );
  }

  void _showTaskUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تحديث حالة المهمة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('اختر المهمة لتحديث حالتها:'),
              SizedBox(height: 16),
              DropdownButtonFormField(
                items: activeTasks.map((task) {
                  return DropdownMenuItem(
                    value: task['id'],
                    child: Text('${task['id']} - ${task['type']}'),
                  );
                }).toList(),
                onChanged: (value) {},
                decoration: InputDecoration(
                  labelText: 'المهمة',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                items: ['قيد التنفيذ', 'مكتملة', 'متأخرة'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) {},
                decoration: InputDecoration(
                  labelText: 'الحالة الجديدة',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'ملاحظات (اختياري)',
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
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تحديث حالة المهمة بنجاح'),
                  backgroundColor: _successColor,
                ),
              );
            },
            child: Text('تأكيد التحديث'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      title: 'فني الصيانة الكهربائية',
      theme: ThemeData(
        primaryColor: Color(0xFF0D47A1),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF0D47A1),
          secondary: Color(0xFF1976D2),
        ),
        fontFamily: 'Cairo', // استخدام خط عربي مناسب
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          elevation: 2,
          centerTitle: true,
        ),
      ),
      home: MaintenanceTechnicianScreen(),
    ),
  );
}

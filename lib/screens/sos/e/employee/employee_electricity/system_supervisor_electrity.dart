import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SystemSupervisorScreen extends StatefulWidget {
  @override
  _SystemSupervisorScreenState createState() => _SystemSupervisorScreenState();
}

class _SystemSupervisorScreenState extends State<SystemSupervisorScreen> {
  // الألوان المحسنة للتصميم الاحترافي
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

  int _selectedTab = 0;
  final List<String> _tabs = ['نظرة عامة', 'الإحصائيات', 'التقارير'];

  final List<Map<String, dynamic>> systemStats = [
    {
      'metric': 'المستخدمين النشطين',
      'value': '1,250',
      'icon': Icons.people,
      'color': Color(0xFF0D47A1),
      'trend': Icons.trending_up,
      'trendColor': Colors.green,
      'change': '+5.2%',
    },
    {
      'metric': 'المهام اليومية',
      'value': '45',
      'icon': Icons.task,
      'color': Color(0xFF1976D2),
      'trend': Icons.trending_flat,
      'trendColor': Colors.blue,
      'change': '0.0%',
    },
    {
      'metric': 'الإنذارات',
      'value': '3',
      'icon': Icons.warning,
      'color': Color(0xFFF57C00),
      'trend': Icons.trending_down,
      'trendColor': Colors.red,
      'change': '-12.5%',
    },
    {
      'metric': 'الأداء',
      'value': '98%',
      'icon': Icons.speed,
      'color': Color(0xFF2E7D32),
      'trend': Icons.trending_up,
      'trendColor': Colors.green,
      'change': '+2.3%',
    },
  ];

  final List<Map<String, dynamic>> recentActivities = [
    {
      'user': 'أحمد محمد',
      'action': 'تسجيل دخول',
      'time': DateTime.now().subtract(Duration(minutes: 5)),
      'status': 'ناجح',
      'avatar': 'AM',
    },
    {
      'user': 'فاطمة علي',
      'action': 'تعديل فاتورة',
      'time': DateTime.now().subtract(Duration(minutes: 15)),
      'status': 'ناجح',
      'avatar': 'فع',
    },
    {
      'user': 'سالم عبدالله',
      'action': 'محاولة دخول',
      'time': DateTime.now().subtract(Duration(minutes: 30)),
      'status': 'فاشل',
      'avatar': 'سع',
    },
    {
      'user': 'مريم خالد',
      'action': 'دفع فاتورة',
      'time': DateTime.now().subtract(Duration(minutes: 45)),
      'status': 'ناجح',
      'avatar': 'مخ',
    },
    {
      'user': 'علي حسن',
      'action': 'تحديث البيانات',
      'time': DateTime.now().subtract(Duration(hours: 1)),
      'status': 'ناجح',
      'avatar': 'عه',
    },
  ];

  final List<Map<String, dynamic>> employeePerformance = [
    {
      'employee': 'موظف خدمة العملاء',
      'completed': 25,
      'pending': 3,
      'rating': '4.8',
      'avatar': 'خدمة',
      'progress': 0.89,
    },
    {
      'employee': 'فني الصيانة',
      'completed': 18,
      'pending': 2,
      'rating': '4.6',
      'avatar': 'صيانة',
      'progress': 0.78,
    },
    {
      'employee': 'المحاسب',
      'completed': 30,
      'pending': 1,
      'rating': '4.9',
      'avatar': 'محاسب',
      'progress': 0.95,
    },
    {
      'employee': 'مدقق الجودة',
      'completed': 22,
      'pending': 4,
      'rating': '4.7',
      'avatar': 'جودة',
      'progress': 0.82,
    },
  ];

  // بيانات الرسم البياني
  final List<SalesData> chartData = [
    SalesData('يناير', 35),
    SalesData('فبراير', 28),
    SalesData('مارس', 34),
    SalesData('أبريل', 32),
    SalesData('مايو', 40),
    SalesData('يونيو', 38),
    SalesData('يوليو', 45),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'لوحة تحكم المشرف - الكهرباء',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, size: 26),
            onPressed: () {},
            tooltip: 'الإشعارات',
          ),
          IconButton(
            icon: Icon(Icons.search, size: 26),
            onPressed: () {},
            tooltip: 'بحث',
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // تبويبات الصفحة
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTab = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 3,
                            color: _selectedTab == index
                                ? _primaryColor
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Text(
                        _tabs[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: _selectedTab == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _selectedTab == index
                              ? _primaryColor
                              : _textSecondaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedTab == 0) _buildOverviewTab(),
                  if (_selectedTab == 1) _buildStatisticsTab(),
                  if (_selectedTab == 2) _buildReportsTab(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.settings, size: 26),
        backgroundColor: _primaryColor,
        elevation: 4,
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نظرة عامة على النظام',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        SizedBox(
          height: 320,
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: systemStats.length,
            itemBuilder: (context, index) {
              return _buildUsageStatCard(systemStats[index]);
            },
          ),
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                'أداء الموظفين',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
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
          itemCount: employeePerformance.length,
          itemBuilder: (context, index) {
            return _buildEmployeePerformanceCard(employeePerformance[index]);
          },
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                'النشاطات الحديثة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
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
          itemCount: recentActivities.length,
          itemBuilder: (context, index) {
            return _buildActivityCard(recentActivities[index]);
          },
        ),
      ],
    );
  }

  Widget _buildStatisticsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إحصائيات الاستهلاك',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: _borderColor, width: 1),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'استهلاك الكهرباء الشهري (كيلوواط/ساعة)'),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <LineSeries<SalesData, String>>[
                LineSeries<SalesData, String>(
                  name: 'الاستهلاك',
                  dataSource: chartData,
                  xValueMapper: (SalesData sales, _) => sales.month,
                  yValueMapper: (SalesData sales, _) => sales.sales,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                  color: _primaryColor,
                  markerSettings: MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),
        Text(
          'توزيع الاستهلاك',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4,
          ),
          itemCount: systemStats.length,
          itemBuilder: (context, index) {
            return _buildUsageStatCard(systemStats[index]);
          },
        ),
      ],
    );
  }

  Widget _buildReportsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التقارير المتاحة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        SizedBox(height: 16),
        _buildReportItem(
          title: 'تقرير الاستهلاك الشهري',
          icon: Icons.description,
          description: 'تقرير مفصل عن استهلاك الكهرباء خلال الشهر',
          date: 'تم إنشاؤه: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
        ),
        SizedBox(height: 12),
        _buildReportItem(
          title: 'تقرير المدفوعات',
          icon: Icons.payment,
          description: 'تفاصيل المدفوعات والفواتير المستحقة',
          date:
              'تم إنشاؤه: ${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)))}',
        ),
        SizedBox(height: 12),
        _buildReportItem(
          title: 'تقرير الإنذارات',
          icon: Icons.warning,
          description: 'سجل الإنذارات والمشاكل الفنية',
          date:
              'تم إنشاؤه: ${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 2)))}',
        ),
        SizedBox(height: 12),
        _buildReportItem(
          title: 'تقرير أداء الموظفين',
          icon: Icons.people,
          description: 'تقييم أداء الموظفين وإنجازاتهم',
          date:
              'تم إنشاؤه: ${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 3)))}',
        ),
        SizedBox(height: 24),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add, size: 20),
            label: Text('إنشاء تقرير جديد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemStatCard(Map<String, dynamic> stat) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: Container(
        height: 110, // تحديد ارتفاع ثابت للبطاقة
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: stat['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(stat['icon'], color: stat['color'], size: 14),
                  ),
                  Icon(stat['trend'], color: stat['trendColor'], size: 12),
                ],
              ),
              SizedBox(height: 4),
              FittedBox(
                child: Text(
                  stat['value'],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ),
              SizedBox(height: 2),
              Text(
                stat['metric'],
                style: TextStyle(fontSize: 9, color: _textSecondaryColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                stat['change'],
                style: TextStyle(
                  fontSize: 8,
                  color: stat['trendColor'],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsageStatCard(Map<String, dynamic> stat) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: Container(
        constraints: BoxConstraints(minHeight: 140, maxHeight: 150),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            // مؤشر التقدم
            Container(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                value: 0.7,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(stat['color']),
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 6),
            // القيمة
            Text(
              stat['value'],
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2),
            // المقياس
            Text(
              stat['metric'],
              style: TextStyle(
                fontSize: 8,
                color: _textSecondaryColor,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeePerformanceCard(Map<String, dynamic> performance) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _cardColor,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: _primaryColor.withOpacity(0.1),
            child: Text(
              performance['avatar'],
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            performance['employee'],
            style: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                'المكتمل: ${performance['completed']} • المعلق: ${performance['pending']}',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 6),
              LinearProgressIndicator(
                value: performance['progress'],
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                borderRadius: BorderRadius.circular(4),
                minHeight: 6,
              ),
            ],
          ),
          trailing: Chip(
            label: Text('⭐ ${performance['rating']}'),
            backgroundColor: Colors.amber[50],
            side: BorderSide(color: Colors.amber.shade200),
            labelStyle: TextStyle(
              color: Colors.amber.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _cardColor,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: _primaryColor.withOpacity(0.1),
            child: Text(
              activity['avatar'],
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            activity['user'],
            style: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
          ),
          subtitle: Text(activity['action']),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('HH:mm').format(activity['time']),
                style: TextStyle(fontSize: 12, color: _textSecondaryColor),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: activity['status'] == 'ناجح'
                      ? _successColor.withOpacity(0.1)
                      : _errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  activity['status'],
                  style: TextStyle(
                    fontSize: 10,
                    color: activity['status'] == 'ناجح'
                        ? _successColor
                        : _errorColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportItem({
    required String title,
    required IconData icon,
    required String description,
    required String date,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _cardColor,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _primaryColor, size: 24),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(description),
              SizedBox(height: 8),
              Text(
                date,
                style: TextStyle(fontSize: 12, color: _textSecondaryColor),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.download, color: _primaryColor),
            onPressed: () {},
            tooltip: 'تحميل التقرير',
          ),
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.month, this.sales);
  final String month;
  final double sales;
}

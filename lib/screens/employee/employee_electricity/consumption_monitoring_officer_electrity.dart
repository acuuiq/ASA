import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsumptionMonitoringOfficerScreen extends StatefulWidget {
  const ConsumptionMonitoringOfficerScreen({super.key});
  static const String screenroot = 'consumption_monitoring_officer_screen';

  @override
  ConsumptionMonitoringOfficerScreenState createState() =>
      ConsumptionMonitoringOfficerScreenState();
}

class ConsumptionMonitoringOfficerScreenState
    extends State<ConsumptionMonitoringOfficerScreen> {
  // الألوان للتصميم الجديد
  final Color _primaryColor = const Color(0xFF1A237E);
  final Color _secondaryColor = const Color(0xFF3949AB);
  final Color _accentColor = const Color(0xFF536DFE);
  final Color _backgroundColor = const Color(0xFFF5F7FF);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF263238);
  final Color _textSecondaryColor = const Color(0xFF78909C);
  final Color _successColor = const Color(0xFF4CAF50);
  final Color _warningColor = const Color(0xFFFF9800);
  final Color _errorColor = const Color(0xFFF44336);
  final Color _borderColor = const Color(0xFFE3E8F2);
  final Color _gradientStart = const Color(0xFF1A237E);
  final Color _gradientEnd = const Color(0xFF283593);

  int _selectedTab = 0;
  final String _selectedArea = 'جميع المناطق';
  final String _selectedPeriod = 'هذا الشهر';

  // بيانات الاستهلاك
  final List<Map<String, dynamic>> _consumptionData = [
    {
      'area': 'حي الرياض',
      'currentConsumption': 12500,
      'previousConsumption': 11800,
      'changePercent': 5.9,
      'customers': 250,
      'avgConsumption': 50,
      'trend': 'up',
    },
    {
      'area': 'حي النخيل',
      'currentConsumption': 8900,
      'previousConsumption': 9200,
      'changePercent': -3.3,
      'customers': 180,
      'avgConsumption': 49.4,
      'trend': 'down',
    },
    {
      'area': 'حي العليا',
      'currentConsumption': 15600,
      'previousConsumption': 14800,
      'changePercent': 5.4,
      'customers': 300,
      'avgConsumption': 52,
      'trend': 'up',
    },
    {
      'area': 'حي الصفا',
      'currentConsumption': 7200,
      'previousConsumption': 7500,
      'changePercent': -4.0,
      'customers': 150,
      'avgConsumption': 48,
      'trend': 'down',
    },
  ];

  // بيانات الاستهلاك الشهري المعدلة
  final List<Map<String, dynamic>> _monthlyConsumptionData = [
    {'month': 'يناير', 'consumption': 45000, 'previous': 42000, 'trend': 'up'},
    {'month': 'فبراير', 'consumption': 48000, 'previous': 45000, 'trend': 'up'},
    {'month': 'مارس', 'consumption': 52000, 'previous': 48000, 'trend': 'up'},
    {'month': 'أبريل', 'consumption': 55000, 'previous': 52000, 'trend': 'up'},
    {'month': 'مايو', 'consumption': 62000, 'previous': 55000, 'trend': 'up'},
    {'month': 'يونيو', 'consumption': 75000, 'previous': 62000, 'trend': 'up'},
    {'month': 'يوليو', 'consumption': 82000, 'previous': 75000, 'trend': 'up'},
    {
      'month': 'أغسطس',
      'consumption': 78000,
      'previous': 82000,
      'trend': 'down',
    },
    {
      'month': 'سبتمبر',
      'consumption': 65000,
      'previous': 78000,
      'trend': 'down',
    },
    {
      'month': 'أكتوبر',
      'consumption': 58000,
      'previous': 65000,
      'trend': 'down',
    },
    {
      'month': 'نوفمبر',
      'consumption': 52000,
      'previous': 58000,
      'trend': 'down',
    },
    {
      'month': 'ديسمبر',
      'consumption': 47000,
      'previous': 52000,
      'trend': 'down',
    },
  ];

  // بيانات الإنذارات والشذوذ
  final List<Map<String, dynamic>> _alertsData = [
    {
      'type': 'استهلاك مرتفع',
      'area': 'حي العليا',
      'customer': 'أحمد محمد',
      'consumption': 850,
      'average': 450,
      'percentage': 89,
      'priority': 'عالي',
      'date': '2024-01-15',
    },
    {
      'type': 'شذوذ في الاستهلاك',
      'area': 'حي الرياض',
      'customer': 'سارة عبدالله',
      'consumption': 620,
      'average': 320,
      'percentage': 94,
      'priority': 'متوسط',
      'date': '2024-01-14',
    },
    {
      'type': 'انخفاض مفاجئ',
      'area': 'حي النخيل',
      'customer': 'خالد إبراهيم',
      'consumption': 120,
      'average': 380,
      'percentage': -68,
      'priority': 'منخفض',
      'date': '2024-01-13',
    },
  ];

  // بيانات مقارنة المناطق
  final List<Map<String, dynamic>> _comparisonData = [
    {
      'area1': 'حي العليا',
      'area2': 'حي الرياض',
      'consumption1': 15600,
      'consumption2': 12500,
      'difference': 3100,
      'differencePercent': 24.8,
    },
    {
      'area1': 'حي النخيل',
      'area2': 'حي الصفا',
      'consumption1': 8900,
      'consumption2': 7200,
      'difference': 1700,
      'differencePercent': 23.6,
    },
  ];

  // بيانات السجل التاريخي
  final List<Map<String, dynamic>> _historyData = [
    {
      'year': '2023',
      'totalConsumption': 685000,
      'growth': 8.2,
      'customers': 1250,
    },
    {
      'year': '2022',
      'totalConsumption': 633000,
      'growth': 6.5,
      'customers': 1180,
    },
    {
      'year': '2021',
      'totalConsumption': 594000,
      'growth': 5.8,
      'customers': 1120,
    },
    {
      'year': '2020',
      'totalConsumption': 561000,
      'growth': 4.2,
      'customers': 1050,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('مراقبة استهلاك الكهرباء'),
        backgroundColor: _primaryColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_gradientStart, _gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotifications,
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: _buildCurrentView(),
    );
  }

  // دالة لبناء الواجهة الحالية بناءً على التبويب المحدد
  Widget _buildCurrentView() {
    switch (_selectedTab) {
      case 0:
        return _buildMainView();
      case 1:
        return _buildReportsView();
      case 2:
        return _buildAlertsView();
      case 3:
        return _buildComparisonView();
      case 4:
        return _buildHistoryView();
      case 5:
        return _buildSettingsView();
      case 6:
        return _buildHelpView();
      default:
        return _buildMainView();
    }
  }

  // دالة لبناء القائمة المنزلقة (Drawer)
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_gradientStart, _gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
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
                  'سالم العلي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'مراقب استهلاك - المنطقة الشرقية',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(0, Icons.dashboard, 'لوحة التحكم الرئيسية', _selectedTab == 0),
          _buildDrawerItem(1, Icons.analytics, 'تقارير الاستهلاك', _selectedTab == 1),
          _buildDrawerItem(2, Icons.warning, 'الإنذارات والشذوذ', _selectedTab == 2),
          _buildDrawerItem(3, Icons.compare, 'مقارنة المناطق', _selectedTab == 3),
          _buildDrawerItem(4, Icons.history, 'السجل التاريخي', _selectedTab == 4),
          Divider(),
          _buildDrawerItem(5, Icons.settings, 'الإعدادات', _selectedTab == 5),
          _buildDrawerItem(6, Icons.help, 'المساعدة والدعم', _selectedTab == 6),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: _errorColor),
            title: Text('تسجيل الخروج'),
            onTap: () {
              Navigator.pop(context);
              // TODO: تنفيذ تسجيل الخروج
            },
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء عناصر القائمة
  Widget _buildDrawerItem(int index, IconData icon, String title, bool isSelected) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? _primaryColor : _textSecondaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? _primaryColor : _textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
        Navigator.pop(context);
      },
    );
  }

  // الواجهة الرئيسية (نظرة عامة + تحليلات)
  Widget _buildMainView() {
    return Column(
      children: [
        _buildMainTabBar(),
        Expanded(
          child: _selectedTab == 0 ? _buildOverviewTab() : _buildAnalyticsTab(),
        ),
      ],
    );
  }

  Widget _buildMainTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: _borderColor, width: 1),
      ),
      margin: const EdgeInsets.all(12),
      child: Row(
        children: [
          _buildMainTabButton(0, 'نظرة عامة', Icons.dashboard),
          _buildMainTabButton(1, 'التحليلات', Icons.analytics),
        ],
      ),
    );
  }

  Widget _buildMainTabButton(int index, String title, IconData icon) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected
              ? _primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              _selectedTab = index;
            });
          },
          style: TextButton.styleFrom(
            foregroundColor: isSelected ? _primaryColor : _textSecondaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // تبويب النظرة العامة
  Widget _buildOverviewTab() {
    final filteredData = _selectedArea == 'جميع المناطق'
        ? _consumptionData
        : _consumptionData
            .where((item) => item['area'] == _selectedArea)
            .toList();

    final totalConsumption = filteredData.fold<double>(
      0,
      (sum, item) => sum + (item['currentConsumption'] as int).toDouble(),
    );
    final totalCustomers = filteredData.fold<int>(
      0,
      (sum, item) => sum + (item['customers'] as int),
    );
    final avgConsumption = totalCustomers > 0
        ? totalConsumption / totalCustomers
        : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.8,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildStatCard(
                'إجمالي الاستهلاك',
                '${NumberFormat('#,###').format(totalConsumption)} ك.و.س',
                Icons.bolt,
                _primaryColor,
              ),
              _buildStatCard(
                'متوسط الاستهلاك',
                '${avgConsumption.toStringAsFixed(1)} ك.و.س/عميل',
                Icons.show_chart,
                _secondaryColor,
              ),
              _buildStatCard(
                'عدد العملاء',
                NumberFormat('#,###').format(totalCustomers),
                Icons.people,
                _successColor,
              ),
              _buildStatCard(
                'المناطق',
                '${_consumptionData.length}',
                Icons.location_on,
                _warningColor,
              ),
            ],
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'أداء المناطق',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
          ),
          const SizedBox(height: 12),

          ...filteredData.map((areaData) => _buildAreaCard(areaData)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                Icon(Icons.more_vert, color: _textSecondaryColor, size: 18),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: _textSecondaryColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaCard(Map<String, dynamic> areaData) {
    final isIncrease = areaData['changePercent'] > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    areaData['area'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isIncrease
                        ? _errorColor.withOpacity(0.1)
                        : _successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 14,
                        color: isIncrease ? _errorColor : _successColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${areaData['changePercent'].abs().toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isIncrease ? _errorColor : _successColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.spaceAround,
              children: [
                _buildAreaStat(
                  'الاستهلاك',
                  '${NumberFormat('#,###').format(areaData['currentConsumption'])} ك.و.س',
                ),
                _buildAreaStat(
                  'العملاء',
                  NumberFormat('#,###').format(areaData['customers']),
                ),
                _buildAreaStat(
                  'المتوسط',
                  '${areaData['avgConsumption']} ك.و.س',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: _textSecondaryColor)),
      ],
    );
  }

  // تبويب التحليلات
  Widget _buildAnalyticsTab() {
    final totalConsumption = _monthlyConsumptionData.fold<int>(
      0,
      (sum, item) => sum + (item['consumption'] as int),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainStatsCard(totalConsumption),
          const SizedBox(height: 20),
          _buildMonthlyChart(),
          const SizedBox(height: 20),
          _buildMonthlyDetailsList(),
        ],
      ),
    );
  }

  Widget _buildMainStatsCard(int totalConsumption) {
    final currentMonth = DateTime.now().month - 1;
    final currentMonthData = _monthlyConsumptionData[currentMonth];
    final isIncrease = currentMonthData['trend'] == 'up';
    final change = isIncrease
        ? currentMonthData['consumption'] - currentMonthData['previous']
        : currentMonthData['previous'] - currentMonthData['consumption'];
    final changePercent = (change / currentMonthData['previous'] * 100)
        .toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, _secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الاستهلاك الشهري الحالي',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      '${NumberFormat('#,###').format(currentMonthData['consumption'])} ك.و.س',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$changePercent%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.white.withOpacity(0.3), height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'الإجمالي السنوي',
                  '${NumberFormat('#,###').format(totalConsumption)} ك.و.س',
                ),
                _buildStatItem(
                  'متوسط شهري',
                  '${NumberFormat('#,###').format(totalConsumption ~/ 12)} ك.و.س',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildMonthlyChart() {
    final maxConsumption = _monthlyConsumptionData.fold<int>(
      0,
      (max, item) => item['consumption'] > max ? item['consumption'] : max,
    );

    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
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
              'مخطط الاستهلاك الشهري',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _monthlyConsumptionData.map((monthData) {
                    final height =
                        (monthData['consumption'] / maxConsumption) * 150;
                    final isIncrease = monthData['trend'] == 'up';

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Tooltip(
                            message:
                                '${monthData['month']}: ${NumberFormat('#,###').format(monthData['consumption'])} ك.و.س',
                            child: Container(
                              width: 25,
                              height: height,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isIncrease
                                      ? [_errorColor, _warningColor]
                                      : [_successColor, _primaryColor],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 60,
                            child: Text(
                              monthData['month'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _textColor,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyDetailsList() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
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
              'تفاصيل الاستهلاك الشهري',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            ..._monthlyConsumptionData
                .map((monthData) => _buildMonthListItem(monthData))
                ,
          ],
        ),
      ),
    );
  }

  Widget _buildMonthListItem(Map<String, dynamic> monthData) {
    final isIncrease = monthData['trend'] == 'up';
    final change = isIncrease
        ? monthData['consumption'] - monthData['previous']
        : monthData['previous'] - monthData['consumption'];
    final changePercent = (change / monthData['previous'] * 100)
        .toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isIncrease
                  ? _errorColor.withOpacity(0.1)
                  : _successColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
              color: isIncrease ? _errorColor : _successColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  monthData['month'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                Text(
                  '${NumberFormat('#,###').format(monthData['consumption'])} ك.و.س',
                  style: TextStyle(fontSize: 14, color: _textSecondaryColor),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$changePercent%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isIncrease ? _errorColor : _successColor,
                ),
              ),
              Text(
                isIncrease ? 'زيادة' : 'انخفاض',
                style: TextStyle(fontSize: 12, color: _textSecondaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // واجهة تقارير الاستهلاك
  Widget _buildReportsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تقارير الاستهلاك التفصيلية',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildReportSection(
            'تقرير الاستهلاك حسب المناطق',
            Icons.location_on,
            _consumptionData.map((area) => 
              '${area['area']}: ${NumberFormat('#,###').format(area['currentConsumption'])} ك.و.س (${area['changePercent'] > 0 ? '+' : ''}${area['changePercent']}%)'
            ).toList(),
          ),
          
          const SizedBox(height: 20),
          
          _buildReportSection(
            'تقرير الاستهلاك الشهري',
            Icons.calendar_today,
            _monthlyConsumptionData.map((month) => 
              '${month['month']}: ${NumberFormat('#,###').format(month['consumption'])} ك.و.س'
            ).toList(),
          ),
          
          const SizedBox(height: 20),
          
          _buildReportStatsCard(),
        ],
      ),
    );
  }

  Widget _buildReportSection(String title, IconData icon, List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
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
            Row(
              children: [
                Icon(icon, color: _primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text('• $item'),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildReportStatsCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
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
              'إحصائيات عامة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 20,
              runSpacing: 16,
              alignment: WrapAlignment.spaceAround,
              children: [
                _buildReportStat('إجمالي العملاء', '1,250'),
                _buildReportStat('متوسط الاستهلاك', '52 ك.و.س'),
                _buildReportStat('نمو سنوي', '8.2%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: _textSecondaryColor)),
      ],
    );
  }

  // واجهة الإنذارات والشذوذ
  Widget _buildAlertsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإنذارات والشذوذ في الاستهلاك',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          
          ..._alertsData.map((alert) => _buildAlertCard(alert)),
        ],
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    alert['type'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(alert['priority']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    alert['priority'],
                    style: TextStyle(
                      color: _getPriorityColor(alert['priority']),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('المنطقة: ${alert['area']}'),
            Text('العميل: ${alert['customer']}'),
            Text('التاريخ: ${alert['date']}'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Text('الاستهلاك الحالي: ${alert['consumption']} ك.و.س'),
                Text('المتوسط: ${alert['average']} ك.و.س'),
                Text('النسبة: ${alert['percentage']}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // واجهة مقارنة المناطق
  Widget _buildComparisonView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مقارنة أداء المناطق',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          
          ..._comparisonData.map((comparison) => _buildComparisonCard(comparison)),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(Map<String, dynamic> comparison) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
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
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(comparison['area1'], style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${NumberFormat('#,###').format(comparison['consumption1'])} ك.و.س'),
                  ],
                ),
                Icon(Icons.compare_arrows, color: _primaryColor),
                Column(
                  children: [
                    Text(comparison['area2'], style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${NumberFormat('#,###').format(comparison['consumption2'])} ك.و.س'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'الفرق: ${NumberFormat('#,###').format(comparison['difference'])} ك.و.س (${comparison['differencePercent']}%)',
              style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // واجهة السجل التاريخي
  Widget _buildHistoryView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'السجل التاريخي للاستهلاك',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          
          ..._historyData.map((year) => _buildHistoryCard(year)),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> year) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(year['year'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${NumberFormat('#,###').format(year['totalConsumption'])} ك.و.س'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('نمو ${year['growth']}%', style: TextStyle(color: _successColor, fontWeight: FontWeight.bold)),
                Text('${year['customers']} عميل'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // واجهة الإعدادات
  Widget _buildSettingsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإعدادات',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildSettingCard('إعدادات الإشعارات', Icons.notifications),
          _buildSettingCard('تحديث البيانات', Icons.refresh),
          _buildSettingCard('نسخة احتياطية', Icons.backup),
          _buildSettingCard('خصوصية البيانات', Icons.security),
        ],
      ),
    );
  }

  Widget _buildSettingCard(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: ListTile(
        leading: Icon(icon, color: _primaryColor),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: تنفيذ الإعدادات
        },
      ),
    );
  }

  // واجهة المساعدة والدعم
  Widget _buildHelpView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المساعدة والدعم',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildHelpCard('الدعم الفني', 'اتصل بفريق الدعم الفني', Icons.support_agent),
          _buildHelpCard('الأسئلة الشائعة', 'استفسارات شائعة', Icons.help_center),
          _buildHelpCard('تواصل معنا', 'معلومات الاتصال', Icons.contact_support),
        ],
      ),
    );
  }

  Widget _buildHelpCard(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: ListTile(
        leading: Icon(icon, color: _primaryColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: تنفيذ المساعدة
        },
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عالي':
        return _errorColor;
      case 'متوسط':
        return _warningColor;
      case 'منخفض':
        return _successColor;
      default:
        return _textSecondaryColor;
    }
  }

  void _showNotifications() {
    // TODO: Implement notifications screen
  }
}

void main() {
  runApp(const MaterialApp(home: ConsumptionMonitoringOfficerScreen()));
}
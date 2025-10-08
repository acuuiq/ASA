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
  String _selectedArea = 'جميع المناطق';
  String _selectedPeriod = 'هذا الشهر';

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

  // العملاء ذوو الاستهلاك المرتفع
  final List<Map<String, dynamic>> _highConsumptionCustomers = [
    {
      'name': 'أحمد محمد',
      'id': 'CUST-001',
      'consumption': 320,
      'avgAreaConsumption': 150,
      'percentage': 213,
      'address': 'حي الرياض - شارع الملك فهد',
      'previousConsumption': 280,
    },
    {
      'name': 'فاطمة علي',
      'id': 'CUST-002',
      'consumption': 290,
      'avgAreaConsumption': 145,
      'percentage': 200,
      'address': 'حي النخيل - شارع الأمير محمد',
      'previousConsumption': 260,
    },
    {
      'name': 'سالم عبدالله',
      'id': 'CUST-003',
      'consumption': 310,
      'avgAreaConsumption': 155,
      'percentage': 200,
      'address': 'حي العليا - شارع العروبة',
      'previousConsumption': 270,
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
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotifications,
          ),
        ],
      ),
      body: Column(
        children: [
          // تبويبات التنقل
          _buildTabBar(),

          // محتوى التبويبات
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildOverviewTab(),
                _buildHighConsumptionTab(),
                _buildAnalyticsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateReport,
        child: const Icon(Icons.picture_as_pdf),
        backgroundColor: _primaryColor,
      ),
    );
  }

  Widget _buildTabBar() {
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
          _buildTabButton(0, 'نظرة عامة', Icons.dashboard),
          _buildTabButton(1, 'استهلاك مرتفع', Icons.warning),
          _buildTabButton(2, 'التحليلات', Icons.analytics),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title, IconData icon) {
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
          // بطاقات الإحصائيات
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

          // عنوان قسم المناطق
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

          // قائمة المناطق
          ...filteredData.map((areaData) => _buildAreaCard(areaData)).toList(),
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
                Text(
                  areaData['area'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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

  Widget _buildHighConsumptionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'العملاء ذوو الاستهلاك المرتفع',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'العملاء الذين يتجاوز استهلاكهم 200% من متوسط المنطقة',
            style: TextStyle(fontSize: 14, color: _textSecondaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          ..._highConsumptionCustomers
              .map((customer) => _buildHighConsumptionCard(customer))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildHighConsumptionCard(Map<String, dynamic> customer) {
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
                Text(
                  customer['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${customer['percentage']}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _errorColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              customer['address'],
              style: TextStyle(fontSize: 14, color: _textSecondaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCustomerStat(
                  'الاستهلاك الحالي',
                  '${customer['consumption']} ك.و.س',
                ),
                _buildCustomerStat(
                  'المتوسط السابق',
                  '${customer['previousConsumption']} ك.و.س',
                ),
                _buildCustomerStat(
                  'متوسط المنطقة',
                  '${customer['avgAreaConsumption']} ك.و.س',
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _contactCustomer(customer),
                icon: const Icon(Icons.phone, size: 18),
                label: const Text('اتصال بالعميل'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: _textSecondaryColor)),
      ],
    );
  }

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
          // بطاقة الإحصائيات الرئيسية
          _buildMainStatsCard(totalConsumption),
          const SizedBox(height: 20),

          // مخطط الاستهلاك الشهري
          _buildMonthlyChart(),
          const SizedBox(height: 20),

          // قائمة التفاصيل الشهرية
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
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _monthlyConsumptionData.map((monthData) {
                  final height =
                      (monthData['consumption'] / maxConsumption) * 150;
                  final isIncrease = monthData['trend'] == 'up';

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Tooltip(
                        message:
                            '${monthData['month']}: ${NumberFormat('#,###').format(monthData['consumption'])} ك.و.س',
                        child: Container(
                          width: 20,
                          height: height,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isIncrease
                                  ? [_errorColor, _warningColor]
                                  : [_successColor, _primaryColor],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        monthData['month'].substring(0, 3),
                        style: TextStyle(
                          fontSize: 10,
                          color: _textSecondaryColor,
                        ),
                      ),
                    ],
                  );
                }).toList(),
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
                .toList(),
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تصفية البيانات'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedArea,
                  items:
                      [
                        'جميع المناطق',
                        ..._consumptionData.map((e) => e['area'] as String),
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedArea = newValue!;
                    });
                    Navigator.of(context).pop();
                  },
                  decoration: const InputDecoration(
                    labelText: 'المنطقة',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedPeriod,
                  items:
                      [
                        'هذا الشهر',
                        'الربع الأول',
                        'الربع الثاني',
                        'الربع الثالث',
                        'الربع الرابع',
                        'هذا العام',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPeriod = newValue!;
                    });
                    Navigator.of(context).pop();
                  },
                  decoration: const InputDecoration(
                    labelText: 'الفترة',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('تطبيق'),
            ),
          ],
        );
      },
    );
  }

  void _showNotifications() {
    // TODO: Implement notifications screen
  }

  void _generateReport() {
    // TODO: Implement report generation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('جاري إنشاء التقرير...')));
  }

  void _contactCustomer(Map<String, dynamic> customer) {
    // TODO: Implement customer contact
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('اتصال بـ ${customer['name']}'),
          content: Text('هل تريد الاتصال بالعميل ${customer['name']}؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement actual call
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('جاري الاتصال بـ ${customer['name']}...'),
                  ),
                );
              },
              child: const Text('اتصال'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(home: ConsumptionMonitoringOfficerScreen()));
}

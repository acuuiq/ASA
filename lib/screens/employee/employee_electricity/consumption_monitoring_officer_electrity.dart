import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsumptionMonitoringOfficerScreen extends StatefulWidget {
  const ConsumptionMonitoringOfficerScreen({super.key});
  static const String screenroot = 'consumption_monitoring_officer_screen';

  @override
  _ConsumptionMonitoringOfficerScreenState createState() =>
      _ConsumptionMonitoringOfficerScreenState();
}

class _ConsumptionMonitoringOfficerScreenState
    extends State<ConsumptionMonitoringOfficerScreen> {
  // الألوان للتصميم الرسمي
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

  // بيانات الاستهلاك الشهري
  final List<MonthlyConsumption> _monthlyData = [
    MonthlyConsumption('يناير', 45000, 42000),
    MonthlyConsumption('فبراير', 48000, 45000),
    MonthlyConsumption('مارس', 52000, 48000),
    MonthlyConsumption('أبريل', 55000, 52000),
    MonthlyConsumption('مايو', 62000, 55000),
    MonthlyConsumption('يونيو', 75000, 62000),
    MonthlyConsumption('يوليو', 82000, 75000),
    MonthlyConsumption('أغسطس', 78000, 82000),
    MonthlyConsumption('سبتمبر', 65000, 78000),
    MonthlyConsumption('أكتوبر', 58000, 65000),
    MonthlyConsumption('نوفمبر', 52000, 58000),
    MonthlyConsumption('ديسمبر', 47000, 52000),
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
        border: Border(bottom: BorderSide(color: _borderColor, width: 1)),
      ),
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
      child: TextButton(
        onPressed: () {
          setState(() {
            _selectedTab = index;
          });
        },
        style: TextButton.styleFrom(
          foregroundColor: isSelected ? _primaryColor : _textSecondaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
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
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 40,
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
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
          Row(
            children: [
              _buildStatCard(
                'إجمالي الاستهلاك',
                '${NumberFormat('#,###').format(totalConsumption)} ك.و.س',
                Icons.bolt,
                _primaryColor,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                'متوسط الاستهلاك',
                '${avgConsumption.toStringAsFixed(1)} ك.و.س/عميل',
                Icons.show_chart,
                _secondaryColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard(
                'عدد العملاء',
                NumberFormat('#,###').format(totalCustomers),
                Icons.people,
                _successColor,
              ),
              const SizedBox(width: 12),
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
          Text(
            'أداء المناطق',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 12),

          // قائمة المناطق
          ...filteredData.map((areaData) => _buildAreaCard(areaData)).toList(),
        ],
      ),
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
          ),
          const SizedBox(height: 16),

          ..._highConsumptionCustomers
              .map((customer) => _buildHighConsumptionCard(customer))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تحليلات الاستهلاك',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 16),

          // مخطط الاستهلاك الشهري (بديل عن syncfusion)
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'الاستهلاك الشهري (ك.و.س)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildCustomChart()),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLegendItem('هذا العام', _primaryColor),
                    _buildLegendItem('العام الماضي', _secondaryColor),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // إحصائيات مقارنة
          Text(
            'مقارنة الأداء',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildComparisonStats(),
        ],
      ),
    );
  }

  Widget _buildCustomChart() {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _ConsumptionChartPainter(_monthlyData),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 12, color: _textColor)),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: _textSecondaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAreaCard(Map<String, dynamic> areaData) {
    final isIncrease = areaData['changePercent'] > 0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: areaData['avgConsumption'] / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                areaData['avgConsumption'] > 60
                    ? _errorColor
                    : areaData['avgConsumption'] > 40
                    ? _warningColor
                    : _successColor,
              ),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
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

  Widget _buildHighConsumptionCard(Map<String, dynamic> customer) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer['id'],
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor,
                      ),
                    ),
                  ],
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
                    '+${customer['percentage']}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _errorColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCustomerStat(
                  'الاستهلاك',
                  '${customer['consumption']} ك.و.س',
                ),
                _buildCustomerStat(
                  'المتوسط',
                  '${customer['avgAreaConsumption']} ك.و.س',
                ),
                _buildCustomerStat(
                  'التغير',
                  '${((customer['consumption'] - customer['previousConsumption']) / customer['previousConsumption'] * 100).toStringAsFixed(1)}%',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              customer['address'],
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () => _contactCustomer(customer),
                  child: const Text('اتصال'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primaryColor,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _sendWarning(customer),
                  child: const Text('إرسال تنبيه'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _warningColor,
                  ),
                ),
              ],
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

  Widget _buildComparisonStats() {
    final totalCurrent = _monthlyData.fold<double>(
      0,
      (sum, item) => sum + item.currentYear,
    );
    final totalPrevious = _monthlyData.fold<double>(
      0,
      (sum, item) => sum + item.previousYear,
    );
    final changePercent =
        ((totalCurrent - totalPrevious) / totalPrevious * 100);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildComparisonItem(
              'هذا العام',
              '${NumberFormat('#,###').format(totalCurrent)} ك.و.س',
              _primaryColor,
            ),
            _buildComparisonItem(
              'العام الماضي',
              '${NumberFormat('#,###').format(totalPrevious)} ك.و.س',
              _secondaryColor,
            ),
            _buildComparisonItem(
              'التغير',
              '${changePercent.toStringAsFixed(1)}%',
              changePercent > 0 ? _errorColor : _successColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: _textSecondaryColor)),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تصفية البيانات'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('الفترة الزمنية'),
                  trailing: DropdownButton<String>(
                    value: _selectedPeriod,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPeriod = newValue!;
                      });
                      Navigator.pop(context);
                    },
                    items:
                        <String>[
                          'هذا الشهر',
                          'الربع الأول',
                          'الربع الثاني',
                          'الربع الثالث',
                          'الربع الرابع',
                          'هذا العام',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  ),
                ),
                ListTile(
                  title: const Text('المنطقة'),
                  trailing: DropdownButton<String>(
                    value: _selectedArea,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedArea = newValue!;
                      });
                      Navigator.pop(context);
                    },
                    items:
                        <String>[
                          'جميع المناطق',
                          'حي الرياض',
                          'حي النخيل',
                          'حي العليا',
                          'حي الصفا',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('تطبيق'),
            ),
          ],
        );
      },
    );
  }

  void _showNotifications() {
    // implementation for showing notifications
  }

  void _generateReport() {
    // implementation for generating reports
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري إنشاء التقرير...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _contactCustomer(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('اتصال بالعميل: ${customer['name']}'),
          content: Text('هل تريد الاتصال بالعميل ${customer['name']}؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // implementation for calling customer
              },
              child: const Text('اتصال'),
            ),
          ],
        );
      },
    );
  }

  void _sendWarning(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('إرسال تنبيه إلى: ${customer['name']}'),
          content: const Text(
            'هل تريد إرسال تنبيه استهلاك مرتفع إلى هذا العميل؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إرسال التنبيه إلى ${customer['name']}'),
                    backgroundColor: _successColor,
                  ),
                );
              },
              child: const Text('إرسال'),
            ),
          ],
        );
      },
    );
  }
}

class MonthlyConsumption {
  final String month;
  final double currentYear;
  final double previousYear;

  MonthlyConsumption(this.month, this.currentYear, this.previousYear);
}

// رسام مخصص للرسم البياني
class _ConsumptionChartPainter extends CustomPainter {
  final List<MonthlyConsumption> data;

  _ConsumptionChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final maxValue =
        data.fold<double>(
          0,
          (max, item) => item.currentYear > max ? item.currentYear : max,
        ) *
        1.1;

    // رسم المحور X
    final xAxisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, size.height - 20),
      Offset(size.width, size.height - 20),
      xAxisPaint,
    );

    // رسم الخطوط للبيانات
    _drawLine(
      canvas,
      size,
      data.map((e) => e.currentYear).toList(),
      Colors.blue,
      maxValue,
    );
    _drawLine(
      canvas,
      size,
      data.map((e) => e.previousYear).toList(),
      Colors.green,
      maxValue,
    );

    // رسم التسميات
    drawLabels(canvas, size, data.map((e) => e.month).toList());
  }

  void _drawLine(
    Canvas canvas,
    Size size,
    List<double> values,
    Color color,
    double maxValue,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final xStep = size.width / (values.length - 1);
    final yFactor = (size.height - 40) / maxValue;

    for (int i = 0; i < values.length; i++) {
      final x = i * xStep;
      final y = size.height - 20 - (values[i] * yFactor);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void drawLabels(Canvas canvas, Size size, List<String> labels) {
    final xstep = size.width / (labels.length - 1);
    final textStyle = TextStyle(fontSize: 10, color: Colors.black);

    for (int i = 0; i < labels.length; i++) {
      if (i % 2 == 0) {
        const ltr = ui.TextDirection.ltr;

        final paragraphBuilder = ui.ParagraphBuilder(
          ui.ParagraphStyle(
            textDirection: ltr, // تم التصحيح هنا
            fontSize: 10,
          ),
        );

        paragraphBuilder.pushStyle(textStyle as ui.TextStyle);
        paragraphBuilder.addText(labels[i]);
        final paragraph = paragraphBuilder.build();
        paragraph.layout(ui.ParagraphConstraints(width: size.width));

        final x = i * xstep - (paragraph.width / 2);
        final y = size.height - 5;

        canvas.drawParagraph(paragraph, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

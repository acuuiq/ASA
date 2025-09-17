import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyConsumptionScreen extends StatelessWidget {
  final String serviceTitle;
  final Color serviceColor;
  final List<Color> serviceGradient;

  const DailyConsumptionScreen({
    super.key,
    required this.serviceTitle,
    required this.serviceColor,
    required this.serviceGradient,
  });

  @override
  Widget build(BuildContext context) {
    // بيانات نموذجية للاستهلاك
    final dailyData = [
      {'day': 'الإثنين', 'consumption': 22, 'cost': 4500},
      {'day': 'الثلاثاء', 'consumption': 25, 'cost': 5100},
      {'day': 'الأربعاء', 'consumption': 18, 'cost': 3600},
      {'day': 'الخميس', 'consumption': 30, 'cost': 6200},
      {'day': 'الجمعة', 'consumption': 15, 'cost': 3000},
      {'day': 'السبت', 'consumption': 28, 'cost': 5800},
      {'day': 'الأحد', 'consumption': 20, 'cost': 4100},
    ];

    final currentConsumption = 25; // كيلوواط/ساعة أو لتر
    final currentCost = 5100; // دينار
    final dailyAverage = 23;
    final monthlyTotal = 690;
    final monthlyCost = 138000;

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الاستهلاك اليومي - $serviceTitle'),
        backgroundColor: serviceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة ملخص الاستهلاك الحالي
            _buildSummaryCard(context, currentConsumption, currentCost),
            
            const SizedBox(height: 20),
            
            // مخطط الاستهلاك الأسبوعي
            _buildWeeklyChart(dailyData),
            
            const SizedBox(height: 20),
            
            // إحصائيات إضافية
            _buildStatisticsSection(dailyAverage, monthlyTotal, monthlyCost),
            
            const SizedBox(height: 20),
            
            // نصائح لتوفير الطاقة/الماء
            _buildTipsSection(),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, int consumption, int cost) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: serviceGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'الاستهلاك اليومي',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                serviceTitle == 'الماء' ? '$consumption لتر' : '$consumption كيلوواط/ساعة',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${NumberFormat('#,###').format(cost)} دينار',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 15),
              LinearProgressIndicator(
                value: consumption / 50, // افترض أن الحد الأقصى 50
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 10),
              Text(
                '${(consumption / 50 * 100).toStringAsFixed(1)}% من الحد اليومي',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(List<Map<String, dynamic>> data) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الاستهلاك الأسبوعي',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 35,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: serviceColor,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()} ${serviceTitle == 'الماء' ? 'لتر' : 'ك.و/س'}',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              data[value.toInt()]['day'],
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: item['consumption'].toDouble(),
                          color: serviceColor,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
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

  Widget _buildStatisticsSection(int average, int monthlyTotal, int monthlyCost) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الإحصائيات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _buildStatItem(
              icon: Icons.av_timer,
              title: 'المتوسط اليومي',
              value: serviceTitle == 'الماء' ? '$average لتر' : '$average كيلوواط/ساعة',
            ),
            _buildStatItem(
              icon: Icons.calendar_month,
              title: 'الإجمالي الشهري',
              value: serviceTitle == 'الماء' ? '$monthlyTotal لتر' : '$monthlyTotal كيلوواط/ساعة',
            ),
            _buildStatItem(
              icon: Icons.attach_money,
              title: 'التكلفة الشهرية',
              value: '${NumberFormat('#,###').format(monthlyCost)} دينار',
            ),
            _buildStatItem(
              icon: Icons.trending_up,
              title: 'مقارنة بالشهر الماضي',
              value: '+5%',
              valueColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: serviceColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    final tips = serviceTitle == 'الماء'
        ? [
            'استخدم الدش بدلاً من حوض الاستحمام لتوفير الماء',
            'أصلح التسريبات فور اكتشافها',
            'استخدم غسالة الملابس عندما تكون ممتلئة بالكامل',
            'اغسل الخضروات في وعاء بدلاً من تحت الصنبور',
          ]
        : [
            'افصل الأجهزة الإلكترونية عند عدم الاستخدام',
            'استخدم مصابيح LED الموفرة للطاقة',
            'اضبط مكيف الهواء على 24 درجة مئوية',
            'نظف مرشحات المكيف بانتظام لتحسين الكفاءة',
          ];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نصائح لتوفير ${serviceTitle == "الماء" ? "الماء" : "الطاقة"}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...tips.map((tip) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline, color: serviceColor, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
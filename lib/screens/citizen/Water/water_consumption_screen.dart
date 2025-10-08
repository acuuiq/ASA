import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class WaterConsumptionScreen extends StatelessWidget {
  const WaterConsumptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات نموذجية للاستهلاك اليومي للماء
    final dailyData = [
      {'day': 'الإثنين', 'consumption': 220, 'cost': 4500},
      {'day': 'الثلاثاء', 'consumption': 250, 'cost': 5100},
      {'day': 'الأربعاء', 'consumption': 180, 'cost': 3600},
      {'day': 'الخميس', 'consumption': 300, 'cost': 6200},
      {'day': 'الجمعة', 'consumption': 150, 'cost': 3000},
      {'day': 'السبت', 'consumption': 280, 'cost': 5800},
      {'day': 'الأحد', 'consumption': 200, 'cost': 4100},
    ];

    final currentConsumption = 250; // لتر
    final currentCost = 5100; // دينار
    final dailyAverage = 230;
    final monthlyTotal = 6900;
    final monthlyCost = 138000;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الاستهلاك اليومي - الماء'),
        backgroundColor: const Color(0xFF2196F3),
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
            
            // نصائح لتوفير الماء
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
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
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
                '$consumption لتر',
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
                value: consumption / 500, // الحد الأقصى 500 لتر
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 10),
              Text(
                '${(consumption / 500 * 100).toStringAsFixed(1)}% من الحد اليومي',
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
                  maxY: 350,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: const Color(0xFF2196F3),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()} لتر',
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
                          color: const Color(0xFF2196F3),
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
              value: '$average لتر',
            ),
            _buildStatItem(
              icon: Icons.calendar_month,
              title: 'الإجمالي الشهري',
              value: '$monthlyTotal لتر',
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
          Icon(icon, color: const Color(0xFF2196F3), size: 20),
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
    final tips = [
      'استخدم الدش بدلاً من حوض الاستحمام لتوفير الماء',
      'أصلح التسريبات فور اكتشافها',
      'استخدم غسالة الملابس عندما تكون ممتلئة بالكامل',
      'اغسل الخضروات في وعاء بدلاً من تحت الصنبور',
      'استخدم صنابير موفرة للماء',
      'اجمع ماء المطر لري النباتات',
    ];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'نصائح لتوفير الماء',
              style: TextStyle(
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
                      Icon(Icons.lightbulb_outline, color: const Color(0xFF2196F3), size: 16),
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
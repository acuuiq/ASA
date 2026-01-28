import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ElectricityConsumptionScreen extends StatelessWidget {
  const ElectricityConsumptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات نموذجية للاستهلاك اليومي للكهرباء
    final dailyData = [
      {'day': 'الإثنين', 'consumption': 22, 'cost': 4500},
      {'day': 'الثلاثاء', 'consumption': 25, 'cost': 5100},
      {'day': 'الأربعاء', 'consumption': 18, 'cost': 3600},
      {'day': 'الخميس', 'consumption': 30, 'cost': 6200},
      {'day': 'الجمعة', 'consumption': 15, 'cost': 3000},
      {'day': 'السبت', 'consumption': 28, 'cost': 5800},
      {'day': 'الأحد', 'consumption': 20, 'cost': 4100},
    ];

    final currentConsumption = 25; // كيلوواط/ساعة
    final currentCost = 5100; // دينار
    final dailyAverage = 23;
    final monthlyTotal = 690;
    final monthlyCost = 138000;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الاستهلاك اليومي - الكهرباء'),
        backgroundColor: const Color(0xFFFF9800),
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
            
            // مخطط الاستهلاك الأسبوعي باستخدام syncfusion
            _buildWeeklyChart(dailyData),
            
            const SizedBox(height: 20),
            
            // إحصائيات إضافية
            _buildStatisticsSection(dailyAverage, monthlyTotal, monthlyCost),
            
            const SizedBox(height: 20),
            
            // نصائح لتوفير الطاقة
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
            colors: [Color(0xFFFF9800), Color(0xFFFFC107)],
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
                '$consumption كيلوواط/ساعة',
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
                value: consumption / 50, // الحد الأقصى 50 كيلوواط/ساعة
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
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
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  labelRotation: 0,
                  labelStyle: const TextStyle(fontSize: 10),
                  title: AxisTitle(text: ''),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(width: 1, color: Colors.grey),
                  labelStyle: const TextStyle(fontSize: 10),
                  title: AxisTitle(text: 'ك.و/س'),
                ),
                series: <CartesianSeries>[
                  BarSeries<Map<String, dynamic>, String>(
                    dataSource: data,
                    xValueMapper: (item, _) => item['day'],
                    yValueMapper: (item, _) => item['consumption'],
                    color: const Color(0xFFFF9800),
                    width: 0.6,
                    spacing: 0.2,
                    borderRadius: BorderRadius.circular(4),
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                      textStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.white, // هنا تم تغيير اللون إلى الأبيض
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                    final item = data[pointIndex];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${item['day']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item['consumption']} ك.و/س',
                            style: const TextStyle(
                              color: Color(0xFFFF9800),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${NumberFormat('#,###').format(item['cost'])} دينار',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
              value: '$average كيلوواط/ساعة',
            ),
            _buildStatItem(
              icon: Icons.calendar_month,
              title: 'الإجمالي الشهري',
              value: '$monthlyTotal كيلوواط/ساعة',
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
          Icon(icon, color: const Color(0xFFFF9800), size: 20),
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
      'افصل الأجهزة الإلكترونية عند عدم الاستخدام',
      'استخدم مصابيح LED الموفرة للطاقة',
      'اضبط مكيف الهواء على 24 درجة مئوية',
      'نظف مرشحات المكيف بانتظام لتحسين الكفاءة',
      'استخدم السخانات الشمسية لتسخين الماء',
      'اختر أجهزة كهربائية ذات كفاءة عالية في استهلاك الطاقة',
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
              'نصائح لتوفير الطاقة',
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
                      Icon(Icons.lightbulb_outline, color: const Color(0xFFFF9800), size: 16),
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
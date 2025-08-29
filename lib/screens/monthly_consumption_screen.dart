import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui';

class MonthlyConsumptionScreen extends StatelessWidget {
  final Color serviceColor;
  final List<Color> serviceGradient;
  final String serviceTitle;

  const MonthlyConsumptionScreen({
    super.key,
    required this.serviceColor,
    required this.serviceGradient,
    required this.serviceTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.grey[800]!;
    final shadowColor = isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.2);
    final dividerColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;

    // بيانات الاستهلاك السنوي
    final List<Map<String, dynamic>> fullYearData = [
      {'month': 'يناير', 'value': 420, 'target': 380, 'trend': Icons.arrow_upward},
      {'month': 'فبراير', 'value': 400, 'target': 380, 'trend': Icons.arrow_downward},
      {'month': 'مارس', 'value': 390, 'target': 380, 'trend': Icons.arrow_downward},
      {'month': 'أبريل', 'value': 410, 'target': 380, 'trend': Icons.arrow_upward},
      {'month': 'مايو', 'value': 430, 'target': 380, 'trend': Icons.arrow_upward},
      {'month': 'يونيو', 'value': 450, 'target': 380, 'trend': Icons.arrow_upward},
      {'month': 'يوليو', 'value': 440, 'target': 380, 'trend': Icons.arrow_downward},
      {'month': 'أغسطس', 'value': 460, 'target': 380, 'trend': Icons.arrow_upward},
      {'month': 'سبتمبر', 'value': 420, 'target': 380, 'trend': Icons.arrow_downward},
      {'month': 'أكتوبر', 'value': 400, 'target': 380, 'trend': Icons.arrow_downward},
      {'month': 'نوفمبر', 'value': 390, 'target': 380, 'trend': Icons.arrow_downward},
      {'month': 'ديسمبر', 'value': 410, 'target': 380, 'trend': Icons.arrow_upward},
    ];

    // بيانات آخر 6 أشهر
    final lastSixMonthsData = fullYearData.sublist(fullYearData.length - 6);
    
    final currentConsumption = lastSixMonthsData.last['value'];
    final previousConsumption = lastSixMonthsData[lastSixMonthsData.length - 2]['value'];
    final difference = currentConsumption - previousConsumption;
    final isIncrease = difference > 0;
    final unit = serviceTitle == 'الماء' ? 'لتر' : 'ك.و.س';
    final percentageChange = (difference.abs() / previousConsumption * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      appBar: AppBar(
        title: Text('الاستهلاك الشهري - $serviceTitle',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          )),
        backgroundColor: serviceColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: serviceGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: serviceColor.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة ملخص الاستهلاك مع تأثير زجاجي
            _GlassCard(
              blurStrength: 20,
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
                              'الاستهلاك الحالي',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$currentConsumption $unit',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isIncrease ? Icons.trending_up : Icons.trending_down,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 1,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'مقارنة بالشهر الماضي',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isIncrease 
                                ? Colors.red.withOpacity(0.3) 
                                : Colors.green.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$percentageChange%',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // بطاقة الرسم البياني الخطي
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مقارنة الاستهلاك الشهري',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                SizedBox(
  height: 250,
  child: LineChart(
    LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1000, // تغيير من 50 إلى 1000
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: dividerColor,
            strokeWidth: 1,
            dashArray: [5],
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: dividerColor,
            strokeWidth: 1,
            dashArray: [5],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (double value, TitleMeta meta) {
              final index = value.toInt();
              if (index >= 0 && index < lastSixMonthsData.length) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4,
                  child: Text(
                    lastSixMonthsData[index]['month'],
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (double value, TitleMeta meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 4,
                child: Text(
                  '${value.toInt()}',
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: dividerColor,
          width: 1,
        ),
      ),
      minX: 0,
      maxX: lastSixMonthsData.length.toDouble() - 1,
      minY: 0,
      maxY: 5000, // تغيير إلى 5000 بدلاً من القيمة الحسابية
      lineBarsData: [
        LineChartBarData(
          spots: lastSixMonthsData.asMap().entries.map((entry) {
            return FlSpot(
              entry.key.toDouble(),
              entry.value['value'].toDouble(),
            );
          }).toList(),
          isCurved: true,
          color: serviceColor,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 5,
                color: serviceColor,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                serviceColor.withOpacity(0.3),
                serviceColor.withOpacity(0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // خط الهدف
        LineChartBarData(
          spots: lastSixMonthsData.asMap().entries.map((entry) {
            return FlSpot(
              entry.key.toDouble(),
              entry.value['target'].toDouble(),
            );
          }).toList(),
          isCurved: true,
          color: Colors.orange,
          barWidth: 2,
          isStrokeCapRound: true,
          dashArray: [5, 5],
          dotData: FlDotData(show: false),
        ),
      ],
    ),
  ),
),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // بطاقة ملخص الاستهلاك السنوي (معدلة لترتيب عمودي)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ملخص الاستهلاك السنوي',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      _VerticalSummaryItem(
                        title: 'إجمالي الاستهلاك',
                        value: '${fullYearData.fold<int>(0, (int sum, item) => sum + (item['value'] as int))} $unit',
                        icon: Icons.data_usage,
                        color: Colors.blue,
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 12),
                      _VerticalSummaryItem(
                        title: 'متوسط الاستهلاك',
                        value: '${(fullYearData.fold<int>(0, (int sum, item) => sum + (item['value'] as int)) / 12).toStringAsFixed(1)} $unit',
                        icon: Icons.timeline,
                        color: Colors.green,
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 12),
                      _VerticalSummaryItem(
                        title: 'أعلى استهلاك',
                        value: '${fullYearData.reduce((a, b) => a['value'] > b['value'] ? a : b)['value']} $unit',
                        icon: Icons.arrow_upward,
                        color: Colors.red,
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 12),
                      _VerticalSummaryItem(
                        title: 'أقل استهلاك',
                        value: '${fullYearData.reduce((a, b) => a['value'] < b['value'] ? a : b)['value']} $unit',
                        icon: Icons.arrow_downward,
                        color: Colors.teal,
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // بطاقة نصائح التوفير
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: serviceColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'نصائح لتوفير $serviceTitle',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _TipCard(
                    title: 'إصلاح التسريبات',
                    description: 'تأكد من عدم وجود تسريبات في الأنابيب أو الحنفيات',
                    icon: Icons.home_repair_service,
                    color: Colors.blue,
                    isDarkMode: isDarkMode,
                  ),
                  _TipCard(
                    title: 'استخدام الأجهزة بكفاءة',
                    description: 'تشغيل الأجهزة الكهربائية في أوقات غير الذروة',
                    icon: Icons.electrical_services,
                    color: Colors.orange,
                    isDarkMode: isDarkMode,
                  ),
                  _TipCard(
                    title: 'الصيانة الدورية',
                    description: 'إجراء صيانة دورية للأجهزة لضمان كفاءتها',
                    icon: Icons.engineering,
                    color: Colors.green,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// عنصر ملخص عمودي جديد
class _VerticalSummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDarkMode;

  const _VerticalSummaryItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final double blurStrength;

  const _GlassCard({
    required this.child,
    this.blurStrength = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurStrength,
            sigmaY: blurStrength,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isDarkMode;

  const _TipCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_left,
            color: color,
            size: 28,
          ),
        ],
      ),
    );
  }
}
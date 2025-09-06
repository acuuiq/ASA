import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui';

class MonthlyConsumptionScreen extends StatefulWidget {
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
  State<MonthlyConsumptionScreen> createState() => _MonthlyConsumptionScreenState();
}

class _MonthlyConsumptionScreenState extends State<MonthlyConsumptionScreen> {
  int? _selectedMonthIndex;

  // بيانات الاستهلاك السنوي
  final List<Map<String, dynamic>> fullYearData = [
    {'month': 'يناير', 'value': 420, 'target': 380, 'trend': Icons.arrow_upward, 'color': Colors.purple, 'weeks': [95, 110, 105, 100]},
    {'month': 'فبراير', 'value': 400, 'target': 380, 'trend': Icons.arrow_downward, 'color': Colors.blue, 'weeks': [90, 105, 100, 105]},
    {'month': 'مارس', 'value': 390, 'target': 380, 'trend': Icons.arrow_downward, 'color': Colors.green, 'weeks': [85, 100, 95, 110]},
    {'month': 'أبريل', 'value': 410, 'target': 380, 'trend': Icons.arrow_upward, 'color': Colors.orange, 'weeks': [100, 95, 110, 105]},
    {'month': 'مايو', 'value': 430, 'target': 380, 'trend': Icons.arrow_upward, 'color': Colors.red, 'weeks': [110, 105, 115, 100]},
    {'month': 'يونيو', 'value': 450, 'target': 380, 'trend': Icons.arrow_upward, 'color': Colors.pink, 'weeks': [120, 110, 105, 115]},
    {'month': 'يوليو', 'value': 440, 'target': 380, 'trend': Icons.arrow_downward, 'color': Colors.purpleAccent, 'weeks': [115, 105, 110, 110]},
    {'month': 'أغسطس', 'value': 460, 'target': 380, 'trend': Icons.arrow_upward, 'color': Colors.blueAccent, 'weeks': [120, 115, 110, 115]},
    {'month': 'سبتمبر', 'value': 420, 'target': 380, 'trend': Icons.arrow_downward, 'color': Colors.greenAccent, 'weeks': [100, 110, 105, 105]},
    {'month': 'أكتوبر', 'value': 400, 'target': 380, 'trend': Icons.arrow_downward, 'color': Colors.amber, 'weeks': [95, 105, 100, 100]},
    {'month': 'نوفمبر', 'value': 390, 'target': 380, 'trend': Icons.arrow_downward, 'color': Colors.deepOrange, 'weeks': [90, 100, 95, 105]},
    {'month': 'ديسمبر', 'value': 410, 'target': 380, 'trend': Icons.arrow_upward, 'color': Colors.indigo, 'weeks': [95, 110, 105, 100]},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.grey[800]!;
    final shadowColor = isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.2);
    final dividerColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;

    // بيانات آخر 6 أشهر
    final lastSixMonthsData = fullYearData.sublist(fullYearData.length - 6);
    
    final currentConsumption = lastSixMonthsData.last['value'];
    final previousConsumption = lastSixMonthsData[lastSixMonthsData.length - 2]['value'];
    final difference = currentConsumption - previousConsumption;
    final isIncrease = difference > 0;
    final unit = widget.serviceTitle == 'الماء' ? 'لتر' : 'ك.و.س';
    final percentageChange = (difference.abs() / previousConsumption * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      appBar: AppBar(
        title: Text('الاستهلاك الشهري - ${widget.serviceTitle}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          )),
        backgroundColor: widget.serviceColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.serviceGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.serviceColor.withOpacity(0.5),
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
          

            const SizedBox(height: 24),

            // بطاقة الرسم البياني الشريطي
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
                    height: 300,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 500,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.black.withOpacity(0.7),
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${lastSixMonthsData[groupIndex]['month']}\n',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${rod.toY.toInt()} $unit',
                                    style: TextStyle(
                                      color: lastSixMonthsData[groupIndex]['color'],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          touchCallback: (event, response) {
                            if (response != null && response.spot != null) {
                              setState(() {
                                _selectedMonthIndex = response.spot!.touchedBarGroupIndex;
                              });
                            }
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                final index = value.toInt();
                                if (index >= 0 && index < lastSixMonthsData.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      lastSixMonthsData[index]['month'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textColor,
                                        fontWeight: _selectedMonthIndex == index 
                                            ? FontWeight.bold 
                                            : FontWeight.normal,
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
                                return Text(
                                  '${value.toInt()}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: textColor,
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
                        barGroups: lastSixMonthsData.asMap().entries.map((entry) {
                          final index = entry.key;
                          final monthData = entry.value;
                          
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: monthData['value'].toDouble(),
                                width: 22,
                                color: monthData['color'],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: lastSixMonthsData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final monthData = entry.value;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMonthIndex = index;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _selectedMonthIndex == index
                                ? monthData['color'].withOpacity(0.3)
                                : monthData['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: monthData['color'],
                              width: _selectedMonthIndex == index ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: monthData['color'],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                monthData['month'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textColor,
                                  fontWeight: _selectedMonthIndex == index 
                                      ? FontWeight.bold 
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // بطاقة تفاصيل الأسابيع (تظهر عند اختيار شهر)
            if (_selectedMonthIndex != null)
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
                        Icon(Icons.calendar_today, color: lastSixMonthsData[_selectedMonthIndex!]['color'], size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'تفاصيل استهلاك ${lastSixMonthsData[_selectedMonthIndex!]['month']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'توزيع الاستهلاك على الأسابيع',
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: List.generate(4, (weekIndex) {
                        final weekValue = lastSixMonthsData[_selectedMonthIndex!]['weeks'][weekIndex];
                        final total = lastSixMonthsData[_selectedMonthIndex!]['value'];
                        final percentage = (weekValue / total * 100).round();
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                child: Text(
                                  'الأسبوع ${weekIndex + 1}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: lastSixMonthsData[_selectedMonthIndex!]['color'].withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: weekValue / 150, // 150 هو القيمة القصوى المتوقعة للأسبوع
                                      child: Container(
                                        height: 24,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              lastSixMonthsData[_selectedMonthIndex!]['color'],
                                              lastSixMonthsData[_selectedMonthIndex!]['color'].withOpacity(0.7),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '$weekValue $unit',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '$percentage%',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

            if (_selectedMonthIndex != null) const SizedBox(height: 24),

            // بطاقة ملخص الاستهلاك السنوي
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
          ],
        ),
      ),
    );
  }
}

// عنصر ملخص عمودي
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
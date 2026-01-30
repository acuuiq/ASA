import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:table_calendar/table_calendar.dart';

class EmployeeScheduleScreen extends StatefulWidget {
  const EmployeeScheduleScreen({super.key});

  @override
  State<EmployeeScheduleScreen> createState() => _EmployeeScheduleScreenState();
}

class _EmployeeScheduleScreenState extends State<EmployeeScheduleScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // ========== نظام التقارير الجديد (من الكود الأول) ==========
  String _selectedArea = 'جميع المناطق';
  String _selectedReportTypeSystem = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;
  DateTime? _lastSelectedDate;
  final List<String> _areas = ['جميع المناطق', 'حي الرياض', 'حي النخيل', 'حي العليا', 'حي الصفا'];
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
  
  // بيانات التقارير - محدثة لمجال النفايات (نفس الكود الأول)
  final List<Map<String, dynamic>> reports = [
    {
      'id': 'REP-2024-001',
      'title': 'تقرير الإيرادات الشهري للنفايات',
      'type': 'مالي',
      'period': 'يناير 2024',
      'generatedDate': DateTime.now().subtract(Duration(days: 2)),
      'totalRevenue': 5000000,
      'totalBills': 200,
      'paidBills': 180,
    },
    {
      'id': 'REP-2024-002',
      'title': 'تقرير الفواتير المستلمة',
      'type': 'مالي',
      'period': 'يناير 2024',
      'generatedDate': DateTime.now().subtract(Duration(days: 5)),
      'receivedInvoices': '180 فاتورة',
      'totalReceivedAmount': '4,500,000 درهم',
      'averageReceivedAmount': '25,000 درهم/فاتورة'
    },
    {
      'id': 'REP-2024-003',
      'title': 'تقرير المدفوعات المتأخرة',
      'type': 'متابعة',
      'period': 'يناير 2024',
      'generatedDate': DateTime.now().subtract(Duration(days: 1)),
      'overdueAmount': 500000,
      'overdueBills': 20,
    },
  ];
  
  // ========== دوال التقارير (من الكود الأول) ==========
  String _formatCurrency(dynamic amount) {
    double numericAmount = 0.0;
    if (amount is int) {
      numericAmount = amount.toDouble();
    } else if (amount is double) {
      numericAmount = amount;
    } else if (amount is String) {
      numericAmount = double.tryParse(amount) ?? 0.0;
    }
    
    return '${NumberFormat('#,##0').format(numericAmount)} ';
  }
  
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
  
  void compareReports() {
    final revenueReport = reports[0];
    final receivedReport = reports[1];
    final overdueReport = reports[2];
    
    final totalRevenue = revenueReport['totalRevenue'] as int;
    final totalBills = revenueReport['totalBills'] as int;
    final paidBills = revenueReport['paidBills'] as int;
    
    final receivedInvoicesStr = receivedReport['receivedInvoices'] as String;
    final receivedInvoices = int.parse(receivedInvoicesStr.replaceAll(RegExp(r'[^0-9]'), ''));
    
    final totalReceivedAmountStr = receivedReport['totalReceivedAmount'] as String;
    final totalReceivedAmount = int.parse(totalReceivedAmountStr.replaceAll(RegExp(r'[^0-9]'), ''));
    
    final overdueAmount = overdueReport['overdueAmount'] as int;
    final overdueBills = overdueReport['overdueBills'] as int;
    
    final unpaidBills = totalBills - paidBills;
    final calculatedRevenue = totalReceivedAmount + overdueAmount;
    final calculatedBills = receivedInvoices + overdueBills;
    
    final revenueMatch = totalRevenue == calculatedRevenue;
    final billsMatch = totalBills == calculatedBills;
    
    print('=== مقارنة التقارير ===');
    print('📊 التقرير 1 - الإيرادات الشهرية: ${_formatNumber(totalRevenue)} درهم');
    print('📄 التقرير 2 - الفواتير المستلمة: ${_formatNumber(totalReceivedAmount)} درهم');
    print('⏰ التقرير 3 - المدفوعات المتأخرة: ${_formatNumber(overdueAmount)} درهم');
    print('🧮 المجموع المحسوب: ${_formatNumber(calculatedRevenue)} درهم');
    print('---');
    print('📊 التقرير 1 - إجمالي الفواتير: ${_formatNumber(totalBills)} فاتورة');
    print('📄 التقرير 2 - الفواتير المستلمة: ${_formatNumber(receivedInvoices)} فاتورة');
    print('⏰ التقرير 3 - الفواتير المتأخرة: ${_formatNumber(overdueBills)} فاتورة');
    print('🧮 المجموع المحسوب: ${_formatNumber(calculatedBills)} فاتورة');
    print('---');
    print('📈 نتائج المقارنة:');
    print('${revenueMatch ? '✅' : '❌'} الإيرادات ${revenueMatch ? 'مطابقة' : 'غير مطابقة'}');
    print('${billsMatch ? '✅' : '❌'} عدد الفواتير ${billsMatch ? 'مطابق' : 'غير مطابق'}');
  }
  
  void displayReportsInfo() {
    print('📑 التقارير المتاحة:');
    for (var report in reports) {
      print('\n--- ${report['title']} ---');
      print('🆔 الرقم: ${report['id']}');
      print('📁 النوع: ${report['type']}');
      print('📅 الفترة: ${report['period']}');
      print('🗓️ تاريخ الإنشاء: ${_formatDate(report['generatedDate'] as DateTime)}');
      
      if (report['id'] == 'REP-2024-001') {
        print('💰 الإيراد الكلي: ${_formatNumber(report['totalRevenue'] as int)} درهم');
        print('📋 إجمالي الفواتير: ${_formatNumber(report['totalBills'] as int)} فاتورة');
        print('✅ الفواتير المدفوعة: ${_formatNumber(report['paidBills'] as int)} فاتورة');
      } else if (report['id'] == 'REP-2024-002') {
        print('📥 الفواتير المستلمة: ${report['receivedInvoices']}');
        print('💳 إجمالي المبلغ المستلم: ${report['totalReceivedAmount']}');
        print('📊 متوسط المبلغ: ${report['averageReceivedAmount']}');
      } else if (report['id'] == 'REP-2024-003') {
        print('⚠️  المبلغ المتأخر: ${_formatNumber(report['overdueAmount'] as int)} درهم');
        print('⏰ الفواتير المتأخرة: ${_formatNumber(report['overdueBills'] as int)} فاتورة');
      }
    }
  }
  
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  // ========== واجهة التقارير (من الكود الأول) ==========
  Widget _buildReportsView(double screenWidth, [num? height]) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF117E75).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.assignment, color: const Color(0xFF117E75), size: 24),
              ),
              const SizedBox(width: 8),
              const Text(
                'نظام التقارير المتقدم',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF117E75),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildReportTypeFilter(),
          const SizedBox(height: 20),
          _buildReportOptions(),
          const SizedBox(height: 20),
          _buildGenerateReportButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  Widget _buildReportTypeFilter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
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
            const Text(
              'نوع التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _reportTypes.map((type) {
                  final isSelected = _selectedReportTypeSystem == type;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedReportTypeSystem = type;
                          _selectedDates.clear();
                          _selectedWeek = null;
                          _selectedMonth = null;
                        });
                      },
                      selectedColor: const Color(0xFF117E75).withOpacity(0.2),
                      checkmarkColor: const Color(0xFF117E75),
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFF117E75) : const Color(0xFF212121),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: isSelected ? const Color(0xFF117E75) : Colors.grey[300]!),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildReportOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
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
            const Text(
              'خيارات التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedReportTypeSystem == 'يومي') _buildDailyOptions(),
            if (_selectedReportTypeSystem == 'أسبوعي') _buildWeeklyOptions(),
            if (_selectedReportTypeSystem == 'شهري') _buildMonthlyOptions(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDailyOptions() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _showMultiDatePicker,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF117E75),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 8),
              Text('فتح التقويم واختيار التواريخ'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedDates.isNotEmpty) ...[
          const Text(
            'التواريخ المختارة:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedDates.map((date) {
              return Chip(
                backgroundColor: const Color(0xFF117E75).withOpacity(0.1),
                label: Text(DateFormat('yyyy-MM-dd').format(date), style: const TextStyle(color: Color(0xFF117E75))),
                deleteIconColor: const Color(0xFF117E75),
                onDeleted: () {
                  setState(() {
                    _selectedDates.remove(date);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${_selectedDates.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF117E75),
                      ),
                    ),
                    const Text('يوم مختار'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd').format(_selectedDates.first),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const Text('التاريخ المختار'),
                  ],
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[400], size: 48),
                const SizedBox(height: 8),
                Text(
                  'لم يتم اختيار أي تواريخ',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'انقر على الزر أعلاه لفتح التقويم واختيار التواريخ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildWeeklyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر الأسبوع',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _weeks.map((week) {
            final isSelected = _selectedWeek == week;
            return FilterChip(
              label: Text(
                week,
                style: const TextStyle(fontSize: 12),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedWeek = selected ? week : null;
                });
              },
              selectedColor: const Color(0xFF117E75).withOpacity(0.2),
              checkmarkColor: const Color(0xFF117E75),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF117E75) : const Color(0xFF212121),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? const Color(0xFF117E75) : Colors.grey[300]!),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildMonthlyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر الشهر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _months.map((month) {
            final isSelected = _selectedMonth == month;
            return FilterChip(
              label: Text(
                month,
                style: const TextStyle(fontSize: 12),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedMonth = selected ? month : null;
                });
              },
              selectedColor: const Color(0xFF117E75).withOpacity(0.2),
              checkmarkColor: const Color(0xFF117E75),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF117E75) : const Color(0xFF212121),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? const Color(0xFF117E75) : Colors.grey[300]!),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildGenerateReportButton() {
    bool isFormValid = false;
    
    switch (_selectedReportTypeSystem) {
      case 'يومي':
        isFormValid = _selectedDates.isNotEmpty;
        break;
      case 'أسبوعي':
        isFormValid = _selectedWeek != null;
        break;
      case 'شهري':
        isFormValid = _selectedMonth != null;
        break;
    }
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isFormValid ? _generateReport : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid ? const Color(0xFF117E75) : Colors.grey[400],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.summarize),
            const SizedBox(width: 8),
            Text(
              'إنشاء التقرير ${_selectedReportTypeSystem == 'يومي' && _selectedDates.isNotEmpty ? '(${_selectedDates.length} يوم)' : ''}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showMultiDatePicker() {
    final List<DateTime> originalSelection = List.from(_selectedDates);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('اختر التواريخ', style: TextStyle(color: Color(0xFF117E75), fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  TableCalendar(
                    firstDay: DateTime.now().subtract(const Duration(days: 365)),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    focusedDay: DateTime.now(),
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {CalendarFormat.month: 'شهري'},
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: const TextStyle(color: Color(0xFF117E75), fontWeight: FontWeight.bold),
                      leftChevronIcon: const Icon(Icons.chevron_left, color: Color(0xFF117E75)),
                      rightChevronIcon: const Icon(Icons.chevron_right, color: Color(0xFF117E75)),
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: const BoxDecoration(color: Color(0xFF117E75), shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(color: const Color(0xFF8D6E63), shape: BoxShape.circle),
                      weekendTextStyle: const TextStyle(color: Color(0xFFD32F2F)),
                      defaultTextStyle: const TextStyle(color: Color(0xFF212121)),
                      holidayTextStyle: const TextStyle(color: Color(0xFFF57C00)),
                    ),
                    selectedDayPredicate: (day) {
                      return _lastSelectedDate != null &&
                          _lastSelectedDate!.year == day.year &&
                          _lastSelectedDate!.month == day.month &&
                          _lastSelectedDate!.day == day.day;
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        bool isInList = _selectedDates.any((selectedDate) =>
                            selectedDate.year == selectedDay.year &&
                            selectedDate.month == selectedDay.month &&
                            selectedDate.day == selectedDay.day);
                        
                        if (!isInList) {
                          _selectedDates.add(selectedDay);
                        }
                        
                        _lastSelectedDate = selectedDay;
                      });
                    },
                  ),
                  if (_selectedDates.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'التاريخ المختار:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF117E75),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedDates.map((date) {
                            return Chip(
                              backgroundColor: const Color(0xFF117E75).withOpacity(0.1),
                              label: Text(DateFormat('yyyy-MM-dd').format(date), style: const TextStyle(color: Color(0xFF117E75))),
                              deleteIconColor: const Color(0xFF117E75),
                              onDeleted: () {
                                setState(() {
                                  _selectedDates.remove(date);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey[400], size: 48),
                          const SizedBox(height: 8),
                          Text(
                            'لم يتم اختيار أي تاريخ',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'انقر على التاريخ لاختياره',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _selectedDates.clear();
                  _selectedDates.addAll(originalSelection);
                  Navigator.pop(context);
                },
                child: Text('إلغاء', style: TextStyle(color: Colors.grey[600])),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF117E75),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: const Text('تم'),
              ),
            ],
          );
        },
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }
  
  void _toggleDateSelection(DateTime date) {
    setState(() {
      bool isInList = _selectedDates.any((selectedDate) =>
          selectedDate.year == date.year &&
          selectedDate.month == date.month &&
          selectedDate.day == date.day);
      
      if (!isInList) {
        _selectedDates.add(date);
      }
      
      _lastSelectedDate = date;
    });
  }
  
  void _generateReport() {
    if (_selectedReportTypeSystem == 'يومي' && _selectedDates.isEmpty) {
      _showErrorSnackbar('يرجى اختيار تواريخ أولاً');
      return;
    }
    
    String reportPeriod = '';
    
    switch (_selectedReportTypeSystem) {
      case 'يومي':
        if (_selectedDates.isNotEmpty) {
          final sortedDates = List<DateTime>.from(_selectedDates)..sort();
          if (_selectedDates.length == 1) {
            reportPeriod = DateFormat('yyyy-MM-dd').format(_selectedDates.first);
          } else {
            reportPeriod = '${DateFormat('yyyy-MM-dd').format(sortedDates.first)} إلى ${DateFormat('yyyy-MM-dd').format(sortedDates.last)}';
          }
        }
        break;
      case 'أسبوعي':
        reportPeriod = _selectedWeek ?? 'غير محدد';
        break;
      case 'شهري':
        reportPeriod = _selectedMonth ?? 'غير محدد';
        break;
    }
    
    _showSuccessSnackbar('تم إنشاء التقرير لـ ${_selectedDates.length} يوم بنجاح');
    _showGeneratedReport(reportPeriod);
  }
  
  void _showGeneratedReport(String period) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('التقرير $period', style: const TextStyle(color: Color(0xFF117E75), fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('نوع التقرير: $_selectedReportTypeSystem', style: const TextStyle(color: Color(0xFF212121))),
              if (_selectedReportTypeSystem == 'يومي' && _selectedDates.isNotEmpty)
                Text('عدد الأيام: ${_selectedDates.length}', style: const TextStyle(color: Color(0xFF212121))),
              if (_selectedWeek != null)
                Text('الأسبوع: $_selectedWeek', style: const TextStyle(color: Color(0xFF212121))),
              if (_selectedMonth != null)
                Text('الشهر: $_selectedMonth', style: const TextStyle(color: Color(0xFF212121))),
              const SizedBox(height: 16),
              const Text('ملخص التقرير:', style: TextStyle(color: Color(0xFF117E75), fontWeight: FontWeight.bold)),
              const Text('- إجمالي الفواتير: 3', style: TextStyle(color: Color(0xFF212121))),
              const Text('- الفواتير المدفوعة: 0', style: TextStyle(color: Color(0xFF212121))),
              const Text('- الفواتير غير المدفوعة: 3', style: TextStyle(color: Color(0xFF212121))),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF117E75),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _generatePdfReport(period);
            },
            child: const Text('تصدير PDF'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _generatePdfReport(String period) async {
    try {
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              _buildPdfHeader(period),
              pw.SizedBox(height: 20),
              pw.SizedBox(height: 20),
              _buildPdfBillsDetails(),
            ];
          },
        ),
      );
      
      final Uint8List pdfBytes = await pdf.save();
      await _sharePdfFile(pdfBytes, period);
      
    } catch (e) {
      _showErrorSnackbar('خطأ في تصدير التقرير: $e');
    }
  }
  
  pw.Widget _buildPdfHeader(String period) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'وزارة البلديات',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green,
              ),
            ),
            pw.Text(
              'تقرير نظام فواتير النفايات',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            pw.Text(
              'نوع التقرير: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(_selectedReportTypeSystem),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            pw.Text(
              'الفترة: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(period),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            pw.Text(
              'تاريخ الإنشاء: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())),
          ],
        ),
      ],
    );
  }
  
  pw.Widget _buildPdfSummary(int totalRevenue) {
    const totalBills = 3;
    const paidBills = 0;
    const unpaidBills = 3;
    const overdueBills = 1;
    
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.green),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ملخص التقرير',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('إجمالي الفواتير:'),
              pw.Text('${NumberFormat('#,##0').format(totalBills)}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('الفواتير المدفوعة:'),
              pw.Text('${NumberFormat('#,##0').format(paidBills)}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('الفواتير غير المدفوعة:'),
              pw.Text('${NumberFormat('#,##0').format(unpaidBills)}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('الفواتير المتأخرة:'),
              pw.Text('${NumberFormat('#,##0').format(overdueBills)}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('إجمالي الإيرادات:'),
              pw.Text('${NumberFormat('#,##0').format(totalRevenue)} دينار'),
            ],
          ),
        ],
      ),
    );
  }
  
  pw.Widget _buildPdfBillsDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'تفاصيل الفواتير',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.green,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.green100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('رقم الفاتورة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('المشترك', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('المبلغ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الحالة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('تاريخ الاستحقاق', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
  
  Future<void> _sharePdfFile(Uint8List pdfBytes, String period) async {
    try {
      final fileName = 'تقرير_فواتير_النفايات_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      await Share.shareXFiles(
        [
          XFile.fromData(
            pdfBytes,
            name: fileName,
            mimeType: 'application/pdf',
          )
        ],
        subject: 'تقرير فواتير النفايات - $period',
        text: 'مرفق تقرير فواتير النفايات للفترة $period',
      );
      
      _showSuccessSnackbar('تم تصدير التقرير بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في مشاركة الملف: $e');
    }
  }
  
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFD32F2F),
        duration: const Duration(seconds: 4),
      ),
    );
  }
  
  // ========== تعديل الجدول والبلاغات ==========
  List<DaySchedule> _weeklySchedule = [];
  List<DaySchedule> _originalSchedule = []; // لحفظ النسخة الأصلية قبل التعديل
  
  List<Truck> _availableTrucks = [
    Truck(
      id: 1,
      name: 'الشاحنة الرسمية ١',
      type: 'نفايات عامة',
      capacity: '١٥ طن',
      plateNumber: 'بغداد ١٢٣٤',
      sector: 'قطاع الكرخ',
      districts: ['شارع حيفا', 'سوق الشورجة', 'المنطقة التجارية'],
      status: 'جاهزة للعمل',
      isSelected: false,
      lastMaintenance: DateTime.now().subtract(Duration(days: 15)),
      nextMaintenance: DateTime.now().add(Duration(days: 45)),
      driver: 'أحمد كاظم',
    ),
    Truck(
      id: 2,
      name: 'الشاحنة الرسمية ٢',
      type: 'نفايات بناء',
      capacity: '٢٠ طن',
      plateNumber: 'بغداد ٥٦٧٨',
      sector: 'قطاع الرصافة',
      districts: ['البتاوين', 'الوزيرية', 'الاعظمية'],
      status: 'تحت الصيانة',
      isSelected: false,
      lastMaintenance: DateTime.now().subtract(Duration(days: 60)),
      nextMaintenance: DateTime.now().add(Duration(days: 30)),
      driver: 'سالم محمد',
    ),
    Truck(
      id: 3,
      name: 'الشاحنة الرسمية ٣',
      type: 'نفايات طبية',
      capacity: '١٠ طن',
      plateNumber: 'بغداد ٩٠١٢',
      sector: 'قطاع الكاظمية',
      districts: ['الشعب', 'النهضة', 'حي العلماء'],
      status: 'مشغولة حالياً',
      isSelected: false,
      lastMaintenance: DateTime.now().subtract(Duration(days: 30)),
      nextMaintenance: DateTime.now().add(Duration(days: 60)),
      driver: 'علي محمود',
    ),
    Truck(
      id: 4,
      name: 'الشاحنة الرسمية ٤',
      type: 'نفايات عامة',
      capacity: '١٢ طن',
      plateNumber: 'بغداد ٣٤٥٦',
      sector: 'قطاع المنصور',
      districts: ['شارع ١٤ رمضان', 'حي العدل', 'حي الأطباء'],
      status: 'جاهزة للعمل',
      isSelected: false,
      lastMaintenance: DateTime.now().subtract(Duration(days: 20)),
      nextMaintenance: DateTime.now().add(Duration(days: 70)),
      driver: 'حسن كاظم',
    ),
  ];
  
  List<Cleaner> _cleaners = [
    Cleaner(
      id: 1, 
      name: 'علي محمود', 
      phone: '٠٧٧١٢٣٤٥٦٧', 
      isSelected: false, 
      status: 'متاح',
      idNumber: '٨٧٦٥٤٣٢١٠',
      sector: 'قطاع الكرخ',
      experienceYears: 3,
      monthlySalary: '١،٢٠٠،٠٠٠ دينار',
      lastAttendance: DateTime.now().subtract(Duration(days: 1)),
    ),
    Cleaner(
      id: 2, 
      name: 'حسن كاظم', 
      phone: '٠٧٧٧٦٥٤٣٢١', 
      isSelected: false, 
      status: 'متاح',
      idNumber: '٩٨٧٦٥٤٣٢١',
      sector: 'قطاع الرصافة',
      experienceYears: 5,
      monthlySalary: '١،٥٠٠،٠٠٠ دينار',
      lastAttendance: DateTime.now(),
    ),
    Cleaner(
      id: 3, 
      name: 'مهدي عبدالله', 
      phone: '٠٧٧٩٨٧٦٥٤٣', 
      isSelected: false, 
      status: 'في المهمة',
      idNumber: '١٢٣٤٥٦٧٨٩',
      sector: 'قطاع الكاظمية',
      experienceYears: 2,
      monthlySalary: '١،٠٠٠،٠٠٠ دينار',
      lastAttendance: DateTime.now().subtract(Duration(days: 2)),
    ),
    Cleaner(
      id: 4, 
      name: 'حسين علي', 
      phone: '٠٧٧٤٥٦٧٨٩٠', 
      isSelected: false, 
      status: 'متاح',
      idNumber: '٥٥٥٦٦٦٧٧٧',
      sector: 'قطاع المنصور',
      experienceYears: 4,
      monthlySalary: '١،٣٠٠،٠٠٠ دينار',
      lastAttendance: DateTime.now(),
    ),
    Cleaner(
      id: 5, 
      name: 'قاسم أحمد', 
      phone: '٠٧٧٦٧٨٩٠١٢', 
      isSelected: false, 
      status: 'إجازة',
      idNumber: '٣٣٣٢٢٢١١١',
      sector: 'قطاع الكرخ',
      experienceYears: 6,
      monthlySalary: '١،٨٠٠،٠٠٠ دينار',
      lastAttendance: DateTime.now().subtract(Duration(days: 5)),
    ),
    Cleaner(
      id: 6, 
      name: 'جواد حسن', 
      phone: '٠٧٧٣٤٥٦٧٨٩', 
      isSelected: false, 
      status: 'متاح',
      idNumber: '٤٤٤٥٥٥٦٦٦',
      sector: 'قطاع الرصافة',
      experienceYears: 1,
      monthlySalary: '٩٠٠،٠٠٠ دينار',
      lastAttendance: DateTime.now(),
    ),
  ];
  
  List<Report> _reports = [
    Report(
      id: 1, 
      title: 'تراكم النفايات في الكرخ', 
      description: 'تراكم كبير للنفايات في منطقة الكرخ بالقرب من سوق الشورجة مما يسبب انتشار الروائح الكريهة ويعيق حركة السير. تم التبليغ من قبل عدة مواطنين في المنطقة، ويحتاج الأمر إلى تدخل سريع.', 
      date: DateTime.now().subtract(const Duration(days: 1)), 
      status: 'معلق',
      images: [
        'https://images.unsplash.com/photo-1557170334-a9632e77c6e4?w=400',
        'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400'
      ],
      location: 'بغداد - الكرخ - شارع حيفا',
      latitude: 33.3128,
      longitude: 44.3615,
      reporterName: 'أحمد كاظم',
      reporterPhone: '07701234567',
    ),
    Report(
      id: 2, 
      title: 'تكدس نفايات في الرصافة', 
      description: 'تكدس النفايات بالقرب من مستشفى ابن الخطيب في منطقة الرصافة يشكل خطراً صحياً على السكان والمرضى. النفايات تحتوي على مخلفات طبية مما يزيد من خطورتها.', 
      date: DateTime.now().subtract(const Duration(days: 2)), 
      status: 'قيد المعالجة',
      images: [
        'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400'
      ],
      location: 'بغداد - الرصافة - منطقة البتاوين',
      latitude: 33.3152,
      longitude: 44.3661,
      reporterName: 'سالم محمد',
      reporterPhone: '07707654321',
    ),
    Report(
      id: 3, 
      title: 'نفايات البناء في المنصور', 
      description: 'تجميع مخلفات البناء في الشوارع الرئيسية بمنطقة المنصور بالقرب من القصر الأبيض. المخلفات تشمل أسمنت وحديد وأخشاب وتسبب إعاقة كاملة للحركة المرورية.', 
      date: DateTime.now().subtract(const Duration(hours: 12)), 
      status: 'معلق',
      images: [],
      location: 'بغداد - المنصور - شارع ١٤ رمضان',
      latitude: 33.3050,
      longitude: 44.3469,
      reporterName: 'فاطمة عبدالله',
      reporterPhone: '07709876543',
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeSchedule();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _initializeSchedule() {
    final now = DateTime.now();
    final currentWeekStart = now.subtract(Duration(days: now.weekday % 7));
    
    _weeklySchedule = List.generate(7, (index) {
      final day = currentWeekStart.add(Duration(days: index));
      final isFriday = day.weekday == DateTime.friday;
      
      var daySchedule = DaySchedule(
        date: day,
        dayName: _getArabicDayName(day.weekday),
        startTime: isFriday ? 'لا يوجد جمع' : '٨:٠٠ ص',
        endTime: isFriday ? '' : '٦:٠٠ م',
        truck: isFriday ? null : _availableTrucks[index % _availableTrucks.length],
        isDayOff: isFriday,
        assignedCleaners: isFriday ? [] : _getRandomCleanersForDay(index),
      );
      return daySchedule;
    });
    
    // حفظ نسخة من الجدول الأصلي
    _originalSchedule = _weeklySchedule.map((schedule) => DaySchedule(
      date: schedule.date,
      dayName: schedule.dayName,
      startTime: schedule.startTime,
      endTime: schedule.endTime,
      truck: schedule.truck,
      isDayOff: schedule.isDayOff,
      assignedCleaners: List.from(schedule.assignedCleaners),
    )).toList();
  }
  
  List<Cleaner> _getRandomCleanersForDay(int dayIndex) {
    final shuffled = List<Cleaner>.from(_cleaners)..shuffle();
    return shuffled.take(2 + (dayIndex % 2)).toList();
  }
  
  String _getArabicDayName(int weekday) {
    switch (weekday) {
      case 7: return 'الأحد';
      case 1: return 'الإثنين';
      case 2: return 'الثلاثاء';
      case 3: return 'الأربعاء';
      case 4: return 'الخميس';
      case 5: return 'الجمعة';
      case 6: return 'السبت';
      default: return '';
    }
  }
  
  Widget _buildWasteScheduleTab() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF117E75),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text(
                'جدول جمع النفايات - بلدية بغداد',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.edit, size: 18),
                label: const Text(
                  'تعديل الجدول',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 14),
                ),
                onPressed: () => _editWasteSchedule(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF117E75),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'مواعيد جمع النفايات في العاصمة بغداد',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF117E75),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Expanded(
          child: ListView.builder(
            itemCount: _weeklySchedule.length,
            itemBuilder: (context, index) {
              final schedule = _weeklySchedule[index];
              return _buildScheduleRow(schedule);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildScheduleRow(DaySchedule schedule) {
    bool isDayOff = schedule.isDayOff;
    String timeText = isDayOff ? 'لا يوجد جمع' : '${schedule.startTime} - ${schedule.endTime}';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF117E75),
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(8),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    schedule.dayName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('yyyy/MM/dd').format(schedule.date),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    timeText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDayOff ? Colors.red : const Color(0xFF117E75),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  if (!isDayOff && schedule.truck != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      schedule.truck!.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                  if (!isDayOff && schedule.assignedCleaners.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${schedule.assignedCleaners.length} عامل',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReportsTab() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF117E75),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'البلاغات والشكاوى - بلدية بغداد',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _buildReportStatCard('معلق', _reports.where((r) => r.status == 'معلق').length, Colors.red),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildReportStatCard('قيد المعالجة', _reports.where((r) => r.status == 'قيد المعالجة').length, Colors.orange),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildReportStatCard('مكتمل', _reports.where((r) => r.status == 'مكتمل').length, Colors.green),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            itemCount: _reports.length,
            itemBuilder: (context, index) {
              return _buildReportCard(_reports[index], index);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildReportStatCard(String status, int count, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildReportCard(Report report, int index) {
    Color statusColor = Colors.grey;
    switch (report.status) {
      case 'مكتمل':
        statusColor = Colors.green;
        break;
      case 'قيد المعالجة':
        statusColor = Colors.orange;
        break;
      case 'معلق':
        statusColor = Colors.red;
        break;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    report.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: statusColor,
                ),
                Text(
                  DateFormat('yyyy/MM/dd - HH:mm').format(report.date),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              report.title,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF117E75),
                fontFamily: 'Tajawal',
              ),
            ),
            
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showReportDetails(report),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF117E75),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'عرض التفاصيل',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _changeReportStatus(index),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF117E75),
                      side: const BorderSide(color: Color(0xFF117E75)),
                    ),
                    child: const Text(
                      'تغيير الحالة',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTeamDistributionTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF117E75),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(12),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 16),
              unselectedLabelStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 14),
              tabs: const [
                Tab(text: '🔧 العمال النظافة'),
                Tab(text: '🚛 أسطول الشاحنات'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildCleanersTab(),
                _buildTrucksDistributionTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCleanersTab() {
    int selectedCount = _cleaners.where((cleaner) => cleaner.isSelected).length;
    int availableCount = _cleaners.where((cleaner) => cleaner.status == 'متاح').length;
    int onMissionCount = _cleaners.where((cleaner) => cleaner.status == 'في المهمة').length;
    int vacationCount = _cleaners.where((cleaner) => cleaner.status == 'إجازة').length;
    
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF117E75),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text(
                '👷 قوة العمل النظافة - بلدية بغداد',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCleanerStat('المجموع', '${_cleaners.length}'),
                  _buildCleanerStat('متاح', '$availableCount'),
                  _buildCleanerStat('مهمة', '$onMissionCount'),
                  _buildCleanerStat('إجازة', '$vacationCount'),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'تم اختيار $selectedCount عامل',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // أزرار التحكم
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: _selectAllCleaners,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.check_circle, color: const Color(0xFF4CAF50), size: 24),
                          const SizedBox(height: 4),
                          const Text(
                            'تحديد الكل',
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: _deselectAllCleaners,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.clear, color: Colors.red, size: 24),
                          const SizedBox(height: 4),
                          const Text(
                            'إلغاء الكل',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () => _exportWorkersReport(),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.print, color: const Color(0xFF2196F3), size: 24),
                          const SizedBox(height: 4),
                          const Text(
                            'طباعة',
                            style: TextStyle(
                              color: Color(0xFF2196F3),
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // قائمة العمال
        Expanded(
          child: ListView.builder(
            itemCount: _cleaners.length,
            itemBuilder: (context, index) {
              return _buildCleanerCard(_cleaners[index], index);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildTrucksDistributionTab() {
    int selectedCount = _availableTrucks.where((truck) => truck.isSelected).length;
    int readyCount = _availableTrucks.where((truck) => truck.status == 'جاهزة للعمل').length;
    int maintenanceCount = _availableTrucks.where((truck) => truck.status == 'تحت الصيانة').length;
    int busyCount = _availableTrucks.where((truck) => truck.status == 'مشغولة حالياً').length;
    
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF117E75),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text(
                '🚛 الأسطول الحكومي - بلدية بغداد',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTruckStat('المجموع', '${_availableTrucks.length}'),
                  _buildTruckStat('جاهزة', '$readyCount'),
                  _buildTruckStat('صيانة', '$maintenanceCount'),
                  _buildTruckStat('مشغولة', '$busyCount'),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'تم اختيار $selectedCount شاحنة',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // أزرار التحكم
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: _selectAllTrucks,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.check_circle, color: const Color(0xFF4CAF50), size: 24),
                          const SizedBox(height: 4),
                          const Text(
                            'تحديد الكل',
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: _deselectAllTrucks,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.clear, color: Colors.red, size: 24),
                          const SizedBox(height: 4),
                          const Text(
                            'إلغاء الكل',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () => _exportFleetReport(),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.print, color: const Color(0xFF2196F3), size: 24),
                          const SizedBox(height: 4),
                          const Text(
                            'طباعة',
                            style: TextStyle(
                              color: Color(0xFF2196F3),
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // قائمة الشاحنات
        Expanded(
          child: ListView.builder(
            itemCount: _availableTrucks.length,
            itemBuilder: (context, index) {
              return _buildTruckStatusCard(_availableTrucks[index], index);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildCleanerStat(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }
  
  Widget _buildTruckStat(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF117E75),
        title: const Text(
          'نظام إدارة النفايات - بلدية بغداد',
          style: TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Tajawal'),
          tabs: const [
            Tab(icon: Icon(Icons.calendar_today), text: 'الجدول'),
            Tab(icon: Icon(Icons.report), text: 'البلاغات'),
            Tab(icon: Icon(Icons.people), text: 'توزيع الفرق'),
            Tab(icon: Icon(Icons.assessment), text: 'التقارير'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWasteScheduleTab(),
          _buildReportsTab(),
          _buildTeamDistributionTab(),
          _buildReportsView(MediaQuery.of(context).size.width),
        ],
      ),
    );
  }
  
  // ========== دالة تعديل الجدول ==========
  void _editWasteSchedule() {
    List<DaySchedule> tempSchedule = List.from(_weeklySchedule);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'تعديل جدول النفايات',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF117E75),
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Tajawal',
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: tempSchedule.length,
                      itemBuilder: (context, index) {
                        final schedule = tempSchedule[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Checkbox(
                                      value: schedule.isDayOff,
                                      onChanged: (value) {
                                        setState(() {
                                          tempSchedule[index] = DaySchedule(
                                            date: schedule.date,
                                            dayName: schedule.dayName,
                                            startTime: value! ? 'لا يوجد جمع' : '٨:٠٠ ص',
                                            endTime: value ? '' : '٦:٠٠ م',
                                            truck: schedule.truck,
                                            isDayOff: value,
                                            assignedCleaners: schedule.assignedCleaners,
                                          );
                                        });
                                      },
                                      activeColor: const Color(0xFF117E75),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          schedule.dayName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF117E75),
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                        Text(
                                          DateFormat('yyyy/MM/dd').format(schedule.date),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                
                                if (!schedule.isDayOff) ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: schedule.startTime,
                                          decoration: const InputDecoration(
                                            labelText: 'وقت البدء',
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              tempSchedule[index] = DaySchedule(
                                                date: schedule.date,
                                                dayName: schedule.dayName,
                                                startTime: value,
                                                endTime: schedule.endTime,
                                                truck: schedule.truck,
                                                isDayOff: schedule.isDayOff,
                                                assignedCleaners: schedule.assignedCleaners,
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: schedule.endTime,
                                          decoration: const InputDecoration(
                                            labelText: 'وقت الانتهاء',
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              tempSchedule[index] = DaySchedule(
                                                date: schedule.date,
                                                dayName: schedule.dayName,
                                                startTime: schedule.startTime,
                                                endTime: value,
                                                truck: schedule.truck,
                                                isDayOff: schedule.isDayOff,
                                                assignedCleaners: schedule.assignedCleaners,
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _weeklySchedule = List.from(tempSchedule);
                            });
                            Navigator.pop(context);
                            _showSuccessSnackbar('تم حفظ التعديلات بنجاح');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'حفظ التعديلات',
                            style: TextStyle(fontFamily: 'Tajawal', fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _weeklySchedule = List.from(_originalSchedule);
                            });
                            Navigator.pop(context);
                            _showSuccessSnackbar('تم إلغاء التعديلات');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'إلغاء التعديلات',
                            style: TextStyle(fontFamily: 'Tajawal', fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  // ========== دالة عرض تفاصيل البلاغ ==========
  void _showReportDetails(Report report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              'تفاصيل البلاغ',
              style: const TextStyle(
                color: Color(0xFF117E75),
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // عنوان البلاغ
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF117E75).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    report.title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF117E75),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // حالة البلاغ
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Chip(
                      label: Text(
                        report.status,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      backgroundColor: _getStatusColor(report.status),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'حالة البلاغ:',
                      style: TextStyle(
                        color: Color(0xFF117E75),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // معلومات البلاغ
                _buildReportDetailItem('الوصف', report.description),
                _buildReportDetailItem('الموقع', report.location),
                _buildReportDetailItem('المبلغ', report.reporterName),
                _buildReportDetailItem('رقم الهاتف', report.reporterPhone),
                _buildReportDetailItem('تاريخ البلاغ', DateFormat('yyyy/MM/dd - HH:mm').format(report.date)),
                
                const SizedBox(height: 16),
                
                // صور البلاغ
                if (report.images.isNotEmpty) ...[
                  const Text(
                    'الصور المرفقة:',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF117E75),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: report.images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(report.images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                
                const SizedBox(height: 24),
                
                // زر العودة
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF117E75),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'رجوع',
                      style: TextStyle(fontFamily: 'Tajawal', fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildReportDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF117E75),
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF212121),
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'مكتمل':
        return Colors.green;
      case 'قيد المعالجة':
        return Colors.orange;
      case 'معلق':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  // ========== دالة تغيير حالة البلاغ ==========
  void _changeReportStatus(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'تغيير حالة البلاغ',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF117E75), fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'اختر الحالة الجديدة:',
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            const SizedBox(height: 16),
            _buildReportStatusOption('معلق', Colors.red, Icons.access_time, 'البلاغ في انتظار المعالجة', index),
            _buildReportStatusOption('قيد المعالجة', Colors.orange, Icons.build, 'البلاغ قيد التنفيذ', index),
            _buildReportStatusOption('مكتمل', Colors.green, Icons.check_circle, 'تم معالجة البلاغ', index),
          ],
        ),
      ),
    );
  }
  
  Widget _buildReportStatusOption(String status, Color color, IconData icon, String description, int reportIndex) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: color, size: 24),
        title: Text(
          status,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        subtitle: Text(
          description,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontFamily: 'Tajawal',
          ),
        ),
        trailing: _reports[reportIndex].status == status 
            ? Icon(Icons.check, color: color)
            : null,
        onTap: () {
          setState(() {
            _reports[reportIndex] = Report(
              id: _reports[reportIndex].id,
              title: _reports[reportIndex].title,
              description: _reports[reportIndex].description,
              date: _reports[reportIndex].date,
              status: status,
              images: _reports[reportIndex].images,
              location: _reports[reportIndex].location,
              latitude: _reports[reportIndex].latitude,
              longitude: _reports[reportIndex].longitude,
              reporterName: _reports[reportIndex].reporterName,
              reporterPhone: _reports[reportIndex].reporterPhone,
            );
          });
          Navigator.pop(context);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم تغيير حالة البلاغ إلى $status',
                textAlign: TextAlign.right,
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
              backgroundColor: color,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
  
  // ========== دالة طباعة تقرير العمال ==========
  void _exportWorkersReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصدير تقرير العمال', style: TextStyle(color: Color(0xFF117E75), fontFamily: 'Tajawal')),
        content: const Text('سيتم إنشاء تقرير بجميع بيانات العمال المختارين', style: TextStyle(fontFamily: 'Tajawal')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar('تم إنشاء تقرير العمال بنجاح');
            },
            child: const Text('تأكيد', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }
  
  // ========== دالة طباعة تقرير الأسطول ==========
  void _exportFleetReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصدير تقرير الأسطول', style: TextStyle(color: Color(0xFF117E75), fontFamily: 'Tajawal')),
        content: const Text('سيتم إنشاء تقرير بجميع بيانات الشاحنات المختارة', style: TextStyle(fontFamily: 'Tajawal')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar('تم إنشاء تقرير الأسطول بنجاح');
            },
            child: const Text('تأكيد', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }
  
  // ========== بطاقة العامل (التصميم المحسّن) ==========
  Widget _buildCleanerCard(Cleaner cleaner, int index) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.person;
    String statusDescription = '';
    
    switch (cleaner.status) {
      case 'متاح':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusDescription = 'متاح للتخصيص في أي مهمة';
        break;
      case 'في المهمة':
        statusColor = Colors.blue;
        statusIcon = Icons.work;
        statusDescription = 'مشغول حالياً في مهمة جمع نفايات';
        break;
      case 'إجازة':
        statusColor = Colors.orange;
        statusIcon = Icons.beach_access;
        statusDescription = 'في إجازة رسمية - غير متاح';
        break;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: cleaner.isSelected ? const Color(0xFF117E75) : Colors.transparent,
              width: 5,
            ),
          ),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              statusColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // رأس البطاقة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    value: cleaner.isSelected,
                    onChanged: (value) {
                      _toggleCleanerSelection(index);
                    },
                    activeColor: const Color(0xFF117E75),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, color: statusColor, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          cleaner.status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // معلومات العامل
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF117E75).withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: const Color(0xFF117E75),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          cleaner.name,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              cleaner.phone,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.phone, color: Colors.grey[400], size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // المعلومات الإضافية
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildCleanerInfoRow('الرقم الوظيفي', cleaner.idNumber),
                    _buildCleanerInfoRow('القطاع', cleaner.sector),
                    _buildCleanerInfoRow('الراتب', cleaner.monthlySalary),
                    _buildCleanerInfoRow('الخبرة', '${cleaner.experienceYears} سنة'),
                    _buildCleanerInfoRow('آخر حضور', DateFormat('yyyy/MM/dd').format(cleaner.lastAttendance)),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // وصف الحالة
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        statusDescription,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: statusColor,
                          fontFamily: 'Tajawal',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(statusIcon, color: statusColor, size: 16),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // أزرار التحكم
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.edit, size: 18, color: const Color(0xFF117E75)),
                      label: Text(
                        'تعديل',
                        style: TextStyle(
                          color: const Color(0xFF117E75),
                          fontFamily: 'Tajawal',
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () => _changeCleanerStatus(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF117E75).withOpacity(0.1),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.message, size: 18, color: Colors.white),
                      label: Text(
                        'تواصل',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () => _contactCleaner(cleaner),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF117E75),
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCleanerInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF212121),
              fontFamily: 'Tajawal',
              fontSize: 13,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF117E75),
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
  
  // ========== بطاقة الشاحنة (التصميم المحسّن) ==========
  Widget _buildTruckStatusCard(Truck truck, int index) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.local_shipping;
    String statusDescription = '';
    
    switch (truck.status) {
      case 'جاهزة للعمل':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusDescription = 'جاهزة للعمل - متاحة للاستخدام الفوري';
        break;
      case 'تحت الصيانة':
        statusColor = Colors.orange;
        statusIcon = Icons.build;
        statusDescription = 'قيد الصيانة الدورية - غير متاحة';
        break;
      case 'مشغولة حالياً':
        statusColor = Colors.blue;
        statusIcon = Icons.work;
        statusDescription = 'مشغولة في مهمة جمع نفايات';
        break;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: truck.isSelected ? const Color(0xFF117E75) : Colors.transparent,
              width: 5,
            ),
          ),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              statusColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // رأس البطاقة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    value: truck.isSelected,
                    onChanged: (value) {
                      _toggleTruckSelection(index);
                    },
                    activeColor: const Color(0xFF117E75),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, color: statusColor, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          truck.status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // معلومات الشاحنة الرئيسية
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF117E75).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.local_shipping,
                      color: const Color(0xFF117E75),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          truck.name,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          truck.type,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFF117E75),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // المعلومات الفنية
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // الصف الأول
                    Row(
                      children: [
                        Expanded(
                          child: _buildTruckDetailCard('السعة', truck.capacity, Icons.inventory),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTruckDetailCard('اللوحة', truck.plateNumber, Icons.confirmation_number),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // الصف الثاني
                    Row(
                      children: [
                        Expanded(
                          child: _buildTruckDetailCard('السائق', truck.driver, Icons.person),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTruckDetailCard('القطاع', truck.sector, Icons.location_on),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // مناطق الخدمة
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF117E75).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF117E75).withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'مناطق الخدمة:',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF117E75),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      truck.districts.join('، '),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFF212121),
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // معلومات الصيانة
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'آخر صيانة: ${DateFormat('yyyy/MM/dd').format(truck.lastMaintenance)}',
                          style: TextStyle(
                            color: statusColor,
                            fontFamily: 'Tajawal',
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          'الصيانة القادمة: ${DateFormat('yyyy/MM/dd').format(truck.nextMaintenance)}',
                          style: TextStyle(
                            color: statusColor,
                            fontFamily: 'Tajawal',
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    Icon(statusIcon, color: statusColor, size: 20),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // أزرار التحكم
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.edit, size: 18, color: const Color(0xFF117E75)),
                      label: Text(
                        'تعديل الحالة',
                        style: TextStyle(
                          color: const Color(0xFF117E75),
                          fontFamily: 'Tajawal',
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () => _changeTruckStatus(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF117E75).withOpacity(0.1),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.history, size: 18, color: Colors.white),
                      label: Text(
                        'سجل الصيانة',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () => _showMaintenanceHistory(truck),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF117E75),
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTruckDetailCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, color: const Color(0xFF117E75), size: 16),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF117E75),
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
  
  void _toggleCleanerSelection(int index) {
    setState(() {
      _cleaners[index] = Cleaner(
        id: _cleaners[index].id,
        name: _cleaners[index].name,
        phone: _cleaners[index].phone,
        isSelected: !_cleaners[index].isSelected,
        status: _cleaners[index].status,
        idNumber: _cleaners[index].idNumber,
        sector: _cleaners[index].sector,
        experienceYears: _cleaners[index].experienceYears,
        monthlySalary: _cleaners[index].monthlySalary,
        lastAttendance: _cleaners[index].lastAttendance,
      );
    });
  }
  
  void _toggleTruckSelection(int index) {
    setState(() {
      _availableTrucks[index] = Truck(
        id: _availableTrucks[index].id,
        name: _availableTrucks[index].name,
        type: _availableTrucks[index].type,
        capacity: _availableTrucks[index].capacity,
        plateNumber: _availableTrucks[index].plateNumber,
        sector: _availableTrucks[index].sector,
        districts: _availableTrucks[index].districts,
        status: _availableTrucks[index].status,
        isSelected: !_availableTrucks[index].isSelected,
        lastMaintenance: _availableTrucks[index].lastMaintenance,
        nextMaintenance: _availableTrucks[index].nextMaintenance,
        driver: _availableTrucks[index].driver,
      );
    });
  }
  
  void _contactCleaner(Cleaner cleaner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تواصل مع ${cleaner.name}', style: const TextStyle(color: Color(0xFF117E75), fontFamily: 'Tajawal')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('اختر طريقة التواصل:', style: TextStyle(fontFamily: 'Tajawal')),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('اتصال هاتفي', style: TextStyle(fontFamily: 'Tajawal')),
              subtitle: Text(cleaner.phone, style: const TextStyle(fontFamily: 'Tajawal')),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackbar('جاري الاتصال بـ ${cleaner.name}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Colors.blue),
              title: const Text('رسالة نصية', style: TextStyle(fontFamily: 'Tajawal')),
              subtitle: Text(cleaner.phone, style: const TextStyle(fontFamily: 'Tajawal')),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackbar('جاري إرسال رسالة لـ ${cleaner.name}');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }
  
  void _showMaintenanceHistory(Truck truck) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('سجل صيانة ${truck.name}', style: const TextStyle(color: Color(0xFF117E75), fontFamily: 'Tajawal')),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('تاريخ الصيانات:', style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildMaintenanceItem('صيانة دورية', 'تم تغيير الزيت والفلاتر', DateTime.now().subtract(Duration(days: 15)), 'مكتملة'),
                    _buildMaintenanceItem('إصلاح نظام الفرامل', 'إصلاح كامل لنظام الفرامل', DateTime.now().subtract(Duration(days: 45)), 'مكتملة'),
                    _buildMaintenanceItem('فحص إطارات', 'فحص وموازنة الإطارات', DateTime.now().subtract(Duration(days: 60)), 'مكتملة'),
                    _buildMaintenanceItem('صيانة المحرك', 'تنظيف وفحص المحرك', DateTime.now().subtract(Duration(days: 90)), 'مكتملة'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMaintenanceItem(String title, String description, DateTime date, String status) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.build, color: Color(0xFF117E75)),
        title: Text(title, style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              DateFormat('yyyy/MM/dd').format(date),
              style: const TextStyle(fontFamily: 'Tajawal', fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(status, style: const TextStyle(fontSize: 10, color: Colors.white)),
          backgroundColor: status == 'مكتملة' ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
  
  void _selectAllCleaners() {
    setState(() {
      for (int i = 0; i < _cleaners.length; i++) {
        _cleaners[i] = Cleaner(
          id: _cleaners[i].id,
          name: _cleaners[i].name,
          phone: _cleaners[i].phone,
          isSelected: true,
          status: _cleaners[i].status,
          idNumber: _cleaners[i].idNumber,
          sector: _cleaners[i].sector,
          experienceYears: _cleaners[i].experienceYears,
          monthlySalary: _cleaners[i].monthlySalary,
          lastAttendance: _cleaners[i].lastAttendance,
        );
      }
    });
    _showSuccessSnackbar('تم تحديد جميع العمال');
  }
  
  void _deselectAllCleaners() {
    setState(() {
      for (int i = 0; i < _cleaners.length; i++) {
        _cleaners[i] = Cleaner(
          id: _cleaners[i].id,
          name: _cleaners[i].name,
          phone: _cleaners[i].phone,
          isSelected: false,
          status: _cleaners[i].status,
          idNumber: _cleaners[i].idNumber,
          sector: _cleaners[i].sector,
          experienceYears: _cleaners[i].experienceYears,
          monthlySalary: _cleaners[i].monthlySalary,
          lastAttendance: _cleaners[i].lastAttendance,
        );
      }
    });
    _showSuccessSnackbar('تم إلغاء تحديد جميع العمال');
  }
  
  void _selectAllTrucks() {
    setState(() {
      for (int i = 0; i < _availableTrucks.length; i++) {
        _availableTrucks[i] = Truck(
          id: _availableTrucks[i].id,
          name: _availableTrucks[i].name,
          type: _availableTrucks[i].type,
          capacity: _availableTrucks[i].capacity,
          plateNumber: _availableTrucks[i].plateNumber,
          sector: _availableTrucks[i].sector,
          districts: _availableTrucks[i].districts,
          status: _availableTrucks[i].status,
          isSelected: true,
          lastMaintenance: _availableTrucks[i].lastMaintenance,
          nextMaintenance: _availableTrucks[i].nextMaintenance,
          driver: _availableTrucks[i].driver,
        );
      }
    });
    _showSuccessSnackbar('تم تحديد جميع الشاحنات');
  }
  
  void _deselectAllTrucks() {
    setState(() {
      for (int i = 0; i < _availableTrucks.length; i++) {
        _availableTrucks[i] = Truck(
          id: _availableTrucks[i].id,
          name: _availableTrucks[i].name,
          type: _availableTrucks[i].type,
          capacity: _availableTrucks[i].capacity,
          plateNumber: _availableTrucks[i].plateNumber,
          sector: _availableTrucks[i].sector,
          districts: _availableTrucks[i].districts,
          status: _availableTrucks[i].status,
          isSelected: false,
          lastMaintenance: _availableTrucks[i].lastMaintenance,
          nextMaintenance: _availableTrucks[i].nextMaintenance,
          driver: _availableTrucks[i].driver,
        );
      }
    });
    _showSuccessSnackbar('تم إلغاء تحديد جميع الشاحنات');
  }
  
  void _changeCleanerStatus(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'تغيير حالة العامل',
          textAlign: TextAlign.right,
          style: TextStyle(color: Color(0xFF117E75), fontFamily: 'Tajawal'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'اختر الحالة الجديدة:',
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            const SizedBox(height: 16),
            _buildCleanerStatusOption('متاح', Colors.green, Icons.check_circle, index),
            _buildCleanerStatusOption('في المهمة', Colors.blue, Icons.work, index),
            _buildCleanerStatusOption('إجازة', Colors.orange, Icons.beach_access, index),
            _buildCleanerStatusOption('مريض', Colors.red, Icons.medical_services, index),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _changeTruckStatus(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'تغيير حالة الشاحنة',
          textAlign: TextAlign.right,
          style: TextStyle(color: Color(0xFF117E75), fontFamily: 'Tajawal'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'اختر الحالة الجديدة:',
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            const SizedBox(height: 16),
            _buildTruckStatusOption('جاهزة للعمل', Colors.green, Icons.check_circle, index),
            _buildTruckStatusOption('تحت الصيانة', Colors.orange, Icons.build, index),
            _buildTruckStatusOption('مشغولة حالياً', Colors.blue, Icons.local_shipping, index),
            _buildTruckStatusOption('فارغة', Colors.purple, Icons.local_shipping, index),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCleanerStatusOption(String status, Color color, IconData icon, int cleanerIndex) {
    return ListTile(
      trailing: Icon(icon, color: color),
      title: Text(
        status,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
      ),
      onTap: () {
        setState(() {
          _cleaners[cleanerIndex] = Cleaner(
            id: _cleaners[cleanerIndex].id,
            name: _cleaners[cleanerIndex].name,
            phone: _cleaners[cleanerIndex].phone,
            isSelected: _cleaners[cleanerIndex].isSelected,
            status: status,
            idNumber: _cleaners[cleanerIndex].idNumber,
            sector: _cleaners[cleanerIndex].sector,
            experienceYears: _cleaners[cleanerIndex].experienceYears,
            monthlySalary: _cleaners[cleanerIndex].monthlySalary,
            lastAttendance: _cleaners[cleanerIndex].lastAttendance,
          );
        });
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم تغيير حالة ${_cleaners[cleanerIndex].name} إلى $status',
              textAlign: TextAlign.right,
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: color,
          ),
        );
      },
    );
  }
  
  Widget _buildTruckStatusOption(String status, Color color, IconData icon, int truckIndex) {
    return ListTile(
      trailing: Icon(icon, color: color),
      title: Text(
        status,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
      ),
      onTap: () {
        setState(() {
          _availableTrucks[truckIndex] = Truck(
            id: _availableTrucks[truckIndex].id,
            name: _availableTrucks[truckIndex].name,
            type: _availableTrucks[truckIndex].type,
            capacity: _availableTrucks[truckIndex].capacity,
            plateNumber: _availableTrucks[truckIndex].plateNumber,
            sector: _availableTrucks[truckIndex].sector,
            districts: _availableTrucks[truckIndex].districts,
            status: status,
            isSelected: _availableTrucks[truckIndex].isSelected,
            lastMaintenance: _availableTrucks[truckIndex].lastMaintenance,
            nextMaintenance: _availableTrucks[truckIndex].nextMaintenance,
            driver: _availableTrucks[truckIndex].driver,
          );
        });
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم تغيير حالة ${_availableTrucks[truckIndex].name} إلى $status',
              textAlign: TextAlign.right,
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: color,
          ),
        );
      },
    );
  }
  
  Widget _buildReportStatusOptionFullScreen(String status, Color color, IconData icon, String description, int reportIndex) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(
          status,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            description,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.arrow_forward_ios, color: color, size: 16),
        ),
        onTap: () {
          setState(() {
            _reports[reportIndex] = Report(
              id: _reports[reportIndex].id,
              title: _reports[reportIndex].title,
              description: _reports[reportIndex].description,
              date: _reports[reportIndex].date,
              status: status,
              images: _reports[reportIndex].images,
              location: _reports[reportIndex].location,
              latitude: _reports[reportIndex].latitude,
              longitude: _reports[reportIndex].longitude,
              reporterName: _reports[reportIndex].reporterName,
              reporterPhone: _reports[reportIndex].reporterPhone,
            );
          });
          Navigator.pop(context);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم تغيير حالة البلاغ إلى $status',
                textAlign: TextAlign.right,
                style: const TextStyle(fontFamily: 'Tajawal', fontSize: 16),
              ),
              backgroundColor: color,
              duration: const Duration(seconds: 3),
            ),
          );
        },
      ),
    );
  }
}

// النماذج المحدثة
class Report {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String status;
  final List<String> images;
  final String location;
  final double latitude;
  final double longitude;
  final String reporterName;
  final String reporterPhone;
  
  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.images,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.reporterName,
    required this.reporterPhone,
  });
}

class DaySchedule {
  final DateTime date;
  final String dayName;
  String startTime;
  String endTime;
  Truck? truck;
  bool isDayOff;
  List<Cleaner> assignedCleaners;
  
  DaySchedule({
    required this.date,
    required this.dayName,
    required this.startTime,
    required this.endTime,
    required this.truck,
    required this.isDayOff,
    required this.assignedCleaners,
  });
}

class Cleaner {
  final int id;
  final String name;
  final String phone;
  final bool isSelected;
  final String status;
  final String idNumber;
  final String sector;
  final int experienceYears;
  final String monthlySalary;
  final DateTime lastAttendance;
  
  Cleaner({
    required this.id,
    required this.name,
    required this.phone,
    required this.isSelected,
    required this.status,
    required this.idNumber,
    required this.sector,
    required this.experienceYears,
    required this.monthlySalary,
    required this.lastAttendance,
  });
}

class Truck {
  final int id;
  final String name;
  final String type;
  final String capacity;
  final String plateNumber;
  final String sector;
  final List<String> districts;
  final String status;
  final bool isSelected;
  final DateTime lastMaintenance;
  final DateTime nextMaintenance;
  final String driver;
  
  Truck({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.plateNumber,
    required this.sector,
    required this.districts,
    required this.status,
    required this.isSelected,
    required this.lastMaintenance,
    required this.nextMaintenance,
    required this.driver,
  });
}

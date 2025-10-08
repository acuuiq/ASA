//مسؤول البلاغات
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportingOfficerElectricityScreen extends StatefulWidget {
  static const String screenRoute = 'reporting_officer_electricity';

  const ReportingOfficerElectricityScreen({super.key});

  @override
  State<ReportingOfficerElectricityScreen> createState() =>
      _ReportingOfficerElectricityScreenState();
}

class _ReportingOfficerElectricityScreenState
    extends State<ReportingOfficerElectricityScreen> {
  // الألوان المستوحاة من التصميم الحكومي
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

  int _selectedTabIndex = 0;
  final List<String> _tabs = ['التقارير النشطة', 'التقارير المحلولة'];

  List<Map<String, dynamic>> activeReports = [
    {
      'id': 'REP-001',
      'location': 'شارع الملك فهد، الرياض',
      'type': 'عطل في العداد',
      'priority': 'عالي',
      'priorityColor': Color(0xFFD32F2F),
      'reportedDate': DateTime.now().subtract(const Duration(hours: 1)),
      'status': 'قيد المراجعة',
      'statusColor': Color(0xFFF57C00),
      'assignedTo': 'فريق الصيانة أ',
      'estimatedTime': '2 ساعة',
    },
    {
      'id': 'REP-002',
      'location': 'حي النخيل، جدة',
      'type': 'انقطاع تيار',
      'priority': 'عاجل',
      'priorityColor': Color(0xFFD32F2F),
      'reportedDate': DateTime.now().subtract(const Duration(minutes: 30)),
      'status': 'قيد التنفيذ',
      'statusColor': Color(0xFF1976D2),
      'assignedTo': 'فريق الطوارئ',
      'estimatedTime': '1 ساعة',
    },
    {
      'id': 'REP-003',
      'location': 'حي العليا، الرياض',
      'type': 'صيانة وقائية',
      'priority': 'متوسط',
      'priorityColor': Color(0xFFFFA000),
      'reportedDate': DateTime.now().subtract(const Duration(hours: 3)),
      'status': 'مجدول',
      'statusColor': Color(0xFF7B1FA2),
      'assignedTo': 'فريق الصيانة ب',
      'estimatedTime': '5 ساعات',
    },
  ];

  List<Map<String, dynamic>> resolvedReports = [
    {
      'id': 'REP-004',
      'location': 'حي الشفا، الرياض',
      'type': 'إصلاح كابل',
      'resolvedDate': DateTime.now().subtract(const Duration(days: 1)),
      'duration': '3 ساعات',
      'rating': '4.5',
      'technician': 'أحمد محمد',
      'cost': '1250 ر.س',
    },
    {
      'id': 'REP-005',
      'location': 'حي النزهة، جدة',
      'type': 'استبدال عداد',
      'resolvedDate': DateTime.now().subtract(const Duration(days: 2)),
      'duration': '2 ساعة',
      'rating': '4.8',
      'technician': 'خالد عبدالله',
      'cost': '800 ر.س',
    },
  ];

  // قائمة الحالات الممكنة للبلاغات النشطة
  final List<String> _statusOptions = [
    'قيد المراجعة',
    'مجدول',
    'قيد التنفيذ',
    'مكتمل',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: _primaryColor,
          elevation: 0,
          title: const Text(
            'مسؤول البلاغات - الكهرباء',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: _borderColor, width: 1),
                ),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 3, color: _primaryColor),
                  ),
                ),
                labelColor: _primaryColor,
                unselectedLabelColor: _textSecondaryColor,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 14),
                tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // التقارير النشطة
            _buildActiveReportsTab(),
            // التقارير المحلولة
            _buildResolvedReportsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: _primaryColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onPressed: _refreshReports,
          child: const Icon(Icons.refresh, size: 28, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildActiveReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // إحصائيات سريعة
          _buildStatsSection(),
          const SizedBox(height: 20),
          // قائمة التقارير النشطة
          Text(
            'البلاغات النشطة (${activeReports.length})',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...activeReports
              .map((report) => _buildActiveReportCard(report))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildResolvedReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // إحصائيات سريعة
          _buildResolvedStatsSection(),
          const SizedBox(height: 20),
          // قائمة التقارير المحلولة
          Text(
            'البلاغات المحلولة (${resolvedReports.length})',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...resolvedReports
              .map((report) => _buildResolvedReportCard(report))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final highPriorityCount = activeReports
        .where((r) => r['priority'] == 'عاجل' || r['priority'] == 'عالي')
        .length;
    final inProgressCount = activeReports
        .where((r) => r['status'] == 'قيد التنفيذ')
        .length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'إجمالي النشطة',
            value: activeReports.length.toString(),
            color: _primaryColor,
            icon: Icons.report_problem,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'عالية الأولوية',
            value: highPriorityCount.toString(),
            color: _errorColor,
            icon: Icons.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'قيد التنفيذ',
            value: inProgressCount.toString(),
            color: _secondaryColor,
            icon: Icons.build,
          ),
        ),
      ],
    );
  }

  Widget _buildResolvedStatsSection() {
    final avgDuration = resolvedReports.isNotEmpty
        ? resolvedReports
                  .map((r) => int.parse(r['duration'].split(' ')[0]))
                  .reduce((a, b) => a + b) /
              resolvedReports.length
        : 0;
    final avgRating = resolvedReports.isNotEmpty
        ? resolvedReports
                  .map((r) => double.parse(r['rating']))
                  .reduce((a, b) => a + b) /
              resolvedReports.length
        : 0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'إجمالي المحلولة',
            value: resolvedReports.length.toString(),
            color: _successColor,
            icon: Icons.check_circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'متوسط المدة',
            value: '${avgDuration.toStringAsFixed(1)} س',
            color: _secondaryColor,
            icon: Icons.timer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'متوسط التقييم',
            value: avgRating.toStringAsFixed(1),
            color: _warningColor,
            icon: Icons.star,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _cardColor,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: _textSecondaryColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveReportCard(Map<String, dynamic> report) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _showReportDetails(report),
        child: Container(
          decoration: BoxDecoration(color: _cardColor),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    report['id'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _textSecondaryColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: report['priorityColor'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: report['priorityColor'],
                        width: 1,
                      ),
                    ),
                    child: Text(
                      report['priority'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: report['priorityColor'],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                report['type'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: _textSecondaryColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      report['location'],
                      style: TextStyle(
                        fontSize: 14,
                        color: _textSecondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: _textSecondaryColor),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat(
                      'yyyy-MM-dd - HH:mm',
                    ).format(report['reportedDate']),
                    style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: report['statusColor'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      report['status'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: report['statusColor'],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.group, size: 16, color: _textSecondaryColor),
                  const SizedBox(width: 4),
                  Text(
                    'مخصص ل: ${report['assignedTo']}',
                    style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                  ),
                  const Spacer(),
                  Icon(Icons.timer, size: 16, color: _textSecondaryColor),
                  const SizedBox(width: 4),
                  Text(
                    'الوقت المتوقع: ${report['estimatedTime']}',
                    style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResolvedReportCard(Map<String, dynamic> report) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _showResolvedReportDetails(report),
        child: Container(
          decoration: BoxDecoration(color: _cardColor),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    report['id'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _textSecondaryColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: _successColor, width: 1),
                    ),
                    child: Text(
                      'مكتمل',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _successColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                report['type'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: _textSecondaryColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      report['location'],
                      style: TextStyle(
                        fontSize: 14,
                        color: _textSecondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: _textSecondaryColor),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat(
                      'yyyy-MM-dd - HH:mm',
                    ).format(report['resolvedDate']),
                    style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: _textSecondaryColor),
                      const SizedBox(width: 4),
                      Text(
                        'المدة: ${report['duration']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: _textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.engineering, size: 16, color: _textSecondaryColor),
                  const SizedBox(width: 4),
                  Text(
                    'الفني: ${report['technician']}',
                    style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${report['rating']}',
                        style: TextStyle(fontSize: 12, color: Colors.amber),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: _textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'التكلفة: ${report['cost']}',
                    style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _refreshReports() {
    // هنا سيتم تنفيذ عملية تحديث البيانات
    setState(() {
      // إعادة تحميل البيانات (في تطبيق حقيقي، سيتم جلب البيانات من API)
      activeReports = List.from(activeReports);
      resolvedReports = List.from(resolvedReports);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم تحديث البيانات بنجاح'),
        backgroundColor: _successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showReportDetails(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.report_problem, color: _primaryColor),
            const SizedBox(width: 8),
            Text('تفاصيل البلاغ', style: TextStyle(color: _textColor)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'رقم البلاغ: ${report['id']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('نوع البلاغ: ${report['type']}'),
              const SizedBox(height: 8),
              Text('الموقع: ${report['location']}'),
              const SizedBox(height: 8),
              Text('الأولوية: ${report['priority']}'),
              const SizedBox(height: 8),
              Text('الحالة: ${report['status']}'),
              const SizedBox(height: 8),
              Text(
                'وقت الإبلاغ: ${DateFormat('yyyy-MM-dd - HH:mm').format(report['reportedDate'])}',
              ),
              const SizedBox(height: 8),
              Text('مخصص ل: ${report['assignedTo']}'),
              const SizedBox(height: 8),
              Text('الوقت المتوقع: ${report['estimatedTime']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showUpdateStatusDialog(report);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
            child: const Text('تحديث الحالة'),
          ),
        ],
      ),
    );
  }

  void _showUpdateStatusDialog(Map<String, dynamic> report) {
    String? selectedStatus = report['status'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                Icon(Icons.update, color: _primaryColor),
                const SizedBox(width: 8),
                Text('تحديث حالة البلاغ', style: TextStyle(color: _textColor)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('رقم البلاغ: ${report['id']}'),
                const SizedBox(height: 16),
                Text('الحالة الحالية: ${report['status']}'),
                const SizedBox(height: 16),
                Text('اختر الحالة الجديدة:'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: _statusOptions.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedStatus = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedStatus != null) {
                    _updateReportStatus(report, selectedStatus!);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
                child: const Text('تأكيد التحديث'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateReportStatus(Map<String, dynamic> report, String newStatus) {
    setState(() {
      // تحديث حالة البلاغ
      int index = activeReports.indexWhere((r) => r['id'] == report['id']);
      if (index != -1) {
        activeReports[index]['status'] = newStatus;

        // تحديث لون الحالة بناءً على القيمة الجديدة
        if (newStatus == 'قيد المراجعة') {
          activeReports[index]['statusColor'] = _warningColor;
        } else if (newStatus == 'مجدول') {
          activeReports[index]['statusColor'] = Color(0xFF7B1FA2);
        } else if (newStatus == 'قيد التنفيذ') {
          activeReports[index]['statusColor'] = _secondaryColor;
        } else if (newStatus == 'مكتمل') {
          activeReports[index]['statusColor'] = _successColor;

          // إذا كانت الحالة الجديدة "مكتمل"، ننقل البلاغ إلى قائمة البلاغات المحلولة
          _moveToResolvedReports(activeReports[index]);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحديث حالة البلاغ إلى "$newStatus"'),
        backgroundColor: _successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _moveToResolvedReports(Map<String, dynamic> report) {
    setState(() {
      // إزالة البلاغ من القائمة النشطة
      activeReports.removeWhere((r) => r['id'] == report['id']);

      // إضافة البلاغ إلى القائمة المحلولة مع بيانات إضافية
      resolvedReports.add({
        'id': report['id'],
        'location': report['location'],
        'type': report['type'],
        'resolvedDate': DateTime.now(),
        'duration': report['estimatedTime'],
        'rating': (4.0 + Random().nextDouble()).toStringAsFixed(1),
        'technician': report['assignedTo'],
        'cost': '${500 + Random().nextInt(1500)} ر.س',
      });
    });
  }

  void _showResolvedReportDetails(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: _successColor),
            const SizedBox(width: 8),
            Text('تفاصيل البلاغ المحلول', style: TextStyle(color: _textColor)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'رقم البلاغ: ${report['id']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('نوع البلاغ: ${report['type']}'),
              const SizedBox(height: 8),
              Text('الموقع: ${report['location']}'),
              const SizedBox(height: 8),
              Text(
                'وقت الحل: ${DateFormat('yyyy-MM-dd - HH:mm').format(report['resolvedDate'])}',
              ),
              const SizedBox(height: 8),
              Text('المدة: ${report['duration']}'),
              const SizedBox(height: 8),
              Text('الفني: ${report['technician']}'),
              const SizedBox(height: 8),
              Text('التقييم: ${report['rating']} / 5'),
              const SizedBox(height: 8),
              Text('التكلفة: ${report['cost']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}

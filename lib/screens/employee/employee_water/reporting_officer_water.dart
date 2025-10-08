import 'package:flutter/material.dart';

class ReportingOfficerWaterScreen extends StatefulWidget {
  const ReportingOfficerWaterScreen({super.key});

  @override
  State<ReportingOfficerWaterScreen> createState() => _ReportingOfficerWaterScreenState();
}

class _ReportingOfficerWaterScreenState extends State<ReportingOfficerWaterScreen> {
  // بيانات تجريبية للبلاغات
  final List<Report> reports = [
    Report(
      id: '1',
      type: ReportType.waterService,
      title: 'انقطاع المياه',
      description: 'انقطاع المياه عن المنطقة منذ صباح اليوم',
      citizenName: 'أحمد محمد',
      date: '2023-10-15',
      time: '10:30',
      status: ReportStatus.pending,
      imageUrl: 'https://example.com/water-problem.jpg',
    ),
    Report(
      id: '2',
      type: ReportType.employeeNegligence,
      title: 'تقصير في العمل',
      description: 'موظف لم يحضر لمعالجة المشكلة',
      citizenName: 'فاطمة علي',
      date: '2023-10-14',
      time: '14:20',
      status: ReportStatus.inProgress,
      imageUrl: 'https://example.com/employee-issue.jpg',
    ),
    Report(
      id: '3',
      type: ReportType.appProblem,
      title: 'خطأ في التطبيق',
      description: 'التطبيق لا يستجيب عند محاولة الإبلاغ',
      citizenName: 'خالد إبراهيم',
      date: '2023-10-13',
      time: '09:15',
      status: ReportStatus.resolved,
      imageUrl: 'https://example.com/app-error.jpg',
    ),
  ];

  ReportType? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final filteredReports = _selectedFilter == null
        ? reports
        : reports.where((report) => report.type == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('البلاغات الواردة'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // فلتر حسب نوع البلاغ
          _buildFilterSection(),
          const SizedBox(height: 8),
          
          // قائمة البلاغات
          Expanded(
            child: filteredReports.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.report_problem, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'لا توجد بلاغات',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      return _buildReportCard(filteredReports[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              type: null,
              label: 'الكل',
              icon: Icons.all_inclusive,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              type: ReportType.waterService,
              label: 'مشكلة ماء',
              icon: Icons.water_drop,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              type: ReportType.employeeNegligence,
              label: 'تقصير موظفين',
              icon: Icons.person_off,
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              type: ReportType.appProblem,
              label: 'مشكلة تطبيق',
              icon: Icons.bug_report,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required ReportType? type,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedFilter == type;
    
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.blue),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? type : null;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.blue[700],
      side: BorderSide(color: Colors.blue.shade300),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildReportCard(Report report) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس البطاقة (النوع والحالة)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildReportTypeChip(report.type),
                _buildStatusChip(report.status),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // معلومات البلاغ
            Text(
              report.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              report.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // معلومات المبلغ والوقت
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        report.citizenName,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${report.date} - ${report.time}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // صورة البلاغ
            if (report.imageUrl != null && report.imageUrl!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'صورة البلاغ:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    report.imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'تعذر تحميل الصورة',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // أزرار الإجراءات
            if (report.status != ReportStatus.resolved) ...[
              Row(
                children: [
                  if (report.status == ReportStatus.pending) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateStatus(report, ReportStatus.inProgress),
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: const Text('بدء المعالجة'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateStatus(report, ReportStatus.resolved),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('تم الحل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[100]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'تم حل البلاغ',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeChip(ReportType type) {
    final typeInfo = _getTypeInfo(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: typeInfo.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: typeInfo.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getTypeIcon(type), size: 14, color: typeInfo.color),
          const SizedBox(width: 6),
          Text(
            typeInfo.label,
            style: TextStyle(
              color: typeInfo.color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ReportStatus status) {
    final statusInfo = _getStatusInfo(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusInfo.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusInfo.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(status), size: 14, color: statusInfo.color),
          const SizedBox(width: 6),
          Text(
            statusInfo.label,
            style: TextStyle(
              color: statusInfo.color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _updateStatus(Report report, ReportStatus newStatus) {
    setState(() {
      report.status = newStatus;
    });
    
    // هنا يمكن إضافة كود لإرسال التحديث إلى الخادم
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحديث حالة البلاغ إلى: ${_getStatusInfo(newStatus).label}'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  IconData _getTypeIcon(ReportType type) {
    switch (type) {
      case ReportType.waterService:
        return Icons.water_drop;
      case ReportType.employeeNegligence:
        return Icons.person_off;
      case ReportType.appProblem:
        return Icons.bug_report;
    }
  }

  IconData _getStatusIcon(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return Icons.access_time;
      case ReportStatus.inProgress:
        return Icons.play_arrow;
      case ReportStatus.resolved:
        return Icons.check_circle;
    }
  }

  TypeInfo _getTypeInfo(ReportType type) {
    switch (type) {
      case ReportType.waterService:
        return TypeInfo('مشكلة في خدمة الماء', Colors.blue);
      case ReportType.employeeNegligence:
        return TypeInfo('تقصير الموظفين', Colors.red);
      case ReportType.appProblem:
        return TypeInfo('مشكلة في التطبيق', Colors.orange);
    }
  }

  StatusInfo _getStatusInfo(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return StatusInfo('قيد الانتظار', Colors.orange);
      case ReportStatus.inProgress:
        return StatusInfo('قيد المعالجة', Colors.blue);
      case ReportStatus.resolved:
        return StatusInfo('تم الحل', Colors.green);
    }
  }
}

// نموذج البيانات
class Report {
  final String id;
  final ReportType type;
  final String title;
  final String description;
  final String citizenName;
  final String date;
  final String time;
  ReportStatus status;
  final String? imageUrl;

  Report({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.citizenName,
    required this.date,
    required this.time,
    required this.status,
    this.imageUrl,
  });
}

enum ReportType {
  waterService,
  employeeNegligence,
  appProblem,
}

enum ReportStatus {
  pending,
  inProgress,
  resolved,
}

class TypeInfo {
  final String label;
  final Color color;

  TypeInfo(this.label, this.color);
}

class StatusInfo {
  final String label;
  final Color color;

  StatusInfo(this.label, this.color);
}
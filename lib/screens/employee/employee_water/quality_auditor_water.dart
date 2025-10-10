// quality_auditor_water.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// استبدال خرائط Google بخريطة مبسطة مؤقتاً
class SimpleMapWidget extends StatelessWidget {
  final double lat;
  final double lng;
  final String address;

  const SimpleMapWidget({
    super.key,
    required this.lat,
    required this.lng,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'موقع البلاغ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 40, color: Colors.blue),
                const SizedBox(height: 8),
                Text(
                  'الإحداثيات: $lat, $lng',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                address,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class QualityAuditorWaterScreen extends StatefulWidget {
  static const String screenRoute = '/quality-auditor-water';

  const QualityAuditorWaterScreen({super.key});

  @override
  State<QualityAuditorWaterScreen> createState() => _QualityAuditorWaterScreenState();
}

class _QualityAuditorWaterScreenState extends State<QualityAuditorWaterScreen> {
  List<WaterQualityReport> reports = [];
  List<WaterQualityReport> filteredReports = [];
  String filterStatus = 'الكل';
  final List<String> statusFilters = ['الكل', 'معلق', 'قيد المعالجة', 'مكتمل', 'ملغي'];

  @override
  void initState() {
    super.initState();
    _loadSampleReports();
  }

  void _loadSampleReports() {
    List<WaterQualityReport> sampleReports = [
      WaterQualityReport(
        id: 'WQ-001',
        title: 'مشكلة في جودة المياه',
        description: 'المياه ذات رائحة كريهة ولون عكر في منطقة الرياض',
        reportType: 'جودة المياه',
        problemType: 'عكورة ورائحة',
        location: const WaterLocation(
          lat: 24.7136,
          lng: 46.6753,
          address: 'الرياض - حي الملز',
        ),
        reporterName: 'أحمد محمد',
        reporterPhone: '0551234567',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'معلق',
        priority: 'عالية',
        attachedImages: [
          XFile('assets/sample_water_1.jpg'), // صورة عينة
        ],
        waterParameters: WaterParameters(
          turbidity: 8.5,
          phLevel: 6.2,
          salinity: 1200,
          chlorine: 0.1,
          temperature: 28.0,
          tds: 850,
        ),
      ),
      WaterQualityReport(
        id: 'WQ-002',
        title: 'مياه مالحة',
        description: 'المياه مالحة جداً وغير صالحة للشرب في منطقة جدة',
        reportType: 'جودة المياه',
        problemType: 'ملوحة عالية',
        location: const WaterLocation(
          lat: 21.4858,
          lng: 39.1925,
          address: 'جدة - حي الصفا',
        ),
        reporterName: 'فاطمة عبدالله',
        reporterPhone: '0509876543',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        status: 'قيد المعالجة',
        priority: 'متوسطة',
        attachedImages: [
          XFile('assets/sample_water_2.jpg'), // صورة عينة
        ],
        waterParameters: WaterParameters(
          turbidity: 2.1,
          phLevel: 7.8,
          salinity: 2500,
          chlorine: 0.8,
          temperature: 30.5,
          tds: 1500,
        ),
      ),
    ];

    setState(() {
      reports = sampleReports;
      filteredReports = sampleReports;
    });
  }

  void _filterReports(String status) {
    setState(() {
      filterStatus = status;
      if (status == 'الكل') {
        filteredReports = reports;
      } else {
        filteredReports = reports.where((report) => report.status == status).toList();
      }
    });
  }

  void _updateReportStatus(String reportId, String newStatus) {
    setState(() {
      final report = reports.firstWhere((r) => r.id == reportId);
      report.status = newStatus;
      report.updatedAt = DateTime.now();
      _filterReports(filterStatus);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحديث حالة البلاغ إلى $newStatus'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showReportDetails(WaterQualityReport report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ReportDetailsBottomSheet(
          report: report,
          onStatusUpdate: _updateReportStatus,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        title: const Text(
          'تدقيق جودة المياه',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 2,
                color: Colors.black12,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsCard(),
          _buildReportsList(),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    final pendingCount = reports.where((r) => r.status == 'معلق').length;
    final inProgressCount = reports.where((r) => r.status == 'قيد المعالجة').length;
    final completedCount = reports.where((r) => r.status == 'مكتمل').length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 3,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('معلق', pendingCount, Colors.orange),
          _buildStatItem('قيد المعالجة', inProgressCount, Colors.blue),
          _buildStatItem('مكتمل', completedCount, Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildReportsList() {
    return Expanded(
      child: filteredReports.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.water_damage_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد بلاغات',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredReports.length,
              itemBuilder: (context, index) {
                final report = filteredReports[index];
                return _buildReportCard(report);
              },
            ),
    );
  }

  Widget _buildReportCard(WaterQualityReport report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _showReportDetails(report),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(report.status),
                  _buildPriorityChip(report.priority),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                report.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                report.description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      report.location.address,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(report.timestamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Text(
                    report.id,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (report.waterParameters != null) ...[
                const SizedBox(height: 12),
                _buildWaterParametersPreview(report.waterParameters!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status) {
      case 'معلق':
        chipColor = Colors.orange;
      case 'قيد المعالجة':
        chipColor = Colors.blue;
      case 'مكتمل':
        chipColor = Colors.green;
      case 'ملغي':
        chipColor = Colors.red;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color chipColor;
    switch (priority) {
      case 'عالية':
        chipColor = Colors.red;
      case 'متوسطة':
        chipColor = Colors.orange;
      case 'منخفضة':
        chipColor = Colors.green;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        priority,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildWaterParametersPreview(WaterParameters parameters) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معايير جودة المياه:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildParameterItem('العكورة', '${parameters.turbidity} NTU'),
              _buildParameterItem('الأس الهيدروجيني', parameters.phLevel.toString()),
              _buildParameterItem('الملوحة', '${parameters.salinity} ppm'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParameterItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تصفية البلاغات'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: statusFilters.length,
              itemBuilder: (context, index) {
                final status = statusFilters[index];
                return RadioListTile<String>(
                  title: Text(status),
                  value: status,
                  groupValue: filterStatus,
                  onChanged: (value) {
                    Navigator.pop(context);
                    _filterReports(value!);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class ReportDetailsBottomSheet extends StatefulWidget {
  final WaterQualityReport report;
  final Function(String, String) onStatusUpdate;

  const ReportDetailsBottomSheet({
    super.key,
    required this.report,
    required this.onStatusUpdate,
  });

  @override
  State<ReportDetailsBottomSheet> createState() => _ReportDetailsBottomSheetState();
}

class _ReportDetailsBottomSheetState extends State<ReportDetailsBottomSheet> {
  int _selectedTab = 0;

  void _updateStatus(String newStatus) {
    widget.onStatusUpdate(widget.report.id, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 60,
            height: 5,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'تفاصيل البلاغ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTab('تفاصيل البلاغ', 0),
                _buildTab('معايير الجودة', 1),
                _buildTab('وصف المشكلة', 2),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _getCurrentTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int tabIndex) {
    final isSelected = _selectedTab == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = tabIndex;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getCurrentTab() {
    switch (_selectedTab) {
      case 0:
        return _buildDetailsTab();
      case 1:
        return _buildQualityTab();
      case 2:
        return _buildProblemDescriptionTab();
      default:
        return _buildDetailsTab();
    }
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReportHeader(),
          const SizedBox(height: 20),
          SimpleMapWidget(
            lat: widget.report.location.lat,
            lng: widget.report.location.lng,
            address: widget.report.location.address,
          ),
          const SizedBox(height: 20),
          _buildReportDetails(),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildQualityTab() {
    if (widget.report.waterParameters == null) {
      return const Center(
        child: Text(
          'لا توجد بيانات معايير جودة المياه',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWaterParameters(),
          const SizedBox(height: 20),
          _buildQualitySummary(),
        ],
      ),
    );
  }

  Widget _buildProblemDescriptionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // وصف المشكلة
          _buildProblemDescription(),
          const SizedBox(height: 20),
          
          // الصور المرفقة
          _buildAttachedImages(),
        ],
      ),
    );
  }

  Widget _buildProblemDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'وصف المشكلة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.report.description,
                style: const TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'نوع المشكلة: ${widget.report.problemType}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.water_drop, color: Colors.blue, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.report.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.report.problemType,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildStatusChip(widget.report.status),
                    const SizedBox(width: 8),
                    _buildPriorityChip(widget.report.priority),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تفاصيل البلاغ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildDetailItem('رقم البلاغ', widget.report.id),
        _buildDetailItem('نوع البلاغ', widget.report.reportType),
        _buildDetailItem('نوع المشكلة', widget.report.problemType),
        _buildDetailItem('اسم المبلغ', widget.report.reporterName),
        _buildDetailItem('هاتف المبلغ', widget.report.reporterPhone),
        _buildDetailItem('وقت البلاغ', 
          DateFormat('yyyy-MM-dd HH:mm').format(widget.report.timestamp)),
        if (widget.report.updatedAt != null)
          _buildDetailItem('آخر تحديث', 
            DateFormat('yyyy-MM-dd HH:mm').format(widget.report.updatedAt!)),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterParameters() {
    final params = widget.report.waterParameters!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'معايير جودة المياه',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildParameterRow('العكورة', '${params.turbidity} NTU', 
                _getParameterStatus(params.turbidity, 5.0, 'turbidity')),
              _buildParameterRow('الأس الهيدروجيني', params.phLevel.toStringAsFixed(1),
                _getParameterStatus(params.phLevel, 6.5, 'ph')),
              _buildParameterRow('الملوحة', '${params.salinity} ppm',
                _getParameterStatus(params.salinity, 1000, 'salinity')),
              _buildParameterRow('الكلور', '${params.chlorine} mg/L',
                _getParameterStatus(params.chlorine, 0.5, 'chlorine')),
              _buildParameterRow('درجة الحرارة', '${params.temperature}°C',
                _getParameterStatus(params.temperature, 25, 'temperature')),
              _buildParameterRow('إجمالي المواد الذاتية', '${params.tds} ppm',
                _getParameterStatus(params.tds, 500, 'tds')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQualitySummary() {
    final params = widget.report.waterParameters!;
    int goodCount = 0;
    int badCount = 0;

    // حساب عدد المعايير الجيدة والغير مقبولة
    if (_getParameterStatus(params.turbidity, 5.0, 'turbidity') == 'جيد') goodCount++; else badCount++;
    if (_getParameterStatus(params.phLevel, 6.5, 'ph') == 'جيد') goodCount++; else badCount++;
    if (_getParameterStatus(params.salinity, 1000, 'salinity') == 'جيد') goodCount++; else badCount++;
    if (_getParameterStatus(params.chlorine, 0.5, 'chlorine') == 'جيد') goodCount++; else badCount++;
    if (_getParameterStatus(params.temperature, 25, 'temperature') == 'جيد') goodCount++; else badCount++;
    if (_getParameterStatus(params.tds, 500, 'tds') == 'جيد') goodCount++; else badCount++;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص الجودة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('المعايير الجيدة', goodCount, Colors.green),
              _buildSummaryItem('المعايير غير المقبولة', badCount, Colors.red),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getOverallQuality(goodCount, badCount),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: badCount > 3 ? Colors.red : badCount > 0 ? Colors.orange : Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getOverallQuality(int goodCount, int badCount) {
    if (badCount == 0) return 'جودة المياه ممتازة';
    if (badCount <= 2) return 'جودة المياه مقبولة';
    if (badCount <= 4) return 'جودة المياه متوسطة';
    return 'جودة المياه غير مقبولة';
  }

  String _getParameterStatus(double value, double threshold, String type) {
    switch (type) {
      case 'ph':
        if (value >= 6.5 && value <= 8.5) return 'جيد';
        return 'غير مقبول';
      case 'turbidity':
        if (value <= 5.0) return 'جيد';
        return 'غير مقبول';
      case 'salinity':
        if (value <= 1000) return 'جيد';
        return 'غير مقبول';
      case 'chlorine':
        if (value >= 0.2 && value <= 0.5) return 'جيد';
        return 'غير مقبول';
      case 'temperature':
        if (value <= 25) return 'جيد';
        return 'مرتفع';
      case 'tds':
        if (value <= 500) return 'جيد';
        return 'مرتفع';
      default:
        return 'غير معروف';
    }
  }

  Widget _buildParameterRow(String parameter, String value, String status) {
    Color statusColor = status == 'جيد' ? Colors.green : Colors.red;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              parameter,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Text(
                status,
                style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachedImages() {
    if (widget.report.attachedImages.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الصور المرفقة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Column(
              children: [
                Icon(Icons.photo_library, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا توجد صور مرفقة',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الصور المرفقة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          '${widget.report.attachedImages.length} صورة مرفقة توضح المشكلة',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.report.attachedImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: () {
                    _showImageDialog(widget.report.attachedImages[index]);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 160,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          // في التطبيق الحقيقي، استبدل هذا بـ Image.file أو Image.network
                          Center(
                            child: Icon(
                              Icons.photo,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'صورة ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showImageDialog(XFile imageFile) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: AssetImage('assets/sample_water_1.jpg'), // صورة عينة
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'تغيير حالة البلاغ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (widget.report.status == 'معلق') ...[
          _buildActionButton('بدء المعالجة', Colors.blue, () => _updateStatus('قيد المعالجة')),
        ],
        if (widget.report.status == 'قيد المعالجة') ...[
          _buildActionButton('إكمال المعالجة', Colors.green, () => _updateStatus('مكتمل')),
          const SizedBox(height: 8),
          _buildActionButton('إلغاء البلاغ', Colors.red, () => _updateStatus('ملغي')),
        ],
        if (widget.report.status == 'مكتمل' || widget.report.status == 'ملغي') ...[
          _buildActionButton('إعادة فتح البلاغ', Colors.orange, () => _updateStatus('معلق')),
        ],
      ],
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status) {
      case 'معلق':
        chipColor = Colors.orange;
      case 'قيد المعالجة':
        chipColor = Colors.blue;
      case 'مكتمل':
        chipColor = Colors.green;
      case 'ملغي':
        chipColor = Colors.red;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color chipColor;
    switch (priority) {
      case 'عالية':
        chipColor = Colors.red;
      case 'متوسطة':
        chipColor = Colors.orange;
      case 'منخفضة':
        chipColor = Colors.green;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        priority,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
    );
  }
}

class WaterLocation {
  final double lat;
  final double lng;
  final String address;

  const WaterLocation({
    required this.lat,
    required this.lng,
    required this.address,
  });
}

class WaterQualityReport {
  final String id;
  final String title;
  final String description;
  final String reportType;
  final String problemType;
  final WaterLocation location;
  final String reporterName;
  final String reporterPhone;
  final DateTime timestamp;
  String status;
  final String priority;
  final List<XFile> attachedImages;
  final WaterParameters? waterParameters;
  DateTime? updatedAt;

  WaterQualityReport({
    required this.id,
    required this.title,
    required this.description,
    required this.reportType,
    required this.problemType,
    required this.location,
    required this.reporterName,
    required this.reporterPhone,
    required this.timestamp,
    required this.status,
    required this.priority,
    required this.attachedImages,
    this.waterParameters,
    this.updatedAt,
  });
}

class WaterParameters {
  final double turbidity; // العكورة (NTU)
  final double phLevel; // الأس الهيدروجيني
  final double salinity; // الملوحة (ppm)
  final double chlorine; // الكلور (mg/L)
  final double temperature; // درجة الحرارة (°C)
  final double tds; // إجمالي المواد الذاتية (ppm)

  WaterParameters({
    required this.turbidity,
    required this.phLevel,
    required this.salinity,
    required this.chlorine,
    required this.temperature,
    required this.tds,
  });
}
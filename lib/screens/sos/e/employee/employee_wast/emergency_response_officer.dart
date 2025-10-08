import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EmergencyResponseOfficerScreen extends StatefulWidget {
  const EmergencyResponseOfficerScreen({super.key});

  @override
  State<EmergencyResponseOfficerScreen> createState() => _EmergencyResponseOfficerScreenState();
}

class _EmergencyResponseOfficerScreenState extends State<EmergencyResponseOfficerScreen> {
  int _currentTabIndex = 0;
  String _currentFilter = 'الكل';

  // نظام الألوان الحكومي المحسن
  static const Color _primaryColor = Color(0xFF006400);
  static const Color _secondaryColor = Color(0xFFD4AF37);
  static const Color _accentColor = Color(0xFF8B0000);
  static const Color _backgroundColor = Color(0xFFF5F5F5);
  static const Color _successColor = Color(0xFF2E8B57);
  static const Color _warningColor = Color(0xFFFF8C00);
  static const Color _infoColor = Color(0xFF1E90FF);

  // بيانات محسنة للرسم البياني
  final List<TeamPerformance> _monthlyPerformance = [
    TeamPerformance('يناير', 85, 92, 78),
    TeamPerformance('فبراير', 88, 90, 82),
    TeamPerformance('مارس', 82, 88, 80),
    TeamPerformance('أبريل', 90, 95, 85),
    TeamPerformance('مايو', 87, 91, 83),
    TeamPerformance('يونيو', 92, 96, 88),
  ];

  // بيانات محسنة للتقرير
  final List<DetailedReport> _detailedReports = [
    DetailedReport(
      id: '1',
      title: 'تقرير أداء يناير الشامل',
      type: 'أداء الفرق',
      date: '2024-01-31',
      status: ReportStatus.completed,
      summary: 'أظهرت الفرق أداءً ممتازاً خلال يناير مع تحقيق معدل إنجاز 94%',
      metrics: {
        'معدل الإنجاز': '94%',
        'متوسط وقت الاستجابة': '15 دقيقة',
        'رضا العملاء': '4.7/5',
        'المهام المكتملة': '156',
        'التكاليف': '45,000 ريال'
      },
      recommendations: [
        'زيادة عدد الفرق في منطقة حي النخيل',
        'تحسين وقت الاستجابة في ساعات الذروة',
        'تحديث معدات فريق الصرف الصحي'
      ]
    ),
    DetailedReport(
      id: '2',
      title: 'تحليل الطلبات العاجلة للربع الأول',
      type: 'تحليل إحصائي',
      date: '2024-03-31',
      status: ReportStatus.completed,
      summary: 'تحليل مفصل للطلبات العاجلة وتوزيعها الجغرافي',
      metrics: {
        'إجمالي الطلبات': '485',
        'طلبات عاجلة': '156',
        'متوسط وقت المعالجة': '2.5 ساعة',
        'المنطقة الأكثر طلباً': 'حي النخيل',
        'أكثر أنواع الطلبات': 'انسداد الصرف الصحي'
      },
      recommendations: [
        'تخصيص فريق دائم لمنطقة حي النخيل',
        'تحسين نظام التبليغ عن الطلبات',
        'زيادة الوعي المجتمعي بالاستخدام الصحيح'
      ]
    ),
  ];

  List<EmergencyTeam> _teams = [
    EmergencyTeam(
      id: '1',
      name: 'فريق الطوارئ 1',
      status: TeamStatus.active,
      location: 'حي الروضة',
      currentTask: 'معالجة انسداد صرف صحي',
      members: 5,
      vehicle: 'شاحنة صرف صحي',
      rating: 4.8,
      vehicleCondition: 'جيدة',
      lastMaintenance: '2024-01-15',
      nextMaintenance: '2024-02-15',
      contact: '+966500000001',
      specialization: 'الصرف الصحي',
    ),
    EmergencyTeam(
      id: '2',
      name: 'فريق النظافة 2',
      status: TeamStatus.available,
      location: 'حي العليا',
      currentTask: 'لا يوجد',
      members: 4,
      vehicle: 'شاحنة نفايات',
      rating: 4.5,
      vehicleCondition: 'ممتازة',
      lastMaintenance: '2024-01-20',
      nextMaintenance: '2024-02-20',
      contact: '+966500000002',
      specialization: 'جمع النفايات',
    ),
  ];

  List<EmergencyRequest> _emergencyRequests = [
    EmergencyRequest(
      id: '1',
      type: 'انسداد صرف صحي',
      location: 'حي النخيل، شارع الأمير سلطان',
      time: DateTime.now().subtract(const Duration(minutes: 10)),
      priority: Priority.high,
      status: RequestStatus.inProgress,
      assignedTeam: 'فريق الطوارئ 1',
      estimatedCompletion: DateTime.now().add(const Duration(hours: 2)),
      citizenRating: 0,
      citizenName: 'أحمد محمد',
      citizenPhone: '+966500000011',
      description: 'انسداد كامل في مجرى الصرف الرئيسي مع تجمع المياه',
    ),
    EmergencyRequest(
      id: '2',
      type: 'حاوية متضررة',
      location: 'حي الورود، شارع الخليج',
      time: DateTime.now().subtract(const Duration(minutes: 25)),
      priority: Priority.medium,
      status: RequestStatus.pending,
      assignedTeam: '',
      estimatedCompletion: null,
      citizenRating: 0,
      citizenName: 'فاطمة عبدالله',
      citizenPhone: '+966500000022',
      description: 'حاوية نفايات متضررة تحتاج استبدال',
    ),
    EmergencyRequest(
      id: '3',
      type: 'تسرب مياه',
      location: 'حي السلام، شارع الملك فهد',
      time: DateTime.now().subtract(const Duration(hours: 3)),
      priority: Priority.high,
      status: RequestStatus.completed,
      assignedTeam: 'فريق الطوارئ 1',
      estimatedCompletion: DateTime.now().subtract(const Duration(hours: 1)),
      citizenRating: 5,
      citizenName: 'خالد أحمد',
      citizenPhone: '+966500000033',
      description: 'تسرب مياه من خط رئيسي',
    ),
    EmergencyRequest(
      id: '4',
      type: 'نفايات متراكمة',
      location: 'حي الأندلس، شارع الخليج',
      time: DateTime.now().subtract(const Duration(days: 1)),
      priority: Priority.medium,
      status: RequestStatus.cancelled,
      assignedTeam: '',
      estimatedCompletion: null,
      citizenRating: 0,
      citizenName: 'سارة محمد',
      citizenPhone: '+966500000044',
      description: 'نفايات متراكمة في الشارع',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('نظام إدارة طوارئ البلدية'),
        backgroundColor: _primaryColor,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotifications,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _showProfile,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildCurrentTabContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEmergencyQuickActions,
        backgroundColor: _accentColor,
        child: const Icon(Icons.emergency, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // 📊 الرسم البياني المفعل
  Widget _buildPerformanceChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('أداء الفرق الشهري', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(
                  title: AxisTitle(text: 'الأشهر'),
                  labelRotation: -45,
                ),
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(text: 'النسبة %'),
                  minimum: 70,
                  maximum: 100,
                ),
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  LineSeries<TeamPerformance, String>(
                    name: 'فريق الطوارئ',
                    dataSource: _monthlyPerformance,
                    xValueMapper: (TeamPerformance data, _) => data.month,
                    yValueMapper: (TeamPerformance data, _) => data.emergencyTeam,
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: _accentColor,
                  ),
                  LineSeries<TeamPerformance, String>(
                    name: 'فريق النظافة',
                    dataSource: _monthlyPerformance,
                    xValueMapper: (TeamPerformance data, _) => data.month,
                    yValueMapper: (TeamPerformance data, _) => data.cleaningTeam,
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: _primaryColor,
                  ),
                  LineSeries<TeamPerformance, String>(
                    name: 'فريق الصيانة',
                    dataSource: _monthlyPerformance,
                    xValueMapper: (TeamPerformance data, _) => data.month,
                    yValueMapper: (TeamPerformance data, _) => data.maintenanceTeam,
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: _warningColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildChartLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _buildLegendItem(_accentColor, 'فريق الطوارئ'),
        _buildLegendItem(_primaryColor, 'فريق النظافة'),
        _buildLegendItem(_warningColor, 'فريق الصيانة'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // 📈 لوحة التحليلات والتقارير المحسنة
  Widget _buildAnalyticsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPerformanceChart(),
          const SizedBox(height: 16),
          _buildTrendAnalysis(),
          const SizedBox(height: 16),
          _buildQualityMetrics(),
          const SizedBox(height: 16),
          _buildDetailedReportsList(),
        ],
      ),
    );
  }

  Widget _buildTrendAnalysis() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تحليل الاتجاهات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTrendItem('المناطق الأكثر طلباً', 'حي النخيل - 45 طلب'),
            _buildTrendItem('أوقات الذروة', '8-10 صباحاً - 6-8 مساءً'),
            _buildTrendItem('أكثر أنواع الطلبات', 'انسداد الصرف الصحي'),
            _buildTrendItem('معدل الاستجابة', '15 دقيقة في المتوسط'),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(title, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityMetrics() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('مؤشرات الجودة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildQualityMetric('متوسط وقت الاستجابة', '15 دقيقة', '12 دقيقة'),
            _buildQualityMetric('معدل إكمال المهام', '94%', '96%'),
            _buildQualityMetric('رضا العملاء', '4.7/5', '4.8/5'),
            _buildQualityMetric('فعالية التكلفة', '92%', '95%'),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityMetric(String metric, String current, String target) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(metric, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('الحالي: $current', style: const TextStyle(fontSize: 14)),
                Text('المستهدف: $target', style: const TextStyle(color: _successColor, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 📋 قائمة التقارير المفصلة
  Widget _buildDetailedReportsList() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('التقارير التفصيلية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._detailedReports.map((report) => _buildDetailedReportItem(report)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedReportItem(DetailedReport report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description, color: _primaryColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    report.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                _buildReportStatus(report.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('${report.type} - ${report.date}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(report.summary, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            _buildReportMetrics(report.metrics),
            const SizedBox(height: 12),
            _buildReportActions(report),
          ],
        ),
      ),
    );
  }

  Widget _buildReportMetrics(Map<String, String> metrics) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: metrics.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Text(entry.key, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(entry.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReportActions(DetailedReport report) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton(
          onPressed: () => _viewDetailedReport(report),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text('عرض التقرير', style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
        OutlinedButton(
          onPressed: () => _shareReport(report),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text('مشاركة', style: TextStyle(fontSize: 12)),
        ),
        if (report.status == ReportStatus.completed)
          IconButton(
            onPressed: () => _downloadReport(report),
            icon: const Icon(Icons.download, size: 18),
            tooltip: 'تحميل التقرير',
          ),
        IconButton(
          onPressed: () => _printReport(report),
          icon: const Icon(Icons.print, size: 18),
          tooltip: 'طباعة التقرير',
        ),
      ],
    );
  }

  // 👥 قسم الفرق مع الأيقونات المصغرة
  Widget _buildTeamCard(EmergencyTeam team) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTeamStatusIndicator(team.status),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(team.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(team.location, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
                _buildTeamRating(team.rating),
              ],
            ),
            const SizedBox(height: 8),
            _buildTeamDetailsCompact(team),
            const SizedBox(height: 8),
            _buildTeamActionsCompact(team),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamDetailsCompact(EmergencyTeam team) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTeamDetailRow(Icons.assignment, 'المهمة: ${team.currentTask}'),
        _buildTeamDetailRow(Icons.directions_car, 'المركبة: ${team.vehicle}'),
        _buildTeamDetailRow(Icons.engineering, 'التخصص: ${team.specialization}'),
        _buildTeamDetailRow(Icons.build, 'حالة المركبة: ${team.vehicleCondition}'),
      ],
    );
  }

  Widget _buildTeamDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: _primaryColor),
          const SizedBox(width: 4),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamActionsCompact(EmergencyTeam team) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (team.status == TeamStatus.available)
          ElevatedButton(
            onPressed: () => _assignTaskToTeam(team),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(100, 32),
            ),
            child: const Text('تعيين مهمة', style: TextStyle(color: Colors.white, fontSize: 10)),
          ),
        if (team.status == TeamStatus.active)
          ElevatedButton(
            onPressed: () => _reassignTeamTask(team),
            style: ElevatedButton.styleFrom(
              backgroundColor: _warningColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(100, 32),
            ),
            child: const Text('إعادة تعيين', style: TextStyle(color: Colors.white, fontSize: 10)),
          ),
        IconButton(
          onPressed: () => _showTeamDetails(team),
          icon: const Icon(Icons.info_outline, size: 16),
          iconSize: 16,
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          tooltip: 'تفاصيل',
        ),
        IconButton(
          onPressed: () => _contactTeam(team),
          icon: const Icon(Icons.phone, size: 16),
          iconSize: 16,
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          tooltip: 'اتصال',
        ),
        IconButton(
          onPressed: () => _showTeamLocation(team),
          icon: const Icon(Icons.location_on, size: 16),
          iconSize: 16,
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          tooltip: 'موقع',
        ),
        IconButton(
          onPressed: () => _editTeam(team),
          icon: const Icon(Icons.edit, size: 16),
          iconSize: 16,
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          tooltip: 'تعديل',
        ),
      ],
    );
  }

  // وظائف جديدة للتقارير
  void _viewDetailedReport(DetailedReport report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report.title),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('نوع التقرير: ${report.type}'),
                Text('التاريخ: ${report.date}'),
                const SizedBox(height: 16),
                const Text('الملخص:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(report.summary),
                const SizedBox(height: 16),
                const Text('المؤشرات:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...report.metrics.entries.map((entry) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(entry.key)),
                        Text(entry.value, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
                if (report.recommendations.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('التوصيات:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...report.recommendations.map((rec) => 
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_left, size: 16),
                          const SizedBox(width: 4),
                          Expanded(child: Text(rec)),
                        ],
                      ),
                    )),
                ],
              ],
            ),
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
              _showSuccessMessage('تم تحميل التقرير: ${report.title}');
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
            child: const Text('تحميل PDF', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _shareReport(DetailedReport report) {
    _showSuccessMessage('جاري مشاركة التقرير: ${report.title}');
  }

  void _downloadReport(DetailedReport report) {
    _showSuccessMessage('تم تحميل التقرير: ${report.title}');
  }

  void _printReport(DetailedReport report) {
    _showSuccessMessage('جاري الطباعة: ${report.title}');
  }

  // باقي الوظائف الأساسية
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _buildTabItem(0, Icons.dashboard, 'اللوحة'),
          _buildTabItem(1, Icons.emergency, 'الطلبات'),
          _buildTabItem(2, Icons.group, 'الفرق'),
          _buildTabItem(3, Icons.analytics, 'التقارير'),
          _buildTabItem(4, Icons.map, 'الخريطة'),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String title) {
    final isSelected = _currentTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? _primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? _primaryColor : Colors.grey, size: 20),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? _primaryColor : Colors.grey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    switch (_currentTabIndex) {
      case 0: return _buildDashboard();
      case 1: return _buildRequestsView();
      case 2: return _buildTeamsView();
      case 3: return _buildAnalyticsView();
      case 4: return _buildMapView();
      default: return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildQuickStats(),
          const SizedBox(height: 16),
          _buildUrgentRequests(),
          const SizedBox(height: 16),
          _buildTeamsStatus(),
          const SizedBox(height: 16),
          _buildUpcomingTasks(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final activeRequests = _emergencyRequests.where((r) => r.status == RequestStatus.inProgress).length;
    final availableTeams = _teams.where((t) => t.status == TeamStatus.available).length;
    final highPriorityRequests = _emergencyRequests.where((r) => r.priority == Priority.high).length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard('الطلبات النشطة', activeRequests.toString(), Icons.emergency, _accentColor),
          _buildStatCard('الفرق المتاحة', availableTeams.toString(), Icons.group, _successColor),
          _buildStatCard('طلبات عاجلة', highPriorityRequests.toString(), Icons.priority_high, _warningColor),
          _buildStatCard('معدل الإنجاز', '94%', Icons.trending_up, _primaryColor),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(left: 8),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUrgentRequests() {
    final urgentRequests = _emergencyRequests.where((r) => r.priority == Priority.high).toList();
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning, color: _accentColor),
                const SizedBox(width: 8),
                const Text('الطلبات العاجلة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            if (urgentRequests.isEmpty)
              const Center(child: Text('لا توجد طلبات عاجلة', style: TextStyle(color: Colors.grey))),
            ...urgentRequests.map((request) => _buildRequestItem(request)),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestItem(EmergencyRequest request) {
    return ListTile(
      leading: _buildPriorityIndicator(request.priority),
      title: Text(request.type),
      subtitle: Text(request.location),
      trailing: _buildStatusBadge(request.status),
      onTap: () => _showRequestDetails(request),
    );
  }

  Widget _buildPriorityIndicator(Priority priority) {
    final color = priority == Priority.high ? _accentColor : 
                  priority == Priority.medium ? _warningColor : _infoColor;
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildStatusBadge(RequestStatus status) {
    final statusInfo = _getStatusInfo(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusInfo.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusInfo.icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            statusInfo.text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  StatusInfo _getStatusInfo(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return StatusInfo('معلقة', _warningColor, Icons.pending);
      case RequestStatus.inProgress:
        return StatusInfo('قيد المعالجة', _infoColor, Icons.autorenew);
      case RequestStatus.completed:
        return StatusInfo('مكتملة', _successColor, Icons.check_circle);
      case RequestStatus.cancelled:
        return StatusInfo('ملغاة', _accentColor, Icons.cancel);
    }
  }

  Widget _buildTeamsStatus() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.group, color: _primaryColor),
                const SizedBox(width: 8),
                const Text('حالة الفرق', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ..._teams.map((team) => _buildTeamStatusItem(team)),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamStatusItem(EmergencyTeam team) {
    return ListTile(
      leading: _buildTeamStatusIndicator(team.status),
      title: Text(team.name),
      subtitle: Text(team.currentTask),
      trailing: Text(team.location),
      onTap: () => _showTeamDetails(team),
    );
  }

  Widget _buildUpcomingTasks() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule, color: _infoColor),
                const SizedBox(width: 8),
                const Text('المهام القادمة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _buildTaskItem('اجتماع تقييم الأداء', 'غداً 10:00 ص', Icons.meeting_room),
            _buildTaskItem('تسليم تقرير الربع الأول', '2024-04-01', Icons.assignment),
            _buildTaskItem('صيانة المركبات', '2024-02-15', Icons.build),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(String task, String date, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: _primaryColor),
      title: Text(task),
      subtitle: Text(date),
      trailing: const Icon(Icons.chevron_left),
    );
  }

  Widget _buildRequestsView() {
    List<EmergencyRequest> filteredRequests = _getFilteredRequests();

    return Column(
      children: [
        _buildRequestsFilter(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredRequests.length,
            itemBuilder: (context, index) => _buildRequestCard(filteredRequests[index]),
          ),
        ),
      ],
    );
  }

  List<EmergencyRequest> _getFilteredRequests() {
    switch (_currentFilter) {
      case 'عاجلة':
        return _emergencyRequests.where((r) => r.priority == Priority.high).toList();
      case 'قيد المعالجة':
        return _emergencyRequests.where((r) => r.status == RequestStatus.inProgress).toList();
      case 'مكتملة':
        return _emergencyRequests.where((r) => r.status == RequestStatus.completed).toList();
      case 'ملغاة':
        return _emergencyRequests.where((r) => r.status == RequestStatus.cancelled).toList();
      default:
        return _emergencyRequests;
    }
  }

  Widget _buildRequestsFilter() {
    final filters = ['الكل', 'عاجلة', 'قيد المعالجة', 'مكتملة', 'ملغاة'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _buildFilterChip(filter, _currentFilter == filter),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (bool value) {
        setState(() {
          _currentFilter = value ? label : 'الكل';
        });
      },
      selectedColor: _primaryColor,
      checkmarkColor: Colors.white,
    );
  }

  Widget _buildRequestCard(EmergencyRequest request) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildPriorityIndicator(request.priority),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(request.type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                _buildStatusBadge(request.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('الموقع: ${request.location}'),
            Text('الوقت: ${_formatTime(request.time)}'),
            if (request.citizenName.isNotEmpty) Text('المبلغ: ${request.citizenName}'),
            if (request.assignedTeam.isNotEmpty) Text('الفريق: ${request.assignedTeam}'),
            if (request.estimatedCompletion != null) 
              Text('الانتهاء المتوقع: ${_formatTime(request.estimatedCompletion!)}'),
            const SizedBox(height: 12),
            _buildRequestActions(request),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestActions(EmergencyRequest request) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (request.status == RequestStatus.pending) ...[
            Container(
              margin: const EdgeInsets.only(left: 4),
              child: ElevatedButton(
                onPressed: () => _assignTeam(request),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(100, 36),
                ),
                child: const Text('تعيين فريق', style: TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 4),
              child: ElevatedButton(
                onPressed: () => _cancelRequest(request),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(100, 36),
                ),
                child: const Text('إلغاء الطلب', style: TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ),
          ],
          if (request.status == RequestStatus.inProgress) ...[
            // زر إكمال المهمة - باللون الأخضر الحكومي
            Container(
              margin: const EdgeInsets.only(left: 4),
              child: ElevatedButton(
                onPressed: () => _markRequestCompleted(request),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _successColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(100, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text('إكمال', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ],
                ),
              ),
            ),
            // زر تحديث التقدم - باللون الأزرق الحكومي
            Container(
              margin: const EdgeInsets.only(left: 4),
              child: ElevatedButton(
                onPressed: () => _updateRequestProgress(request),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _infoColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(100, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.update, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text('تحديث', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _showRequestDetails(request),
            icon: const Icon(Icons.info_outline, color: _infoColor, size: 20),
          ),
          IconButton(
            onPressed: () => _contactCitizen(request),
            icon: const Icon(Icons.phone, color: _successColor, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsView() {
    return Column(
      children: [
        _buildTeamsSummary(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _teams.length,
            itemBuilder: (context, index) => _buildTeamCard(_teams[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamsSummary() {
    final availableTeams = _teams.where((t) => t.status == TeamStatus.available).length;
    final activeTeams = _teams.where((t) => t.status == TeamStatus.active).length;
    final maintenanceTeams = _teams.where((t) => t.status == TeamStatus.maintenance).length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          _buildTeamSummaryItem('متاحة', availableTeams, _successColor),
          _buildTeamSummaryItem('نشطة', activeTeams, _accentColor),
          _buildTeamSummaryItem('صيانة', maintenanceTeams, _warningColor),
          _buildTeamSummaryItem('الإجمالي', _teams.length, _primaryColor),
        ],
      ),
    );
  }

  Widget _buildTeamSummaryItem(String label, int count, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text('$count', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTeamStatusIndicator(TeamStatus status) {
    final color = status == TeamStatus.available ? _successColor : 
                  status == TeamStatus.active ? _accentColor : _warningColor;
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildTeamRating(double rating) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 14),
        const SizedBox(width: 2),
        Text(rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildReportStatus(ReportStatus status) {
    final statusInfo = _getReportStatusInfo(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusInfo.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusInfo.text,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }

  StatusInfo _getReportStatusInfo(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return StatusInfo('قيد الإعداد', _warningColor, Icons.pending);
      case ReportStatus.inProgress:
        return StatusInfo('قيد المراجعة', _infoColor, Icons.autorenew);
      case ReportStatus.completed:
        return StatusInfo('مكتمل', _successColor, Icons.check_circle);
    }
  }

  Widget _buildMapView() {
    return Stack(
      children: [
        Container(
          color: Colors.grey[200],
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 64, color: _primaryColor),
                SizedBox(height: 16),
                Text('خريطة تفاعلية لتتبع الفرق والطلبات'),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              _buildMapControl(Icons.my_location, 'تحديد الموقع', _centerMap),
              _buildMapControl(Icons.filter_center_focus, 'فلترة', _filterMap),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapControl(IconData icon, String tooltip, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: FloatingActionButton.small(
        onPressed: onPressed,
        heroTag: tooltip,
        backgroundColor: Colors.white,
        child: Icon(icon, color: _primaryColor),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => setState(() => _currentTabIndex = 0),
            color: _currentTabIndex == 0 ? _primaryColor : Colors.grey,
          ),
          IconButton(
            icon: const Icon(Icons.assignment),
            onPressed: () => setState(() => _currentTabIndex = 1),
            color: _currentTabIndex == 1 ? _primaryColor : Colors.grey,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  // وظائف تفاعلية
  void _showEmergencyQuickActions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('الإجراءات السريعة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildQuickAction('طلب دعم إضافي', Icons.group_add, _primaryColor, _requestBackup),
            _buildQuickAction('تقرير فوري', Icons.assignment, _secondaryColor, _generateQuickReport),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _requestBackup() => _showSuccessMessage('تم إرسال طلب الدعم');
  void _generateQuickReport() => _showSuccessMessage('تم توليد التقرير');
  void _centerMap() => _showSuccessMessage('تم تحديد موقع المركز');
  void _filterMap() => _showSuccessMessage('فتح خيارات الفلترة');
  void _showNotifications() => _showSuccessMessage('عرض الإشعارات');
  void _showProfile() => _showSuccessMessage('عرض الملف الشخصي');
  void _showSettings() => _showSuccessMessage('عرض الإعدادات');

  void _assignTeam(EmergencyRequest request) {
    _showSuccessMessage('تعيين فريق للطلب');
  }

  void _cancelRequest(EmergencyRequest request) {
    _showSuccessMessage('تم إلغاء الطلب');
  }

  void _markRequestCompleted(EmergencyRequest request) {
    _showSuccessMessage('تم إكمال المهمة');
  }

  void _updateRequestProgress(EmergencyRequest request) {
    _showSuccessMessage('تم تحديث التقدم');
  }

  void _showRequestDetails(EmergencyRequest request) {
    _showSuccessMessage('عرض تفاصيل الطلب');
  }

  void _contactCitizen(EmergencyRequest request) {
    _showSuccessMessage('جاري الاتصال بالمواطن');
  }

  void _assignTaskToTeam(EmergencyTeam team) {
    _showSuccessMessage('تعيين مهمة للفريق');
  }

  void _reassignTeamTask(EmergencyTeam team) {
    _showSuccessMessage('إعادة تعيين المهمة');
  }

  void _showTeamDetails(EmergencyTeam team) {
    _showSuccessMessage('عرض تفاصيل الفريق');
  }

  void _contactTeam(EmergencyTeam team) {
    _showSuccessMessage('جاري الاتصال بالفريق');
  }

  void _showTeamLocation(EmergencyTeam team) {
    _showSuccessMessage('عرض موقع الفريق');
  }

  void _editTeam(EmergencyTeam team) {
    _showSuccessMessage('تعديل بيانات الفريق');
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _successColor,
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

// النماذج المطلوبة
class TeamPerformance {
  final String month;
  final double emergencyTeam;
  final double cleaningTeam;
  final double maintenanceTeam;

  TeamPerformance(this.month, this.emergencyTeam, this.cleaningTeam, this.maintenanceTeam);
}

class DetailedReport {
  final String id;
  final String title;
  final String type;
  final String date;
  final ReportStatus status;
  final String summary;
  final Map<String, String> metrics;
  final List<String> recommendations;

  DetailedReport({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.status,
    required this.summary,
    required this.metrics,
    this.recommendations = const [],
  });
}

class EmergencyTeam {
  final String id;
  final String name;
  final TeamStatus status;
  final String location;
  final String currentTask;
  final int members;
  final String vehicle;
  final double rating;
  final String vehicleCondition;
  final String lastMaintenance;
  final String nextMaintenance;
  final String contact;
  final String specialization;

  EmergencyTeam({
    required this.id,
    required this.name,
    required this.status,
    required this.location,
    required this.currentTask,
    required this.members,
    required this.vehicle,
    required this.rating,
    required this.vehicleCondition,
    required this.lastMaintenance,
    required this.nextMaintenance,
    required this.contact,
    required this.specialization,
  });
}

class EmergencyRequest {
  final String id;
  final String type;
  final String location;
  final DateTime time;
  final Priority priority;
  RequestStatus status;
  String assignedTeam;
  final DateTime? estimatedCompletion;
  final double citizenRating;
  final String citizenName;
  final String citizenPhone;
  final String description;

  EmergencyRequest({
    required this.id,
    required this.type,
    required this.location,
    required this.time,
    required this.priority,
    required this.status,
    required this.assignedTeam,
    this.estimatedCompletion,
    required this.citizenRating,
    required this.citizenName,
    required this.citizenPhone,
    required this.description,
  });
}

class StatusInfo {
  final String text;
  final Color color;
  final IconData icon;

  StatusInfo(this.text, this.color, this.icon);
}

enum Priority { low, medium, high }
enum RequestStatus { pending, inProgress, completed, cancelled }
enum TeamStatus { available, active, maintenance }
enum ReportStatus { pending, inProgress, completed }
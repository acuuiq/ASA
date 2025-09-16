import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReportingOfficerWasteScreen extends StatefulWidget {
  static const String screenRoute = 'reporting_officer_waste_screen';

  const ReportingOfficerWasteScreen({super.key});

  @override
  _ReportingOfficerWasteScreenState createState() => _ReportingOfficerWasteScreenState();
}

class _ReportingOfficerWasteScreenState extends State<ReportingOfficerWasteScreen> {
  // الألوان المنسجمة مع التصميم الحكومي
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

  int _newReportsCount = 0;
  int _inProgressCount = 0;
  int _resolvedCount = 0;
  bool _isLoading = true;
  Map<String, dynamic>? _userProfile;

  final List<Map<String, dynamic>> _reports = [];
  final List<Map<String, dynamic>> _fieldTeams = [];
  final List<Map<String, dynamic>> _employees = [
    {'id': '1', 'name': 'محمد أحمد', 'specialization': 'جمع النفايات'},
    {'id': '2', 'name': 'علي حسن', 'specialization': 'تنظيف الشوارع'},
    {'id': '3', 'name': 'سالم عبدالله', 'specialization': 'صيانة الحاويات'},
    {'id': '4', 'name': 'فاطمة محمد', 'specialization': 'مراقبة الجودة'},
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final userData = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();
        
        setState(() {
          _userProfile = userData;
        });
      }

      // جلب بيانات البلاغات (بيانات وهمية لل演示)
      await Future.delayed(const Duration(seconds: 1));
      
      // بيانات وهمية للبلاغات مع إضافة الصور
      final mockReports = [
        {
          'id': '1',
          'title': 'حاوية ممتلئة',
          'type': 'full_container',
          'location': 'حي الرياض - شارع الملك فهد',
          'latitude': 24.7136,
          'longitude': 46.6753,
          'status': 'new',
          'description': 'الحاوية ممتلئة وتفيض النفايات',
          'created_at': DateTime.now().subtract(const Duration(hours: 2)),
          'images': [
            'https://picsum.photos/400/300?random=1',
            'https://picsum.photos/400/300?random=2',
          ],
        },
        {
          'id': '2',
          'title': 'حاوية تالفة',
          'type': 'damaged_container',
          'location': 'حي النخيل - شارع الأمير محمد',
          'latitude': 24.7236,
          'longitude': 46.6853,
          'status': 'in_progress',
          'description': 'الحاوية مكسورة وتحتاج استبدال',
          'created_at': DateTime.now().subtract(const Duration(days: 1)),
          'images': [
            'https://picsum.photos/400/300?random=3',
          ],
        },
        {
          'id': '3',
          'title': 'إلقاء نفايات عشوائي',
          'type': 'illegal_dumping',
          'location': 'حي العليا - near المدرسة',
          'latitude': 24.7336,
          'longitude': 46.6953,
          'status': 'resolved',
          'description': 'تم رفع النفايات العشوائية',
          'created_at': DateTime.now().subtract(const Duration(days: 3)),
          'images': [
            'https://picsum.photos/400/300?random=4',
            'https://picsum.photos/400/300?random=5',
            'https://picsum.photos/400/300?random=6',
          ],
        },
      ];

      // بيانات وهمية للفرق
      final mockTeams = [
        {
          'id': '1',
          'name': 'الفريق الشمالي',
          'status': 'available',
          'active_tasks': 2,
        },
        {
          'id': '2',
          'name': 'الفريق الجنوبي',
          'status': 'busy',
          'active_tasks': 5,
        },
        {
          'id': '3',
          'name': 'الفريق الشرقي',
          'status': 'available',
          'active_tasks': 1,
        },
      ];

      setState(() {
        _reports.addAll(mockReports);
        _fieldTeams.addAll(mockTeams);
        _newReportsCount = _reports.where((report) => report['status'] == 'new').length;
        _inProgressCount = _reports.where((report) => report['status'] == 'in_progress').length;
        _resolvedCount = _reports.where((report) => report['status'] == 'resolved').length;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // دالة تسجيل الخروج
  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      print('تم تسجيل الخروج بنجاح');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // دالة إضافة بلاغ جديد
  void _showNewReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة بلاغ جديد'),
        content: const Text('هذه الميزة قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  // دالة لتوثيق تقصير الموظف (للعرض فقط)
  void _showEmployeeNegligenceForm() {
    // بيانات وهمية للعرض (يجب استبدالها بالبيانات الفعلية من المستخدم)
    final negligenceData = {
      'employeeName': 'محمد أحمد',
      'specialization': 'جمع النفايات',
      'date': '2023-10-15',
      'time': '14:30',
      'description': 'لم يقم الموظف بتفريغ الحاوية في الوقت المحدد مما تسبب في تراكم النفايات حولها.',
      'imageUrl': 'https://picsum.photos/400/300?random=7',
    };
    
    showDialog(
      context: context,
      builder: (context) => EmployeeNegligenceForm(
        negligenceData: negligenceData,
        primaryColor: _primaryColor,
      ),
    );
  }

  // دالة للإبلاغ عن مشكلة في التطبيق (للعرض فقط)
  void _showAppIssueReportForm() {
    // بيانات وهمية للعرض (يجب استبدالها بالبيانات الفعلية من المستخدم)
    final issueData = {
      'issueType': 'مشكلة تقنية',
      'phone': '+966 512345678',
      'description': 'التطبيق يتعطل عند محاولة تحديث حالة البلاغات، يرجى إصلاح هذه المشكلة في أقرب وقت ممكن.',
      'imageUrl': 'https://picsum.photos/400/300?random=8',
    };
    
    showDialog(
      context: context,
      builder: (context) => AppIssueReportForm(
        primaryColor: _primaryColor,
        issueData: issueData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: _backgroundColor,
        body: Center(child: CircularProgressIndicator(color: _primaryColor)),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          title: const Text('مسؤول البلاغات - النفايات'),
          backgroundColor: _primaryColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadInitialData,
              tooltip: 'تحديث البيانات',
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _signOut,
              tooltip: 'تسجيل الخروج',
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: 'الرئيسية', icon: Icon(Icons.dashboard)),
              Tab(text: 'البلاغات', icon: Icon(Icons.report_problem)),
              Tab(text: 'الفرق', icon: Icon(Icons.group)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDashboardTab(),
            _buildReportsTab(),
            _buildTeamsTab(),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _showAppIssueReportForm,
              backgroundColor: _errorColor,
              mini: true,
              child: const Icon(Icons.bug_report, color: Colors.white),
              tooltip: 'عرض مشكلة في التطبيق',
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: _showEmployeeNegligenceForm,
              backgroundColor: _warningColor,
              mini: true,
              child: const Icon(Icons.person_off, color: Colors.white),
              tooltip: 'عرض تقصير موظف',
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: _showNewReportDialog,
              backgroundColor: _primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
              tooltip: 'إضافة بلاغ جديد',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatsRow(),
          const SizedBox(height: 20),
          _buildReportsMap(),
          const SizedBox(height: 20),
          _buildRecentReports(),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('بلاغات جديدة', _newReportsCount, _warningColor, Icons.warning),
        _buildStatCard('قيد المعالجة', _inProgressCount, _accentColor, Icons.schedule),
        _buildStatCard('تم حلها', _resolvedCount, _successColor, Icons.check_circle),
      ],
    );
  }

  Widget _buildStatCard(String title, int count, Color color, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                '$count',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
              Text(title, style: TextStyle(color: _textSecondaryColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportsMap() {
    return Card(
      elevation: 2,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map, size: 50, color: _textSecondaryColor),
              const SizedBox(height: 8),
              Text(
                'خريطة البلاغات',
                style: TextStyle(
                  color: _textSecondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '(سيتم تفعيل الخريطة قريباً)',
                style: TextStyle(color: _textSecondaryColor, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentReports() {
    final recentReports = _reports.take(5).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'آخر البلاغات',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 8),
        ...recentReports.map((report) => _buildReportCard(report)),
      ],
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(_getReportIcon(report['type']), color: _getReportColor(report['status'])),
        title: Text(report['title'] ?? 'بدون عنوان'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الموقع: ${report['location'] ?? 'غير محدد'}'),
            Text(
              'التاريخ: ${DateFormat('yyyy-MM-dd HH:mm').format(report['created_at'])}',
              style: TextStyle(fontSize: 12, color: _textSecondaryColor),
            ),
            Text(
              'الحالة: ${_getStatusText(report['status'])}',
              style: TextStyle(
                color: _getReportColor(report['status']),
                fontSize: 12,
              ),
            ),
            if (report['images'] != null && (report['images'] as List).isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(Icons.photo_library, size: 14, color: _primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      '${(report['images'] as List).length} صورة',
                      style: TextStyle(fontSize: 12, color: _primaryColor),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward, color: _primaryColor),
          onPressed: () => _showReportDetails(report),
        ),
      ),
    );
  }

  Widget _buildReportsTab() {
    return ListView.builder(
      itemCount: _reports.length,
      itemBuilder: (context, index) {
        return _buildReportCard(_reports[index]);
      },
    );
  }

  Widget _buildTeamsTab() {
    return ListView.builder(
      itemCount: _fieldTeams.length,
      itemBuilder: (context, index) {
        return _buildTeamCard(_fieldTeams[index]);
      },
    );
  }

  Widget _buildTeamCard(Map<String, dynamic> team) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.group, color: _primaryColor),
        ),
        title: Text(team['name'] ?? 'فريق بدون اسم'),
        subtitle: Text('الحالة: ${_getTeamStatus(team['status'])}'),
        trailing: Chip(
          label: Text('${team['active_tasks']} مهام'),
          backgroundColor: _primaryColor.withOpacity(0.1),
          labelStyle: TextStyle(color: _primaryColor),
        ),
        onTap: () => _showTeamDetails(team),
      ),
    );
  }

  IconData _getReportIcon(String type) {
    switch (type) {
      case 'full_container': return Icons.delete;
      case 'damaged_container': return Icons.broken_image;
      case 'illegal_dumping': return Icons.warning;
      default: return Icons.report_problem;
    }
  }

  Color _getReportColor(String status) {
    switch (status) {
      case 'new': return _warningColor;
      case 'in_progress': return _accentColor;
      case 'resolved': return _successColor;
      default: return _textSecondaryColor;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'new': return 'جديدة';
      case 'in_progress': return 'قيد المعالجة';
      case 'resolved': return 'تم الحل';
      default: return 'غير معروف';
    }
  }

  String _getTeamStatus(String status) {
    switch (status) {
      case 'available': return 'متاح';
      case 'busy': return 'مشغول';
      case 'offline': return 'غير متصل';
      default: return 'غير معروف';
    }
  }

  void _showReportDetails(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report['title'] ?? 'تفاصيل البلاغ'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('النوع:', _getReportTypeText(report['type'])),
              _buildDetailRow('الموقع:', report['location'] ?? 'غير محدد'),
              if (report['latitude'] != null && report['longitude'] != null)
                _buildDetailRow('الإحداثيات:', 
                    '${report['latitude']}, ${report['longitude']}'),
              _buildDetailRow('الحالة:', _getStatusText(report['status'])),
              if (report['description'] != null)
                _buildDetailRow('الوصف:', report['description']),
              if (report['created_at'] != null)
                _buildDetailRow(
                  'وقت الإنشاء:',
                  DateFormat('yyyy-MM-dd HH:mm').format(report['created_at']),
                ),
              
              if (report['images'] != null && (report['images'] as List).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'الصور المرفقة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (report['images'] as List).length,
                        itemBuilder: (context, index) {
                          final imageUrl = (report['images'] as List)[index];
                          return GestureDetector(
                            onTap: () => _showFullScreenImage(imageUrl),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[200],
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Icon(Icons.zoom_in, color: Colors.white, size: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'انقر على الصورة لعرضها بالحجم الكامل',
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () => _updateReportStatus(report),
            child: const Text('تحديث الحالة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('الصورة المرفقة'),
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
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
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 50),
                        SizedBox(height: 16),
                        Text('فشل في تحميل الصورة', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: _textSecondaryColor),
            ),
          ),
        ],
      ));
  }

  String _getReportTypeText(String type) {
    switch (type) {
      case 'full_container': return 'حاوية ممتلئة';
      case 'damaged_container': return 'حاوية تالفة';
      case 'illegal_dumping': return 'إلقاء عشوائي';
      default: return 'نوع غير معروف';
    }
  }

  void _showTeamDetails(Map<String, dynamic> team) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(team['name'] ?? 'تفاصيل الفريق'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('الحالة:', _getTeamStatus(team['status'])),
            _buildDetailRow('عدد المهام النشطة:', '${team['active_tasks']}'),
          ],
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

  void _updateReportStatus(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحديث حالة البلاغ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.warning, color: _warningColor),
              title: const Text('جديدة'),
              onTap: () => _changeStatus(report, 'new'),
            ),
            ListTile(
              leading: Icon(Icons.schedule, color: _accentColor),
              title: const Text('قيد المعالجة'),
              onTap: () => _changeStatus(report, 'in_progress'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: _successColor),
              title: const Text('تم الحل'),
              onTap: () => _changeStatus(report, 'resolved'),
            ),
          ],
        ),
      ),
    );
  }

  void _changeStatus(Map<String, dynamic> report, String newStatus) {
    Navigator.pop(context);
    setState(() {
      report['status'] = newStatus;
      _newReportsCount = _reports.where((r) => r['status'] == 'new').length;
      _inProgressCount = _reports.where((r) => r['status'] == 'in_progress').length;
      _resolvedCount = _reports.where((r) => r['status'] == 'resolved').length;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحديث حالة البلاغ إلى ${_getStatusText(newStatus)}'),
        backgroundColor: _successColor,
      ),
    );
  }
}

// نموذج توثيق تقصير الموظف (للعرض فقط)
class EmployeeNegligenceForm extends StatelessWidget {
  final Map<String, dynamic> negligenceData;
  final Color primaryColor;

  const EmployeeNegligenceForm({
    super.key,
    required this.negligenceData,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تفاصيل تقصير الموظف'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('اسم الموظف:', negligenceData['employeeName'] ?? 'غير محدد'),
            _buildDetailRow('التخصص:', negligenceData['specialization'] ?? 'غير محدد'),
            _buildDetailRow('تاريخ المشكلة:', negligenceData['date'] ?? 'غير محدد'),
            _buildDetailRow('وقت المشكلة:', negligenceData['time'] ?? 'غير محدد'),
            const SizedBox(height: 16),
            const Text(
              'وصف المشكلة:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(negligenceData['description'] ?? 'لا يوجد وصف'),
            ),
            const SizedBox(height: 16),
            if (negligenceData['imageUrl'] != null && negligenceData['imageUrl'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الصورة المرفقة:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showFullScreenImage(context, negligenceData['imageUrl']),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                        image: DecorationImage(
                          image: NetworkImage(negligenceData['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(Icons.zoom_in, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'انقر على الصورة لعرضها بالحجم الكامل',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
          ),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('الصورة المرفقة'),
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
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
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 50),
                        SizedBox(height: 16),
                        Text('فشل في تحميل الصورة', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// نموذج الإبلاغ عن مشكلة في التطبيق (للعرض فقط)
class AppIssueReportForm extends StatelessWidget {
  final Map<String, dynamic> issueData;
  final Color primaryColor;

  const AppIssueReportForm({
    super.key, 
    required this.primaryColor,
    required this.issueData,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تفاصيل مشكلة التطبيق'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('نوع المشكلة:', issueData['issueType'] ?? 'غير محدد'),
            _buildDetailRow('رقم الهاتف:', issueData['phone'] ?? 'غير محدد'),
            const SizedBox(height: 16),
            const Text(
              'وصف المشكلة:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(issueData['description'] ?? 'لا يوجد وصف'),
            ),
            const SizedBox(height: 16),
            if (issueData['imageUrl'] != null && issueData['imageUrl'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الصورة المرفقة:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showFullScreenImage(context, issueData['imageUrl']),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                        image: DecorationImage(
                          image: NetworkImage(issueData['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(Icons.zoom_in, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'انقر على الصورة لعرضها بالحجم الكامل',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
          ),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('الصورة المرفقة'),
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
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
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 50),
                        SizedBox(height: 16),
                        Text('فشل في تحميل الصورة', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
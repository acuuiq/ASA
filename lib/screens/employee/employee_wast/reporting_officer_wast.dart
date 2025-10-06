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
  final Color _primaryColor = const Color.fromARGB(255, 104, 149, 216);
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

      // جلب بيانات البلاغات (بيانات وهمية)
      await Future.delayed(const Duration(seconds: 1));
      
      // بيانات وهمية للبلاغات
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

  // دالة فتح الخريطة مع تحديد الموقع
  void _openMapWithLocation(Map<String, dynamic> report) {
    if (report['latitude'] != null && report['longitude'] != null) {
      _showLocationOnMap(
        report['latitude'],
        report['longitude'],
        report['title'] ?? 'موقع البلاغ',
        report['location'] ?? 'موقع غير محدد',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('لا توجد إحداثيات للموقع'),
          backgroundColor: _errorColor,
        ),
      );
    }
  }

  // دالة عرض الموقع على الخريطة
  void _showLocationOnMap(double latitude, double longitude, String title, String address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('موقع البلاغ: $title'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            children: [
              // محاكاة للخريطة (في التطبيق الحقيقي يمكن استخدام google_maps_flutter)
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                  border: Border.all(color: _borderColor),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, size: 50, color: _errorColor),
                          const SizedBox(height: 8),
                          Text(
                            'خريطة الموقع',
                            style: TextStyle(
                              color: _textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'الإحداثيات: $latitude, $longitude',
                            style: TextStyle(color: _textSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                    // مؤشر الموقع
                    Positioned(
                      top: 125,
                      left: MediaQuery.of(context).size.width * 0.4,
                      child: Icon(Icons.location_pin, color: _errorColor, size: 40),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: _primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'العنوان:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                          ),
                          Text(
                            address,
                            style: TextStyle(color: _textSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
            onPressed: () {
              Navigator.pop(context);
              _openInMapsApp(latitude, longitude);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
            ),
            child: const Text('فتح في تطبيق الخرائط'),
          ),
        ],
      ),
    );
  }

  // دالة فتح الموقع في تطبيق الخرائط
  void _openInMapsApp(double latitude, double longitude) {
    // في التطبيق الحقيقي يمكن استخدام:
    // url_launcher package لفتح تطبيق الخرائط
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('سيتم فتح الموقع في تطبيق الخرائط'),
            Text(
              'الإحداثيات: $latitude, $longitude',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: _successColor,
        duration: const Duration(seconds: 3),
      ),
    );
    
    // في التطبيق الحقيقي:
    // launchUrl(Uri.parse(url));
  }

  // دالة تسجيل الخروج
  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
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
<<<<<<< Updated upstream
=======
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _showAppIssueReportForm,
              backgroundColor: _errorColor,
              mini: true,
              tooltip: 'عرض مشكلة في التطبيق',
              child: const Icon(Icons.bug_report, color: Colors.white),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: _showEmployeeNegligenceForm,
              backgroundColor: _warningColor,
              mini: true,
              tooltip: 'عرض تقصير موظف',
              child: const Icon(Icons.person_off, color: Colors.white),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: _showNewReportDialog,
              backgroundColor: _primaryColor,
              tooltip: 'إضافة بلاغ جديد',
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
>>>>>>> Stashed changes
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
            // جعل الموقع قابل للضغط
            GestureDetector(
              onTap: () => _openMapWithLocation(report),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: _primaryColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'الموقع: ${report['location'] ?? 'غير محدد'}',
                      style: TextStyle(
                        color: _primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
      ),
    );
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
              
              // جعل الموقع قابل للضغط في التفاصيل أيضاً
              GestureDetector(
                onTap: () => _openMapWithLocation(report),
                child: _buildDetailRowWithIcon(
                  'الموقع:',
                  report['location'] ?? 'غير محدد',
                  Icons.location_on,
                  _primaryColor,
                ),
              ),
              
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () => _openMapWithLocation(report),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map),
                SizedBox(width: 4),
                Text('عرض على الخريطة'),
              ],
            ),
          ),
        ],
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
      ),
    );
  }

  Widget _buildDetailRowWithIcon(String label, String value, IconData icon, Color color) {
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
            child: Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: color,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // الدوال المساعدة الأخرى
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

<<<<<<< Updated upstream
=======
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
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
            ),
            child: const Text('تحديث الحالة'),
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

>>>>>>> Stashed changes
  String _getReportTypeText(String type) {
    switch (type) {
      case 'full_container': return 'حاوية ممتلئة';
      case 'damaged_container': return 'حاوية تالفة';
      case 'illegal_dumping': return 'إلقاء عشوائي';
      default: return 'نوع غير معروف';
    }
  }
}
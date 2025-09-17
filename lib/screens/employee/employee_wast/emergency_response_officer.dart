import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmergencyResponseOfficerScreen extends StatefulWidget {
  const EmergencyResponseOfficerScreen({super.key});

  @override
  State<EmergencyResponseOfficerScreen> createState() =>
      _EmergencyResponseOfficerScreenState();
}

class _EmergencyResponseOfficerScreenState
    extends State<EmergencyResponseOfficerScreen>
    with SingleTickerProviderStateMixin {
  // نظام الألوان الجديد
  static const Color _primaryColor = Color(0xFF1A237E);
  static const Color _secondaryColor = Color(0xFF283593);
  static const Color _accentColor = Color(0xFF536DFE);
  static const Color _backgroundColor = Color(0xFFF8F9FA);
  static const Color _cardColor = Colors.white;
  static const Color _textColor = Color(0xFF263238);
  static const Color _textSecondaryColor = Color(0xFF78909C);
  static const Color _successColor = Color(0xFF43A047);
  static const Color _warningColor = Color(0xFFFF9800);
  static const Color _errorColor = Color(0xFFE53935);
  static const Color _wasteColor = Color(0xFF66BB6A);

  // ألوان إضافية
  static const Color _gradientStart = Color(0xFF1A237E);
  static const Color _gradientEnd = Color(0xFF283593);
  static const Color _shadowColor = Color(0x1A000000);

  late AnimationController _animationController;
  late Animation<double> _animation;
  int _selectedWheelItem = -1;
  bool _isWheelSpinning = false;
  int _currentPageIndex = 0;

  // بيانات الطلبات العاجلة الجديدة
  final List<Map<String, dynamic>> _emergencyRequests = [
    {
      'id': '1',
      'type': 'انسداد صرف صحي',
      'location': 'حي النخيل، شارع الأمير سلطان',
      'time': 'منذ 10 دقائق',
      'priority': 'عالية',
      'status': 'قيد المعالجة',
      'assignedTo': 'فريق الطوارئ 2',
      'icon': Icons.plumbing,
      'progress': 60,
    },
    {
      'id': '2',
      'type': 'حاوية متضررة',
      'location': 'حي الورود، شارع الخليج',
      'time': 'منذ 25 دقيقة',
      'priority': 'متوسطة',
      'status': 'معلقة',
      'assignedTo': 'لم يتم التعيين',
      'icon': Icons.auto_delete,
      'progress': 0,
    },
    {
      'id': '3',
      'type': 'تسرب مواد خطرة',
      'location': 'حي الصناعة، شارع الملك عبدالله',
      'time': 'منذ 45 دقيقة',
      'priority': 'عالية جداً',
      'status': 'قيد المعالجة',
      'assignedTo': 'فريق المواد الخطرة',
      'icon': Icons.dangerous,
      'progress': 30,
    },
    {
      'id': '4',
      'type': 'مخلفات بناء',
      'location': 'حي التعاون، شارع الأمير فيصل',
      'time': 'منذ ساعتين',
      'priority': 'منخفضة',
      'status': 'مكتملة',
      'assignedTo': 'فريق النظافة 4',
      'icon': Icons.construction,
      'progress': 100,
    },
  ];

  // بيانات الفرق المتاحة الجديدة
  final List<Map<String, dynamic>> _availableTeams = [
    {
      'id': '1',
      'name': 'فريق الطوارئ 1',
      'status': 'نشط',
      'location': 'حي الروضة',
      'currentTask': 'معالجة انسداد',
      'members': 5,
      'vehicle': 'شاحنة صرف صحي',
      'rating': 4.8,
    },
    {
      'id': '2',
      'name': 'فريق النظافة 2',
      'status': 'متاح',
      'location': 'حي العليا',
      'currentTask': 'لا يوجد',
      'members': 4,
      'vehicle': 'شاحنة نفايات',
      'rating': 4.5,
    },
    {
      'id': '3',
      'name': 'فريق المواد الخطرة',
      'status': 'نشط',
      'location': 'حي السليمانية',
      'currentTask': 'تنظيف تسرب',
      'members': 6,
      'vehicle': 'شاحنة مخصصة',
      'rating': 4.9,
    },
    {
      'id': '4',
      'name': 'فريق الاستجابة السريعة',
      'status': 'متاح',
      'location': 'حي المرسلات',
      'currentTask': 'لا يوجد',
      'members': 3,
      'vehicle': 'سيارة دفع رباعي',
      'rating': 4.7,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (_isWheelSpinning) return;

    setState(() {
      _isWheelSpinning = true;
      _selectedWheelItem = -1;
    });

    _animationController.reset();
    _animationController.forward().then((_) {
      final random = DateTime.now().millisecond % 8;
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _selectedWheelItem = random;
          _isWheelSpinning = false;
        });
        _showWheelResult(random);
      });
    });
  }

  void _showWheelResult(int selectedIndex) {
    final List<Map<String, dynamic>> results = [
      {
        'title': 'تعيين فريق النظافة 2',
        'icon': Icons.assignment_turned_in,
        'color': _successColor,
      },
      {
        'title': 'طلب معدات إضافية',
        'icon': Icons.build,
        'color': _warningColor,
      },
      {
        'title': 'إرسال فريق الطوارئ',
        'icon': Icons.emergency,
        'color': _errorColor,
      },
      {
        'title': 'تحديث أولوية المهمة',
        'icon': Icons.priority_high,
        'color': _accentColor,
      },
      {
        'title': 'طلب تعزيزات',
        'icon': Icons.group_add,
        'color': _primaryColor,
      },
      {
        'title': 'توجيه إلى منطقة قريبة',
        'icon': Icons.near_me,
        'color': _secondaryColor,
      },
      {
        'title': 'إبلاغ الجهات المعنية',
        'icon': Icons.notification_important,
        'color': _wasteColor,
      },
      {
        'title': 'تقييم الموقف أولاً',
        'icon': Icons.assessment,
        'color': _textSecondaryColor,
      },
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(results[selectedIndex]['icon'], color: results[selectedIndex]['color'], size: 28),
            const SizedBox(width: 12),
            Text(
              'نتيجة العجلة',
              style: TextStyle(
                color: _textColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Text(
          results[selectedIndex]['title'],
          style: TextStyle(
            color: _textSecondaryColor,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'تم',
              style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('مركز طوارئ النظافة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: _primaryColor,
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_gradientStart, _gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, size: 24, color: Colors.white),
            onPressed: _showNotifications,
            tooltip: 'الإشعارات',
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 24, color: Colors.white),
            onPressed: _signOut,
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط التبويب المحسن
          Container(
            decoration: BoxDecoration(
              color: _cardColor,
              boxShadow: [
                BoxShadow(
                  color: _shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildTabItem(0, Icons.emergency, 'الطلبات'),
                _buildTabItem(1, Icons.group_work, 'الفرق'),
                _buildTabItem(2, Icons.explore, 'القرار'),
                _buildTabItem(3, Icons.analytics, 'الإحصائيات'),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentPageIndex,
              children: [
                _buildEmergencyRequestsView(),
                _buildTeamsView(),
                _buildDecisionWheelView(),
                _buildStatisticsView(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _wasteColor,
        onPressed: _reportNewEmergency,
        child: const Icon(Icons.add_alert, size: 28, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String title) {
    final isSelected = _currentPageIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentPageIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? _primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
            gradient: isSelected
                ? LinearGradient(
                    colors: [_primaryColor.withOpacity(0.1), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? _primaryColor : _textSecondaryColor,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? _primaryColor : _textSecondaryColor,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyRequestsView() {
    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('الطلبات العاجلة', Icons.emergency),
            const SizedBox(height: 20),
            ..._emergencyRequests.map((request) => _buildRequestItem(request)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamsView() {
    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('الفرق المتاحة', Icons.group_work),
            const SizedBox(height: 20),
            ..._availableTeams.map((team) => _buildTeamItem(team)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDecisionWheelView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSectionHeader('عجلة القرار', Icons.explore),
          const SizedBox(height: 20),
          _buildDecisionWheelCard(),
        ],
      ),
    );
  }

  Widget _buildStatisticsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSectionHeader('الإحصائيات', Icons.analytics),
          const SizedBox(height: 20),
          _buildStatsGrid(),
          const SizedBox(height: 20),
          _buildPerformanceChart(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _primaryColor, size: 24),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildRequestItem(Map<String, dynamic> request) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: _cardColor,
      child: InkWell(
        onTap: () => _handleRequest(request),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس البطاقة
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(request['icon'], color: _primaryColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      request['type'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: _textColor,
                      ),
                    ),
                  ),
                  _buildPriorityBadge(request['priority']),
                ],
              ),
            ),
            
            // محتوى البطاقة
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.location_on, 'الموقع', request['location']),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.access_time, 'الوقت', request['time']),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoRow(Icons.assignment, 'الحالة', request['status']),
                      const Spacer(),
                      _buildStatusChip(request['status']),
                    ],
                  ),
                  if (request['assignedTo'] != 'لم يتم التعيين')
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.group, 'المُعين', request['assignedTo']),
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (request['progress'] > 0) _buildProgressBar(request['progress']),
                ],
              ),
            ),
            
            // أزرار البطاقة
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _handleRequest(request),
                      style: FilledButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, size: 18),
                          SizedBox(width: 8),
                          Text('إدارة الطلب'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.map, size: 22, color: _primaryColor),
                    onPressed: () => _viewOnMap(request),
                    style: IconButton.styleFrom(
                      backgroundColor: _primaryColor.withOpacity(0.1),
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(int progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'تقدم المعالجة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textSecondaryColor,
                fontSize: 14,
              ),
            ),
            Text('$progress%', style: TextStyle(color: _primaryColor, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress / 100,
          backgroundColor: _backgroundColor,
          color: _primaryColor,
          borderRadius: BorderRadius.circular(10),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color badgeColor;
    String badgeText;
    
    switch (priority) {
      case 'عالية جداً':
        badgeColor = _errorColor;
        badgeText = 'عالي جداً';
        break;
      case 'عالية':
        badgeColor = _warningColor;
        badgeText = 'عالي';
        break;
      case 'متوسطة':
        badgeColor = _accentColor;
        badgeText = 'متوسط';
        break;
      default:
        badgeColor = _successColor;
        badgeText = 'منخفض';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        badgeText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTeamItem(Map<String, dynamic> team) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // مؤشر حالة الفريق
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: team['status'] == 'متاح' ? _successColor : _accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                
                // معلومات الفريق
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        team['location'],
                        style: TextStyle(color: _textSecondaryColor, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                
                // تقييم الفريق
                Row(
                  children: [
                    Icon(Icons.star, color: _warningColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      team['rating'].toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المهمة الحالية: ${team['currentTask']}',
                        style: TextStyle(color: _textSecondaryColor, fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'المركبة: ${team['vehicle']}',
                        style: TextStyle(color: _textSecondaryColor, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.people, size: 14, color: _primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        '${team['members']}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _viewTeamLocation(team),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryColor,
                  side: BorderSide(color: _primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 16),
                    SizedBox(width: 6),
                    Text('عرض الموقع'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecisionWheelCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'عجلة قرارات الطوارئ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'استخدم العجلة لاتخاذ قرارات سريعة في حالات الطوارئ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: _textSecondaryColor),
            ),
            const SizedBox(height: 24),
            
            // عجلة القرار الجديدة
            Center(
              child: GestureDetector(
                onTap: _spinWheel,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animation.value * 20,
                      child: child,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // العجلة الأساسية
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              _primaryColor,
                              _secondaryColor,
                              _accentColor,
                              _successColor,
                              _warningColor,
                              _errorColor,
                              _wasteColor,
                              _textSecondaryColor,
                            ],
                            stops: const [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                      ),

                      // تقسيمات العجلة
                      for (int i = 0; i < 8; i++)
                        Transform.rotate(
                          angle: i * (3.1415926535 / 4),
                          child: Container(
                            width: 250,
                            height: 2,
                            color: Colors.white54,
                          ),
                        ),

                      // مركز العجلة
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(Icons.emergency, color: _primaryColor, size: 30),
                      ),

                      // المؤشر
                      const Positioned(
                        top: -12,
                        child: Icon(
                          Icons.arrow_drop_up,
                          size: 50,
                          color: Colors.red,
                        ),
                      ),

                      // النصوص على العجلة
                      for (int i = 0; i < 8; i++)
                        Transform.rotate(
                          angle: i * (3.1415926535 / 4) + (3.1415926535 / 8),
                          child: Container(
                            alignment: Alignment.center,
                            width: 250,
                            child: Transform.translate(
                              offset: const Offset(0, -90),
                              child: Transform.rotate(
                                angle: -i * (3.1415926535 / 4) - (3.1415926535 / 8),
                                child: Text(
                                  '${i + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // زر التدوير
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _spinWheel,
                style: FilledButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isWheelSpinning ? Icons.autorenew : Icons.explore,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isWheelSpinning ? 'جاري التدوير...' : 'تدوير العجلة',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard('الطلبات النشطة', '8', Icons.emergency, _errorColor),
        _buildStatCard('الفرق المتاحة', '2', Icons.group_work, _successColor),
        _buildStatCard('المكتملة اليوم', '15', Icons.check_circle, _primaryColor),
        _buildStatCard('المعلقة', '3', Icons.pending, _warningColor),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: _textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أداء الفرق هذا الأسبوع',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'رسم بياني لأداء الفرق',
                  style: TextStyle(color: _textSecondaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _textSecondaryColor),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(fontWeight: FontWeight.bold, color: _textColor, fontSize: 14),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: _textSecondaryColor, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor = _textSecondaryColor;
    
    if (status == 'قيد المعالجة') {
      statusColor = _successColor;
    } else if (status == 'معلقة') {
      statusColor = _warningColor;
    } else if (status == 'مكتملة') {
      statusColor = _primaryColor;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _handleRequest(Map<String, dynamic> request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: _textSecondaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'إدارة الطلب: ${request['type']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow(Icons.location_on, 'الموقع', request['location']),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.priority_high, 'الأولوية', request['priority']),
            const SizedBox(height: 12),
            
            const SizedBox(height: 20),
            Text(
              'اختر فريقًا لتعيينه:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor),
            ),
            const SizedBox(height: 12),
            ..._availableTeams
                .where((team) => team['status'] == 'متاح')
                .map(
                  (team) => ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.group_work, color: _primaryColor, size: 20),
                    ),
                    title: Text(team['name'], style: TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
                    subtitle: Text(team['location'], style: TextStyle(color: _textSecondaryColor)),
                    trailing: Text('${team['members']} أعضاء', style: TextStyle(color: _textSecondaryColor)),
                    onTap: () {
                      Navigator.pop(context);
                      _assignTeamToRequest(request, team);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                )
                .toList(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryColor,
                  side: BorderSide(color: _primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('إلغاء'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _assignTeamToRequest(Map<String, dynamic> request, Map<String, dynamic> team) {
    setState(() {
      request['assignedTo'] = team['name'];
      request['status'] = 'قيد المعالجة';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تعيين ${team['name']} إلى الطلب بنجاح'),
        backgroundColor: _successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _viewOnMap(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('موقع الطلب: ${request['type']}', style: TextStyle(color: _textColor)),
        content: Text('سيتم فتح موقع الطلب على الخريطة في التطبيق الكامل', style: TextStyle(color: _textSecondaryColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً', style: TextStyle(color: _primaryColor)),
          ),
        ],
      ),
    );
  }

  void _viewTeamLocation(Map<String, dynamic> team) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('موقع الفريق: ${team['name']}', style: TextStyle(color: _textColor)),
        content: Text('سيتم فتح موقع الفريق على الخريطة في التطبيق الكامل', style: TextStyle(color: _textSecondaryColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً', style: TextStyle(color: _primaryColor)),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الإشعارات', style: TextStyle(color: _textColor)),
        content: Text('لا توجد إشعارات جديدة', style: TextStyle(color: _textSecondaryColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً', style: TextStyle(color: _primaryColor)),
          ),
        ],
      ),
    );
  }

  void _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void _reportNewEmergency() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: _textSecondaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'الإبلاغ عن حالة طارئة جديدة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'نوع الحالة',
                  labelStyle: TextStyle(color: _textSecondaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _textSecondaryColor.withOpacity(0.3)),
                  ),
                  prefixIcon: Icon(Icons.category, color: _primaryColor),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'الموقع',
                  labelStyle: TextStyle(color: _textSecondaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _textSecondaryColor.withOpacity(0.3)),
                  ),
                  prefixIcon: Icon(Icons.location_on, color: _primaryColor),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'التفاصيل',
                  labelStyle: TextStyle(color: _textSecondaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _textSecondaryColor.withOpacity(0.3)),
                  ),
                  prefixIcon: Icon(Icons.description, color: _primaryColor),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primaryColor,
                        side: BorderSide(color: _primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم الإبلاغ عن الحالة الطارئة بنجاح', style: TextStyle(color: Colors.white)),
                            backgroundColor: _successColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('إرسال'),
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
}
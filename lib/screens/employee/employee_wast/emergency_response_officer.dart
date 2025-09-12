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
  // الألوان الرئيسية للتصميم
  final Color _primaryColor = const Color(0xFF0D47A1); // أزرق حكومي داكن
  final Color _secondaryColor = const Color(0xFF1976D2); // أزرق حكومي
  final Color _accentColor = const Color(0xFF64B5F6); // أزرق فاتح
  final Color _backgroundColor = const Color(0xFFF8F9FA); // خلفية رمادية فاتحة
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _wasteColor = const Color(0xFF4CAF50); // لون قسم النفايات

  late AnimationController _animationController;
  late Animation<double> _animation;
  int _selectedWheelItem = -1;
  bool _isWheelSpinning = false;

  // بيانات الطلبات العاجلة
  final List<Map<String, dynamic>> _emergencyRequests = [
    {
      'id': '1',
      'type': 'انسداد مجرى',
      'location': 'حي السلام، شارع الملك فهد',
      'time': 'منذ 15 دقيقة',
      'priority': 'عالية',
      'status': 'قيد المعالجة',
      'assignedTo': 'فريق النظافة 3',
    },
    {
      'id': '2',
      'type': 'حاوية ممتلئة',
      'location': 'حي الروضة، شارع الأمير محمد',
      'time': 'منذ 30 دقيقة',
      'priority': 'متوسطة',
      'status': 'معلقة',
      'assignedTo': 'لم يتم التعيين',
    },
    {
      'id': '3',
      'type': 'تسرب نفايات',
      'location': 'حي المركز، شارع الصناعة',
      'time': 'منذ ساعة',
      'priority': 'عالية',
      'status': 'قيد المعالجة',
      'assignedTo': 'فريق الطوارئ 1',
    },
  ];

  // بيانات الفرق المتاحة
  final List<Map<String, dynamic>> _availableTeams = [
    {
      'id': '1',
      'name': 'فريق النظافة 1',
      'status': 'متاح',
      'location': 'حي الشرق',
      'currentTask': 'لا يوجد',
    },
    {
      'id': '2',
      'name': 'فريق النظافة 2',
      'status': 'يعمل',
      'location': 'حي الغرب',
      'currentTask': 'جمع النفايات',
    },
    {
      'id': '3',
      'name': 'فريق النظافة 3',
      'status': 'متاح',
      'location': 'حي الشمال',
      'currentTask': 'لا يوجد',
    },
    {
      'id': '4',
      'name': 'فريق الطوارئ 1',
      'status': 'يعمل',
      'location': 'حي الجنوب',
      'currentTask': 'معالجة انسداد',
    },
  ];

  @override
  void initState() {
    super.initState();

    // تهيئة المتحكم للحركة الدورانية
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

  // دورة تدوير العجلة
  void _spinWheel() {
    if (_isWheelSpinning) return;

    setState(() {
      _isWheelSpinning = true;
      _selectedWheelItem = -1;
    });

    _animationController.reset();
    _animationController.forward().then((_) {
      // بعد انتهاء التدوير، اختيار عنصر عشوائي
      final random = DateTime.now().millisecond % 6;
      setState(() {
        _selectedWheelItem = random;
        _isWheelSpinning = false;
      });

      // عرض النتيجة
      _showWheelResult(random);
    });
  }

  // عرض نتيجة العجلة
  void _showWheelResult(int selectedIndex) {
    final List<String> results = [
      'تعيين فريق النظافة 1',
      'تعيين فريق النظافة 3',
      'طلب معدات إضافية',
      'إرسال فريق الطوارئ',
      'تحديث أولوية المهمة',
      'طلب تعزيزات',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('نتيجة العجلة'),
        content: Text(results[selectedIndex]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
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
        title: const Text('مركز التحكم - موظف الطوارئ'),
        backgroundColor: _primaryColor,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الطلبات العاجلة
            _buildEmergencyRequestsCard(),

            const SizedBox(height: 20),

            // بطاقة الفرق المتاحة
            _buildTeamsCard(),

            const SizedBox(height: 20),

            // عجلة القرار - البوابة المتحركة
            _buildDecisionWheel(),

            const SizedBox(height: 20),

            // إحصائيات سريعة
            _buildQuickStats(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _wasteColor,
        onPressed: () => _reportNewEmergency(),
        child: const Icon(Icons.add_alert, color: Colors.white),
      ),
    );
  }

  // بناء بطاقة الطلبات العاجلة
  Widget _buildEmergencyRequestsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emergency, color: _errorColor),
                const SizedBox(width: 10),
                const Text(
                  'الطلبات العاجلة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ..._emergencyRequests
                .map((request) => _buildRequestItem(request))
                .toList(),
          ],
        ),
      ),
    );
  }

  // بناء عنصر طلب
  Widget _buildRequestItem(Map<String, dynamic> request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _backgroundColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                request['type'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: request['priority'] == 'عالية'
                      ? _errorColor
                      : _warningColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  request['priority'],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            request['location'],
            style: TextStyle(color: _textSecondaryColor),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                request['time'],
                style: TextStyle(color: _textSecondaryColor, fontSize: 12),
              ),
              Text(
                request['status'],
                style: TextStyle(
                  color: request['status'] == 'قيد المعالجة'
                      ? _successColor
                      : _warningColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (request['assignedTo'] != 'لم يتم التعيين')
            Text(
              'مُعين إلى: ${request['assignedTo']}',
              style: TextStyle(color: _textSecondaryColor, fontSize: 12),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleRequest(request),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _secondaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('إدارة الطلب'),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.location_on, color: _primaryColor),
                onPressed: () => _viewOnMap(request),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // بناء بطاقة الفرق المتاحة
  Widget _buildTeamsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.group, color: _primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'الفرق المتاحة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ..._availableTeams.map((team) => _buildTeamItem(team)).toList(),
          ],
        ),
      ),
    );
  }

  // بناء عنصر فريق
  Widget _buildTeamItem(Map<String, dynamic> team) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _backgroundColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: team['status'] == 'متاح' ? _successColor : _warningColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              team['status'] == 'متاح' ? Icons.check : Icons.schedule,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  team['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                Text(
                  team['location'],
                  style: TextStyle(color: _textSecondaryColor, fontSize: 12),
                ),
                Text(
                  team['currentTask'],
                  style: TextStyle(color: _textSecondaryColor, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.location_on, color: _primaryColor),
            onPressed: () => _viewTeamLocation(team),
          ),
        ],
      ),
    );
  }

  // بناء عجلة القرار
  Widget _buildDecisionWheel() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, color: _primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'عجلة القرار',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'استخدم عجلة القرار لاتخاذ قرارات سريعة في حالات الطوارئ',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _spinWheel,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animation.value * 20, // تدوير العجلة
                      child: child,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // العجلة الأساسية
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: _primaryColor,
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [_primaryColor, _secondaryColor],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),

                      // تقسيمات العجلة
                      for (int i = 0; i < 6; i++)
                        Transform.rotate(
                          angle:
                              i *
                              (3.1415926535 / 3), // تقسيم العجلة إلى 6 أجزاء
                          child: Container(
                            width: 200,
                            height: 2,
                            color: Colors.white,
                          ),
                        ),

                      // مركز العجلة
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.emergency, color: _primaryColor),
                      ),

                      // المؤشر
                      const Positioned(
                        top: 0,
                        child: Icon(
                          Icons.arrow_drop_up,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _spinWheel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  _isWheelSpinning ? 'جاري التدوير...' : 'تدوير العجلة',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بناء إحصائيات سريعة
  Widget _buildQuickStats() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: _primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'إحصائيات سريعة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'الطلبات النشطة',
                  '12',
                  Icons.emergency,
                  _errorColor,
                ),
                _buildStatItem(
                  'الفرق المتاحة',
                  '3',
                  Icons.group,
                  _successColor,
                ),
                _buildStatItem(
                  'المكتملة اليوم',
                  '8',
                  Icons.check_circle,
                  _primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // بناء عنصر إحصائية
  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 30),
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
        Text(title, style: TextStyle(fontSize: 12, color: _textSecondaryColor)),
      ],
    );
  }

  // دالة التعامل مع الطلب
  void _handleRequest(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إدارة الطلب: ${request['type']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الموقع: ${request['location']}'),
            Text('الأولوية: ${request['priority']}'),
            Text('الحالة: ${request['status']}'),
            const SizedBox(height: 16),
            const Text('اختر فريقًا لتعيينه:'),
            ..._availableTeams
                .where((team) => team['status'] == 'متاح')
                .map(
                  (team) => ListTile(
                    leading: Icon(Icons.group, color: _primaryColor),
                    title: Text(team['name']),
                    subtitle: Text(team['location']),
                    onTap: () {
                      Navigator.pop(context);
                      _assignTeamToRequest(request, team);
                    },
                  ),
                )
                .toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  // تعيين فريق إلى طلب
  void _assignTeamToRequest(
    Map<String, dynamic> request,
    Map<String, dynamic> team,
  ) {
    // هنا سيتم ربط الفريق بالطلب في قاعدة البيانات
    setState(() {
      request['assignedTo'] = team['name'];
      request['status'] = 'قيد المعالجة';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تعيين ${team['name']} إلى الطلب بنجاح'),
        backgroundColor: _successColor,
      ),
    );
  }

  // عرض الموقع على الخريطة
  void _viewOnMap(Map<String, dynamic> request) {
    // هنا سيتم فتح الخريطة وعرض موقع الطلب
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('موقع الطلب: ${request['type']}'),
        content: const Text(
          'سيتم فتح موقع الطلب على الخريطة في التطبيق الكامل',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  // عرض موقع الفريق على الخريطة
  void _viewTeamLocation(Map<String, dynamic> team) {
    // هنا سيتم فتح الخريطة وعرض موقع الفريق
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('موقع الفريق: ${team['name']}'),
        content: const Text(
          'سيتم فتح موقع الفريق على الخريطة في التطبيق الكامل',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  // عرض الإشعارات
  void _showNotifications() {
    // هنا سيتم عرض الإشعارات
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الإشعارات'),
        content: const Text('لا توجد إشعارات جديدة'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  // تسجيل الخروج
  void _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      // العودة إلى شاشة تسجيل الدخول
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // الإبلاغ عن حالة طارئة جديدة
  void _reportNewEmergency() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الإبلاغ عن حالة طارئة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'نوع الحالة'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'الموقع'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'التفاصيل'),
              maxLines: 3,
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم الإبلاغ عن الحالة الطارئة بنجاح'),
                ),
              );
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }
}

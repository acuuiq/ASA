//شاشه مدير طلبات الحاويات ولنفايات
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContainerRequestManager extends StatefulWidget {
  static const String screenRoute = 'container_request_manager';

  const ContainerRequestManager({super.key});

  @override
  State<ContainerRequestManager> createState() =>
      _ContainerRequestManagerState();
}

class _ContainerRequestManagerState extends State<ContainerRequestManager>
    with SingleTickerProviderStateMixin {
  // ألوان التصميم المميز عالمياً
  final Color _primaryColor = const Color(0xFF2E7D32); // أخضر أساسي
  final Color _secondaryColor = const Color(0xFF66BB6A); // أخضر فاتح
  final Color _accentColor = const Color(0xFFF57C00); // برتقالي مميز
  final Color _backgroundColor = const Color(0xFFF8F9FA); // خلفية رمادية فاتحة
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);
  final Color _successColor = const Color(0xFF388E3C);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _borderColor = const Color(0xFFE0E0E0);

  // حالة لتتبع البوابة المفتوحة
  String? _selectedGateway;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // قائمة البوابات
  final List<Map<String, dynamic>> _gateways = [
    {
      'id': 'overview',
      'title': 'نظرة عامة على الطلبات',
      'icon': Icons.dashboard,
      'colors': [Color(0xFF2E7D32), Color(0xFF66BB6A)],
      'description': 'عرض إحصاءات الطلبات والحالات',
      'badgeCount': 0,
    },
    {
      'id': 'new',
      'title': 'الطلبات الجديدة',
      'icon': Icons.new_releases,
      'colors': [Color(0xFF1976D2), Color(0xFF64B5F6)],
      'description': 'إدارة الطلبات الجديدة التي تحتاج للمراجعة',
      'badgeCount': 5,
    },
    {
      'id': 'in_progress',
      'title': 'طلبات قيد المعالجة',
      'icon': Icons.hourglass_bottom,
      'colors': [Color(0xFFF57C00), Color(0xFFFFB74D)],
      'description': 'متابعة الطلبات قيد التنفيذ والتوصيل',
      'badgeCount': 12,
    },
    {
      'id': 'completed',
      'title': 'الطلبات المكتملة',
      'icon': Icons.check_circle,
      'colors': [Color(0xFF388E3C), Color(0xFF81C784)],
      'description': 'عرض الطلبات التي تم توصيلها بنجاح',
      'badgeCount': 0,
    },
    {
      'id': 'cancelled',
      'title': 'الطلبات الملغاة',
      'icon': Icons.cancel,
      'colors': [Color(0xFFD32F2F), Color(0xFFE57373)],
      'description': 'مراجعة الطلبات الملغاة وأسباب الإلغاء',
      'badgeCount': 0,
    },
    {
      'id': 'statistics',
      'title': 'إحصائيات وتقارير',
      'icon': Icons.analytics,
      'colors': [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
      'description': 'تقارير أداء النظام وإحصائيات الطلبات',
      'badgeCount': 0,
    },
    {
      'id': 'container_types',
      'title': 'إدارة أنواع الحاويات',
      'icon': Icons.category,
      'colors': [Color(0xFF00897B), Color(0xFF4DB6AC)],
      'description': 'إضافة وتعديل أنواع الحاويات المتاحة',
      'badgeCount': 0,
    },
    {
      'id': 'settings',
      'title': 'إعدادات النظام',
      'icon': Icons.settings,
      'colors': [Color(0xFF546E7A), Color(0xFF90A4AE)],
      'description': 'تعديل إعدادات نظام إدارة الطلبات',
      'badgeCount': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          _selectedGateway != null
              ? _gateways.firstWhere(
                  (g) => g['id'] == _selectedGateway,
                )['title']
              : 'مدير طلبات الحاويات - النفايات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_selectedGateway != null) {
              setState(() {
                _selectedGateway = null;
                _animationController.reset();
                _animationController.forward();
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: _selectedGateway != null
            ? [
                IconButton(
                  icon: Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _selectedGateway = null;
                      _animationController.reset();
                      _animationController.forward();
                    });
                  },
                ),
              ]
            : null,
      ),
      body: _selectedGateway != null
          ? _buildGatewayContent(_selectedGateway!)
          : _buildWheelView(),
    );
  }

  // بناء واجهة العجلة
  Widget _buildWheelView() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // شريط البحث
              _buildSearchBar(),
              SizedBox(height: 20),

              Text(
                'إدارة طلبات الحاويات',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'اختر البوابة المطلوبة للبدء',
                style: TextStyle(fontSize: 16, color: _textSecondaryColor),
              ),
              SizedBox(height: 30),

              // بناء العجلة من دوائر
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _gateways.length,
                  itemBuilder: (context, index) {
                    final gateway = _gateways[index];
                    return _buildGatewayCircle(gateway);
                  },
                ),
              ),

              SizedBox(height: 20),

              // إحصائيات سريعة
              _buildQuickStats(),
            ],
          ),
        ),
      ),
    );
  }

  // شريط البحث
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ابحث في الطلبات...',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: _primaryColor),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  // إحصائيات سريعة
  Widget _buildQuickStats() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إحصائيات سريعة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickStatItem(
                  'جديدة',
                  '5',
                  Icons.new_releases,
                  Colors.blue,
                ),
                _buildQuickStatItem(
                  'قيد المعالجة',
                  '12',
                  Icons.hourglass_bottom,
                  Colors.orange,
                ),
                _buildQuickStatItem(
                  'مكتملة',
                  '24',
                  Icons.check_circle,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(title, style: TextStyle(fontSize: 12, color: _textSecondaryColor)),
      ],
    );
  }

  // بناء دائرة البوابة
  Widget _buildGatewayCircle(Map<String, dynamic> gateway) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGateway = gateway['id'];
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: List<Color>.from(gateway['colors']),
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 15,
              right: 15,
              child: Icon(
                gateway['icon'],
                color: Colors.white.withOpacity(0.8),
                size: 30,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    gateway['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 5),
                  if (gateway['badgeCount'] > 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${gateway['badgeCount']} جديد',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
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

  // بناء محتوى البوابة المحددة
  Widget _buildGatewayContent(String gatewayId) {
    final gateway = _gateways.firstWhere((g) => g['id'] == gatewayId);

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: _getGatewayContent(gateway),
    );
  }

  Widget _getGatewayContent(Map<String, dynamic> gateway) {
    switch (gateway['id']) {
      case 'overview':
        return _buildOverviewContent(gateway);
      case 'new':
        return _buildNewRequestsContent(gateway);
      case 'in_progress':
        return _buildInProgressContent(gateway);
      case 'completed':
        return _buildCompletedContent(gateway);
      case 'cancelled':
        return _buildCancelledContent(gateway);
      case 'statistics':
        return _buildStatisticsContent(gateway);
      case 'container_types':
        return _buildContainerTypesContent(gateway);
      case 'settings':
        return _buildSettingsContent(gateway);
      default:
        return Center(child: Text('المحتوى غير متوفر'));
    }
  }

  // محتوى نظرة عامة
  Widget _buildOverviewContent(Map<String, dynamic> gateway) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGatewayHeader(gateway),
          SizedBox(height: 20),

          // مخطط إحصائي
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'توزيع الطلبات',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildChartBar('جديدة', 5, Colors.blue, 24),
                        _buildChartBar('قيد التنفيذ', 12, Colors.orange, 24),
                        _buildChartBar('مكتملة', 24, Colors.green, 24),
                        _buildChartBar('ملغاة', 3, Colors.red, 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                'الطلبات الجديدة',
                '5',
                Icons.new_releases,
                Colors.blue,
              ),
              _buildStatCard(
                'قيد المعالجة',
                '12',
                Icons.hourglass_bottom,
                Colors.orange,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                'المكتملة',
                '24',
                Icons.check_circle,
                Colors.green,
              ),
              _buildStatCard('الملغاة', '3', Icons.cancel, Colors.red),
            ],
          ),

          SizedBox(height: 20),
          Text(
            'آخر الطلبات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildRequestItem(
            'طلب #1234',
            'محمود أحمد',
            'قيد المعالجة',
            Colors.orange,
          ),
          _buildRequestItem('طلب #1233', 'سعيد محمد', 'مكتمل', Colors.green),
          _buildRequestItem('طلب #1232', 'فاطمة علي', 'جديد', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildChartBar(String label, int value, Color color, int maxValue) {
    final height = (value / maxValue) * 150;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          ),
        ),
        SizedBox(height: 5),
        Text(value.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  // محتوى الطلبات الجديدة
  Widget _buildNewRequestsContent(Map<String, dynamic> gateway) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGatewayHeader(gateway),
          SizedBox(height: 20),

          // فلترة الطلبات
          Row(
            children: [
              Expanded(
                child: FilterChip(
                  label: Text('الكل (5)'),
                  selected: true,
                  onSelected: (_) {},
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: FilterChip(
                  label: Text('عاجل (2)'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ),
            ],
          ),

          SizedBox(height: 15),
          _buildRequestItem(
            'طلب #1235',
            'أحمد السيد',
            'جديد',
            Colors.blue,
            showActions: true,
            isUrgent: true,
          ),
          _buildRequestItem(
            'طلب #1234',
            'محمد نور',
            'جديد',
            Colors.blue,
            showActions: true,
          ),
          _buildRequestItem(
            'طلب #1233',
            'سارة عبدالله',
            'جديد',
            Colors.blue,
            showActions: true,
            isUrgent: true,
          ),
          _buildRequestItem(
            'طلب #1232',
            'خالد أمين',
            'جديد',
            Colors.blue,
            showActions: true,
          ),
          _buildRequestItem(
            'طلب #1231',
            'ليلى مصطفى',
            'جديد',
            Colors.blue,
            showActions: true,
          ),
        ],
      ),
    );
  }

  // بناء رأس البوابة
  Widget _buildGatewayHeader(Map<String, dynamic> gateway) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: List<Color>.from(gateway['colors']),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(gateway['icon'], color: Colors.white, size: 30),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gateway['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  gateway['description'],
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // بناء بطاقة إحصائية
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(title),
          ],
        ),
      ),
    );
  }

  // بناء عنصر طلب
  Widget _buildRequestItem(
    String id,
    String customer,
    String status,
    Color statusColor, {
    bool showActions = false,
    bool isUrgent = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      color: isUrgent ? statusColor.withOpacity(0.1) : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.inventory_2, color: statusColor),
        ),
        title: Row(
          children: [
            Text(id, style: TextStyle(fontWeight: FontWeight.bold)),
            if (isUrgent)
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.error, color: Colors.red, size: 16),
              ),
          ],
        ),
        subtitle: Text(customer),
        trailing: Chip(
          label: Text(status, style: TextStyle(color: Colors.white)),
          backgroundColor: statusColor,
        ),
        onTap: () {
          _showRequestDetails(context, id);
        },
      ),
    );
  }

  void _showRequestDetails(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تفاصيل الطلب $requestId'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('العميل: محمود أحمد'),
                Text('نوع الحاوية: بلاستيك'),
                Text('الكمية: 5 حاويات'),
                Text('الحالة: قيد المعالجة'),
                Text(
                  'تاريخ الطلب: ${DateFormat('yyyy/MM/dd').format(DateTime.now())}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('إغلاق'),
            ),
            ElevatedButton(onPressed: () {}, child: Text('تغيير الحالة')),
          ],
        );
      },
    );
  }

  // محتويات البوابات الأخرى
  Widget _buildInProgressContent(Map<String, dynamic> gateway) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGatewayHeader(gateway),
          SizedBox(height: 20),
          _buildRequestItem(
            'طلب #1225',
            'علي حسن',
            'قيد التوصيل',
            Colors.orange,
          ),
          _buildRequestItem(
            'طلب #1224',
            'ناصر محمد',
            'قيد التجميع',
            Colors.orange,
          ),
          _buildRequestItem(
            'طلب #1223',
            'ريم عبدالله',
            'قيد التوصيل',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedContent(Map<String, dynamic> gateway) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGatewayHeader(gateway),
          SizedBox(height: 20),
          _buildRequestItem('طلب #1220', 'سالم أحمد', 'مكتمل', Colors.green),
          _buildRequestItem('طلب #1219', 'فهد خالد', 'مكتمل', Colors.green),
          _buildRequestItem('طلب #1218', 'لطيفة محمد', 'مكتمل', Colors.green),
        ],
      ),
    );
  }

  Widget _buildCancelledContent(Map<String, dynamic> gateway) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGatewayHeader(gateway),
          SizedBox(height: 20),
          _buildRequestItem('طلب #1217', 'محمد سعيد', 'ملغى', Colors.red),
          _buildRequestItem('طلب #1216', 'أحمد علي', 'ملغى', Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatisticsContent(Map<String, dynamic> gateway) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGatewayHeader(gateway),
          SizedBox(height: 20),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إحصائيات الطلبات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('إجمالي الطلبات:'),
                      Text('44', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('معدل الإكمال:'),
                      Text(
                        '85%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('متوسط وقت التنفيذ:'),
                      Text(
                        '2.5 يوم',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainerTypesContent(Map<String, dynamic> gateway) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGatewayHeader(gateway),
          SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: Icon(Icons.category, color: Colors.blue),
              title: Text('حاوية بلاستيك'),
              subtitle: Text('سعة 100 لتر'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.category, color: Colors.green),
              title: Text('حاوية معدنية'),
              subtitle: Text('سعة 200 لتر'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.category, color: Colors.orange),
              title: Text('حاوية كرتون'),
              subtitle: Text('سعة 50 لتر'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(Map<String, dynamic> gateway) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGatewayHeader(gateway),
          SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.blue),
              title: Text('الإشعارات'),
              subtitle: Text('إدارة إشعارات النظام'),
              trailing: Switch(value: true, onChanged: (_) {}),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.language, color: Colors.green),
              title: Text('اللغة'),
              subtitle: Text('تغيير لغة التطبيق'),
              trailing: Text('العربية'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.security, color: Colors.orange),
              title: Text('الأمان'),
              subtitle: Text('إعدادات الأمان والخصوصية'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}

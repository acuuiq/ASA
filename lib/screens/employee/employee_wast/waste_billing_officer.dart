import 'package:flutter/material.dart';

class WasteBillingOfficerScreen extends StatefulWidget {
  const WasteBillingOfficerScreen({super.key});

  @override
  State<WasteBillingOfficerScreen> createState() => _WasteBillingOfficerScreenState();
}

class _WasteBillingOfficerScreenState extends State<WasteBillingOfficerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // بيانات حقيقية للعرض
  Map<String, dynamic> _billingData = {
    'monthlyInvoices': 150,
    'pendingPayments': 25,
    'paidInvoices': 125,
    'totalRevenue': 75000,
    'outstandingBalance': 12500,
  };

  List<Map<String, dynamic>> _recentInvoices = [];
  List<Map<String, dynamic>> _pendingPayments = [];
  List<Map<String, dynamic>> _alerts = [];

  final List<Map<String, dynamic>> _mainFeatures = [
    {
      'icon': Icons.receipt_long,
      'title': 'إدارة الفواتير',
      'color': Colors.blue,
      'screen': 'invoices'
    },
    {
      'icon': Icons.payment,
      'title': 'المدفوعات',
      'color': Colors.green,
      'screen': 'payments'
    },
    {
      'icon': Icons.people,
      'title': 'الحسابات',
      'color': Colors.purple,
      'screen': 'accounts'
    },
    {
      'icon': Icons.analytics,
      'title': 'التقارير',
      'color': Colors.orange,
      'screen': 'reports'
    },
    {
      'icon': Icons.notifications_active,
      'title': 'التنبيهات',
      'color': Colors.red,
      'screen': 'alerts'
    },
    {
      'icon': Icons.settings,
      'title': 'الإعدادات',
      'color': Colors.grey,
      'screen': 'settings'
    },
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {
      'icon': Icons.search,
      'title': 'بحث فاتورة',
      'color': Colors.blue,
    },
    {
      'icon': Icons.download,
      'title': 'تصدير تقرير',
      'color': Colors.green,
    },
    {
      'icon': Icons.email,
      'title': 'إرسال تنبيه',
      'color': Colors.orange,
    },
    {
      'icon': Icons.refresh,
      'title': 'تحديث البيانات',
      'color': Color.fromARGB(255, 17, 126, 117),
    },
  ];

  // بيانات الإعدادات المفصلة
  final List<Map<String, dynamic>> _settingsData = [
    {
      'title': 'المعلومات الشخصية',
      'icon': Icons.person,
      'description': 'إدارة بياناتك الشخصية والمهنية',
      'settings': [
        {
          'name': 'الاسم الكامل',
          'value': 'موظف الفواتير - قسم النفايات',
          'type': 'text',
          'editable': true
        },
        {
          'name': 'البريد الإلكتروني',
          'value': 'billing.officer@waste.gov',
          'type': 'email',
          'editable': true
        },
        {
          'name': 'رقم الهاتف',
          'value': '0550123456',
          'type': 'phone',
          'editable': true
        },
        {
          'name': 'القسم',
          'value': 'إدارة الفواتير',
          'type': 'text',
          'editable': false
        },
        {
          'name': 'المسمى الوظيفي',
          'value': 'موظف فواتير أول',
          'type': 'text',
          'editable': false
        },
        {
          'name': 'تاريخ التعيين',
          'value': '2023-01-15',
          'type': 'date',
          'editable': false
        },
      ]
    },
    {
      'title': 'إعدادات الفواتير',
      'icon': Icons.receipt,
      'description': 'تخصيص إعدادات نظام الفواتير',
      'settings': [
        {
          'name': 'تنسيق رقم الفاتورة',
          'value': 'INV-YYYY-###',
          'type': 'select',
          'options': ['INV-YYYY-###', 'INV-###-YYYY', 'WASTE-INV-###'],
          'editable': true
        },
        {
          'name': 'فترة إرسال الفواتير',
          'value': 'شهري',
          'type': 'select',
          'options': ['شهري', 'ربع سنوي', 'نصف سنوي', 'سنوي'],
          'editable': true
        },
        {
          'name': 'الحد الأقصى للفواتير',
          'value': '200',
          'type': 'number',
          'editable': true
        },
        {
          'name': 'الإشعارات التلقائية',
          'value': 'مفعل',
          'type': 'switch',
          'editable': true
        },
        {
          'name': 'فترة السماح',
          'value': '15 يوم',
          'type': 'select',
          'options': ['7 أيام', '15 يوم', '30 يوم'],
          'editable': true
        },
        {
          'name': 'نسبة الغرامة',
          'value': '2%',
          'type': 'text',
          'editable': true
        },
      ]
    },
    {
      'title': 'إعدادات الإشعارات',
      'icon': Icons.notifications,
      'description': 'التحكم في الإشعارات والتنبيهات',
      'settings': [
        {
          'name': 'إشعارات الدفع',
          'value': 'مفعل',
          'type': 'switch',
          'editable': true
        },
        {
          'name': 'إشعارات التأخير',
          'value': 'مفعل',
          'type': 'switch',
          'editable': true
        },
        {
          'name': 'إشعارات العملاء الجدد',
          'value': 'مفعل',
          'type': 'switch',
          'editable': true
        },
        {
          'name': 'التنبيهات الصوتية',
          'value': 'معطل',
          'type': 'switch',
          'editable': true
        },
        {
          'name': 'الإشعارات عبر البريد',
          'value': 'مفعل',
          'type': 'switch',
          'editable': true
        },
        {
          'name': 'الإشعارات عبر SMS',
          'value': 'معطل',
          'type': 'switch',
          'editable': true
        },
      ]
    },
    {
      'title': 'الأمان',
      'icon': Icons.security,
      'description': 'إعدادات الأمان والخصوصية',
      'settings': [
        {
          'name': 'المصادقة الثنائية',
          'value': 'مفعلة',
          'type': 'switch',
          'editable': true
        },
        {
          'name': 'تغيير كلمة المرور',
          'value': '********',
          'type': 'password',
          'editable': true
        },
        {
          'name': 'نشاط تسجيل الدخول',
          'value': 'عرض',
          'type': 'button',
          'editable': true
        },
        {
          'name': 'جلسات نشطة',
          'value': '1',
          'type': 'text',
          'editable': false
        },
        {
          'name': 'تاريخ آخر تسجيل دخول',
          'value': '2024-01-15 08:30',
          'type': 'datetime',
          'editable': false
        },
        {
          'name': 'تشفير البيانات',
          'value': 'مفعل',
          'type': 'switch',
          'editable': false
        },
      ]
    },
    {
      'title': 'التطبيق',
      'icon': Icons.apps,
      'description': 'إعدادات التطبيق والمظهر',
      'settings': [
        {
          'name': 'اللغة',
          'value': 'العربية',
          'type': 'select',
          'options': ['العربية', 'English'],
          'editable': true
        },
        {
          'name': 'النسخة',
          'value': '2.1.4',
          'type': 'text',
          'editable': false
        },
        {
          'name': 'المظهر',
          'value': 'فاتح',
          'type': 'select',
          'options': ['فاتح', 'غامق', 'تلقائي'],
          'editable': true
        },
        {
          'name': 'حجم الخط',
          'value': 'متوسط',
          'type': 'select',
          'options': ['صغير', 'متوسط', 'كبير'],
          'editable': true
        },
        {
          'name': 'التحديث التلقائي',
          'value': 'مفعل',
          'type': 'switch',
          'editable': true
        },
        {
          'name': 'مسح الذاكرة المؤقتة',
          'value': '2.3 MB',
          'type': 'button',
          'editable': true
        },
      ]
    },
    {
      'title': 'المساعدة والدعم',
      'icon': Icons.help,
      'description': 'الدعم الفني والمساعدة',
      'settings': [
        {
          'name': 'المركز المساعدة',
          'value': 'زيارة',
          'type': 'button',
          'editable': true
        },
        {
          'name': 'اتصل بالدعم',
          'value': '8001234567',
          'type': 'phone',
          'editable': true
        },
        {
          'name': 'البريد الدعم',
          'value': 'support@waste.gov',
          'type': 'email',
          'editable': true
        },
        {
          'name': 'الشروط والأحكام',
          'value': 'عرض',
          'type': 'button',
          'editable': true
        },
        {
          'name': 'سياسة الخصوصية',
          'value': 'عرض',
          'type': 'button',
          'editable': true
        },
        {
          'name': 'تقييم التطبيق',
          'value': 'تقييم',
          'type': 'button',
          'editable': true
        },
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
    _loadInitialData();
  }

  void _loadInitialData() {
    // تحميل بيانات الفواتير الحديثة
    _recentInvoices = [
      {
        'id': 'INV-2024-001',
        'customer': 'أحمد محمد',
        'amount': 500,
        'date': '2024-01-15',
        'status': 'مدفوعة',
        'statusColor': Colors.green
      },
      {
        'id': 'INV-2024-002',
        'customer': 'فاطمة علي',
        'amount': 750,
        'date': '2024-01-14',
        'status': 'متأخرة',
        'statusColor': Colors.red
      },
      {
        'id': 'INV-2024-003',
        'customer': 'خالد إبراهيم',
        'amount': 300,
        'date': '2024-01-13',
        'status': 'معلقة',
        'statusColor': Colors.orange
      },
    ];

    // تحميل المدفوعات المعلقة
    _pendingPayments = [
      {
        'id': 'PAY-001',
        'customer': 'شركة الأمل',
        'amount': 1200,
        'dueDate': '2024-01-20',
        'daysLate': 5
      },
      {
        'id': 'PAY-002',
        'customer': 'مؤسسة النهضة',
        'amount': 800,
        'dueDate': '2024-01-18',
        'daysLate': 3
      },
    ];

    // تحميل التنبيهات
    _alerts = [
      {
        'type': 'متأخرة',
        'count': 3,
        'message': 'فواتير متأخرة عن السداد',
        'color': Colors.red
      },
      {
        'type': 'معلقة',
        'count': 5,
        'message': 'مدفوعات قيد المراجعة',
        'color': Colors.orange
      },
      {
        'type': 'جديدة',
        'count': 12,
        'message': 'فواتير جديدة هذا الأسبوع',
        'color': Colors.blue
      },
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('موظف الفواتير - قسم النفايات'),
        backgroundColor: const Color.fromARGB(255, 17, 126, 117),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showAlertsScreen(context),
            tooltip: 'التنبيهات',
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _showProfileScreen(),
            tooltip: 'الملف الشخصي',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الترحيب والإحصائيات السريعة
            ScaleTransition(
              scale: _scaleAnimation,
              child: _buildWelcomeCard(),
            ),
            const SizedBox(height: 20),

            // الإجراءات السريعة
            _buildQuickActionsSection(),
            const SizedBox(height: 20),

            // الميزات الرئيسية
            _buildMainFeaturesSection(),
          ],
        ),
      ),
    );
  }

  // بطاقة الترحيب والإحصائيات
  Widget _buildWelcomeCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 17, 126, 117).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 17, 126, 117),
                        const Color.fromARGB(255, 12, 89, 83),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 17, 126, 117).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.person, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'مرحباً بك',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'موظف الفواتير - النفايات',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'نشط',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // إحصائيات سريعة
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimatedStatItem(Icons.receipt, 'الفواتير', _billingData['monthlyInvoices'].toString(), Colors.blue, 0),
                  SizedBox(width: 15),
                  _buildAnimatedStatItem(Icons.payment, 'المدفوع', _billingData['paidInvoices'].toString(), Colors.green, 100),
                  SizedBox(width: 15),
                  _buildAnimatedStatItem(Icons.pending, 'المتأخر', _billingData['pendingPayments'].toString(), Colors.orange, 200),
                  SizedBox(width: 15),
                  _buildAnimatedStatItem(Icons.attach_money, 'الإيرادات', '${(_billingData['totalRevenue'] / 1000).toStringAsFixed(0)}K', Colors.purple, 300),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedStatItem(IconData icon, String title, String value, Color color, int delay) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutBack,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // قسم الإجراءات السريعة
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 15, right: 8),
          child: Text(
            'الإجراءات السريعة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 17, 126, 117),
            ),
          ),
        ),
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _quickActions.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: index == _quickActions.length - 1 ? 0 : 12),
                child: _buildAnimatedQuickActionItem(_quickActions[index], index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedQuickActionItem(Map<String, dynamic> action, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutBack,
      child: GestureDetector(
        onTap: () => _handleQuickAction(action),
        child: Container(
          width: 80,
          margin: EdgeInsets.only(right: 8),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      action['color'].withOpacity(0.8),
                      action['color'],
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: action['color'].withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  action['icon'],
                  size: 22,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                action['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // قسم الميزات الرئيسية
  Widget _buildMainFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 15, right: 8),
          child: Text(
            'الميزات الرئيسية',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 17, 126, 117),
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: _mainFeatures.length,
          itemBuilder: (context, index) {
            return _buildAnimatedFeatureItem(_mainFeatures[index], index);
          },
        ),
      ],
    );
  }

  Widget _buildAnimatedFeatureItem(Map<String, dynamic> feature, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500 + (index * 100)),
      curve: Curves.easeOutBack,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToFeature(feature['screen']),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  feature['color'].withOpacity(0.05),
                  feature['color'].withOpacity(0.1),
                ],
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: feature['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: feature['color'].withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    feature['icon'],
                    size: 20,
                    color: feature['color'],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  feature['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دوال التنقل والمعالجة
  void _handleQuickAction(Map<String, dynamic> action) {
    switch (action['title']) {
      case 'بحث فاتورة':
        _searchInvoices();
        break;
      case 'تصدير تقرير':
        _exportReport();
        break;
      case 'إرسال تنبيه':
        _sendAlert();
        break;
      case 'تحديث البيانات':
        _refreshData();
        break;
    }
  }

  void _navigateToFeature(String screen) {
    switch (screen) {
      case 'invoices':
        _showInvoicesManagementScreen();
        break;
      case 'payments':
        _showPaymentsScreen();
        break;
      case 'accounts':
        _showAccountsScreen();
        break;
      case 'reports':
        _showReportsScreen();
        break;
      case 'alerts':
        _showAlertsScreen(context);
        break;
      case 'settings':
        _showSettingsScreen();
        break;
    }
  }

  void _showInvoicesManagementScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('إدارة الفواتير'),
            backgroundColor: Colors.blue,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('الفواتير الحديثة'),
                Expanded(
                  child: ListView.builder(
                    itemCount: _recentInvoices.length,
                    itemBuilder: (context, index) {
                      final invoice = _recentInvoices[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(Icons.receipt, color: invoice['statusColor']),
                          title: Text(invoice['id']),
                          subtitle: Text('${invoice['customer']} - ${invoice['amount']} ر.س'),
                          trailing: Chip(
                            label: Text(
                              invoice['status'],
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: invoice['statusColor'],
                          ),
                          onTap: () => _showInvoiceDetails(invoice),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _createNewInvoice,
                  icon: Icon(Icons.add),
                  label: Text('إنشاء فاتورة جديدة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('إدارة المدفوعات'),
            backgroundColor: Colors.green,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('المدفوعات المعلقة'),
                Expanded(
                  child: ListView.builder(
                    itemCount: _pendingPayments.length,
                    itemBuilder: (context, index) {
                      final payment = _pendingPayments[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(Icons.payment, color: Colors.orange),
                          title: Text(payment['id']),
                          subtitle: Text('${payment['customer']} - ${payment['amount']} ر.س'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('متأخر ${payment['daysLate']} أيام'),
                              Text('استحق: ${payment['dueDate']}'),
                            ],
                          ),
                          onTap: () => _processPayment(payment),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _recordPayment,
                        icon: Icon(Icons.payment),
                        label: Text('تسجيل مدفوعات'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _generatePaymentReport,
                        icon: Icon(Icons.analytics),
                        label: Text('تقرير المدفوعات'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAccountsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('إدارة الحسابات'),
            backgroundColor: Colors.purple,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('ملخص الحسابات'),
                _buildAccountSummary(),
                SizedBox(height: 20),
                _buildSectionHeader('العملاء'),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.group, color: Colors.purple),
                        title: Text('إجمالي العملاء'),
                        trailing: Text('150', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ListTile(
                        leading: Icon(Icons.trending_up, color: Colors.green),
                        title: Text('عملاء نشطين'),
                        trailing: Text('125', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ListTile(
                        leading: Icon(Icons.trending_down, color: Colors.red),
                        title: Text('عملاء متأخرين'),
                        trailing: Text('25', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReportsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('التقارير المالية'),
            backgroundColor: Colors.orange,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('التقارير المتاحة'),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildReportCard(
                        'تقرير الفواتير',
                        Icons.receipt,
                        Colors.blue,
                        _generateInvoiceReport,
                        stats: {
                          'الفواتير الشهرية': '150',
                          'المدفوعة': '125',
                          'المعلقة': '25',
                          'نسبة التحصيل': '83%'
                        }
                      ),
                      _buildReportCard(
                        'تقرير المدفوعات',
                        Icons.payment,
                        Colors.green,
                        _generatePaymentReport,
                        stats: {
                          'إجمالي المدفوعات': '75,000 ر.س',
                          'المستحقة': '12,500 ر.س',
                          'المتأخرة': '2,300 ر.س',
                          'نسبة السداد': '86%'
                        }
                      ),
                      _buildReportCard(
                        'تقرير الإيرادات',
                        Icons.attach_money,
                        Colors.purple,
                        _generateRevenueReport,
                        stats: {
                          'الإيراد الشهري': '75,000 ر.س',
                          'الإيراد السنوي': '900,000 ر.س',
                          'نمو الإيرادات': '+15%',
                          'متوسط الفاتورة': '500 ر.س'
                        }
                      ),
                      _buildReportCard(
                        'تقرير العملاء',
                        Icons.people,
                        Colors.orange,
                        _generateCustomerReport,
                        stats: {
                          'إجمالي العملاء': '150',
                          'النشطون': '125',
                          'المتأخرون': '25',
                          'رضا العملاء': '94%'
                        }
                      ),
                      _buildReportCard(
                        'تقرير التحصيل',
                        Icons.trending_up,
                        Colors.teal,
                        _generateCollectionReport,
                        stats: {
                          'معدل التحصيل': '92%',
                          'أيام التحصيل': '45 يوم',
                          'المتحصل فعلياً': '69,000 ر.س',
                          'المستهدف': '75,000 ر.س'
                        }
                      ),
                      _buildReportCard(
                        'تقرير الأداء',
                        Icons.analytics,
                        Colors.indigo,
                        _generatePerformanceReport,
                        stats: {
                          'كفاءة التحصيل': '88%',
                          'الفواتير المغلقة': '142',
                          'معدل الإنجاز': '95%',
                          'التقييم الشهري': 'A+'
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(String title, IconData icon, Color color, Function onTap, {Map<String, String>? stats}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => onTap(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.3), width: 2),
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (stats != null) ...[
                const SizedBox(height: 8),
                ...stats.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('الإعدادات'),
            backgroundColor: Colors.grey,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildSettingsItem('المعلومات الشخصية', Icons.person, _editProfile),
                _buildSettingsItem('إعدادات الفواتير', Icons.receipt, _editInvoiceSettings),
                _buildSettingsItem('إعدادات الإشعارات', Icons.notifications, _editNotificationSettings),
                _buildSettingsItem('الأمان', Icons.security, _editSecuritySettings),
                _buildSettingsItem('التطبيق', Icons.apps, _editAppSettings),
                _buildSettingsItem('المساعدة والدعم', Icons.help, _showHelp),
                _buildSettingsItem('تسجيل الخروج', Icons.logout, _logout, isLogout: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAlertsScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.notifications_active, color: Colors.red),
            SizedBox(width: 10),
            Text('التنبيهات العاجلة'),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _alerts.length,
            itemBuilder: (context, index) {
              final alert = _alerts[index];
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: alert['color'].withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.warning, color: alert['color']),
                ),
                title: Text('${alert['count']} ${alert['type']}'),
                subtitle: Text(alert['message']),
                trailing: Chip(
                  label: Text(alert['count'].toString()),
                  backgroundColor: alert['color'],
                  labelStyle: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: _markAlertsAsRead,
            child: const Text('تجاهل الكل'),
          ),
        ],
      ),
    );
  }

  void _showProfileScreen() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الملف الشخصي'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Color.fromARGB(255, 17, 126, 117),
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text('موظف الفواتير - قسم النفايات', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('البريد الإلكتروني: billing.officer@waste.gov'),
            SizedBox(height: 8),
            Text('رقم الهاتف: 0550123456'),
            SizedBox(height: 8),
            Text('القسم: إدارة الفواتير'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          TextButton(
            onPressed: _editProfile,
            child: Text('تعديل'),
          ),
        ],
      ),
    );
  }

  // دوال مساعدة للواجهات
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildAccountSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الإيرادات الشهرية:'),
                Text('${_billingData['totalRevenue']} ر.س', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الرصيد المستحق:'),
                Text('${_billingData['outstandingBalance']} ر.س', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, Function onTap, {bool isLogout = false}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.grey[700]),
        title: Text(title, style: TextStyle(color: isLogout ? Colors.red : null)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => onTap(),
      ),
    );
  }

  // دوال التنفيذ الحقيقية
  void _searchInvoices() {
    showSearch(
      context: context,
      delegate: _InvoiceSearchDelegate(_recentInvoices),
    );
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تصدير التقرير...'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    // محاكاة عملية التصدير
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تصدير التقرير بنجاح'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _sendAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إرسال تنبيه'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'عنوان التنبيه'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'رسالة التنبيه'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إرسال التنبيه بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('إرسال'),
          ),
        ],
      ),
    );
  }

  void _refreshData() {
    setState(() {
      _billingData['monthlyInvoices'] += 5;
      _billingData['paidInvoices'] += 3;
      _billingData['pendingPayments'] += 2;
      _billingData['totalRevenue'] += 2500;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحديث البيانات...'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحديث البيانات بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _showInvoiceDetails(Map<String, dynamic> invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الفاتورة: ${invoice['id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('العميل: ${invoice['customer']}'),
            Text('المبلغ: ${invoice['amount']} ر.س'),
            Text('التاريخ: ${invoice['date']}'),
            Text('الحالة: ${invoice['status']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _editInvoice(invoice);
            },
            child: Text('تعديل'),
          ),
        ],
      ),
    );
  }

  void _createNewInvoice() {
    // تنفيذ إنشاء فاتورة جديدة
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('فتح نموذج إنشاء فاتورة جديدة'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _processPayment(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('معالجة الدفع: ${payment['id']}'),
        content: Text('هل تريد معالجة الدفع للمبلغ ${payment['amount']} ر.س؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم معالجة الدفع بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('تأكيد المعالجة'),
          ),
        ],
      ),
    );
  }

  void _recordPayment() {
    // تنفيذ تسجيل مدفوعات
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('فتح نموذج تسجيل المدفوعات'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _generateInvoiceReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.receipt, color: Colors.blue),
            SizedBox(width: 10),
            Text('تقرير الفواتير'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildReportDetailItem('إجمالي الفواتير', '150', Colors.blue),
              _buildReportDetailItem('الفواتير المدفوعة', '125', Colors.green),
              _buildReportDetailItem('الفواتير المعلقة', '25', Colors.orange),
              _buildReportDetailItem('نسبة التحصيل', '83%', Colors.teal),
              _buildReportDetailItem('متوسط قيمة الفاتورة', '500 ر.س', Colors.purple),
              _buildReportDetailItem('فواتير متأخرة', '3', Colors.red),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _exportReport();
            },
            child: Text('تصدير التقرير'),
          ),
        ],
      ),
    );
  }

  void _generatePaymentReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.payment, color: Colors.green),
            SizedBox(width: 10),
            Text('تقرير المدفوعات'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildReportDetailItem('إجمالي المدفوعات', '75,000 ر.س', Colors.green),
              _buildReportDetailItem('المبالغ المستحقة', '12,500 ر.س', Colors.orange),
              _buildReportDetailItem('المتأخرات', '2,300 ر.س', Colors.red),
              _buildReportDetailItem('نسبة السداد', '86%', Colors.teal),
              _buildReportDetailItem('مدفوعات هذا الشهر', '25,000 ر.س', Colors.blue),
              _buildReportDetailItem('المستهدف', '30,000 ر.س', Colors.purple),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _exportReport();
            },
            child: Text('تصدير التقرير'),
          ),
        ],
      ),
    );
  }

  void _generateRevenueReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.attach_money, color: Colors.purple),
            SizedBox(width: 10),
            Text('تقرير الإيرادات'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildReportDetailItem('الإيراد الشهري', '75,000 ر.س', Colors.purple),
              _buildReportDetailItem('الإيراد السنوي', '900,000 ر.س', Colors.deepPurple),
              _buildReportDetailItem('نمو الإيرادات', '+15%', Colors.green),
              _buildReportDetailItem('متوسط الفاتورة', '500 ر.س', Colors.blue),
              _buildReportDetailItem('أعلى إيراد', '85,000 ر.س', Colors.orange),
              _buildReportDetailItem('أقل إيراد', '65,000 ر.س', Colors.red),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _exportReport();
            },
            child: Text('تصدير التقرير'),
          ),
        ],
      ),
    );
  }

  void _generateCustomerReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.people, color: Colors.orange),
            SizedBox(width: 10),
            Text('تقرير العملاء'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildReportDetailItem('إجمالي العملاء', '150', Colors.orange),
              _buildReportDetailItem('العملاء النشطون', '125', Colors.green),
              _buildReportDetailItem('العملاء المتأخرون', '25', Colors.red),
              _buildReportDetailItem('رضا العملاء', '94%', Colors.teal),
              _buildReportDetailItem('عملاء جدد', '15', Colors.blue),
              _buildReportDetailItem('معدل الاحتفاظ', '92%', Colors.purple),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _exportReport();
            },
            child: Text('تصدير التقرير'),
          ),
        ],
      ),
    );
  }

  void _generateCollectionReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.trending_up, color: Colors.teal),
            SizedBox(width: 10),
            Text('تقرير التحصيل'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildReportDetailItem('معدل التحصيل الحالي', '92%', Colors.teal),
              _buildReportDetailItem('إجمالي المبلغ المتحصل', '69,000 ر.س', Colors.green),
              _buildReportDetailItem('المبلغ المستحق', '12,500 ر.س', Colors.orange),
              _buildReportDetailItem('أيام التحصيل المتوسطة', '45 يوم', Colors.blue),
              _buildReportDetailItem('المستهدف الشهري', '75,000 ر.س', Colors.purple),
              _buildReportDetailItem('نسبة تحقيق الهدف', '92%', Colors.teal),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _exportReport();
            },
            child: Text('تصدير التقرير'),
          ),
        ],
      ),
    );
  }

  void _generatePerformanceReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.analytics, color: Colors.indigo),
            SizedBox(width: 10),
            Text('تقرير الأداء'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildReportDetailItem('كفاءة التحصيل', '88%', Colors.indigo),
              _buildReportDetailItem('الفواتير المغلقة', '142/150', Colors.green),
              _buildReportDetailItem('معدل الإنجاز', '95%', Colors.blue),
              _buildReportDetailItem('التقييم الشهري', 'A+', Colors.purple),
              _buildReportDetailItem('أداء الفريق', 'متميز', Colors.teal),
              _buildReportDetailItem('التوصيات', '2 تحسين', Colors.orange),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _exportReport();
            },
            child: Text('تصدير التقرير'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportDetailItem(String title, String value, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // دوال الإعدادات المفصلة
  void _editProfile() {
    _showDetailedSettingsScreen(0);
  }

  void _editInvoiceSettings() {
    _showDetailedSettingsScreen(1);
  }

  void _editNotificationSettings() {
    _showDetailedSettingsScreen(2);
  }

  void _editSecuritySettings() {
    _showDetailedSettingsScreen(3);
  }

  void _editAppSettings() {
    _showDetailedSettingsScreen(4);
  }

  void _showHelp() {
    _showDetailedSettingsScreen(5);
  }

  // دالة تسجيل الخروج المحدثة
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 10),
            Text('تسجيل الخروج'),
          ],
        ),
        content: Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق dialog التأكيد
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  // دالة تنفيذ تسجيل الخروج
  void _performLogout() {
    // إظهار رسالة تأكيد
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تسجيل الخروج...'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // محاكاة عملية تسجيل الخروج
    Future.delayed(Duration(seconds: 2), () {
      // في التطبيق الحقيقي، هنا سيتم:
      // 1. مسح بيانات الجلسة
      // 2. إغلاق الاتصالات
      // 3. الانتقال لشاشة تسجيل الدخول
      
      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تسجيل الخروج بنجاح'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      // محاكاة الانتقال لشاشة تسجيل الدخول
      Future.delayed(Duration(seconds: 1), () {
        // في التطبيق الحقيقي، استخدم Navigator.pushReplacement للانتقال لشاشة Login
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        
        // لأغراض العرض، سنظهر رسالة فقط
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('تم تسجيل الخروج'),
            content: Text('تم تسجيل الخروج بنجاح. يمكنك الآن إغلاق التطبيق أو تسجيل الدخول مرة أخرى.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // في التطبيق الحقيقي، أضف إعادة التوجيه لشاشة Login هنا
                },
                child: Text('موافق'),
              ),
            ],
          ),
        );
      });
    });
  }

  void _editInvoice(Map<String, dynamic> invoice) => _showNotImplemented('تعديل الفاتورة');
  void _markAlertsAsRead() => _showNotImplemented('تجاهل التنبيهات');

  void _showDetailedSettingsScreen(int index) {
    final setting = _settingsData[index];
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(setting['title']),
            backgroundColor: Colors.grey,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // رأس القسم
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(setting['icon'], size: 40, color: Colors.grey[700]),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                setting['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                setting['description'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
                
                // قائمة الإعدادات
                Expanded(
                  child: ListView.builder(
                    itemCount: setting['settings'].length,
                    itemBuilder: (context, index) {
                      final item = setting['settings'][index];
                      return _buildSettingItem(item, setting['title']);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(Map<String, dynamic> item, String category) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          item['name'],
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: item['type'] == 'switch' ? null : Text(
          item['value'],
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        trailing: _buildSettingTrailing(item),
        onTap: () => _handleSettingTap(item, category),
      ),
    );
  }

  Widget _buildSettingTrailing(Map<String, dynamic> item) {
    switch (item['type']) {
      case 'switch':
        return Switch(
          value: item['value'] == 'مفعل' || item['value'] == 'مفعلة',
          onChanged: item['editable'] ? (value) {
            _handleSettingChange(item, value ? 'مفعل' : 'معطل');
          } : null,
          activeColor: Color.fromARGB(255, 17, 126, 117),
        );
      case 'select':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item['value'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, color: Colors.grey[500]),
          ],
        );
      case 'button':
        return ElevatedButton(
          onPressed: () => _handleSettingButton(item),
          child: Text(
            item['value'],
            style: TextStyle(fontSize: 12),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 17, 126, 117),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
        );
      default:
        return Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[500],
        );
    }
  }

  void _handleSettingTap(Map<String, dynamic> item, String category) {
    if (!item['editable']) {
      _showNotImplemented('${item['name']} في $category');
      return;
    }

    switch (item['type']) {
      case 'text':
      case 'email':
      case 'phone':
      case 'number':
        _showEditDialog(item, category);
        break;
      case 'select':
        _showSelectDialog(item, category);
        break;
      case 'password':
        _showPasswordDialog(item, category);
        break;
      case 'button':
        _handleSettingButton(item);
        break;
    }
  }

  void _handleSettingChange(Map<String, dynamic> item, String newValue) {
    // في التطبيق الحقيقي، هنا سيتم تحديث القيمة في قاعدة البيانات
    setState(() {
      item['value'] = newValue;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحديث ${item['name']} بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleSettingButton(Map<String, dynamic> item) {
    switch (item['name']) {
      case 'نشاط تسجيل الدخول':
        _showLoginActivity();
        break;
      case 'الشروط والأحكام':
        _showTermsAndConditions();
        break;
      case 'سياسة الخصوصية':
        _showPrivacyPolicy();
        break;
      case 'تقييم التطبيق':
        _rateApp();
        break;
      case 'المركز المساعدة':
        _showHelpCenter();
        break;
      case 'مسح الذاكرة المؤقتة':
        _clearCache();
        break;
      default:
        _showNotImplemented(item['name']);
    }
  }

  void _showEditDialog(Map<String, dynamic> item, String category) {
    TextEditingController controller = TextEditingController(text: item['value']);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعديل ${item['name']}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: item['name'],
            border: OutlineInputBorder(),
          ),
          keyboardType: _getKeyboardType(item['type']),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _handleSettingChange(item, controller.text);
                Navigator.pop(context);
              }
            },
            child: Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showSelectDialog(Map<String, dynamic> item, String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اختيار ${item['name']}'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: item['options'].length,
            itemBuilder: (context, index) {
              final option = item['options'][index];
              return ListTile(
                title: Text(option),
                trailing: option == item['value'] ? Icon(Icons.check, color: Color.fromARGB(255, 17, 126, 117)) : null,
                onTap: () {
                  _handleSettingChange(item, option);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showPasswordDialog(Map<String, dynamic> item, String category) {
    TextEditingController currentController = TextEditingController();
    TextEditingController newController = TextEditingController();
    TextEditingController confirmController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تغيير كلمة المرور'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              decoration: InputDecoration(
                labelText: 'كلمة المرور الحالية',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: newController,
              decoration: InputDecoration(
                labelText: 'كلمة المرور الجديدة',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                labelText: 'تأكيد كلمة المرور الجديدة',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newController.text == confirmController.text && newController.text.isNotEmpty) {
                _handleSettingChange(item, '********');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم تغيير كلمة المرور بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('كلمات المرور غير متطابقة'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('تغيير'),
          ),
        ],
      ),
    );
  }

  TextInputType _getKeyboardType(String type) {
    switch (type) {
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      case 'number':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  void _showLoginActivity() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('نشاط تسجيل الدخول'),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActivityItem('الجهاز الحالي', '2024-01-15 08:30', 'نشط'),
              _buildActivityItem('جهاز Windows', '2024-01-14 15:20', 'مغلق'),
              _buildActivityItem('جهاز Android', '2024-01-13 10:15', 'مغلق'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String device, String date, String status) {
    return ListTile(
      leading: Icon(Icons.computer, color: Colors.grey[600]),
      title: Text(device),
      subtitle: Text(date),
      trailing: Chip(
        label: Text(
          status,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
        backgroundColor: status == 'نشط' ? Colors.green : Colors.grey,
      ),
    );
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الشروط والأحكام'),
        content: SingleChildScrollView(
          child: Text(
            'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق.\n\nإذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما ولا يحوي أخطاء لغوية، مولد النص العربى مفيد لمصممي المواقع على وجه الخصوص.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('سياسة الخصوصية'),
        content: SingleChildScrollView(
          child: Text(
            'نحن نحرص على خصوصيتك ونلتزم بحماية بياناتك الشخصية. هذه السياسة توضح كيف نتعامل مع معلوماتك:\n\n• نحن نجمع المعلومات اللازمة لتقديم الخدمة\n• لا نشارك معلوماتك مع أطراف ثالثة بدون موافقتك\n• نستخدم أحدث تقنيات التشفير لحماية بياناتك\n• يمكنك طلب حذف بياناتك في أي وقت\n\nللمزيد من المعلومات، يرجى التواصل مع فريق الدعم.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تقييم التطبيق'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('كيف تقيم تجربتك مع التطبيق؟'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [1,2,3,4,5].map((star) => 
                IconButton(
                  icon: Icon(Icons.star, color: Colors.amber),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('شكراً لتقييمك!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                )
              ).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('لاحقاً'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('المركز المساعدة'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildHelpItem('كيفية إنشاء فاتورة جديدة', Icons.receipt),
                _buildHelpItem('طريقة تسجيل المدفوعات', Icons.payment),
                _buildHelpItem('حل مشاكل النظام', Icons.build),
                _buildHelpItem('الأسئلة الشائعة', Icons.help_outline),
                _buildHelpItem('الاتصال بالدعم الفني', Icons.support_agent),
                _buildHelpItem('مقاطع فيديو تعليمية', Icons.video_library),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem(String title, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Color.fromARGB(255, 17, 126, 117)),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showHelpDetail(title),
      ),
    );
  }

  void _showHelpDetail(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(
          'هذا نموذج للمساعدة حول $title. في التطبيق الحقيقي، سيكون هنا شرح مفصل وخطوات عملية.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('مسح الذاكرة المؤقتة'),
        content: Text('هل أنت متأكد من رغبتك في مسح الذاكرة المؤقتة؟ هذا الإجراء لا يمكن التراجع عنه.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم مسح الذاكرة المؤقتة بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('تأكيد المسح'),
          ),
        ],
      ),
    );
  }

  void _showNotImplemented(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - هذه الميزة قيد التطوير'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class _InvoiceSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> invoices;

  _InvoiceSearchDelegate(this.invoices);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = invoices.where((invoice) =>
        invoice['id'].toLowerCase().contains(query.toLowerCase()) ||
        invoice['customer'].toLowerCase().contains(query.toLowerCase()));
    
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final invoice = results.elementAt(index);
        return ListTile(
          title: Text(invoice['id']),
          subtitle: Text('${invoice['customer']} - ${invoice['amount']} ر.س'),
          trailing: Chip(
            label: Text(invoice['status'], style: TextStyle(color: Colors.white)),
            backgroundColor: invoice['statusColor'],
          ),
          onTap: () {
            close(context, invoice);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? invoices
        : invoices.where((invoice) =>
            invoice['id'].toLowerCase().contains(query.toLowerCase()) ||
            invoice['customer'].toLowerCase().contains(query.toLowerCase()));

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final invoice = suggestions.elementAt(index);
        return ListTile(
          leading: Icon(Icons.receipt),
          title: Text(invoice['id']),
          subtitle: Text(invoice['customer']),
          onTap: () {
            query = invoice['id'];
            showResults(context);
          },
        );
      },
    );
  }
}
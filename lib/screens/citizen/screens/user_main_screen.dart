import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/service_details_screen.dart';
import '../services/payment_screen.dart';
import '../services/points_and_gifts_screen.dart';
import '../services/waste_schedule_screen.dart';
import '../services/container_request_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import '../auth/signin_screen.dart';

class UserMainScreen extends StatefulWidget {
  static const String screenRoot = 'user_main';

  const UserMainScreen({super.key});

  @override
  _UserMainScreenState createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  bool _showSuccessMessage = false;
  String _successMessage = '';
  bool _showExitDialog = false;

  // معلومات المستخدم الافتراضية
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  bool _isAccountApproved = false;

  // الألوان الجديدة للتصميم الرسمي الحكومي
  final Color _primaryColor = const Color(0xFF0D47A1); // أزبل حكومي داكن
  final Color _secondaryColor = const Color(0xFF1976D2); // أزرق حكومي
  final Color _accentColor = const Color(0xFF64B5F6); // أزرق فاتح
  final Color _backgroundColor = const Color(0xFFF8F9FA); // خلفية رمادية فاتحة
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _borderColor = const Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    _checkUserStatus();

    _tabController = TabController(length: _services.length, vsync: this);
    _tabController.addListener(_handleTabSelection);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args['showSuccessMessage'] == true) {
        setState(() {
          _showSuccessMessage = true;
          _successMessage = args['message'] ?? 'تم إنشاء الحساب بنجاح';
        });

        // إخفاء الرسالة تلقائياً بعد 5 ثواني
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              _showSuccessMessage = false;
            });
          }
        });
      }
    });
  }

  Future<void> _checkUserStatus() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        // إذا لم يكن المستخدم مسجلاً دخولاً، ارجع إلى شاشة تسجيل الدخول
        Navigator.pushNamedAndRemoveUntil(
          context,
          SigninScreen.screenroot,
          (route) => false,
        );
        return;
      }

      // جلب بيانات المستخدم من جدول profiles
      final userData = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      // في دالة _checkUserStatus()
      setState(() {
        _userProfile = userData;
        _isAccountApproved = true; // جعل جميع الحسابات معتمدة تلقائياً
        _isLoading = false;
      });
    } catch (e) {
      print('Error checking user status: $e');
      // إذا حدث خطأ، ارجع إلى شاشة تسجيل الدخول
      Navigator.pushNamedAndRemoveUntil(
        context,
        SigninScreen.screenroot,
        (route) => false,
      );
    }
  }

  // دالة تسجيل الخروج
  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context,
        SigninScreen.screenroot,
        (route) => false,
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<bool> _onWillPop() async {
    if (_showExitDialog) return true;

    setState(() {
      _showExitDialog = true;
    });

    // عرض رسالة التأكيد
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الخروج'),
        content: const Text('هل تريد الخروج من التطبيق؟'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              setState(() {
                _showExitDialog = false;
              });
            },
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('خروج'),
          ),
        ],
      ),
    );

    setState(() {
      _showExitDialog = false;
    });

    return result ?? false;
  }

  final Map<String, IconData> _customIcons = {
    'electricity': Icons.bolt,
    'water': Icons.water_drop,
    'waste': Icons.delete,
    'payment': Icons.payment,
    'emergency': Icons.emergency,
    'consumption': Icons.show_chart,
    'problem': Icons.report_problem,
    'tax': Icons.receipt,
    'offers': Icons.card_giftcard,
    'premium': Icons.star,
    'container': Icons.add_circle,
    'schedule': Icons.calendar_today,
    'profile': Icons.person,
  };

  final List<Map<String, dynamic>> _services = [
    {
      'title': 'الكهرباء',
      'icon': 'electricity',
      'color': const Color(0xFF0D47A1),
      'gradient': [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
      'services': [
        {
          'name': 'دفع الفاتورة',
          'icon': 'payment',
          'premium': false,
          'hasEarlyPaymentDiscount': true,
        },
        {'name': 'أمر طارئ', 'icon': 'emergency', 'premium': false},
        {'name': 'الاستهلاك الشهري', 'icon': 'consumption', 'premium': false},
        {'name': 'الإبلاغ عن مشكلة', 'icon': 'problem', 'premium': false},
        {'name': 'ضريبة التأخير', 'icon': 'tax', 'premium': false},
        {'name': 'الهدايا والعروض', 'icon': 'offers', 'premium': false},
        {'name': 'خدمات مميزة', 'icon': 'premium', 'premium': true},
      ],
    },
    {
      'title': 'الماء',
      'icon': 'water',
      'color': const Color(0xFF00B4D8), // تغيير إلى اللون السمائي
      'gradient': [
        const Color(0xFF00B4D8),
        const Color(0xFF90E0EF),
      ], // تغيير التدرج اللوني
      'services': [
        {
          'name': 'دفع الفاتورة',
          'icon': 'payment',
          'premium': false,
          'hasEarlyPaymentDiscount': true,
        },
        {'name': 'أمر طارئ', 'icon': 'emergency', 'premium': false},
        {'name': 'الاستهلاك الشهري', 'icon': 'consumption', 'premium': false},
        {'name': 'الإبلاغ عن مشكلة', 'icon': 'problem', 'premium': false},
        {'name': 'ضريبة التأخير', 'icon': 'tax', 'premium': false},
        {'name': 'الهدايا والعروض', 'icon': 'offers', 'premium': false},
        {'name': 'خدمات مميزة', 'icon': 'premium', 'premium': true},
      ],
    },
    {
      'title': 'النفايات',
      'icon': 'waste',
      'color': const Color(0xFF4CAF50), // تغيير إلى اللون الأخضر المعروف
      'gradient': [
        const Color(0xFF4CAF50),
        const Color(0xFF8BC34A),
      ], // تغيير التدرج اللوني
      'services': [
        {
          'name': 'دفع الرسوم',
          'icon': 'payment',
          'premium': false,
          'hasEarlyPaymentDiscount': true,
        },
        {
          'name': 'طلب حاوية جديدة',
          'icon': 'container',
          'premium': false,
          'isFirstContainerFree': true,
        },
        {'name': 'جدول النظافة', 'icon': 'schedule', 'premium': false},
        {'name': 'الإبلاغ عن مشكلة', 'icon': 'problem', 'premium': false},
        {'name': 'ضريبة التأخير', 'icon': 'tax', 'premium': false},
        {'name': 'الهدايا والعروض', 'icon': 'offers', 'premium': false},
        {'name': 'خدمات مميزة', 'icon': 'premium', 'premium': true},
      ],
    },
  ];

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'فاتورة جديدة',
      'message': 'لديك فاتورة كهرباء جديدة بقيمة 25000 دينار',
      'color': const Color(0xFF0D47A1),
      'icon': Icons.receipt,
      'read': false,
      'date': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'title': 'خصم الدفع المبكر',
      'message': 'احصل على خصم 10% عند الدفع قبل 15/10/2023',
      'color': const Color(0xFF2E7D32),
      'icon': Icons.discount,
      'read': false,
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildDailyConsumptionCard(
    Color color,
    List<Color> gradient,
    String title,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _customIcons['consumption']!,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'الاستهلاك اليومي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title == 'الماء' ? '250 لتر' : '25 كيلوواط/ساعة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'اليوم: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                        style: TextStyle(
                          fontSize: 12,
                          color: _textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 0.65,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          strokeWidth: 5,
                        ),
                        Text(
                          '65%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: 0.65,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),
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

    // إذا كان الحساب معتمداً، عرض الواجهة الكاملة
    final currentService = _services[_currentIndex];
    final serviceColor = currentService['color'] as Color;
    final serviceGradient = currentService['gradient'] as List<Color>;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: _primaryColor,
          elevation: 0,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _customIcons[currentService['icon']],
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                currentService['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          leading: _buildProfileButton(serviceColor),
          actions: [_buildNotificationButton()],
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
                controller: _tabController,
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 3, color: serviceColor),
                  ),
                ),
                labelColor: serviceColor,
                unselectedLabelColor: _textSecondaryColor,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 14),
                tabs: _services.map((service) {
                  return Tab(text: service['title']);
                }).toList(),
              ),
            ),
          ),
        ),

        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: _services.map((service) {
                final serviceColor = service['color'] as Color;
                final serviceGradient = service['gradient'] as List<Color>;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (service['title'] != 'النفايات')
                        _buildDailyConsumptionCard(
                          serviceColor,
                          serviceGradient,
                          service['title'],
                        ),
                      _buildServiceList(
                        service['services'],
                        serviceColor,
                        serviceGradient,
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              }).toList(),
            ),

            // رسالة النجاح
            if (_showSuccessMessage)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: _successColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _successMessage,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Tajawal',
                                fontSize: 14,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _showSuccessMessage = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: _primaryColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onPressed: _showEmergencyDialog,
          child: Icon(
            _customIcons['emergency']!,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // دالة لبناء زر الملف الشخصي
  Widget _buildProfileButton(Color serviceColor) {
    return IconButton(
      icon: Icon(Icons.person, color: Colors.white, size: 24),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              userProfile: _userProfile,
              onSignOut: _signOut,
              primaryColor: _primaryColor,
              textColor: _textColor,
              textSecondaryColor: _textSecondaryColor,
              errorColor: _errorColor,
            ),
          ),
        );
      },
      tooltip: 'الملف الشخصي',
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 24,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsScreen(
                    notifications: _notifications,
                    serviceColor: _services[_currentIndex]['color'] as Color,
                  ),
                ),
              );
            },
            tooltip: 'الإشعارات',
          ),
          if (_notifications.any((n) => !n['read']))
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _errorColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: const Text(
                  '!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceList(
    List<dynamic> services,
    Color color,
    List<Color> gradient,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: services.map((service) {
          return _buildServiceListItem(service, color, gradient);
        }).toList(),
      ),
    );
  }

  Widget _buildServiceListItem(
    Map<String, dynamic> service,
    Color color,
    List<Color> gradient,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _handleServiceTap(service['name']),
        child: Container(
          decoration: BoxDecoration(color: _cardColor),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _customIcons[service['icon']],
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                      if (service['premium']) const SizedBox(height: 4),
                      if (service['premium'])
                        Text(
                          'خدمة مدفوعة',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 226, 155, 0),
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: _textSecondaryColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleServiceTap(String serviceName) {
    final currentService = _services[_currentIndex];
    final serviceColor = currentService['color'] as Color;
    final serviceGradient = currentService['gradient'] as List<Color>;
    final serviceTitle = currentService['title'];

    if (serviceName.contains('دفع الفاتورة') ||
        serviceName.contains('دفع الرسوم')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            services: [
              ServiceItem(
                id: '1',
                name: serviceName,
                amount: 185.75,
                color: serviceColor,
                gradient: serviceGradient,
                additionalInfo: null, // أو أي معلومات إضافية
              ),
            ],
            primaryColor: serviceColor,
            primaryGradient: serviceGradient,
          ),
        ),
      );
    } else if (serviceName.contains('طلب حاوية جديدة')) {
      _handleContainerRequest(context, currentService);
    } else if (serviceName.contains('الهدايا والعروض')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OffersAndPrizesScreen(serviceColor: serviceColor),
        ),
      );
    } else if (serviceName.contains('جدول النظافة')) {
      _showCleaningSchedule(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceDetailsScreen(
            serviceName: serviceName,
            serviceColor: serviceColor,
            serviceGradient: serviceGradient,
            serviceTitle: serviceTitle,
          ),
        ),
      );
    }
  }

  void _handleContainerRequest(
    BuildContext context,
    Map<String, dynamic> currentService,
  ) {
    final serviceColor = currentService['color'] as Color;
    final isFirstContainerFree =
        (currentService['services'].firstWhere(
                  (s) => s['name'] == 'طلب حاوية جديدة',
                )['isFirstContainerFree'] ??
                false)
            as bool;

    final containerTypes = [
      {
        'type': 'صغيرة (120 لتر)',
        'price': isFirstContainerFree ? 0 : 5000,
        'icon': Icons.delete,
        'color': _successColor,
        'dimensions': '60x60x80 سم',
        'weight': '8 كغ',
        'description': 'مناسبة للاستخدام المنزلي اليومي',
      },
      {
        'type': 'متوسطة (240 لتر)',
        'price': 7500,
        'icon': Icons.delete_outline,
        'color': _primaryColor,
        'dimensions': '70x70x100 سم',
        'weight': '12 كغ',
        'description': 'مناسبة للعائلات الكبيرة',
      },
      {
        'type': 'كبيرة (360 لتر)',
        'price': 10000,
        'icon': Icons.delete_forever,
        'color': _secondaryColor,
        'dimensions': '80x80x120 سم',
        'weight': '15 كغ',
        'description': 'مناسبة للمطاعم والمحلات التجارية',
      },
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContainerRequestScreen(
          containerTypes: containerTypes,
          serviceColor: serviceColor,
          isFirstContainerFree: isFirstContainerFree,
        ),
      ),
    );
  }

  void _showCleaningSchedule(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WasteScheduleScreen(
          serviceColor: _services[_currentIndex]['color'] as Color,
        ),
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.emergency, color: _errorColor),
            const SizedBox(width: 8),
            Text('طلب طارئ'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('هل تريد إرسال طلب طارئ لخدمة الإسعافات الأولية؟'),
            const SizedBox(height: 16),
            Icon(Icons.emergency, size: 60, color: _errorColor),
            const SizedBox(height: 16),
            Text(
              'سيتم إرسال موقعك الحالي تلقائياً',
              style: TextStyle(color: _errorColor),
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
                SnackBar(
                  content: Text('تم إرسال الطلب الطارئ'),
                  backgroundColor: _successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text('تأكيد الإرسال'),
          ),
        ],
      ),
    );
  }
}

class OffersAndPrizesScreen extends StatelessWidget {
  final Color serviceColor;

  const OffersAndPrizesScreen({super.key, required this.serviceColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الهدايا والعروض'),
        backgroundColor: serviceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildOfferCard(
                context: context,
                title: "خصم الدفع المبكر",
                description: "احصل على خصم 10% عند الدفع قبل تاريخ الاستحقاق",
                icon: Icons.attach_money,
                color: Colors.green,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('خصم الدفع المبكر'),
                      content: const Text(
                        'احصل على خصم 10% عند الدفع المبكر للفاتورة قبل تاريخ الاستحقاق',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('حسناً'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildOfferCard(
                context: context,
                title: "السحب على جوائز",
                description: "سحب للمستخدمين الملتزمين بالدفع في الموعد",
                icon: Icons.celebration,
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PrizesRaffleScreen(serviceColor: serviceColor),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildOfferCard(
                context: context,
                title: "النقاط",
                description: "اجمع النقاط مع كل دفعة واستبدلها بهدايا مميزة",
                icon: Icons.card_giftcard,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                                  PointsAndGiftsScreen(serviceColor: serviceColor),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
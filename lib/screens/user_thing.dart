import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'service_details_screen.dart';
import 'payment_screen.dart';
import 'points_and_gifts_screen.dart';
import 'waste_schedule_screen.dart';
import 'container_request_screen.dart';
import 'settings_screen.dart';

class UserThing extends StatefulWidget {
  static const String screenRoot = 'user_thing';

  const UserThing({super.key});

  @override
  _UserThingState createState() => _UserThingState();
}

class _UserThingState extends State<UserThing>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  bool _showSuccessMessage = false;
  String _successMessage = '';
  bool _showExitDialog = false;

  // معلومات المستخدم الافتراضية
  final Map<String, dynamic> _userProfile = {
    'name': 'أحمد محمد',
    'email': 'ahmed@example.com',
    'phone': '+1234567890',
    'address': 'شارع المدينة المنورة، الرياض',
    'points': 1500,
    'subscriptionDate': '2023-01-15',
    'avatar': Icons.person,
  };

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
    'waste': Icons.recycling,
    'payment': Icons.payment,
    'emergency': Icons.emergency,
    'consumption': Icons.show_chart,
    'problem': Icons.report_problem,
    'tax': Icons.money_off,
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
      'color': const Color(0xFF6A1B9A),
      'gradient': [const Color(0xFF9C27B0), const Color(0xFF6A1B9A)],
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
      'color': const Color(0xFF00ACC1),
      'gradient': [const Color(0xFF00BCD4), const Color(0xFF00838F)],
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
      'color': const Color(0xFF43A047),
      'gradient': [const Color(0xFF66BB6A), const Color(0xFF2E7D32)],
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
      'color': Colors.blue,
      'icon': Icons.receipt,
      'read': false,
      'date': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'title': 'خصم الدفع المبكر',
      'message': 'احصل على خصم 10% عند الدفع قبل 15/10/2023',
      'color': Colors.green,
      'icon': Icons.discount,
      'read': false,
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  @override
  void initState() {
    super.initState();
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
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
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
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _customIcons['consumption']!,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'الاستهلاك اليومي',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'اليوم: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 0.65,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 6,
                        ),
                        Text(
                          '65%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
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
    final currentService = _services[_currentIndex];
    final serviceColor = currentService['color'] as Color;
    final serviceGradient = currentService['gradient'] as List<Color>;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: serviceColor,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: serviceGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _customIcons[currentService['icon']],
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                currentService['title'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          leading: _buildProfileButton(serviceColor),
          actions: [_buildNotificationButton()],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 3, color: serviceColor),
                  insets: const EdgeInsets.symmetric(horizontal: 16),
                ),
                labelColor: serviceColor,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 14),
                tabs: _services.map((service) {
                  return Tab(
                    icon: Icon(_customIcons[service['icon']], size: 24),
                    text: service['title'],
                  );
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
                      _buildServiceGrid(
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
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _successMessage,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Tajawal',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
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
          backgroundColor: serviceColor,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withOpacity(0.5), width: 2),
          ),
          onPressed: _showEmergencyDialog,
          child: Icon(
            _customIcons['emergency']!,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // دالة لبناء زر الملف الشخصي
  Widget _buildProfileButton(Color serviceColor) {
    return IconButton(
      icon: Icon(Icons.person, color: Colors.white, size: 28),
      onPressed: _showProfileDialog,
      tooltip: 'الملف الشخصي',
    );
  }

  // دالة لعرض نافذة الملف الشخصي
  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              Text(
                _userProfile['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _userProfile['email'],
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: Colors.grey[300]),
              const SizedBox(height: 16),
              _buildProfileInfoItem(
                Icons.phone,
                'رقم الهاتف',
                _userProfile['phone'],
              ),
              _buildProfileInfoItem(
                Icons.location_on,
                'العنوان',
                _userProfile['address'],
              ),
              _buildProfileInfoItem(
                Icons.star,
                'النقاط',
                '${_userProfile['points']} نقطة',
              ),
              _buildProfileInfoItem(
                Icons.calendar_today,
                'تاريخ الاشتراك',
                _userProfile['subscriptionDate'],
              ),
            ],
          ),
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

  // دالة لبناء عنصر معلومات الملف الشخصي
  Widget _buildProfileInfoItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
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

  Widget _buildNotificationButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 28,
              color: Colors.white,
            ),
            onPressed: _showNotifications,
            tooltip: 'الإشعارات',
          ),
          if (_notifications.any((n) => !n['read']))
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
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

  Widget _buildServiceGrid(
    List<dynamic> services,
    Color color,
    List<Color> gradient,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return _buildServiceCard(services[index], color, gradient);
        },
      ),
    );
  }

  Widget _buildServiceCard(
    Map<String, dynamic> service,
    Color color,
    List<Color> gradient,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _handleServiceTap(service['name']),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, color.withOpacity(0.1)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (service['premium'])
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'مدفوع',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(Icons.star, color: Colors.black, size: 14),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _customIcons[service['icon']],
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    Text(
                      service['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 3,
                      width: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
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
            serviceName: serviceTitle,
            serviceColor: serviceColor,
            serviceGradient: serviceGradient,
            amount: 185.75,
            hasDiscount:
                (currentService['services'].firstWhere(
                          (s) => s['name'] == serviceName,
                        )['hasEarlyPaymentDiscount'] ??
                        false)
                    as bool,
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
        'color': Colors.green,
        'dimensions': '60x60x80 سم',
        'weight': '8 كغ',
        'description': 'مناسبة للاستخدام المنزلي اليومي',
      },
      {
        'type': 'متوسطة (240 لتر)',
        'price': 7500,
        'icon': Icons.delete_outline,
        'color': Colors.blue,
        'dimensions': '70x70x100 سم',
        'weight': '12 كغ',
        'description': 'مناسبة للعائلات الكبيرة',
      },
      {
        'type': 'كبيرة (360 لتر)',
        'price': 10000,
        'icon': Icons.delete_forever,
        'color': Colors.orange,
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

  void _showNotifications() {
    final serviceColor = _services[_currentIndex]['color'] as Color;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الإشعارات',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: serviceColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.grey),
              Expanded(
                child: _notifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا يوجد إشعارات',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8),
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final notification = _notifications[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: (notification['color'] as Color)
                                  .withOpacity(0.1),
                              child: Icon(
                                notification['icon'] as IconData,
                                color: notification['color'] as Color,
                              ),
                            ),
                            title: Text(
                              notification['title'],
                              style: TextStyle(
                                fontWeight: (notification['read'] as bool)
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notification['message']),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'yyyy-MM-dd - hh:mm a',
                                  ).format(notification['date'] as DateTime),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            trailing: !(notification['read'] as bool)
                                ? Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: serviceColor,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : null,
                            onTap: () {
                              setState(() {
                                notification['read'] = true;
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.emergency, color: Colors.red),
            SizedBox(width: 8),
            Text('طلب طارئ'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('هل تريد إرسال طلب طارئ لخدمة الإسعافات الأولية؟'),
            const SizedBox(height: 16),
            const Icon(Icons.emergency, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'سيتم إرسال موقعك الحالي تلقائياً',
              style: TextStyle(color: Colors.red[700]),
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
                  content: Text('تم إرسال الطلب الطارئ'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

class PointsAndGiftsScreen extends StatelessWidget {
  final Color serviceColor;

  const PointsAndGiftsScreen({super.key, required this.serviceColor});
  void _showServiceSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر الخدمة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bolt, color: Colors.purple),
              title: const Text('الكهرباء'),
              onTap: () {
                Navigator.pop(context);
                _navigateToPaymentScreen(context, 'الكهرباء');
              },
            ),
            ListTile(
              leading: const Icon(Icons.water_drop, color: Colors.blue),
              title: const Text('الماء'),
              onTap: () {
                Navigator.pop(context);
                _navigateToPaymentScreen(context, 'الماء');
              },
            ),
            ListTile(
              leading: const Icon(Icons.recycling, color: Colors.green),
              title: const Text('النفايات'),
              onTap: () {
                Navigator.pop(context);
                _navigateToPaymentScreen(context, 'النفايات');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPaymentScreen(BuildContext context, String serviceName) {
    // تحديد بيانات الخدمة بناءً على الاسم
    Map<String, dynamic> serviceData;
    const double amount = 185.75;

    switch (serviceName) {
      case 'الكهرباء':
        serviceData = {
          'color': const Color(0xFF6A1B9A),
          'gradient': [const Color(0xFF9C27B0), const Color(0xFF6A1B9A)],
        };
        break;
      case 'الماء':
        serviceData = {
          'color': const Color(0xFF00ACC1),
          'gradient': [const Color(0xFF00BCD4), const Color(0xFF00838F)],
        };
        break;
      case 'النفايات':
        serviceData = {
          'color': const Color(0xFF43A047),
          'gradient': [const Color(0xFF66BB6A), const Color(0xFF2E7D32)],
        };
        break;
      default:
        serviceData = {
          'color': Colors.blue,
          'gradient': [Colors.blue, Colors.blue.shade700],
        };
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          serviceName: serviceName,
          serviceColor: serviceData['color'] as Color,
          serviceGradient: serviceData['gradient'] as List<Color>,
          amount: amount,
          hasDiscount: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' النقاط'),
        backgroundColor: serviceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة النقاط
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [serviceColor.withOpacity(0.8), serviceColor],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 40, color: Colors.white),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'نقاطك الحالية',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          '1500 نقطة',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'تعادل 15.00 دينار',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // قسم كيفية كسب النقاط
            Column(
              children: [
                const Text(
                  'كيفية كسب النقاط',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                _buildPointsItem(
                  icon: Icons.payment,
                  title: 'الدفع في الموعد',
                  points: '+50 نقطة',
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PointsDetailsScreen(
                          pointsType: 'الدفع في الموعد',
                          serviceColor: serviceColor,
                        ),
                      ),
                    );
                  },
                ),
                _buildPointsItem(
                  icon: Icons.alarm,
                  title: 'الدفع المبكر',
                  points: '+100 نقطة',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PointsDetailsScreen(
                          pointsType: 'الدفع المبكر',
                          serviceColor: serviceColor,
                        ),
                      ),
                    );
                  },
                ),
                _buildPointsItem(
                  icon: Icons.group_add,
                  title: 'إحالة أصدقاء',
                  points: '+200 نقطة',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PointsDetailsScreen(
                          pointsType: 'إحالة أصدقاء',
                          serviceColor: serviceColor,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
            const SizedBox(height: 30),

            // قسم استخدام النقاط
            const Text(
              'استخدام النقاط',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildUsageItem(
              icon: Icons.receipt,
              title: 'خصومات على الفواتير',
              description: '100 نقطة = 1 دينار',
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showServiceSelectionDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: serviceColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'استخدام النقاط',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsItem({
    required IconData icon,
    required String title,
    required String points,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            Text(
              points,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: serviceColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
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
        ],
      ),
    );
  }
}

class PrizesRaffleScreen extends StatefulWidget {
  final Color serviceColor;

  const PrizesRaffleScreen({super.key, required this.serviceColor});

  @override
  _PrizesRaffleScreenState createState() => _PrizesRaffleScreenState();
}

class _PrizesRaffleScreenState extends State<PrizesRaffleScreen> {
  bool _paymentVerified = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _paymentVerified = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('السحب على الجوائز'),
        backgroundColor: widget.serviceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Icon(
                Icons.celebration,
                size: 80,
                color: widget.serviceColor,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                _paymentVerified
                    ? 'تم التحقق من دفعتك بنجاح!'
                    : 'جاري التحقق من دفعتك...',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _paymentVerified ? Colors.green : Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'اختر الجائزة التي ترغب بالمشاركة في السحب عليها:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            if (_paymentVerified) ...[
              _buildPrizeCard(
                title: "السحب على سيارة",
                description: "فرصة لربح سيارة جديدة كلياً",
                icon: Icons.directions_car,
                color: Colors.blue,
                onTap: () => _showRaffleConfirmation(context, "سيارة جديدة"),
              ),
              const SizedBox(height: 15),
              _buildPrizeCard(
                title: "السحب على مكيف سبليت",
                description: "ربح مكيف سبليت عالي الجودة",
                icon: Icons.ac_unit,
                color: Colors.teal,
                onTap: () => _showRaffleConfirmation(context, "مكيف سبليت"),
              ),
              const SizedBox(height: 15),
              _buildPrizeCard(
                title: 'السحب على 1000 نقطة',
                description: '1000 نقطة قابلة للاستبدال بهدايا',
                icon: Icons.star,
                color: Colors.amber,
                onTap: () => _showRaffleConfirmation(context, '1000 نقطة'),
              ),
            ] else ...[
              const Center(child: CircularProgressIndicator()),
            ],

            const SizedBox(height: 30),
            if (_paymentVerified) ...[
              const Text(
                'شروط المشاركة:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildConditionItem('الدفع في الموعد المحدد'),
              _buildConditionItem('عدم وجود متأخرات سابقة'),
              _buildConditionItem('صحة بيانات المستخدم'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPrizeCard({
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(width: 15),
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
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_left, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConditionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: widget.serviceColor, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  void _showRaffleConfirmation(BuildContext context, String prize) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('المشاركة في السحب على $prize'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              'تمت مشاركتك في السحب على $prize بنجاح!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'سيتم الإعلان عن النتائج عبر التطبيق والبريد الإلكتروني',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
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
}

class PointsDetailsScreen extends StatelessWidget {
  final String pointsType;
  final Color serviceColor;

  const PointsDetailsScreen({
    super.key,
    required this.pointsType,
    required this.serviceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pointsType), backgroundColor: serviceColor),
      body: Center(child: Text('تفاصيل $pointsType')),
    );
  }
}
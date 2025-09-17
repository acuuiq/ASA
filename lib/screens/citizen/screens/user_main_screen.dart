import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/payment_screen.dart';
import '../services/points_and_gifts_screen.dart';
import '../services/waste_schedule_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import '../auth/signin_screen.dart';
import '../services/monthly_consumption_screen.dart';
import '../services/problem_report_screen.dart';
import '../services/emergency_screen.dart';
import '../services/paid_services_screen.dart';
import '../services/daily_consumption_screen.dart';
import '../screens/events_screen.dart';

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
    'tax': Icons.receipt_long,
    'offers': Icons.card_giftcard,
    'premium': Icons.star,
    'container': Icons.add_circle,
    'schedule': Icons.calendar_today,
    'profile': Icons.person,
  };
  // استبدال خدمة 'ضريبة التأخير' بـ 'معلومات الفواتير' في جميع الخدمات
  // في قائمة _services، قم بتعديل كل خدمة 'ضريبة التأخير' لتصبح 'معلومات الفواتير'

  // في قائمة _services، أضف خدمة 'أمر طارئ' إلى قسم النفايات
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
        {'name': 'معلومات الفواتير', 'icon': 'tax', 'premium': false},
        {'name': 'الهدايا والعروض', 'icon': 'offers', 'premium': false},
        {'name': 'خدمات مميزة', 'icon': 'premium', 'premium': true},
      ],
    },
    {
      'title': 'الماء',
      'icon': 'water',
      'color': const Color(0xFF00B4D8),
      'gradient': [const Color(0xFF00B4D8), const Color(0xFF90E0EF)],
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
        {'name': 'معلومات الفواتير', 'icon': 'tax', 'premium': false},
        {'name': 'الهدايا والعروض', 'icon': 'offers', 'premium': false},
        {'name': 'خدمات مميزة', 'icon': 'premium', 'premium': true},
      ],
    },
    {
      'title': 'النفايات',
      'icon': 'waste',
      'color': const Color(0xFF4CAF50),
      'gradient': [const Color(0xFF4CAF50), const Color(0xFF8BC34A)],
      'services': [
        {
          'name': 'دفع الرسوم',
          'icon': 'payment',
          'premium': false,
          'hasEarlyPaymentDiscount': true,
        },
        {'name': 'أمر طارئ', 'icon': 'emergency', 'premium': false},

        {'name': 'جدول النظافة', 'icon': 'schedule', 'premium': false},
        {'name': 'الإبلاغ عن مشكلة', 'icon': 'problem', 'premium': false},
        // إضافة خدمة 'أمر طارئ' للنفايات
        {'name': 'معلومات الفواتير', 'icon': 'tax', 'premium': false},
        {'name': 'الهدايا والعروض', 'icon': 'offers', 'premium': false},
        {'name': 'خدمات مميزة', 'icon': 'premium', 'premium': true},
      ],
    },
  ];
final List<Map<String, dynamic>> _events = [
  {
    'title': 'صيانة مخططة',
    'description': 'سيتم إيقاف خدمة الكهرباء للصيانة الدورية يوم السبت القادم من الساعة 10 صباحاً حتى 2 ظهراً',
    'color': const Color(0xFF0D47A1),
    'icon': Icons.engineering,
    'date': DateTime.now().add(const Duration(days: 3)),
    'location': 'جميع الأحياء',
  },
  {
    'title': 'توعية بيئية',
    'description': 'ورشة عمل حول ترشيد استهلاك المياه والطاقة يوم الأحد القادم في المركز الثقافي',
    'color': const Color(0xFF00B4D8),
    'icon': Icons.eco,
    'date': DateTime.now().add(const Duration(days: 4)),
    'location': 'المركز الثقافي - وسط المدينة',
  },
  {
    'title': 'تحديث النظام',
    'description': 'سيتم تحديث نظام الفواتير الإلكترونية يوم الاثنين القادم، قد تؤثر على بعض الخدمات مؤقتاً',
    'color': const Color(0xFF4CAF50),
    'icon': Icons.system_update,
    'date': DateTime.now().add(const Duration(days: 5)),
    'location': 'جميع المناطق',
  },
];
Widget _buildEventsButton() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(
            Icons.event,
            size: 24,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventsScreen(
                  events: _events,
                  serviceColor: _services[_currentIndex]['color'] as Color,
                ),
              ),
            );
          },
          tooltip: 'الأحداث',
        ),
        if (_events.isNotEmpty)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                _events.length.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
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
  // دالة جديدة لعرض معلومات الفواتير
  void _showBillingInformation(BuildContext context, Color serviceColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: serviceColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.receipt_long, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'معلومات الفواتير',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBillingInfoCard(
                      context,
                      title: 'الدفع المبكر',
                      icon: Icons.trending_up,
                      color: const Color(0xFF2E7D32),
                      benefits: [
                        'خصم 10% على قيمة الفاتورة',
                        'نقاط مكافآت إضافية',
                        'تأمين ضد رسوم التأخير',
                        'مشاركة في السحب على الجوائز',
                      ],
                      description:
                          'الدفع قبل تاريخ الاستحقاق ب 5 أيام على الأقل',
                    ),

                    const SizedBox(height: 20),

                    _buildBillingInfoCard(
                      context,
                      title: 'الدفع في الموعد',
                      icon: Icons.event_available,
                      color: const Color(0xFF1976D2),
                      benefits: [
                        'تجنب رسوم التأخير',
                        'الحفاظ على سجل دفع جيد',
                        'استمرارية الخدمة بدون انقطاع',
                        'مشاركة في برنامج الولاء',
                      ],
                      description:
                          'الدفع خلال الفترة من تاريخ الإصدار حتى تاريخ الاستحقاق',
                    ),

                    const SizedBox(height: 20),

                    _buildBillingInfoCard(
                      context,
                      title: 'ضريبة التأخير',
                      icon: Icons.warning,
                      color: const Color(0xFFD32F2F),
                      benefits: [],
                      penalties: [
                        'رسوم تأخير 5% من قيمة الفاتورة',
                        'تجميد بعض الخدمات الإضافية',
                        'تأثير سلبي على التقييم الائتماني',
                        'احتمال انقطاع الخدمة بعد 30 يوم',
                      ],
                      description: 'تطبق عند التأخر عن تاريخ الاستحقاق المحدد',
                    ),

                    const SizedBox(height: 30),

                    // نصائح مهمة
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '💡 نصائح مهمة',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTipItem(
                            'تفعيل التنبيهات لتلقي إشعارات الفواتير',
                          ),
                          _buildTipItem('استخدم الدفع الآلي لتجنب النسيان'),
                          _buildTipItem(
                            'احتفظ بسجل دفعك للرجوع إليه عند الحاجة',
                          ),
                          _buildTipItem('تواصل مع الدعم الفني لأي استفسارات'),
                        ],
                      ),
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

  Widget _buildBillingInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<String> benefits,
    List<String> penalties = const [],
    required String description,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان والآيكون
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // الوصف
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
            ),

            const SizedBox(height: 16),

            // المزايا أو العقوبات
            if (benefits.isNotEmpty) ...[
              const Text(
                'المزايا:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 8),
              ...benefits
                  .map(
                    (benefit) =>
                        _buildListItem('✓ $benefit', const Color(0xFF2E7D32)),
                  )
                  .toList(),
            ],

            if (penalties.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'العقوبات:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD32F2F),
                ),
              ),
              const SizedBox(height: 8),
              ...penalties
                  .map(
                    (penalty) =>
                        _buildListItem('✗ $penalty', const Color(0xFFD32F2F)),
                  )
                  .toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 8, color: Color(0xFF1976D2)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF212121)),
            ),
          ),
        ],
      ),
    );
  }

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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DailyConsumptionScreen(
              serviceTitle: title,
              serviceColor: color,
              serviceGradient: gradient,
            ),
          ),
        );
      },
      child: Card(
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
                      child: Stack(alignment: Alignment.center, children: [
                        
                       
                      ],
                    ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'انقر للمزيد من التفاصيل',
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: color, size: 12),
                  ],
                ),
              ],
            ),
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
          actions: [_buildNotificationButton(),
              _buildEventsButton(), // أضف زر الأحداث هنا
],
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
            services: [], // قائمة فارغة بدون خدمات
            primaryColor: serviceColor,
            primaryGradient: serviceGradient,
          ),
        ),
      );
    } else if (serviceName.contains('الهدايا والعروض')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OffersAndPrizesScreen(serviceColor: serviceColor),
        ),
      );
    } else if (serviceName.contains('جدول النظافة')) {
  


  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WasteScheduleScreen(
        serviceColor: serviceColor,
      ),
    ),
  );



    } else if (serviceName.contains('معلومات الفواتير')) {
      _showBillingInformation(context, serviceColor);
    } else if (serviceName.contains('الإبلاغ عن مشكلة')) {
      // توجيه إلى شاشة الإبلاغ عن المشاكل الجديدة
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProblemReportScreen(
            serviceName: serviceName,
            serviceColor: serviceColor,
            serviceGradient: serviceGradient,
            serviceTitle: serviceTitle,
          ),
        ),
      );
    } else if (serviceName.contains('أمر طارئ')) {
      // توجيه إلى شاشة الطوارئ الجديدة
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmergencyScreen(
            serviceName: serviceName,
            serviceColor: serviceColor,
            serviceGradient: serviceGradient,
            serviceTitle: serviceTitle,
          ),
        ),
      );
    } else if (serviceName.contains('خدمات مميزة')) {
      // توجيه إلى شاشة الخدمات المدفوعة الجديدة
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaidServicesScreen(
            serviceName: serviceName,
            serviceColor: serviceColor,
            serviceGradient: serviceGradient,
            serviceTitle: serviceTitle,
          ),
        ),
      );
    } else {
      // للخدمات الأخرى، يمكنك إما إظهار رسالة أو توجيه إلى صفحة افتراضية
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MonthlyConsumptionScreen(
            serviceColor: serviceColor,
            serviceGradient: serviceGradient,
            serviceTitle: serviceTitle,
          ),
        ),
      );
    }
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

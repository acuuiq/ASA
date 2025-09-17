import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'payment_screen.dart';
import 'points_service.dart'; // استيراد خدمة النقاط
import 'dart:async'; // أضف هذا في الأعلى

class PointsAndGiftsScreen extends StatefulWidget {
  static const String screen = 'pointandgift_screen';
  final Color serviceColor;

  const PointsAndGiftsScreen({super.key, required this.serviceColor});

  @override
  State<PointsAndGiftsScreen> createState() => _PointsAndGiftsScreenState();
}

class _PointsAndGiftsScreenState extends State<PointsAndGiftsScreen> {
  final PointsService _pointsService = PointsService();
  int _userPoints = 0;
  double _pointsValue = 0.2;
  bool _isLoading = true;
  StreamSubscription<int>? _pointsSubscription;

  @override
  void initState() {
    super.initState();
    _loadUserPoints();
    _subscribeToPointsChanges();
  }

  void _subscribeToPointsChanges() {
    _pointsSubscription = _pointsService.getUserPointsStream().listen((points) {
      if (mounted) {
        setState(() {
          _userPoints = points;
          _pointsValue = points * 0.01;
        });
      }
    }, onError: (error) {
      print('Error in points stream: $error');
    });
  }

  Future<void> _loadUserPoints() async {
    try {
      final points = await _pointsService.getUserPoints();
      setState(() {
        _userPoints = points;
        _pointsValue = points * 0.01;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading points: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pointsSubscription?.cancel();
    super.dispose();
  }



  void _navigateToPaymentScreen(BuildContext context, String serviceName) {
    // ... الكود الحالي بدون تغيير
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

    final List<Color> serviceGradient =
        (serviceData['gradient'] as List<Color>?) ??
            [widget.serviceColor, widget.serviceColor];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          services: [
            ServiceItem(
              id: '1',
              name: serviceName,
              amount: 185.75,
              color: widget.serviceColor,
              gradient: serviceGradient,
              additionalInfo: "معلومات إضافية عن الخدمة",
            ),
          ],
          primaryColor: widget.serviceColor,
          primaryGradient: serviceGradient,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' النقاط'),
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
                    colors: [widget.serviceColor.withOpacity(0.8), widget.serviceColor],
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
                        _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                '$_userPoints نقطة',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                        _isLoading
                            ? const SizedBox()
                            : Text(
                                'تعادل ${_pointsValue.toStringAsFixed(2)} دينار',
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
            const SizedBox(height: 10),

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
                          serviceColor: widget.serviceColor,
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
                          serviceColor: widget.serviceColor,
                        ),
                      ),
                    );
                  },
                ),
                _buildPointsItem(
                  icon: Icons.swipe_vertical_sharp,
                  title: 'فعاليات متجددة ',
                  points: '  ',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PointsDetailsScreen(
                          pointsType: 'فعاليات متجددة ',
                          serviceColor: widget.serviceColor,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 0),
              ],
            ),

            // قسم استخدام النقاط
            const Text(
              'استخدام النقاط',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),
            _buildUsageItem(
              icon: Icons.quiz_sharp,
              title: 'ما فائدة النقاط وكيف تستخدمها؟  ',
              description:
                  'تستخدم هذه النقاط في واجهات الدفع للخصم من سعر الفواتير كل 100 نقطة = 1 دينار',
            ),
            const SizedBox(height: 20),
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
          Icon(icon, size: 28, color: widget.serviceColor),
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

// PointsDetailsScreen موجود هنا بالفعل - أضف المحتوى السابق هنا
class PointsDetailsScreen extends StatelessWidget {
  final String pointsType;
  final Color serviceColor;

  const PointsDetailsScreen({
    super.key,
    required this.pointsType,
    required this.serviceColor,
  });

  // بيانات وهمية للعرض
  final List<Map<String, dynamic>> _paymentOnTimeHistory = const [
    {
      'date': '2023-10-01',
      'amount': 50.0,
      'billNumber': 'INV-2023-1001',
      'service': 'الكهرباء',
    },
    {
      'date': '2023-09-01',
      'amount': 50.0,
      'billNumber': 'INV-2023-0901',
      'service': 'الماء',
    },
    {
      'date': '2023-08-01',
      'amount': 50.0,
      'billNumber': 'INV-2023-0801',
      'service': 'النفايات',
    },
  ];

  final List<Map<String, dynamic>> _earlyPaymentHistory = const [
    {
      'date': '2023-10-15',
      'amount': 100.0,
      'billNumber': 'INV-2023-1015',
      'daysEarly': 5,
      'service': 'الكهرباء',
    },
    {
      'date': '2023-09-12',
      'amount': 100.0,
      'billNumber': 'INV-2023-0912',
      'daysEarly': 8,
      'service': 'الماء',
    },
    {
      'date': '2023-08-10',
      'amount': 100.0,
      'billNumber': 'INV-2023-0810',
      'daysEarly': 10,
      'service': 'النفايات',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> historyData;
    String title;
    String totalPoints;
    String description;

    switch (pointsType) {
      case 'الدفع في الموعد':
        title = 'سجل الدفع في الموعد';
        totalPoints = '${_paymentOnTimeHistory.length * 50} نقطة';
        description = 'تحصل على 50 نقطة لكل دفعة في الموعد';
        historyData = _paymentOnTimeHistory;
        break;
      case 'الدفع المبكر':
        title = 'سجل الدفع المبكر';
        totalPoints = '${_earlyPaymentHistory.length * 100} نقطة';
        description = 'تحصل على 100 نقطة لكل دفعة مبكرة';
        historyData = _earlyPaymentHistory;
        break;
      default:
        title = 'سجل النقاط';
        totalPoints = '0 نقطة';
        description = '';
        historyData = [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: serviceColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // بطاقة ملخص النقاط
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [serviceColor.withOpacity(0.8), serviceColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إجمالي النقاط',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          totalPoints,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // قائمة العمليات
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                final item = historyData[index];
                return _buildHistoryItem(item, pointsType);
              },
            ),
          ),
        ],
      ),
      
    );
    
  }

  Widget _buildHistoryItem(Map<String, dynamic> item, String pointsType) {
    IconData icon;
    Color iconColor;
    String title;
    String subtitle;

    switch (pointsType) {
      case 'الدفع في الموعد':
        icon = Icons.payment;
        iconColor = Colors.green;
        title = 'دفع فاتورة ${item['billNumber']} (${item['service']})';
        subtitle = 'تم الدفع في ${item['date']} - ${item['amount']} نقطة';
        break;
      case 'الدفع المبكر':
        icon = Icons.alarm;
        iconColor = Colors.blue;
        title = 'دفع مبكر لفاتورة ${item['billNumber']} (${item['service']})';
        subtitle =
            'تم الدفع قبل ${item['daysEarly']} أيام - ${item['amount']} نقطة';
        break;
      default:
        icon = Icons.star;
        iconColor = Colors.amber;
        title = '';
        subtitle = '';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              DateFormat(
                'dd/MM',
              ).format(DateFormat('yyyy-MM-dd').parse(item['date'])),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
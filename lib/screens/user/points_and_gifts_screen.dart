import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  final List<Map<String, dynamic>> _referralHistory = const [
    {
      'date': '2023-10-10',
      'amount': 200.0,
      'friendName': 'أحمد محمد',
      'friendPhone': '0912345678',
    },
    {
      'date': '2023-09-20',
      'amount': 200.0,
      'friendName': 'سارة علي',
      'friendPhone': '0923456789',
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
      case 'إحالة أصدقاء':
        title = 'سجل الإحالات';
        totalPoints = '${_referralHistory.length * 200} نقطة';
        description = 'تحصل على 200 نقطة لكل إحالة ناجحة';
        historyData = _referralHistory;
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
      case 'إحالة أصدقاء':
        icon = Icons.person_add;
        iconColor = Colors.purple;
        title = 'إحالة ${item['friendName']}';
        subtitle =
            'رقم الجوال: ${item['friendPhone']} - ${item['amount']} نقطة';
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
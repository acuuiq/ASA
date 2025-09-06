import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaterEmployeeScreen extends StatefulWidget {
  static const String screenRoute = 'water_employee_screen';

  const WaterEmployeeScreen({super.key});

  @override
  State<WaterEmployeeScreen> createState() => _WaterEmployeeScreenState();
}

class _WaterEmployeeScreenState extends State<WaterEmployeeScreen> {
  int _selectedTab = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // بيانات العينة
  final List<Map<String, dynamic>> _bills = [
    {
      'id': 'WATER-2024-001',
      'customerName': 'أحمد محمد',
      'customerId': 'C1001',
      'amount': 85.75,
      'consumption': '25 م³',
      'dueDate': DateTime.now().add(Duration(days: 5)),
      'paidDate': null,
      'status': 'غير مدفوعة',
      'address': 'شارع الملك فهد، الرياض',
      'meterNumber': 'WM-87654321',
      'previousReading': 1250,
      'currentReading': 1275,
      'tariff': 'سكني',
      'paymentMethod': '',
      'lateFee': 0.0,
    },
    {
      'id': 'WATER-2024-002',
      'customerName': 'فاطمة علي',
      'customerId': 'C1002',
      'amount': 120.50,
      'consumption': '42 م³',
      'dueDate': DateTime.now().subtract(Duration(days: 3)),
      'paidDate': DateTime.now().subtract(Duration(days: 1)),
      'status': 'مدفوعة',
      'address': 'حي النخيل، جدة',
      'meterNumber': 'WM-12345678',
      'previousReading': 2100,
      'currentReading': 2142,
      'tariff': 'تجاري',
      'paymentMethod': 'بطاقة ائتمان',
      'lateFee': 0.0,
    },
    {
      'id': 'WATER-2024-003',
      'customerName': 'سالم عبدالله',
      'customerId': 'C1003',
      'amount': 65.25,
      'consumption': '18 م³',
      'dueDate': DateTime.now().subtract(Duration(days: 10)),
      'paidDate': null,
      'status': 'متأخرة',
      'address': 'حي العليا، الرياض',
      'meterNumber': 'WM-55556666',
      'previousReading': 3450,
      'currentReading': 3468,
      'tariff': 'سكني',
      'paymentMethod': '',
      'lateFee': 3.26,
    },
  ];

  final List<Map<String, dynamic>> _reports = [
    {
      'id': 'R-001',
      'customerName': 'أحمد محمد',
      'customerId': 'C1001',
      'type': 'عطل في العداد',
      'description': 'العداد لا يعرض القراءة بشكل صحيح',
      'status': 'قيد المعالجة',
      'priority': 'عالية',
      'date': DateTime.now().subtract(Duration(days: 1)),
      'assignedTo': 'فني الصيانة',
      'estimatedResolution': DateTime.now().add(Duration(days: 2)),
    },
    {
      'id': 'R-002',
      'customerName': 'فاطمة علي',
      'customerId': 'C1002',
      'type': 'انقطاع المياه',
      'description': 'انقطاع المياه عن المنطقة بشكل متكرر',
      'status': 'مكتمل',
      'priority': 'عالية',
      'date': DateTime.now().subtract(Duration(days: 3)),
      'assignedTo': 'فريق الطوارئ',
      'estimatedResolution': DateTime.now().subtract(Duration(days: 1)),
    },
  ];

  final List<Map<String, dynamic>> _consumptionStats = [
    {
      'period': 'يناير 2024',
      'totalConsumption': '12500 م³',
      'totalRevenue': '48500 دينار',
      'activeCustomers': 1250,
      'avgConsumption': '28 م³',
    },
    {
      'period': 'فبراير 2024',
      'totalConsumption': '11800 م³',
      'totalRevenue': '44200 دينار',
      'activeCustomers': 1220,
      'avgConsumption': '26 م³',
    },
  ];

  // بيانات الخدمات من واجهة المستخدم
  final Map<String, dynamic> _waterService = {
    'title': 'الماء',
    'icon': 'water',
    'color': Color(0xFF1976D2),
    'gradient': [Color(0xFF2196F3), Color(0xFF1976D2)],
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
  };

  final List<Map<String, dynamic>> _emergencyRequests = [
    {
      'id': 'EMG-001',
      'customerName': 'محمد أحمد',
      'customerId': 'C1004',
      'location': 'شارع الملك عبدالله، الرياض',
      'type': 'انقطاع مياه',
      'priority': 'عالية',
      'status': 'قيد المعالجة',
      'date': DateTime.now().subtract(Duration(hours: 2)),
      'assignedTeam': 'فريق الطوارئ 1',
    },
    {
      'id': 'EMG-002',
      'customerName': 'سارة عبدالله',
      'customerId': 'C1005',
      'location': 'حي العليا، الرياض',
      'type': 'تسرب مياه',
      'priority': 'حرجة',
      'status': 'بانتظار التعيين',
      'date': DateTime.now().subtract(Duration(minutes: 30)),
      'assignedTeam': '',
    },
  ];

  final List<Map<String, dynamic>> _premiumServices = [
    {
      'id': 'PREMIUM-001',
      'name': 'تركيب فلاتر مياه',
      'description': 'تركيب نظام تنقية مياه متكامل',
      'price': '3000 دينار',
      'duration': '3 أيام عمل',
      'status': 'متاح',
    },
    {
      'id': 'PREMIUM-002',
      'name': 'نظام مراقبة استهلاك',
      'description': 'نظام ذكي لمراقبة وتحليل الاستهلاك',
      'price': '1200 دينار',
      'duration': '2 أيام عمل',
      'status': 'متاح',
    },
    {
      'id': 'PREMIUM-003',
      'name': 'صيانة وقائية',
      'description': 'صيانة دورية شاملة للتركيبات المائية',
      'price': '600 دينار',
      'duration': '1 يوم',
      'status': 'متاح',
    },
  ];

  // بيانات الهدايا والعروض المحسنة
  final List<Map<String, dynamic>> _offersAndGifts = [
    {
      'id': 'OFFER-001',
      'title': 'خصم الدفع المبكر',
      'description': 'احصل على خصم 15% عند الدفع قبل تاريخ الاستحقاق',
      'icon': Icons.attach_money,
      'color': Colors.green,
      'gradient': [Colors.green.shade400, Colors.green.shade700],
      'discount': '15%',
      'conditions': 'الدفع قبل تاريخ الاستحقاق بـ 7 أيام',
      'validUntil': DateTime.now().add(Duration(days: 45)),
      'customersUsed': 342,
      'totalSavings': '12500 دينار',
      'image': 'assets/images/early_payment.png',
      'category': 'خصومات',
    },
    {
      'id': 'OFFER-002',
      'title': 'برنامج الولاء',
      'description': 'اكسب نقاطاً مع كل فاتورة وافسحها بمكافآت قيمة',
      'icon': Icons.loyalty,
      'color': Colors.purple,
      'gradient': [Colors.purple.shade400, Colors.purple.shade700],
      'pointsRate': '1 دينار = 10 نقاط',
      'earningMethods': [
        {'method': 'الدفع في الموعد', 'points': 100},
        {'method': 'الدفع المبكر', 'points': 150},
        {'method': 'إحالة أصدقاء', 'points': 500},
      ],
      'redemptionOptions': [
        {'option': 'خصم 20% على الفاتورة', 'points': 1000},
        {'option': 'شهر مجاني من المياه', 'points': 3000},
        {'option': 'تركيب فلتر مياه مجاني', 'points': 5000},
      ],
      'totalPointsDistributed': 285000,
      'activeParticipants': 2450,
      'image': 'assets/images/loyalty.png',
      'category': 'ولاء',
    },
    {
      'id': 'OFFER-003',
      'title': 'عروض الموسم',
      'description': 'استمتع بعروض خاصة خلال فصل الصيف على خدمات الصيانة',
      'icon': Icons.wb_sunny,
      'color': Colors.orange,
      'gradient': [Colors.orange.shade400, Colors.orange.shade700],
      'discount': '25%',
      'conditions': 'صالح على خدمات الصيانة حتى نهاية الموسم',
      'validUntil': DateTime.now().add(Duration(days: 60)),
      'customersUsed': 178,
      'totalSavings': '8900 دينار',
      'image': 'assets/images/summer_offers.png',
      'category': 'موسمية',
    },
  ];

  final List<Map<String, dynamic>> _activeGifts = [
    {
      'id': 'GIFT-001',
      'name': 'كوبون خصم 25%',
      'value': '25%',
      'type': 'خصم',
      'status': 'نشط',
      'issuedDate': DateTime.now().subtract(Duration(days: 10)),
      'expiryDate': DateTime.now().add(Duration(days: 20)),
      'redeemed': 78,
      'total': 200,
      'color': Colors.blue.shade700,
      'icon': Icons.discount,
    },
    {
      'id': 'GIFT-002',
      'name': 'نقاط مكافأة',
      'value': '1000 نقطة',
      'type': 'نقاط',
      'status': 'نشط',
      'issuedDate': DateTime.now().subtract(Duration(days: 5)),
      'expiryDate': DateTime.now().add(Duration(days: 25)),
      'redeemed': 125,
      'total': 300,
      'color': Colors.purple.shade700,
      'icon': Icons.card_giftcard,
    },
    {
      'id': 'GIFT-003',
      'name': 'صيانة مجانية',
      'value': 'خدمة مجانية',
      'type': 'خدمة',
      'status': 'معلقة',
      'issuedDate': DateTime.now().subtract(Duration(days: 2)),
      'expiryDate': DateTime.now().add(Duration(days: 30)),
      'redeemed': 25,
      'total': 100,
      'color': Colors.green.shade700,
      'icon': Icons.build,
    },
    {
      'id': 'GIFT-004',
      'name': 'تركيب فلتر',
      'value': 'تركيب مجاني',
      'type': 'تركيب',
      'status': 'نشط',
      'issuedDate': DateTime.now().subtract(Duration(days: 7)),
      'expiryDate': DateTime.now().add(Duration(days: 23)),
      'redeemed': 42,
      'total': 150,
      'color': Colors.orange.shade700,
      'icon': Icons.filter_alt,
    },
  ];

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
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> data) {
    if (_searchQuery.isEmpty) return data;
    return data.where((item) {
      final customerName = item['customerName']?.toString().toLowerCase() ?? '';
      final id = item['id']?.toString().toLowerCase() ?? '';
      final title = item['title']?.toString().toLowerCase() ?? '';
      final name = item['name']?.toString().toLowerCase() ?? '';
      final customerId = item['customerId']?.toString().toLowerCase() ?? '';
      
      final query = _searchQuery.toLowerCase();
      return customerName.contains(query) ||
             id.contains(query) ||
             title.contains(query) ||
             name.contains(query) ||
             customerId.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('نظام إدارة الماء - الموظف',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Color(0xFF0066CC),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: _showNotifications,
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: _showProfile,
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'ابحث باسم العميل، رقم الفاتورة، أو اسم العرض...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),

          // التبويبات
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabButton('الفواتير', 0, Icons.receipt),
                  _buildTabButton('البلاغات', 1, Icons.report_problem),
                  _buildTabButton('الأوامر الطارئة', 2, Icons.emergency),
                  _buildTabButton('الخدمات المميزة', 3, Icons.star),
                  _buildTabButton('الهدايا والعروض', 4, Icons.card_giftcard),
                  _buildTabButton('الإحصائيات', 5, Icons.analytics),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          Expanded(
            child: _buildCurrentTab(),
          ),
        ],
      ),
      floatingActionButton: _selectedTab == 0
          ? FloatingActionButton(
              onPressed: _showAddBillDialog,
              backgroundColor: Color(0xFF0066CC),
              child: Icon(Icons.add, color: Colors.white),
            )
          : _selectedTab == 2
              ? FloatingActionButton(
                  onPressed: _showAddEmergencyDialog,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.add, color: Colors.white),
                )
              : _selectedTab == 4
                  ? FloatingActionButton(
                      onPressed: _showAddOfferDialog,
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.add, color: Colors.white),
                    )
                  : null,
    );
  }

  Widget _buildTabButton(String title, int index, IconData icon) {
    final isSelected = _selectedTab == index;
    return Container(
      constraints: BoxConstraints(minWidth: 80),
      child: TextButton(
        onPressed: () {
          setState(() {
            _selectedTab = index;
          });
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: isSelected ? Color(0xFF0066CC).withOpacity(0.15) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? Color(0xFF0066CC) : Colors.grey),
            SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Color(0xFF0066CC) : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_selectedTab) {
      case 0:
        return _buildBillsTab();
      case 1:
        return _buildReportsTab();
      case 2:
        return _buildEmergencyTab();
      case 3:
        return _buildPremiumServicesTab();
      case 4:
        return _buildOffersAndGiftsTab();
      case 5:
        return _buildStatisticsTab();
      default:
        return Center(child: Text('غير متوفر'));
    }
  }

  Widget _buildBillsTab() {
    final filteredBills = _filterData(_bills);

    return Column(
      children: [
        // إحصائيات سريعة
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildStatCard(
                'إجمالي الفواتير',
                '${_bills.length}',
                Icons.receipt,
                Color(0xFF0066CC),
              ),
              SizedBox(width: 8),
              _buildStatCard(
                'غير المدفوعة',
                '${_bills.where((b) => b['status'] == 'غير مدفوعة').length}',
                Icons.pending,
                Color(0xFFFF9800),
              ),
              SizedBox(width: 8),
              _buildStatCard(
                'المتأخرة',
                '${_bills.where((b) => b['status'] == 'متأخرة').length}',
                Icons.warning,
                Color(0xFFF44336),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredBills.length,
            itemBuilder: (context, index) {
              return _buildBillCard(filteredBills[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
                Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillCard(Map<String, dynamic> bill) {
    Color statusColor;
    IconData statusIcon;

    switch (bill['status']) {
      case 'مدفوعة':
        statusColor = Color(0xFF4CAF50);
        statusIcon = Icons.check_circle;
        break;
      case 'غير مدفوعة':
        statusColor = Color(0xFFFF9800);
        statusIcon = Icons.pending;
        break;
      case 'متأخرة':
        statusColor = Color(0xFFF44336);
        statusIcon = Icons.warning;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.receipt;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(statusIcon, color: statusColor, size: 24),
        ),
        title: Text(
          bill['customerName'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('فاتورة #${bill['id']}'),
            SizedBox(height: 4),
            Text('${bill['amount']} دينار • ${bill['consumption']}'),
            SizedBox(height: 4),
            Text(
              'تاريخ الاستحقاق: ${DateFormat('yyyy-MM-dd').format(bill['dueDate'])}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            bill['status'],
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () => _showBillDetails(bill),
      ),
    );
  }

  Widget _buildReportsTab() {
    final filteredReports = _filterData(_reports);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildStatCard(
                'إجمالي البلاغات',
                '${_reports.length}',
                Icons.report_problem,
                Color(0xFFF44336),
              ),
              SizedBox(width: 8),
              _buildStatCard(
                'قيد المعالجة',
                '${_reports.where((r) => r['status'] == 'قيد المعالجة').length}',
                Icons.pending,
                Color(0xFFFF9800),
              ),
              SizedBox(width: 8),
              _buildStatCard(
                'مكتملة',
                '${_reports.where((r) => r['status'] == 'مكتمل').length}',
                Icons.check_circle,
                Color(0xFF4CAF50),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredReports.length,
            itemBuilder: (context, index) {
              return _buildReportCard(filteredReports[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    Color statusColor;
    IconData statusIcon;

    switch (report['status']) {
      case 'قيد المعالجة':
        statusColor = Color(0xFFFF9800);
        statusIcon = Icons.pending;
        break;
      case 'مكتمل':
        statusColor = Color(0xFF4CAF50);
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.report_problem;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(statusIcon, color: statusColor, size: 24),
        ),
        title: Text(
          report['customerName'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('${report['type']}'),
            SizedBox(height: 4),
            Text(
              report['description'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              'تاريخ البلاغ: ${DateFormat('yyyy-MM-dd').format(report['date'])}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            report['status'],
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () => _showReportDetails(report),
      ),
    );
  }

  Widget _buildEmergencyTab() {
    final filteredEmergencies = _filterData(_emergencyRequests);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildStatCard(
                'إجمالي الطلبات',
                '${_emergencyRequests.length}',
                Icons.emergency,
                Colors.red,
              ),
              SizedBox(width: 8),
              _buildStatCard(
                'قيد المعالجة',
                '${_emergencyRequests.where((e) => e['status'] == 'قيد المعالجة').length}',
                Icons.pending,
                Color(0xFFFF9800),
              ),
              SizedBox(width: 8),
              _buildStatCard(
                'بانتظار التعيين',
                '${_emergencyRequests.where((e) => e['status'] == 'بانتظار التعيين').length}',
                Icons.schedule,
                Color(0xFF9E9E9E),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredEmergencies.length,
            itemBuilder: (context, index) {
              return _buildEmergencyCard(filteredEmergencies[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyCard(Map<String, dynamic> emergency) {
    Color statusColor;
    IconData statusIcon;

    switch (emergency['status']) {
      case 'قيد المعالجة':
        statusColor = Color(0xFFFF9800);
        statusIcon = Icons.pending;
        break;
      case 'بانتظار التعيين':
        statusColor = Color(0xFF9E9E9E);
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.emergency;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(statusIcon, color: statusColor, size: 24),
        ),
        title: Text(
          emergency['customerName'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('${emergency['type']} - ${emergency['priority']}'),
            SizedBox(height: 4),
            Text(
              emergency['location'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              'تاريخ الطلب: ${DateFormat('yyyy-MM-dd HH:mm').format(emergency['date'])}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            emergency['status'],
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () => _showEmergencyDetails(emergency),
      ),
    );
  }

  Widget _buildPremiumServicesTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'الخدمات المميزة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0066CC)),
        ),
        SizedBox(height: 16),
        ..._premiumServices.map((service) => _buildPremiumServiceCard(service)).toList(),
        
        SizedBox(height: 24),
        Text(
          'طلبات الخدمات المميزة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildServiceRequestItem('تركيب فلاتر مياه', 3, Color(0xFF4CAF50)),
              _buildServiceRequestItem('نظام مراقبة استهلاك', 5, Color(0xFF0066CC)),
              _buildServiceRequestItem('صيانة وقائية', 8, Color(0xFFFF9800)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumServiceCard(Map<String, dynamic> service) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF0066CC).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.star, color: Color(0xFF0066CC), size: 24),
        ),
        title: Text(
          service['name'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(service['description']),
            SizedBox(height: 4),
            Text('السعر: ${service['price']} • المدة: ${service['duration']}'),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFF0066CC).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            service['status'],
            style: TextStyle(color: Color(0xFF0066CC), fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () => _showPremiumServiceDetails(service),
      ),
    );
  }

  Widget _buildServiceRequestItem(String service, int count, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Expanded(child: Text(service)),
          Text('$count طلبات'),
        ],
      ),
    );
  }

  Widget _buildOffersAndGiftsTab() {
    final filteredOffers = _filterData(_offersAndGifts);
    final filteredGifts = _filterData(_activeGifts);
    
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: Color(0xFF0066CC).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Color(0xFF0066CC),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'العروض'),
                Tab(text: 'الهدايا النشطة'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // عرض العروض
                ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: filteredOffers.length,
                  itemBuilder: (context, index) {
                    return _buildOfferCard(filteredOffers[index]);
                  },
                ),
                // عرض الهدايا النشطة
                ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: filteredGifts.length,
                  itemBuilder: (context, index) {
                    return _buildGiftCard(filteredGifts[index]);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              gradient: LinearGradient(
                colors: offer['gradient'] ?? [offer['color'], offer['color']],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(offer['icon'], size: 40, color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        offer['title'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: offer['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        offer['category'] ?? 'عرض',
                        style: TextStyle(color: offer['color'], fontSize: 12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  offer['description'],
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 12),
                if (offer['discount'] != null)
                  Text(
                    'خصم ${offer['discount']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: offer['color']),
                  ),
                if (offer['pointsRate'] != null)
                  Text(
                    'معدل النقاط: ${offer['pointsRate']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('${offer['customersUsed'] ?? offer['activeParticipants']} مستفيد'),
                    Spacer(),
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('صالح حتى: ${DateFormat('yyyy-MM-dd').format(offer['validUntil'])}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiftCard(Map<String, dynamic> gift) {
    Color statusColor;
    switch (gift['status']) {
      case 'نشط':
        statusColor = Color(0xFF4CAF50);
        break;
      case 'معلقة':
        statusColor = Color(0xFFFF9800);
        break;
      case 'منتهية':
        statusColor = Color(0xFF9E9E9E);
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: gift['color'].withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(gift['icon'] ?? Icons.card_giftcard, color: gift['color'], size: 24),
        ),
        title: Text(
          gift['name'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('القيمة: ${gift['value']} • النوع: ${gift['type']}'),
            SizedBox(height: 4),
            Text('تم الاستبدال: ${gift['redeemed']}/${gift['total']}'),
            SizedBox(height: 4),
            Text(
              'تاريخ الانتهاء: ${DateFormat('yyyy-MM-dd').format(gift['expiryDate'])}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            gift['status'],
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () => _showGiftDetails(gift),
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'إحصائيات الاستهلاك',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0066CC)),
        ),
        SizedBox(height: 16),
        ..._consumptionStats.map((stat) => _buildStatisticCard(stat)).toList(),
        
        SizedBox(height: 24),
        Text(
          'مخطط الاستهلاك الشهري',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Container(
          height: 200,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'مخطط الاستهلاك سيظهر هنا',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticCard(Map<String, dynamic> stat) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat['period'],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              _buildStatItem('إجمالي الاستهلاك', stat['totalConsumption']),
              _buildStatItem('إجمالي الإيرادات', stat['totalRevenue']),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              _buildStatItem('العملاء النشطين', '${stat['activeCustomers']}'),
              _buildStatItem('متوسط الاستهلاك', stat['avgConsumption']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF0066CC).withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // وظائف العرض التفصيلي
  void _showBillDetails(Map<String, dynamic> bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الفاتورة'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('رقم الفاتورة: ${bill['id']}'),
              Text('اسم العميل: ${bill['customerName']}'),
              Text('المبلغ: ${bill['amount']} دينار'),
              Text('الحالة: ${bill['status']}'),
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

  void _showReportDetails(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل البلاغ'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('رقم البلاغ: ${report['id']}'),
              Text('اسم العميل: ${report['customerName']}'),
              Text('النوع: ${report['type']}'),
              Text('الحالة: ${report['status']}'),
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

  void _showEmergencyDetails(Map<String, dynamic> emergency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الأمر الطارئ'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('رقم الطلب: ${emergency['id']}'),
              Text('اسم العميل: ${emergency['customerName']}'),
              Text('النوع: ${emergency['type']}'),
              Text('الأولوية: ${emergency['priority']}'),
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

  void _showPremiumServiceDetails(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الخدمة المميزة'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('اسم الخدمة: ${service['name']}'),
              Text('السعر: ${service['price']}'),
              Text('المدة: ${service['duration']}'),
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

  void _showOfferDetails(Map<String, dynamic> offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل العرض'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('العنوان: ${offer['title']}'),
              Text('الوصف: ${offer['description']}'),
              if (offer['discount'] != null)
                Text('الخصم: ${offer['discount']}'),
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

  void _showGiftDetails(Map<String, dynamic> gift) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الهدية'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الاسم: ${gift['name']}'),
              Text('القيمة: ${gift['value']}'),
              Text('النوع: ${gift['type']}'),
              Text('الحالة: ${gift['status']}'),
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

  void _showAddBillDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إضافة فاتورة جديدة'),
        content: Text('سيتم تنفيذ إضافة فاتورة جديدة هنا'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showAddEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إضافة أمر طارئ جديد'),
        content: Text('سيتم تنفيذ إضافة أمر طارئ جديد هنا'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إضافة'),
          ),
        ],
      )
    );
  }

  void _showAddOfferDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إضافة عرض جديد'),
        content: Text('سيتم تنفيذ إضافة عرض جديد هنا'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('سيتم عرض الإشعارات هنا')),
    );
  }

  void _showProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('سيتم عرض الملف الشخصي هنا')),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:mang_mu/screens/citizen_service.dart';
import 'package:mang_mu/screens/citizen_model.dart';
import 'package:intl/intl.dart';

class WaterEmployeeScreen extends StatefulWidget {
  static const String screenRoute = 'water_employee_screen';

  const WaterEmployeeScreen({super.key});

  @override
  State<WaterEmployeeScreen> createState() => _WaterEmployeeScreenState();
}

class _WaterEmployeeScreenState extends State<WaterEmployeeScreen> {
  List<Citizen> _waterCitizens = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _selectedTabIndex =
      0; // 0: العملاء, 1: الفواتير, 2: الطلبات, 3: التقارير, 4: الجودة

  // بيانات الفواتير الافتراضية
  final List<Map<String, dynamic>> _bills = [
    {
      'id': '1',
      'customerName': 'محمد أحمد',
      'customerEmail': 'mohamed@example.com',
      'amount': 120.50,
      'consumption': '250 لتر',
      'dueDate': DateTime.now().add(const Duration(days: 15)),
      'status': 'غير مدفوعة',
      'paidDate': null,
      'hasDiscount': true,
      'meterReading': '1250 م³',
    },
  ];

  // بيانات الطلبات الافتراضية
  final List<Map<String, dynamic>> _requests = [
    {
      'id': '1',
      'customerName': 'محمد أحمد',
      'customerEmail': 'mohamed@example.com',
      'type': 'تسرب مياه',
      'description': 'تسرب مياه من الأنابيب الرئيسية',
      'status': 'قيد المعالجة',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'priority': 'عالي',
      'location': 'شارع الملك فهد',
      'waterLoss': '50 لتر/ساعة',
    },
  ];

  // بيانات جودة المياه
  final List<Map<String, dynamic>> _waterQuality = [
    {
      'area': 'شارع الملك فهد',
      'turbidity': '2.5 NTU',
      'ph': '6.5',
      'chlorine': '0.3 mg/L',
      'status': 'تحت المراقبة',
      'lastTest': DateTime.now().subtract(const Duration(days: 3)),
      'color': Colors.red,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCitizens();
  }

  void _loadCitizens() {
    // جلب المواطنين المسجلين في قسم الماء
    final citizens = CitizenService.getCitizensByDepartment('ماء');
    setState(() {
      _waterCitizens = citizens;
      _isLoading = false;
    });
  }

  void _refreshCitizens() {
    setState(() {
      _isLoading = true;
    });
    _loadCitizens();
  }

  List<Citizen> get _filteredCitizens {
    if (_searchQuery.isEmpty) {
      return _waterCitizens;
    }
    return _waterCitizens
        .where(
          (citizen) =>
              citizen.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              citizen.email.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  List<Map<String, dynamic>> get _filteredBills {
    if (_searchQuery.isEmpty) {
      return _bills;
    }
    return _bills
        .where(
          (bill) =>
              bill['customerName'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              bill['customerEmail'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              bill['status'].toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  List<Map<String, dynamic>> get _filteredRequests {
    if (_searchQuery.isEmpty) {
      return _requests;
    }
    return _requests
        .where(
          (request) =>
              request['customerName'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              request['customerEmail'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              request['type'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              request['status'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('شاشة موظف المياه'),
        backgroundColor: const Color.fromARGB(255, 0, 150, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCitizens,
            tooltip: 'تحديث القائمة',
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث باسم العميل أو البريد الإلكتروني...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // أشرطة التبويب
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabButton('العملاء', 0, Icons.people),
                  _buildTabButton('الفواتير', 1, Icons.receipt),
                  _buildTabButton('الطلبات', 2, Icons.assignment),
                  _buildTabButton('التقارير', 3, Icons.analytics),
                  _buildTabButton('جودة المياه', 4, Icons.health_and_safety),
                ],
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildCurrentTabContent(),
          ),
        ],
      ),
      floatingActionButton: _selectedTabIndex == 1
          ? FloatingActionButton(
              onPressed: _showCreateBillDialog,
              backgroundColor: const Color.fromARGB(255, 0, 150, 255),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : _selectedTabIndex == 2
          ? FloatingActionButton(
              onPressed: _showCreateRequestDialog,
              backgroundColor: const Color.fromARGB(255, 0, 150, 255),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildTabButton(String title, int index, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color.fromARGB(255, 0, 150, 255)
            : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isSelected
                ? const Color.fromARGB(255, 0, 150, 255)
                : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: isSelected ? Colors.white : Colors.grey),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildCustomersTab();
      case 1:
        return _buildBillsTab();
      case 2:
        return _buildRequestsTab();
      case 3:
        return _buildReportsTab();
      case 4:
        return _buildWaterQualityTab();
      default:
        return const Center(child: Text('غير متوفر'));
    }
  }

  Widget _buildCustomersTab() {
    return _filteredCitizens.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا يوجد عملاء مسجلين في قسم المياه',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredCitizens.length,
            itemBuilder: (context, index) {
              final citizen = _filteredCitizens[index];
              return _buildCustomerCard(citizen);
            },
          );
  }

  Widget _buildBillsTab() {
    return _filteredBills.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا يوجد فواتير',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredBills.length,
            itemBuilder: (context, index) {
              final bill = _filteredBills[index];
              return _buildBillCard(bill);
            },
          );
  }

  Widget _buildRequestsTab() {
    return _filteredRequests.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا يوجد طلبات',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredRequests.length,
            itemBuilder: (context, index) {
              final request = _filteredRequests[index];
              return _buildRequestCard(request);
            },
          );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReportCard(
            title: 'إحصائيات العملاء',
            icon: Icons.people,
            value: '${_waterCitizens.length} عميل',
            color: Colors.blue,
          ),
          _buildReportCard(
            title: 'الفواتير غير المدفوعة',
            icon: Icons.money_off,
            value:
                '${_bills.where((b) => b['status'] != 'مدفوعة').length} فاتورة',
            color: Colors.red,
          ),
          _buildReportCard(
            title: 'الطلبات النشطة',
            icon: Icons.assignment,
            value:
                '${_requests.where((r) => r['status'] == 'قيد المعalجة').length} طلب',
            color: Colors.orange,
          ),
          _buildReportCard(
            title: 'إجمالي الإيرادات',
            icon: Icons.attach_money,
            value: '${_calculateTotalRevenue().toStringAsFixed(2)} دينار',
            color: Colors.green,
          ),
          _buildReportCard(
            title: 'إجمالي الاستهلاك',
            icon: Icons.water_drop,
            value: '${_calculateTotalConsumption()} لتر',
            color: const Color.fromARGB(255, 0, 150, 255),
          ),
          const SizedBox(height: 20),
          const Text(
            'توزيع الاستهلاك',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildConsumptionChart(),
        ],
      ),
    );
  }

  Widget _buildWaterQualityTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _waterQuality.length,
      itemBuilder: (context, index) {
        final quality = _waterQuality[index];
        return _buildWaterQualityCard(quality);
      },
    );
  }

  Widget _buildCustomerCard(Citizen citizen) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(
                    255,
                    0,
                    150,
                    255,
                  ).withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 0, 150, 255),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        citizen.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        citizen.email,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.blue),
                  onPressed: () => _showCustomerDetails(citizen),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip('فواتير غير مدفوعة', '2', Colors.red),
                const SizedBox(width: 8),
                _buildInfoChip('طلبات نشطة', '1', Colors.orange),
                const SizedBox(width: 8),
                _buildInfoChip('استهلاك', '250 لتر', Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillCard(Map<String, dynamic> bill) {
    final dueDate = bill['dueDate'] as DateTime;
    final isOverdue = dueDate.isBefore(DateTime.now());
    final statusColor = bill['status'] == 'مدفوعة'
        ? Colors.green
        : isOverdue
        ? Colors.red
        : Colors.orange;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'فاتورة #${bill['id']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    bill['status'],
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(bill['customerName']),
                const SizedBox(width: 16),
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(bill['customerEmail']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.water_drop, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(bill['consumption']),
                const SizedBox(width: 16),
                const Icon(Icons.speed, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('عداد: ${bill['meterReading']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('${bill['amount']} دينار'),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('استحقاق: ${DateFormat('yyyy-MM-dd').format(dueDate)}'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (bill['status'] != 'مدفوعة')
                  ElevatedButton(
                    onPressed: () => _markBillAsPaid(bill['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('تم الدفع'),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editBill(bill),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    final priorityColor = request['priority'] == 'عالي'
        ? Colors.red
        : request['priority'] == 'متوسط'
        ? Colors.orange
        : Colors.green;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طلب #${request['id']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request['priority'],
                    style: TextStyle(
                      color: priorityColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(request['customerName']),
                const SizedBox(width: 16),
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(request['customerEmail']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('النوع: ${request['type']}'),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('المكان: ${request['location']}'),
              ],
            ),
            const SizedBox(height: 8),
            if (request['waterLoss'] != '0 لتر/ساعة')
              Row(
                children: [
                  const Icon(Icons.warning, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    'فقدان مياه: ${request['waterLoss']}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Text(
              'الوصف: ${request['description']}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'التاريخ: ${DateFormat('yyyy-MM-dd HH:mm').format(request['date'])}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (request['status'] != 'مكتمل')
                  ElevatedButton(
                    onPressed: () => _updateRequestStatus(request['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('تحديث الحالة'),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.green),
                  onPressed: () => _viewRequestDetails(request),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterQualityCard(Map<String, dynamic> quality) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  quality['area'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: quality['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    quality['status'],
                    style: TextStyle(
                      color: quality['color'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildQualityItem(
                  'العكورة',
                  quality['turbidity'],
                  Icons.opacity,
                ),
                _buildQualityItem(
                  'الأس الهيدروجيني',
                  quality['ph'],
                  Icons.science,
                ),
                _buildQualityItem(
                  'الكلور',
                  quality['chlorine'],
                  Icons.clean_hands,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'آخر فحص: ${DateFormat('yyyy-MM-dd').format(quality['lastTest'])}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
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
                    value,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsumptionChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: const Column(
        children: [
          Text('رسم بياني لاستهلاك المياه'),
          SizedBox(height: 16),
          Center(child: Icon(Icons.bar_chart, size: 64, color: Colors.grey)),
          SizedBox(height: 8),
          Text('مخطط الاستهلاك الشهري', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: color)),
          const SizedBox(width: 4),
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

  double _calculateTotalRevenue() {
    return _bills
        .where((bill) => bill['status'] == 'مدفوعة')
        .fold(0.0, (sum, bill) => sum + (bill['amount'] as double));
  }

  String _calculateTotalConsumption() {
    final total = _bills.fold(0, (sum, bill) {
      final consumption = int.parse(
        bill['consumption'].toString().split(' ')[0],
      );
      return sum + consumption;
    });
    return total.toString();
  }

  void _showCustomerDetails(Citizen citizen) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل العميل'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('الاسم', citizen.name),
              _buildDetailRow('البريد الإلكتروني', citizen.email),
              _buildDetailRow('القسم', citizen.department),
              _buildDetailRow(
                'تاريخ التسجيل',
                DateFormat('yyyy-MM-dd').format(citizen.registrationDate),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _markBillAsPaid(String billId) {
    setState(() {
      final bill = _bills.firstWhere((b) => b['id'] == billId);
      bill['status'] = 'مدفوعة';
      bill['paidDate'] = DateTime.now();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تحديث حالة الفاتورة إلى مدفوعة'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _editBill(Map<String, dynamic> bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الفاتورة'),
        content: const Text('ميزة تعديل الفاتورة قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _updateRequestStatus(String requestId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحديث حالة الطلب'),
        content: const Text('ميزة تحديث حالة الطلب قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _viewRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل الطلب'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('رقم الطلب', request['id']),
              _buildDetailRow('العميل', request['customerName']),
              _buildDetailRow('البريد الإلكتروني', request['customerEmail']),
              _buildDetailRow('النوع', request['type']),
              _buildDetailRow('الحالة', request['status']),
              _buildDetailRow('الأولوية', request['priority']),
              _buildDetailRow('الموقع', request['location']),
              if (request['waterLoss'] != '0 لتر/ساعة')
                _buildDetailRow('فقدان المياه', request['waterLoss']),
              _buildDetailRow('الوصف', request['description']),
              _buildDetailRow(
                'التاريخ',
                DateFormat('yyyy-MM-dd HH:mm').format(request['date']),
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

  void _showCreateBillDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء فاتورة جديدة'),
        content: const Text('ميزة إنشاء الفواتير قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showCreateRequestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء طلب جديد'),
        content: const Text('ميزة إنشاء الطلبات قيد التطوير'),
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

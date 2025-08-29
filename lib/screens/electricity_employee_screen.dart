import 'package:flutter/material.dart';
import 'package:mang_mu/screens/citizen_service.dart';
import 'package:mang_mu/screens/citizen_model.dart';
import 'package:intl/intl.dart';

class ElectricityEmployeeScreen extends StatefulWidget {
  static const String screenRoute = 'electricity_employee_screen';

  const ElectricityEmployeeScreen({super.key});

  @override
  State<ElectricityEmployeeScreen> createState() =>
      _ElectricityEmployeeScreenState();
}

class _ElectricityEmployeeScreenState extends State<ElectricityEmployeeScreen> {
  List<Citizen> _electricityCitizens = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _selectedTabIndex =
      0; // 0: الفواتير, 1: المدفوعات, 2: الإبلاغات, 3: العروض والهدايا

  // بيانات الفواتير
  final List<Map<String, dynamic>> _bills = [];
  int _nextBillId = 1;

  // بيانات المدفوعات
  final List<Map<String, dynamic>> _payments = [];

  // بيانات الإبلاغات
  final List<Map<String, dynamic>> _reports = [];
  int _nextReportId = 1;

  // بيانات العروض والهدايا
  final List<Map<String, dynamic>> _offers = [];
  int _nextOfferId = 1;

  // متغيرات للفواتير الجديدة
  final TextEditingController _billCustomerController = TextEditingController();
  final TextEditingController _billAmountController = TextEditingController();
  final TextEditingController _billConsumptionController =
      TextEditingController();
  DateTime _selectedBillDate = DateTime.now();
  String _selectedBillStatus = 'غير مدفوعة';

  @override
  void initState() {
    super.initState();
    _loadCitizens();
    // إضافة بعض البيانات الافتراضية للعرض
    _addSampleData();
  }

  void _addSampleData() {
    // إضافة فواتير نموذجية
    _bills.addAll([
      {
        'id': 'B${_nextBillId++}',
        'customerName': 'أحمد محمد',
        'customerEmail': 'ahmed@example.com',
        'amount': 150.75,
        'consumption': '250 ك.و.س',
        'dueDate': DateTime.now().add(const Duration(days: 15)),
        'status': 'غير مدفوعة',
        'createdDate': DateTime.now().subtract(const Duration(days: 10)),
        'lateFee': 0.0,
      },
      {
        'id': 'B${_nextBillId++}',
        'customerName': 'فاطمة علي',
        'customerEmail': 'fatima@example.com',
        'amount': 230.50,
        'consumption': '380 ك.و.س',
        'dueDate': DateTime.now().subtract(const Duration(days: 5)),
        'status': 'مدفوعة',
        'createdDate': DateTime.now().subtract(const Duration(days: 35)),
        'paidDate': DateTime.now().subtract(const Duration(days: 2)),
        'lateFee': 11.53, // 5% من المبلغ
      },
    ]);

    // إضافة مدفوعات نموذجية
    _payments.addAll([
      {
        'id': 'P1',
        'billId': 'B2',
        'customerName': 'فاطمة علي',
        'amount': 230.50,
        'paymentDate': DateTime.now().subtract(const Duration(days: 2)),
        'method': 'بطاقة ائتمان',
        'lateFee': 11.53,
        'totalAmount': 242.03,
      },
    ]);

    // إضافة إبلاغات نموذجية
    _reports.addAll([
      {
        'id': 'R${_nextReportId++}',
        'customerName': 'سعيد خالد',
        'customerEmail': 'saied@example.com',
        'type': 'عطل في العداد',
        'description': 'العداد لا يعمل بشكل صحيح ويظهر قراءات خاطئة',
        'status': 'قيد المعالجة',
        'priority': 'عالي',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'location': 'حي الرياض، شارع الملك فهد',
      },
    ]);

    // إضافة عروض وهدايا نموذجية
    _offers.addAll([
      {
        'id': 'O${_nextOfferId++}',
        'customerName': 'لمياء حسن',
        'customerEmail': 'lamia@example.com',
        'offerType': 'هدية',
        'description': 'خصم 10% على الفاتورة القادمة لانتظامها في الدفع',
        'value': 10.0,
        'status': 'نشط',
        'startDate': DateTime.now(),
        'endDate': DateTime.now().add(const Duration(days: 30)),
      },
    ]);
  }

  void _loadCitizens() {
    // جلب المواطنين المسجلين في قسم الكهرباء
    final citizens = CitizenService.getCitizensByDepartment('كهرباء');
    setState(() {
      _electricityCitizens = citizens;
      _isLoading = false;
    });
  }

  void _refreshCitizens() {
    setState(() {
      _isLoading = true;
    });
    _loadCitizens();
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

  List<Map<String, dynamic>> get _filteredPayments {
    if (_searchQuery.isEmpty) {
      return _payments;
    }
    return _payments
        .where(
          (payment) =>
              payment['customerName'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              payment['method'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  List<Map<String, dynamic>> get _filteredReports {
    if (_searchQuery.isEmpty) {
      return _reports;
    }
    return _reports
        .where(
          (report) =>
              report['customerName'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              report['type'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              report['status'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  List<Map<String, dynamic>> get _filteredOffers {
    if (_searchQuery.isEmpty) {
      return _offers;
    }
    return _offers
        .where(
          (offer) =>
              offer['customerName'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              offer['offerType'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              offer['status'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نظام إدارة الكهرباء'),
        backgroundColor: const Color.fromARGB(255, 17, 126, 117),
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
            child: Row(
              children: [
                _buildTabButton('الفواتير', 0, Icons.receipt),
                _buildTabButton('المدفوعات', 1, Icons.payment),
                _buildTabButton('الإبلاغات', 2, Icons.report_problem),
                _buildTabButton('العروض والهدايا', 3, Icons.card_giftcard),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildCurrentTabContent(),
          ),
        ],
      ),
      floatingActionButton: _selectedTabIndex == 0
          ? FloatingActionButton(
              onPressed: _showCreateBillDialog,
              backgroundColor: const Color.fromARGB(255, 17, 126, 117),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : _selectedTabIndex == 2
          ? FloatingActionButton(
              onPressed: _showCreateReportDialog,
              backgroundColor: const Color.fromARGB(255, 17, 126, 117),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildTabButton(String title, int index, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 17, 126, 117)
                : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? const Color.fromARGB(255, 17, 126, 117)
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : Colors.grey,
              ),
              const SizedBox(height: 4),
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
        ),
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildBillsTab();
      case 1:
        return _buildPaymentsTab();
      case 2:
        return _buildReportsTab();
      case 3:
        return _buildOffersTab();
      default:
        return const Center(child: Text('غير متوفر'));
    }
  }

  Widget _buildBillsTab() {
    final paidBills = _filteredBills
        .where((bill) => bill['status'] == 'مدفوعة')
        .toList();
    final unpaidBills = _filteredBills
        .where((bill) => bill['status'] != 'مدفوعة')
        .toList();
    final overdueBills = _filteredBills
        .where(
          (bill) =>
              bill['status'] != 'مدفوعة' &&
              (bill['dueDate'] as DateTime).isBefore(DateTime.now()),
        )
        .toList();

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(text: 'جميع الفواتير'),
              Tab(text: 'غير المدفوعة'),
              Tab(text: 'المتأخرة'),
            ],
            indicatorColor: const Color.fromARGB(255, 17, 126, 117),
            labelColor: const Color.fromARGB(255, 17, 126, 117),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildBillsListView(_filteredBills, 'لا يوجد فواتير'),
                _buildBillsListView(unpaidBills, 'لا يوجد فواتير غير مدفوعة'),
                _buildBillsListView(overdueBills, 'لا يوجد فواتير متأخرة'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsListView(
    List<Map<String, dynamic>> bills,
    String emptyMessage,
  ) {
    return bills.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.receipt_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  emptyMessage,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bills.length,
            itemBuilder: (context, index) {
              final bill = bills[index];
              return _buildBillCard(bill);
            },
          );
  }

  Widget _buildPaymentsTab() {
    return _filteredPayments.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payment_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا يوجد مدفوعات',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredPayments.length,
            itemBuilder: (context, index) {
              final payment = _filteredPayments[index];
              return _buildPaymentCard(payment);
            },
          );
  }

  Widget _buildReportsTab() {
    return _filteredReports.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.report_problem_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'لا يوجد إبلاغات',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredReports.length,
            itemBuilder: (context, index) {
              final report = _filteredReports[index];
              return _buildReportCard(report);
            },
          );
  }

  Widget _buildOffersTab() {
    return _filteredOffers.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.card_giftcard_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'لا يوجد عروض أو هدايا',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredOffers.length,
            itemBuilder: (context, index) {
              final offer = _filteredOffers[index];
              return _buildOfferCard(offer);
            },
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
                const Icon(Icons.bolt, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(bill['consumption']),
                const SizedBox(width: 16),
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('${bill['amount']} دينار'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('استحقاق: ${DateFormat('yyyy-MM-dd').format(dueDate)}'),
              ],
            ),
            if (bill['lateFee'] > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'ضريبة تأخير: ${bill['lateFee']} دينار',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (bill['status'] != 'مدفوعة')
                  ElevatedButton(
                    onPressed: () => _processPayment(bill),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('معالجة الدفع'),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.blue),
                  onPressed: () => _viewBillDetails(bill),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteBill(bill['id']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> payment) {
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
                  'دفعة #${payment['id']}',
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
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'مكتمل',
                    style: TextStyle(
                      color: Colors.green,
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
                Text(payment['customerName']),
                const SizedBox(width: 16),
                const Icon(Icons.receipt, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('فاتورة #${payment['billId']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('المبلغ: ${payment['amount']} دينار'),
                const SizedBox(width: 16),
                const Icon(Icons.credit_card, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('الطريقة: ${payment['method']}'),
              ],
            ),
            const SizedBox(height: 8),
            if (payment['lateFee'] > 0)
              Text(
                'ضريبة تأخير: ${payment['lateFee']} دينار',
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 8),
            Text(
              'المبلغ الإجمالي: ${payment['totalAmount']} دينار',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'تاريخ الدفع: ${DateFormat('yyyy-MM-dd HH:mm').format(payment['paymentDate'])}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final priorityColor = report['priority'] == 'عالي'
        ? Colors.red
        : report['priority'] == 'متوسط'
        ? Colors.orange
        : Colors.green;

    final statusColor = report['status'] == 'مكتمل'
        ? Colors.green
        : report['status'] == 'قيد المعالجة'
        ? Colors.blue
        : Colors.grey;

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
                  'إبلاغ #${report['id']}',
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
                    report['priority'],
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
                Text(report['customerName']),
                const SizedBox(width: 16),
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(report['customerEmail']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('النوع: ${report['type']}'),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    report['status'],
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'الوصف: ${report['description']}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'الموقع: ${report['location']}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'التاريخ: ${DateFormat('yyyy-MM-dd HH:mm').format(report['date'])}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (report['status'] != 'مكتمل')
                  ElevatedButton(
                    onPressed: () => _updateReportStatus(report['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('تحديث الحالة'),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.green),
                  onPressed: () => _viewReportDetails(report),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteReport(report['id']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    final statusColor = offer['status'] == 'نشط'
        ? Colors.green
        : offer['status'] == 'منتهي'
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
                  'عرض #${offer['id']}',
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
                    offer['status'],
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
                Text(offer['customerName']),
                const SizedBox(width: 16),
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(offer['customerEmail']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('النوع: ${offer['offerType']}'),
                const SizedBox(width: 16),
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('القيمة: ${offer['value']}%'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'الوصف: ${offer['description']}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'من: ${DateFormat('yyyy-MM-dd').format(offer['startDate'])}',
                ),
                const SizedBox(width: 16),
                Text(
                  'إلى: ${DateFormat('yyyy-MM-dd').format(offer['endDate'])}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => _applyOffer(offer['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('تطبيق العرض'),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editOffer(offer),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteOffer(offer['id']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(Map<String, dynamic> bill) {
    final dueDate = bill['dueDate'] as DateTime;
    final isOverdue = dueDate.isBefore(DateTime.now());
    double lateFee = 0.0;

    if (isOverdue) {
      // حساب ضريبة التأخير (5% من المبلغ)
      lateFee = (bill['amount'] as double) * 0.05;
    }

    final totalAmount = (bill['amount'] as double) + lateFee;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('معالجة الدفع'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('العميل: ${bill['customerName']}'),
            Text('مبلغ الفاتورة: ${bill['amount']} دينار'),
            if (lateFee > 0)
              Text(
                'ضريبة التأخير: $lateFee دينار',
                style: const TextStyle(color: Colors.red),
              ),
            Text(
              'المبلغ الإجمالي: $totalAmount دينار',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('اختر طريقة الدفع:'),
            DropdownButtonFormField<String>(
              value: 'بطاقة ائتمان',
              items: ['بطاقة ائتمان', 'تحويل بنكي', 'نقدي', 'محفظة إلكترونية']
                  .map(
                    (method) =>
                        DropdownMenuItem(value: method, child: Text(method)),
                  )
                  .toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
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
              // إنشاء سجل الدفع
              final payment = {
                'id': 'P${_payments.length + 1}',
                'billId': bill['id'],
                'customerName': bill['customerName'],
                'amount': bill['amount'],
                'paymentDate': DateTime.now(),
                'method': 'بطاقة ائتمان',
                'lateFee': lateFee,
                'totalAmount': totalAmount,
              };

              setState(() {
                _payments.add(payment);
                bill['status'] = 'مدفوعة';
                bill['paidDate'] = DateTime.now();
                bill['lateFee'] = lateFee;
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم معالجة الدفع بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('تأكيد الدفع'),
          ),
        ],
      ),
    );
  }

  void _viewBillDetails(Map<String, dynamic> bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل الفاتورة'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('رقم الفاتورة', bill['id']),
              _buildDetailRow('العميل', bill['customerName']),
              _buildDetailRow('البريد الإلكتروني', bill['customerEmail']),
              _buildDetailRow('الاستهلاك', bill['consumption']),
              _buildDetailRow('المبلغ', '${bill['amount']} دينار'),
              if (bill['lateFee'] > 0)
                _buildDetailRow('ضريبة التأخير', '${bill['lateFee']} دينار'),
              _buildDetailRow(
                'تاريخ الاستحقاق',
                DateFormat('yyyy-MM-dd').format(bill['dueDate']),
              ),
              _buildDetailRow('الحالة', bill['status']),
              if (bill['paidDate'] != null)
                _buildDetailRow(
                  'تاريخ الدفع',
                  DateFormat('yyyy-MM-dd').format(bill['paidDate']),
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

  void _deleteBill(String billId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الفاتورة'),
        content: const Text('هل أنت متأكد من أنك تريد حذف هذه الفاتورة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _bills.removeWhere((bill) => bill['id'] == billId);
                _payments.removeWhere((payment) => payment['billId'] == billId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف الفاتورة بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _updateReportStatus(String reportId) {
    final report = _reports.firstWhere((r) => r['id'] == reportId);
    final currentStatus = report['status'];
    String newStatus = currentStatus;

    if (currentStatus == 'قيد المعالجة') {
      newStatus = 'مكتمل';
    } else if (currentStatus == 'مكتمل') {
      newStatus = 'ملغي';
    } else {
      newStatus = 'قيد المعالجة';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحديث حالة الإبلاغ'),
        content: Text(
          'تغيير حالة الإبلاغ من "$currentStatus" إلى "$newStatus"',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                report['status'] = newStatus;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تحديث حالة الإبلاغ إلى $newStatus'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _deleteReport(String reportId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الإبلاغ'),
        content: const Text('هل أنت متأكد من أنك تريد حذف هذا الإبلاغ؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _reports.removeWhere((report) => report['id'] == reportId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف الإبلاغ بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _viewReportDetails(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل الإبلاغ'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('رقم الإبلاغ', report['id']),
              _buildDetailRow('العميل', report['customerName']),
              _buildDetailRow('البريد الإلكتروني', report['customerEmail']),
              _buildDetailRow('النوع', report['type']),
              _buildDetailRow('الحالة', report['status']),
              _buildDetailRow('الأولوية', report['priority']),
              _buildDetailRow('الوصف', report['description']),
              _buildDetailRow('الموقع', report['location']),
              _buildDetailRow(
                'التاريخ',
                DateFormat('yyyy-MM-dd HH:mm').format(report['date']),
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

  void _applyOffer(String offerId) {
    final offer = _offers.firstWhere((o) => o['id'] == offerId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تطبيق العرض'),
        content: Text(
          'هل تريد تطبيق عرض ${offer['offerType']} بقيمة ${offer['value']}% للعميل ${offer['customerName']}؟',
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
                  content: Text(
                    'تم تطبيق العرض على فواتير ${offer['customerName']}',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('تطبيق'),
          ),
        ],
      ),
    );
  }

  void _editOffer(Map<String, dynamic> offer) {
    // تنفيذ منطق تعديل العرض
  }

  void _deleteOffer(String offerId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف العرض'),
        content: const Text('هل أنت متأكد من أنك تريد حذف هذا العرض؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _offers.removeWhere((offer) => offer['id'] == offerId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف العرض بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
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

  void _showCreateBillDialog() {
    _billCustomerController.clear();
    _billAmountController.clear();
    _billConsumptionController.clear();
    _selectedBillDate = DateTime.now().add(const Duration(days: 30));
    _selectedBillStatus = 'غير مدفوعة';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('إنشاء فاتورة جديدة'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _electricityCitizens.isNotEmpty
                        ? _electricityCitizens.first.email
                        : '',
                    items: _electricityCitizens
                        .map(
                          (citizen) => DropdownMenuItem(
                            value: citizen.email,
                            child: Text('${citizen.name} (${citizen.email})'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      final citizen = _electricityCitizens.firstWhere(
                        (c) => c.email == value,
                      );
                      _billCustomerController.text = citizen.name;
                    },
                    decoration: const InputDecoration(
                      labelText: 'اختر العميل',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _billCustomerController,
                    decoration: const InputDecoration(
                      labelText: 'اسم العميل',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _billAmountController,
                    decoration: const InputDecoration(
                      labelText: 'المبلغ (دينار)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _billConsumptionController,
                    decoration: const InputDecoration(
                      labelText: 'الاستهلاك (ك.و.س)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('تاريخ الاستحقاق:'),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedBillDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _selectedBillDate = selectedDate;
                            });
                          }
                        },
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(_selectedBillDate),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_billCustomerController.text.isNotEmpty &&
                      _billAmountController.text.isNotEmpty &&
                      _billConsumptionController.text.isNotEmpty) {
                    final newBill = {
                      'id': 'B${_nextBillId++}',
                      'customerName': _billCustomerController.text,
                      'customerEmail': _electricityCitizens.isNotEmpty
                          ? _electricityCitizens
                                .firstWhere(
                                  (c) => c.name == _billCustomerController.text,
                                )
                                .email
                          : '',
                      'amount': double.parse(_billAmountController.text),
                      'consumption': '${_billConsumptionController.text} ك.و.س',
                      'dueDate': _selectedBillDate,
                      'status': _selectedBillStatus,
                      'createdDate': DateTime.now(),
                      'lateFee': 0.0,
                    };

                    setState(() {
                      _bills.add(newBill);
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إنشاء الفاتورة بنجاح'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('إنشاء'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCreateReportDialog() {
    // تنفيذ منطق إنشاء إبلاغ جديد
  }

  @override
  void dispose() {
    _billCustomerController.dispose();
    _billAmountController.dispose();
    _billConsumptionController.dispose();
    super.dispose();
  }
}

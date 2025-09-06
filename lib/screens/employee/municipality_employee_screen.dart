import 'package:flutter/material.dart';
import 'package:mang_mu/screens/user/citizen_service.dart';
import 'package:mang_mu/screens/user/citizen_model.dart';
import 'package:intl/intl.dart';

class MunicipalityEmployeeScreen extends StatefulWidget {
  static const String screenRoute = 'municipality_employee_screen';

  const MunicipalityEmployeeScreen({super.key});

  @override
  State<MunicipalityEmployeeScreen> createState() =>
      _MunicipalityEmployeeScreenState();
}

class _MunicipalityEmployeeScreenState
    extends State<MunicipalityEmployeeScreen> {
  List<Citizen> _municipalityCitizens = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _selectedTabIndex =
      0; // 0: العملاء, 1: الحاويات , 2: التراخيص, 3: الشكاوى, 4: النظافة, 5: التقارير

  // بيانات الحاويات الافتراضية
  List<Map<String, dynamic>> _containers = [
    {
      'id': '1',
      'customerName': 'محمد أحمد',
      'customerEmail': 'mohamed@example.com',
      'type': 'صغيرة (120 لتر)',
      'status': 'قيد المعالجة',
      'requestDate': DateTime.now().subtract(const Duration(days: 5)),
      'address': 'شارع الملك فهد - الرياض',
      'isFirstContainer': true,
      'price': 0,
      'dimensions': '60x60x80 سم',
    },
  ];

  // بيانات التراخيص الافتراضية
  final List<Map<String, dynamic>> _licenses = [
    {
      'id': 'L001',
      'businessName': 'مطعم الريان',
      'ownerName': 'أحمد السعدي',
      'licenseType': 'مطعم',
      'status': 'نشط',
      'issueDate': DateTime(2023, 1, 15),
      'expiryDate': DateTime(2024, 1, 15),
      'annualFee': 5000,
      'address': 'شارع التحلية - الرياض',
    },
  ];

  // بيانات الشكاوى الافتراضية
  List<Map<String, dynamic>> _complaints = [
    {
      'id': 'C001',
      'customerName': 'خالد الفيصل',
      'customerEmail': 'khaled@example.com',
      'type': 'تراكم النفايات',
      'status': 'قيد المعالجة',
      'date': DateTime.now().subtract(const Duration(hours: 3)),
      'priority': 'عالي',
      'location': 'شارع العليا - الرياض',
      'description': 'تراكم النفايات لمدة 3 أيام',
    },
  ];

  // بيانات جدول النظافة
  final List<Map<String, dynamic>> _cleaningSchedule = [
    {
      'area': 'حي الملقا',
      'schedule': 'يومياً - 8:00 صباحاً',
      'team': 'الفريق أ',
      'lastCleaning': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'منتظم',
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCitizens();
  }

  void _loadCitizens() {
    // جلب المواطنين المسجلين في قسم البلدية
    final citizens = CitizenService.getCitizensByDepartment('بلدية');
    setState(() {
      _municipalityCitizens = citizens;
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
      return _municipalityCitizens;
    }
    return _municipalityCitizens
        .where(
          (citizen) =>
              citizen.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              citizen.email.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  List<Map<String, dynamic>> get _filteredContainers {
    if (_searchQuery.isEmpty) {
      return _containers;
    }
    return _containers
        .where(
          (container) =>
              container['customerName'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              container['customerEmail'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              container['status'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  List<Map<String, dynamic>> get _filteredLicenses {
    if (_searchQuery.isEmpty) {
      return _licenses;
    }
    return _licenses
        .where(
          (license) =>
              license['businessName'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              license['ownerName'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              license['status'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  List<Map<String, dynamic>> get _filteredComplaints {
    if (_searchQuery.isEmpty) {
      return _complaints;
    }
    return _complaints
        .where(
          (complaint) =>
              complaint['customerName'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              complaint['customerEmail'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              complaint['type'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              complaint['status'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('شاشة موظف البلدية'),
        backgroundColor: const Color.fromARGB(255, 76, 175, 80),
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
                  _buildTabButton('الحاويات', 1, Icons.delete),
                  _buildTabButton('التراخيص', 2, Icons.business),
                  _buildTabButton('الشكاوى', 3, Icons.report_problem),
                  _buildTabButton('النظافة', 4, Icons.clean_hands),
                  _buildTabButton('التقارير', 5, Icons.analytics),
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
    );
  }

  Widget _buildTabButton(String title, int index, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 76, 175, 80)
              : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? const Color.fromARGB(255, 76, 175, 80)
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey,
            ),
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
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildCustomersTab();
      case 1:
        return _buildContainersTab();
      case 2:
        return _buildLicensesTab();
      case 3:
        return _buildComplaintsTab();
      case 4:
        return _buildCleaningTab();
      case 5:
        return _buildReportsTab();
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
                  'لا يوجد عملاء مسجلين في قسم البلدية',
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

  Widget _buildContainersTab() {
    return _filteredContainers.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا يوجد طلبات حاويات',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredContainers.length,
            itemBuilder: (context, index) {
              final container = _filteredContainers[index];
              return _buildContainerCard(container);
            },
          );
  }

  Widget _buildLicensesTab() {
    return _filteredLicenses.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا يوجد تراخيص',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredLicenses.length,
            itemBuilder: (context, index) {
              final license = _filteredLicenses[index];
              return _buildLicenseCard(license);
            },
          );
  }

  Widget _buildComplaintsTab() {
    return _filteredComplaints.isEmpty
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
                  'لا يوجد شكاوى',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredComplaints.length,
            itemBuilder: (context, index) {
              final complaint = _filteredComplaints[index];
              return _buildComplaintCard(complaint);
            },
          );
  }

  Widget _buildCleaningTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _cleaningSchedule.length,
      itemBuilder: (context, index) {
        final schedule = _cleaningSchedule[index];
        return _buildCleaningCard(schedule);
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
            value: '${_municipalityCitizens.length} عميل',
            color: Colors.blue,
          ),
          _buildReportCard(
            title: 'طلبات الحاويات',
            icon: Icons.delete,
            value: '${_containers.length} طلب',
            color: Colors.green,
          ),
          _buildReportCard(
            title: 'التراخيص النشطة',
            icon: Icons.business,
            value:
                '${_licenses.where((l) => l['status'] == 'نشط').length} ترخيص',
            color: Colors.orange,
          ),
          _buildReportCard(
            title: 'الشكاوى النشطة',
            icon: Icons.report_problem,
            value:
                '${_complaints.where((c) => c['status'] == 'قيد المعالجة').length} شكوى',
            color: Colors.red,
          ),
          _buildReportCard(
            title: 'إجمالي الإيرادات',
            icon: Icons.attach_money,
            value: '${_calculateTotalRevenue().toStringAsFixed(2)} دينار',
            color: Colors.green,
          ),
          const SizedBox(height: 20),
          const Text(
            'إحصائيات النظافة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildCleaningStats(),
        ],
      ),
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
                    76,
                    175,
                    80,
                  ).withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 76, 175, 80),
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
                _buildInfoChip('حاويات', '2', Colors.green),
                const SizedBox(width: 8),
                _buildInfoChip('تراخيص', '1', Colors.blue),
                const SizedBox(width: 8),
                _buildInfoChip('شكاوى', '0', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerCard(Map<String, dynamic> container) {
    final statusColor = container['status'] == 'مكتمل'
        ? Colors.green
        : container['status'] == 'قيد المعالجة'
            ? Colors.orange
            : Colors.red;

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
                  'طلب حاوية #${container['id']}',
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
                    container['status'],
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
                Text(container['customerName']),
                const SizedBox(width: 16),
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(container['customerEmail']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(container['type']),
                const SizedBox(width: 16),
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('${container['price']} دينار'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(container['address'])),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'التاريخ: ${DateFormat('yyyy-MM-dd').format(container['requestDate'])}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (container['status'] != 'مكتمل')
                  ElevatedButton(
                    onPressed: () => _updateContainerStatus(container['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('تحديث الحالة'),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.blue),
                  onPressed: () => _viewContainerDetails(container),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenseCard(Map<String, dynamic> license) {
    final statusColor = license['status'] == 'نشط'
        ? Colors.green
        : license['status'] == 'قيد التجديد'
            ? Colors.orange
            : Colors.red;

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
                  'ترخيص #${license['id']}',
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
                    license['status'],
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              license['businessName'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('المالك: ${license['ownerName']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('النوع: ${license['licenseType']}'),
                const SizedBox(width: 16),
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('الرسوم: ${license['annualFee']} دينار'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(license['address'])),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'الإصدار: ${DateFormat('yyyy-MM-dd').format(license['issueDate'])}',
                ),
                const SizedBox(width: 16),
                Text(
                  'الانتهاء: ${DateFormat('yyyy-MM-dd').format(license['expiryDate'])}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (license['status'] != 'نشط')
                  ElevatedButton(
                    onPressed: () => _renewLicense(license['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('تجديد'),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.green),
                  onPressed: () => _viewLicenseDetails(license),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintCard(Map<String, dynamic> complaint) {
    final priorityColor = complaint['priority'] == 'عالي'
        ? Colors.red
        : complaint['priority'] == 'متوسط'
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
                  'شكوى #${complaint['id']}',
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
                    complaint['priority'],
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
                Text(complaint['customerName']),
                const SizedBox(width: 16),
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(complaint['customerEmail']),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('النوع: ${complaint['type']}'),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(complaint['location']),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'الوصف: ${complaint['description']}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'التاريخ: ${DateFormat('yyyy-MM-dd HH:mm').format(complaint['date'])}',
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    complaint['status'],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (complaint['status'] != 'مكتمل')
                  ElevatedButton(
                    onPressed: () => _updateComplaintStatus(complaint['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('تحديث الحالة'),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.green),
                  onPressed: () => _viewComplaintDetails(complaint),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleaningCard(Map<String, dynamic> schedule) {
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
                  schedule['area'],
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
                    color: schedule['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    schedule['status'],
                    style: TextStyle(
                      color: schedule['color'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('الجدول: ${schedule['schedule']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.group, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('الفريق: ${schedule['team']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.cleaning_services,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  'آخر تنظيف: ${DateFormat('yyyy-MM-dd').format(schedule['lastCleaning'])}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: schedule['status'] == 'منتظم'
                  ? 1.0
                  : schedule['status'] == 'متأخر'
                      ? 0.5
                      : 0.2,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(schedule['color']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleaningStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('مناطق نظيفة', '15', Colors.green),
              _buildStatItem('مناطق متأخرة', '3', Colors.orange),
              _buildStatItem('مناطق متوقفة', '2', Colors.red),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'إحصائيات أداء النظافة',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
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
    double total = 0;
    total += _containers.fold(
      0.0,
      (sum, container) => sum + (container['price'] as num).toDouble(),
    );
    total += _licenses.fold(
      0.0,
      (sum, license) => sum + (license['annualFee'] as num).toDouble(),
    );
    return total;
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

  void _updateContainerStatus(String containerId) {
    String selectedStatus = 'مكتمل';
    String? notes;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('تحديث حالة طلب الحاوية'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('اختر الحالة الجديدة:'),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: ['قيد المعالجة', 'مكتمل', 'ملغى']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedStatus = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'الحالة',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ملاحظات (اختياري)',
                    ),
                    onChanged: (value) {
                      notes = value;
                    },
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
                  // تحديث حالة الحاوية
                  setState(() {
                    int index = _containers.indexWhere(
                      (container) => container['id'] == containerId,
                    );
                    if (index != -1) {
                      _containers[index]['status'] = selectedStatus;
                      if (notes != null && notes!.isNotEmpty) {
                        _containers[index]['notes'] = notes;
                      }
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم تحديث حالة الطلب إلى: $selectedStatus'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('تأكيد التحديث'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _viewContainerDetails(Map<String, dynamic> container) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل طلب الحاوية'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('رقم الطلب', container['id']),
              _buildDetailRow('العميل', container['customerName']),
              _buildDetailRow('البريد الإلكتروني', container['customerEmail']),
              _buildDetailRow('نوع الحاوية', container['type']),
              _buildDetailRow('الحالة', container['status']),
              _buildDetailRow('السعر', '${container['price']} دينار'),
              _buildDetailRow('الأبعاد', container['dimensions']),
              _buildDetailRow('العنوان', container['address']),
              _buildDetailRow(
                'تاريخ الطلب',
                DateFormat('yyyy-MM-dd').format(container['requestDate']),
              ),
              if (container['isFirstContainer'])
                _buildDetailRow('ملاحظة', 'الحاوية الأولى مجانية'),
              if (container['notes'] != null)
                _buildDetailRow('ملاحظات إضافية', container['notes']),
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

  void _renewLicense(String licenseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تجديد الترخيص'),
        content: const Text('ميزة تجديد التراخيص قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _viewLicenseDetails(Map<String, dynamic> license) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل الترخيص'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('رقم الترخيص', license['id']),
              _buildDetailRow('اسم المنشأة', license['businessName']),
              _buildDetailRow('اسم المالك', license['ownerName']),
              _buildDetailRow('نوع الترخيص', license['licenseType']),
              _buildDetailRow('الحالة', license['status']),
              _buildDetailRow(
                'الرسوم السنوية',
                '${license['annualFee']} دينار',
              ),
              _buildDetailRow('العنوان', license['address']),
              _buildDetailRow(
                'تاريخ الإصدار',
                DateFormat('yyyy-MM-dd').format(license['issueDate']),
              ),
              _buildDetailRow(
                'تاريخ الانتهاء',
                DateFormat('yyyy-MM-dd').format(license['expiryDate']),
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

  void _updateComplaintStatus(String complaintId) {
    String selectedStatus = 'مكتمل';
    String? resolutionNotes;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('تحديث حالة الشكوى'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('اختر الحالة الجديدة:'),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: ['قيد المعالجة', 'مكتمل', 'ملغى']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedStatus = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'الحالة',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ملاحظات الحل (اختياري)',
                    ),
                    onChanged: (value) {
                      resolutionNotes = value;
                    },
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
                  // تحديث حالة الشكوى
                  setState(() {
                    int index = _complaints.indexWhere(
                      (complaint) => complaint['id'] == complaintId,
                    );
                    if (index != -1) {
                      _complaints[index]['status'] = selectedStatus;
                      if (resolutionNotes != null &&
                          resolutionNotes!.isNotEmpty) {
                        _complaints[index]['resolutionNotes'] = resolutionNotes;
                      }
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم تحديث حالة الشكوى إلى: $selectedStatus',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('تأكيد التحديث'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _viewComplaintDetails(Map<String, dynamic> complaint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل الشكوى'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('رقم الشكوى', complaint['id']),
              _buildDetailRow('العميل', complaint['customerName']),
              _buildDetailRow('البريد الإلكتروني', complaint['customerEmail']),
              _buildDetailRow('نوع الشكوى', complaint['type']),
              _buildDetailRow('الحالة', complaint['status']),
              _buildDetailRow('الأولوية', complaint['priority']),
              _buildDetailRow('الموقع', complaint['location']),
              _buildDetailRow('الوصف', complaint['description']),
              _buildDetailRow(
                'التاريخ',
                DateFormat('yyyy-MM-dd HH:mm').format(complaint['date']),
              ),
              if (complaint['resolutionNotes'] != null)
                _buildDetailRow('ملاحظات الحل', complaint['resolutionNotes']),
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


  void _showCreateLicenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء ترخيص جديد'),
        content: const Text('ميزة إنشاء التراخيص قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showCreateComplaintDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل شكوى جديدة'),
        content: const Text('ميزة تسجيل الشكاوى قيد التطوير'),
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
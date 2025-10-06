// اخصائي خدمات مميزة
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PremiumServicesSpecialistScreen extends StatefulWidget {
  static const String routeName = '/premium-services-specialist';

  const PremiumServicesSpecialistScreen({super.key});

  @override
  State<PremiumServicesSpecialistScreen> createState() =>
      _PremiumServicesSpecialistScreenState();
}

class _PremiumServicesSpecialistScreenState
    extends State<PremiumServicesSpecialistScreen>
    with SingleTickerProviderStateMixin {
  // الألوان المستوحاة من التصميم الحكومي
  final Color _primaryColor = const Color(0xFF0D47A1);
  final Color _secondaryColor = const Color(0xFF1976D2);
  final Color _accentColor = const Color(0xFFFFA000); // لون مميز للعروض
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _borderColor = const Color(0xFFE0E0E0);

  late TabController _tabController;
  late TabController _requestsTabController;
  int _currentTabIndex = 0;
  int _currentRequestsTabIndex = 0;

  final List<Map<String, dynamic>> availableServices = [
    {
      'id': 'PREMIUM-001',
      'name': 'تركيب ألواح شمسية',
      'price': '5000 دينار',
      'duration': '5 أيام',
      'requests': 8,
      'rating': 4.8,
      'status': 'متاح',
      'icon': Icons.solar_power,
      'color': Colors.amber,
    },
    {
      'id': 'PREMIUM-002',
      'name': 'نظام مراقبة استهلاك',
      'price': '1500 دينار',
      'duration': '2 أيام',
      'requests': 12,
      'rating': 4.5,
      'status': 'متاح',
      'icon': Icons.monitor_heart,
      'color': Colors.blue,
    },
    {
      'id': 'PREMIUM-003',
      'name': 'عداد ذكي متقدم',
      'price': '2500 دينار',
      'duration': '3 أيام',
      'requests': 15,
      'rating': 4.7,
      'status': 'متاح',
      'icon': Icons.smartphone,
      'color': Colors.green,
    },
  ];

  List<Map<String, dynamic>> serviceRequests = [
    {
      'id': 'SR-001',
      'service': 'تركيب ألواح شمسية',
      'customer': 'محمد أحمد',
      'requestDate': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'قيد المعالجة',
      'priority': 'عالي',
      'address': 'حي الرياض، شارع الملك فهد',
    },
    {
      'id': 'SR-002',
      'service': 'نظام مراقبة استهلاك',
      'customer': 'سارة عبدالله',
      'requestDate': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'مقبول',
      'priority': 'متوسط',
      'address': 'حي النخيل، شارع الأمير محمد',
    },
    {
      'id': 'SR-003',
      'service': 'عداد ذكي متقدم',
      'customer': 'علي حسين',
      'requestDate': DateTime.now().subtract(const Duration(hours: 5)),
      'status': 'مكتمل',
      'priority': 'منخفض',
      'address': 'حي السلام، شارع الخليج',
    },
    {
      'id': 'SR-004',
      'service': 'تركيب ألواح شمسية',
      'customer': 'فاطمة خالد',
      'requestDate': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'ملغي',
      'priority': 'متوسط',
      'address': 'حي الورود، شارع الجامعة',
    },
  ];

  List<Map<String, dynamic>> get _stats => [
    {
      'title': 'الخدمات المتاحة',
      'value': '5',
      'icon': Icons.star,
      'color': Colors.amber,
    },
    {
      'title': 'طلبات الخدمات',
      'value': '15',
      'icon': Icons.request_page,
      'color': Colors.blue,
    },
    {
      'title': 'معدل الرضا',
      'value': '92%',
      'icon': Icons.thumb_up,
      'color': Colors.green,
    },
    {
      'title': 'الإيرادات',
      'value': '45,750',
      'icon': Icons.attach_money,
      'color': _successColor,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _requestsTabController = TabController(length: 4, vsync: this);
    
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    
    _requestsTabController.addListener(() {
      setState(() {
        _currentRequestsTabIndex = _requestsTabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _requestsTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('إدارة الخدمات المميزة والعروض'),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 3, color: _accentColor),
                ),
              ),
              labelColor: _accentColor,
              unselectedLabelColor: _textSecondaryColor,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'الخدمات المتاحة'),
                Tab(text: 'طلبات الخدمات'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // إحصائيات الخدمات
          _buildStatsSection(),

          // محتوى التبويبات
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // تبويب الخدمات المتاحة
                _buildAvailableServicesTab(),

                // تبويب طلبات الخدمات
                _buildServiceRequestsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddServiceDialog,
        backgroundColor: _accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _borderColor, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'نظرة عامة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _stats.length,
              itemBuilder: (context, index) {
                final stat = _stats[index];
                return Container(
                  width: 150,
                  margin: EdgeInsets.only(
                    left: index == _stats.length - 1 ? 0 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderColor, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(stat['icon'], size: 18, color: stat['color']),
                            const SizedBox(width: 6),
                            Text(
                              stat['value'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stat['title'],
                          style: TextStyle(
                            fontSize: 14,
                            color: _textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableServicesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: availableServices.length,
      itemBuilder: (context, index) {
        final service = availableServices[index];
        return _buildServiceCard(service);
      },
    );
  }

  Widget _buildServiceRequestsTab() {
    return Column(
      children: [
        // تبويبات الطلبات الداخلية
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _requestsTabController,
            isScrollable: true,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2, color: _primaryColor),
              ),
            ),
            labelColor: _primaryColor,
            unselectedLabelColor: _textSecondaryColor,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            tabs: const [
              Tab(text: 'قيد المعالجة'),
              Tab(text: 'مقبول'),
              Tab(text: 'مكتمل'),
              Tab(text: 'ملغي'),
            ],
          ),
        ),
        
        // محتوى تبويبات الطلبات
        Expanded(
          child: TabBarView(
            controller: _requestsTabController,
            children: [
              _buildRequestsByStatus('قيد المعالجة'),
              _buildRequestsByStatus('مقبول'),
              _buildRequestsByStatus('مكتمل'),
              _buildRequestsByStatus('ملغي'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestsByStatus(String status) {
    final filteredRequests = serviceRequests.where((request) => request['status'] == status).toList();
    
    if (filteredRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: _textSecondaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد طلبات $status',
              style: TextStyle(
                fontSize: 16,
                color: _textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredRequests.length,
      itemBuilder: (context, index) {
        final request = filteredRequests[index];
        return _buildServiceRequestCard(request);
      },
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: _borderColor, width: 1),
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
                    color: service['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    service['icon'],
                    color: service['color'],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
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
                      const SizedBox(height: 4),
                      Text(
                        'السعر: ${service['price']} • المدة: ${service['duration']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(service['status']),
                  backgroundColor: service['status'] == 'متاح'
                      ? _successColor.withOpacity(0.1)
                      : _warningColor.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: service['status'] == 'متاح'
                        ? _successColor
                        : _warningColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildRatingStars(service['rating']),
                const SizedBox(width: 8),
                Text(
                  '${service['rating']}',
                  style: TextStyle(color: _textSecondaryColor, fontSize: 14),
                ),
                const SizedBox(width: 16),
                Icon(Icons.request_page, size: 16, color: _textSecondaryColor),
                const SizedBox(width: 4),
                Text(
                  '${service['requests']} طلبات',
                  style: TextStyle(color: _textSecondaryColor, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _editService(service),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryColor,
                      side: BorderSide(color: _primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('تعديل'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _manageServiceRequests(service),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('إدارة الطلبات'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceRequestCard(Map<String, dynamic> request) {
    Color statusColor;
    switch (request['status']) {
      case 'مقبول':
        statusColor = _successColor;
        break;
      case 'قيد المعالجة':
        statusColor = _warningColor;
        break;
      case 'مكتمل':
        statusColor = _primaryColor;
        break;
      case 'ملغي':
        statusColor = _errorColor;
        break;
      default:
        statusColor = _textSecondaryColor;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: _borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: _primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['customer'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                      Text(
                        request['service'],
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(request['status']),
                  backgroundColor: statusColor.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: _textSecondaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('yyyy-MM-dd').format(request['requestDate']),
                  style: TextStyle(fontSize: 14, color: _textSecondaryColor),
                ),
                const SizedBox(width: 16),
                Icon(Icons.flag, size: 16, color: _textSecondaryColor),
                const SizedBox(width: 4),
                Text(
                  'الأولوية: ${request['priority']}',
                  style: TextStyle(fontSize: 14, color: _textSecondaryColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: _textSecondaryColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    request['address'],
                    style: TextStyle(fontSize: 14, color: _textSecondaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewRequestDetails(request),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryColor,
                      side: BorderSide(color: _primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('التفاصيل'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateRequestStatus(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('تحديث الحالة'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  void _showAddServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة خدمة جديدة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'اسم الخدمة',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'السعر',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'المدة',
                  border: OutlineInputBorder(),
                ),
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
              // إضافة الخدمة الجديدة
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم إضافة الخدمة بنجاح'),
                  backgroundColor: _successColor,
                ),
              );
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _editService(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعديل خدمة: ${service['name']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'اسم الخدمة',
                  border: const OutlineInputBorder(),
                  hintText: service['name'],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'السعر',
                  border: const OutlineInputBorder(),
                  hintText: service['price'],
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'المدة',
                  border: const OutlineInputBorder(),
                  hintText: service['duration'],
                ),
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
              // حفظ التعديلات
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم حفظ التعديلات بنجاح'),
                  backgroundColor: _successColor,
                ),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _manageServiceRequests(Map<String, dynamic> service) {
    // التنقل إلى شاشة إدارة طلبات الخدمة
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('إدارة طلبات خدمة: ${service['name']}'),
        backgroundColor: _primaryColor,
      ),
    );
  }

  void _viewRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الطلب: ${request['id']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('العميل: ${request['customer']}'),
              Text('الخدمة: ${request['service']}'),
              Text(
                'تاريخ الطلب: ${DateFormat('yyyy-MM-dd').format(request['requestDate'])}',
              ),
              Text('الحالة: ${request['status']}'),
              Text('الأولوية: ${request['priority']}'),
              Text('العنوان: ${request['address']}'),
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

  void _updateRequestStatus(Map<String, dynamic> request) {
    String? newStatus;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('تحديث حالة الطلب: ${request['id']}'),
            content: DropdownButtonFormField(
              value: newStatus ?? request['status'],
              items: ['قيد المعالجة', 'مقبول', 'مكتمل', 'ملغي']
                  .map(
                    (status) => DropdownMenuItem(value: status, child: Text(status)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  newStatus = value as String?;
                });
              },
              decoration: const InputDecoration(
                labelText: 'الحالة الجديدة',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (newStatus != null) {
                    setState(() {
                      request['status'] = newStatus;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('تم تحديث حالة الطلب بنجاح'),
                        backgroundColor: _successColor,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('يرجى اختيار حالة جديدة'),
                        backgroundColor: _errorColor,
                      ),
                    );
                  }
                },
                child: const Text('تحديث'),
              ),
            ],
          );
        },
      ),
    );
  }
}
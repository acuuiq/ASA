import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WasteCleaningWorkerScreen extends StatefulWidget {
  const WasteCleaningWorkerScreen({super.key});

  @override
  State<WasteCleaningWorkerScreen> createState() => _WasteCleaningWorkerScreenState();
}

class _WasteCleaningWorkerScreenState extends State<WasteCleaningWorkerScreen>
    with SingleTickerProviderStateMixin {  // إضافة Mixin
  // الألوان المستخدمة في التصميم
  final Color _primaryColor = const Color(0xFF2E7D32);
  final Color _secondaryColor = const Color(0xFF4CAF50);
  final Color _accentColor = const Color(0xFF8BC34A);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);

  late TabController _tabController;  // إضافة TabController
  int _currentTabIndex = 0;
  final List<String> _tabs = ['مهام اليوم', 'طلبات التسليم', 'بلاغات المعالجة', 'سجل الأداء'];

  // مهام اليوم
  final List<Map<String, dynamic>> _todayTasks = [
    {
      'time': '08:00 - 09:30',
      'area': 'المنطقة الشمالية - الحي السكني',
      'type': 'جمع النفايات',
      'status': 'مكتمل',
      'completed': true,
    },
    {
      'time': '10:00 - 11:30',
      'area': 'المنطقة التجارية - السوق المركزي',
      'type': 'جمع النفايات',
      'status': 'قيد التنفيذ',
      'completed': false,
    },
    {
      'time': '12:00 - 13:00',
      'area': 'حي الأندلس - شارع النخيل',
      'type': 'تسليم حاوية جديدة',
      'status': 'قيد الانتظار',
      'completed': false,
    },
    {
      'time': '14:00 - 15:00',
      'area': 'المنطقة الجنوبية',
      'type': 'صيانة حاوية تالفة',
      'status': 'قيد الانتظار',
      'completed': false,
    },
  ];

  // طلبات تسليم الحاويات
  final List<Map<String, dynamic>> _deliveryRequests = [
    {
      'customer': 'علي أحمد',
      'address': 'حي السلام - شارع 10 - منزل 25',
      'containerType': 'صغيرة (120 لتر)',
      'requestDate': '2023-10-15',
      'status': 'معلّق',
    },
    {
      'customer': 'سالم محمد',
      'address': 'حي النور - شارع 5 - منزل 12',
      'containerType': 'كبيرة (360 لتر)',
      'requestDate': '2023-10-14',
      'status': 'مكتمل',
    },
  ];

  // بلاغات تحتاج المعالجة
  final List<Map<String, dynamic>> _reportsToHandle = [
    {
      'type': 'حاوية ممتلئة',
      'address': 'حي الورود - شارع 8',
      'reporter': 'مواطن',
      'reportDate': '2023-10-15',
      'priority': 'عاجل',
    },
    {
      'type': 'حاوية تالفة',
      'address': 'حي الربيع - شارع 12',
      'reporter': 'بلدية المنطقة',
      'reportDate': '2023-10-14',
      'priority': 'متوسط',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);  // تهيئة TabController
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();  // التخلص من الـ controller عند إغلاق الصفحة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('لوحة تحكم عامل النظافة'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // شريط التبويبات
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,  // إضافة الـ controller
              onTap: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
              indicatorColor: _primaryColor,
              labelColor: _primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ),
          
          // محتوى التبويبات
          Expanded(
            child: TabBarView(
              controller: _tabController,  // إضافة الـ controller لـ TabBarView
              children: [
                // تبويب مهام اليوم
                _buildTodayTasksTab(),
                
                // تبويب طلبات التسليم
                _buildDeliveryRequestsTab(),
                
                // تبويب بلاغات المعالجة
                _buildReportsTab(),
                
                // تبويب سجل الأداء
                _buildPerformanceTab(),
              ],
            ),
          ),
        ],
      ),
      
      // زر الإجراء السريع
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showQuickActions(context);
        },
        backgroundColor: _primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // بناء واجهة مهام اليوم
  Widget _buildTodayTasksTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _todayTasks.length,
      itemBuilder: (context, index) {
        final task = _todayTasks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              _getTaskIcon(task['type']),
              color: _primaryColor,
            ),
            title: Text(
              task['type'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task['area']),
                Text('الوقت: ${task['time']}'),
                const SizedBox(height: 4),
                Chip(
                  label: Text(
                    task['status'],
                    style: TextStyle(
                      color: task['completed'] ? Colors.white : _textColor,
                    ),
                  ),
                  backgroundColor: task['completed'] ? _secondaryColor : Colors.amber[100],
                ),
              ],
            ),
            trailing: task['completed']
                ? const Icon(Icons.check_circle, color: Colors.green)
                : IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: () {
                      _completeTask(index);
                    },
                  ),
          ),
        );
      },
    );
  }

  // بناء واجهة طلبات التسليم
  Widget _buildDeliveryRequestsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _deliveryRequests.length,
      itemBuilder: (context, index) {
        final request = _deliveryRequests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.local_shipping, color: Colors.blue),
            title: Text(
              'تسليم حاوية ${request['containerType']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('العميل: ${request['customer']}'),
                Text('العنوان: ${request['address']}'),
                Text('تاريخ الطلب: ${request['requestDate']}'),
                const SizedBox(height: 4),
                Chip(
                  label: Text(request['status']),
                  backgroundColor: request['status'] == 'مكتمل' ? Colors.green[100] : Colors.orange[100],
                ),
              ],
            ),
            trailing: request['status'] != 'مكتمل'
                ? IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      _completeDelivery(index);
                    },
                  )
                : null,
          ),
        );
      },
    );
  }

  // بناء واجهة البلاغات
  Widget _buildReportsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _reportsToHandle.length,
      itemBuilder: (context, index) {
        final report = _reportsToHandle[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              Icons.warning,
              color: report['priority'] == 'عاجل' ? Colors.red : Colors.orange,
            ),
            title: Text(
              report['type'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('العنوان: ${report['address']}'),
                Text('المبلغ: ${report['reporter']}'),
                Text('تاريخ البلاغ: ${report['reportDate']}'),
                const SizedBox(height: 4),
                Chip(
                  label: Text(
                    report['priority'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: report['priority'] == 'عاجل' ? Colors.red : Colors.orange,
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.check_circle),
              onPressed: () {
                _resolveReport(index);
              },
            ),
          ),
        );
      },
    );
  }

  // بناء واجهة سجل الأداء
  Widget _buildPerformanceTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إحصائيات الأداء',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('المهام المكتملة', '24', Icons.task_alt),
              _buildStatCard('الحاويات المسلمة', '8', Icons.local_shipping),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('البلاغات المعالجة', '15', Icons.warning),
              _buildStatCard('التقييم العام', '4.8/5', Icons.star),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'أفضل المناطق أداءً',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const ListTile(
            leading: Icon(Icons.location_on, color: Colors.green),
            title: Text('المنطقة الشمالية'),
            subtitle: Text('أعلى تقييم: 4.9/5'),
          ),
          const ListTile(
            leading: Icon(Icons.location_on, color: Colors.blue),
            title: Text('المنطقة التجارية'),
            subtitle: Text('أعلى تقييم: 4.7/5'),
          ),
        ],
      ),
    );
  }

  // بناء بطاقة الإحصائيات
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: _primaryColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // الحصول على أيقونة المهمة
  IconData _getTaskIcon(String taskType) {
    switch (taskType) {
      case 'جمع النفايات':
        return Icons.delete;
      case 'تسليم حاوية جديدة':
        return Icons.local_shipping;
      case 'صيانة حاوية تالفة':
        return Icons.build;
      default:
        return Icons.task;
    }
  }

  // إكمال المهمة
  void _completeTask(int index) {
    setState(() {
      _todayTasks[index]['status'] = 'مكتمل';
      _todayTasks[index]['completed'] = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إكمال المهمة بنجاح')),
    );
  }

  // إكمال عملية التسليم
  void _completeDelivery(int index) {
    setState(() {
      _deliveryRequests[index]['status'] = 'مكتمل';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تسليم الحاوية بنجاح')),
    );
  }

  // معالجة البلاغ
  void _resolveReport(int index) {
    setState(() {
      _reportsToHandle.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم معالجة البلاغ بنجاح')),
    );
  }

  // عرض الإجراءات السريعة
  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add_task, color: Colors.green),
                title: const Text('تسجيل مهمة جديدة'),
                onTap: () {
                  Navigator.pop(context);
                  _addNewTask();
                },
              ),
              ListTile(
                leading: const Icon(Icons.report, color: Colors.orange),
                title: const Text('تسجيل بلاغ جديد'),
                onTap: () {
                  Navigator.pop(context);
                  _reportIssue();
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_shipping, color: Colors.blue),
                title: const Text('تسليم حاوية جديدة'),
                onTap: () {
                  Navigator.pop(context);
                  _deliverContainer();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // إضافة مهمة جديدة
  void _addNewTask() {
    // تنفيذ логика إضافة مهمة جديدة
  }

  // تسجيل بلاغ جديد
  void _reportIssue() {
    // تنفيذ логика تسجيل بلاغ جديد
  }

  // تسليم حاوية جديدة
  void _deliverContainer() {
    // تنفيذ логика تسليم حاوية جديدة
  }
}
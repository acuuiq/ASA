import 'package:flutter/material.dart';

class WasteCleaningWorkerScreen extends StatefulWidget {
  const WasteCleaningWorkerScreen({super.key});

  @override
  State<WasteCleaningWorkerScreen> createState() => _WasteCleaningWorkerScreenState();
}

class _WasteCleaningWorkerScreenState extends State<WasteCleaningWorkerScreen> {
  // الألوان المستخدمة في التصميم
  final Color _primaryColor = const Color.fromARGB(255, 48, 145, 169);
  final Color _secondaryColor = const Color(0xFF4CAF50);
  final Color _accentColor = const Color(0xFF8BC34A);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);

  String? _selectedTab;
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
    _selectedTab = _tabs.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('لوحة تحكم عامل النظافة'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu), // أيقونة القائمة الثلاثية الخطوط
          onPressed: () {
            _showTabMenu(context);
          },
        ),
      ),
      body: _buildCurrentTab(),
      
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

  // عرض قائمة التبويبات
  void _showTabMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _tabs.map((tab) {
              return ListTile(
                leading: _getTabIcon(tab),
                title: Text(
                  tab,
                  style: TextStyle(
                    fontWeight: _selectedTab == tab ? FontWeight.bold : FontWeight.normal,
                    color: _selectedTab == tab ? _primaryColor : _textColor,
                  ),
                ),
                trailing: _selectedTab == tab ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () {
                  setState(() {
                    _selectedTab = tab;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // بناء محتوى التبويب الحالي
  Widget _buildCurrentTab() {
    switch (_selectedTab) {
      case 'مهام اليوم':
        return _buildTodayTasksTab();
      case 'طلبات التسليم':
        return _buildDeliveryRequestsTab();
      case 'بلاغات المعالجة':
        return _buildReportsTab();
      case 'سجل الأداء':
        return _buildPerformanceTab();
      default:
        return _buildTodayTasksTab();
    }
  }

  // الحصول على أيقونة التبويب
  Icon _getTabIcon(String tabName) {
    switch (tabName) {
      case 'مهام اليوم':
        return const Icon(Icons.task, color: Colors.black);
      case 'طلبات التسليم':
        return const Icon(Icons.local_shipping, color: Colors.black);
      case 'بلاغات المعالجة':
        return const Icon(Icons.warning, color: Colors.black);
      case 'سجل الأداء':
        return const Icon(Icons.assessment, color: Colors.black);
      default:
        return const Icon(Icons.task, color: Colors.black);
    }
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
            leading: _buildCircularIcon(
              _getTaskIcon(task['type']),
              _primaryColor,
              Colors.white,
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
                ? _buildCircularIcon(Icons.check_circle, Colors.green, Colors.white, size: 24)
                : _buildCircularIconButton(
                    Icons.done,
                    _primaryColor,
                    Colors.white,
                    onPressed: () => _completeTask(index),
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
            leading: _buildCircularIcon(Icons.local_shipping, Colors.blue, Colors.white),
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
                ? _buildCircularIconButton(
                    Icons.check,
                    _primaryColor,
                    Colors.white,
                    onPressed: () => _completeDelivery(index),
                  )
                : _buildCircularIcon(Icons.check_circle, Colors.green, Colors.white, size: 24),
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
            leading: _buildCircularIcon(
              Icons.warning,
              report['priority'] == 'عاجل' ? Colors.red : Colors.orange,
              Colors.white,
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
            trailing: _buildCircularIconButton(
              Icons.check_circle,
              _primaryColor,
              Colors.white,
              onPressed: () => _resolveReport(index),
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
          ListTile(
            leading: _buildCircularIcon(Icons.location_on, Colors.green, Colors.white),
            title: const Text('المنطقة الشمالية'),
            subtitle: const Text('أعلى تقييم: 4.9/5'),
          ),
          ListTile(
            leading: _buildCircularIcon(Icons.location_on, Colors.blue, Colors.white),
            title: const Text('المنطقة التجارية'),
            subtitle: const Text('أعلى تقييم: 4.7/5'),
          ),
        ],
      ),
    );
  }

  // بناء بطاقة الإحصائيات
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCircularIcon(icon, _primaryColor, Colors.white, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
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

  // بناء أيقونة دائرية
  Widget _buildCircularIcon(IconData icon, Color backgroundColor, Color iconColor, {double size = 40}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: size * 0.6,
      ),
    );
  }

  // بناء زر أيقونة دائرية
  Widget _buildCircularIconButton(IconData icon, Color backgroundColor, Color iconColor, 
      {double size = 40, required VoidCallback onPressed}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: size * 0.5),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        iconSize: size * 0.5,
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
                leading: _buildCircularIcon(Icons.add_task, Colors.green, Colors.white),
                title: const Text('تسجيل مهمة جديدة'),
                onTap: () {
                  Navigator.pop(context);
                  _addNewTask();
                },
              ),
              ListTile(
                leading: _buildCircularIcon(Icons.report, Colors.orange, Colors.white),
                title: const Text('تسجيل بلاغ جديد'),
                onTap: () {
                  Navigator.pop(context);
                  _reportIssue();
                },
              ),
              ListTile(
                leading: _buildCircularIcon(Icons.local_shipping, Colors.blue, Colors.white),
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
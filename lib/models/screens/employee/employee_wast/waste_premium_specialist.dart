import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WastePremiumSpecialistScreen extends StatefulWidget {
  const WastePremiumSpecialistScreen({super.key});

  @override
  State<WastePremiumSpecialistScreen> createState() => _WastePremiumSpecialistScreenState();
}

class _WastePremiumSpecialistScreenState extends State<WastePremiumSpecialistScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  
  // الألوان المخصصة لموظف النفايات المميزة (تم التعديل)
  final Color _primaryColor = const Color(0xFF00695C); // أخضر نيلي داكن
  final Color _secondaryColor = const Color(0xFF00897B); // أخضر نيلي
  final Color _accentColor = const Color(0xFF4DB6AC); // أخضر نيلي فاتح
  final Color _backgroundColor = const Color(0xFFE0F2F1); // أخضر فاتح جداً
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF263238);
  final Color _textSecondaryColor = const Color(0xFF78909C);
  
  // البيانات الوهمية
  final List<Map<String, dynamic>> _premiumRequests = [
    {
      'id': 'PR001',
      'customer': 'أحمد محمد',
      'service': 'تنظيف مميز',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'معلق',
      'priority': 'عالي',
    },
    {
      'id': 'PR002',
      'customer': 'سارة عبدالله',
      'service': 'إعادة تدوير',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'قيد التنفيذ',
      'priority': 'متوسط',
    },
    {
      'id': 'PR003',
      'customer': 'خالد السعدي',
      'service': 'جمع نفايات خطرة',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'مكتمل',
      'priority': 'عالي',
    },
    {
      'id': 'PR004',
      'customer': 'فاطمة الزهراء',
      'service': 'تدوير إلكتروني',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'status': 'مكتمل',
      'priority': 'منخفض',
    },
  ];
  
  final List<Map<String, dynamic>> _services = [
    {
      'title': 'الطلبات المميزة',
      'icon': Icons.workspace_premium,
      'count': 12,
      'color': Color(0xFFFFD700), // ذهبي
    },
    {
      'title': 'المهام اليومية',
      'icon': Icons.task_alt,
      'count': 8,
      'color': Color(0xFF42A5F5), // أزرق
    },
    {
      'title': 'التقارير',
      'icon': Icons.analytics,
      'count': 5,
      'color': Color(0xFFAB47BC), // بنفسجي
    },
    {
      'title': 'العملاء المميزين',
      'icon': Icons.people_alt,
      'count': 15,
      'color': Color(0xFF66BB6A), // أخضر
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'خدمات النفايات المميزة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'لوحة التحكم'),
            Tab(icon: Icon(Icons.list_alt), text: 'الطلبات'),
            Tab(icon: Icon(Icons.bar_chart), text: 'التقارير'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildRequestsTab(),
          _buildReportsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewRequestDialog(context);
        },
        backgroundColor: _primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة الترحيب
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'مرحباً بك،',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'موظف خدمات النفايات المميزة',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.notifications_active, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStatCard('مهمة اليوم', 5, Icons.today, Colors.amber),
                      const SizedBox(width: 12),
                      _buildStatCard('مكتملة', 23, Icons.check_circle, Colors.green),
                      const SizedBox(width: 12),
                      _buildStatCard('معلقة', 7, Icons.pending_actions, Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // الخدمات السريعة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'الخدمات السريعة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor),
            ),
          ),
          const SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: _services.length,
            itemBuilder: (context, index) {
              final service = _services[index];
              return _buildServiceCard(service);
            },
          ),
          
          const SizedBox(height: 24),
          
          // الطلبات الحديثة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الطلبات الحديثة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor),
                ),
                TextButton(
                  onPressed: () {
                    _tabController.animateTo(1);
                  },
                  child: Text(
                    'عرض الكل',
                    style: TextStyle(color: _primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _premiumRequests.take(3).length,
            itemBuilder: (context, index) {
              final request = _premiumRequests[index];
              return _buildRequestItem(request, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // الانتقال إلى الشاشة المناسبة
        },
        onHover: (hovering) {
          // تأثير عند التمرير
        },
        child: Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: service['color'].withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(service['icon'], color: service['color'], size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                service['title'],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                '${service['count']}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'ابحث في الطلبات...',
              prefixIcon: Icon(Icons.search, color: _textSecondaryColor),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _premiumRequests.length,
            itemBuilder: (context, index) {
              final request = _premiumRequests[index];
              return _buildRequestItem(request, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRequestItem(Map<String, dynamic> request, int index) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.info;
    
    if (request['status'] == 'معلق') {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
    } else if (request['status'] == 'قيد التنفيذ') {
      statusColor = Colors.blue;
      statusIcon = Icons.schedule;
    } else if (request['status'] == 'مكتمل') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    }
    
    Color priorityColor = Colors.grey;
    if (request['priority'] == 'عالي') {
      priorityColor = Colors.red;
    } else if (request['priority'] == 'متوسط') {
      priorityColor = Colors.orange;
    } else if (request['priority'] == 'منخفض') {
      priorityColor = Colors.green;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.work_outline, color: _primaryColor, size: 26),
        ),
        title: Text(
          request['customer'],
          style: TextStyle(fontWeight: FontWeight.bold, color: _textColor, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(request['service'], style: TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: _textSecondaryColor),
                const SizedBox(width: 4),
                Text(
                  DateFormat('yyyy-MM-dd').format(request['date']),
                  style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, color: statusColor, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    request['status'],
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                request['priority'],
                style: TextStyle(
                  color: priorityColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          _showRequestDetails(request);
        },
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تقارير أداء خدمات النفايات المميزة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor),
          ),
          const SizedBox(height: 8),
          Text(
            'تحليل شامل لأداء الخدمات المميزة',
            style: TextStyle(fontSize: 14, color: _textSecondaryColor),
          ),
          const SizedBox(height: 24),
          
          // إحصائيات سريعة
          Row(
            children: [
              Expanded(
                child: _buildReportStatCard('إجمالي الطلبات', '142', Icons.request_page, _primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildReportStatCard('طلبات هذا الشهر', '24', Icons.calendar_month, _secondaryColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildReportStatCard('معدل الإنجاز', '87%', Icons.trending_up, Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildReportStatCard('رضا العملاء', '4.8/5', Icons.star, Colors.amber),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // تقارير نوعية
          Text(
            'التقارير النوعية',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor),
          ),
          const SizedBox(height: 12),
          
          _buildReportItem('تقرير الأداء الشهري', Icons.description, 'يحتوي على إحصائيات الأداء للشهر الحالي'),
          _buildReportItem('تقرير رضا العملاء', Icons.sentiment_satisfied_alt, 'تحليل لاستبيانات رضا العملاء'),
          _buildReportItem('تقرير الطلبات المعلقة', Icons.pending_actions, 'الطلبات التي تحتاج لمتابعة'),
          _buildReportItem('تقرير التكاليف', Icons.attach_money, 'تحليل للتكاليف والإيرادات'),
          
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.add_chart, color: Colors.white),
            label: const Text('إنشاء تقرير جديد', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReportStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                Icon(Icons.more_vert, color: _textSecondaryColor, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: _textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildReportItem(String title, IconData icon, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _primaryColor),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
        subtitle: Text(description, style: TextStyle(fontSize: 12, color: _textSecondaryColor)),
        trailing: Icon(Icons.arrow_forward_ios, color: _textSecondaryColor, size: 16),
        onTap: () {},
      ),
    );
  }

  void _showRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.request_page, color: _primaryColor),
            const SizedBox(width: 8),
            Text('تفاصيل الطلب: ${request['id']}'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('العميل:', request['customer']),
              _buildDetailRow('الخدمة:', request['service']),
              _buildDetailRow('الحالة:', request['status']),
              _buildDetailRow('الأولوية:', request['priority']),
              _buildDetailRow('التاريخ:', DateFormat('yyyy-MM-dd HH:mm').format(request['date'])),
              const SizedBox(height: 16),
              const Text(
                'ملاحظات إضافية:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق.',
                style: TextStyle(fontSize: 14, color: _textSecondaryColor),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
            child: const Text('تحديث الحالة'),
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
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showNewRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.add_circle, color: _primaryColor, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'طلب خدمة جديدة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'اسم العميل',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'نوع الخدمة',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'الأولوية',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
                items: ['منخفض', 'متوسط', 'عالي']
                    .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('تم إنشاء الطلب بنجاح'),
                          backgroundColor: _primaryColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('إنشاء'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
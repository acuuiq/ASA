import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WasteSchedulerScreen extends StatefulWidget {
  const WasteSchedulerScreen({super.key});

  @override
  State<WasteSchedulerScreen> createState() => _WasteSchedulerScreenState();
}

class _WasteSchedulerScreenState extends State<WasteSchedulerScreen> {
  // الألوان المخصصة لموظف جدولة النفايات
  final Color _primaryColor = const Color(0xFF00796B); // أخضر نيلي داكن
  final Color _secondaryColor = const Color(0xFF009688); // أخضر نيلي
  final Color _accentColor = const Color(0xFF4DB6AC); // أخضر نيلي فاتح
  final Color _backgroundColor = const Color(0xFFE0F2F1); // خلفية فاتحة
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF263238);
  final Color _textSecondaryColor = const Color(0xFF78909C);

  // البيانات الوهمية
  final List<Map<String, dynamic>> _quickActions = [
    {
      'title': 'إنشاء جدول',
      'icon': Icons.schedule,
      'color': Color(0xFF00796B),
      'data': '12 جدول نشط',
      'subtitle': 'إدارة جداول النظافة'
    },
    {
      'title': 'إدارة الفرق',
      'icon': Icons.groups,
      'color': Color(0xFF5C6BC0),
      'data': '8 فرق عمل',
      'subtitle': 'توزيع المهام على الفرق'
    },
    {
      'title': 'تتبع المركبات',
      'icon': Icons.local_shipping,
      'color': Color(0xFFFF7043),
      'data': '15 مركبة',
      'subtitle': 'مراقبة حركة الشاحنات'
    },
    {
      'title': 'التقارير',
      'icon': Icons.analytics,
      'color': Color(0xFF66BB6A),
      'data': '28 تقرير',
      'subtitle': 'تقارير الأداء والإنجاز'
    },
    {
      'title': 'المناطق',
      'icon': Icons.map,
      'color': Color(0xFFAB47BC),
      'data': '10 مناطق',
      'subtitle': 'إدارة مناطق العمل'
    },
    {
      'title': 'الإشعارات',
      'icon': Icons.notifications,
      'color': Color(0xFFFFA726),
      'data': '5 غير مقروء',
      'subtitle': 'البلاغات والتنبيهات'
    },
  ];

  // بيانات المهام الحديثة
  final List<Map<String, dynamic>> _recentTasks = [
    {
      'title': 'جمع النفايات - حي الربيع',
      'time': '08:00 - 10:00',
      'status': 'مكتمل',
      'team': 'الفريق أ',
      'date': 'السبت 10 أكتوبر',
      'icon': Icons.delete,
      'color': Colors.green
    },
    {
      'title': 'إعادة التدوير - حي الأندلس',
      'time': '09:00 - 11:00',
      'status': 'قيد التنفيذ',
      'team': 'الفريق ب',
      'date': 'الأحد 11 أكتوبر',
      'icon': Icons.recycling,
      'color': Colors.blue
    },
    {
      'title': 'نفايات خطرة - المنطقة الصناعية',
      'time': '10:00 - 12:00',
      'status': 'معلق',
      'team': 'الفريق ج',
      'date': 'الاثنين 12 أكتوبر',
      'icon': Icons.warning,
      'color': Colors.orange
    },
    {
      'title': 'نفايات بناء - حي الزهور',
      'time': '07:00 - 09:00',
      'status': 'مخطط',
      'team': 'الفريق د',
      'date': 'الثلاثاء 13 أكتوبر',
      'icon': Icons.construction,
      'color': Colors.purple
    },
  ];

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'نظام إدارة النفايات',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // إنشاء مهمة جديدة
        },
        backgroundColor: _primaryColor,
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentPageIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildTasksPage();
      case 2:
        return _buildReportsPage();
      case 3:
        return _buildProfilePage();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة الترحيب
          _buildWelcomeCard(),
          
          SizedBox(height: 24),
          
          // الإحصائيات السريعة
          Text(
            'نظرة سريعة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          SizedBox(height: 16),
          _buildStatsGrid(),
          
          SizedBox(height: 24),
          
          // الإجراءات السريعة
          Text(
            'الإجراءات السريعة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          SizedBox(height: 16),
          _buildActionGrid(),
          
          SizedBox(height: 24),
          
          // المهام الحديثة
          Text(
            'المهام الحديثة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          SizedBox(height: 16),
          _buildRecentTasks(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
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
            Text(
              'مرحباً بك،',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'مدير جدولة النفايات',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWelcomeStat('المهام اليوم', '5', Icons.today),
                _buildWelcomeStat('المكتملة', '23', Icons.check_circle),
                _buildWelcomeStat('المعلقة', '7', Icons.pending),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeStat(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('الفرق النشطة', '8', Icons.groups, Colors.blue),
        _buildStatCard('المركبات', '15', Icons.local_shipping, Colors.green),
        _buildStatCard('المناطق', '10', Icons.map, Colors.orange),
        _buildStatCard('التقارير', '28', Icons.bar_chart, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
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

  Widget _buildActionGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: _quickActions.length,
      itemBuilder: (context, index) {
        final action = _quickActions[index];
        return _buildActionButton(action);
      },
    );
  }

  Widget _buildActionButton(Map<String, dynamic> action) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleActionTap(action['title']),
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: action['color'].withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(action['icon'], color: action['color'], size: 24),
              ),
              SizedBox(height: 8),
              Text(
                action['title'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
              SizedBox(height: 4),
              Text(
                action['data'],
                style: TextStyle(
                  fontSize: 10,
                  color: _textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTasks() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _recentTasks.length,
      itemBuilder: (context, index) {
        final task = _recentTasks[index];
        return _buildTaskItem(task, index);
      },
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task, int index) {
    Color statusColor = Colors.grey;
    
    if (task['status'] == 'مكتمل') {
      statusColor = Colors.green;
    } else if (task['status'] == 'قيد التنفيذ') {
      statusColor = Colors.blue;
    } else if (task['status'] == 'معلق') {
      statusColor = Colors.orange;
    } else if (task['status'] == 'مخطط') {
      statusColor = Colors.purple;
    }
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: task['color'].withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(task['icon'], color: task['color'], size: 24),
        ),
        title: Text(
          task['title'],
          style: TextStyle(fontWeight: FontWeight.bold, color: _textColor, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('${task['time']} - ${task['date']}'),
            SizedBox(height: 4),
            Text(task['team'], style: TextStyle(fontSize: 12, color: _textSecondaryColor)),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            task['status'],
            style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () {
          // عرض تفاصيل المهمة
        },
      ),
    );
  }

  Widget _buildTasksPage() {
    return Center(
      child: Text(
        'صفحة المهام',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildReportsPage() {
    return Center(
      child: Text(
        'صفحة التقارير',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProfilePage() {
    return Center(
      child: Text(
        'صفحة الملف الشخصي',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentPageIndex,
      onTap: (index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _primaryColor,
      unselectedItemColor: _textSecondaryColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: 'المهام',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'التقارير',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'الملف الشخصي',
        ),
      ],
    );
  }

  void _handleActionTap(String actionTitle) {
    // معالجة الإجراءات السريعة
    switch (actionTitle) {
      case 'إنشاء جدول':
        // فتح شاشة إنشاء جدول
        break;
      case 'إدارة الفرق':
        // فتح شاشة إدارة الفرق
        break;
      case 'تتبع المركبات':
        // فتح شاشة تتبع المركبات
        break;
      case 'التقارير':
        // فتح شاشة التقارير
        break;
      case 'المناطق':
        // فتح شاشة المناطق
        break;
      case 'الإشعارات':
        // فتح شاشة الإشعارات
        break;
    }
  }
}
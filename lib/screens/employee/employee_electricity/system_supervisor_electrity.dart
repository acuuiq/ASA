//مشرف النظام (الكهرباء)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SystemSupervisorScreen extends StatelessWidget {
  final List<Map<String, dynamic>> systemStats = [
    {
      'metric': 'المستخدمين النشطين',
      'value': '1,250',
      'icon': Icons.people,
      'color': Colors.blue,
    },
    {
      'metric': 'المهام اليومية',
      'value': '45',
      'icon': Icons.task,
      'color': Colors.green,
    },
    {
      'metric': 'الإنذارات',
      'value': '3',
      'icon': Icons.warning,
      'color': Colors.orange,
    },
    {
      'metric': 'الأداء',
      'value': '98%',
      'icon': Icons.speed,
      'color': Colors.purple,
    },
  ];

  final List<Map<String, dynamic>> recentActivities = [
    {
      'user': 'أحمد محمد',
      'action': 'تسجيل دخول',
      'time': DateTime.now().subtract(Duration(minutes: 5)),
      'status': 'ناجح',
    },
    {
      'user': 'فاطمة علي',
      'action': 'تعديل فاتورة',
      'time': DateTime.now().subtract(Duration(minutes: 15)),
      'status': 'ناجح',
    },
    {
      'user': 'سالم عبدالله',
      'action': 'محاولة دخول',
      'time': DateTime.now().subtract(Duration(minutes: 30)),
      'status': 'فاشل',
    },
  ];

  final List<Map<String, dynamic>> employeePerformance = [
    {
      'employee': 'موظف خدمة العملاء',
      'completed': 25,
      'pending': 3,
      'rating': '4.8',
    },
    {'employee': 'فني الصيانة', 'completed': 18, 'pending': 2, 'rating': '4.6'},
    {'employee': 'المحاسب', 'completed': 30, 'pending': 1, 'rating': '4.9'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المشرف - لوحة التحكم'),
        backgroundColor: Colors.indigo[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // إحصائيات النظام
              Text(
                'نظرة عامة على النظام',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: systemStats.length,
                itemBuilder: (context, index) {
                  return _buildSystemStatCard(systemStats[index]);
                },
              ),
              SizedBox(height: 20),

              // أداء الموظفين
              Text(
                'أداء الموظفين',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: employeePerformance.length,
                itemBuilder: (context, index) {
                  return _buildEmployeePerformanceCard(
                    employeePerformance[index],
                  );
                },
              ),
              SizedBox(height: 20),

              // النشاطات الحديثة
              Text(
                'النشاطات الحديثة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recentActivities.length,
                itemBuilder: (context, index) {
                  return _buildActivityCard(recentActivities[index]);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.settings),
        backgroundColor: Colors.indigo[700],
      ),
    );
  }

  Widget _buildSystemStatCard(Map<String, dynamic> stat) {
    return Card(
      color: stat['color'].withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(stat['icon'], color: stat['color'], size: 24),
            SizedBox(height: 8),
            Text(
              stat['value'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              stat['metric'],
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeePerformanceCard(Map<String, dynamic> performance) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(performance['employee']),
        subtitle: Text(
          'المكتمل: ${performance['completed']} • المعلق: ${performance['pending']}',
        ),
        trailing: Chip(
          label: Text('⭐ ${performance['rating']}'),
          backgroundColor: Colors.amber[100],
        ),
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          activity['status'] == 'ناجح' ? Icons.check_circle : Icons.error,
          color: activity['status'] == 'ناجح' ? Colors.green : Colors.red,
        ),
        title: Text(activity['user']),
        subtitle: Text(activity['action']),
        trailing: Text(DateFormat('HH:mm').format(activity['time'])),
      ),
    );
  }
}

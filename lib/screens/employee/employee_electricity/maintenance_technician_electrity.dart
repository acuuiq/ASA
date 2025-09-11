//فني الصيانة (الكهرباء)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaintenanceTechnicianScreen extends StatelessWidget {
  final List<Map<String, dynamic>> activeTasks = [
    {
      'id': 'TASK-001',
      'location': 'شارع الملك فهد، الرياض',
      'type': 'عطل في العداد',
      'priority': 'عالي',
      'assignedDate': DateTime.now().subtract(Duration(hours: 1)),
      'estimatedTime': '2 ساعة',
      'status': 'قيد التنفيذ',
    },
    {
      'id': 'TASK-002',
      'location': 'حي النخيل، جدة',
      'type': 'انقطاع تيار',
      'priority': 'عاجل',
      'assignedDate': DateTime.now().subtract(Duration(minutes: 30)),
      'estimatedTime': '4 ساعات',
      'status': 'معلقة',
    },
  ];

  final List<Map<String, dynamic>> completedTasks = [
    {
      'id': 'TASK-003',
      'location': 'حي العليا، الرياض',
      'type': 'صيانة وقائية',
      'completionDate': DateTime.now().subtract(Duration(days: 1)),
      'duration': '3 ساعات',
      'rating': '4.5',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الفني - لوحة المهام'),
        backgroundColor: Colors.orange[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حالة المهام
            Row(
              children: [
                _buildStatusCard(
                  'المهام النشطة',
                  activeTasks.length.toString(),
                  Colors.blue,
                ),
                SizedBox(width: 12),
                _buildStatusCard(
                  'مكتملة',
                  completedTasks.length.toString(),
                  Colors.green,
                ),
                SizedBox(width: 12),
                _buildStatusCard('متأخرة', '2', Colors.red),
              ],
            ),
            SizedBox(height: 20),

            // المهام الحالية
            Text(
              'المهام المخصصة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: activeTasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskCard(activeTasks[index]);
                },
              ),
            ),

            // المهام المنتهية
            Text(
              'المهام المنتهية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: completedTasks.length,
                itemBuilder: (context, index) {
                  return _buildCompletedTaskCard(completedTasks[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.update),
        backgroundColor: Colors.orange[700],
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(title, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.build, color: Colors.orange),
        title: Text(task['type']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task['location']),
            Text('الأولوية: ${task['priority']}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(task['status']), Text('~${task['estimatedTime']}')],
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildCompletedTaskCard(Map<String, dynamic> task) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      color: Colors.green[50],
      child: ListTile(
        leading: Icon(Icons.check_circle, color: Colors.green),
        title: Text(task['type']),
        subtitle: Text(
          'تم الانتهاء: ${DateFormat('yyyy-MM-dd').format(task['completionDate'])}',
        ),
        trailing: Chip(
          label: Text('⭐ ${task['rating']}'),
          backgroundColor: Colors.amber[100],
        ),
      ),
    );
  }
}

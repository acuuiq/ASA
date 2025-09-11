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
      'customerName': 'أحمد محمد',
      'customerPhone': '0551234567',
      'meterNumber': 'MTR-2023-001',
      'consumption': '250 ك.و.س',
    },
    {
      'id': 'TASK-002',
      'location': 'حي النخيل، جدة',
      'type': 'انقطاع تيار',
      'priority': 'عاجل',
      'assignedDate': DateTime.now().subtract(Duration(minutes: 30)),
      'estimatedTime': '4 ساعات',
      'status': 'معلقة',
      'customerName': 'سارة عبدالله',
      'customerPhone': '0557654321',
      'meterNumber': 'MTR-2023-045',
      'consumption': '180 ك.و.س',
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
      'customerName': 'خالد إبراهيم',
      'meterNumber': 'MTR-2023-078',
      'partsUsed': ['عداد جديد', 'أسلاك توصيل'],
      'cost': '350 ريال',
    },
    {
      'id': 'TASK-004',
      'location': 'حي السلام، الدمام',
      'type': 'استبدال عداد',
      'completionDate': DateTime.now().subtract(Duration(days: 3)),
      'duration': '2.5 ساعة',
      'rating': '4.8',
      'customerName': 'فاطمة علي',
      'meterNumber': 'MTR-2023-112',
      'partsUsed': ['عداد ذكي'],
      'cost': '520 ريال',
    },
  ];

  final List<Map<String, dynamic>> delayedTasks = [
    {
      'id': 'TASK-005',
      'location': 'حي الورود، الخبر',
      'type': 'إصلاح خط كهرباء',
      'priority': 'عالي',
      'assignedDate': DateTime.now().subtract(Duration(days: 2)),
      'estimatedTime': '5 ساعات',
      'status': 'متأخرة',
      'delayReason': 'انتظار قطع الغيار',
      'customerName': 'محمد حسن',
      'customerPhone': '0559876543',
      'meterNumber': 'MTR-2023-087',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'فني الصيانة - الكهرباء',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF0D47A1),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // عرض الإشعارات
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة معلومات الفني
            _buildTechnicianInfoCard(),
            SizedBox(height: 16),

            // حالة المهام
            Row(
              children: [
                _buildStatusCard(
                  'المهام النشطة',
                  activeTasks.length.toString(),
                  Colors.blue,
                  Icons.assignment,
                ),
                SizedBox(width: 8),
                _buildStatusCard(
                  'مكتملة',
                  completedTasks.length.toString(),
                  Colors.green,
                  Icons.check_circle,
                ),
                SizedBox(width: 8),
                _buildStatusCard(
                  'متأخرة',
                  delayedTasks.length.toString(),
                  Colors.red,
                  Icons.warning,
                ),
              ],
            ),
            SizedBox(height: 20),

            // المهام الحالية
            Text(
              'المهام النشطة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: activeTasks.length,
                itemBuilder: (context, index) {
                  return _buildActiveTaskCard(activeTasks[index]);
                },
              ),
            ),

            SizedBox(height: 16),

            // المهام المتأخرة
            if (delayedTasks.isNotEmpty) ...[
              Text(
                'المهام المتأخرة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: delayedTasks.length,
                  itemBuilder: (context, index) {
                    return _buildDelayedTaskCard(delayedTasks[index]);
                  },
                ),
              ),
              SizedBox(height: 16),
            ],

            // المهام المنتهية
            Text(
              'المهام المنتهية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 2,
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
        onPressed: () {
          // تحديث قائمة المهام
        },
        child: Icon(Icons.refresh),
        backgroundColor: Color(0xFF0D47A1),
      ),
    );
  }

  Widget _buildTechnicianInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFF0D47A1).withOpacity(0.2),
              child: Icon(Icons.person, color: Color(0xFF0D47A1), size: 30),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'فادي أحمد',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'فني كهرباء - المنطقة الوسطى',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'المهام هذا الأسبوع: ${activeTasks.length + completedTasks.length}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.star, color: Colors.amber, size: 20),
            Text('4.7', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTaskCard(Map<String, dynamic> task) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getPriorityColor(task['priority']).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.build,
            color: _getPriorityColor(task['priority']),
            size: 20,
          ),
        ),
        title: Text(
          task['type'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(task['location'], style: TextStyle(fontSize: 12)),
            SizedBox(height: 2),
            Text(
              'العميل: ${task['customerName']}',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            task['status'],
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: _getStatusColor(task['status']),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'رقم المهمة:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(task['id']),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'رقم العداد:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(task['meterNumber']),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'هاتف العميل:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(task['customerPhone']),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الاستهلاك:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(task['consumption']),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الوقت المقدر:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(task['estimatedTime']),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // بدء المهمة
                      },
                      icon: Icon(Icons.play_arrow, size: 18),
                      label: Text('بدء العمل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        // تأجيل المهمة
                      },
                      icon: Icon(Icons.schedule, size: 18),
                      label: Text('تأجيل'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDelayedTaskCard(Map<String, dynamic> task) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.red[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.red[100]!, width: 1),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.warning, color: Colors.red, size: 20),
        ),
        title: Text(
          task['type'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(task['location'], style: TextStyle(fontSize: 12)),
            SizedBox(height: 2),
            Text(
              'سبب التأخير: ${task['delayReason']}',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            task['status'],
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
        onTap: () {
          // عرض تفاصيل المهمة المتأخرة
        },
      ),
    );
  }

  Widget _buildCompletedTaskCard(Map<String, dynamic> task) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_circle, color: Colors.green, size: 20),
        ),
        title: Text(
          task['type'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(task['location'], style: TextStyle(fontSize: 12)),
            SizedBox(height: 2),
            Text(
              'العميل: ${task['customerName']}',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 2),
            Text('التكلفة: ${task['cost']}', style: TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Chip(
              label: Text('⭐ ${task['rating']}'),
              backgroundColor: Colors.amber[100],
            ),
            SizedBox(height: 4),
            Text(
              DateFormat('yyyy-MM-dd').format(task['completionDate']),
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
        onTap: () {
          // عرض تفاصيل المهمة المنتهية
        },
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عاجل':
        return Colors.red;
      case 'عالي':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'قيد التنفيذ':
        return Colors.blue;
      case 'معلقة':
        return Colors.orange;
      case 'متأخرة':
        return Colors.red;
      case 'مكتملة':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

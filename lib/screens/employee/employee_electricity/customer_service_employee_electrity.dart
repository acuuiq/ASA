import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerServiceEmployeeElectricityScreen extends StatelessWidget {
  final List<Map<String, dynamic>> pendingRequests = [
    {
      'id': 'REQ-001',
      'customer': 'أحمد محمد',
      'type': 'استفسار عن الفاتورة',
      'priority': 'عادي',
      'date': DateTime.now().subtract(Duration(hours: 2)),
      'status': 'قيد المعالجة',
    },
    {
      'id': 'REQ-002',
      'customer': 'فاطمة علي',
      'type': 'شكوى في الخدمة',
      'priority': 'عالي',
      'date': DateTime.now().subtract(Duration(hours: 1)),
      'status': 'جديد',
    },
  ];

  final List<Map<String, dynamic>> resolvedRequests = [
    {
      'id': 'REQ-003',
      'customer': 'سالم عبدالله',
      'type': 'تغيير العنوان',
      'date': DateTime.now().subtract(Duration(days: 1)),
      'resolution': 'تم التحديث بنجاح',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('خدمة العملاء - لوحة التحكم'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إحصائيات سريعة
            Row(
              children: [
                _buildStatCard('الطلبات الجديدة', '5', Colors.orange),
                SizedBox(width: 12),
                _buildStatCard('قيد المعالجة', '3', Colors.blue),
                SizedBox(width: 12),
                _buildStatCard('مكتملة', '12', Colors.green),
              ],
            ),
            SizedBox(height: 20),

            // الطلبات العاجلة
            Text(
              'الطلبات العاجلة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: pendingRequests.length,
                itemBuilder: (context, index) {
                  return _buildRequestCard(pendingRequests[index]);
                },
              ),
            ),

            // الطلبات المكتملة
            Text(
              'الطلبات المكتملة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: resolvedRequests.length,
                itemBuilder: (context, index) {
                  return _buildResolvedCard(resolvedRequests[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_comment),
        backgroundColor: Colors.blue[700],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
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

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.support_agent, color: Colors.blue),
        title: Text(request['customer']),
        subtitle: Text(request['type']),
        trailing: Chip(
          label: Text(request['status']),
          backgroundColor: request['status'] == 'جديد'
              ? Colors.orange
              : Colors.blue,
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildResolvedCard(Map<String, dynamic> request) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      color: Colors.green[50],
      child: ListTile(
        leading: Icon(Icons.check_circle, color: Colors.green),
        title: Text(request['customer']),
        subtitle: Text(request['type']),
        trailing: Text(DateFormat('yyyy-MM-dd').format(request['date'])),
      ),
    );
  }
}

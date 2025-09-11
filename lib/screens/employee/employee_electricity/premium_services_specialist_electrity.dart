//فني الصيانة (الكهرباء)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PremiumServicesSpecialistScreen extends StatelessWidget {
  final List<Map<String, dynamic>> availableServices = [
    {
      'id': 'PREMIUM-001',
      'name': 'تركيب ألواح شمسية',
      'price': '5000 دينار',
      'duration': '5 أيام',
      'requests': 8,
      'rating': '4.8',
      'status': 'متاح',
    },
    {
      'id': 'PREMIUM-002',
      'name': 'نظام مراقبة استهلاك',
      'price': '1500 دينار',
      'duration': '2 أيام',
      'requests': 12,
      'rating': '4.5',
      'status': 'متاح',
    },
  ];

  final List<Map<String, dynamic>> serviceRequests = [
    {
      'id': 'SR-001',
      'service': 'تركيب ألواح شمسية',
      'customer': 'محمد أحمد',
      'requestDate': DateTime.now().subtract(Duration(days: 2)),
      'status': 'قيد المراجعة',
      'priority': 'عالي',
    },
    {
      'id': 'SR-002',
      'service': 'نظام مراقبة استهلاك',
      'customer': 'سارة عبدالله',
      'requestDate': DateTime.now().subtract(Duration(days: 1)),
      'status': 'مقبول',
      'priority': 'متوسط',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الخدمات المميزة - الإدارة'),
        backgroundColor: Colors.amber[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إحصائيات الخدمات
            Row(
              children: [
                _buildServiceStat('الخدمات المتاحة', '5', Colors.amber),
                SizedBox(width: 12),
                _buildServiceStat('طلبات الخدمات', '15', Colors.blue),
                SizedBox(width: 12),
                _buildServiceStat('معدل الرضا', '92%', Colors.green),
              ],
            ),
            SizedBox(height: 20),

            // الخدمات المتاحة
            Text(
              'الخدمات المتاحة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: availableServices.length,
                itemBuilder: (context, index) {
                  return _buildServiceCard(availableServices[index]);
                },
              ),
            ),

            // طلبات الخدمات
            Text(
              'طلبات الخدمات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: serviceRequests.length,
                itemBuilder: (context, index) {
                  return _buildServiceRequestCard(serviceRequests[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.star),
        backgroundColor: Colors.amber[700],
      ),
    );
  }

  Widget _buildServiceStat(String title, String value, Color color) {
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.star, color: Colors.amber),
        title: Text(service['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('السعر: ${service['price']} • المدة: ${service['duration']}'),
            Text(
              'الطلبات: ${service['requests']} • التقييم: ⭐ ${service['rating']}',
            ),
          ],
        ),
        trailing: Chip(
          label: Text(service['status']),
          backgroundColor: Colors.amber[100],
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildServiceRequestCard(Map<String, dynamic> request) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.request_page, color: Colors.blue),
        title: Text(request['customer']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(request['service']),
            Text('الأولوية: ${request['priority']}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chip(
              label: Text(request['status']),
              backgroundColor: request['status'] == 'مقبول'
                  ? Colors.green[100]
                  : Colors.orange[100],
            ),
            Text(DateFormat('yyyy-MM-dd').format(request['requestDate'])),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportingOfficerElectricityScreen extends StatelessWidget {
  final List<Map<String, dynamic>> activeReports = [
    {
      'id': 'REP-001',
      'location': 'شارع الملك فهد، الرياض',
      'type': 'عطل في العداد',
      'priority': 'عالي',
      'reportedDate': DateTime.now().subtract(Duration(hours: 1)),
      'status': 'قيد المراجعة',
    },
    {
      'id': 'REP-002',
      'location': 'حي النخيل، جدة',
      'type': 'انقطاع تيار',
      'priority': 'عاجل',
      'reportedDate': DateTime.now().subtract(Duration(minutes: 30)),
      'status': 'معلقة',
    },
  ];

  final List<Map<String, dynamic>> resolvedReports = [
    {
      'id': 'REP-003',
      'location': 'حي العليا، الرياض',
      'type': 'صيانة وقائية',
      'resolvedDate': DateTime.now().subtract(Duration(days: 1)),
      'duration': '3 ساعات',
      'rating': '4.5',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ضابط التقارير - لوحة التقارير'),
        backgroundColor: Colors.orange[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حالة التقارير
            Row(
              children: [
                _buildStatusCard(
                  'التقارير النشطة',
                  activeReports.length.toString(),
                  Colors.blue,
                ),
                SizedBox(width: 12),
                _buildStatusCard(
                  'محلولة',
                  resolvedReports.length.toString(),
                  Colors.green,
                ),
              ],
            ),
            SizedBox(height: 20),
            // التقارير النشطة
            Text(
              'التقارير النشطة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: activeReports.length,
                itemBuilder: (context, index) {
                  final report = activeReports[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('${report['type']} - ${report['location']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('الأولوية: ${report['priority']}'),
                          Text(
                            'تاريخ الإبلاغ: ${DateFormat('yyyy-MM-dd – kk:mm').format(report['reportedDate'])}',
                          ),
                          Text('الحالة: ${report['status']}'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // تفاصيل التقرير
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // التقارير المحلولة
            Text(
              'التقارير المحلولة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: resolvedReports.length,
                itemBuilder: (context, index) {
                  final report = resolvedReports[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('${report['type']} - ${report['location']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تاريخ الحل: ${DateFormat('yyyy-MM-dd – kk:mm').format(report['resolvedDate'])}',
                          ),
                          Text('المدة: ${report['duration']}'),
                          Text('التقييم: ${report['rating']} / 5'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // تفاصيل التقرير المحلول
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // تحديث التقارير
        },
        child: Icon(Icons.refresh),
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
}

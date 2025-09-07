import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QualityAuditorScreen extends StatelessWidget {
  final List<Map<String, dynamic>> qualityMetrics = [
    {
      'metric': 'جودة الخدمة',
      'score': '94%',
      'target': '90%',
      'trend': Icons.trending_up,
      'color': Colors.green,
    },
    {
      'metric': 'وقت الاستجابة',
      'score': '2.1 ساعة',
      'target': '2.5 ساعة',
      'trend': Icons.trending_up,
      'color': Colors.green,
    },
    {
      'metric': 'رضا العملاء',
      'score': '91%',
      'target': '88%',
      'trend': Icons.trending_up,
      'color': Colors.green,
    },
    {
      'metric': 'معدل الأخطاء',
      'score': '2.3%',
      'target': '1.5%',
      'trend': Icons.trending_down,
      'color': Colors.orange,
    },
  ];

  final List<Map<String, dynamic>> auditTasks = [
    {
      'id': 'AUDIT-001',
      'department': 'خدمة العملاء',
      'type': 'مراجعة جودة المكالمات',
      'dueDate': DateTime.now().add(Duration(days: 3)),
      'status': 'مخطط',
    },
    {
      'id': 'AUDIT-002',
      'department': 'الفنيين',
      'type': 'تدقيق أعمال الصيانة',
      'dueDate': DateTime.now().add(Duration(days: 1)),
      'status': 'عاجل',
    },
    {
      'id': 'AUDIT-003',
      'department': 'المحاسبة',
      'type': 'مراجعة الفواتير',
      'dueDate': DateTime.now().subtract(Duration(days: 2)),
      'status': 'متأخر',
    },
  ];

  final List<Map<String, dynamic>> completedAudits = [
    {
      'id': 'AUDIT-004',
      'department': 'خدمة العملاء',
      'type': 'مراجعة الشكاوى',
      'completionDate': DateTime.now().subtract(Duration(days: 5)),
      'result': 'ممتاز',
      'score': '95%',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الجودة والتدقيق - التقارير'),
        backgroundColor: Colors.deepOrange[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مؤشرات الجودة
            Text(
              'مؤشرات الجودة',
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
                childAspectRatio: 1.3,
              ),
              itemCount: qualityMetrics.length,
              itemBuilder: (context, index) {
                return _buildQualityMetricCard(qualityMetrics[index]);
              },
            ),
            SizedBox(height: 20),

            // مهام التدقيق
            Text(
              'مهام التدقيق',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: auditTasks.length,
                itemBuilder: (context, index) {
                  return _buildAuditTaskCard(auditTasks[index]);
                },
              ),
            ),

            // التدقيقات المكتملة
            Text(
              'التدقيقات المكتملة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: completedAudits.length,
                itemBuilder: (context, index) {
                  return _buildCompletedAuditCard(completedAudits[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.assignment_turned_in),
        backgroundColor: Colors.deepOrange[700],
      ),
    );
  }

  Widget _buildQualityMetricCard(Map<String, dynamic> metric) {
    return Card(
      color: metric['color'].withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(metric['trend'], color: metric['color']),
                SizedBox(width: 4),
                Text(
                  metric['metric'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              metric['score'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: metric['color'],
              ),
            ),
            SizedBox(height: 4),
            Text(
              'الهدف: ${metric['target']}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditTaskCard(Map<String, dynamic> task) {
    Color statusColor = Colors.grey;
    if (task['status'] == 'عاجل') statusColor = Colors.orange;
    if (task['status'] == 'متأخر') statusColor = Colors.red;
    if (task['status'] == 'مخطط') statusColor = Colors.blue;

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.assignment, color: statusColor),
        title: Text(task['department']),
        subtitle: Text(task['type']),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chip(
              label: Text(task['status']),
              backgroundColor: statusColor.withOpacity(0.1),
              labelStyle: TextStyle(color: statusColor),
            ),
            Text(DateFormat('yyyy-MM-dd').format(task['dueDate'])),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildCompletedAuditCard(Map<String, dynamic> audit) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      color: Colors.green[50],
      child: ListTile(
        leading: Icon(Icons.verified, color: Colors.green),
        title: Text(audit['department']),
        subtitle: Text(audit['type']),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chip(
              label: Text(audit['result']),
              backgroundColor: Colors.green[100],
            ),
            Text('نتيجة: ${audit['score']}'),
          ],
        ),
      ),
    );
  }
}

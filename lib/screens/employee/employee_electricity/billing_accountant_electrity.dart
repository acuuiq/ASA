import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillingAccountantScreen extends StatelessWidget {
  final List<Map<String, dynamic>> pendingBills = [
    {
      'id': 'INV-2024-001',
      'customer': 'أحمد محمد',
      'amount': 185.75,
      'dueDate': DateTime.now().add(Duration(days: 5)),
      'status': 'غير مدفوعة',
    },
    {
      'id': 'INV-2024-002',
      'customer': 'فاطمة علي',
      'amount': 230.50,
      'dueDate': DateTime.now().subtract(Duration(days: 3)),
      'status': 'متأخرة',
    },
  ];

  final List<Map<String, dynamic>> paidBills = [
    {
      'id': 'INV-2024-003',
      'customer': 'سالم عبدالله',
      'amount': 150.25,
      'paidDate': DateTime.now().subtract(Duration(days: 1)),
      'paymentMethod': 'بطاقة ائتمان',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المحاسبة - إدارة الفواتير'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إحصائيات مالية
            Row(
              children: [
                _buildFinanceCard(
                  'الإيرادات اليوم',
                  '2,450 دينار',
                  Colors.green,
                ),
                SizedBox(width: 12),
                _buildFinanceCard('الفواتير المتأخرة', '5', Colors.red),
                SizedBox(width: 12),
                _buildFinanceCard('المدفوعات', '87%', Colors.blue),
              ],
            ),
            SizedBox(height: 20),

            // الفواتير المنتظرة
            Text(
              'الفواتير المنتظرة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: pendingBills.length,
                itemBuilder: (context, index) {
                  return _buildPendingBillCard(pendingBills[index]);
                },
              ),
            ),

            // الفواتير المدفوعة
            Text(
              'الفواتير المدفوعة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: paidBills.length,
                itemBuilder: (context, index) {
                  return _buildPaidBillCard(paidBills[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.receipt),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  Widget _buildFinanceCard(String title, String value, Color color) {
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

  Widget _buildPendingBillCard(Map<String, dynamic> bill) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.receipt, color: Colors.orange),
        title: Text(bill['customer']),
        subtitle: Text('${bill['amount']} دينار'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(bill['status']),
            Text(DateFormat('yyyy-MM-dd').format(bill['dueDate'])),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildPaidBillCard(Map<String, dynamic> bill) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      color: Colors.green[50],
      child: ListTile(
        leading: Icon(Icons.check_circle, color: Colors.green),
        title: Text(bill['customer']),
        subtitle: Text('${bill['amount']} دينار - ${bill['paymentMethod']}'),
        trailing: Text(DateFormat('yyyy-MM-dd').format(bill['paidDate'])),
      ),
    );
  }
}

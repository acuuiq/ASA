//محاسب فاتورة الكهرباء
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillingAccountantScreen extends StatefulWidget {
  @override
  _BillingAccountantScreenState createState() =>
      _BillingAccountantScreenState();
}

class _BillingAccountantScreenState extends State<BillingAccountantScreen> {
  final List<Map<String, dynamic>> pendingBills = [
    {
      'id': 'INV-2024-001',
      'customer': 'أحمد محمد',
      'customerId': 'CUST-001',
      'amount': 185.75,
      'dueDate': DateTime.now().add(Duration(days: 5)),
      'status': 'غير مدفوعة',
      'consumption': '250 ك.و.س',
      'previousReading': '1250',
      'currentReading': '1500',
      'address': 'حي الرياض - شارع الملك فهد',
      'phone': '0551234567',
    },
    {
      'id': 'INV-2024-002',
      'customer': 'فاطمة علي',
      'customerId': 'CUST-002',
      'amount': 230.50,
      'dueDate': DateTime.now().subtract(Duration(days: 3)),
      'status': 'متأخرة',
      'consumption': '320 ك.و.س',
      'previousReading': '2100',
      'currentReading': '2420',
      'address': 'حي النخيل - شارع الأمير محمد',
      'phone': '0557654321',
    },
  ];

  final List<Map<String, dynamic>> paidBills = [
    {
      'id': 'INV-2024-003',
      'customer': 'سالم عبدالله',
      'customerId': 'CUST-003',
      'amount': 150.25,
      'paidDate': DateTime.now().subtract(Duration(days: 1)),
      'paymentMethod': 'بطاقة ائتمان',
      'consumption': '180 ك.و.س',
      'previousReading': '3050',
      'currentReading': '3230',
      'address': 'حي العليا - شارع العروبة',
      'phone': '0555555555',
    },
    {
      'id': 'INV-2024-004',
      'customer': 'نورة السعدي',
      'customerId': 'CUST-004',
      'amount': 420.75,
      'paidDate': DateTime.now().subtract(Duration(days: 2)),
      'paymentMethod': 'تحويل بنكي',
      'consumption': '510 ك.و.س',
      'previousReading': '4520',
      'currentReading': '5030',
      'address': 'حي الصفا - شارع الخليج',
      'phone': '0556666777',
    },
  ];

  int _selectedIndex = 0;
  final Color _primaryColor = Color(0xFF0D47A1);
  final Color _secondaryColor = Color(0xFF1976D2);
  final Color _accentColor = Color(0xFF64B5F6);
  final Color _backgroundColor = Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF212121);
  final Color _textSecondaryColor = Color(0xFF757575);
  final Color _successColor = Color(0xFF2E7D32);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _errorColor = Color(0xFFD32F2F);
  final Color _borderColor = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المحاسبة - إدارة فواتير الكهرباء'),
        backgroundColor: _primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // تبويبات التنقل
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: _borderColor, width: 1)),
            ),
            child: Row(
              children: [
                _buildTabButton(0, 'الإحصائيات', Icons.bar_chart),
                _buildTabButton(1, 'الفواتير', Icons.receipt),
                _buildTabButton(2, 'العملاء', Icons.people),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildStatisticsTab(),
                _buildBillsTab(),
                _buildCustomersTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateBillDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: _primaryColor,
      ),
    );
  }

  Widget _buildTabButton(int index, String title, IconData icon) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        style: TextButton.styleFrom(
          foregroundColor: _selectedIndex == index
              ? _primaryColor
              : _textSecondaryColor,
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نظرة عامة على الفواتير',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          SizedBox(height: 16),
          // إحصائيات مالية
          Row(
            children: [
              _buildFinanceCard(
                'إجمالي الإيرادات',
                '3,842.25 دينار',
                Colors.green,
                Icons.attach_money,
              ),
              SizedBox(width: 12),
              _buildFinanceCard(
                'الفواتير المتأخرة',
                '5',
                Colors.red,
                Icons.warning,
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildFinanceCard('المدفوعات', '87%', Colors.blue, Icons.payment),
              SizedBox(width: 12),
              _buildFinanceCard(
                'الفواتير الجديدة',
                '2',
                Colors.purple,
                Icons.new_releases,
              ),
            ],
          ),
          SizedBox(height: 20),

          // موجز سريع
          Text(
            'إجراءات سريعة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildQuickAction(Icons.receipt, 'إنشاء فاتورة', _primaryColor),
              SizedBox(width: 12),
              _buildQuickAction(Icons.email, 'إرسال تنبيه', _warningColor),
              SizedBox(width: 12),
              _buildQuickAction(Icons.bar_chart, 'تقارير', _successColor),
            ],
          ),
          SizedBox(height: 20),

          // مخطط بياني بسيط (محاكاة)
          Text(
            'إحصائيات الشهر الحالي',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildChartBar(120, 'مدفوعة', _successColor),
                    _buildChartBar(80, 'متأخرة', _warningColor),
                    _buildChartBar(60, 'غير مدفوعة', _errorColor),
                  ],
                ),
                SizedBox(height: 16),
                Divider(height: 1),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('150', 'فاتورة مدفوعة'),
                    _buildStatItem('25', 'فاتورة متأخرة'),
                    _buildStatItem('18', 'فاتورة جديدة'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              indicatorColor: _primaryColor,
              labelColor: _primaryColor,
              unselectedLabelColor: _textSecondaryColor,
              tabs: [
                Tab(text: 'الفواتير المنتظرة (${pendingBills.length})'),
                Tab(text: 'الفواتير المدفوعة (${paidBills.length})'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [_buildPendingBillsList(), _buildPaidBillsList()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomersTab() {
    // تجميع بيانات العملاء من الفواتير
    final allBills = [...pendingBills, ...paidBills];
    final customers = allBills
        .map(
          (bill) => {
            'name': bill['customer'],
            'id': bill['customerId'],
            'phone': bill['phone'],
            'address': bill['address'],
            'lastBill': bill['id'],
            'amount': bill['amount'],
            'status': bill.containsKey('paidDate') ? 'مدفوع' : bill['status'],
          },
        )
        .toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'قائمة العملاء',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          SizedBox(height: 16),
          ...customers.map((customer) => _buildCustomerCard(customer)).toList(),
        ],
      ),
    );
  }

  Widget _buildFinanceCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: _textSecondaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // إجراء سريع
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Icon(icon, color: color),
                SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartBar(double height, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: _textSecondaryColor)),
      ],
    );
  }

  Widget _buildPendingBillsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: pendingBills.length,
      itemBuilder: (context, index) {
        return _buildPendingBillCard(pendingBills[index]);
      },
    );
  }

  Widget _buildPaidBillsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: paidBills.length,
      itemBuilder: (context, index) {
        return _buildPaidBillCard(paidBills[index]);
      },
    );
  }

  Widget _buildPendingBillCard(Map<String, dynamic> bill) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Icon(Icons.receipt, color: Colors.orange),
        title: Text(
          bill['customer'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${bill['amount']} دينار'),
            Text('رقم العداد: ${bill['customerId']}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chip(
              label: Text(
                bill['status'],
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              backgroundColor: bill['status'] == 'متأخرة'
                  ? Colors.red
                  : Colors.orange,
            ),
            Text(DateFormat('yyyy-MM-dd').format(bill['dueDate'])),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الاستهلاك: ${bill['consumption']}'),
                    Text('القراءة السابقة: ${bill['previousReading']}'),
                    Text('القراءة الحالية: ${bill['currentReading']}'),
                  ],
                ),
                SizedBox(height: 8),
                Text('العنوان: ${bill['address']}'),
                Text('الهاتف: ${bill['phone']}'),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('إشعار دفع'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        _showBillDetails(context, bill);
                      },
                      child: Text('تفاصيل'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text('تعديل'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _warningColor,
                      ),
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

  Widget _buildPaidBillCard(Map<String, dynamic> bill) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.check_circle, color: Colors.green),
        title: Text(
          bill['customer'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${bill['amount']} دينار - ${bill['paymentMethod']}'),
            Text('رقم العداد: ${bill['customerId']}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat('yyyy-MM-dd').format(bill['paidDate'])),
            SizedBox(height: 4),
            Text('مكتملة', style: TextStyle(color: Colors.green)),
          ],
        ),
        onTap: () {
          _showBillDetails(context, bill);
        },
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _primaryColor.withOpacity(0.1),
          child: Icon(Icons.person, color: _primaryColor),
        ),
        title: Text(
          customer['name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الهاتف: ${customer['phone']}'),
            Text(
              'آخر فاتورة: ${customer['lastBill']} - ${customer['amount']} دينار',
            ),
            Text('الحالة: ${customer['status']}'),
          ],
        ),
        trailing: Icon(Icons.chevron_left, color: _textSecondaryColor),
        onTap: () {
          _showCustomerDetails(context, customer);
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تصفية الفواتير'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(title: Text('الكل'), onTap: () {}),
                ListTile(title: Text('غير مدفوعة'), onTap: () {}),
                ListTile(title: Text('متأخرة'), onTap: () {}),
                ListTile(title: Text('مدفوعة'), onTap: () {}),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('تطبيق'),
            ),
          ],
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('بحث عن فاتورة'),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'ابحث برقم الفاتورة أو اسم العميل',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('بحث'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateBillDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('إنشاء فاتورة جديدة'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(decoration: InputDecoration(labelText: 'رقم العداد')),
                TextField(
                  decoration: InputDecoration(labelText: 'القراءة السابقة'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'القراءة الحالية'),
                ),
                TextField(decoration: InputDecoration(labelText: 'المبلغ')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إنشاء'),
            ),
          ],
        );
      },
    );
  }

  void _showBillDetails(BuildContext context, Map<String, dynamic> bill) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تفاصيل الفاتورة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildDetailRow('رقم الفاتورة', bill['id']),
                _buildDetailRow('العميل', bill['customer']),
                _buildDetailRow('رقم العداد', bill['customerId']),
                _buildDetailRow('المبلغ', '${bill['amount']} دينار'),
                if (bill.containsKey('paymentMethod'))
                  _buildDetailRow('طريقة الدفع', bill['paymentMethod']),
                if (bill.containsKey('paidDate'))
                  _buildDetailRow(
                    'تاريخ الدفع',
                    DateFormat('yyyy-MM-dd').format(bill['paidDate']),
                  ),
                if (bill.containsKey('dueDate'))
                  _buildDetailRow(
                    'تاريخ الاستحقاق',
                    DateFormat('yyyy-MM-dd').format(bill['dueDate']),
                  ),
                _buildDetailRow('الاستهلاك', bill['consumption']),
                _buildDetailRow('القراءة السابقة', bill['previousReading']),
                _buildDetailRow('القراءة الحالية', bill['currentReading']),
                _buildDetailRow('العنوان', bill['address']),
                _buildDetailRow('الهاتف', bill['phone']),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('موافق'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCustomerDetails(
    BuildContext context,
    Map<String, dynamic> customer,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تفاصيل العميل',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildDetailRow('اسم العميل', customer['name']),
                _buildDetailRow('رقم العداد', customer['id']),
                _buildDetailRow('الهاتف', customer['phone']),
                _buildDetailRow('العنوان', customer['address']),
                _buildDetailRow('حالة آخر فاتورة', customer['status']),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('موافق'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

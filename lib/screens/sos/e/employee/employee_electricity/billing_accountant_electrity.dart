import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillingAccountantScreen extends StatefulWidget {
  const BillingAccountantScreen({super.key});

  @override
  BillingAccountantScreenState createState() => BillingAccountantScreenState();
}

class BillingAccountantScreenState extends State<BillingAccountantScreen> {
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
  final Color _primaryColor = Color(0xFF4361EE);
  final Color _secondaryColor = Color(0xFF3A0CA3);
  final Color _accentColor = Color(0xFF7209B7);
  final Color _backgroundColor = Color(0xFFF8F9FA);
  final Color _successColor = Color(0xFF4CC9F0);
  final Color _warningColor = Color(0xFFF72585);
  final Color _cardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          title: Text(
            'إدارة الفواتير',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          backgroundColor: _primaryColor,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.search, size: 22, color: Colors.white),
              onPressed: () => _showSearchDialog(context),
            ),
            IconButton(
              icon: Icon(Icons.filter_list, size: 22, color: Colors.white),
              onPressed: () => _showFilterDialog(context),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'الإحصائيات'),
              Tab(text: 'الفواتير'),
              Tab(text: 'العملاء'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStatisticsTab(),
            _buildBillsTab(),
            _buildCustomersTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateBillDialog(context),
          backgroundColor: _primaryColor,
          child: Icon(Icons.add, size: 28, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Header Stats
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_primaryColor, _secondaryColor],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      '3,842.25',
                      'إجمالي الإيرادات',
                      Icons.account_balance_wallet,
                    ),
                    _buildStatItem('5', 'فواتير متأخرة', Icons.warning),
                    _buildStatItem('87%', 'نسبة الدفع', Icons.bar_chart),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.white70, size: 18),
                      SizedBox(width: 8),
                      Text(
                        '${pendingBills.length} فاتورة تحتاج للمتابعة',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  'إنشاء فاتورة',
                  Icons.add,
                  _onCreateBill,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  'إرسال تنبيه',
                  Icons.notifications,
                  _onSendNotification,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  'التقارير',
                  Icons.analytics,
                  _onShowReports,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Monthly Chart
          _buildMonthlyChart(),
          SizedBox(height: 24),

          // Recent Activity
          _buildRecentActivity(),
        ],
      ),
    );
  }

  // الدوال الجديدة للتعامل مع النقر على الأزرار
  void _onCreateBill() {
    _showCreateBillDialog(context);
  }

  void _onSendNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إرسال التنبيه للعملاء المتأخرين'),
        backgroundColor: _successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onShowReports() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('التقارير'),
        content: Text('سيتم عرض التقارير الشاملة للفواتير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildQuickAction(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: _primaryColor, size: 24),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائيات الشهر الحالي',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartBar(120, 'مدفوعة', _successColor),
              _buildChartBar(80, 'متأخرة', _warningColor),
              _buildChartBar(60, 'غير مدفوعة', _primaryColor),
            ],
          ),
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem2('150', 'مدفوعة'),
              _buildStatItem2('25', 'متأخرة'),
              _buildStatItem2('18', 'جديدة'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'النشاط الحديث',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 16),
          ...paidBills.take(3).map((bill) => _buildActivityItem(bill)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> bill) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _successColor.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.receipt, color: _successColor, size: 20),
      ),
      title: Text(
        bill['customer'],
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${bill['amount']} دينار - ${DateFormat('MMM dd').format(bill['paidDate'])}',
      ),
      trailing: Text(
        'مكتملة',
        style: TextStyle(color: _successColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBillsTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: _cardColor,
            child: TabBar(
              indicatorColor: _primaryColor,
              labelColor: _primaryColor,
              unselectedLabelColor: Colors.grey[600],
              tabs: [
                Tab(text: 'المنتظرة (${pendingBills.length})'),
                Tab(text: 'المدفوعة (${paidBills.length})'),
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

  Widget _buildPendingBillsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: pendingBills.length,
      itemBuilder: (context, index) {
        return _buildBillCard(pendingBills[index], true);
      },
    );
  }

  Widget _buildPaidBillsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: paidBills.length,
      itemBuilder: (context, index) {
        return _buildBillCard(paidBills[index], false);
      },
    );
  }

  Widget _buildBillCard(Map<String, dynamic> bill, bool isPending) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bill['id'],
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPending
                        ? _warningColor.withOpacity(0.2)
                        : _successColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isPending ? bill['status'] : 'مكتملة',
                    style: TextStyle(
                      color: isPending ? _warningColor : _successColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              bill['customer'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  isPending
                      ? 'استحقاق: ${DateFormat('MMM dd').format(bill['dueDate'])}'
                      : 'دفعت: ${DateFormat('MMM dd').format(bill['paidDate'])}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${bill['amount']} دينار',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: _primaryColor,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.visibility, size: 20),
                      onPressed: () => _showBillDetails(context, bill),
                    ),
                    if (isPending)
                      IconButton(
                        icon: Icon(Icons.notifications, size: 20),
                        onPressed: () => _onSendNotificationToCustomer(bill),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onSendNotificationToCustomer(Map<String, dynamic> bill) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إرسال تنبيه إلى ${bill['customer']}'),
        backgroundColor: _successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildCustomersTab() {
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

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        return _buildCustomerCard(customers[index]);
      },
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
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
            Text('الحالة: ${customer['status']}'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showCustomerDetails(context, customer),
      ),
    );
  }

  Widget _buildChartBar(double height, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildStatItem2(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'تصفية الفواتير',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 20),
            ...['الكل', 'غير مدفوعة', 'متأخرة', 'مدفوعة']
                .map(
                  (filter) => ListTile(
                    title: Text(filter),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تم تطبيق عامل التصفية: $filter'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'بحث عن فاتورة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'ابحث برقم الفاتورة أو اسم العميل',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('جاري البحث...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Text('بحث'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateBillDialog(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _meterNumberController =
        TextEditingController();
    final TextEditingController _customerNameController =
        TextEditingController();
    final TextEditingController _previousReadingController =
        TextEditingController();
    final TextEditingController _currentReadingController =
        TextEditingController();
    final TextEditingController _amountController = TextEditingController();
    final TextEditingController _addressController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'إنشاء فاتورة جديدة',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 20),

              // رقم العداد
              TextFormField(
                controller: _meterNumberController,
                decoration: InputDecoration(
                  labelText: 'رقم العداد *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم العداد';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // اسم العميل
              TextFormField(
                controller: _customerNameController,
                decoration: InputDecoration(
                  labelText: 'اسم العميل *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم العميل';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // القراءة السابقة
              TextFormField(
                controller: _previousReadingController,
                decoration: InputDecoration(
                  labelText: 'القراءة السابقة *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال القراءة السابقة';
                  }
                  if (double.tryParse(value) == null) {
                    return 'يرجى إدخال رقم صحيح';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // القراءة الحالية
              TextFormField(
                controller: _currentReadingController,
                decoration: InputDecoration(
                  labelText: 'القراءة الحالية *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال القراءة الحالية';
                  }
                  if (double.tryParse(value) == null) {
                    return 'يرجى إدخال رقم صحيح';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // المبلغ
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'المبلغ *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال المبلغ';
                  }
                  if (double.tryParse(value) == null) {
                    return 'يرجى إدخال رقم صحيح';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // العنوان
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'العنوان',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // الهاتف
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'الهاتف',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),

              // زر الإنشاء
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // إذا كانت جميع الحقول صحيحة
                    Navigator.pop(context);

                    // إضافة الفاتورة الجديدة
                    _addNewBillToPending(
                      _meterNumberController.text,
                      _customerNameController.text,
                      double.parse(_amountController.text),
                      _previousReadingController.text,
                      _currentReadingController.text,
                      _addressController.text,
                      _phoneController.text,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم إنشاء الفاتورة بنجاح للعميل ${_customerNameController.text}',
                        ),
                        backgroundColor: _successColor,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: Text('إنشاء الفاتورة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // زر الإلغاء
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
              ),

              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  // دالة جديدة لإضافة فاتورة جديدة إلى القائمة
  void _addNewBillToPending(
    String meterNumber,
    String customerName,
    double amount,
    String previousReading,
    String currentReading,
    String address,
    String phone,
  ) {
    // حساب الاستهلاك
    double prev = double.tryParse(previousReading) ?? 0;
    double curr = double.tryParse(currentReading) ?? 0;
    double consumption = curr - prev;

    setState(() {
      pendingBills.insert(0, {
        'id': 'INV-${DateTime.now().millisecondsSinceEpoch}',
        'customer': customerName,
        'customerId': meterNumber,
        'amount': amount,
        'dueDate': DateTime.now().add(Duration(days: 30)),
        'status': 'غير مدفوعة',
        'consumption': '${consumption.toInt()} ك.و.س',
        'previousReading': previousReading,
        'currentReading': currentReading,
        'address': address.isNotEmpty ? address : 'لم يتم تحديد العنوان',
        'phone': phone.isNotEmpty ? phone : 'لم يتم تحديد الهاتف',
      });
    });
  }

  void _showBillDetails(BuildContext context, Map<String, dynamic> bill) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تفاصيل الفاتورة',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              ..._buildBillDetails(bill),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('تم'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBillDetails(Map<String, dynamic> bill) {
    return [
      _buildDetailItem('رقم الفاتورة', bill['id']),
      _buildDetailItem('العميل', bill['customer']),
      _buildDetailItem('المبلغ', '${bill['amount']} دينار'),
      _buildDetailItem('الاستهلاك', bill['consumption']),
      _buildDetailItem('العنوان', bill['address']),
      _buildDetailItem('الهاتف', bill['phone']),
    ];
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showCustomerDetails(
    BuildContext context,
    Map<String, dynamic> customer,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تفاصيل العميل',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              _buildDetailItem('الاسم', customer['name']),
              _buildDetailItem('رقم العداد', customer['id']),
              _buildDetailItem('الهاتف', customer['phone']),
              _buildDetailItem('الحالة', customer['status']),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('تم'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

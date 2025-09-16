import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WasteBillingOfficerScreen extends StatefulWidget {
  const WasteBillingOfficerScreen({super.key});

  @override
  State<WasteBillingOfficerScreen> createState() => _WasteBillingOfficerScreenState();
}

class _WasteBillingOfficerScreenState extends State<WasteBillingOfficerScreen> with SingleTickerProviderStateMixin {
  // الألوان الجديدة - تصميم عصري وأنيق
  final Color _primaryColor = const Color(0xFF2A6EBB); // أزرق رئيسي
  final Color _secondaryColor = const Color(0xFF33C1B1); // تركواز
  final Color _accentColor = const Color(0xFFFF7D29); // برتقالي
  final Color _backgroundColor = const Color(0xFFF5F8FF); // أزرق فاتح جداً
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF2D3748);
  final Color _textSecondaryColor = const Color(0xFF718096);
  final Color _successColor = const Color(0xFF38A169);
  final Color _warningColor = const Color(0xFFDD6B20);
  final Color _errorColor = const Color(0xFFE53E3E);
  final Color _borderColor = const Color(0xFFE2E8F0);

  late TabController _tabController;
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pendingBills = [];
  final List<Map<String, dynamic>> _paidBills = [];
  final List<Map<String, dynamic>> _overdueBills = [];

  // متغيرات للتحريك
  double _tabBarHeight = 70.0;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _loadSampleData();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        // تأثير اهتزازي بسيط عند تغيير التبويب
        _tabBarHeight = 65.0;
      });
      
      Future.delayed(const Duration(milliseconds: 150), () {
        setState(() {
          _tabBarHeight = 70.0;
        });
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadSampleData() {
    // بيانات نموذجية للفواتير
    setState(() {
      _pendingBills.addAll([
        {
          'id': 'WASTE-001',
          'customer': 'أحمد محمد',
          'address': 'حي السلام، شارع 10',
          'amount': 75.0,
          'period': 'يناير 2024',
          'status': 'pending',
          'containerType': 'كبيرة (360 لتر)',
          'dateIssued': DateTime(2024, 1, 15),
          'dueDate': DateTime(2024, 2, 5),
        },
        {
          'id': 'WASTE-002',
          'customer': 'سارة عبدالله',
          'address': 'حي النهضة، شارع 20',
          'amount': 50.0,
          'period': 'يناير 2024',
          'status': 'pending',
          'containerType': 'متوسطة (240 لتر)',
          'dateIssued': DateTime(2024, 1, 15),
          'dueDate': DateTime(2024, 2, 5),
        },
      ]);

      _paidBills.addAll([
        {
          'id': 'WASTE-003',
          'customer': 'خالد إبراهيم',
          'address': 'حي الورود، شارع 5',
          'amount': 75.0,
          'period': 'ديسمبر 2023',
          'status': 'paid',
          'containerType': 'كبيرة (360 لتر)',
          'dateIssued': DateTime(2023, 12, 15),
          'dueDate': DateTime(2024, 1, 5),
          'paidDate': DateTime(2024, 1, 3),
        },
        {
          'id': 'WASTE-005',
          'customer': 'محمد السعدي',
          'address': 'حي الروضة، شارع 8',
          'amount': 60.0,
          'period': 'ديسمبر 2023',
          'status': 'paid',
          'containerType': 'صغيرة (120 لتر)',
          'dateIssued': DateTime(2023, 12, 15),
          'dueDate': DateTime(2024, 1, 5),
          'paidDate': DateTime(2024, 1, 2),
        },
      ]);

      _overdueBills.addAll([
        {
          'id': 'WASTE-004',
          'customer': 'فاطمة علي',
          'address': 'حي المصيف، شارع 15',
          'amount': 50.0,
          'period': 'ديسمبر 2023',
          'status': 'overdue',
          'containerType': 'متوسطة (240 لتر)',
          'dateIssued': DateTime(2023, 12, 15),
          'dueDate': DateTime(2024, 1, 5),
          'daysOverdue': 15,
        },
        {
          'id': 'WASTE-006',
          'customer': 'علي حسين',
          'address': 'حي الفيصلية، شارع 12',
          'amount': 75.0,
          'period': 'ديسمبر 2023',
          'status': 'overdue',
          'containerType': 'كبيرة (360 لتر)',
          'dateIssued': DateTime(2023, 12, 15),
          'dueDate': DateTime(2024, 1, 5),
          'daysOverdue': 10,
        },
      ]);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _isSearching ? _buildSearchAppBar() : _buildMainAppBar(),
      body: Column(
        children: [
          // شريط الإحصائيات مع تأثيرات
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isSearching ? 0 : 120,
            child: _isSearching ? SizedBox.shrink() : _buildStatsBar(),
          ),
          
          // تبويبات مع تأثيرات متحركة
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _tabBarHeight,
            curve: Curves.easeInOut,
            child: _isSearching ? SizedBox.shrink() : _buildAnimatedTabBar(),
          ),
          
          // محتوى التبويب
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // الفواتير الجديدة
                _buildBillsList(_pendingBills, 'pending'),
                
                // الفواتير المدفوعة
                _buildBillsList(_paidBills, 'paid'),
                
                // الفواتير المتأخرة
                _buildBillsList(_overdueBills, 'overdue'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showGenerateBillDialog(context);
        },
        backgroundColor: _primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildMainAppBar() {
    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'ابحث عن فاتورة...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
                autofocus: true,
              )
            : const Text(
                'نظام إدارة فواتير النفايات',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
      backgroundColor: _primaryColor,
      centerTitle: true,
      elevation: 4,
      shadowColor: _primaryColor.withOpacity(0.4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: _toggleSearch,
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // الانتقال إلى شاشة الإشعارات
          },
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            // الانتقال إلى الملف الشخصي
          },
        ),
      ],
    );
  }

  AppBar _buildSearchAppBar() {
    return AppBar(
      title: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'ابحث عن فاتورة...',
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.white),
        autofocus: true,
      ),
      backgroundColor: _primaryColor,
      centerTitle: true,
      elevation: 4,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _toggleSearch,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _searchController.clear();
          },
        ),
      ],
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.pending_actions, 'قيد الانتظار', _pendingBills.length.toString(), _warningColor),
          _buildStatItem(Icons.paid, 'المدفوعة', _paidBills.length.toString(), _successColor),
          _buildStatItem(Icons.warning, 'المتأخرة', _overdueBills.length.toString(), _errorColor),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String title, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(title, style: TextStyle(color: _textSecondaryColor, fontSize: 12)),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAnimatedTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _primaryColor,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: _textSecondaryColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        tabs: const [
          Tab(text: 'الفواتير الجديدة'),
          Tab(text: 'الفواتير المدفوعة'),
          Tab(text: 'الفواتير المتأخرة'),
        ],
        onTap: (index) {
          setState(() {
            // تأثير اهتزازي عند النقر على التبويب
            _tabBarHeight = 65.0;
          });
          
          Future.delayed(const Duration(milliseconds: 150), () {
            setState(() {
              _tabBarHeight = 70.0;
            });
          });
        },
      ),
    );
  }

  Widget _buildBillsList(List<Map<String, dynamic>> bills, String status) {
    if (bills.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 60,
              color: _textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              status == 'pending' 
                ? 'لا توجد فواتير جديدة' 
                : status == 'paid' 
                  ? 'لا توجد فواتير مدفوعة' 
                  : 'لا توجد فواتير متأخرة',
              style: TextStyle(
                color: _textSecondaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bills.length,
      itemBuilder: (context, index) {
        final bill = bills[index];
        return _buildBillCard(bill, status, index);
      },
    );
  }

  Widget _buildBillCard(Map<String, dynamic> bill, String status, int index) {
    Color statusColor = _primaryColor;
    IconData statusIcon = Icons.pending;
    String statusText = 'قيد الانتظار';

    if (status == 'paid') {
      statusColor = _successColor;
      statusIcon = Icons.check_circle;
      statusText = 'تم الدفع';
    } else if (status == 'overdue') {
      statusColor = _errorColor;
      statusIcon = Icons.warning;
      statusText = 'متأخرة';
    }

    return Dismissible(
      key: Key(bill['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: _errorColor,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _showDeleteBillDialog(context, bill);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200 + (index * 100)),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, index.isEven ? 0 : 0, 0),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: _borderColor, width: 1),
          ),
          shadowColor: _primaryColor.withOpacity(0.2),
          child: InkWell(
            onTap: () {
              _showBillDetails(context, bill, status);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bill['id'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                          fontSize: 16,
                        ),
                      ),
                      Chip(
                        backgroundColor: statusColor.withOpacity(0.1),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(statusIcon, size: 16, color: statusColor),
                            const SizedBox(width: 4),
                            Text(
                              statusText,
                              style: TextStyle(color: statusColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bill['customer'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bill['address'],
                    style: TextStyle(
                      color: _textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'فترة الفاتورة: ${bill['period']}',
                        style: TextStyle(
                          color: _textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'نوع الحاوية: ${bill['containerType']}',
                        style: TextStyle(
                          color: _textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: _borderColor, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المبلغ: ${bill['amount'].toStringAsFixed(2)} ر.س',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          if (status == 'pending' || status == 'overdue')
                            IconButton(
                              icon: Icon(Icons.edit, color: _primaryColor, size: 20),
                              onPressed: () {
                                _showEditBillDialog(context, bill);
                              },
                            ),
                          if (status == 'pending' || status == 'overdue')
                            IconButton(
                              icon: Icon(Icons.delete, color: _errorColor, size: 20),
                              onPressed: () {
                                _showDeleteBillDialog(context, bill);
                              },
                            ),
                          if (status == 'paid')
                            Text(
                              'تم الدفع في: ${DateFormat('yyyy-MM-dd').format(bill['paidDate'])}',
                              style: TextStyle(
                                color: _successColor,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (status == 'overdue')
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'متأخرة بمقدار: ${bill['daysOverdue']} يوم',
                        style: TextStyle(
                          color: _errorColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: 'الفواتير',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          activeIcon: Icon(Icons.analytics),
          label: 'التقارير',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: _primaryColor,
      unselectedItemColor: _textSecondaryColor,
      onTap: _onItemTapped,
      backgroundColor: Colors.white,
      elevation: 8,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }

  void _showBillDetails(BuildContext context, Map<String, dynamic> bill, String status) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: _borderColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                Text(
                  'تفاصيل الفاتورة',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow('رقم الفاتورة', bill['id']),
                _buildDetailRow('العميل', bill['customer']),
                _buildDetailRow('العنوان', bill['address']),
                _buildDetailRow('نوع الحاوية', bill['containerType']),
                _buildDetailRow('فترة الفاتورة', bill['period']),
                _buildDetailRow('تاريخ الإصدار', DateFormat('yyyy-MM-dd').format(bill['dateIssued'])),
                _buildDetailRow('تاريخ الاستحقاق', DateFormat('yyyy-MM-dd').format(bill['dueDate'])),
                if (status == 'paid')
                  _buildDetailRow('تاريخ الدفع', DateFormat('yyyy-MM-dd').format(bill['paidDate'])),
                if (status == 'overdue')
                  _buildDetailRow('أيام التأخير', '${bill['daysOverdue']} يوم'),
                const SizedBox(height: 16),
                Divider(color: _borderColor, thickness: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المبلغ الإجمالي',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                    Text(
                      '${bill['amount'].toStringAsFixed(2)} ر.س',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (status == 'pending' || status == 'overdue')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditBillDialog(context, bill);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'تعديل الفاتورة',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: _primaryColor),
                    ),
                    child: Text(
                      'إغلاق',
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 16,
                      ),
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

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: _textSecondaryColor,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: _textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showGenerateBillDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إنشاء فاتورة جديدة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'اسم العميل',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'العنوان',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'نوع الحاوية',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['صغيرة (120 لتر)', 'متوسطة (240 لتر)', 'كبيرة (360 لتر)']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'المبلغ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixText: 'ر.س ',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: _primaryColor),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(color: _primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // حفظ الفاتورة الجديدة
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('تم إنشاء الفاتورة بنجاح'),
                              backgroundColor: _successColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('إنشاء'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditBillDialog(BuildContext context, Map<String, dynamic> bill) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تعديل الفاتورة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: bill['customer'],
                  decoration: InputDecoration(
                    labelText: 'اسم العميل',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: bill['address'],
                  decoration: InputDecoration(
                    labelText: 'العنوان',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  value: bill['containerType'],
                  decoration: InputDecoration(
                    labelText: 'نوع الحاوية',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['صغيرة (120 لتر)', 'متوسطة (240 لتر)', 'كبيرة (360 لتر)']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: bill['amount'].toString(),
                  decoration: InputDecoration(
                    labelText: 'المبلغ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixText: 'ر.س ',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: _primaryColor),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(color: _primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // حفظ التعديلات
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('تم تعديل الفاتورة بنجاح'),
                              backgroundColor: _successColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('حفظ'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteBillDialog(BuildContext context, Map<String, dynamic> bill) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حذف الفاتورة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'هل أنت متأكد من حذف فاتورة ${bill['id']}؟',
                  style: TextStyle(
                    color: _textSecondaryColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: _primaryColor),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(color: _primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // حذف الفاتورة
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم حذف فاتورة ${bill['id']}'),
                              backgroundColor: _successColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _errorColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('حذف'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
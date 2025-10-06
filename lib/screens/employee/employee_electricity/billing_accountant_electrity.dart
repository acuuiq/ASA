import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mang_mu/providers/language_provider.dart' show LanguageProvider;
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';
import 'package:mang_mu/language/app_localizations.dart';

class BillingAccountantScreen extends StatefulWidget {
  static const String screenRoute = '/billing-accountant';
  
  const BillingAccountantScreen({super.key});

  @override
  BillingAccountantScreenState createState() => BillingAccountantScreenState();
}

class BillingAccountantScreenState extends State<BillingAccountantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  // الألوان الجديدة للتصميم المحسّن
  final Color _primaryColor = Color(0xFF0D47A1);
  final Color _secondaryColor = Color(0xFF1976D2);
  final Color _backgroundColor = Color(0xFFF8F9FA);
  final Color _textColor = Color(0xFF212121);
  final Color _textSecondaryColor = Color(0xFF757575);
  final Color _successColor = Color(0xFF2E7D32);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _errorColor = Color(0xFFD32F2F);
  final Color _borderColor = Color(0xFFE0E0E0);

  String _formatCurrency(double amount) {
    final localizations = AppLocalizations.of(context);
    return '${NumberFormat('#,##0').format(amount)} ${localizations.translate('currency')}';
  }

  final List<Map<String, dynamic>> pendingBills = [
    {
      'id': 'INV-2024-001',
      'customer': 'أحمد محمد',
      'customerId': 'CUST-001',
      'amount': 185.75,
      'amountIQD': 91018,
      'dueDate': DateTime.now().add(Duration(days: 5)),
      'status': 'unpaid',
      'consumption': '250 ك.و.س',
      'previousReading': '1250',
      'currentReading': '1500',
      'address': 'حي الرياض - شارع الملك فهد',
      'phone': '077235477514',
    },
    {
      'id': 'INV-2024-002',
      'customer': 'فاطمة علي',
      'customerId': 'CUST-002',
      'amount': 230.50,
      'amountIQD': 112945,
      'dueDate': DateTime.now().subtract(Duration(days: 3)),
      'status': 'overdue',
      'consumption': '320 ك.و.س',
      'previousReading': '2100',
      'currentReading': '2420',
      'address': 'حي النخيل - شارع الأمير محمد',
      'phone': '07827534903',
    },
    {
      'id': 'INV-2024-005',
      'customer': 'خالد إبراهيم',
      'customerId': 'CUST-005',
      'amount': 315.25,
      'amountIQD': 154473,
      'dueDate': DateTime.now().add(Duration(days: 2)),
      'status': 'unpaid',
      'consumption': '280 ك.و.س',
      'previousReading': '3200',
      'currentReading': '3480',
      'address': 'حي العليا - شارع العروبة',
      'phone': '07758888999',
    },
  ];

  final List<Map<String, dynamic>> paidBills = [
    {
      'id': 'INV-2024-003',
      'customer': 'سالم عبدالله',
      'customerId': 'CUST-003',
      'amount': 150.25,
      'amountIQD': 73623,
      'paidDate': DateTime.now().subtract(Duration(days: 1)),
      'paymentMethod': 'بطاقة ائتمان',
      'consumption': '180 ك.و.س',
      'previousReading': '3050',
      'currentReading': '3230',
      'address': 'حي العليا - شارع العروبة',
      'phone': '07755555555',
    },
    {
      'id': 'INV-2024-004',
      'customer': 'نورة السعدي',
      'customerId': 'CUST-004',
      'amount': 420.75,
      'amountIQD': 206168,
      'paidDate': DateTime.now().subtract(Duration(days: 2)),
      'paymentMethod': 'تحويل بنكي',
      'consumption': '510 ك.و.س',
      'previousReading': '4520',
      'currentReading': '5030',
      'address': 'حي الصفا - شارع الخليج',
      'phone': '07856666777',
    },
    {
      'id': 'INV-2024-006',
      'customer': 'محمد حسن',
      'customerId': 'CUST-006',
      'amount': 275.50,
      'amountIQD': 134995,
      'paidDate': DateTime.now().subtract(Duration(days: 5)),
      'paymentMethod': 'نقدي',
      'consumption': '220 ك.و.س',
      'previousReading': '1800',
      'currentReading': '2020',
      'address': 'حي الورود - شارع الخليج',
      'phone': '07757777888',
    },
  ];

  final List<Map<String, dynamic>> overdueBills = [
    {
      'id': 'INV-2024-007',
      'customer': 'علي أحمد',
      'customerId': 'CUST-007',
      'amount': 190.00,
      'amountIQD': 93100,
      'dueDate': DateTime.now().subtract(Duration(days: 10)),
      'status': 'overdue',
      'consumption': '210 ك.و.س',
      'previousReading': '4100',
      'currentReading': '4310',
      'address': 'حي السلام - شارع الجامعة',
      'phone': '07759999000',
      'delayReason': 'notReceived',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('accountantDashboard'),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
  icon: Stack(
    children: [
      Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
      Positioned(
        right: 0,
        top: 0,
        child: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          constraints: BoxConstraints(minWidth: 16, minHeight: 16),
          child: Text(
            '2',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  ),
  onPressed: () {
    Navigator.pushNamed(context, NotificationsScreen.routeName);
  },
),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 3, color: _primaryColor),
                ),
              ),
              labelColor: _primaryColor,
              unselectedLabelColor: isDarkMode ? Colors.white70 : _textSecondaryColor,
              labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              tabs: [
                Tab(text: '${localizations.translate('activeBills')} (${pendingBills.length})'),
                Tab(text: '${localizations.translate('paidBills')} (${paidBills.length})'),
                Tab(text: '${localizations.translate('overdueBills')} (${overdueBills.length})'),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode 
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D1B2A),
                    Color(0xFF1B263B),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF8F9FA),
                    Color(0xFFE9ECEF),
                  ],
                ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPendingBillsView(isDarkMode),
            _buildPaidBillsView(isDarkMode),
            _buildOverdueBillsView(isDarkMode),
          ],
        ),
      ),
      drawer: _buildDrawer(context, isDarkMode),
    );
  }

  Widget _buildPendingBillsView(bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAccountantInfoCard(isDarkMode),
          SizedBox(height: 20),
          _buildStatsRow(isDarkMode),
          SizedBox(height: 20),
          Text(
            localizations.translate('activeBills'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : _primaryColor,
            ),
          ),
          SizedBox(height: 16),
          ...pendingBills.map((bill) => _buildPendingBillCard(bill, isDarkMode)),
        ],
      ),
    );
  }

  Widget _buildPaidBillsView(bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerformanceCard(isDarkMode),
          SizedBox(height: 20),
          Text(
            localizations.translate('paidBills'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : _primaryColor,
            ),
          ),
          SizedBox(height: 16),
          ...paidBills.map((bill) => _buildPaidBillCard(bill, isDarkMode)),
        ],
      ),
    );
  }

  Widget _buildOverdueBillsView(bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverdueAnalysisCard(isDarkMode),
          SizedBox(height: 20),
          Text(
            localizations.translate('overdueBills'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _errorColor,
            ),
          ),
          SizedBox(height: 16),
          ...overdueBills.map((bill) => _buildOverdueBillCard(bill, isDarkMode)),
        ],
      ),
    );
  }

  Widget _buildAccountantInfoCard(bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Color(0xFF1E3A5F), Color(0xFF0D47A1)]
              : [Colors.white, Color(0xFFE3F2FD)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(Icons.person_rounded, color: Colors.white, size: 32),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.translate('accountantName'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? Colors.white : _textColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    localizations.translate('accountantTitle'),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : _textSecondaryColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _successColor.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.assignment_turned_in_rounded, color: _successColor, size: 16),
                            SizedBox(width: 6),
                            Text(
                              '${paidBills.length} ${localizations.translate('paidInvoices')}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: _successColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _primaryColor.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.attach_money_rounded, color: _primaryColor, size: 16),
                            SizedBox(width: 6),
                            Text(
                              '${_formatCurrency(_calculateTotalRevenue())}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: _primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 4),
          _buildStatCard(
            localizations.translate('activeBills'),
            pendingBills.length.toString(),
            Icons.receipt_long_rounded,
            _primaryColor,
            isDarkMode,
          ),
          SizedBox(width: 12),
          _buildStatCard(
            localizations.translate('paidBills'),
            paidBills.length.toString(),
            Icons.verified_rounded,
            _successColor,
            isDarkMode,
          ),
          SizedBox(width: 12),
          _buildStatCard(
            localizations.translate('overdueBills'),
            overdueBills.length.toString(),
            Icons.warning_amber_rounded,
            _errorColor,
            isDarkMode,
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white70 : _textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingBillCard(Map<String, dynamic> bill, bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    double amount = (bill['amountIQD'] ?? bill['amount'] ?? 0).toDouble();
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _getStatusColor(bill['status']).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.receipt_long_rounded,
            color: _getStatusColor(bill['status']),
            size: 22,
          ),
        ),
        title: Text(
          '${localizations.translate('invoiceNumber')} #${bill['id']}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: isDarkMode ? Colors.white : _textColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            Text(
              bill['customer'],
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : _textSecondaryColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${localizations.translate('amount')}: ${_formatCurrency(amount)}',
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white60 : _textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(bill['status']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _getStatusColor(bill['status']).withOpacity(0.3)),
          ),
          child: Text(
            _getStatusText(bill['status']),
            style: TextStyle(
              fontSize: 12,
              color: _getStatusColor(bill['status']),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildDetailRow('${localizations.translate('invoiceNumber')}:', bill['id'], isDarkMode),
                SizedBox(height: 12),
                _buildDetailRow('${localizations.translate('customer')}:', bill['customer'], isDarkMode),
                SizedBox(height: 12),
                _buildDetailRow('${localizations.translate('customerPhone')}:', bill['phone'], isDarkMode),
                SizedBox(height: 12),
                _buildDetailRow('${localizations.translate('amount')}:', _formatCurrency(amount), isDarkMode),
                SizedBox(height: 12),
                _buildDetailRow('${localizations.translate('dueDate')}:', 
                  DateFormat('yyyy-MM-dd').format(bill['dueDate']), isDarkMode),
                SizedBox(height: 12),
                _buildDetailRow('${localizations.translate('consumption')}:', bill['consumption'], isDarkMode),
                SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _markAsPaid(bill);
                      },
                      icon: Icon(Icons.check_rounded, size: 18),
                      label: Text(localizations.translate('markAsPaid')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _successColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _sendReminder(bill);
                      },
                      icon: Icon(Icons.notifications_active_rounded, size: 18),
                      label: Text(localizations.translate('sendReminder')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _warningColor,
                        side: BorderSide(color: _warningColor),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _contactCustomer(bill);
                      },
                      icon: Icon(Icons.phone_rounded, size: 18),
                      label: Text(localizations.translate('contactCustomer')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primaryColor,
                        side: BorderSide(color: _primaryColor),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildPaidBillCard(Map<String, dynamic> bill, bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    double amount = (bill['amountIQD'] ?? bill['amount'] ?? 0).toDouble();
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(20),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _successColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.verified_rounded, color: _successColor, size: 24),
        ),
        title: Text(
          '${localizations.translate('invoiceNumber')} #${bill['id']}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: isDarkMode ? Colors.white : _textColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              bill['customer'],
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : _textSecondaryColor,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '${localizations.translate('amount')}: ${_formatCurrency(amount)}',
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white60 : _textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${localizations.translate('paymentMethod')}: ${bill['paymentMethod']}',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white54 : _textSecondaryColor,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(Icons.credit_score_rounded, color: _successColor, size: 24),
            SizedBox(height: 8),
            Text(
              DateFormat('MM-dd').format(bill['paidDate']),
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white54 : _textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        onTap: () {
          _showBillDetails(bill, true, isDarkMode);
        },
      ),
    );
  }

  Widget _buildOverdueBillCard(Map<String, dynamic> bill, bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    double amount = (bill['amountIQD'] ?? bill['amount'] ?? 0).toDouble();
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _errorColor.withOpacity(0.05),
        border: Border.all(color: _errorColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(20),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _errorColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.warning_amber_rounded, color: _errorColor, size: 24),
        ),
        title: Text(
          '${localizations.translate('invoiceNumber')} #${bill['id']}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: isDarkMode ? Colors.white : _textColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              bill['customer'],
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : _textSecondaryColor,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '${localizations.translate('amount')}: ${_formatCurrency(amount)}',
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white60 : _textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            if (bill['delayReason'] != null)
              Text(
                '${localizations.translate('delayReason')}: ${_getDelayReasonText(bill['delayReason'])}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white54 : _textSecondaryColor,
                ),
              ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _errorColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _errorColor.withOpacity(0.3)),
          ),
          child: Text(
            _getStatusText(bill['status']),
            style: TextStyle(
              fontSize: 12,
              color: _errorColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          _showBillDetails(bill, false, isDarkMode);
        },
      ),
    );
  }

  Widget _buildPerformanceCard(bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    double totalRevenue = _calculateTotalRevenue();
    int totalBills = paidBills.length + pendingBills.length + overdueBills.length;
    double paymentRate = totalBills > 0 ? (paidBills.length / totalBills * 100) : 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Color(0xFF1E1E1E), Color(0xFF2D2D2D)]
              : [Colors.white, Color(0xFFF8F9FA)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.analytics_rounded, color: _primaryColor, size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  localizations.translate('monthlyPerformance'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : _primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 8),
                  _buildPerformanceIndicator(
                    localizations.translate('totalRevenue'),
                    _formatCurrency(totalRevenue),
                    Icons.attach_money_rounded,
                    _primaryColor,
                    isDarkMode,
                  ),
                  SizedBox(width: 20),
                  _buildPerformanceIndicator(
                    localizations.translate('paymentRate'),
                    '${paymentRate.toStringAsFixed(1)}%',
                    Icons.trending_up_rounded,
                    _successColor,
                    isDarkMode,
                  ),
                  SizedBox(width: 20),
                  _buildPerformanceIndicator(
                    localizations.translate('paidInvoicesCount'),
                    '${paidBills.length}',
                    Icons.verified_rounded,
                    _successColor,
                    isDarkMode,
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isDarkMode ? Colors.white12 : _backgroundColor,
              ),
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: constraints.maxWidth * (paymentRate / 100),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: LinearGradient(
                            colors: [_successColor, Color(0xFF4CAF50)],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.translate('paymentRate'),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : _textSecondaryColor,
                  ),
                ),
                Text(
                  '${paymentRate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _successColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceIndicator(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Container(
      width: 110,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? Colors.white10 : Colors.white,
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode ? Colors.white60 : _textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOverdueAnalysisCard(bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    double totalOverdueAmount = 1355 * 490;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Color(0xFF1E1E1E), Color(0xFF2D2D2D)]
              : [Colors.white, Color(0xFFF8F9FA)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.analytics_outlined, color: _errorColor, size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  localizations.translate('overdueAnalysis'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : _primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildOverdueReason(localizations.translate('notReceived'), 2, 850 * 490, isDarkMode),
            SizedBox(height: 16),
            _buildOverdueReason(localizations.translate('paymentIssues'), 1, 190 * 490, isDarkMode),
            SizedBox(height: 16),
            _buildOverdueReason(localizations.translate('incorrectData'), 1, 315 * 490, isDarkMode),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _errorColor.withOpacity(0.05),
                border: Border.all(color: _errorColor.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${localizations.translate('totalOverdueAmount')}:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white70 : _textColor,
                    ),
                  ),
                  Text(
                    _formatCurrency(totalOverdueAmount),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: _errorColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverdueReason(String reason, int count, double amount, bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? Colors.white10 : Colors.white,
        border: Border.all(color: isDarkMode ? Colors.white24 : _borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              reason, 
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : _textColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$count ${localizations.translate('invoicesCount')}',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white60 : _textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              _formatCurrency(amount),
              style: TextStyle(
                fontSize: 14,
                color: _errorColor,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    
    return Drawer(
      backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_primaryColor, _secondaryColor],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(Icons.person_rounded, color: Colors.white, size: 40),
                ),
                SizedBox(height: 16),
                Text(
                  localizations.translate('accountantName'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  localizations.translate('accountantTitle'),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // قسم التبويبات الرئيسية
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              localizations.translate('mainTabs'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white70 : _primaryColor,
              ),
            ),
          ),
          
          // تبويب الفواتير النشطة
          _buildDrawerItem(
            context: context,
            title: localizations.translate('activeBills'),
            icon: Icons.receipt_long_rounded,
            count: pendingBills.length,
            isActive: _currentIndex == 0,
            isDarkMode: isDarkMode,
            onTap: () {
              Navigator.pop(context);
              _tabController.animateTo(0);
            },
          ),
          
          // تبويب الفواتير المدفوعة
          _buildDrawerItem(
            context: context,
            title: localizations.translate('paidBills'),
            icon: Icons.verified_rounded,
            count: paidBills.length,
            isActive: _currentIndex == 1,
            isDarkMode: isDarkMode,
            color: _successColor,
            onTap: () {
              Navigator.pop(context);
              _tabController.animateTo(1);
            },
          ),
          
          // تبويب الفواتير المتأخرة
          _buildDrawerItem(
            context: context,
            title: localizations.translate('overdueBills'),
            icon: Icons.warning_amber_rounded,
            count: overdueBills.length,
            isActive: _currentIndex == 2,
            isDarkMode: isDarkMode,
            color: _errorColor,
            onTap: () {
              Navigator.pop(context);
              _tabController.animateTo(2);
            },
          ),
          
          Divider(color: isDarkMode ? Colors.white24 : _borderColor),
          
          // قسم الإعدادات والإجراءات الأخرى
          Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              localizations.translate('settingsAndActions'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white70 : _primaryColor,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.people_alt_rounded, color: Colors.green, size: 20),
            ),
            title: Text(
              localizations.translate('customerManagement'),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : _textColor,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomersScreen()));
            },
          ),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.settings_rounded, color: _primaryColor, size: 20),
            ),
            title: Text(
              localizations.translate('settings'),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : _textColor,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          Divider(color: isDarkMode ? Colors.white24 : _borderColor),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.logout_rounded, color: _errorColor, size: 20),
            ),
            title: Text(
              localizations.translate('logout'),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color:Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required int count,
    required bool isActive,
    required bool isDarkMode,
    Color color = const Color(0xFF0D47A1),
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isActive ? color.withOpacity(0.1) : Colors.transparent,
        border: isActive ? Border.all(color: color.withOpacity(0.3)) : null,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.2) : color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: isActive ? color : color.withOpacity(0.7), size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? color : (isDarkMode ? Colors.white : _textColor),
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : _textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value, 
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white : _textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'unpaid':
        return _primaryColor;
      case 'overdue':
        return _errorColor;
      case 'paid':
        return _successColor;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    final localizations = AppLocalizations.of(context);
    switch (status) {
      case 'unpaid':
        return localizations.translate('unpaid');
      case 'overdue':
        return localizations.translate('overdueStatus');
      case 'paid':
        return localizations.translate('paidStatus');
      default:
        return status;
    }
  }

  String _getDelayReasonText(String reason) {
    final localizations = AppLocalizations.of(context);
    switch (reason) {
      case 'notReceived':
        return localizations.translate('notReceived');
      case 'paymentIssues':
        return localizations.translate('paymentIssues');
      case 'incorrectData':
        return localizations.translate('incorrectData');
      default:
        return reason;
    }
  }

  double _calculateTotalRevenue() {
    return paidBills.fold(0, (sum, bill) => sum + (bill['amountIQD'] ?? bill['amount'] ?? 0).toDouble());
  }

  void _markAsPaid(Map<String, dynamic> bill) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('confirmPayment')),
        content: Text(
          localizations.translate(
            'confirmPaymentMessage',
            {
              'invoice': bill['id'],
              'customer': bill['customer']
            }
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                pendingBills.remove(bill);
                bill['paidDate'] = DateTime.now();
                bill['paymentMethod'] = localizations.locale.languageCode == 'ar' ? 'غير محدد' : 'Not Specified';
                bill['status'] = 'paid';
                paidBills.add(bill);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.translate('paymentConfirmed')),
                  backgroundColor: _successColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Text(localizations.translate('confirm')),
          ),
        ],
      ),
    );
  }

  void _sendReminder(Map<String, dynamic> bill) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('sendReminderTitle')),
        content: Text(
          localizations.translate(
            'sendReminderMessage',
            {
              'customer': bill['customer'],
              'invoice': bill['id']
            }
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.translate('reminderSent')),
                  backgroundColor: _successColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Text(localizations.translate('sendReminder')),
          ),
        ],
      ),
    );
  }

  void _contactCustomer(Map<String, dynamic> bill) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('contactCustomerTitle')),
        content: Text(
          localizations.translate(
            'contactCustomerMessage',
            {
              'customer': bill['customer'],
              'phone': bill['phone']
            }
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.translate('callingCustomer')),
                  backgroundColor: _primaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Text(localizations.translate('contactCustomer')),
          ),
        ],
      ),
    );
  }

  void _showBillDetails(Map<String, dynamic> bill, bool isPaid, bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    double amount = (bill['amountIQD'] ?? bill['amount'] ?? 0).toDouble();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '${localizations.translate('invoiceNumber')} ${bill['id']}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : _textColor,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('${localizations.translate('invoiceNumber')}:', bill['id'], isDarkMode),
              SizedBox(height: 12),
              _buildDetailRow('${localizations.translate('customer')}:', bill['customer'], isDarkMode),
              SizedBox(height: 12),
              _buildDetailRow('${localizations.translate('customerPhone')}:', bill['phone'], isDarkMode),
              SizedBox(height: 12),
              _buildDetailRow('${localizations.translate('amount')}:', _formatCurrency(amount), isDarkMode),
              SizedBox(height: 12),
              _buildDetailRow('${localizations.translate('consumption')}:', bill['consumption'], isDarkMode),
              if (isPaid) ...[
                SizedBox(height: 12),
                _buildDetailRow('${localizations.translate('paymentDate')}:', 
                  DateFormat('yyyy-MM-dd').format(bill['paidDate']), isDarkMode),
                SizedBox(height: 12),
                _buildDetailRow('${localizations.translate('paymentMethod')}:', bill['paymentMethod'], isDarkMode),
              ] else ...[
                SizedBox(height: 12),
                _buildDetailRow('${localizations.translate('dueDate')}:', 
                  DateFormat('yyyy-MM-dd').format(bill['dueDate']), isDarkMode),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('close')),
          ),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('notifications')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNotificationItem(
                localizations.translate('createBill'),
                localizations.translate('createBillMessage'),
                Icons.receipt_long_rounded,
                _primaryColor,
              ),
              SizedBox(height: 16),
              _buildNotificationItem(
                localizations.translate('sendReminder'),
                'فاتورة INV-2024-002 ${localizations.locale.languageCode == 'ar' ? 'لم يتم دفعها بعد' : 'has not been paid yet'}',
                Icons.notifications_active_rounded,
                _warningColor,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('close')),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String message,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text(message, style: TextStyle(fontSize: 12, color: _textSecondaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateBillDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('createBillTitle')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(localizations.translate('createBillMessage')),
              SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundColor: _primaryColor.withOpacity(0.1),
                child: Icon(Icons.receipt_long_rounded, color: _primaryColor, size: 40),
              ),
              SizedBox(height: 16),
              Text(
                localizations.translate('createBill'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.translate('openingForm')),
                  backgroundColor: _primaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Text(localizations.translate('continue')),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('helpTitle')),
        content: Text(localizations.translate('helpMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('close')),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('logoutTitle')),
        content: Text(localizations.translate('logoutMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                EsigninScreen.screenroot,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
            ),
            child: Text(localizations.translate('logout')),
          ),
        ],
      ),
    );
  }
}

// شاشة إدارة العملاء
class CustomersScreen extends StatefulWidget {
  static const String routeName = '/customers';

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final Color _primaryColor = Color(0xFF0D47A1);
  final Color _secondaryColor = Color(0xFF1976D2);
  final Color _successColor = Color(0xFF2E7D32);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _errorColor = Color(0xFFD32F2F);
  final Color _backgroundColor = Color(0xFFF8F9FA);
  final Color _textColor = Color(0xFF212121);
  final Color _textSecondaryColor = Color(0xFF757575);

  final List<Map<String, dynamic>> _customers = [
    {
      'id': 'CUST-001',
      'name': 'أحمد محمد',
      'phone': '077235477514',
      'email': 'ahmed@example.com',
      'address': 'حي الرياض - شارع الملك فهد',
      'joinDate': DateTime.now().subtract(Duration(days: 120)),
      'status': 'active',
      'totalInvoices': 8,
      'totalPaid': 1250.75,
      'pendingBills': 1,
      'meterNumber': 'MTR-001234',
      'subscriptionType': 'سكني',
    },
    {
      'id': 'CUST-002',
      'name': 'فاطمة علي',
      'phone': '07827534903',
      'email': 'fatima@example.com',
      'address': 'حي النخيل - شارع الأمير محمد',
      'joinDate': DateTime.now().subtract(Duration(days: 90)),
      'status': 'active',
      'totalInvoices': 6,
      'totalPaid': 890.50,
      'pendingBills': 1,
      'meterNumber': 'MTR-001235',
      'subscriptionType': 'سكني',
    },
    // ... باقي العملاء
  ];

  List<Map<String, dynamic>> _filteredCustomers = [];
  String _searchQuery = '';
  String _filterStatus = 'all';

  @override
  void initState() {
    super.initState();
    _filteredCustomers = _customers;
  }

  void _filterCustomers() {
    setState(() {
      _filteredCustomers = _customers.where((customer) {
        final matchesSearch = customer['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            customer['phone'].toString().contains(_searchQuery) ||
            customer['id'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
        
        final matchesStatus = _filterStatus == 'all' || customer['status'] == _filterStatus;
        
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  String _formatCurrency(double amount) {
    final localizations = AppLocalizations.of(context);
    return '${NumberFormat('#,##0').format(amount)} ${localizations.translate('currency')}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return _successColor;
      case 'inactive':
        return _warningColor;
      case 'overdue':
        return _errorColor;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    final localizations = AppLocalizations.of(context);
    switch (status) {
      case 'active':
        return localizations.translate('active');
      case 'inactive':
        return localizations.translate('inactive');
      case 'overdue':
        return localizations.translate('overdueStatus');
      default:
        return status;
    }
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer, bool isDarkMode) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _getStatusColor(customer['status']).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_rounded,
            color: _getStatusColor(customer['status']),
            size: 22,
          ),
        ),
        title: Text(
          customer['name'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: isDarkMode ? Colors.white : _textColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            Text(
              customer['id'],
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : _textSecondaryColor,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone_rounded, size: 14, color: _textSecondaryColor),
                SizedBox(width: 4),
                Text(
                  customer['phone'],
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white60 : _textSecondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(customer['status']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _getStatusColor(customer['status']).withOpacity(0.3)),
          ),
          child: Text(
            _getStatusText(customer['status']),
            style: TextStyle(
              fontSize: 12,
              color: _getStatusColor(customer['status']),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildCustomerDetailRow('${localizations.translate('customerId')}:', customer['id'], isDarkMode),
                SizedBox(height: 12),
                _buildCustomerDetailRow('${localizations.translate('customerName')}:', customer['name'], isDarkMode),
                SizedBox(height: 12),
                _buildCustomerDetailRow('${localizations.translate('customerPhone')}:', customer['phone'], isDarkMode),
                SizedBox(height: 12),
                _buildCustomerDetailRow('${localizations.translate('email')}:', customer['email'], isDarkMode),
                SizedBox(height: 12),
                _buildCustomerDetailRow('${localizations.translate('address')}:', customer['address'], isDarkMode),
                SizedBox(height: 12),
                _buildCustomerDetailRow('${localizations.translate('meterNumber')}:', customer['meterNumber'], isDarkMode),
                SizedBox(height: 12),
                _buildCustomerDetailRow('${localizations.translate('subscriptionType')}:', customer['subscriptionType'], isDarkMode),
                SizedBox(height: 12),
                _buildCustomerDetailRow('${localizations.translate('joinDate')}:', 
                  DateFormat('yyyy-MM-dd').format(customer['joinDate']), isDarkMode),
                SizedBox(height: 20),
                
                // إحصائيات العميل
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDarkMode ? Colors.white10 : _backgroundColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCustomerStat(
                        '${localizations.translate('totalInvoices')}',
                        customer['totalInvoices'].toString(),
                        Icons.receipt_rounded,
                        _primaryColor,
                      ),
                      _buildCustomerStat(
                        '${localizations.translate('totalPaid')}',
                        _formatCurrency(customer['totalPaid']),
                        Icons.attach_money_rounded,
                        _successColor,
                      ),
                      _buildCustomerStat(
                        '${localizations.translate('pendingBills')}',
                        customer['pendingBills'].toString(),
                        Icons.pending_actions_rounded,
                        _warningColor,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _viewCustomerInvoices(customer);
                      },
                      icon: Icon(Icons.receipt_long_rounded, size: 18),
                      label: Text(localizations.translate('viewInvoices')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _editCustomer(customer);
                      },
                      icon: Icon(Icons.edit_rounded, size: 18),
                      label: Text(localizations.translate('editCustomer')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _warningColor,
                        side: BorderSide(color: _warningColor),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _contactCustomer(customer);
                      },
                      icon: Icon(Icons.phone_rounded, size: 18),
                      label: Text(localizations.translate('contactCustomer')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _successColor,
                        side: BorderSide(color: _successColor),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildCustomerDetailRow(String label, String value, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : _textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value, 
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white : _textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerStat(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _viewCustomerInvoices(Map<String, dynamic> customer) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${localizations.translate('invoicesFor')} ${customer['name']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long_rounded, size: 48, color: _primaryColor),
              SizedBox(height: 16),
              Text(
                localizations.translate('underDevelopment'),
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('close')),
          ),
        ],
      ),
    );
  }

  void _editCustomer(Map<String, dynamic> customer) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${localizations.translate('editCustomer')} ${customer['name']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_rounded, size: 48, color: _warningColor),
              SizedBox(height: 16),
              Text(
                localizations.translate('underDevelopment'),
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('close')),
          ),
        ],
      ),
    );
  }

  void _contactCustomer(Map<String, dynamic> customer) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('contactCustomerTitle')),
        content: Text(
          localizations.translate(
            'contactCustomerMessage',
            {
              'customer': customer['name'],
              'phone': customer['phone']
            }
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.translate('callingCustomer')),
                  backgroundColor: _primaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Text(localizations.translate('contactCustomer')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);
    
    int activeCustomers = _customers.where((c) => c['status'] == 'active').length;
    int inactiveCustomers = _customers.where((c) => c['status'] == 'inactive').length;
    int overdueCustomers = _customers.where((c) => c['status'] == 'overdue').length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('customerManagement'),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        // تم حذف زر إضافة عميل من هنا
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode 
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D1B2A),
                    Color(0xFF1B263B),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF8F9FA),
                    Color(0xFFE9ECEF),
                  ],
                ),
        ),
        child: Column(
          children: [
            // بطالة الإحصائيات
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [Color(0xFF1E3A5F), Color(0xFF0D47A1)]
                      : [Colors.white, Color(0xFFE3F2FD)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryStat(localizations.translate('totalcustomer'), _customers.length.toString(), Icons.people_alt_rounded, _primaryColor),
                  _buildSummaryStat(localizations.translate('active'), activeCustomers.toString(), Icons.check_circle_rounded, _successColor),
                  _buildSummaryStat(localizations.translate('overdueStatus'), overdueCustomers.toString(), Icons.warning_amber_rounded, _errorColor),
                ],
              ),
            ),

            // شريط البحث والتصفية
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                        _filterCustomers();
                      },
                      decoration: InputDecoration(
                        hintText: localizations.translate('ابحث عن العملاء...'),
                        prefixIcon: Icon(Icons.search_rounded, color: _textSecondaryColor),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('الكل', localizations.translate('all'), _filterStatus == 'all', isDarkMode),
                        SizedBox(width: 8),
                        _buildFilterChip('active', localizations.translate('active'), _filterStatus == 'active', isDarkMode),
                        SizedBox(width: 8),
                        _buildFilterChip('غير النشط', localizations.translate('inactive'), _filterStatus == 'inactive', isDarkMode),
                        SizedBox(width: 8),
                        _buildFilterChip('overdue', localizations.translate('overdueStatus'), _filterStatus == 'overdue', isDarkMode),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // قائمة العملاء
            Expanded(
              child: _filteredCustomers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline_rounded, size: 64, color: _textSecondaryColor),
                          SizedBox(height: 16),
                          Text(
                            localizations.translate('noCustomersFound'),
                            style: TextStyle(
                              fontSize: 18,
                              color: _textSecondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: _filteredCustomers.map((customer) => _buildCustomerCard(customer, isDarkMode)).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
      // تم حذف زر الإضافة العائم (FloatingActionButton) من هنا
    );
  }

  Widget _buildSummaryStat(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: _textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label, bool selected, bool isDarkMode) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : (isDarkMode ? Colors.white : _textColor),
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: selected,
      onSelected: (bool selected) {
        setState(() {
          _filterStatus = selected ? value : 'all';
        });
        _filterCustomers();
      },
      backgroundColor: isDarkMode ? Colors.white10 : Colors.white,
      selectedColor: _primaryColor,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? _primaryColor : (isDarkMode ? Colors.white24 : _textSecondaryColor.withOpacity(0.3)),
        ),
      ),
    );
  }
}

// شاشة الإعدادات
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Color _primaryColor = Color(0xFF0D47A1);
  final Color _successColor = Color(0xFF2E7D32);

  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final localizations = AppLocalizations.of(context);
        
        // الحصول على اللغة الحالية
        String currentLanguage = languageProvider.currentLocale.languageCode == 'ar' 
            ? 'العربية' 
            : 'English';
        
        return Scaffold(
          appBar: AppBar(
            title: Text(
              localizations.translate('settings'),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            backgroundColor: _primaryColor,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: const Color.fromARGB(255, 0, 0, 0)),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.save_rounded, color: Colors.white),
                onPressed: () => _saveSettings(context),
                tooltip: localizations.translate('save'),
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: isDarkMode 
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0D1B2A),
                        Color(0xFF1B263B),
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF8F9FA),
                        Color(0xFFE9ECEF),
                      ],
                    ),
            ),
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                // بطاقة المظهر
                _buildSettingsSection(
                  title: localizations.translate('appearance'),
                  icon: Icons.palette_rounded,
                  iconColor: Colors.purple,
                  isDarkMode: isDarkMode,
                  children: [
                    _buildSettingItemWithSwitch(
                      title: localizations.translate('darkMode'),
                      subtitle: localizations.translate('darkModeDesc'),
                      icon: Icons.dark_mode_rounded,
                      iconColor: Colors.indigo,
                      value: themeProvider.isDarkMode,
                      isDarkMode: isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // بطاقة إعدادات الحساب
                _buildSettingsSection(
                  title: localizations.translate('accountSettings'),
                  icon: Icons.person_rounded,
                  iconColor: Colors.blue,
                  isDarkMode: isDarkMode,
                  children: [
                    _buildSettingItem(
                      title: localizations.translate('accountInfo'),
                      subtitle: localizations.translate('accountInfoDesc'),
                      icon: Icons.person_outline_rounded,
                      iconColor: Colors.blue,
                      isDarkMode: isDarkMode,
                      onTap: () => _showAccountInfo(context),
                    ),
                    _buildSettingItem(
                      title: localizations.translate('changePassword'),
                      subtitle: localizations.translate('changePasswordDesc'),
                      icon: Icons.lock_outline_rounded,
                      iconColor: Colors.orange,
                      isDarkMode: isDarkMode,
                      onTap: () => _showChangePasswordDialog(context),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // بطاقة إعدادات التطبيق
                _buildSettingsSection(
                  title: localizations.translate('appSettings'),
                  icon: Icons.settings_rounded,
                  iconColor: Colors.grey,
                  isDarkMode: isDarkMode,
                  children: [
                    _buildSettingItem(
                      title: localizations.translate('language'),
                      subtitle: localizations.translate('languageDesc'),
                      icon: Icons.language_rounded,
                      iconColor: Colors.blue,
                      isDarkMode: isDarkMode,
                      trailing: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _primaryColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.language_rounded,
                              color: _primaryColor,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              currentLanguage,
                              style: TextStyle(
                                color: _primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        _changeLanguage(context, languageProvider);
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // بطاقة الإشعارات
                _buildSettingsSection(
                  title: localizations.translate('notificationsSettings'),
                  icon: Icons.notifications_rounded,
                  iconColor: Colors.orange,
                  isDarkMode: isDarkMode,
                  children: [
                    _buildSettingItemWithSwitch(
                      title: localizations.translate('enableNotifications'),
                      subtitle: localizations.translate('enableNotificationsDesc'),
                      icon: Icons.notifications_active_rounded,
                      iconColor: Colors.orange,
                      value: _notificationsEnabled,
                      isDarkMode: isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    if (_notificationsEnabled) ...[
                      _buildSettingItemWithSwitch(
                        title: localizations.translate('invoiceNotifications'),
                        subtitle: localizations.translate('invoiceNotificationsDesc'),
                        icon: Icons.receipt_long_rounded,
                        iconColor: Colors.blue,
                        value: true,
                        isDarkMode: isDarkMode,
                        onChanged: (value) {},
                      ),
                      _buildSettingItemWithSwitch(
                        title: localizations.translate('offersNotifications'),
                        subtitle: localizations.translate('offersNotificationsDesc'),
                        icon: Icons.local_offer_rounded,
                        iconColor: Colors.purple,
                        value: true,
                        isDarkMode: isDarkMode,
                        onChanged: (value) {},
                      ),
                      _buildSettingItemWithSwitch(
                        title: localizations.translate('systemNotifications'),
                        subtitle: localizations.translate('systemNotificationsDesc'),
                        icon: Icons.info_rounded,
                        iconColor: Colors.blue,
                        value: true,
                        isDarkMode: isDarkMode,
                        onChanged: (value) {},
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 20)
              ],
            ),
          ),
        );
      },
    );
  }

  void _changeLanguage(BuildContext context, LanguageProvider languageProvider) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('language')),
        content: Text('هل تريد تغيير اللغة إلى ${languageProvider.currentLocale.languageCode == 'ar' ? 'English' : 'العربية'}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              // تغيير اللغة
              languageProvider.toggleLanguage();
              Navigator.pop(context);
              
              // إظهار رسالة نجاح
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    languageProvider.currentLocale.languageCode == 'ar' 
                        ? 'تم تغيير اللغة إلى العربية' 
                        : 'Language changed to English'
                  ),
                  backgroundColor: _successColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Text(localizations.translate('confirm')),
          ),
        ],
      ),
    );
  }

  void _saveSettings(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.translate('settingsSaved')),
        backgroundColor: _successColor,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showAccountInfo(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('accountInfo')),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: _primaryColor.withOpacity(0.1),
                  child: Icon(Icons.person_rounded, color: _primaryColor, size: 40),
                ),
              ),
              SizedBox(height: 16),
              _buildInfoRow('الاسم', localizations.translate('accountantName'), Theme.of(context).brightness == Brightness.dark),
              _buildInfoRow('البريد الإلكتروني', 'mohamed@company.com', Theme.of(context).brightness == Brightness.dark),
              _buildInfoRow('القسم', localizations.translate('accountantTitle'), Theme.of(context).brightness == Brightness.dark),
              _buildInfoRow('رقم الموظف', 'EMP-2024-001', Theme.of(context).brightness == Brightness.dark),
              _buildInfoRow('تاريخ الانضمام', '2024-01-15', Theme.of(context).brightness == Brightness.dark),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('close')),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate('changePassword')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: localizations.locale.languageCode == 'ar' ? 'كلمة المرور الحالية' : 'Current Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: localizations.locale.languageCode == 'ar' ? 'كلمة المرور الجديدة' : 'New Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: localizations.locale.languageCode == 'ar' ? 'تأكيد كلمة المرور الجديدة' : 'Confirm New Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.translate('passwordChanged')),
                  backgroundColor: _successColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Text(localizations.translate('save')),
          ),
        ],
      ),
    );
  }

  // باقي دوال البناء تبقى كما هي...
  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required bool isDarkMode,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : _primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool isDarkMode,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDarkMode ? Colors.white10 : Colors.grey[50],
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white60 : Colors.grey[600],
              ),
            ),
            trailing: trailing,
            onTap: onTap,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSettingItemWithSwitch({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required bool isDarkMode,
    required Function(bool) onChanged,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDarkMode ? Colors.white10 : Colors.grey[50],
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white60 : Colors.grey[600],
              ),
            ),
            trailing: Transform.scale(
              scale: 0.8,
              child: Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeColor: _primaryColor,
                activeTrackColor: _primaryColor.withOpacity(0.5),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Color _primaryColor = Color(0xFF0D47A1);
  final Color _secondaryColor = Color(0xFF1976D2);
  final Color _backgroundColor = Color(0xFFF8F9FA);
  final Color _textColor = Color(0xFF212121);
  final Color _textSecondaryColor = Color(0xFF757575);
  final Color _successColor = Color(0xFF2E7D32);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _errorColor = Color(0xFFD32F2F);
  final Color _infoColor = Color(0xFF1976D2);

  String _selectedFilter = 'الكل';

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'type': 'invoice',
      'title': 'فاتورة جديدة',
      'description': 'تم إنشاء فاتورة جديدة للعميل أحمد محمد بقيمة 185,750 دينار',
      'time': 'منذ 5 دقائق',
      'icon': Icons.receipt_long_rounded,
      'color': Color(0xFF2196F3),
      'read': false,
    },
    {
      'id': '2',
      'type': 'payment',
      'title': 'دفع فاتورة',
      'description': 'تم دفع فاتورة INV-2024-003 من قبل العميل سالم عبدالله',
      'time': 'منذ ساعة',
      'icon': Icons.payment_rounded,
      'color': Color(0xFF4CAF50),
      'read': false,
    },
    {
      'id': '3',
      'type': 'reminder',
      'title': 'تذكير بفاتورة',
      'description': 'فاتورة INV-2024-002 متأخرة الدفع - يرجى التواصل مع العميل',
      'time': 'منذ 3 ساعات',
      'icon': Icons.notification_important_rounded,
      'color': Color(0xFFFF9800),
      'read': true,
    },
    {
      'id': '4',
      'type': 'system',
      'title': 'تحديث النظام',
      'description': 'تم تحديث نظام الفواتير بنجاح إلى الإصدار 2.1.0',
      'time': 'منذ 5 ساعات',
      'icon': Icons.system_update_rounded,
      'color': Color(0xFF9C27B0),
      'read': true,
    },
    {
      'id': '5',
      'type': 'invoice',
      'title': 'فاتورة شهرية',
      'description': 'تم إنشاء الفواتير الشهرية لجميع العملاء بنجاح',
      'time': 'منذ يوم',
      'icon': Icons.receipt_long_rounded,
      'color': Color(0xFF2196F3),
      'read': true,
    },
    {
      'id': '6',
      'type': 'customer',
      'title': 'عميل جديد',
      'description': 'تم إضافة عميل جديد إلى النظام - يوسف محمد',
      'time': 'منذ يومين',
      'icon': Icons.person_add_rounded,
      'color': Color(0xFF4CAF50),
      'read': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'الكل') {
      return _notifications;
    }
    
    Map<String, String> filterMap = {
      'الفواتير': 'invoice',
      'المدفوعات': 'payment', 
      'التذكيرات': 'reminder',
      'النظام': 'system',
      'العملاء': 'customer',
    };
    
    return _notifications.where((notification) {
      return notification['type'] == filterMap[_selectedFilter];
    }).toList();
  }

  void _markAsRead(String id) {
    setState(() {
      _notifications.firstWhere((notification) => notification['id'] == id)['read'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['read'] = true;
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((notification) => notification['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('notifications'),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.mark_email_read_rounded, color: Colors.white),
            onPressed: _markAllAsRead,
            tooltip: localizations.translate('markAllAsRead'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode 
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D1B2A),
                    Color(0xFF1B263B),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF8F9FA),
                    Color(0xFFE9ECEF),
                  ],
                ),
        ),
        child: Column(
          children: [
            // إحصائيات سريعة
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [Color(0xFF1E3A5F), Color(0xFF0D47A1)]
                      : [Colors.white, Color(0xFFE3F2FD)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNotificationStat('الإجمالي', _notifications.length.toString(), Icons.notifications_rounded, _primaryColor),
                  _buildNotificationStat('غير مقروء', '${_notifications.where((n) => !n['read']).length}', Icons.markunread_rounded, _warningColor),
                  _buildNotificationStat('مهم', '3', Icons.priority_high_rounded, _errorColor),
                ],
              ),
            ),

            // فلاتر التبويب
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('الكل', _selectedFilter == 'الكل', isDarkMode),
                    SizedBox(width: 8),
                    _buildFilterChip('الفواتير', _selectedFilter == 'الفواتير', isDarkMode),
                    SizedBox(width: 8),
                    _buildFilterChip('المدفوعات', _selectedFilter == 'المدفوعات', isDarkMode),
                    SizedBox(width: 8),
                    _buildFilterChip('التذكيرات', _selectedFilter == 'التذكيرات', isDarkMode),
                    SizedBox(width: 8),
                    _buildFilterChip('النظام', _selectedFilter == 'النظام', isDarkMode),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // قائمة الإشعارات
            Expanded(
              child: _filteredNotifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_rounded,
                            size: 64,
                            color: _textSecondaryColor,
                          ),
                          SizedBox(height: 16),
                          Text(
                            localizations.translate('noNotifications'),
                            style: TextStyle(
                              fontSize: 18,
                              color: _textSecondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            localizations.translate('noNotificationsDesc'),
                            style: TextStyle(
                              fontSize: 14,
                              color: _textSecondaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _filteredNotifications[index];
                        return _buildNotificationCard(notification, isDarkMode);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationStat(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: _textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool selected, bool isDarkMode) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : (isDarkMode ? Colors.white : _textColor),
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: selected,
      onSelected: (bool selected) {
        setState(() {
          _selectedFilter = selected ? label : 'الكل';
        });
      },
      backgroundColor: isDarkMode ? Colors.white10 : Colors.white,
      selectedColor: _primaryColor,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? _primaryColor : (isDarkMode ? Colors.white24 : _textSecondaryColor.withOpacity(0.3)),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
        border: !notification['read'] ? Border.all(
          color: _primaryColor.withOpacity(0.3),
          width: 1,
        ) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (!notification['read']) {
              _markAsRead(notification['id']);
            }
            _showNotificationDetails(notification);
          },
          onLongPress: () {
            _showNotificationActions(notification['id']);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة الإشعار
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: notification['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notification['icon'],
                    color: notification['color'],
                    size: 22,
                  ),
                ),
                SizedBox(width: 12),
                
                // محتوى الإشعار
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: isDarkMode ? Colors.white : _textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification['read'])
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        notification['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white70 : _textSecondaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: _textSecondaryColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            notification['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color: _textSecondaryColor,
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getNotificationTypeColor(notification['type']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getNotificationTypeText(notification['type']),
                              style: TextStyle(
                                fontSize: 10,
                                color: _getNotificationTypeColor(notification['type']),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getNotificationTypeColor(String type) {
    switch (type) {
      case 'invoice':
        return _primaryColor;
      case 'payment':
        return _successColor;
      case 'reminder':
        return _warningColor;
      case 'system':
        return _infoColor;
      case 'customer':
        return Color(0xFF9C27B0);
      default:
        return _textSecondaryColor;
    }
  }

  String _getNotificationTypeText(String type) {
    switch (type) {
      case 'invoice':
        return 'فاتورة';
      case 'payment':
        return 'دفع';
      case 'reminder':
        return 'تذكير';
      case 'system':
        return 'النظام';
      case 'customer':
        return 'عميل';
      default:
        return type;
    }
  }

  void _showNotificationActions(String id) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF1E1E1E) : Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.mark_email_read_rounded, color: _primaryColor, size: 20),
              ),
              title: Text('تعليم كمقروء'),
              onTap: () {
                Navigator.pop(context);
                _markAsRead(id);
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _errorColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_rounded, color: _errorColor, size: 20),
              ),
              title: Text('حذف الإشعار'),
              onTap: () {
                Navigator.pop(context);
                _deleteNotification(id);
              },
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _textSecondaryColor,
                  side: BorderSide(color: _textSecondaryColor.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notification['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(notification['icon'], color: notification['color'], size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : _textColor,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                notification['description'],
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : _textSecondaryColor,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isDarkMode ? Colors.white10 : _backgroundColor,
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 16, color: _textSecondaryColor),
                    SizedBox(width: 8),
                    Text(
                      notification['time'],
                      style: TextStyle(
                        color: _textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getNotificationTypeColor(notification['type']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getNotificationTypeText(notification['type']),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getNotificationTypeColor(notification['type']),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('close')),
          ),
          if (!notification['read'])
            ElevatedButton(
              onPressed: () {
                _markAsRead(notification['id']);
                Navigator.pop(context);
              },
              child: Text(localizations.translate('markAsRead')),
            ),
        ],
      ),
    );
  }
}
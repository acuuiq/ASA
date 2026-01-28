import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'invoices_service.dart';

class TransactionHistoryScreen extends StatefulWidget {
  static const String screen = 'transaction_history_screen';
  
  final Color primaryColor;
  final List<Color> primaryGradient;

  const TransactionHistoryScreen({
    super.key,
    required this.primaryColor,
    required this.primaryGradient,
  });

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final InvoicesService _invoicesService = InvoicesService();
  final SupabaseClient _supabase = Supabase.instance.client;
  
  List<dynamic> _allTransactions = [];
  bool _isLoading = true;
  String _selectedFilter = 'الكل';

  @override
  void initState() {
    super.initState();
    _loadAllTransactions();
  }

  Future<void> _loadAllTransactions() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final regularInvoices = await _invoicesService.getUserInvoices();

      // ✅ استخدام مجموعة للتأكد من عدم وجود تكرار باستخدام مفتاح فريد أقوى
      final Map<String, dynamic> uniqueTransactions = {};
      
      List<dynamic> allTransactions = [
        ...regularInvoices.map((invoice) => {
          ...invoice,
          'type': 'regular',
          'display_date': DateTime.parse(invoice['payment_date']),
          'unique_key': 'regular_${invoice['id']}_${invoice['payment_date']}_${invoice['amount']}',
        }),
      ];

      // ✅ إزالة التكرار باستخدام المفتاح الفريد مع تسجيل التحذيرات
      for (final transaction in allTransactions) {
        final String uniqueKey = transaction['unique_key'];
        if (uniqueTransactions.containsKey(uniqueKey)) {
          print('⚠️ تم اكتشاف معاملة مكررة وحذفها: $uniqueKey');
        } else {
          uniqueTransactions[uniqueKey] = transaction;
        }
      }

      // ✅ ترتيب حسب التاريخ
      final uniqueList = uniqueTransactions.values.toList();
      uniqueList.sort((a, b) => b['display_date'].compareTo(a['display_date']));

      setState(() {
        _allTransactions = uniqueList;
        _isLoading = false;
      });

      print('✅ تم تحميل ${_allTransactions.length} معاملة فريدة');

    } catch (e) {
      print('Error loading transactions: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<dynamic> get _filteredTransactions {
    if (_selectedFilter == 'الكل') {
      return _allTransactions;
    } else if (_selectedFilter == 'الخدمات الأساسية') {
      return _allTransactions.where((transaction) => transaction['type'] == 'regular').toList();
    }
    
    // فلترة حسب نوع الخدمة المحددة
    return _allTransactions.where((transaction) {
      if (transaction['type'] == 'regular') {
        final services = transaction['services'];
        if (services is List && services.isNotEmpty) {
          for (final service in services) {
            final serviceName = _getServiceNameFromJson(service);
            if (serviceName == _selectedFilter) {
              return true;
            }
          }
        }
        return false;
      }
      return false;
    }).toList();
  }

  String _getServiceNameFromJson(dynamic serviceData) {
    try {
      if (serviceData is Map<String, dynamic>) {
        return serviceData['name'] ?? 
               serviceData['title'] ?? 
               serviceData['serviceName'] ?? 
               'خدمة غير محددة';
      } else if (serviceData is String) {
        final parsed = json.decode(serviceData);
        return parsed['name'] ?? 
               parsed['title'] ?? 
               parsed['serviceName'] ?? 
               'خدمة غير محددة';
      }
    } catch (e) {
      print('Error parsing service name: $e');
    }
    return 'خدمة غير محددة';
  }

  String _getServiceAmountFromJson(dynamic serviceData) {
    try {
      if (serviceData is Map<String, dynamic>) {
        final amount = serviceData['amount'];
        if (amount is double) return amount.toStringAsFixed(2);
        if (amount is int) return amount.toDouble().toStringAsFixed(2);
        if (amount is String) return amount;
      } else if (serviceData is String) {
        final parsed = json.decode(serviceData);
        final amount = parsed['amount'];
        if (amount is double) return amount.toStringAsFixed(2);
        if (amount is int) return amount.toDouble().toStringAsFixed(2);
        if (amount is String) return amount;
      }
    } catch (e) {
      print('Error parsing service amount: $e');
    }
    return '0.00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل المعاملات'),
        backgroundColor: widget.primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // فلتر المعاملات
          _buildFilterSection(),
          
          // إحصائيات سريعة
          _buildQuickStats(),
          
          // قائمة المعاملات
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: widget.primaryColor))
                : _filteredTransactions.isEmpty
                    ? _buildEmptyState()
                    : _buildTransactionsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    final List<String> filters = ['الكل', 'الخدمات الأساسية'];

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تصفية المعاملات:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = selected ? filter : 'الكل';
                      });
                    },
                    selectedColor: widget.primaryColor.withOpacity(0.2),
                    checkmarkColor: widget.primaryColor,
                    labelStyle: TextStyle(
                      color: _selectedFilter == filter ? widget.primaryColor : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final totalTransactions = _allTransactions.length;
    final totalAmount = _allTransactions.fold(0.0, (sum, transaction) {
      return sum + (transaction['amount'] ?? 0).toDouble();
    });

    final regularCount = _allTransactions.where((t) => t['type'] == 'regular').length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMiniStat(totalTransactions.toString(), 'كل المعاملات'),
          _buildMiniStat(_formatAmount(totalAmount), 'المبلغ الكلي'),
          _buildMiniStat(regularCount.toString(), 'الخدمات الأساسية'),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String value, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: widget.primaryColor,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'لا توجد معاملات',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'سيظهر سجل معاملاتك هنا بعد إتمام أول عملية دفع',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = _filteredTransactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isRegular = transaction['type'] == 'regular';
    final paymentDate = DateTime.parse(transaction['payment_date']);
    final amount = transaction['amount'] ?? 0.0;
    final paymentMethod = transaction['payment_method'] ?? 'غير محدد';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getRegularServiceTitle(transaction),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: widget.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'خدمة أساسية',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${amount.toStringAsFixed(2)} د.ع',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy/MM/dd').format(paymentDate),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // تفاصيل إضافية
            _buildTransactionDetails(transaction),

            const SizedBox(height: 12),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طريقة الدفع: $paymentMethod',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  DateFormat('HH:mm').format(paymentDate),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRegularServiceTitle(Map<String, dynamic> transaction) {
    final services = transaction['services'];
    if (services is List && services.isNotEmpty) {
      final firstService = services[0];
      return _getServiceNameFromJson(firstService);
    }
    return 'فاتورة خدمة';
  }

  Widget _buildTransactionDetails(Map<String, dynamic> transaction) {
    return _buildRegularServiceDetails(transaction);
  }

  Widget _buildRegularServiceDetails(Map<String, dynamic> transaction) {
    final services = transaction['services'];
    final pointsUsed = transaction['points_used'] ?? 0;
    final pointsEarned = transaction['points_earned'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (services is List && services.isNotEmpty) ...[
          const Text(
            'الخدمات المدفوعة:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ..._buildServicesList(services),
        ],
        
        if (pointsUsed > 0 || pointsEarned > 0) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              if (pointsUsed > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'مستخدم: $pointsUsed نقطة',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (pointsEarned > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'مكتسب: $pointsEarned نقطة',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  List<Widget> _buildServicesList(dynamic servicesData) {
    final List<Widget> serviceWidgets = [];
    
    try {
      List<dynamic> servicesList = [];
      
      if (servicesData is List) {
        servicesList = servicesData;
      } else if (servicesData is String) {
        servicesList = json.decode(servicesData);
      }

      for (int i = 0; i < servicesList.length; i++) {
        final service = servicesList[i];
        final serviceName = _getServiceNameFromJson(service);
        final serviceAmount = _getServiceAmountFromJson(service);

        serviceWidgets.add(
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${i + 1}. $serviceName',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Text(
                  '$serviceAmount د.ع',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      print('Error building services list: $e');
      serviceWidgets.add(
        const Text('خطأ في عرض الخدمات', style: TextStyle(color: Colors.red, fontSize: 12)),
      );
    }

    return serviceWidgets;
  }
}
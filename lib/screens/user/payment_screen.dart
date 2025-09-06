import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// نموذج بيانات الخدمة
class ServiceItem {
  final String id;
  final String name;
  final double amount;
  final Color color;
  final List<Color> gradient;
  final String? additionalInfo;

  ServiceItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.color,
    required this.gradient,
    this.additionalInfo,
  });
}

class PaymentScreen extends StatefulWidget {
  final List<ServiceItem> services; // قائمة الخدمات بدلاً من خدمة واحدة
  final Color primaryColor;
  final List<Color> primaryGradient;

  const PaymentScreen({
    super.key,
    required this.services,
    required this.primaryColor,
    required this.primaryGradient,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ibanController = TextEditingController();
  final _friendIdController = TextEditingController();

  // متغيرات الدفع عن صديق
  bool _payForFriend = false;
  String _friendName = '';
  bool _isFriendVerified = false;
  String _selectedPaymentMethod = '';
  String _selectedPaymentOption = '';
  bool _showPaymentForm = false;
  bool _isEarlyPayment = false;
  bool _usePoints = false;
  double _discountAmount = 0.0;
  double _pointsDiscount = 0.0;
  double _finalAmount = 0.0;
  final DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  // نظام النقاط
  final int _userPoints = 500;
  final double _pointsRate = 0.01;



  // تعريف قائمة فئات الدفع
  final List<Map<String, dynamic>> _paymentCategories = [
    {
      'title': 'البطاقات المصرفية',
      'icon': Icons.credit_card,
      'options': [
        {
          'name': 'بطاقة فيزا',
          'icon': Icons.credit_card,
          'color': Colors.blue,
          'form': 'credit_card',
        },
        {
          'name': 'بطاقة ماستركارد',
          'icon': Icons.credit_card,
          'color': Colors.red,
          'form': 'credit_card',
        },
      ],
    },
    {
      'title': 'المحافظ الإلكترونية',
      'icon': Icons.account_balance_wallet,
      'options': [
        {
          'name': 'زين كاش',
          'icon': Icons.phone_android,
          'color': Colors.purple,
          'form': 'wallet',
        },
        {
          'name': 'AsiaPay',
          'icon': Icons.payment,
          'color': Colors.green,
          'form': 'wallet',
        },
      ],
    },
    {
      'title': 'التحويل البنكي',
      'icon': Icons.account_balance,
      'options': [
        {
          'name': 'الرافدين',
          'icon': Icons.account_balance,
          'color': Colors.orange,
          'form': 'bank_transfer',
        },
        {
          'name': 'الرشيد',
          'icon': Icons.account_balance,
          'color': Colors.blueGrey,
          'form': 'bank_transfer',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _finalAmount = _calculateTotalAmount();
    _calculatePointsDiscount();
  }

  double _calculateTotalAmount() {
    return widget.services.fold(0.0, (sum, service) => sum + service.amount);
  }

  void _calculatePointsDiscount() {
    _pointsDiscount = _userPoints * _pointsRate;
    if (_pointsDiscount > _calculateTotalAmount()) {
      _pointsDiscount = _calculateTotalAmount();
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _accountNumberController.dispose();
    _ibanController.dispose();
    _friendIdController.dispose();
    super.dispose();
  }

  void _verifyFriend() async {
    if (_friendIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقم هاتف الصديق')),
      );
      return;
    }

    // محاكاة التحقق من الخادم
    setState(() {
      _isFriendVerified = true;
      _friendName = 'أحمد محمد'; // سيتم استبدالها بالقيمة الفعلية من API
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم التحقق من $_friendName')),
    );
  }

  void _updateFinalAmount() {
    double amount = _calculateTotalAmount();

    if (_isEarlyPayment) {
      amount -= _discountAmount;
    }

    if (_usePoints) {
      amount -= _pointsDiscount;
      if (amount < 0) amount = 0;
    }

    setState(() {
      _finalAmount = amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _calculateTotalAmount();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق والدفع'),
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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عرض قائمة الخدمات في السلة
            _buildServicesList(),
            const SizedBox(height: 20),

            _buildInvoiceSummary(totalAmount),
            const SizedBox(height: 30),

            if (!_showPaymentForm) ...[
              const Text(
                'اختر طريقة الدفع',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'اختر طريقة الدفع المفضلة لديك',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              _buildPaymentMethods(),
            ],

            if (_showPaymentForm) ...[
              InkWell(
                onTap: () {
                  setState(() {
                    _showPaymentForm = false;
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: widget.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'العودة لطرق الدفع',
                      style: TextStyle(
                        color: widget.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'معلومات الدفع عبر $_selectedPaymentOption',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'الرجاء إدخال المعلومات المطلوبة للدفع',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              _buildPaymentForm(),
              const SizedBox(height: 30),
              _buildPayButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_cart, color: widget.primaryColor),
                const SizedBox(width: 10),
                const Text(
                  'الخدمات المختارة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...widget.services.map((service) => _buildServiceItem(service)).toList(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الإجمالي:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  '${_calculateTotalAmount().toStringAsFixed(2)} د.ع',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(ServiceItem service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            service.color.withOpacity(0.1),
            service.color.withOpacity(0.05),
        ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: service.color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: service.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (service.additionalInfo != null)
                  Text(
                    service.additionalInfo!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: service.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${service.amount.toStringAsFixed(2)} د.ع',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: service.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceSummary(double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            widget.primaryColor.withOpacity(0.1),
            widget.primaryGradient[1].withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المبلغ المستحق:', style: TextStyle(fontSize: 16)),
              Text(
                '${totalAmount.toStringAsFixed(2)} د.ع',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: widget.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(height: 1),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('عدد الخدمات:'),
              Text(
                '${widget.services.length} خدمة',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('تاريخ الاستحقاق:'),
              Text(
                DateFormat('yyyy-MM-dd').format(_dueDate),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // خيارات الخصم والدفع بالنقاط
          if (_userPoints > 0) ...[
            const SizedBox(height: 15),
            const Divider(height: 1),
            const SizedBox(height: 15),

            // خيار الدفع المبكر لجميع الخدمات
            _buildDiscountOption(
              title: 'الدفع المبكر (خصم 10%)',
              value: _isEarlyPayment,
              onChanged: (value) {
                setState(() {
                  _isEarlyPayment = value!;
                  if (_isEarlyPayment) {
                    _discountAmount = totalAmount * 0.1;
                  } else {
                    _discountAmount = 0.0;
                  }
                  _updateFinalAmount();
                });
              },
              icon: Icons.alarm,
              color: Colors.blue,
            ),

            // خيار الدفع بالنقاط
            _buildDiscountOption(
              title: 'استخدام النقاط (${_pointsDiscount.toStringAsFixed(2)} د.ع)',
              subtitle: 'لديك $_userPoints نقطة',
              value: _usePoints,
              onChanged: (value) {
                setState(() {
                  _usePoints = value!;
                  _updateFinalAmount();
                });
              },
              icon: Icons.star,
              color: Colors.amber,
            ),
          ],

          const SizedBox(height: 15),
          const Divider(height: 1),
          const SizedBox(height: 15),

          // تحسين واجهة الدفع عن صديق
          _buildPayForFriendSection(),

          const Divider(height: 1),
          const SizedBox(height: 15),

          // تفاصيل الخصومات
          if (_isEarlyPayment)
            _buildDetailRow(
              'خصم الدفع المبكر',
              '-${_discountAmount.toStringAsFixed(2)} د.ع',
            ),

          if (_usePoints)
            _buildDetailRow(
              'خصم النقاط',
              '-${_pointsDiscount.toStringAsFixed(2)} د.ع',
            ),

          // المبلغ النهائي
          _buildDetailRow(
            'المبلغ النهائي',
            '${_finalAmount.toStringAsFixed(2)} د.ع',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPayForFriendSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDiscountOption(
          title: 'الدفع عن صديق',
          value: _payForFriend,
          onChanged: (value) {
            setState(() {
              _payForFriend = value!;
              if (!_payForFriend) {
                _friendName = '';
                _isFriendVerified = false;
              }
            });
          },
          icon: Icons.group,
          color: const Color.fromARGB(255, 0, 86, 156),
        ),

        if (_payForFriend) ...[
          const SizedBox(height: 15),
          Text(
            'معلومات الصديق',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _friendIdController,
                  decoration: InputDecoration(
                    labelText: 'رقم هاتف أو معرف الصديق',
                    hintText: 'أدخل رقم الهاتف المسجل',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                onPressed: _verifyFriend,
                child: const Text('بحث', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),

          if (_isFriendVerified) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green[100]!),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade400,
                          Colors.green.shade600,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _friendName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'رقم الهاتف: ${_friendIdController.text}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _isFriendVerified = false;
                        _friendName = '';
                      });
                    },
                  ),
                ],
              ),
            ),
          ] else if (_friendIdController.text.isNotEmpty && !_isFriendVerified) ...[
            const SizedBox(height: 10),
            Text(
              'لم يتم العثور على صديق بهذا الرقم',
              style: TextStyle(color: Colors.red[600], fontSize: 14),
            ),
          ],

          const SizedBox(height: 10),
          Text(
            'سيتم خصم المبلغ من حسابك وإضافته لرصيد صديقك',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildDiscountOption({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: value ? color : Colors.grey[300]!, width: 1),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: value ? color : Colors.black,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: color,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? widget.primaryColor : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: _paymentCategories.map((category) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Icon(category['icon'], color: widget.primaryColor),
                  const SizedBox(width: 10),
                  Text(
                    category['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: category['options'].length,
              itemBuilder: (context, index) {
                final option = category['options'][index];
                return _buildPaymentOption(option);
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPaymentOption(Map<String, dynamic> option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = option['form'];
          _selectedPaymentOption = option['name'];
          _showPaymentForm = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: option['color'].withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(option['icon'], color: option['color']),
            ),
            const SizedBox(height: 8),
            Text(
              option['name'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    switch (_selectedPaymentMethod) {
      case 'credit_card':
        return _buildCreditCardForm();
      case 'wallet':
        return _buildWalletForm();
      case 'bank_transfer':
        return _buildBankTransferForm();
      default:
        return _buildCreditCardForm();
    }
  }

  Widget _buildCreditCardForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _cardNumberController,
            decoration: InputDecoration(
              labelText: 'رقم البطاقة',
              hintText: '1234 5678 9012 3456',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.credit_card),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال رقم البطاقة';
              }
              if (value.length < 16) {
                return 'رقم البطاقة يجب أن يكون 16 رقم';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _cardHolderController,
            decoration: InputDecoration(
              labelText: 'اسم صاحب البطاقة',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال اسم صاحب البطاقة';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(
                    labelText: 'تاريخ الانتهاء (MM/YY)',
                    hintText: '12/25',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال تاريخ الانتهاء';
                      }
                      if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                        return 'الصيغة MM/YY';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال CVV';
                      }
                      if (value.length < 3) {
                        return 'CVV يجب أن يكون 3 أو 4 أرقام';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
      )
        );
      }

      Widget _buildWalletForm() {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  hintText: '07XX XXX XXXX',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الهاتف';
                  }
                  if (value.length < 10) {
                    return 'رقم الهاتف يجب أن يكون 10 أرقام';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور';
                  }
                  if (value.length < 6) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      }

      Widget _buildBankTransferForm() {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: 'رقم الحساب',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الحساب';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _ibanController,
                decoration: InputDecoration(
                  labelText: 'رقم IBAN',
                  hintText: 'IQXX XXXX XXXX XXXX XXXX XXXX',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.code),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم IBAN';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      }

      Widget _buildPayButton() {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            onPressed: _processPayment,
            child: const Text(
              'تأكيد الدفع',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        );
      }

      void _processPayment() {
        if (_formKey.currentState?.validate() ?? false) {
          if (_payForFriend && !_isFriendVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('الرجاء التحقق من هوية الصديق أولاً')),
            );
            return;
          }
          _showPaymentConfirmation();
        }
      }

      void _showPaymentConfirmation() {
        int pointsUsed = _usePoints ? (_pointsDiscount / _pointsRate).ceil() : 0;
        int pointsEarned = (_isEarlyPayment ? 100 : 50) + (_finalAmount * 0.1).ceil();
        if (_payForFriend && _isFriendVerified) {
          pointsEarned += 100; // نقاط إضافية للإحالة
        }
        int newPoints = _userPoints - pointsUsed + pointsEarned;

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Icon(Icons.verified, size: 60, color: widget.primaryColor),
                  const SizedBox(height: 20),
                  const Text(
                    'تأكيد الدفع',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'سيتم خصم مبلغ ${_finalAmount.toStringAsFixed(2)} د.ع عبر $_selectedPaymentOption',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('طريقة الدفع', _selectedPaymentOption),
                        const Divider(height: 15),
                        _buildDetailRow('المبلغ الأصلي', '${_calculateTotalAmount().toStringAsFixed(2)} د.ع'),
                        if (_isEarlyPayment)
                          _buildDetailRow(
                            'خصم الدفع المبكر',
                            '-${_discountAmount.toStringAsFixed(2)} د.ع',
                          ),
                        if (_usePoints)
                          _buildDetailRow(
                            'خصم النقاط',
                            '-${_pointsDiscount.toStringAsFixed(2)} د.ع',
                          ),
                        if (_payForFriend && _isFriendVerified)
                          _buildDetailRow('الدفع عن', _friendName),
                        const Divider(height: 15),
                        _buildDetailRow(
                          'المبلغ النهائي',
                          '${_finalAmount.toStringAsFixed(2)} د.ع',
                          isTotal: true,
                        ),
                        if (_usePoints) ...[
                          const Divider(height: 15),
                          _buildDetailRow('النقاط المستخدمة', '$pointsUsed نقطة'),
                        ],
                        const Divider(height: 15),
                        _buildDetailRow(
                          'التاريخ',
                          DateFormat('yyyy-MM-dd – hh:mm a').format(DateTime.now()),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: widget.primaryColor),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              color: widget.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showPaymentSuccess(
                              newPoints,
                              pointsEarned,
                              pointsUsed,
                            );
                          },
                          child: const Text(
                            'تأكيد الدفع',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      }

      void _showPaymentSuccess(int newPoints, int pointsEarned, int pointsUsed) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            insetPadding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'تم الدفع بنجاح!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'تم خصم مبلغ ${_finalAmount.toStringAsFixed(2)} د.ع',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          if (_payForFriend && _isFriendVerified) ...[
                            _buildDetailRow('تم الدفع عن', _friendName),
                            const Divider(height: 15),
                          ],
                          _buildDetailRow(
                            'رقم المرجع',
                            '#${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                          ),
                          const Divider(height: 15),
                          _buildDetailRow(
                            'التاريخ والوقت',
                            DateFormat('yyyy-MM-dd – hh:mm a').format(DateTime.now()),
                          ),
                          const Divider(height: 15),
                          if (pointsEarned > 0)
                            _buildDetailRow(
                              'النقاط المكتسبة',
                              '+$pointsEarned نقطة',
                            ),
                          if (pointsUsed > 0)
                            _buildDetailRow(
                              'النقاط المستخدمة',
                              '-$pointsUsed نقطة',
                            ),
                          const Divider(height: 15),
                          _buildDetailRow(
                            'رصيد النقاط الجديد',
                            '$newPoints نقطة',
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'حسناً',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    // مثال على استخدام الشاشة
    void main() {
      runApp(MaterialApp(
        home: PaymentScreen(
          services: [
            ServiceItem(
              id: '1',
              name: 'خدمة الكهرباء',
              amount: 25000,
              color: Colors.blue,
              gradient: [Colors.blue.shade400, Colors.blue.shade600],
              additionalInfo: 'فبراير 2024',
            ),
            ServiceItem(
              id: '2',
              name: 'خدمة المياه',
              amount: 15000,
              color: Colors.green,
              gradient: [Colors.green.shade400, Colors.green.shade600],
              additionalInfo: 'فبراير 2024',
            ),
          ],
          primaryColor: const Color(0xFF4CAF50),
          primaryGradient: const [
            Color(0xFF4CAF50),
            Color(0xFF45a049),
          ],
        ),
      ));
    }
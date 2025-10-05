import 'package:flutter/material.dart';

class QualityAuditorWaterScreen extends StatefulWidget {
  const QualityAuditorWaterScreen({super.key});

  @override
  State<QualityAuditorWaterScreen> createState() => _QualityAuditorWaterScreenState();
}

class _QualityAuditorWaterScreenState extends State<QualityAuditorWaterScreen> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _waterQualityTests = [];
  final List<Map<String, dynamic>> _complianceReports = [];
  final List<Map<String, dynamic>> _alerts = [];

  final TextEditingController _testLocationController = TextEditingController();
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _turbidityController = TextEditingController();
  final TextEditingController _chlorineController = TextEditingController();
  final TextEditingController _bacteriaController = TextEditingController();
  final TextEditingController _alertDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // بيانات تجريبية للعرض
    _waterQualityTests.addAll([
      {
        'id': '1',
        'location': 'محطة التنقية الرئيسية',
        'date': '2024-01-15',
        'ph': '7.2',
        'turbidity': '0.8',
        'chlorine': '1.2',
        'bacteria': 'سلبي',
        'status': 'مطابق'
      },
      {
        'id': '2',
        'location': 'خزان المنطقة الشمالية',
        'date': '2024-01-15',
        'ph': '6.8',
        'turbidity': '1.2',
        'chlorine': '0.9',
        'bacteria': 'سلبي',
        'status': 'مطابق'
      },
      {
        'id': '3',
        'location': 'بئر المنطقة الجنوبية',
        'date': '2024-01-15',
        'ph': '5.9',
        'turbidity': '2.1',
        'chlorine': '0.3',
        'bacteria': 'إيجابي',
        'status': 'غير مطابق'
      },
    ]);

    _complianceReports.addAll([
      {
        'id': 'R1',
        'title': 'تقرير المطابقة الشهري',
        'period': 'يناير 2024',
        'status': 'مكتمل',
        'complianceRate': '98%'
      },
      {
        'id': 'R2',
        'title': 'تقرير الجودة الأسبوعي',
        'period': 'الأسبوع 2-2024',
        'status': 'قيد الإعداد',
        'complianceRate': '95%'
      },
    ]);

    _alerts.addAll([
      {
        'id': 'A1',
        'type': 'حموضة',
        'location': 'خزان المنطقة الشرقية',
        'date': '2024-01-15',
        'value': '5.8',
        'standard': '6.5-8.5',
        'severity': 'high',
        'status': 'قيد المعالجة',
        'description': 'انخفاض شديد في درجة الحموضة'
      },
      {
        'id': 'A2',
        'type': 'عكورة',
        'location': 'محطة المعالجة الثانوية',
        'date': '2024-01-14',
        'value': '3.2',
        'standard': 'أقل من 1.0',
        'severity': 'medium',
        'status': 'مكتمل',
        'description': 'ارتفاع في مستوى العكورة'
      },
      {
        'id': 'A3',
        'type': 'كلور',
        'location': 'شبكة التوزيع المركزية',
        'date': '2024-01-13',
        'value': '0.2',
        'standard': '0.5-2.0',
        'severity': 'high',
        'status': 'قيد المعالجة',
        'description': 'انخفاض مستوى الكلور المتبقي'
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'مدقق جودة المياه',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF104E58),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // عداد الإبلاغات غير المقروءة
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.warning_amber_rounded, size: 24),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),
              if (_getUnresolvedAlertsCount() > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      _getUnresolvedAlertsCount().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _buildCurrentScreen(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // شريط التنقل السفلي المخصص
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF104E58),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 11,
          ),
          items: [
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.home_outlined, Icons.home_filled, 0),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.analytics_outlined, Icons.analytics, 1),
              label: 'الاختبارات',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.assignment_outlined, Icons.assignment, 2),
              label: 'التقارير',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.warning_outlined, Icons.warning_amber_rounded, 3),
              label: 'الإبلاغات',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.add_circle_outline, Icons.add_circle, 4),
              label: 'إضافة',
            ),
          ],
        ),
      ),
    );
  }

  // أيقونة متحركة
  Widget _buildAnimatedIcon(IconData outlineIcon, IconData filledIcon, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _currentIndex == index 
            ? const Color(0xFF104E58).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        _currentIndex == index ? filledIcon : outlineIcon,
        color: _currentIndex == index 
            ? const Color(0xFF104E58)
            : Colors.grey,
        size: _currentIndex == index ? 26 : 24,
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildQualityTests();
      case 2:
        return _buildReports();
      case 3:
        return _buildAlerts();
      case 4:
        return _buildAddTest();
      default:
        return _buildDashboard();
    }
  }

  // الشاشة الرئيسية - Dashboard
  Widget _buildDashboard() {
    final unresolvedAlerts = _alerts.where((alert) => alert['status'] == 'قيد المعالجة').length;
    final totalTests = _waterQualityTests.length;
    final compliantTests = _waterQualityTests.where((test) => test['status'] == 'مطابق').length;
    final complianceRate = totalTests > 0 ? ((compliantTests / totalTests) * 100).round() : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقات الإحصائيات
          const Text(
            'نظرة عامة على جودة المياه',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: Color(0xFF104E58),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard(
                'اختبارات اليوم', 
                totalTests.toString(), 
                Icons.water_drop_outlined,
                Icons.water_drop,
                Colors.blue,
                'إجمالي الاختبارات'
              ),
              _buildStatCard(
                'إبلاغات نشطة', 
                unresolvedAlerts.toString(), 
                Icons.warning_outlined,
                Icons.warning_amber_rounded,
                Colors.orange,
                'قيد المعالجة'
              ),
              _buildStatCard(
                'نسبة المطابقة', 
                '$complianceRate%', 
                Icons.check_circle_outline,
                Icons.check_circle,
                Colors.green,
                'من إجمالي الاختبارات'
              ),
              _buildStatCard(
                'المناطق المغطاة', 
                '8', 
                Icons.location_on_outlined,
                Icons.location_on,
                Colors.purple,
                'مناطق المراقبة'
              ),
            ],
          ),
          const SizedBox(height: 24),

          // الإبلاغات العاجلة
          if (unresolvedAlerts > 0) ...[
            _buildUrgentAlertsSection(),
            const SizedBox(height: 24),
          ],

          // الاختبارات الحديثة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الاختبارات الحديثة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: Color(0xFF104E58),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._waterQualityTests.take(2).map(_buildTestItem).toList(),
        ],
      ),
    );
  }

  // بطاقة إحصائية دائرية
  Widget _buildStatCard(String title, String value, IconData outlineIcon, IconData filledIcon, Color color, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                filledIcon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
                color: Color(0xFF104E58),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Tajawal',
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // قسم الإبلاغات العاجلة
  Widget _buildUrgentAlertsSection() {
    final urgentAlerts = _alerts.where((alert) => 
      alert['status'] == 'قيد المعالجة' && alert['severity'] == 'high'
    ).toList();

    if (urgentAlerts.isEmpty) return const SizedBox();

    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error_outline, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'إبلاغات عاجلة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...urgentAlerts.map(_buildAlertItem).toList(),
        ],
      ),
    );
  }

  // قائمة اختبارات الجودة
  Widget _buildQualityTests() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.analytics, color: Color(0xFF104E58), size: 28),
              const SizedBox(width: 12),
              const Text(
                'اختبارات جودة المياه',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: Color(0xFF104E58),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.filter_list_rounded, size: 24),
                onPressed: _showFilterDialog,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _waterQualityTests.length,
            itemBuilder: (context, index) {
              return _buildTestItem(_waterQualityTests[index]);
            },
          ),
        ),
      ],
    );
  }

  // شاشة التقارير
  Widget _buildReports() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.assignment, color: Color(0xFF104E58), size: 28),
              const SizedBox(width: 12),
              const Text(
                'تقارير المطابقة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: Color(0xFF104E58),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'تقرير جديد',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                  ),
                ),
                onPressed: _generateNewReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF104E58),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _complianceReports.length,
            itemBuilder: (context, index) {
              return _buildReportItem(_complianceReports[index]);
            },
          ),
        ),
      ],
    );
  }

  // شاشة الإبلاغات
  Widget _buildAlerts() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              const Text(
                'إبلاغات جودة المياه',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: Color(0xFF104E58),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.add_alert, size: 20),
                label: const Text(
                  'إبلاغ جديد',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                  ),
                ),
                onPressed: _showNewAlertDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _alerts.length,
            itemBuilder: (context, index) {
              return _buildAlertItem(_alerts[index]);
            },
          ),
        ),
      ],
    );
  }

  // شاشة إضافة اختبار جديد
  Widget _buildAddTest() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إضافة اختبار جودة جديد',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: Color(0xFF104E58),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'أدخل بيانات اختبار جودة المياه الجديد',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Tajawal',
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          _buildTestForm(),
        ],
      ),
    );
  }

  // نموذج إضافة اختبار
  Widget _buildTestForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _testLocationController,
              decoration: InputDecoration(
                labelText: 'موقع الاختبار',
                labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _phController,
                    decoration: InputDecoration(
                      labelText: 'درجة الحموضة (pH)',
                      labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.ac_unit),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _turbidityController,
                    decoration: InputDecoration(
                      labelText: 'العكورة (NTU)',
                      labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.blur_on),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _chlorineController,
                    decoration: InputDecoration(
                      labelText: 'الكلور (mg/L)',
                      labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.clean_hands),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _bacteriaController,
                    decoration: InputDecoration(
                      labelText: 'البكتيريا',
                      labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.bug_report),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save, size: 24),
                label: const Text(
                  'حفظ الاختبار',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _saveWaterTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF104E58),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // عنصر اختبار فردي
  Widget _buildTestItem(Map<String, dynamic> test) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: test['status'] == 'مطابق' 
                ? Colors.green.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            test['status'] == 'مطابق' ? Icons.check_circle : Icons.warning,
            color: test['status'] == 'مطابق' ? Colors.green : Colors.orange,
            size: 24,
          ),
        ),
        title: Text(
          test['location'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'التاريخ: ${test['date']}',
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
              ),
            ),
            Text(
              'الحموضة: ${test['ph']} - العكورة: ${test['turbidity']} NTU',
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: test['status'] == 'مطابق' ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            test['status'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        onTap: () => _showTestDetails(test),
      ),
    );
  }

  // عنصر تقرير فردي
  Widget _buildReportItem(Map<String, dynamic> report) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.assignment, color: Colors.blue, size: 24),
        ),
        title: Text(
          report['title'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'الفترة: ${report['period']}',
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              report['complianceRate'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontFamily: 'Tajawal',
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: report['status'] == 'مكتمل' ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                report['status'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showReportDetails(report),
      ),
    );
  }

  // عنصر إبلاغ فردي
  Widget _buildAlertItem(Map<String, dynamic> alert) {
    Color severityColor = Colors.grey;
    IconData severityIcon = Icons.info_outline;

    switch (alert['severity']) {
      case 'high':
        severityColor = Colors.red;
        severityIcon = Icons.error_outline;
        break;
      case 'medium':
        severityColor = Colors.orange;
        severityIcon = Icons.warning_amber_rounded;
        break;
      case 'low':
        severityColor = Colors.blue;
        severityIcon = Icons.info_outline;
        break;
    }

    Color statusColor = alert['status'] == 'قيد المعالجة' ? Colors.orange : Colors.green;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: severityColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(severityIcon, color: severityColor, size: 24),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildAlertTypeIcon(alert['type']),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${alert['type']} - ${alert['location']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'القيمة: ${alert['value']} | المعيار: ${alert['standard']}',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Tajawal',
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            alert['description'],
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14,
            ),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                alert['status'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              alert['date'],
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Tajawal',
                color: Colors.grey,
              ),
            ),
          ],
        ),
        onTap: () => _showAlertDetails(alert),
      ),
    );
  }

  // أيقونة نوع الإبلاغ
  Widget _buildAlertTypeIcon(String type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case 'حموضة':
        icon = Icons.ac_unit;
        color = Colors.blue;
        break;
      case 'عكورة':
        icon = Icons.blur_on;
        color = Colors.brown;
        break;
      case 'كلور':
        icon = Icons.clean_hands;
        color = Colors.green;
        break;
      case 'بكتيريا':
        icon = Icons.bug_report;
        color = Colors.red;
        break;
      default:
        icon = Icons.water_drop;
        color = Colors.blue;
    }
    
    return Icon(icon, color: color, size: 20);
  }

  // وظائف الأعمال الرئيسية لمدقق الجودة
  void _saveWaterTest() {
    if (_testLocationController.text.isEmpty) {
      _showMessage('الرجاء إدخال موقع الاختبار');
      return;
    }

    final newTest = {
      'id': (_waterQualityTests.length + 1).toString(),
      'location': _testLocationController.text,
      'date': '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
      'ph': _phController.text,
      'turbidity': _turbidityController.text,
      'chlorine': _chlorineController.text,
      'bacteria': _bacteriaController.text,
      'status': _calculateTestStatus(),
    };

    setState(() {
      _waterQualityTests.insert(0, newTest);
    });

    // تنظيف الحقول
    _testLocationController.clear();
    _phController.clear();
    _turbidityController.clear();
    _chlorineController.clear();
    _bacteriaController.clear();

    _showMessage('تم حفظ اختبار الجودة بنجاح');
  }

  String _calculateTestStatus() {
    final ph = double.tryParse(_phController.text) ?? 0;
    final turbidity = double.tryParse(_turbidityController.text) ?? 0;
    final chlorine = double.tryParse(_chlorineController.text) ?? 0;
    
    if (ph >= 6.5 && ph <= 8.5 && turbidity <= 1.0 && chlorine >= 0.5 && chlorine <= 2.0) {
      return 'مطابق';
    } else {
      return 'غير مطابق';
    }
  }

  void _showTestDetails(Map<String, dynamic> test) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.analytics, color: Color(0xFF104E58), size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'تفاصيل الاختبار',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: Color(0xFF104E58),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow('الموقع:', test['location']),
              _buildDetailRow('التاريخ:', test['date']),
              _buildDetailRow('درجة الحموضة:', '${test['ph']} pH'),
              _buildDetailRow('العكورة:', '${test['turbidity']} NTU'),
              _buildDetailRow('الكلور:', '${test['chlorine']} mg/L'),
              _buildDetailRow('البكتيريا:', test['bacteria']),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: test['status'] == 'مطابق' ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'الحالة: ${test['status']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF104E58),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportDetails(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.assignment, color: Color(0xFF104E58), size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'تفاصيل التقرير',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: Color(0xFF104E58),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow('العنوان:', report['title']),
              _buildDetailRow('الفترة:', report['period']),
              _buildDetailRow('الحالة:', report['status']),
              _buildDetailRow('نسبة المطابقة:', report['complianceRate']),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'إغلاق',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _shareReport(report),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF104E58),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'مشاركة',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDetails(Map<String, dynamic> alert) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildAlertTypeIcon(alert['type']),
                  const SizedBox(width: 12),
                  Text(
                    'إبلاغ ${alert['type']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: Color(0xFF104E58),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow('الموقع:', alert['location']),
              _buildDetailRow('التاريخ:', alert['date']),
              _buildDetailRow('القيمة المسجلة:', alert['value']),
              _buildDetailRow('المعيار المسموح:', alert['standard']),
              _buildDetailRow('مستوى الخطورة:', alert['severity'] == 'high' ? 'عالي' : 
                alert['severity'] == 'medium' ? 'متوسط' : 'منخفض'),
              _buildDetailRow('الحالة:', alert['status']),
              const SizedBox(height: 8),
              const Text(
                'وصف المشكلة:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                alert['description'],
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'إغلاق',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  if (alert['status'] == 'قيد المعالجة') ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _resolveAlert(alert['id']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'تم الحل',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'تصفية الاختبارات',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: Color(0xFF104E58),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'جميع الاختبارات',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'المطابقة فقط',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'غير المطابقة',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF104E58),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateNewReport() {
    final newReport = {
      'id': 'R${_complianceReports.length + 1}',
      'title': 'تقرير المطابقة ${DateTime.now().month}/${DateTime.now().year}',
      'period': '${DateTime.now().month}/${DateTime.now().year}',
      'status': 'قيد الإعداد',
      'complianceRate': '0%',
    };

    setState(() {
      _complianceReports.insert(0, newReport);
    });

    _showMessage('تم إنشاء تقرير جديد');
  }

  void _shareReport(Map<String, dynamic> report) {
    _showMessage('تم مشاركة التقرير: ${report['title']}');
  }

  void _showNewAlertDialog() {
    String? selectedType = 'حموضة';
    String? selectedSeverity = 'medium';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.add_alert, color: Colors.orange, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'إبلاغ جديد',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          color: Color(0xFF104E58),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(
                      labelText: 'نوع المشكلة',
                      labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ['حموضة', 'عكورة', 'كلور', 'بكتيريا', 'أخرى']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type, style: const TextStyle(fontFamily: 'Tajawal')),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _testLocationController,
                    decoration: InputDecoration(
                      labelText: 'موقع المشكلة',
                      labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _alertDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'وصف المشكلة',
                      labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedSeverity,
                    decoration: InputDecoration(
                      labelText: 'مستوى الخطورة',
                      labelStyle: const TextStyle(fontFamily: 'Tajawal'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'low',
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue),
                            const SizedBox(width: 8),
                            const Text('منخفض', style: TextStyle(fontFamily: 'Tajawal')),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'medium',
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.orange),
                            const SizedBox(width: 8),
                            const Text('متوسط', style: TextStyle(fontFamily: 'Tajawal')),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'high',
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            const Text('عالي', style: TextStyle(fontFamily: 'Tajawal')),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSeverity = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _createNewAlert(selectedType!, selectedSeverity!);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'إرسال',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _createNewAlert(String type, String severity) {
    if (_testLocationController.text.isEmpty || _alertDescriptionController.text.isEmpty) {
      _showMessage('الرجاء ملء جميع الحقول');
      return;
    }

    final newAlert = {
      'id': 'A${_alerts.length + 1}',
      'type': type,
      'location': _testLocationController.text,
      'date': '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
      'value': _getDefaultValueForType(type),
      'standard': _getStandardForType(type),
      'severity': severity,
      'status': 'قيد المعالجة',
      'description': _alertDescriptionController.text,
    };

    setState(() {
      _alerts.insert(0, newAlert);
    });

    _testLocationController.clear();
    _alertDescriptionController.clear();

    _showMessage('تم إرسال الإبلاغ بنجاح');
  }

  String _getDefaultValueForType(String type) {
    switch (type) {
      case 'حموضة': return '5.8';
      case 'عكورة': return '3.2';
      case 'كلور': return '0.2';
      case 'بكتيريا': return 'إيجابي';
      default: return 'غير طبيعي';
    }
  }

  String _getStandardForType(String type) {
    switch (type) {
      case 'حموضة': return '6.5-8.5';
      case 'عكورة': return 'أقل من 1.0';
      case 'كلور': return '0.5-2.0';
      case 'بكتيريا': return 'سلبي';
      default: return '-';
    }
  }

  void _resolveAlert(String alertId) {
    setState(() {
      final alertIndex = _alerts.indexWhere((alert) => alert['id'] == alertId);
      if (alertIndex != -1) {
        _alerts[alertIndex]['status'] = 'مكتمل';
      }
    });
    Navigator.pop(context);
    _showMessage('تم حل الإبلاغ بنجاح');
  }

  int _getUnresolvedAlertsCount() {
    return _alerts.where((alert) => alert['status'] == 'قيد المعالجة').length;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Tajawal', fontSize: 16),
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF104E58),
      ),
    );
  }

  @override
  void dispose() {
    _testLocationController.dispose();
    _phController.dispose();
    _turbidityController.dispose();
    _chlorineController.dispose();
    _bacteriaController.dispose();
    _alertDescriptionController.dispose();
    super.dispose();
  }
}
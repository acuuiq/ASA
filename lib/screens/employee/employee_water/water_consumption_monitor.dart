import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WaterConsumptionMonitorScreen extends StatefulWidget {
  const WaterConsumptionMonitorScreen({super.key});
  static const String screenroot = 'water_consumption_monitor_screen';

  @override
  WaterConsumptionMonitorScreenState createState() =>
      WaterConsumptionMonitorScreenState();
}

class WaterConsumptionMonitorScreenState
    extends State<WaterConsumptionMonitorScreen> {
  // الألوان للتصميم الحكومي لشركة المياه - متوافقة مع الوضع المظلم
  Color get _primaryColor => const Color(0xFF0066B3);
  Color get _secondaryColor => const Color(0xFF003366);
  Color get _accentColor => const Color(0xFF00A8E8);
  Color get _successColor => const Color(0xFF28A745);
  Color get _warningColor => const Color(0xFFFFC107);
  Color get _errorColor => const Color(0xFFDC3545);
  Color get _waterBlue => const Color(0xFF0077BE);
  
  // ألوان ديناميكية تعتمد على الوضع المظلم
  Color _backgroundColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF121212) : const Color(0xFFE6F3FF);
  }
  
  Color _cardColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  }
  
  Color _textColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white : const Color(0xFF1A2E35);
  }
  
  Color _textSecondaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF5A6C7D);
  }
  
  Color _borderColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF333333) : const Color(0xFFB8D8F0);
  }
  
  Color _gradientStart(BuildContext context) => _primaryColor;
  Color _gradientEnd(BuildContext context) => _secondaryColor;

  int _selectedTab = 0;
  String _selectedArea = 'جميع المناطق';
  String _selectedReportType = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;
  int _currentReportInnerTab = 0;

  // متغيرات الإعدادات
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = false;

  String _language = 'العربية';
  final List<String> _languages = ['العربية', 'English'];
  
  final List<String> _areas = ['جميع المناطق', 'حي الرياض', 'حي النخيل', 'حي العليا', 'حي الصفا'];
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

  // بيانات العينات للمياه
  final List<Map<String, dynamic>> _waterConsumptionData = [
    {
      'area': 'حي الرياض',
      'currentConsumption': 3750,
      'previousConsumption': 3540,
      'changePercent': 5.9,
      'customers': 250,
      'avgConsumption': 15,
      'trend': 'up',
      'highConsumptionCustomers': 12,
      'waterPressure': 3.2,
    },
    {
      'area': 'حي النخيل',
      'currentConsumption': 2670,
      'previousConsumption': 2760,
      'changePercent': -3.3,
      'customers': 180,
      'avgConsumption': 14.8,
      'trend': 'down',
      'highConsumptionCustomers': 6,
      'waterPressure': 3.5,
    },
    {
      'area': 'حي العليا',
      'currentConsumption': 4680,
      'previousConsumption': 4440,
      'changePercent': 5.4,
      'customers': 300,
      'avgConsumption': 15.6,
      'trend': 'up',
      'highConsumptionCustomers': 22,
      'waterPressure': 3.0,
    },
    {
      'area': 'حي الصفا',
      'currentConsumption': 2160,
      'previousConsumption': 2250,
      'changePercent': -4.0,
      'customers': 150,
      'avgConsumption': 14.4,
      'trend': 'down',
      'highConsumptionCustomers': 4,
      'waterPressure': 3.8,
    },
  ];

  // بيانات الاستهلاك اليومي للمياه
  final List<Map<String, dynamic>> _dailyWaterData = [
    {
      'date': DateTime.now().subtract(Duration(days: 0)),
      'area': 'حي الرياض',
      'consumption': 125,
      'peakHours': '6-9 صباحاً',
      'peakConsumption': 48,
      'avgConsumption': 0.5,
      'customers': 250,
      'waterPressure': 3.2,
      'leakageAlerts': 2,
    },
    {
      'date': DateTime.now().subtract(Duration(days: 0)),
      'area': 'حي النخيل',
      'consumption': 89,
      'peakHours': '7-10 صباحاً',
      'peakConsumption': 32,
      'avgConsumption': 0.49,
      'customers': 180,
      'waterPressure': 3.5,
      'leakageAlerts': 0,
    },
    {
      'date': DateTime.now().subtract(Duration(days: 0)),
      'area': 'حي العليا',
      'consumption': 156,
      'peakHours': '5-8 صباحاً',
      'peakConsumption': 58,
      'avgConsumption': 0.52,
      'customers': 300,
      'waterPressure': 3.0,
      'leakageAlerts': 3,
    },
    {
      'date': DateTime.now().subtract(Duration(days: 0)),
      'area': 'حي الصفا',
      'consumption': 72,
      'peakHours': '6-9 صباحاً',
      'peakConsumption': 28,
      'avgConsumption': 0.48,
      'customers': 150,
      'waterPressure': 3.8,
      'leakageAlerts': 1,
    },
    {
      'date': DateTime.now().subtract(Duration(days: 1)),
      'area': 'جميع المناطق',
      'consumption': 442,
      'peakHours': '6-9 صباحاً',
      'peakConsumption': 166,
      'avgConsumption': 0.5,
      'customers': 880,
      'waterPressure': 3.4,
      'leakageAlerts': 6,
    },
  ];

  // بيانات الاستهلاك الشهري للمياه
  final List<Map<String, dynamic>> _monthlyWaterData = [
    {
      'month': 'يناير 2024',
      'area': 'حي الرياض',
      'consumption': 112500,
      'previousMonth': 108600,
      'changePercent': 3.5,
      'avgDaily': 3629,
      'peakDay': '15 يناير',
      'peakConsumption': 132,
      'customers': 250,
      'totalLeakages': 15,
    },
    {
      'month': 'يناير 2024',
      'area': 'حي النخيل',
      'consumption': 80100,
      'previousMonth': 82800,
      'changePercent': -3.2,
      'avgDaily': 2583,
      'peakDay': '18 يناير',
      'peakConsumption': 95,
      'customers': 180,
      'totalLeakages': 8,
    },
    {
      'month': 'يناير 2024',
      'area': 'حي العليا',
      'consumption': 140400,
      'previousMonth': 133800,
      'changePercent': 5.0,
      'avgDaily': 4529,
      'peakDay': '20 يناير',
      'peakConsumption': 165,
      'customers': 300,
      'totalLeakages': 22,
    },
    {
      'month': 'يناير 2024',
      'area': 'حي الصفا',
      'consumption': 64800,
      'previousMonth': 67200,
      'changePercent': -3.9,
      'avgDaily': 2090,
      'peakDay': '12 يناير',
      'peakConsumption': 78,
      'customers': 150,
      'totalLeakages': 6,
    },
    {
      'month': 'ديسمبر 2023',
      'area': 'جميع المناطق',
      'consumption': 397800,
      'previousMonth': 386400,
      'changePercent': 3.1,
      'avgDaily': 12832,
      'peakDay': '25 ديسمبر',
      'peakConsumption': 485,
      'customers': 880,
      'totalLeakages': 51,
    },
  ];

  // بيانات الإنذارات للمياه
  final List<Map<String, dynamic>> _waterAlertsData = [
    {
      'type': 'استهلاك مرتفع',
      'area': 'حي العليا',
      'customer': 'أحمد محمد',
      'consumption': 85,
      'average': 45,
      'percentage': 89,
      'priority': 'عالي',
      'date': '2024-01-15',
      'status': 'غير معالج',
    },
    {
      'type': 'تسريب مياه',
      'area': 'حي الرياض',
      'customer': 'مدرسة الأندلس',
      'consumption': 120,
      'average': 60,
      'percentage': 100,
      'priority': 'عالي',
      'date': '2024-01-14',
      'status': 'تحت المراجعة',
      'leakageLocation': 'شارع الملك فهد',
    },
    {
      'type': 'انخفاض الضغط',
      'area': 'حي النخيل',
      'customer': 'مستشفى النخيل',
      'consumption': 45,
      'average': 70,
      'percentage': -36,
      'priority': 'متوسط',
      'date': '2024-01-13',
      'status': 'مغلق',
      'pressure': 1.8,
    },
  ];


  // بيانات المناطق للاختيار
  final List<String> _areasForSelection = ['جميع المناطق', 'حي الرياض', 'حي النخيل', 'حي العليا', 'حي الصفا'];

  // ========== تحسين القائمة المنسدلة ==========
  Widget _buildImprovedDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required String label,
    IconData? icon,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, right: 16, left: 16),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: _primaryColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white10 : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: _primaryColor),
                elevation: 8,
                style: TextStyle(
                  fontSize: 16,
                  color: _textColor(context),
                  fontWeight: FontWeight.w500,
                ),
                dropdownColor: _cardColor(context),
                borderRadius: BorderRadius.circular(12),
                items: items.map<DropdownMenuItem<String>>((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          if (item == value)
                            Icon(Icons.check_circle_rounded, color: _successColor, size: 18),
                          if (item == value)
                            const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                color: item == value ? _primaryColor : _textColor(context),
                                fontWeight: item == value ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== تحسين قائمة المنطقة ==========
  Widget _buildImprovedAreaFilter() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.location_on_rounded, color: _primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedArea,
                isExpanded: true,
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _primaryColor,
                    size: 20,
                  ),
                ),
                elevation: 8,
                style: TextStyle(
                  fontSize: 16,
                  color: _textColor(context),
                  fontWeight: FontWeight.w600,
                ),
                dropdownColor: _cardColor(context),
                borderRadius: BorderRadius.circular(12),
                items: _areasForSelection.map((String area) {
                  bool isSelected = area == _selectedArea;
                  return DropdownMenuItem<String>(
                    value: area,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? _primaryColor.withOpacity(0.05) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (isSelected)
                            Icon(Icons.check_circle_rounded, color: _successColor, size: 18),
                          if (isSelected)
                            const SizedBox(width: 8),
                          Icon(
                            Icons.water_drop_rounded,
                            size: 16,
                            color: isSelected ? _primaryColor : _textSecondaryColor(context),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              area,
                              style: TextStyle(
                                color: isSelected ? _primaryColor : _textColor(context),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (area != 'جميع المناطق')
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_getCustomersCount(area)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _primaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedArea = newValue;
                    });
                    _showSuccessSnackbar('تم تغيير المنطقة إلى: $newValue');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getCustomersCount(String area) {
    final areaData = _waterConsumptionData.firstWhere(
      (data) => data['area'] == area,
      orElse: () => {'customers': 0},
    );
    return areaData['customers'] ?? 0;
  }

  // ========== دوال الإعدادات ==========
  void _resetToDefaults() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _cardColor(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.restart_alt_rounded, color: _primaryColor),
              SizedBox(width: 8),
              Text('إعادة التعيين', style: TextStyle(color: _textColor(context))),
            ],
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد إعادة جميع الإعدادات إلى القيم الافتراضية؟',
            style: TextStyle(color: _textColor(context)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor(context))),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _notificationsEnabled = true;
                  _soundEnabled = true;
                  _vibrationEnabled = false;
                  _language = 'العربية';
                });
                
                themeProvider.toggleTheme(false);
                
                Navigator.pop(context);
                _showSuccessSnackbar('تم إعادة التعيين إلى الإعدادات الافتراضية');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }

  // ========== دوال واجهة الإعدادات ==========

  Widget _buildSettingsSection(String title, IconData icon, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _primaryColor, size: 22),
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: themeProvider.isDarkMode ? Colors.white : _textColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkModeSwitch(ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? Colors.white10 : _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: themeProvider.isDarkMode ? Colors.amber : Colors.grey,
              size: 22,
            ),
          ),
          SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الوضع الداكن',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: themeProvider.isDarkMode ? Colors.white : _textColor(context),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  themeProvider.isDarkMode ? 'مفعل - استمتع بتجربة مريحة للعين' : 'معطل - استمتع بالمظهر الافتراضي',
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.isDarkMode ? Colors.white70 : _textSecondaryColor(context),
                  ),
                ),
              ],
            ),
          ),
          
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            activeColor: Colors.amber,
            activeTrackColor: Colors.amber.withOpacity(0.5),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch(String title, String subtitle, bool value, Function(bool) onChanged, ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? Colors.white10 : _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: themeProvider.isDarkMode ? Colors.white : _textColor(context),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.isDarkMode ? Colors.white70 : _textSecondaryColor(context),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingDropdown(String title, String value, List<String> items, Function(String?) onChanged, ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? Colors.white10 : _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: themeProvider.isDarkMode ? Colors.white : _textColor(context),
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode ? Colors.white10 : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _primaryColor.withOpacity(0.3)),
            ),
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: themeProvider.isDarkMode ? Colors.white : _textColor(context),
                    ),
                  ),
                );
              }).toList(),
              underline: SizedBox(),
              icon: Icon(Icons.arrow_drop_down_rounded, color: _primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(ThemeProvider themeProvider) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? Colors.white10 : _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAboutRow('الإصدار', '1.0.0', themeProvider),
          _buildAboutRow('تاريخ البناء', '2024-03-20', themeProvider),
          _buildAboutRow('المطور', 'وزارة الموارد المائية - العراق', themeProvider),
          _buildAboutRow('رقم الترخيص', 'MWR-2024-001', themeProvider),
          _buildAboutRow('آخر تحديث', '2024-03-15', themeProvider),
          _buildAboutRow('البريد الإلكتروني', 'support@water.gov.iq', themeProvider),
        ],
      ),
    );
  }

  Widget _buildAboutRow(String title, String value, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: themeProvider.isDarkMode ? Colors.white : _textColor(context),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white70 : _textSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  // ========== دوال المساعدة والدعم ==========

  Widget _buildContactCard() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? Colors.white10 : _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.support_agent_rounded, color: _primaryColor, size: 28),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'مركز الدعم الفني',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : _textColor(context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildContactItem(Icons.phone_rounded, 'رقم الدعم الفني', '07725252103', true),
          _buildContactItem(Icons.phone_rounded, 'رقم الطوارئ', '07862268894', true),
          _buildContactItem(Icons.email_rounded, 'البريد الإلكتروني', 'fadhilali402@gmail.com', false),
          _buildContactItem(Icons.access_time_rounded, 'ساعات العمل', '8:00 ص - 4:00 م', false),
          _buildContactItem(Icons.location_on_rounded, 'العنوان', 'بغداد - وزارة الموارد المائية', false),
          SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _makePhoneCall('07725252103'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.phone_rounded, size: 20),
                  label: Text('اتصال فوري'),
                ),
              ),
              SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value, bool isPhone) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: _primaryColor, size: 20),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : _textColor(context),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: isPhone ? () => _makePhoneCall(value) : null,
              child: Text(
                value,
                style: TextStyle(
                  color: isPhone ? _primaryColor : (isDarkMode ? Colors.white70 : _textSecondaryColor(context)),
                  decoration: isPhone ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDarkMode ? Colors.white : _textColor(context),
        ),
      ),
    );
  }

  List<Widget> _buildFAQItems() {
    Provider.of<ThemeProvider>(context, listen: false);

    List<Map<String, String>> faqs = [
      {
        'question': 'كيف يمكنني مراقبة الاستهلاك المرتفع للمياه؟',
        'answer': 'اذهب إلى قسم "الاستهلاك اليومي" أو "الاستهلاك الشهري" ← استعرض البيانات حسب المنطقة ← انقر على أي منطقة لعرض التفاصيل'
      },
      {
        'question': 'كيف أعرض تقرير استهلاك المياه الشهري؟',
        'answer': 'انتقل إلى قسم "التقارير" ← اختر "شهري" ← حدد الشهر المطلوب ← انقر على "إنشاء التقرير"'
      },
      {
        'question': 'كيف أتعامل مع إنذارات التسريبات؟',
        'answer': 'اذهب إلى قسم "الإنذارات" ← استعرض قائمة إنذارات التسريبات ← انقر على زر "معالجة" بجانب كل إنذار ← اتبع الإجراءات المطلوبة'
      },
      {
        'question': 'كيف أتحقق من ضغط المياه في منطقة معينة؟',
        'answer': 'استخدم فلتر المنطقة في أعلى الشاشة ← اختر المنطقة المطلوبة ← سيتم عرض بيانات ضغط المياه في بطاقة معلومات المنطقة'
      },
      {
        'question': 'كيف أقوم بتصدير تقارير استهلاك المياه؟',
        'answer': 'انتقل إلى قسم التقارير ← اختر نوع التقرير والفترة ← انقر على "إنشاء التقرير" ← اختر "تصدير PDF" لحفظ أو مشاركة التقرير'
      },
    ];

    return faqs.map((faq) {
      return _buildExpandableItem(faq['question']!, faq['answer']!);
    }).toList();
  }

  Widget _buildExpandableItem(String question, String answer) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? Colors.white10 : _cardColor(context),
      ),
      child: ExpansionTile(
        leading: Icon(Icons.help_outline_rounded, color: _primaryColor),
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDarkMode ? Colors.white : _textColor(context),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : _textSecondaryColor(context),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoCard() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? Colors.white10 : _cardColor(context),
      ),
      child: Column(
        children: [
          _buildInfoRow('الإصدار', '1.0.0', isDarkMode),
          _buildInfoRow('تاريخ البناء', '2024-03-20', isDarkMode),
          _buildInfoRow('المطور', 'وزارة الموارد المائية', isDarkMode),
          _buildInfoRow('رقم الترخيص', 'MWR-2024-001', isDarkMode),
          _buildInfoRow('آخر تحديث', '2024-03-15', isDarkMode),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : _textColor(context),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : _textSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  // ========== دوال التفاعل ==========

  void _makePhoneCall(String phoneNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري الاتصال بـ $phoneNumber'),
        backgroundColor: _primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
    launch('tel:9647862268894');
  }

  // ========== دوال PDF والتقارير ==========

  Future<void> _generatePdfReport(String period) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              _buildPdfHeader(period),
              pw.SizedBox(height: 20),
              _buildPdfSummary(),
              pw.SizedBox(height: 20),
              _buildPdfConsumptionDetails(),
              pw.SizedBox(height: 20),
              _buildPdfAlerts(),
              pw.SizedBox(height: 20),
              _buildPdfDailyConsumption(),
            ];
          },
        ),
      );

      final Uint8List pdfBytes = await pdf.save();
      await _sharePdfFile(pdfBytes, period);

    } catch (e) {
      _showErrorSnackbar('خطأ في تصدير التقرير: $e');
    }
  }

  Future<void> _sharePdfFile(Uint8List pdfBytes, String period) async {
    try {
      final fileName = 'تقرير_استهلاك_المياه_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      await Share.shareXFiles(
        [
          XFile.fromData(
            pdfBytes,
            name: fileName,
            mimeType: 'application/pdf',
          )
        ],
        subject: 'تقرير استهلاك المياه - $period',
        text: 'مرفق تقرير استهلاك المياه للفترة $period',
      );

      _showSuccessSnackbar('تم تصدير التقرير بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في مشاركة الملف: $e');
    }
  }

  pw.Widget _buildPdfHeader(String period) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'وزارة الموارد المائية',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
            pw.Text(
              'تقرير مراقبة استهلاك المياه',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            pw.Text(
              'نوع التقرير: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(_selectedReportType),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            pw.Text(
              'الفترة: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(period),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            pw.Text(
              'المنطقة: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(_selectedArea),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            pw.Text(
              'تاريخ الإنشاء: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPdfSummary() {
    final filteredData = _selectedArea == 'جميع المناطق'
        ? _waterConsumptionData
        : _waterConsumptionData.where((item) => item['area'] == _selectedArea).toList();

    final totalConsumption = filteredData.fold<double>(
      0,
      (sum, item) => sum + (item['currentConsumption'] as int).toDouble(),
    );
    final totalCustomers = filteredData.fold<int>(
      0,
      (sum, item) => sum + (item['customers'] as int),
    );
    final avgConsumption = totalCustomers > 0
        ? totalConsumption / totalCustomers
        : 0;
    final highConsumptionCount = filteredData.fold<int>(
      0,
      (sum, item) => sum + (item['highConsumptionCustomers'] as int),
    );
    final avgPressure = filteredData.fold<double>(
      0,
      (sum, item) => sum + (item['waterPressure'] as double),
    ) / (filteredData.length > 0 ? filteredData.length : 1);

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blue),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ملخص التقرير',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('إجمالي الاستهلاك:'),
              pw.Text('${NumberFormat('#,##0').format(totalConsumption)} م³'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('متوسط الاستهلاك:'),
              pw.Text('${avgConsumption.toStringAsFixed(1)} م³/عميل'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('عدد العملاء:'),
              pw.Text(NumberFormat('#,##0').format(totalCustomers)),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('عملاء استهلاك مرتفع:'),
              pw.Text(highConsumptionCount.toString()),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('متوسط ضغط المياه:'),
              pw.Text('${avgPressure.toStringAsFixed(1)} بار'),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfConsumptionDetails() {
    final filteredData = _selectedArea == 'جميع المناطق'
        ? _waterConsumptionData
        : _waterConsumptionData.where((item) => item['area'] == _selectedArea).toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'تفاصيل الاستهلاك حسب المنطقة',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.blue100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('المنطقة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الاستهلاك الحالي', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('عدد العملاء', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('التغيير %', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الضغط', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ...filteredData.map((area) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(area['area']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('${NumberFormat('#,##0').format(area['currentConsumption'])} م³'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(area['customers'].toString()),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    '${area['changePercent'] > 0 ? '+' : ''}${area['changePercent'].toStringAsFixed(1)}%',
                    style: pw.TextStyle(
                      color: area['changePercent'] > 0 ? PdfColors.red : PdfColors.green,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('${area['waterPressure'].toStringAsFixed(1)} بار'),
                ),
              ],
            )).toList(),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPdfAlerts() {
    final filteredAlerts = _getFilteredAlerts();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'إنذارات المياه',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 10),
        if (filteredAlerts.isEmpty)
          pw.Text('لا توجد إنذارات'),
        ...filteredAlerts.map((alert) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 10),
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(5),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    alert['type'],
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: pw.BoxDecoration(
                      color: _getPdfPriorityColor(alert['priority']),
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    child: pw.Text(
                      alert['priority'],
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Text('العميل: ${alert['customer']}'),
              pw.Text('المنطقة: ${alert['area']}'),
              pw.Text('التاريخ: ${alert['date']}'),
              pw.Text('الاستهلاك: ${alert['consumption']} م³ (المتوسط: ${alert['average']} م³)'),
              pw.Text('نسبة الزيادة: ${alert['percentage']}%'),
              pw.Text('الحالة: ${alert['status']}'),
              if (alert['leakageLocation'] != null)
                pw.Text('موقع التسريب: ${alert['leakageLocation']}'),
              if (alert['pressure'] != null)
                pw.Text('الضغط: ${alert['pressure']} بار'),
            ],
          ),
        )).toList(),
      ],
    );
  }

  pw.Widget _buildPdfDailyConsumption() {
    final filteredData = _selectedArea == 'جميع المناطق'
        ? _dailyWaterData.where((item) => item['area'] == 'جميع المناطق').toList()
        : _dailyWaterData.where((item) => item['area'] == _selectedArea).toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'الاستهلاك اليومي للمياه',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.blue100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('التاريخ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('المنطقة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الاستهلاك', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('ذروة الاستهلاك', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('إنذارات التسريب', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ...filteredData.map((item) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(DateFormat('yyyy-MM-dd').format(item['date'])),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(item['area']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('${NumberFormat('#,##0').format(item['consumption'])} م³'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('${item['peakConsumption']} م³ (${item['peakHours']})'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(item['leakageAlerts'].toString()),
                ),
              ],
            )).toList(),
          ],
        ),
      ],
    );
  }

  PdfColor _getPdfPriorityColor(String priority) {
    switch (priority) {
      case 'عالي':
        return PdfColors.red;
      case 'متوسط':
        return PdfColors.orange;
      case 'منخفض':
        return PdfColors.green;
      default:
        return PdfColors.grey;
    }
  }

  // ========== دوال الواجهة الرئيسية ==========

  Widget _buildCurrentView() {
    switch (_selectedTab) {
      case 0:
        return _buildDashboardView();
      case 1:
        return _buildDailyConsumptionView();
      case 2:
        return _buildMonthlyConsumptionView();
      case 3:
        return _buildReportsView();
      case 4:
        return _buildIncomingReportsView(); // التبويب الجديد للبلاغات
      default:
        return _buildDashboardView();
    }
  }

  Widget _buildSettingsView() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Container(
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                  )
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF5F5F5), Color(0xFFE6F3FF)],
                  ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSettingsSection('الإشعارات', Icons.notifications_rounded, themeProvider),
                _buildSettingSwitch(
                  'تفعيل الإشعارات',
                  'استلام إشعارات حول استهلاك المياه والإنذارات',
                  _notificationsEnabled,
                  (bool value) => setState(() => _notificationsEnabled = value),
                  themeProvider,
                ),
                _buildSettingSwitch(
                  'الصوت',
                  'تشغيل صوت للإشعارات الواردة',
                  _soundEnabled,
                  (bool value) => setState(() => _soundEnabled = value),
                  themeProvider,
                ),
                _buildSettingSwitch(
                  'الاهتزاز',
                  'اهتزاز الجهاز عند استلام الإشعارات',
                  _vibrationEnabled,
                  (bool value) => setState(() => _vibrationEnabled = value),
                  themeProvider,
                ),

                SizedBox(height: 24),
                _buildSettingsSection('المظهر', Icons.palette_rounded, themeProvider),
                
                _buildDarkModeSwitch(themeProvider),
                
                _buildSettingDropdown(
                  'اللغة',
                  _language,
                  _languages,
                  (String? value) => setState(() => _language = value!),
                  themeProvider,
                ),
                
                SizedBox(height: 24),
                _buildSettingsSection('حول التطبيق', Icons.info_rounded, themeProvider),
                _buildAboutCard(themeProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHelpView() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Container(
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                  )
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF5F5F5), Color(0xFFE6F3FF)],
                  ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactCard(),

                SizedBox(height: 24),

                _buildSectionTitle('الأسئلة الشائعة'),
                ..._buildFAQItems(),

                SizedBox(height: 24),
                _buildSectionTitle('معلومات التطبيق'),
                _buildAppInfoCard(),

                SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
  // استخدام القائمة المحسنة بدلاً من القديمة
  Widget _buildAreaFilter() {
    return _buildImprovedAreaFilter();
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        border: Border(
          bottom: BorderSide(color: _borderColor(context)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTabItem(0, Icons.dashboard, 'لوحة التحكم'),
            _buildTabItem(1, Icons.today_rounded, 'الاستهلاك اليومي'),
            _buildTabItem(2, Icons.calendar_month_rounded, 'الاستهلاك الشهري'),
            _buildTabItem(3, Icons.assignment, 'التقارير'),                  _buildTabItem(4, Icons.assignment_late_rounded, 'البلاغات'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String title) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? _primaryColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? _primaryColor : _textSecondaryColor(context),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? _primaryColor : _textColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardView() {
    final filteredData = _selectedArea == 'جميع المناطق'
        ? _waterConsumptionData
        : _waterConsumptionData.where((item) => item['area'] == _selectedArea).toList();

    final totalConsumption = filteredData.fold<double>(
      0,
      (sum, item) => sum + (item['currentConsumption'] as int).toDouble(),
    );
    final totalCustomers = filteredData.fold<int>(
      0,
      (sum, item) => sum + (item['customers'] as int),
    );
    final avgConsumption = totalCustomers > 0
        ? totalConsumption / totalCustomers
        : 0;
    final highConsumptionCount = filteredData.fold<int>(
      0,
      (sum, item) => sum + (item['highConsumptionCustomers'] as int),
    );
    final avgPressure = filteredData.fold<double>(
      0,
      (sum, item) => sum + (item['waterPressure'] as double),
    ) / (filteredData.length > 0 ? filteredData.length : 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedArea != 'جميع المناطق')
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _primaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: _primaryColor, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'عرض بيانات: $_selectedArea',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildStatCard(
                'إجمالي الاستهلاك',
                '${NumberFormat('#,###').format(totalConsumption)} م³',
                Icons.water_drop_rounded,
                _waterBlue,
              ),
              _buildStatCard(
                'متوسط الاستهلاك',
                '${avgConsumption.toStringAsFixed(1)} م³/عميل',
                Icons.show_chart,
                _accentColor,
              ),
              _buildStatCard(
                'عدد العملاء',
                NumberFormat('#,###').format(totalCustomers),
                Icons.people,
                _successColor,
              ),
              _buildStatCard(
                'عملاء استهلاك مرتفع',
                highConsumptionCount.toString(),
                Icons.warning,
                _warningColor,
              ),
              _buildStatCard(
                'متوسط ضغط المياه',
                '${avgPressure.toStringAsFixed(1)} بار',
                Icons.speed_rounded,
                _primaryColor,
              ),
              _buildStatCard(
                'إنذارات التسريبات',
                '${_waterAlertsData.where((a) => a['type'] == 'تسريب مياه').length}',
                Icons.plumbing_rounded,
                _errorColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildAreasPerformanceSection(filteredData),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 120,
        maxHeight: 140,
      ),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textColor(context),
                  fontFamily: 'Tajawal',
                  height: 0.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: _textSecondaryColor(context),
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  letterSpacing: 0.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreasPerformanceSection(List<Map<String, dynamic>> areasData) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.analytics, color: _primaryColor, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  'أداء المناطق-استهلاك المياه',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _textColor(context),
                  ),
                ),
                const Spacer(),
                if (_selectedArea != 'جميع المناطق')
                  Text(
                    'المنطقة: $_selectedArea',
                    style: TextStyle(
                      fontSize: 14,
                      color: _textSecondaryColor(context),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (areasData.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.area_chart, color: _textSecondaryColor(context), size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'لا توجد بيانات ${_selectedArea != 'جميع المناطق' ? 'للمنطقة $_selectedArea' : ''}',
                      style: TextStyle(color: _textSecondaryColor(context)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              Column(
                children: areasData.map((areaData) => _buildAreaPerformanceItem(areaData)).toList(),
              ),
          ],
        ),
      ),
    );
  }
    // ========== قسم البلاغات الواردة (التبويب الخامس) ==========
  
  // بيانات تجريبية للبلاغات الواردة للمياه
  final List<Map<String, dynamic>> _incomingWaterReports = [
    {
      'id': 'WTR-INC-2024-001',
      'title': 'بلاغ عطل في العدالة',
      'reporter': 'أحمد محمد',
      'phone': '07712345678',
      'area': 'حي الرياض',
      'address': 'شارع الملك فهد - بناء 12',
      'type': 'عطل فني',
      'priority': 'عالي',
      'status': 'جديد',
      'date': DateTime.now().subtract(Duration(hours: 2)),
      'description': 'عدالة المياه لا تعمل ولا يسجل الاستهلاك',
      'assignedTo': 'غير معين',
      'images': 2,
    },
    {
      'id': 'WTR-INC-2024-002',
      'title': 'استهلاك غير طبيعي',
      'reporter': 'سارة عبدالله',
      'phone': '07798765432',
      'area': 'حي النخيل',
      'address': 'شارع الزهور - فيلا 45',
      'type': 'استهلاك مرتفع',
      'priority': 'متوسط',
      'status': 'قيد المعالجة',
      'date': DateTime.now().subtract(Duration(days: 1)),
      'description': 'فواتير المياه مرتفعة بشكل غير طبيعي خلال الشهرين الماضيين',
      'assignedTo': 'مهندس صالح',
      'images': 1,
    },
    {
      'id': 'WTR-INC-2024-003',
      'title': 'تسريب مياه',
      'reporter': 'خالد العمري',
      'phone': '07755555555',
      'area': 'حي العليا',
      'address': 'شارع التخصصي - عمارة 8',
      'type': 'تسريب',
      'priority': 'عالي',
      'status': 'تمت المعالجة',
      'date': DateTime.now().subtract(Duration(days: 3)),
      'description': 'تسريب مياه من الأنبوب الرئيسي أمام العمارة',
      'assignedTo': 'فريق الصيانة',
      'images': 3,
    },
    {
      'id': 'WTR-INC-2024-004',
      'title': 'شكوى فاتورة',
      'reporter': 'فاطمة الزهراء',
      'phone': '07744444444',
      'area': 'حي الصفا',
      'address': 'شارع الأندلس - شقة 302',
      'type': 'شكوى',
      'priority': 'منخفض',
      'status': 'جديد',
      'date': DateTime.now().subtract(Duration(hours: 5)),
      'description': 'خطأ في قراءة العدالة والفاتورة مرتفعة',
      'assignedTo': 'غير معين',
      'images': 2,
    },
    {
      'id': 'WTR-INC-2024-005',
      'title': 'انقطاع المياه',
      'reporter': 'عبدالله السالم',
      'phone': '07733333333',
      'area': 'حي الرياض',
      'address': 'شارع البترجي - منزل 22',
      'type': 'انقطاع',
      'priority': 'عالي',
      'status': 'قيد المعالجة',
      'date': DateTime.now().subtract(Duration(hours: 8)),
      'description': 'انقطاع المياه عن الحي منذ الصباح',
      'assignedTo': 'فريق الطوارئ',
      'images': 0,
    },
    {
      'id': 'WTR-INC-2024-006',
      'title': 'جودة المياه',
      'reporter': 'محمد العلي',
      'phone': '07722222222',
      'area': 'حي النخيل',
      'address': 'شارع النخيل - مجمع 5',
      'type': 'جودة',
      'priority': 'متوسط',
      'status': 'جديد',
      'date': DateTime.now().subtract(Duration(hours: 12)),
      'description': 'لون المياه مائل للصفرة ورائحة غير طبيعية',
      'assignedTo': 'غير معين',
      'images': 2,
    },
  ];

  Widget _buildIncomingReportsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان الرئيسي
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.assignment_late_rounded, color: _primaryColor, size: 24),
              ),
              const SizedBox(width: 8),
              Text(
                'البلاغات الواردة',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'عرض وإدارة البلاغات المقدمة من المواطنين',
            style: TextStyle(
              color: _textSecondaryColor(context),
            ),
          ),
          const SizedBox(height: 20),

          // إحصائيات سريعة للبلاغات
          _buildIncomingStats(),

          const SizedBox(height: 20),

          // قائمة البلاغات
          _buildIncomingWaterReportsList(),
        ],
      ),
    );
  }

  Widget _buildIncomingStats() {
    int newCount = _incomingWaterReports.where((r) => r['status'] == 'جديد').length;
    int inProgressCount = _incomingWaterReports.where((r) => r['status'] == 'قيد المعالجة').length;
    int completedCount = _incomingWaterReports.where((r) => r['status'] == 'تمت المعالجة').length;
    int highPriorityCount = _incomingWaterReports.where((r) => r['priority'] == 'عالي').length;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCircle('جديد', newCount.toString(), _errorColor),
              _buildStatCircle('قيد المعالجة', inProgressCount.toString(), _warningColor),
              _buildStatCircle('منتهي', completedCount.toString(), _successColor),
              _buildStatCircle('عالي', highPriorityCount.toString(), _errorColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCircle(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _textSecondaryColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildIncomingWaterReportsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _incomingWaterReports.length,
      itemBuilder: (context, index) {
        final report = _incomingWaterReports[index];
        return _buildIncomingWaterReportCard(report);
      },
    );
  }

  Widget _buildIncomingWaterReportCard(Map<String, dynamic> report) {
    Color priorityColor = report['priority'] == 'عالي' ? _errorColor :
                         report['priority'] == 'متوسط' ? _warningColor : _successColor;
    
    Color statusColor = report['status'] == 'جديد' ? _errorColor :
                       report['status'] == 'قيد المعالجة' ? _warningColor : _successColor;

    // تحديد الأيقونة حسب نوع البلاغ
    IconData typeIcon;
    switch (report['type']) {
      case 'عطل فني':
        typeIcon = Icons.build_rounded;
        break;
      case 'تسريب':
        typeIcon = Icons.plumbing_rounded;
        break;
      case 'استهلاك مرتفع':
        typeIcon = Icons.trending_up_rounded;
        break;
      case 'انقطاع':
        typeIcon = Icons.water_damage_rounded;
        break;
      case 'جودة':
        typeIcon = Icons.science_rounded;
        break;
      case 'شكوى':
        typeIcon = Icons.feedback_rounded;
        break;
      default:
        typeIcon = Icons.report_problem_rounded;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showWaterReportDetails(report),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        typeIcon,
                        color: priorityColor,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: _textColor(context),
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.person_outline, size: 12, color: _textSecondaryColor(context)),
                              SizedBox(width: 4),
                              Text(
                                report['reporter'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _textSecondaryColor(context),
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.phone_outlined, size: 12, color: _textSecondaryColor(context)),
                              SizedBox(width: 4),
                              Text(
                                report['phone'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _textSecondaryColor(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: _textSecondaryColor(context)),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        report['address'],
                        style: TextStyle(
                          fontSize: 12,
                          color: _textSecondaryColor(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 8),
                
                Row(
                  children: [
                    Icon(Icons.description_outlined, size: 14, color: _textSecondaryColor(context)),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        report['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: _textSecondaryColor(context),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: priorityColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.priority_high_rounded,
                                size: 12,
                                color: priorityColor,
                              ),
                              SizedBox(width: 4),
                              Text(
                                report['priority'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: priorityColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: statusColor.withOpacity(0.3)),
                          ),
                          child: Text(
                            report['status'],
                            style: TextStyle(
                              fontSize: 10,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (report['images'] > 0) ...[
                          SizedBox(width: 8),
                          Row(
                            children: [
                              Icon(Icons.image_outlined, size: 12, color: _primaryColor),
                              SizedBox(width: 2),
                              Text(
                                '${report['images']}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 12, color: _textSecondaryColor(context)),
                        SizedBox(width: 4),
                        Text(
                          _getTimeAgo(report['date']),
                          style: TextStyle(
                            fontSize: 10,
                            color: _textSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                if (report['assignedTo'] != 'غير معين') ...[
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _backgroundColor(context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person_rounded, size: 14, color: _primaryColor),
                        SizedBox(width: 4),
                        Text(
                          'مسند إلى: ${report['assignedTo']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: _primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWaterReportDetails(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: _cardColor(context),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.report_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'تفاصيل البلاغ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWaterDetailSection('معلومات البلاغ', [
                      _buildWaterDetailRow('رقم البلاغ', report['id']),
                      _buildWaterDetailRow('العنوان', report['title']),
                      _buildWaterDetailRow('النوع', report['type']),
                      _buildWaterDetailRow('التاريخ', DateFormat('yyyy-MM-dd HH:mm').format(report['date'])),
                    ]),
                    
                    SizedBox(height: 16),
                    
                    _buildWaterDetailSection('معلومات المبلغ', [
                      _buildWaterDetailRow('الاسم', report['reporter']),
                      _buildWaterDetailRow('رقم الهاتف', report['phone']),
                      _buildWaterDetailRow('المنطقة', report['area']),
                      _buildWaterDetailRow('العنوان', report['address']),
                    ]),
                    
                    SizedBox(height: 16),
                    
                    _buildWaterDetailSection('تفاصيل البلاغ', [
                      _buildWaterDetailRow('الوصف', report['description'], isMultiline: true),
                      _buildWaterDetailRow('الأولوية', report['priority']),
                      _buildWaterDetailRow('الحالة', report['status']),
                      _buildWaterDetailRow('مسند إلى', report['assignedTo']),
                      if (report['images'] > 0)
                        _buildWaterDetailRow('المرفقات', '$report[images] صورة'),
                    ]),
                  ],
                ),
              ),
            ),
            
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardColor(context),
                border: Border(top: BorderSide(color: _borderColor(context))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _assignWaterReport(report);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('تسليم البلاغ'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _updateWaterReportStatus(report);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _successColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('تحديث الحالة'),
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

  Widget _buildWaterDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildWaterDetailRow(String label, String value, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label + ':',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _textSecondaryColor(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: _textColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _assignWaterReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: Text('تسليم البلاغ', style: TextStyle(color: _primaryColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('اختر الموظف لتسليم البلاغ إليه:'),
            SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'اختر الموظف',
              ),
              items: ['مهندس أحمد', 'فني محمد', 'مهندس سارة', 'فريق الصيانة', 'فريق الطوارئ']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar('تم تسليم البلاغ بنجاح');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('تسليم'),
          ),
        ],
      ),
    );
  }

  void _updateWaterReportStatus(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: Text('تحديث حالة البلاغ', style: TextStyle(color: _primaryColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('الحالة الحالية: ${report['status']}'),
            SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'الحالة الجديدة',
              ),
              value: report['status'],
              items: ['جديد', 'قيد المعالجة', 'تمت المعالجة', 'مغلق']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ملاحظات',
                hintText: 'أضف ملاحظات حول التحديث...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar('تم تحديث حالة البلاغ');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _successColor,
              foregroundColor: Colors.white,
            ),
            child: Text('تحديث'),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
  Widget _buildAreaPerformanceItem(Map<String, dynamic> areaData) {
    final isIncrease = areaData['changePercent'] > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor(context)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  areaData['area'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _textColor(context),
                  ),
                ),
                Text(
                  '${areaData['customers']} عميل',
                  style: TextStyle(fontSize: 12, color: _textSecondaryColor(context)),
                ),
                Row(
                  children: [
                    Icon(Icons.speed_rounded, size: 12, color: _primaryColor),
                    SizedBox(width: 4),
                    Text(
                      'ضغط: ${areaData['waterPressure'].toStringAsFixed(1)} بار',
                      style: TextStyle(fontSize: 10, color: _textSecondaryColor(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${NumberFormat('#,###').format(areaData['currentConsumption'])} م³',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _textColor(context),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14,
                    color: isIncrease ? _errorColor : _successColor,
                  ),
                  Text(
                    '${areaData['changePercent'].abs().toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: isIncrease ? _errorColor : _successColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========== قسم الاستهلاك اليومي للمياه ==========
  Widget _buildDailyConsumptionView() {
    final filteredData = _selectedArea == 'جميع المناطق'
        ? _dailyWaterData.where((item) => item['area'] == 'جميع المناطق').toList()
        : _dailyWaterData.where((item) => item['area'] == _selectedArea).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.water_drop_rounded, color: _primaryColor, size: 24),
              ),
              const SizedBox(width: 8),
              Text(
                'الاستهلاك اليومي للمياه',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'عرض وتحليل استهلاك المياه اليومي حسب المناطق',
            style: TextStyle(
              color: _textSecondaryColor(context),
            ),
          ),
          const SizedBox(height: 20),

          _buildDailyStatsSummary(),
          const SizedBox(height: 20),

          _buildCurrentDayConsumption(),
          const SizedBox(height: 20),

          _buildDailyConsumptionList(filteredData),
          const SizedBox(height: 20),

          _buildPeakHoursAnalysis(),
        ],
      ),
    );
  }

  Widget _buildDailyStatsSummary() {
    final today = DateTime.now();
    final todayData = _dailyWaterData.where(
      (item) => item['date'].year == today.year && 
                item['date'].month == today.month && 
                item['date'].day == today.day && 
                item['area'] == 'جميع المناطق'
    ).toList();

    final totalToday = todayData.isNotEmpty ? todayData.first['consumption'] : 442;
    final peakToday = todayData.isNotEmpty ? todayData.first['peakConsumption'] : 166;
    final leakagesToday = todayData.isNotEmpty ? todayData.first['leakageAlerts'] : 6;
    final avgPressure = todayData.isNotEmpty ? todayData.first['waterPressure'] : 3.4;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إحصائيات اليوم',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _textColor(context),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 12,
                    color: _primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDailyStatItem(
                'إجمالي الاستهلاك',
                '${NumberFormat('#,###').format(totalToday)}',
                'م³',
                Icons.water_drop_rounded,
                _waterBlue,
              ),
              _buildDailyStatItem(
                'ذروة الاستهلاك',
                '${NumberFormat('#,###').format(peakToday)}',
                'م³',
                Icons.trending_up_rounded,
                _warningColor,
              ),
              _buildDailyStatItem(
                'إنذارات التسريب',
                '$leakagesToday',
                'إنذار',
                Icons.plumbing_rounded,
                _errorColor,
              ),
              _buildDailyStatItem(
                'الضغط',
                '${avgPressure.toStringAsFixed(1)}',
                'بار',
                Icons.speed_rounded,
                _accentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyStatItem(String title, String value, String unit, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 12,
            color: _textSecondaryColor(context),
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentDayConsumption() {
    final today = DateTime.now();
    final areasData = _dailyWaterData.where(
      (item) => item['date'].year == today.year && 
                item['date'].month == today.month && 
                item['date'].day == today.day &&
                item['area'] != 'جميع المناطق'
    ).toList();

    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.water_drop_rounded, color: _primaryColor, size: 20),
                SizedBox(width: 8),
                Text(
                  'استهلاك المياه اليوم حسب المناطق',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _textColor(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...areasData.map((area) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      area['area'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _textColor(context),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: LinearProgressIndicator(
                      value: area['consumption'] / 200,
                      backgroundColor: _backgroundColor(context),
                      valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    '${NumberFormat('#,###').format(area['consumption'])}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _textColor(context),
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'م³',
                    style: TextStyle(
                      fontSize: 10,
                      color: _textSecondaryColor(context),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyConsumptionList(List<Map<String, dynamic>> data) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history_rounded, color: _primaryColor, size: 20),
                SizedBox(width: 8),
                Text(
                  'سجل الاستهلاك اليومي للمياه',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _textColor(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (data.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.inbox_rounded, color: _textSecondaryColor(context), size: 48),
                      SizedBox(height: 8),
                      Text(
                        'لا توجد بيانات',
                        style: TextStyle(color: _textSecondaryColor(context)),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...data.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat('dd').format(item['date']),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, yyyy-MM-dd').format(item['date']),
                            style: TextStyle(
                              fontWeight:FontWeight.w600,
                              color: _textColor(context),
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.warning_rounded, size: 12, color: _errorColor),
                              SizedBox(width: 4),
                              Text(
                                'تسريبات: ${item['leakageAlerts']}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _textSecondaryColor(context),
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.speed_rounded, size: 12, color: _primaryColor),
                              SizedBox(width: 4),
                              Text(
                                'ضغط: ${item['waterPressure'].toStringAsFixed(1)} بار',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _textSecondaryColor(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${NumberFormat('#,###').format(item['consumption'])}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _textColor(context),
                          ),
                        ),
                        Text(
                          'م³',
                          style: TextStyle(
                            fontSize: 10,
                            color: _textSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeakHoursAnalysis() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time_rounded, color: _primaryColor, size: 20),
                SizedBox(width: 8),
                Text(
                  'تحليل ساعات الذروة (استهلاك المياه)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _textColor(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _backgroundColor(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildPeakHourItem('6-9 صباحاً', 45, _warningColor),
                  SizedBox(height: 8),
                  _buildPeakHourItem('12-3 مساءً', 25, _accentColor),
                  SizedBox(height: 8),
                  _buildPeakHourItem('5-8 مساءً', 20, _successColor),
                  SizedBox(height: 8),
                  _buildPeakHourItem('10-5 صباحاً', 10, _primaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeakHourItem(String period, int percentage, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            period,
            style: TextStyle(
              fontSize: 12,
              color: _textColor(context),
            ),
          ),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: _backgroundColor(context),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 12),
        Text(
          '$percentage%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // ========== قسم الاستهلاك الشهري للمياه ==========
  Widget _buildMonthlyConsumptionView() {
    final filteredData = _selectedArea == 'جميع المناطق'
        ? _monthlyWaterData.where((item) => item['area'] == 'جميع المناطق').toList()
        : _monthlyWaterData.where((item) => item['area'] == _selectedArea).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.calendar_month_rounded, color: _primaryColor, size: 24),
              ),
              const SizedBox(width: 8),
              Text(
                'الاستهلاك الشهري للمياه',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'عرض وتحليل استهلاك المياه الشهري حسب المناطق',
            style: TextStyle(
              color: _textSecondaryColor(context),
            ),
          ),
          const SizedBox(height: 20),

          _buildMonthlyStatsSummary(),
          const SizedBox(height: 20),

          _buildMonthlyComparison(),
          const SizedBox(height: 20),

          _buildMonthlyConsumptionList(filteredData),
          const SizedBox(height: 20),

          _buildMonthlyAnalysis(),
        ],
      ),
    );
  }

  Widget _buildMonthlyStatsSummary() {
    final currentMonth = _monthlyWaterData.firstWhere(
      (item) => item['month'] == 'يناير 2024' && item['area'] == 'جميع المناطق',
      orElse: () => _monthlyWaterData[4],
    );

    final totalMonth = currentMonth['consumption'];
    final avgDaily = currentMonth['avgDaily'];
    final totalLeakages = currentMonth['totalLeakages'];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إحصائيات الشهر الحالي',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _textColor(context),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'يناير 2024',
                  style: TextStyle(
                    fontSize: 12,
                    color: _primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMonthlyStatItem(
                'إجمالي الشهر',
                '${NumberFormat('#,###').format(totalMonth)}',
                'م³',
                Icons.calendar_month_rounded,
                _waterBlue,
              ),
              _buildMonthlyStatItem(
                'المتوسط اليومي',
                '${NumberFormat('#,###').format(avgDaily)}',
                'م³',
                Icons.show_chart,
                _accentColor,
              ),
              _buildMonthlyStatItem(
                'إجمالي التسريبات',
                '$totalLeakages',
                'تسريب',
                Icons.plumbing_rounded,
                _errorColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyStatItem(String title, String value, String unit, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
          textAlign: TextAlign.center,
        ),
        if (unit.isNotEmpty)
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              color: _textSecondaryColor(context),
            ),
          ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMonthlyComparison() {
    final currentMonth = _monthlyWaterData.firstWhere(
      (item) => item['month'] == 'يناير 2024' && item['area'] == 'جميع المناطق',
      orElse: () => _monthlyWaterData[4],
    );

    final previousMonth = _monthlyWaterData.firstWhere(
      (item) => item['month'] == 'ديسمبر 2023' && item['area'] == 'جميع المناطق',
      orElse: () => _monthlyWaterData[4],
    );

    final changePercent = currentMonth['changePercent'];
    final isIncrease = changePercent > 0;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.compare_arrows_rounded, color: _primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                'مقارنة مع الشهر السابق',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _textColor(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'ديسمبر 2023',
                    style: TextStyle(
                      fontSize: 12,
                      color: _textSecondaryColor(context),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${NumberFormat('#,###').format(previousMonth['consumption'])}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textColor(context),
                    ),
                  ),
                  Text(
                    'م³',
                    style: TextStyle(
                      fontSize: 10,
                      color: _textSecondaryColor(context),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isIncrease ? _errorColor.withOpacity(0.1) : _successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isIncrease ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                      color: isIncrease ? _errorColor : _successColor,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${changePercent.abs().toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isIncrease ? _errorColor : _successColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    'يناير 2024',
                    style: TextStyle(
                      fontSize: 12,
                      color: _textSecondaryColor(context),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${NumberFormat('#,###').format(currentMonth['consumption'])}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textColor(context),
                    ),
                  ),
                  Text(
                    'م³',
                    style: TextStyle(
                      fontSize: 10,
                      color: _textSecondaryColor(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyConsumptionList(List<Map<String, dynamic>> data) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history_rounded, color: _primaryColor, size: 20),
                SizedBox(width: 8),
                Text(
                  'سجل الاستهلاك الشهري للمياه',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _textColor(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (data.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.inbox_rounded, color: _textSecondaryColor(context), size: 48),
                      SizedBox(height: 8),
                      Text(
                        'لا توجد بيانات',
                        style: TextStyle(color: _textSecondaryColor(context)),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...data.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          item['month'].split(' ')[0].substring(0, 3),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['month'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _textColor(context),
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.plumbing_rounded, size: 12, color: _errorColor),
                              SizedBox(width: 4),
                              Text(
                                'تسريبات: ${item['totalLeakages']}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _textSecondaryColor(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${NumberFormat('#,###').format(item['consumption'])}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _textColor(context),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              item['changePercent'] > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                              size: 12,
                              color: item['changePercent'] > 0 ? _errorColor : _successColor,
                            ),
                            Text(
                              '${item['changePercent'].abs().toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 10,
                                color: item['changePercent'] > 0 ? _errorColor : _successColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyAnalysis() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics_rounded, color: _primaryColor, size: 20),
                SizedBox(width: 8),
                Text(
                  'تحليل الأداء الشهري',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _textColor(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildAnalysisRow(
              'أعلى منطقة استهلاكاً',
              'حي العليا',
              '140,400 م³',
              Icons.water_drop_rounded,
              _warningColor,
            ),
            SizedBox(height: 8),
            _buildAnalysisRow(
              'أقل منطقة استهلاكاً',
              'حي الصفا',
              '64,800 م³',
              Icons.water_drop_rounded,
              _successColor,
            ),
            SizedBox(height: 8),
            _buildAnalysisRow(
              'أكثر منطقة تسريبات',
              'حي العليا',
              '22 تسريب',
              Icons.plumbing_rounded,
              _errorColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisRow(String label, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: _textSecondaryColor(context),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _textColor(context),
                  ),
                ),
              ],
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: _textSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  // ========== قسم التقارير ==========
  Widget _buildReportsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.assignment, color: _primaryColor, size: 24),
              ),
              const SizedBox(width: 8),
              Text(
                'نظام تقارير المياه',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: _cardColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor(context)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildReportInnerTabButton('إنشاء التقارير', 0),
                ),
                Expanded(
                  child: _buildReportInnerTabButton('التقارير الواردة', 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          _currentReportInnerTab == 0 
              ? _buildCreateReportSection()
              : _buildReceivedReportsSection(),
        ],
      ),
    );
  }

  Widget _buildReportInnerTabButton(String title, int tabIndex) {
    bool isSelected = _currentReportInnerTab == tabIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentReportInnerTab = tabIndex;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _primaryColor : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : _textColor(context),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateReportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إنشاء تقرير جديد',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'اختر نوع التقرير والفترة المطلوبة',
          style: TextStyle(
            color: _textSecondaryColor(context),
          ),
        ),
        const SizedBox(height: 20),
        _buildReportTypeFilter(),
        const SizedBox(height: 20),
        _buildReportOptions(),
        const SizedBox(height: 20),
        _buildGenerateReportButton(),
        const SizedBox(height: 20),
        
        _buildQuickStats(),
      ],
    );
  }

  Widget _buildReceivedReportsSection() {
    final List<Map<String, dynamic>> receivedReports = [
      {
        'id': 'REP-WTR-2024-001',
        'title': 'تقرير استهلاك المياه الشهري',
        'sender': 'قسم مراقبة المياه',
        'date': DateTime.now().subtract(Duration(days: 2)),
        'type': 'شهري',
        'size': '1.5 MB',
        'status': 'مستلم',
        'fileType': 'PDF',
        'area': 'جميع المناطق',
        'totalConsumption': 397800,
        'customersCount': 880,
        'leakageAlerts': 51,
      },
      {
        'id': 'REP-WTR-2024-002',
        'title': 'تقرير تسريبات المياه الأسبوعي',
        'sender': 'مكتب المدير العام',
        'date': DateTime.now().subtract(Duration(days: 5)),
        'type': 'أسبوعي',
        'size': '920 KB',
        'status': 'مستلم',
        'fileType': 'PDF',
        'area': 'المنطقة الشرقية',
        'totalConsumption': 18500,
        'customersCount': 350,
        'leakageAlerts': 12,
      },
      {
        'id': 'REP-WTR-2024-003',
        'title': 'تقرير استهلاك المياه اليومي',
        'sender': 'فرع بغداد',
        'date': DateTime.now().subtract(Duration(days: 1)),
        'type': 'يومي',
        'size': '520 KB',
        'status': 'غير مقروء',
        'fileType': 'Excel',
        'area': 'حي العليا',
        'totalConsumption': 4680,
        'customersCount': 300,
        'leakageAlerts': 22,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التقارير المستلمة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'عرض وإدارة جميع تقارير المياه التي تم استلامها',
          style: TextStyle(
            color: _textSecondaryColor(context),
          ),
        ),
        const SizedBox(height: 20),
        
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _backgroundColor(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor(context)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    receivedReports.length.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  Text(
                    'إجمالي التقارير',
                    style: TextStyle(
                      color: _textSecondaryColor(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    receivedReports.where((r) => r['status'] == 'غير مقروء').length.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _warningColor,
                    ),
                  ),
                  Text(
                    'غير مقروء',
                    style: TextStyle(
                      color: _textSecondaryColor(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${_calculateTotalSize(receivedReports)} MB',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _successColor,
                    ),
                  ),
                  Text(
                    'الحجم الإجمالي',
                    style: TextStyle(
                      color: _textSecondaryColor(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        ...receivedReports.map((report) => _buildReceivedReportCard(report)),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائيات سريعة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickStatItem('تقارير هذا الشهر', '7', Icons.calendar_today_rounded, _primaryColor),
              _buildQuickStatItem('إنذارات تسريب', '15', Icons.warning_rounded, _warningColor),
              _buildQuickStatItem('مناطق مغطاة', '5', Icons.location_on_rounded, _successColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getReportColor(String fileType) {
    switch (fileType) {
      case 'PDF':
        return _errorColor;
      case 'Excel':
        return _successColor;
      case 'Word':
        return _primaryColor;
      default:
        return _accentColor;
    }
  }

  IconData _getReportIcon(String fileType) {
    switch (fileType) {
      case 'PDF':
        return Icons.picture_as_pdf_rounded;
      case 'Excel':
        return Icons.table_chart_rounded;
      case 'Word':
        return Icons.description_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  String _calculateTotalSize(List<Map<String, dynamic>> reports) {
    double total = 0;
    for (var report in reports) {
      String sizeStr = report['size'];
      if (sizeStr.contains('MB')) {
        total += double.parse(sizeStr.replaceAll(' MB', ''));
      } else if (sizeStr.contains('KB')) {
        total += double.parse(sizeStr.replaceAll(' KB', '')) / 1024;
      }
    }
    return total.toStringAsFixed(1);
  }

  void _handleReportAction(String action, Map<String, dynamic> report) {
    switch (action) {
      case 'view':
        _viewReceivedReport(report);
        break;
      case 'download':
        _downloadReport(report);
        break;
      case 'analyze':
        _analyzeReport(report);
        break;
      case 'share':
        _shareReport(report);
        break;
      case 'delete':
        _deleteReport(report);
        break;
    }
  }

  void _viewReceivedReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: Row(
          children: [
            Icon(_getReportIcon(report['fileType']), color: _getReportColor(report['fileType'])),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                report['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _textColor(context),
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
              _buildReportDetailRow('المرسل:', report['sender']),
              _buildReportDetailRow('المنطقة:', report['area']),
              _buildReportDetailRow('النوع:', report['type']),
              _buildReportDetailRow('الحجم:', report['size']),
              _buildReportDetailRow('صيغة الملف:', report['fileType']),
              _buildReportDetailRow('التاريخ:', DateFormat('yyyy-MM-dd HH:mm').format(report['date'])),
              _buildReportDetailRow('الحالة:', report['status']),
              SizedBox(height: 16),
              Divider(color: _borderColor(context)),
              SizedBox(height: 16),
              Text(
                'ملخص البيانات:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              SizedBox(height: 8),
              _buildReportDetailRow('إجمالي الاستهلاك:', '${NumberFormat('#,###').format(report['totalConsumption'])} م³'),
              if (report['customersCount'] != null)
                _buildReportDetailRow('عدد العملاء:', '${NumberFormat('#,###').format(report['customersCount'])}'),
              if (report['leakageAlerts'] != null)
                _buildReportDetailRow('إنذارات تسريب:', '${report['leakageAlerts']} إنذار'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _downloadReport(report),
            child: Text('تحميل'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _analyzeReport(report),
            child: Text('تحليل'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _textSecondaryColor(context),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: _textColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل: ${report['title']}'),
        backgroundColor: _successColor,
      ),
    );
  }

  void _analyzeReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: Row(
          children: [
            Icon(Icons.analytics_rounded, color: _accentColor),
            SizedBox(width: 8),
            Text('تحليل البيانات'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تحليل تقرير ${report['title']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textColor(context),
              ),
            ),
            SizedBox(height: 16),
            _buildAnalysisItem('متوسط الاستهلاك:', '15.3 م³/عميل'),
            _buildAnalysisItem('أعلى منطقة:', 'حي العليا (4680 م³)'),
            _buildAnalysisItem('أدنى منطقة:', 'حي الصفا (2160 م³)'),
            _buildAnalysisItem('نسبة التغيير:', '+3.5% عن الفترة السابقة'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _shareReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('مشاركة: ${report['title']}'),
        backgroundColor: _primaryColor,
      ),
    );
  }

  Widget _buildAnalysisItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.chevron_right_rounded, size: 16, color: _primaryColor),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _textSecondaryColor(context),
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: _textColor(context),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: Row(
          children: [
            Icon(Icons.delete_rounded, color: _errorColor),
            SizedBox(width: 8),
            Text('حذف التقرير'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف تقرير "${report['title']}"؟',
          style: TextStyle(
            color: _textColor(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حذف التقرير: ${report['title']}'),
                  backgroundColor: _errorColor,
                ),
              );
            },
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedReportCard(Map<String, dynamic> report) {
    bool isUnread = report['status'] == 'غير مقروء';
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getReportColor(report['fileType']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getReportIcon(report['fileType']),
            color: _getReportColor(report['fileType']),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                report['title'],
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: _textColor(context),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _warningColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'من: ${report['sender']}',
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
              ),
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 12, color: _textSecondaryColor(context)),
                SizedBox(width: 4),
                Text(
                  report['area'],
                  style: TextStyle(
                    fontSize: 10,
                    color: _textSecondaryColor(context),
                  ),
                ),
                SizedBox(width: 12),
                Icon(Icons.water_drop_outlined, size: 12, color: _textSecondaryColor(context)),
                SizedBox(width: 4),
                Text(
                  '${NumberFormat('#,###').format(report['totalConsumption'])} م³',
                  style: TextStyle(
                    fontSize: 10,
                    color: _textSecondaryColor(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
            Text(
              '${DateFormat('yyyy-MM-dd').format(report['date'])} • ${report['type']} • ${report['size']}',
              style: TextStyle(
                fontSize: 10,
                color: _textSecondaryColor(context),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: _textSecondaryColor(context)),
          onSelected: (value) {
            _handleReportAction(value, report);
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility_rounded, size: 18, color: _primaryColor),
                  SizedBox(width: 8),
                  Text('عرض التقرير'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'download',
              child: Row(
                children: [
                  Icon(Icons.download_rounded, size: 18, color: _successColor),
                  SizedBox(width: 8),
                  Text('تحميل'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'analyze',
              child: Row(
                children: [
                  Icon(Icons.analytics_rounded, size: 18, color: _accentColor),
                  SizedBox(width: 8),
                  Text('تحليل البيانات'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share_rounded, size: 18, color: _secondaryColor),
                  SizedBox(width: 8),
                  Text('مشاركة'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_rounded, size: 18, color: _errorColor),
                  SizedBox(width: 8),
                  Text('حذف'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          _viewReceivedReport(report);
        },
      ),
    );
  }

  Widget _buildReportTypeFilter() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نوع التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor(context),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _reportTypes.map((type) {
                  final isSelected = _selectedReportType == type;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedReportType = type;
                          _selectedDates.clear();
                          _selectedWeek = null;
                          _selectedMonth = null;
                        });
                      },
                      selectedColor: _primaryColor.withOpacity(0.2),
                      checkmarkColor: _primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? _primaryColor : _textColor(context),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: isSelected ? _primaryColor : _borderColor(context)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportOptions() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'خيارات التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor(context),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedReportType == 'يومي') _buildDailyOptions(),
            if (_selectedReportType == 'أسبوعي') _buildWeeklyOptions(),
            if (_selectedReportType == 'شهري') _buildMonthlyOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyOptions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: _showMultiDatePicker,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 8),
              Text('فتح التقويم واختيار التواريخ'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        if (_selectedDates.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _primaryColor.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: _successColor),
                    SizedBox(width: 8),
                    Text(
                      'تم اختيار ${_selectedDates.length} يوم',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'من ${DateFormat('yyyy-MM-dd').format(_selectedDates.reduce((a, b) => a.isBefore(b) ? a : b))} '
                  'إلى ${DateFormat('yyyy-MM-dd').format(_selectedDates.reduce((a, b) => a.isAfter(b) ? a : b))}',
                  style: TextStyle(
                    color: _textSecondaryColor(context),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          Text(
            'التواريخ المحددة:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _textColor(context),
            ),
          ),
          SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 120),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedDates.map((date) {
                  return Chip(
                    backgroundColor: _primaryColor,
                    label: Text(
                      DateFormat('yyyy-MM-dd').format(date),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    deleteIcon: Icon(Icons.close, color: Colors.white, size: 16),
                    onDeleted: () {
                      setState(() {
                        _selectedDates.remove(date);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _backgroundColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor(context)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined, color: _textSecondaryColor(context), size: 48),
                SizedBox(height: 12),
                Text(
                  'لم يتم اختيار أي تواريخ',
                  style: TextStyle(
                    color: _textSecondaryColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'انقر على الزر أعلاه لفتح التقويم\nواختيار التواريخ المطلوبة للتقرير',
                  style: TextStyle(
                    color: _textSecondaryColor(context),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWeeklyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الأسبوع',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _weeks.map((week) {
            final isSelected = _selectedWeek == week;
            return FilterChip(
              label: Text(
                week,
                style: TextStyle(fontSize: 12),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedWeek = selected ? week : null;
                });
              },
              selectedColor: _primaryColor.withOpacity(0.2),
              checkmarkColor: _primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? _primaryColor : _textColor(context),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : _borderColor(context)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonthlyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الشهر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _months.map((month) {
            final isSelected = _selectedMonth == month;
            return FilterChip(
              label: Text(
                month,
                style: TextStyle(fontSize: 12),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedMonth = selected ? month : null;
                });
              },
              selectedColor: _primaryColor.withOpacity(0.2),
              checkmarkColor: _primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? _primaryColor : _textColor(context),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : _borderColor(context)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenerateReportButton() {
    bool isFormValid = false;
    
    switch (_selectedReportType) {
      case 'يومي':
        isFormValid = _selectedDates.isNotEmpty;
        break;
      case 'أسبوعي':
        isFormValid = _selectedWeek != null;
        break;
      case 'شهري':
        isFormValid = _selectedMonth != null;
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isFormValid ? _generateReport : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid ? _primaryColor : _textSecondaryColor(context),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.summarize),
            const SizedBox(width: 8),
            Text(
              'إنشاء التقرير ${_selectedReportType == 'يومي' && _selectedDates.isNotEmpty ? '(${_selectedDates.length} يوم)' : ''}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // ========== دوال مساعدة ==========

  void _showGeneratedReport(String period) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: Text('التقرير $period', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('نوع التقرير: $_selectedReportType', style: TextStyle(color: _textColor(context))),
              if (_selectedReportType == 'يومي' && _selectedDates.isNotEmpty)
                Text('عدد الأيام: ${_selectedDates.length}', style: TextStyle(color: _textColor(context))),
              if (_selectedWeek != null)
                Text('الأسبوع: $_selectedWeek', style: TextStyle(color: _textColor(context))),
              if (_selectedMonth != null)
                Text('الشهر: $_selectedMonth', style: TextStyle(color: _textColor(context))),
              const SizedBox(height: 16),
              Text('ملخص التقرير:', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              Text('- إجمالي الاستهلاك: 397,800 م³', style: TextStyle(color: _textColor(context))),
              Text('- عدد العملاء: 880', style: TextStyle(color: _textColor(context))),
              Text('- متوسط الاستهلاك: 15.1 م³/عميل', style: TextStyle(color: _textColor(context))),
              Text('- عدد إنذارات التسريب: 51', style: TextStyle(color: _textColor(context))),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _textSecondaryColor(context))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _generatePdfReport(period);
            },
            child: const Text('تصدير PDF'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredAlerts() {
    if (_selectedArea == 'جميع المناطق') {
      return _waterAlertsData;
    }
    return _waterAlertsData.where((alert) => alert['area'] == _selectedArea).toList();
  }

  void _handleAlert(int index) {
    setState(() {
      _waterAlertsData[index]['status'] = 'تحت المراجعة';
    });
    _showSuccessSnackbar('تم معالجة إنذار ${_waterAlertsData[index]['customer']}');
  }

  void _toggleDateSelection(DateTime date) {
    final dateToToggle = DateTime(date.year, date.month, date.day);
    
    setState(() {
      if (_selectedDates.any((selectedDate) =>
          selectedDate.year == dateToToggle.year &&
          selectedDate.month == dateToToggle.month &&
          selectedDate.day == dateToToggle.day)) {
        _selectedDates.removeWhere((selectedDate) =>
            selectedDate.year == dateToToggle.year &&
            selectedDate.month == dateToToggle.month &&
            selectedDate.day == dateToToggle.day);
      } else {
        _selectedDates.add(dateToToggle);
      }
      
      _selectedDates.sort((a, b) => a.compareTo(b));
    });
  }

  void _showMultiDatePicker() {
    List<DateTime> tempSelectedDates = List.from(_selectedDates);

    showDialog(
      context: context,
      builder: (context) {
        DateTime focusedDay = DateTime.now();
        
        return Dialog(
          backgroundColor: _cardColor(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'اختر التواريخ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      if (tempSelectedDates.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${tempSelectedDates.length} يوم',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _borderColor(context)),
                            ),
                            child: TableCalendar(
                              firstDay: DateTime.utc(2020, 1, 1),
                              lastDay: DateTime.utc(2030, 12, 31),
                              focusedDay: focusedDay,
                              selectedDayPredicate: (day) {
                                return tempSelectedDates.any((selectedDate) {
                                  return isSameDay(selectedDate, day);
                                });
                              },
                              onDaySelected: (selectedDay, focused) {
                                focusedDay = focused;
                                
                                if (tempSelectedDates.any((date) => isSameDay(date, selectedDay))) {
                                  tempSelectedDates.removeWhere((date) => isSameDay(date, selectedDay));
                                } else {
                                  tempSelectedDates.add(DateTime(selectedDay.year, selectedDay.month, selectedDay.day));
                                }
                                
                                tempSelectedDates.sort((a, b) => a.compareTo(b));
                                (context as Element).markNeedsBuild();
                              },
                              calendarStyle: CalendarStyle(
                                defaultTextStyle: TextStyle(color: _textColor(context)),
                                todayTextStyle: TextStyle(
                                  color: _textColor(context),
                                  fontWeight: FontWeight.bold,
                                ),
                                selectedTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                todayDecoration: BoxDecoration(
                                  color: _accentColor.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: _primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: TextStyle(
                                  color: _primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                leftChevronIcon: Icon(Icons.chevron_left, color: _primaryColor),
                                rightChevronIcon: Icon(Icons.chevron_right, color: _primaryColor),
                                headerPadding: EdgeInsets.symmetric(vertical: 8),
                                headerMargin: EdgeInsets.only(bottom: 8),
                              ),
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekdayStyle: TextStyle(
                                  color: _textColor(context),
                                  fontWeight: FontWeight.w600,
                                ),
                                weekendStyle: TextStyle(
                                  color: _errorColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              daysOfWeekHeight: 30,
                              weekendDays: [DateTime.friday, DateTime.saturday],
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          if (tempSelectedDates.isNotEmpty)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _backgroundColor(context),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _borderColor(context)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.date_range_rounded, color: _primaryColor, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'التواريخ المختارة',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _primaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: tempSelectedDates.map((date) {
                                      return Chip(
                                        backgroundColor: _primaryColor,
                                        label: Text(
                                          DateFormat('yyyy-MM-dd').format(date),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        deleteIcon: Icon(Icons.close, color: Colors.white, size: 16),
                                        onDeleted: () {
                                          tempSelectedDates.remove(date);
                                          (context as Element).markNeedsBuild();
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  if (tempSelectedDates.length > 1)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Text(
                                        'من ${DateFormat('yyyy-MM-dd').format(tempSelectedDates.first)} '
                                        'إلى ${DateFormat('yyyy-MM-dd').format(tempSelectedDates.last)} '
                                        '(${tempSelectedDates.length} يوم)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _textSecondaryColor(context),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          
                          if (tempSelectedDates.isEmpty)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _backgroundColor(context),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _borderColor(context)),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.touch_app_rounded, 
                                       size: 40, 
                                       color: _textSecondaryColor(context)),
                                  SizedBox(height: 12),
                                  Text(
                                    'انقر على الأيام في التقويم',
                                    style: TextStyle(
                                      color: _textColor(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'اختر الأيام المطلوبة للتقرير',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _textSecondaryColor(context),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: _borderColor(context))),
                    color: _cardColor(context),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _errorColor,
                            side: BorderSide(color: _errorColor),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('إلغاء'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedDates = List.from(tempSelectedDates);
                            });
                            Navigator.pop(context);
                            _showSuccessSnackbar('تم اختيار ${_selectedDates.length} يوم');
                          },
                          child: Text('تم الاختيار'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _generateReport() {
    if (_selectedReportType == 'يومي' && _selectedDates.isEmpty) {
      _showErrorSnackbar('يرجى اختيار تواريخ أولاً');
      return;
    }

    String reportPeriod = '';
    
    switch (_selectedReportType) {
      case 'يومي':
        if (_selectedDates.isNotEmpty) {
          final sortedDates = List<DateTime>.from(_selectedDates)..sort();
          if (_selectedDates.length == 1) {
            reportPeriod = DateFormat('yyyy-MM-dd').format(_selectedDates.first);
          } else {
            reportPeriod = '${DateFormat('yyyy-MM-dd').format(sortedDates.first)} إلى ${DateFormat('yyyy-MM-dd').format(sortedDates.last)}';
          }
        }
        break;
      case 'أسبوعي':
        reportPeriod = _selectedWeek ?? 'غير محدد';
        break;
      case 'شهري':
        reportPeriod = _selectedMonth ?? 'غير محدد';
        break;
    }

    _showSuccessSnackbar('تم إنشاء التقرير بنجاح');
    _showGeneratedReport(reportPeriod);
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _successColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _errorColor,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عالي':
        return _errorColor;
      case 'متوسط':
        return _warningColor;
      case 'منخفض':
        return _successColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'غير معالج':
        return _errorColor.withOpacity(0.1);
      case 'تحت المراجعة':
        return _warningColor.withOpacity(0.1);
      case 'مغلق':
        return _successColor.withOpacity(0.1);
      default:
        return _backgroundColor(context);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'غير معالج':
        return _errorColor;
      case 'تحت المراجعة':
        return _warningColor;
      case 'مغلق':
        return _successColor;
      default:
        return _textColor(context);
    }
  }

  void _showNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WaterMonitoringNotificationsScreen()),
    );
  }

  @override
Widget build(BuildContext context) {
  // غيّر هذا السطر ليشمل التبويب الرابع (البلاغات) أيضاً
  bool isMainPage = _selectedTab >= 0 && _selectedTab <= 4; // كان 3 والآن 4
  bool showTabs = isMainPage; // إظهار التبويبات في الصفحات الرئيسية والبلاغات

  return Scaffold(
    backgroundColor: _backgroundColor(context),
    appBar: AppBar(
      title: Text(
        _selectedTab == 4 ? 'البلاغات الواردة' : // أضف هذا الشرط
        _selectedTab == 5 ? 'المساعدة' : 
        'مراقبة استهلاك المياه'
      ),
      backgroundColor: _primaryColor,
      elevation: 2,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_gradientStart(context), _gradientEnd(context)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
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
                    '3',
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
          onPressed: _showNotifications,
        ),
      ],
    ),
    drawer: _buildDrawer(context),
    body: Column(
      children: [
        // إظهار التبويبات فقط في الصفحات الرئيسية (0,1,2,3)
        if (showTabs) ...[
          _buildTabBar(),
          // إظهار فلتر المنطقة فقط في الصفحات الرئيسية (0,1,2)
          if (_selectedTab == 0 || _selectedTab == 1 || _selectedTab == 2) 
            _buildAreaFilter(),
        ],
        // المحتوى الرئيسي
        Expanded(child: _buildCurrentView()),
      ],
    ),
  );
}

  // تعديل دالة _buildDrawer في شاشة المياه
Widget _buildDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: _cardColor(context),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_gradientStart(context), _gradientEnd(context)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(Icons.person, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                'سالم العلي',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'مراقب مياه - المنطقة الشرقية',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        // قسم الإعدادات
        _buildDrawerItem(
          context,
          index: 4, // إعدادات
          icon: Icons.settings,
          title: 'الإعدادات',
          isSelected: _selectedTab == 4,
        ),
        
        // تسجيل الخروج
        ListTile(
          leading: Icon(Icons.exit_to_app, color: _errorColor),
          title: Text('تسجيل الخروج', style: TextStyle(color: _textColor(context))),
          onTap: () {
            _logout(context);
          },
        ),
      ],
    ),
  );
}

// دالة مساعدة لبناء عناصر القائمة
Widget _buildDrawerItem(
  BuildContext context, {
  required int index,
  required IconData icon,
  required String title,
  required bool isSelected,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      border: isSelected ? Border.all(color: _primaryColor.withOpacity(0.3)) : null,
    ),
    child: ListTile(
      leading: Icon(icon, color: isSelected ? _primaryColor : _textSecondaryColor(context)),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? _primaryColor : _textColor(context),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
        Navigator.pop(context);
      },
    ),
  );
}

// دالة تسجيل الخروج
void _logout(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.logout, color: _errorColor),
          SizedBox(width: 8),
          Text('تسجيل الخروج', style: TextStyle(color: _textColor(context))),
        ],
      ),
      content: Text(
        'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
        style: TextStyle(color: _textColor(context)),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor(context))),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              'esignin_screen',
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _errorColor,
            foregroundColor: Colors.white,
          ),
          child: Text('تسجيل الخروج'),
        ),
      ],
    ),
  );
}
}
// شاشة الإشعارات للمياه
class WaterMonitoringNotificationsScreen extends StatefulWidget {
  static const String routeName = '/water-monitoring-notifications';

  @override
  _WaterMonitoringNotificationsScreenState createState() => _WaterMonitoringNotificationsScreenState();
}

class _WaterMonitoringNotificationsScreenState extends State<WaterMonitoringNotificationsScreen> {
  final Color _primaryColor = const Color(0xFF0066B3);
  final Color _secondaryColor = const Color(0xFF003366);
  final Color _successColor = const Color(0xFF28A745);
  final Color _warningColor = const Color(0xFFFFC107);
  final Color _errorColor = const Color(0xFFDC3545);
  final Color _accentColor = const Color(0xFF00A8E8); // تم إضافة هذا اللون

  
  Color _backgroundColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF121212) : const Color(0xFFE6F3FF);
  }
  
  Color _cardColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  }
  
  Color _textColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white : const Color(0xFF1A2E35);
  }
  
  Color _textSecondaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF5A6C7D);
  }
  
  Color _borderColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF333333) : const Color(0xFFB8D8F0);
  }

  int _selectedTab = 0;
  final List<String> _tabs = ['الإنذارات', 'التقارير', 'الاستهلاك', 'الكل'];

  final List<Map<String, dynamic>> _allNotifications = [
    {
      'id': '1',
      'type': 'استهلاك مرتفع',
      'title': 'إنذار استهلاك مياه مرتفع',
      'description': 'المواطن أحمد محمد في حي العليا سجل استهلاكاً مرتفعاً بنسبة 89%',
      'time': 'منذ 5 دقائق',
      'read': false,
      'tab': 0,
      'priority': 'عالي',
      'area': 'حي العليا',
      'customer': 'أحمد محمد',
      'consumption': 85,
      'average': 45,
    },
    {
      'id': '2',
      'type': 'تسريب مياه',
      'title': 'تم اكتشاف تسريب مياه',
      'description': 'تم اكتشاف تسريب مياه في شارع الملك فهد - حي الرياض',
      'time': 'منذ ساعة',
      'read': false,
      'tab': 0,
      'priority': 'عالي',
      'area': 'حي الرياض',
      'customer': 'منطقة عامة',
      'leakageLocation': 'شارع الملك فهد',
      'leakageSeverity': 'متوسط',
    },
    {
      'id': '3',
      'type': 'انخفاض الضغط',
      'title': 'انخفاض ضغط المياه',
      'description': 'انخفاض ضغط المياه في حي النخيل - مستشفى النخيل',
      'time': 'منذ 3 ساعات',
      'read': true,
      'tab': 0,
      'priority': 'متوسط',
      'area': 'حي النخيل',
      'customer': 'مستشفى النخيل',
      'pressure': 1.8,
      'normalPressure': 3.5,
    },
    {
      'id': '4',
      'type': 'تقرير استهلاك',
      'title': 'تقرير استهلاك المياه الشهري جاهز',
      'description': 'تم إنشاء تقرير استهلاك المياه لشهر يناير 2024 بنجاح',
      'time': 'منذ يوم',
      'read': true,
      'tab': 1,
      'priority': 'منخفض',
      'area': 'جميع المناطق',
      'reportType': 'شهري',
      'reportSize': '2.5 MB',
    },
    {
      'id': '5',
      'type': 'تقرير تسريبات',
      'title': 'تقرير التسريبات الأسبوعي',
      'description': 'تم إنشاء تقرير تسريبات المياه للأسبوع الحالي - 15 تسريب جديد',
      'time': 'منذ يومين',
      'read': true,
      'tab': 1,
      'priority': 'متوسط',
      'area': 'المنطقة الشرقية',
      'reportType': 'أسبوعي',
      'reportSize': '1.2 MB',
      'leakages': 15,
    },
    {
      'id': '6',
      'type': 'زيادة استهلاك',
      'title': 'زيادة في استهلاك المياه',
      'description': 'سجلت المنطقة الشرقية زيادة في استهلاك المياه بنسبة 12% هذا الأسبوع',
      'time': 'منذ 30 دقيقة',
      'read': false,
      'tab': 2,
      'priority': 'متوسط',
      'area': 'المنطقة الشرقية',
      'increasePercent': 12,
      'currentConsumption': 4250,
      'previousConsumption': 3795,
    },
    {
      'id': '7',
      'type': 'صيانة مجدولة',
      'title': 'صيانة شبكة المياه',
      'description': 'صيانة مجدولة لشبكة المياه في حي الصفا يوم الجمعة من 8ص - 2م',
      'time': 'منذ 5 ساعات',
      'read': true,
      'tab': 2,
      'priority': 'منخفض',
      'area': 'حي الصفا',
      'maintenanceDate': 'الجمعة 2024-01-20',
      'maintenanceDuration': '6 ساعات',
    },
    {
      'id': '8',
      'type': 'جودة المياه',
      'title': 'فحص جودة المياه',
      'description': 'نتائج فحص جودة المياه في حي الرياض مطابقة للمواصفات',
      'time': 'منذ يوم',
      'read': true,
      'tab': 2,
      'priority': 'منخفض',
      'area': 'حي الرياض',
      'chlorine': '0.5 mg/L',
      'turbidity': '1.2 NTU',
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedTab == 3) {
      return _allNotifications;
    }
    return _allNotifications.where((notification) => notification['tab'] == _selectedTab).toList();
  }

  int get _unreadCount {
    return _allNotifications.where((n) => n['read'] == false).length;
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _allNotifications.indexWhere((n) => n['id'] == id);
      if (index != -1) {
        _allNotifications[index]['read'] = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        notification['read'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحديد الكل كمقروء'),
        backgroundColor: _successColor,
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عالي':
        return _errorColor;
      case 'متوسط':
        return _warningColor;
      case 'منخفض':
        return _successColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'استهلاك مرتفع':
        return Icons.trending_up_rounded;
      case 'تسريب مياه':
        return Icons.plumbing_rounded;
      case 'انخفاض الضغط':
        return Icons.speed_rounded;
      case 'تقرير استهلاك':
      case 'تقرير تسريبات':
        return Icons.assignment_rounded;
      case 'زيادة استهلاك':
        return Icons.analytics_rounded;
      case 'صيانة مجدولة':
        return Icons.build_rounded;
      case 'جودة المياه':
        return Icons.science_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'استهلاك مرتفع':
        return _errorColor;
      case 'تسريب مياه':
        return _errorColor;
      case 'انخفاض الضغط':
        return _warningColor;
      case 'تقرير استهلاك':
      case 'تقرير تسريبات':
        return _primaryColor;
      case 'زيادة استهلاك':
        return _warningColor;
      case 'صيانة مجدولة':
        return _accentColor;
      case 'جودة المياه':
        return _successColor;
      default:
        return _primaryColor;
    }
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    _markAsRead(notification['id']);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getNotificationColor(notification['type']).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getNotificationIcon(notification['type']),
                color: _getNotificationColor(notification['type']),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _textColor(context),
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
                  color: _textColor(context),
                ),
              ),
              SizedBox(height: 16),
              Divider(color: _borderColor(context)),
              SizedBox(height: 16),
              _buildDetailRow('المنطقة:', notification['area']),
              if (notification['customer'] != null)
                _buildDetailRow('العميل:', notification['customer']),
              if (notification['priority'] != null)
                _buildDetailRow('الأولوية:', notification['priority'],
                  valueColor: _getPriorityColor(notification['priority']),
                ),
              _buildDetailRow('الوقت:', notification['time']),
              
              if (notification['consumption'] != null) ...[
                SizedBox(height: 8),
                Text('تفاصيل إضافية:', style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor)),
                SizedBox(height: 4),
                _buildDetailRow('الاستهلاك:', '${notification['consumption']} م³'),
                if (notification['average'] != null)
                  _buildDetailRow('المتوسط:', '${notification['average']} م³'),
              ],
              
              if (notification['leakageLocation'] != null) ...[
                SizedBox(height: 8),
                Text('تفاصيل التسريب:', style: TextStyle(fontWeight: FontWeight.bold, color: _errorColor)),
                SizedBox(height: 4),
                _buildDetailRow('الموقع:', notification['leakageLocation']),
                if (notification['leakageSeverity'] != null)
                  _buildDetailRow('الشدة:', notification['leakageSeverity']),
              ],
              
              if (notification['pressure'] != null) ...[
                SizedBox(height: 8),
                Text('تفاصيل الضغط:', style: TextStyle(fontWeight: FontWeight.bold, color: _warningColor)),
                SizedBox(height: 4),
                _buildDetailRow('الضغط الحالي:', '${notification['pressure']} بار'),
                if (notification['normalPressure'] != null)
                  _buildDetailRow('الضغط الطبيعي:', '${notification['normalPressure']} بار'),
              ],
              
              if (notification['reportType'] != null) ...[
                SizedBox(height: 8),
                Text('تفاصيل التقرير:', style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor)),
                SizedBox(height: 4),
                _buildDetailRow('نوع التقرير:', notification['reportType']),
                if (notification['reportSize'] != null)
                  _buildDetailRow('الحجم:', notification['reportSize']),
                if (notification['leakages'] != null)
                  _buildDetailRow('عدد التسريبات:', '${notification['leakages']}'),
              ],
              
              if (notification['increasePercent'] != null) ...[
                SizedBox(height: 8),
                Text('تحليل الاستهلاك:', style: TextStyle(fontWeight: FontWeight.bold, color: _warningColor)),
                SizedBox(height: 4),
                _buildDetailRow('نسبة الزيادة:', '${notification['increasePercent']}%',
                  valueColor: notification['increasePercent'] > 0 ? _errorColor : _successColor,
                ),
                if (notification['currentConsumption'] != null)
                  _buildDetailRow('الاستهلاك الحالي:', '${notification['currentConsumption']} م³'),
                if (notification['previousConsumption'] != null)
                  _buildDetailRow('الاستهلاك السابق:', '${notification['previousConsumption']} م³'),
              ],
              
              if (notification['maintenanceDate'] != null) ...[
                SizedBox(height: 8),
                Text('تفاصيل الصيانة:', style: TextStyle(fontWeight: FontWeight.bold, color: _accentColor)),
                SizedBox(height: 4),
                _buildDetailRow('التاريخ:', notification['maintenanceDate']),
                if (notification['maintenanceDuration'] != null)
                  _buildDetailRow('المدة:', notification['maintenanceDuration']),
              ],
              
              if (notification['chlorine'] != null) ...[
                SizedBox(height: 8),
                Text('جودة المياه:', style: TextStyle(fontWeight: FontWeight.bold, color: _successColor)),
                SizedBox(height: 4),
                _buildDetailRow('الكلور:', notification['chlorine']),
                if (notification['turbidity'] != null)
                  _buildDetailRow('العكورة:', notification['turbidity']),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _textSecondaryColor(context))),
          ),
          if (!notification['read'])
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _successColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _markAsRead(notification['id']);
                Navigator.pop(context);
              },
              child: Text('تحديد كمقروء'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _textSecondaryColor(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? _textColor(context),
                fontWeight: valueColor != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor(context),
      appBar: AppBar(
        title: Text(
          'إشعارات المياه',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_unreadCount > 0)
            IconButton(
              icon: Icon(Icons.done_all_rounded, color: Colors.white),
              onPressed: _markAllAsRead,
              tooltip: 'تحديد الكل كمقروء',
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: _cardColor(context),
              border: Border(
                bottom: BorderSide(color: _borderColor(context)),
              ),
            ),
            child: Row(
              children: [
                for (int i = 0; i < _tabs.length; i++)
                  _buildTabButton(_tabs[i], i),
              ],
            ),
          ),

          Container(
            height: 1,
            color: _borderColor(context),
          ),

          // إحصائية سريعة
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: _cardColor(context),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.notifications_rounded, color: _primaryColor, size: 20),
                ),
                SizedBox(width: 12),
                Text(
                  'لديك ${_filteredNotifications.length} إشعار',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor(context),
                  ),
                ),
                if (_unreadCount > 0) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _errorColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_unreadCount غير مقروء',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                Spacer(),
                Icon(Icons.swipe_rounded, color: _textSecondaryColor(context), size: 18),
                SizedBox(width: 4),
                Text(
                  'اسحب للتفاصيل',
                  style: TextStyle(
                    fontSize: 10,
                    color: _textSecondaryColor(context),
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 1,
            color: _borderColor(context),
          ),

          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return Dismissible(
                        key: Key(notification['id']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: _successColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.done_all_rounded, color: _successColor),
                              SizedBox(width: 8),
                              Text(
                                'تحديد كمقروء',
                                style: TextStyle(
                                  color: _successColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          _markAsRead(notification['id']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم تحديد الإشعار كمقروء'),
                              backgroundColor: _successColor,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: _buildNotificationCard(notification),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTab == index;
    int count = _allNotifications.where((n) => n['tab'] == index && n['read'] == false).length;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? _secondaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isSelected ? _primaryColor : _textSecondaryColor(context),
                  ),
                ),
                if (count > 0)
                  Positioned(
                    left: -10,
                    top: -8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _errorColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        count.toString(),
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
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    bool isUnread = !notification['read'];
    Color notificationColor = _getNotificationColor(notification['type']);
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUnread ? notificationColor.withOpacity(0.05) : _cardColor(context),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // أيقونة الإشعار
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: notificationColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(notification['type']),
                  color: notificationColor,
                  size: 24,
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
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                              fontSize: 16,
                              color: _textColor(context),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(notification['priority']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            notification['priority'],
                            style: TextStyle(
                              fontSize: 10,
                              color: _getPriorityColor(notification['priority']),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      notification['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: _textSecondaryColor(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: _textSecondaryColor(context)),
                        SizedBox(width: 4),
                        Text(
                          notification['area'],
                          style: TextStyle(
                            fontSize: 12,
                            color: _textSecondaryColor(context),
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.access_time_rounded, size: 14, color: _textSecondaryColor(context)),
                        SizedBox(width: 4),
                        Text(
                          notification['time'],
                          style: TextStyle(
                            fontSize: 12,
                            color: _textSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // علامة غير مقروء
              if (isUnread)
                Container(
                  width: 10,
                  height: 10,
                  margin: EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: notificationColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
        
        Container(
          height: 1,
          color: _borderColor(context),
          margin: EdgeInsets.symmetric(horizontal: 16),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_rounded,
              size: 64,
              color: _primaryColor.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 20,
              color: _textColor(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _selectedTab == 3 
                ? 'ليس لديك أي إشعارات حالياً'
                : 'لا توجد إشعارات في هذا القسم',
            style: TextStyle(
              fontSize: 16,
              color: _textSecondaryColor(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

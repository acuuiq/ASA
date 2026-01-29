
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
  Color get _primaryColor => const Color(0xFF006699); // أزرق مائي
  Color get _secondaryColor => const Color(0xFF004466);
  Color get _accentColor => const Color(0xFF00B4D8); // أزرق فاتح مائي
  Color get _successColor => const Color(0xFF28A745);
  Color get _warningColor => const Color(0xFFFFC107);
  Color get _errorColor => const Color(0xFFDC3545);
  Color get _waterBlue => const Color(0xFF0077B6); // أزرق مائي
  
  // ألوان ديناميكية تعتمد على الوضع المظلم
  Color _backgroundColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF121212) : const Color(0xFFE6F7FF);
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
    return themeProvider.isDarkMode ? const Color(0xFF333333) : const Color(0xFFC2E7FF);
  }
  
  Color _gradientStart(BuildContext context) => _primaryColor;
  Color _gradientEnd(BuildContext context) => _secondaryColor;
  Color _buttonColor(BuildContext context) => _primaryColor;
  Color _buttonHoverColor(BuildContext context) => const Color(0xFF005580);

  int _selectedTab = 0;
  String _selectedArea = 'جميع المناطق';
  String _selectedReportType = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;

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
  final List<Map<String, dynamic>> _consumptionData = [
    {
      'area': 'حي الرياض',
      'currentConsumption': 125000,
      'previousConsumption': 118000,
      'changePercent': 5.9,
      'customers': 250,
      'avgConsumption': 500,
      'trend': 'up',
      'highConsumptionCustomers': 15,
    },
    {
      'area': 'حي النخيل',
      'currentConsumption': 89000,
      'previousConsumption': 92000,
      'changePercent': -3.3,
      'customers': 180,
      'avgConsumption': 494,
      'trend': 'down',
      'highConsumptionCustomers': 8,
    },
    {
      'area': 'حي العليا',
      'currentConsumption': 156000,
      'previousConsumption': 148000,
      'changePercent': 5.4,
      'customers': 300,
      'avgConsumption': 520,
      'trend': 'up',
      'highConsumptionCustomers': 25,
    },
    {
      'area': 'حي الصفا',
      'currentConsumption': 72000,
      'previousConsumption': 75000,
      'changePercent': -4.0,
      'customers': 150,
      'avgConsumption': 480,
      'trend': 'down',
      'highConsumptionCustomers': 5,
    },
  ];

  final List<Map<String, dynamic>> _highConsumptionCustomers = [
    {
      'name': 'أحمد محمد',
      'accountNumber': '123456789',
      'area': 'حي العليا',
      'currentConsumption': 8500,
      'averageConsumption': 4500,
      'increasePercent': 89,
      'address': 'شارع الملك فهد - مبنى 25',
      'meterNumber': 'WTR-001',
      'lastReading': '2024-01-15',
    },
    {
      'name': 'سارة عبدالله',
      'accountNumber': '123456790',
      'area': 'حي الرياض',
      'currentConsumption': 6200,
      'averageConsumption': 3200,
      'increasePercent': 94,
      'address': 'شارع التحلية - مبنى 12',
      'meterNumber': 'WTR-002',
      'lastReading': '2024-01-14',
    },
  ];

  final List<Map<String, dynamic>> _alertsData = [
    {
      'type': 'استهلاك مرتفع',
      'area': 'حي العليا',
      'customer': 'أحمد محمد',
      'consumption': 8500,
      'average': 4500,
      'percentage': 89,
      'priority': 'عالي',
      'date': '2024-01-15',
      'status': 'غير معالج',
    },
    {
      'type': 'شذوذ في الاستهلاك',
      'area': 'حي الرياض',
      'customer': 'سارة عبدالله',
      'consumption': 6200,
      'average': 3200,
      'percentage': 94,
      'priority': 'متوسط',
      'date': '2024-01-14',
      'status': 'تحت المراجعة',
    },
  ];

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
              color: themeProvider.isDarkMode ? Colors.blueAccent.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: themeProvider.isDarkMode ? Colors.blueAccent : Colors.grey,
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
            activeColor: Colors.blueAccent,
            activeTrackColor: Colors.blueAccent.withOpacity(0.5),
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
          _buildAboutRow('المطور', 'وزارة المياه - العراق', themeProvider),
          _buildAboutRow('رقم الترخيص', 'MOW-2024-001', themeProvider),
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
          _buildContactItem(Icons.email_rounded, 'البريد الإلكتروني', 'support@water.gov.iq', false),
          _buildContactItem(Icons.access_time_rounded, 'ساعات العمل', '8:00 ص - 4:00 م', false),
          _buildContactItem(Icons.location_on_rounded, 'العنوان', 'بغداد - وزارة المياه', false),
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
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openSupportChat(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _secondaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.chat_rounded, size: 20),
                  label: Text('مراسلة الدعم'),
                ),
              ),
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
        'answer': 'اذهب إلى قسم "الاستهلاك المرتفع" → استعرض قائمة العملاء → انقر على أي عميل لعرض التفاصيل → استخدم زر "إرسال تنبيه" لإرسال إنذار'
      },
      {
        'question': 'كيف أعرض تقرير الاستهلاك الشهري للمياه؟',
        'answer': 'انتقل إلى قسم "التقارير" → اختر "شهري" → حدد الشهر المطلوب → انقر على "إنشاء التقرير"'
      },
      {
        'question': 'كيف أتعامل مع إنذارات تسرب المياه؟',
        'answer': 'اذهب إلى قسم "الإنذارات" → استعرض قائمة الإنذارات → انقر على زر "معالجة" بجانب كل إنذار → اتبع الإجراءات المطلوبة'
      },
      {
        'question': 'كيف أتحقق من استهلاك المياه في منطقة معينة؟',
        'answer': 'استخدم فلتر المنطقة في أعلى الشاشة → اختر المنطقة المطلوبة → سيتم عرض جميع البيانات المتعلقة بتلك المنطقة'
      },
      {
        'question': 'كيف أقوم بتصدير تقارير المياه؟',
        'answer': 'انتقل إلى قسم التقارير → اختر نوع التقرير والفترة → انقر على "إنشاء التقرير" → اختر "تصدير PDF" لحفظ أو مشاركة التقرير'
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
          _buildInfoRow('المطور', 'وزارة المياه', isDarkMode),
          _buildInfoRow('رقم الترخيص', 'MOW-2024-001', isDarkMode),
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

  void _openSupportChat() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupportChatScreen(
          isDarkMode: isDarkMode,
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          darkCardColor: Colors.white10,
          cardColor: _cardColor(context),
          darkTextColor: Colors.white,
          textColor: _textColor(context),
          darkTextSecondaryColor: Colors.white70,
          textSecondaryColor: _textSecondaryColor(context),
        ),
      ),
    );
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
              _buildPdfHighConsumptionCustomers(),
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
              'شركة المياه',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
            pw.Text(
              'تقرير مراقبة الاستهلاك',
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
        ? _consumptionData
        : _consumptionData.where((item) => item['area'] == _selectedArea).toList();

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
              pw.Text('${NumberFormat('#,##0').format(totalConsumption)} لتر'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('متوسط الاستهلاك:'),
              pw.Text('${avgConsumption.toStringAsFixed(1)} لتر/عميل'),
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
        ],
      ),
    );
  }

  pw.Widget _buildPdfConsumptionDetails() {
    final filteredData = _selectedArea == 'جميع المناطق'
        ? _consumptionData
        : _consumptionData.where((item) => item['area'] == _selectedArea).toList();

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
                  child: pw.Text('${NumberFormat('#,##0').format(area['currentConsumption'])} لتر'),
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
          'الإنذارات',
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
              pw.Text('الاستهلاك: ${alert['consumption']} لتر (المتوسط: ${alert['average']} لتر)'),
              pw.Text('نسبة الزيادة: ${alert['percentage']}%'),
              pw.Text('الحالة: ${alert['status']}'),
            ],
          ),
        )).toList(),
      ],
    );
  }

  pw.Widget _buildPdfHighConsumptionCustomers() {
    final filteredCustomers = _getFilteredHighConsumptionCustomers();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'العملاء ذوو الاستهلاك المرتفع',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 10),
        if (filteredCustomers.isEmpty)
          pw.Text('لا توجد عملاء ذوي استهلاك مرتفع'),
        ...filteredCustomers.map((customer) => pw.Container(
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
                    customer['name'],
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.orange,
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    child: pw.Text(
                      'زيادة ${customer['increasePercent']}%',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Text('رقم الحساب: ${customer['accountNumber']}'),
              pw.Text('المنطقة: ${customer['area']}'),
              pw.Text('العنوان: ${customer['address']}'),
              pw.Text('رقم العداد: ${customer['meterNumber']}'),
              pw.Text('آخر قراءة: ${customer['lastReading']}'),
              pw.Text('الاستهلاك الحالي: ${customer['currentConsumption']} لتر'),
              pw.Text('متوسط الاستهلاك: ${customer['averageConsumption']} لتر'),
            ],
          ),
        )).toList(),
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
        return _buildHighConsumptionView();
      case 2:
        return _buildReportsView();
      case 3:
        return _buildSettingsView();
      case 4:
        return _buildHelpView();
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
                    colors: [Color(0xFFF5F5F5), Color(0xFFE8F5FF)],
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
                  'استلام إشعارات حول الاستهلاك والإنذارات',
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
                    colors: [Color(0xFFF5F5F5), Color(0xFFE8F5FF)],
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

  Widget _buildAreaFilter() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedArea,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: _primaryColor),
          items: _areas.map((String area) {
            return DropdownMenuItem<String>(
              value: area,
              child: Text(area, style: TextStyle(color: _textColor(context))),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedArea = newValue!;
            });
          },
        ),
      ),
    );
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
            _buildTabItem(1, Icons.trending_up, 'الاستهلاك المرتفع'),
            _buildTabItem(2, Icons.assignment, 'التقارير'),
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
        ? _consumptionData
        : _consumptionData.where((item) => item['area'] == _selectedArea).toList();

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
            childAspectRatio: 1.4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildStatCard(
                'إجمالي الاستهلاك',
                '${NumberFormat('#,###').format(totalConsumption)} لتر',
                Icons.water_drop,
                _waterBlue,
              ),
              _buildStatCard(
                'متوسط الاستهلاك',
                '${avgConsumption.toStringAsFixed(1)} لتر/عميل',
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
            ],
          ),
          const SizedBox(height: 20),
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
                  'أداء المناطق',
                  style: TextStyle(
                    fontSize: 18,
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
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${NumberFormat('#,###').format(areaData['currentConsumption'])} لتر',
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

  Widget _buildHighConsumptionView() {
    final filteredCustomers = _getFilteredHighConsumptionCustomers();
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.trending_up, color: _warningColor, size: 24),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'العملاء ذوو الاستهلاك المرتفع',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                ],
              ),
              if (_selectedArea != 'جميع المناطق')
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'المنطقة: $_selectedArea',
                      style: TextStyle(
                        fontSize: 14,
                        color: _primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (filteredCustomers.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, color: _textSecondaryColor(context), size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد عملاء ذوي استهلاك مرتفع ${_selectedArea != 'جميع المناطق' ? 'في $_selectedArea' : ''}',
                    style: TextStyle(
                      fontSize: 18,
                      color: _textSecondaryColor(context),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildCustomerCard(filteredCustomers[index]),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  customer['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor(context),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _warningColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    'زيادة ${customer['increasePercent']}%',
                    style: TextStyle(
                      color: _warningColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildCustomerInfoRow('رقم الحساب', customer['accountNumber']),
            _buildCustomerInfoRow('المنطقة', customer['area']),
            _buildCustomerInfoRow('العنوان', customer['address']),
            _buildCustomerInfoRow('رقم العداد', customer['meterNumber']),
            _buildCustomerInfoRow('آخر قراءة', customer['lastReading']),
            const SizedBox(height: 12),
            Divider(color: _borderColor(context)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildConsumptionComparison(
                  'الاستهلاك الحالي',
                  '${customer['currentConsumption']} لتر',
                  _errorColor,
                ),
                _buildConsumptionComparison(
                  'المتوسط',
                  '${customer['averageConsumption']} لتر',
                  _textColor(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryColor,
                      side: BorderSide(color: _primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _showCustomerDetails(customer);
                    },
                    child: const Text('تفاصيل'),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textColor(context),
              ),
            ),
          ),
          Expanded(child: Text(value, style: TextStyle(color: _textSecondaryColor(context)))),
        ],
      ),
    );
  }

  Widget _buildConsumptionComparison(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
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

  void _showCustomerDetails(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: Text('تفاصيل العميل - ${customer['name']}', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('رقم الحساب', customer['accountNumber']),
              _buildDetailItem('المنطقة', customer['area']),
              _buildDetailItem('العنوان', customer['address']),
              _buildDetailItem('رقم العداد', customer['meterNumber']),
              _buildDetailItem('آخر قراءة', customer['lastReading']),
              _buildDetailItem('الاستهلاك الحالي', '${customer['currentConsumption']} لتر'),
              _buildDetailItem('متوسط الاستهلاك', '${customer['averageConsumption']} لتر'),
              _buildDetailItem('نسبة الزيادة', '${customer['increasePercent']}%'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _textSecondaryColor(context))),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold, color: _textColor(context)),
            ),
          ),
          Expanded(child: Text(value, style: TextStyle(color: _textSecondaryColor(context)))),
        ],
      ),
    );
  }

  void _sendAlertToCustomer(Map<String, dynamic> customer) {
    _showSuccessSnackbar('تم إرسال تنبيه إلى ${customer['name']}');
  }

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
                'نظام التقارير',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildReportTypeFilter(),
          const SizedBox(height: 20),
          _buildReportOptions(),
          const SizedBox(height: 20),
          _buildGenerateReportButton(),
        ],
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
              Text('- إجمالي الاستهلاك: 450,000 لتر', style: TextStyle(color: _textColor(context))),
              Text('- عدد العملاء: 880', style: TextStyle(color: _textColor(context))),
              Text('- متوسط الاستهلاك: 511.4 لتر/عميل', style: TextStyle(color: _textColor(context))),
              Text('- عدد الإنذارات: 12', style: TextStyle(color: _textColor(context))),
              Text('- العملاء ذوو الاستهلاك المرتفع: 48', style: TextStyle(color: _textColor(context))),
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
      return _alertsData;
    }
    return _alertsData.where((alert) => alert['area'] == _selectedArea).toList();
  }

  List<Map<String, dynamic>> _getFilteredHighConsumptionCustomers() {
    if (_selectedArea == 'جميع المناطق') {
      return _highConsumptionCustomers;
    }
    return _highConsumptionCustomers.where((customer) => customer['area'] == _selectedArea).toList();
  }

  void _handleAlert(int index) {
    setState(() {
      _alertsData[index]['status'] = 'تحت المراجعة';
    });
    _showSuccessSnackbar('تم معالجة إنذار ${_alertsData[index]['customer']}');
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
                                  
                                  SizedBox(height: 12),
                                  
                                  if (tempSelectedDates.length > 1)
                                    Text(
                                      'من ${DateFormat('yyyy-MM-dd').format(tempSelectedDates.first)} '
                                      'إلى ${DateFormat('yyyy-MM-dd').format(tempSelectedDates.last)} '
                                      '(${tempSelectedDates.length} يوم)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _textSecondaryColor(context),
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

  Widget _buildCalendar() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today, size: 48, color: _primaryColor),
          SizedBox(height: 16),
          Text(
            'انقر على الزر أعلاه لفتح التقويم',
            style: TextStyle(color: _textSecondaryColor(context)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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

    _showSuccessSnackbar('تم إنشاء التقرير لـ ${_selectedDates.length} يوم بنجاح');
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
      MaterialPageRoute(builder: (context) => MonitoringNotificationsScreen()),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: _backgroundColor(context),
    appBar: AppBar(
      title: const Text('مراقبة استهلاك المياه'),
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MonitoringNotificationsScreen()),
            );
          },
        ),
      ],
    ),

    drawer: _buildDrawer(context),
    body: Column(
      children: [
        _buildTabBar(),
        if (_selectedTab == 0 || _selectedTab == 1) _buildAreaFilter(),
        Expanded(child: _buildCurrentView()),
      ],
    ),
  );
}

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
                'مراقب استهلاك - المنطقة الشرقية',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        _buildDrawerItem(3, Icons.settings, 'الإعدادات', _selectedTab == 3),
        _buildDrawerItem(4, Icons.help, 'المساعدة والدعم', _selectedTab == 4),
        const Divider(color: Color(0xFFD1E0E8)),
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

Widget _buildDrawerItem(int index, IconData icon, String title, bool isSelected) {
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
}

// شاشة محادثة الدعم
class SupportChatScreen extends StatefulWidget {
  final bool isDarkMode;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color darkCardColor;
  final Color cardColor;
  final Color darkTextColor;
  final Color textColor;
  final Color darkTextSecondaryColor;
  final Color textSecondaryColor;

  const SupportChatScreen({
    Key? key,
    required this.isDarkMode,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.darkCardColor,
    required this.cardColor,
    required this.darkTextColor,
    required this.textColor,
    required this.darkTextSecondaryColor,
    required this.textSecondaryColor,
  }) : super(key: key);

  @override
  _SupportChatScreenState createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'مرحباً! كيف يمكنني مساعدتك اليوم؟',
      'isUser': false,
      'time': 'الآن',
      'sender': 'موظف الدعم'
    }
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isUser': true,
        'time': 'الآن',
        'sender': 'أنت'
      });
    });

    _messageController.clear();

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text': 'شكراً لتواصلكم. سأقوم بمساعدتك في حل هذه المشكلة. هل يمكنك تقديم مزيد من التفاصيل؟',
            'isUser': false,
            'time': 'الآن',
            'sender': 'موظف الدعم'
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'محادثة الدعم الفني',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'متصل الآن',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: widget.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: Colors.white),
            onSelected: (value) {
              if (value == 'end_chat') {
                _endChat(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'end_chat',
                child: Row(
                  children: [
                    Icon(Icons.close_rounded, color: Colors.red),
                    SizedBox(width: 8),
                    Text('إنهاء المحادثة'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(color: widget.primaryColor.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.support_agent_rounded, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'فاضل علي - موظف الدعم',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
                        ),
                      ),
                      Text(
                        'متخصص في نظام مراقبة استهلاك المياه',
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'متصل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
              border: Border(
                top: BorderSide(color: widget.primaryColor.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isDarkMode ? Colors.white10 : Colors.grey[50],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالتك هنا...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.attach_file_rounded, color: widget.primaryColor),
                          onPressed: () => _showAttachmentOptions(context),
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: widget.primaryColor,
                  child: IconButton(
                    icon: Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final bool isUser = message['isUser'] as bool;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: widget.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.support_agent_rounded, color: Colors.white, size: 16),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isUser)
                  Text(
                    message['sender'],
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser 
                        ? widget.primaryColor 
                        : (widget.isDarkMode ? Colors.white10 : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message['text'],
                    style: TextStyle(
                      color: isUser ? Colors.white : (widget.isDarkMode ? widget.darkTextColor : widget.textColor),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message['time'],
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (isUser)
            SizedBox(width: 8),
          if (isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: widget.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded, color: Colors.white, size: 16),
            ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'إرفاق ملف',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
            SizedBox(height: 16),
            _buildAttachmentOption(Icons.photo_rounded, 'صورة', () {}),
            _buildAttachmentOption(Icons.description_rounded, 'ملف', () {}),
            _buildAttachmentOption(Icons.receipt_rounded, 'تقرير', () {}),
            _buildAttachmentOption(Icons.location_on_rounded, 'موقع', () {}),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: widget.primaryColor),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _endChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.close_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('إنهاء المحادثة'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد إنهاء المحادثة؟',
          style: TextStyle(
            color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('البقاء في المحادثة'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إنهاء المحادثة بنجاح'),
                  backgroundColor: widget.primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('إنهاء المحادثة'),
          ),
        ],
      ),
    );
  }
}

// شاشة الإشعارات للمراقب
class MonitoringNotificationsScreen extends StatefulWidget {
  static const String routeName = '/monitoring-notifications';

  @override
  _MonitoringNotificationsScreenState createState() => _MonitoringNotificationsScreenState();
}

class _MonitoringNotificationsScreenState extends State<MonitoringNotificationsScreen> {
  final Color _primaryColor = const Color(0xFF006699);
  final Color _secondaryColor = const Color(0xFF004466);
  final Color _successColor = const Color(0xFF28A745);
  final Color _warningColor = const Color(0xFFFFC107);
  final Color _errorColor = const Color(0xFFDC3545);
  
  Color _backgroundColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF121212) : const Color(0xFFE6F7FF);
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
    return themeProvider.isDarkMode ? const Color(0xFF333333) : const Color(0xFFC2E7FF);
  }

  int _selectedTab = 0;
  final List<String> _tabs = ['الإنذارات', 'التقارير', 'الاستهلاك', 'الكل'];

  final List<Map<String, dynamic>> _allNotifications = [
    {
      'id': '1',
      'type': 'استهلاك مرتفع',
      'title': 'إنذار استهلاك مرتفع',
      'description': 'المواطن أحمد محمد في حي العليا سجل استهلاكاً مرتفعاً بنسبة 89%',
      'time': 'منذ 5 دقائق',
      'read': false,
      'tab': 0,
      'priority': 'عالي',
      'area': 'حي العليا',
      'customer': 'أحمد محمد',
    },
    {
      'id': '2',
      'type': 'شذوذ في الاستهلاك',
      'title': 'نمط استهلاك غير طبيعي',
      'description': 'تم رصد نمط استهلاك غير طبيعي للمواطن سارة عبدالله في حي الرياض',
      'time': 'منذ ساعة',
      'read': false,
      'tab': 0,
      'priority': 'متوسط',
      'area': 'حي الرياض',
      'customer': 'سارة عبدالله',
    },
    {
      'id': '3',
      'type': 'تسرب المياه',
      'title': 'تسرب في المنطقة',
      'description': 'تم رصد تسرب في المياه في حي النخيل - شارع الملك فيصل',
      'time': 'منذ 3 ساعات',
      'read': true,
      'tab': 0,
      'priority': 'عالي',
      'area': 'حي النخيل',
      'customer': 'منطقة كاملة',
    },
    {
      'id': '4',
      'type': 'تقرير استهلاك',
      'title': 'تقرير الاستهلاك الشهري جاهز',
      'description': 'تم إنشاء تقرير الاستهلاك الشهري لشهر يناير 2024 بنجاح',
      'time': 'منذ يوم',
      'read': true,
      'tab': 1,
      'priority': 'منخفض',
      'area': 'جميع المناطق',
      'reportType': 'شهري',
    },
    {
      'id': '5',
      'type': 'تقرير إنذارات',
      'title': 'تقرير الإنذارات الأسبوعي',
      'description': 'تم إنشاء تقرير الإنذارات للأسبوع الحالي - 12 إنذار جديد',
      'time': 'منذ يومين',
      'read': true,
      'tab': 1,
      'priority': 'متوسط',
      'area': 'المنطقة الشرقية',
      'reportType': 'أسبوعي',
    },
    {
      'id': '6',
      'type': 'زيادة استهلاك',
      'title': 'زيادة في الاستهلاك العام',
      'description': 'سجلت المنطقة الشرقية زيادة في الاستهلاك بنسبة 15% هذا الأسبوع',
      'time': 'منذ 30 دقيقة',
      'read': false,
      'tab': 2,
      'priority': 'متوسط',
      'area': 'المنطقة الشرقية',
      'increasePercent': 15,
    },
    {
      'id': '7',
      'type': 'مقارنة استهلاك',
      'title': 'مقارنة الاستهلاك مع الفترة الماضية',
      'description': 'انخفاض في استهلاك حي الصفا بنسبة 8% مقارنة بالشهر الماضي',
      'time': 'منذ ساعتين',
      'read': true,
      'tab': 2,
      'priority': 'منخفض',
      'area': 'حي الصفا',
      'increasePercent': -8,
    },
    {
      'id': '8',
      'type': 'ذروة استهلاك',
      'title': 'ساعات الذروة',
      'description': 'تم رصد ذروة استهلاك بين الساعة 6-9 مساءً في جميع المناطق',
      'time': 'منذ 5 ساعات',
      'read': true,
      'tab': 2,
      'priority': 'منخفض',
      'area': 'جميع المناطق',
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedTab == 3) {
      return _allNotifications;
    }
    return _allNotifications.where((notification) => notification['tab'] == _selectedTab).toList();
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
      case 'شذوذ في الاستهلاك':
        return Icons.warning_rounded;
      case 'تسرب المياه':
        return Icons.water_damage_rounded;
      case 'تقرير استهلاك':
      case 'تقرير إنذارات':
        return Icons.assignment_rounded;
      case 'زيادة استهلاك':
      case 'مقارنة استهلاك':
        return Icons.analytics_rounded;
      case 'ذروة استهلاك':
        return Icons.schedule_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor(context),
      appBar: AppBar(
        title: Text(
          'الإشعارات',
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
      ),
      body: Column(
        children: [
          Container(
            height: 50,
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

          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTab == index;
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
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isSelected ? _primaryColor : _textSecondaryColor(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardColor(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getNotificationIcon(notification['type']),
                      color: _primaryColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: _textColor(context),
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(notification['priority']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _getPriorityColor(notification['priority']).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                notification['priority'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getPriorityColor(notification['priority']),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: _textSecondaryColor(context),
                            ),
                            SizedBox(width: 4),
                            Text(
                              notification['area'],
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
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        notification['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: _textSecondaryColor(context),
                        ),
                      ),
                      SizedBox(height: 4),
                      if (!notification['read'])
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              Text(
                notification['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: _textSecondaryColor(context),
                  height: 1.4,
                ),
              ),
              
              SizedBox(height: 8),
              if (notification['customer'] != null)
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 14, color: _textSecondaryColor(context)),
                    SizedBox(width: 4),
                    Text(
                      'العميل: ${notification['customer']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              
              if (notification['reportType'] != null)
                Row(
                  children: [
                    Icon(Icons.description_outlined, size: 14, color: _textSecondaryColor(context)),
                    SizedBox(width: 4),
                    Text(
                      'نوع التقرير: ${notification['reportType']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              
              if (notification['increasePercent'] != null)
                Row(
                  children: [
                    Icon(
                      notification['increasePercent'] > 0 ? 
                          Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                      size: 14,
                      color: notification['increasePercent'] > 0 ? _errorColor : _successColor,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'نسبة التغيير: ${notification['increasePercent']}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: notification['increasePercent'] > 0 ? _errorColor : _successColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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
          Icon(
            Icons.notifications_off_rounded,
            size: 64,
            color: _textSecondaryColor(context),
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لا توجد إشعارات في التبويب المحدد',
            style: TextStyle(
              color: _textSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

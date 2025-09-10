import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  final Color serviceColor;

  const SettingsScreen({super.key, required this.serviceColor});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricAuthEnabled = false;
  String _selectedLanguage = 'العربية';
  String _selectedCurrency = 'دينار عراقي';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _biometricAuthEnabled = prefs.getBool('biometric_auth_enabled') ?? false;
      _selectedLanguage = prefs.getString('selected_language') ?? 'العربية';
      _selectedCurrency = prefs.getString('selected_currency') ?? 'دينار عراقي';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: widget.serviceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إعدادات الحساب
            _buildSectionTitle('إعدادات الحساب'),
            _buildSettingItem(
              icon: Icons.notifications,
              title: 'الإشعارات',
              subtitle: 'إدارة التنبيهات والإشعارات',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                  _saveSetting('notifications_enabled', value);
                },
                activeColor: widget.serviceColor,
              ),
            ),
            _buildSettingItem(
              icon: Icons.fingerprint,
              title: 'المصادقة البيومترية',
              subtitle: 'استخدام البصمة أو التعرف على الوجه',
              trailing: Switch(
                value: _biometricAuthEnabled,
                onChanged: (value) {
                  setState(() => _biometricAuthEnabled = value);
                  _saveSetting('biometric_auth_enabled', value);
                },
                activeColor: widget.serviceColor,
              ),
            ),

            // إعدادات التطبيق
            _buildSectionTitle('إعدادات التطبيق'),
            _buildSettingItem(
              icon: Icons.dark_mode,
              title: 'الوضع الليلي',
              subtitle: 'تفعيل المظهر الداكن',
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
                activeColor: widget.serviceColor,
              ),
            ),
            _buildSettingItem(
              icon: Icons.language,
              title: 'اللغة',
              subtitle: _selectedLanguage,
              trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[600]),
              onTap: () => _showLanguageDialog(),
            ),
            _buildSettingItem(
              icon: Icons.currency_exchange,
              title: 'العملة',
              subtitle: _selectedCurrency,
              trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[600]),
              onTap: () => _showCurrencyDialog(),
            ),

            // الخصوصية والأمان
            _buildSectionTitle('الخصوصية والأمان'),
            _buildSettingItem(
              icon: Icons.lock,
              title: 'سياسة الخصوصية',
              subtitle: 'اطلع على سياسة الخصوصية',
              onTap: () => _showPrivacyPolicy(),
            ),
            _buildSettingItem(
              icon: Icons.security,
              title: 'شروط الخدمة',
              subtitle: 'اقرأ شروط الاستخدام',
              onTap: () => _showTermsOfService(),
            ),
            _buildSettingItem(
              icon: Icons.delete,
              title: 'حذف الحساب',
              subtitle: 'حذف الحساب والبيانات بشكل دائم',
              onTap: () => _showDeleteAccountDialog(),
            ),

            // حول التطبيق
            _buildSectionTitle('حول التطبيق'),
            _buildSettingItem(
              icon: Icons.info,
              title: 'عن التطبيق',
              subtitle: 'الإصدار 1.0.0',
              onTap: () => _showAboutDialog(),
            ),
            _buildSettingItem(
              icon: Icons.contact_support,
              title: 'الدعم الفني',
              subtitle: 'اتصل بفريق الدعم',
              onTap: () => _contactSupport(),
            ),
            _buildSettingItem(
              icon: Icons.star,
              title: 'قيم التطبيق',
              subtitle: 'شاركنا رأيك في المتجر',
              onTap: () => _rateApp(),
            ),

            // مساحة فارغة في الأسفل
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: widget.serviceColor,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: widget.serviceColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('العربية', 'ar'),
            _buildLanguageOption('English', 'en'),
            _buildLanguageOption('Français', 'fr'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language, String code) {
    return ListTile(
      title: Text(language),
      trailing: _selectedLanguage == language ? Icon(Icons.check, color: widget.serviceColor) : null,
      onTap: () {
        setState(() => _selectedLanguage = language);
        _saveSetting('selected_language', language);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تغيير اللغة إلى $language')),
        );
      },
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر العملة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCurrencyOption('دينار عراقي', 'IQD'),
            _buildCurrencyOption('دولار أمريكي', 'USD'),
            _buildCurrencyOption('يورو', 'EUR'),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyOption(String currency, String code) {
    return ListTile(
      title: Text(currency),
      trailing: _selectedCurrency == currency ? Icon(Icons.check, color: widget.serviceColor) : null,
      onTap: () {
        setState(() => _selectedCurrency = currency);
        _saveSetting('selected_currency', currency);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تغيير العملة إلى $currency')),
        );
      },
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('سياسة الخصوصية'),
        content: const SingleChildScrollView(
          child: Text(
            'نحن نحرص على حماية خصوصيتك. نحن نجمع المعلومات الشخصية فقط عندما تكون ضرورية لتقديم خدماتنا. نحن لا نشارك معلوماتك مع أطراف ثالثة دون موافقتك.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('شروط الخدمة'),
        content: const SingleChildScrollView(
          child: Text(
            'باستخدامك لهذا التطبيق، فإنك توافق على الالتزام بشروط الخدمة هذه. يرجى قراءتها بعناية. نحن نحتفظ بالحق في تعديل هذه الشروط في أي وقت.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الحساب'),
        content: const Text('هل أنت متأكد من أنك تريد حذف حسابك؟ هذه العملية لا يمكن التراجع عنها.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم طلب حذف الحساب بنجاح')),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('عن التطبيق'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('إدارة الخدمات البلدية', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('الإصدار: 1.0.0'),
            Text('الباني: فريق التطوير'),
            SizedBox(height: 16),
            Text('تطبيق لإدارة فواتير الكهرباء والماء والنفايات بسهولة وأمان.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الدعم الفني'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.email),
              title: Text('البريد الإلكتروني'),
              subtitle: Text('support@municipality.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('الهاتف'),
              subtitle: Text('+213123456789'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم فتح متجر التطبيقات قريباً')),
    );
  }
}
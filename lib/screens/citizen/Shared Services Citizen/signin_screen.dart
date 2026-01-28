import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SigninScreen extends StatefulWidget {
  static const String screenroot = 'signin_screen';
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

  // الألوان الجديدة المطابقة لشاشة المستخدم الرئيسية
  final Color _primaryColor = const Color(0xFF0D47A1);
  final Color _secondaryColor = const Color(0xFF1976D2);
  final Color _accentColor = const Color(0xFF64B5F6);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _borderColor = const Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // دالة تسجيل الدخول
Future<void> _signIn() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);
    
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      
      final AuthResponse response = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);
      
      if (response.user != null) {
        // التحقق من حالة الحساب في جدول profiles فقط
        final userData = await Supabase.instance.client
            .from('profiles')
            .select('status')
            .eq('id', response.user!.id)
            .single();

        // إذا وصل إلى هنا، يعني الحساب مفعل ويمكن الانتقال للشاشة الرئيسية
        Navigator.pushReplacementNamed(context, 'user_main');
      }
    } on AuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء تسجيل الدخول: ${e.toString()}',
            style: const TextStyle(fontFamily: 'Tajawal'),
          ),
          backgroundColor: _errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

void _handleAuthError(AuthException e) {
  String errorMessage = 'حدث خطأ أثناء تسجيل الدخول';
  
  if (e.message.contains('Invalid login credentials')) {
    errorMessage = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
  } else {
    errorMessage = 'خطأ في المصادقة: ${e.message}';
  }
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMessage, style: TextStyle(fontFamily: 'Tajawal')),
      backgroundColor: _errorColor,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          // خلفية بسيطة مع تدرج لوني
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _primaryColor.withOpacity(0.1),
                  _backgroundColor,
                ],
              ),
            ),
          ),

          // المحتوى الرئيسي
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width > 800 ? size.width * 0.2 : 24,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // الشعار والعنوان
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 40),
                              child: Column(
                                children: [
                                  // الشعار
                                  Container(
                                    width: 100,
                                    height: 100,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: _primaryColor,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _primaryColor.withOpacity(0.3),
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'images/lbbb.png',
                                      fit: BoxFit.contain,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // العنوان
                                  Text(
                                    'تسجيل الدخول',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tajawal',
                                      color: _primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'مرحباً بعودتك',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Tajawal',
                                      color: _textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // نموذج التسجيل
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: _borderColor, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // حقل البريد الإلكتروني
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: TextFormField(
                                        controller: _emailController,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          color: _textColor,
                                          fontSize: 16,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'البريد الإلكتروني',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Tajawal',
                                            color: _textSecondaryColor,
                                          ),
                                          prefixIcon: Icon(Icons.email_outlined, 
                                              color: _textSecondaryColor),
                                          contentPadding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                            horizontal: 20,
                                          ),
                                          filled: true,
                                          fillColor: _backgroundColor,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: _borderColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: _borderColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: _primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'الرجاء إدخال البريد الإلكتروني';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    
                                    // حقل كلمة المرور
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          color: _textColor,
                                          fontSize: 16,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'كلمة المرور',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Tajawal',
                                            color: _textSecondaryColor,
                                          ),
                                          prefixIcon: Icon(Icons.lock_outline, 
                                              color: _textSecondaryColor),
                                          contentPadding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                            horizontal: 20,
                                          ),
                                          filled: true,
                                          fillColor: _backgroundColor,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: _borderColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: _borderColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: _primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'الرجاء إدخال كلمة المرور';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    
                                    // نسيت كلمة المرور
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(
                                        onPressed: () {
                                          // إضافة وظيفة استعادة كلمة المرور هنا
                                        },
                                        child: Text(
                                          'نسيت كلمة المرور؟',
                                          style: TextStyle(
                                            color: _primaryColor,
                                            fontFamily: 'Tajawal',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // زر تسجيل الدخول
                                    _isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                _primaryColor,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: double.infinity,
                                            height: 56,
                                            child: ElevatedButton(
                                              onPressed: _signIn,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: _primaryColor,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                elevation: 3,
                                                shadowColor: _primaryColor.withOpacity(0.3),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.login, size: 20),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'تسجيل الدخول',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Tajawal',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // رابط إنشاء حساب جديد
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ليس لديك حساب؟',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: _textSecondaryColor,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // الانتقال لشاشة إنشاء حساب جديد
                                },
                                child: Text(
                                  'إنشاء حساب',
                                  style: TextStyle(
                                    color: _primaryColor,
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // تذييل الصفحة
     
        // مؤشر التحميل
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
              ),
            ),
          ),
      ],
    ),
  );
}}
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/signin_screen.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/regesyer_screen.dart';
import 'package:mang_mu/widgets/my_buttn.dart';
import 'package:flutter/material.dart';
import 'package:mang_mu/screens/zemp_and_citizen/mainscren.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class WecomeScreen extends StatefulWidget {
  static const String screenroot = 'wcome_screen';
  const WecomeScreen({super.key});

  @override
  State<WecomeScreen> createState() => _WecomeScreenState();
}

class _WecomeScreenState extends State<WecomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  // الألوان الجديدة المطابقة لشاشة تسجيل الدخول
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

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, Mainscren.screenroot);
        return false;
      },
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: Stack(
          children: [
            // خلفية بسيطة مع تدرج لوني
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_primaryColor.withOpacity(0.1), _backgroundColor],
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
                                      width: 120,
                                      height: 120,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: _primaryColor,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _primaryColor.withOpacity(
                                              0.3,
                                            ),
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
                                    const SizedBox(height: 25),
                                    // العنوان
                                    Text(
                                      'واجهة دخول المواطنين',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Tajawal',
                                        color: _primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'من أجل حياة أفضل',
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

                        // أزرار الدخول والتسجيل
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: Column(
                              children: [
                                // زر تسجيل الدخول
                                Container(
                                  width: double.infinity,
                                  height: 56,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        SigninScreen.screenroot,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 3,
                                      shadowColor: _primaryColor.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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

                                // زر إنشاء حساب جديد
                                Container(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        RegesyerScreen.screenRoot,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _cardColor,
                                      foregroundColor: _primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: _primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                      elevation: 1,
                                      shadowColor: _primaryColor.withOpacity(
                                        0.1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.person_add, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'إنشاء حساب جديد',
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

                        // معلومات إضافية
                        const SizedBox(height: 40),
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: Card(
                              elevation: 1,
                              margin: const EdgeInsets.only(bottom: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: _borderColor, width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: _primaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'معلومات سريعة',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Tajawal',
                                            color: _primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'يمكنك تسجيل الدخول إذا كان لديك حساب، أو إنشاء حساب جديد للوصول إلى جميع خدمات البلدية',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Tajawal',
                                        color: _textSecondaryColor,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
            // تذييل الصفحة
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    border: Border.all(color: _borderColor, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'بلدية المدينة الذكية © ${DateTime.now().year}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondaryColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'جميع الحقوق محفوظة',
                        style: TextStyle(
                          fontSize: 12,
                          color: _textSecondaryColor.withOpacity(0.7),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

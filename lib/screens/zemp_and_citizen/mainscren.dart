import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../citizen/Shared Services Citizen/welcome_screen.dart';
import 'package:mang_mu/screens/employee/Shared%20Services/ewecome_screen.dart';
import 'dart:ui';
import 'dart:math';

class Mainscren extends StatefulWidget {
  static const String screenroot = '/mainscren';
  const Mainscren({super.key});

  @override
  State<Mainscren> createState() => _MainscrenState();
}

class _MainscrenState extends State<Mainscren>
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

  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.connected_tv,
      'title': 'خدمات ذكية',
      'description': 'وصول سريع لجميع الخدمات عبر المنصة',
    },
    {
      'icon': Icons.verified_user,
      'title': 'أمان وحماية',
      'description': 'نظام آمن ومحمي لحماية بياناتك',
    },
    {
      'icon': Icons.access_time_filled,
      'title': 'توفير الوقت',
      'description': 'إنجاز المعاملات في دقائق بدون عناء',
    },
  ];

  @override
  void initState() {
    super.initState();
  
    Future.delayed(const Duration(seconds: 5), _nextFeature);
  }

  void _nextFeature() {
    if (!mounted) return;
    if (_currentPage < _features.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      _currentPage++;
    } else {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      _currentPage = 0;
    }
    Future.delayed(const Duration(seconds: 5), _nextFeature);
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
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          // الشعار
                          Container(
                            width: 140,
                            height: 140,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: _primaryColor,
                              borderRadius: BorderRadius.circular(28),
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
                          const SizedBox(height: 25),
                          // العنوان
                          Text(
                            'مدينتي الذكية',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                              color: _primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'نحو مستقبل رقمي متكامل',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Tajawal',
                              color: _textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // أزرار الدخول
                    Column(
                      children: [
                        // زر دخول المواطنين
                        Container(
                          width: double.infinity,
                          height: 56,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                WecomeScreen.screenroot,
                              );
                            },
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
                                const Icon(Icons.people_alt_rounded, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'دخول المواطنين',
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

                        // زر دخول الموظفين
                        Container(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                EwecomeScreen.screenroot,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _cardColor,
                              foregroundColor: _primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: _primaryColor, width: 2),
                              ),
                              elevation: 1,
                              shadowColor: _primaryColor.withOpacity(0.1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.badge_rounded, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'دخول الموظفين',
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

                    // الميزات
                    SizedBox(height: size.height * 0.05),

                    Container(
                      height: 120,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _features.length,
                        itemBuilder: (context, index) {
                          return _buildFeatureCard(
                            _features[index]['icon'],
                            _features[index]['title'],
                            _features[index]['description'],
                          );
                        },
                      ),
                    ),

                    // مؤشر الصفحات
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _features.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentPage == index
                                ? _primaryColor
                                : _primaryColor.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),

                    // معلومات إضافية
                    const SizedBox(height: 30),
                  
                  ],
                ),
              ),
            ),
          ),
        ),

        // تذييل الصفحة
     
      ],
    ),
  );
}

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor,
        border: Border.all(color: _borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _primaryColor.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              color: _primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: _primaryColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: _textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
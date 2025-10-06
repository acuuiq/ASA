import 'package:flutter/material.dart';
import 'package:mang_mu/screens/mainscren.dart';

class SplashScreen extends StatefulWidget {
  static const String screenRoute = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));

    _colorAnimation = ColorTween(
      begin: Color.fromARGB(255, 17, 126, 117),
      end: Color.fromARGB(255, 16, 78, 88),
    ).animate(_controller);

    _controller.forward();

    _navigateToMain();
  }

  Future<void> _navigateToMain() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Mainscren.screenroot);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _colorAnimation.value,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الشعار باستخدام الصورة المخصصة
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: SizedBox(
                    width: 180,
                    height: 180,
                    child: Image.asset(
                      'images/lbbb.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.account_balance,
                          size: 60,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // العنوان الرئيسي
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'بلدية المدينة',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // الشعار الثانوي
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'نحو مدينة أكثر جمالاً',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Tajawal',
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // مؤشر التحميل مع تأثير النبض
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(
                          0.5,
                          1.0,
                          curve: Curves.easeInOut,
                        ),
                      ),
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // نص تذييل الصفحة
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'نسعى لتحقيق راحتكم ورفاهيتكم',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

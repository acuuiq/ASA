import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mang_mu/screens/wecome_screen.dart';
import 'package:mang_mu/screens/ewecome_screen.dart';
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
  bool _isHovering = false;
  int _currentBackground = 0;
  final List<String> _backgrounds = [
    'assets/bg1.svg',
    'assets/bg2.svg',
    'assets/bg3.svg',
  ];
  final Random _random = Random();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.connected_tv,
      'title': 'خدمات ذكية',
      'description': 'وصول سريع لجميع الخدمات  عبر المنصة',
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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _currentBackground = (_currentBackground + 1) % _backgrounds.length;
        });
      }
    });

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
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              key: ValueKey(_currentBackground),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: isDarkMode
                      ? [const Color(0xFF0A0E21), const Color(0xFF1D1E33)]
                      : [const Color(0xFFF5F7FA), const Color(0xFFE4E7EB)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      _backgrounds[_currentBackground],
                      fit: BoxFit.cover,
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.03)
                          : Colors.black.withOpacity(0.03),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          theme.scaffoldBackgroundColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: Colors.transparent),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width > 800 ? size.width * 0.15 : 24,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: MouseRegion(
                              onEnter: (_) =>
                                  setState(() => _isHovering = true),
                              onExit: (_) =>
                                  setState(() => _isHovering = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                padding: const EdgeInsets.all(1),
                                margin: const EdgeInsets.only(bottom: 20),
                                width: 300, // ← أضف هذه السطر لتحديد عرض ثابت
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color.fromARGB(
                                        255,
                                        8,
                                        93,
                                        99,
                                      ).withOpacity(0.9),
                                      const Color.fromARGB(
                                        255,
                                        1,
                                        17,
                                        27,
                                      ).withOpacity(0.9),
                                    ],
                                  ),

                                  // ... بقية الخصائص
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDarkMode
                                          ? const Color.fromARGB(
                                              255,
                                              185,
                                              37,
                                              37,
                                            ).withOpacity(0.4)
                                          : Colors.grey.withOpacity(0.2),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                      offset: const Offset(0, 20),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: isDarkMode
                                        ? Colors.blueGrey.withOpacity(0.2)
                                        : Colors.grey.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Transform(
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateX(_isHovering ? 0.1 : 0.0)
                                        ..rotateY(_isHovering ? 0.05 : 0.0),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width:
                                                250, // يمكن تعديل العرض حسب الحاجة
                                            height:
                                                200, // يمكن تعديل الارتفاع حسب الحاجة
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                12,
                                              ), // زوايا مستديرة - يمكن حذفها إذا أردت زوايا حادة
                                            ),
                                            child: Image.asset(
                                              'images/lbbb.png',
                                              height: 250,
                                              width: 250,
                                              // تغيير إلى BoxFit.contain لعرض الصورة كاملة بدون اقتصاص
                                            ),
                                          ),
                                          const SizedBox(),
                                          if (_isHovering)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                              ),
                                              child: Text(
                                                "المدينة الذكية",
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    250,
                                                    250,
                                                    250,
                                                  ).withOpacity(0.9),
                                                  fontSize: 18,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      blurRadius: 4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 0),
                                    AnimatedDefaultTextStyle(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      style: theme.textTheme.headlineMedium!
                                          .copyWith(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Tajawal',
                                            color: const Color.fromARGB(
                                              255,
                                              255,
                                              255,
                                              255,
                                            ), // أو أي لون من ألوان Material

                                            shadows: [
                                              Shadow(
                                                color: theme.primaryColor
                                                    .withOpacity(0.3),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                      child: const Text('مدينتي الذكية'),
                                    ),
                                    const SizedBox(height: 10),
                                    AnimatedOpacity(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      opacity: _isHovering ? 1 : 0.8,
                                      child: Text(
                                        'نحو مستقبل رقمي متكامل',
                                        style: theme.textTheme.titleMedium!
                                            .copyWith(
                                              color: const Color.fromARGB(
                                                255,
                                                255,
                                                255,
                                                255,
                                              ), // أو أي لون من ألوان Material

                                              fontFamily: 'Tajawal',
                                              fontSize: 18,
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

                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: Column(
                            children: [
                              _buildEnhancedAuthButton(
                                context,
                                icon: Icons.people_alt_rounded,
                                label: 'دخول المواطنين',
                                gradient: LinearGradient(
                                  colors: [
                                    const Color.fromARGB(255, 17, 126, 117),
                                    const Color.fromARGB(255, 16, 78, 88),
                                  ],
                                  transform: const GradientRotation(0.5),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    WecomeScreen.screenroot,
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildEnhancedAuthButton(
                                context,
                                icon: Icons.badge_rounded,
                                label: 'دخول الموظفين',
                                gradient: LinearGradient(
                                  colors: [
                                    const Color.fromARGB(255, 17, 126, 117),
                                    const Color.fromARGB(255, 16, 78, 88),
                                  ],
                                  transform: const GradientRotation(0.5),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    EwecomeScreen.screenroot,
                                  );
                                },
                              ),
                              if (size.width > 600) const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.03),

                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: Container(
                            height: 110,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: _features.length,
                              itemBuilder: (context, index) {
                                return _buildFeatureCard(
                                  _features[index]['icon'],
                                  _features[index]['title'],
                                  _features[index]['description'],
                                  theme,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _features.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: _currentPage == index ? 24 : 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: _currentPage == index
                                      ? const Color.fromARGB(
                                          255,
                                          4,
                                          126,
                                          114,
                                        ) // اللون عند التحديد
                                      : Colors.teal.withOpacity(
                                          0.3,
                                        ), // اللون عند عدم التحديد
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: _isHovering
                                ? Padding(
                                    key: const ValueKey(1),
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Text(
                                      'نحو مدينة ذكية متكاملة',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.headlineSmall!
                                          .copyWith(
                                            fontSize: 22,
                                            color: theme.primaryColor,
                                            fontFamily: 'Tajawal',
                                            fontWeight: FontWeight.w700,
                                            shadows: [
                                              Shadow(
                                                color: theme.primaryColor
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                    ),
                                  )
                                : const SizedBox(key: ValueKey(2), height: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color.fromARGB(0, 0, 0, 0),
                      theme.scaffoldBackgroundColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'بلدية المدينة الذكية © ${DateTime.now().year}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color?.withOpacity(
                          0.7,
                        ),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.cardColor.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 17, 126, 117),
                  Color.fromARGB(255, 16, 78, 88),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 255, 255, 255),
              size: 28,
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',

                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 17, 126, 117),
                          Color.fromARGB(255, 16, 78, 88),
                        ],
                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Tajawal',
                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedAuthButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onPressed,
  }) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 300),
      scale: _isHovering ? 1.03 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: _isHovering ? 20 : 12,
              spreadRadius: _isHovering ? 2 : 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            onHover: (hovering) => setState(() {}),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: gradient,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 26),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tajawal',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required ThemeData theme,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.primaryColor.withOpacity(0.1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: theme.primaryColor, size: 20),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.primaryColor,
                    fontFamily: 'Tajawal',
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

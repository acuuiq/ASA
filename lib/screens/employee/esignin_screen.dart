import 'package:flutter/material.dart';
import 'package:mang_mu/screens/user/user_thing.dart';
import 'package:mang_mu/widgets/my_buttn.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
// استيراد الشاشات الجديدة
import 'package:mang_mu/screens/employee/water_employee_screen.dart';
import 'package:mang_mu/screens/employee/electricity_employee_screen.dart';
import 'package:mang_mu/screens/employee/municipality_employee_screen.dart';

class EsigninScreen extends StatefulWidget {
  static const String screenroot = 'esignin_screen';
  
  const EsigninScreen({super.key});

  @override
  State<EsigninScreen> createState() => _EsigninScreenState();
}

class _EsigninScreenState extends State<EsigninScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _selectedDepartment; // حقل جديد لتخزين التخصص

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentBackground = 0;
  final List<String> _backgrounds = [
    'assets/bg1.svg',
    'assets/bg2.svg',
    'assets/bg3.svg',
  ];

  // قائمة التخصصات المتاحة
  final List<String> _departments = ['ماء', 'كهرباء', 'بلدية'];

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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => _isLoading = false);

        // التوجيه إلى الشاشة المناسبة حسب التخصص
        if (_selectedDepartment == 'ماء') {
          Navigator.pushNamed(context, WaterEmployeeScreen.screenRoute);
        } else if (_selectedDepartment == 'كهرباء') {
          Navigator.pushNamed(context, ElectricityEmployeeScreen.screenRoute);
        } else if (_selectedDepartment == 'بلدية') {
          Navigator.pushNamed(context, MunicipalityEmployeeScreen.screenRoute);
        } else {
          // إذا لم يتم اختيار تخصص، يتم التوجيه إلى الشاشة الافتراضية
          Navigator.pushNamed(context, UserThing.screenRoot);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية المتدرجة مع SVG
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

          // تأثير ضبابي
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: Colors.transparent),
          ),

          // المحتوى الرئيسي
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
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.only(bottom: 30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 8, 93, 99),
                                    Color.fromARGB(255, 1, 17, 27),
                                  ],
                                ),
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
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.asset(
                                      'images/lbbb.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    style: theme.textTheme.headlineMedium!
                                        .copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'Tajawal',
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: theme.primaryColor
                                                  .withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                    child: const Text('تسجيل دخول الموظفين'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // حقل اختيار التخصص
                                _buildDepartmentDropdown(),
                                const SizedBox(height: 20),

                                // حقل البريد الإلكتروني
                                _buildTextField(
                                  controller: _emailController,
                                  hintText: 'البريد الإلكتروني',
                                  icon: Icons.email,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال البريد الإلكتروني';
                                    }
                                    if (!value.contains('@')) {
                                      return 'بريد إلكتروني غير صالح';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // حقل كلمة المرور
                                _buildTextField(
                                  controller: _passwordController,
                                  hintText: 'كلمة المرор',
                                  icon: Icons.lock,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    }
                                    if (value.length < 6) {
                                      return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),

                                // رابط نسيت كلمة المرور
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'نسيت كلمة المرور؟',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),

                                // زر تسجيل الدخول
                                _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : _buildEnhancedAuthButton(
                                        context,
                                        icon: Icons.login,
                                        label: 'تسجيل الدخول',
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 17, 126, 117),
                                            Color.fromARGB(255, 16, 78, 88),
                                          ],
                                        ),
                                        onPressed: _signIn,
                                      ),
                              ],
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
                      Colors.transparent,
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

  Widget _buildDepartmentDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedDepartment,
        decoration: InputDecoration(
          hintText: 'اختر التخصص',
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontFamily: 'Tajawal',
          ),
          prefixIcon: const Icon(Icons.work, color: Colors.white70),
          filled: true,
          fillColor: const Color.fromARGB(255, 17, 126, 117).withOpacity(0.7),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
        style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
        dropdownColor: const Color.fromARGB(255, 17, 126, 117),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        items: _departments.map((String department) {
          return DropdownMenuItem<String>(
            value: department,
            child: Text(department),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedDepartment = newValue;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء اختيار التخصص';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.right,
        style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontFamily: 'Tajawal',
          ),
          prefixIcon: Icon(icon, color: Colors.white70),
          filled: true,
          fillColor: const Color.fromARGB(255, 17, 126, 117).withOpacity(0.7),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 1,
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
          child: Container(
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
    );
  }
}

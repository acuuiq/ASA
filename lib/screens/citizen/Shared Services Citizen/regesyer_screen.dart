import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/user_main_screen.dart';
import 'package:mang_mu/widgets/my_buttn.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class RegesyerScreen extends StatefulWidget {
  static const String screenRoot = 'Regesyer_screen';

  const RegesyerScreen({super.key});

  @override
  State<RegesyerScreen> createState() => _RegesyerScreenState();
}

class _RegesyerScreenState extends State<RegesyerScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  File? _frontIdentityImage;
  File? _backIdentityImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

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
  bool _isProfileOpen = false;
  late AnimationController _profileController;
  late Animation<double> _profileAnimation;

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

    _profileController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _profileAnimation = CurvedAnimation(
      parent: _profileController,
      curve: Curves.easeInOut,
    );

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
    _accountController.dispose();
    _codeController.dispose();
    _fullNameController.dispose();
    _idNumberController.dispose();
    _controller.dispose();
    _profileController.dispose();
    super.dispose();
  }

  void _toggleProfile() {
    setState(() {
      _isProfileOpen = !_isProfileOpen;
      if (_isProfileOpen) {
        _profileController.forward();
      } else {
        _profileController.reverse();
      }
    });
  }

  Future<void> _pickImage(bool isFront) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 90,
    );

    if (image != null) {
      setState(() {
        if (isFront) {
          _frontIdentityImage = File(image.path);
        } else {
          _backIdentityImage = File(image.path);
        }
      });
    }
  }

  void _removeImage(bool isFront) {
    setState(() {
      if (isFront) {
        _frontIdentityImage = null;
      } else {
        _backIdentityImage = null;
      }
    });
  }

  Future<bool> _createAccount() async {
    User? user;

    try {
      print('بدء إنشاء الحساب في Supabase...');

      final email = _accountController.text.trim();
      final password = _codeController.text.trim();
      final fullName = _fullNameController.text.trim();
      final idNumber = _idNumberController.text.trim();

      // التحقق من صحة البيانات
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        _showError('البريد الإلكتروني غير صحيح');
        return false;
      }

      if (password.length < 6) {
        _showError('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
        return false;
      }

      // 1. إنشاء المستخدم في مصادقة Supabase
      print('إنشاء مستخدم في مصادقة Supabase...');
      final AuthResponse authResponse = await Supabase.instance.client.auth
          .signUp(email: email, password: password);

      user = authResponse.user;
      if (user == null) {
        _showError('فشل في إنشاء المستخدم');
        return false;
      }

      print('تم إنشاء المستخدم: ${user.id}');

      // الانتظار قليلاً لضمان توفر الجلسة
      await Future.delayed(Duration(milliseconds: 500));

      // 2. رفع الصور إلى تخزين Supabase
      String frontImageUrl = '';
      String backImageUrl = '';

      if (_frontIdentityImage != null) {
        try {
          frontImageUrl = await _uploadImageToSupabase(
            _frontIdentityImage!,
            'front',
            user.id,
          );
          print('تم رفع الصورة الأمامية بنجاح');
        } catch (e) {
          print('خطأ في رفع الصورة الأمامية: $e');
          _showError('فشل في رفع صورة الهوية الأمامية. يرجى المحاولة مرة أخرى');
          return false;
        }
      }

      if (_backIdentityImage != null) {
        try {
          backImageUrl = await _uploadImageToSupabase(
            _backIdentityImage!,
            'back',
            user.id,
          );
          print('تم رفع الصورة الخلفية بنجاح');
        } catch (e) {
          print('خطأ في رفع الصورة الخلفية: $e');
          _showError('فشل في رفع صورة الهوية الخلفية. يرجى المحاولة مرة أخرى');
          return false;
        }
      }

      // 3. حفظ البيانات في جدول profiles
      try {
        final insertData = {
          'id': user.id,
          'full_name': fullName,
          'id_number': idNumber,
          'email': email,
          'front_id_image': frontImageUrl,
          'back_id_image': backImageUrl,
          'user_type': 'citizen',
          'status': 'under_review',
          'created_at': DateTime.now().toIso8601String(),
        };

        await Supabase.instance.client
            .from('profiles')
            .insert(insertData);
        print('تم حفظ بيانات المستخدم في جدول profiles بنجاح');
      } catch (e) {
        print('خطأ في حفظ البيانات في جدول profiles: $e');
        _showError('فشل في حفظ البيانات. يرجى المحاولة مرة أخرى');
        return false;
      }

      print('تم إنشاء الحساب بنجاح!');
      
      _navigateToNextScreen();
      return true;

    } on AuthException catch (e) {
      print('Supabase Auth Error: ${e.message}');
      _handleSupabaseError(e);
      return false;
    } catch (e) {
      print('General Error: $e');
      _showError('حدث خطأ غير متوقع: ${e.toString()}');

      // التحقق من البيانات فقط إذا تم إنشاء المستخدم
      if (user != null) {
        await _checkUserData(user.id);
      }

      return false;
    }
  }

  Future<void> _checkUserData(String userId) async {
    try {
      final data = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId);
      
      if (data != null && data.isNotEmpty) {
        print('بيانات المستخدم في الجدول: $data');
      } else {
        print('المستخدم غير موجود في جدول profiles');
      }
    } catch (e) {
      print('خطأ في التحقق من البيانات: $e');
    }

    // التحقق من الصور في التخزين
    try {
      final storageObjects = await Supabase.instance.client.storage
          .from('employee_documents')
          .list();

      print('الملفات في التخزين: ${storageObjects.length} ملف');

      // عرض الملفات الخاصة بهذا المستخدم
      final userFiles = storageObjects
          .where((file) => file.name.contains(userId))
          .toList();

      print('ملفات المستخدم: ${userFiles.map((f) => f.name).toList()}');
    } catch (e) {
      print('خطأ في التحقق من التخزين: $e');
    }
  }

  Future<String> _uploadImageToSupabase(
    File image,
    String fileType,
    String userId,
  ) async {
    try {
      print('بدء رفع الصورة إلى Supabase...');

      // استخدام مفتاح service_role للرفع دون الحاجة لجلسة مستخدم
      final supabaseAdmin = SupabaseClient(
        'https://xuwxgjiewdlzzpgzvpxb.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh1d3hnamlld2RsenpwZ3p2cHhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4Mzc5MTIsImV4cCI6MjA3MjQxMzkxMn0.i1CD1NxOM7XDoViqSmyb4ECT7uKZFJPFbzjorscInRY',
      );

      // إنشاء مسار في مجلد المستخدم
      final String fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileType.jpg';

      // قراءة ملف الصورة كبايتس
      final bytes = await image.readAsBytes();

      // رفع الملف باستخدام service_role
      final response = await supabaseAdmin.storage
          .from('employee_documents')
          .uploadBinary(
            fileName, 
            bytes, 
            fileOptions: FileOptions(
              contentType: 'image/jpeg',
              upsert: false,
            ),
          );

      // الحصول على رابط التحميل العام
      final String publicUrl = supabaseAdmin.storage
          .from('employee_documents')
          .getPublicUrl(fileName);

      print('تم رفع الصورة بنجاح: $publicUrl');
      
      // إغلاق الاتصال
      await supabaseAdmin.dispose();
      
      return publicUrl;
    } catch (e) {
      print('Error uploading image to Supabase: $e');
      throw Exception('فشل في رفع الصورة: $e');
    }
  }

  void _navigateToNextScreen() {
    if (mounted) {
      // استخدام Navigator.pushNamed مباشرة
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserMainScreen.screenRoot,
        (route) => false,
        arguments: {
          'showSuccessMessage': true,
          'message': 'تم إنشاء الحساب بنجاح. انتظر حتى يتم التأكد منه',
        },
      );
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(fontFamily: 'Tajawal')),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _handleSupabaseError(AuthException e) {
    String errorMessage = 'حدث خطأ أثناء إنشاء الحساب';

    switch (e.message) {
      case 'User already registered':
        errorMessage = 'الحساب موجود مسبقاً';
        break;
      case 'Invalid email':
        errorMessage = 'البريد الإلكتروني غير صحيح';
        break;
      case 'Email not confirmed':
        errorMessage = 'البريد الإلكتروني لم يتم تأكيده';
        break;
      default:
        errorMessage = 'خطأ في المصادقة: ${e.message}';
    }

    _showError(errorMessage);
  }

  


  Widget _buildImagePreview(File? image, bool isFront) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(255, 17, 126, 117).withOpacity(0.3),
            border: Border.all(
              color: const Color.fromARGB(255, 17, 126, 117),
              width: 2,
            ),
            image: image != null
                ? DecorationImage(image: FileImage(image), fit: BoxFit.cover)
                : null,
          ),
          child: image == null
              ? const Icon(Icons.photo_camera, size: 50, color: Colors.white70)
              : null,
        ),
        if (image != null)
          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeImage(isFront),
            ),
          ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(1, _currentStep >= 0),
        _buildStepLine(),
        _buildStepCircle(2, _currentStep >= 1),
        _buildStepLine(),
        _buildStepCircle(3, _currentStep >= 2),
        _buildStepLine(),
        _buildStepCircle(4, _currentStep >= 3),
      ],
    );
  }

  Widget _buildStepCircle(int step, bool isActive) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? const Color.fromARGB(255, 17, 126, 117)
            : Colors.grey[400],
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStepLine() {
    return Container(width: 50, height: 2, color: Colors.grey[300]);
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
                    vertical: 20,
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
                              margin: const EdgeInsets.only(bottom: 20),
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
                                    child: const Text('تسجيل حساب مواطن جديد'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      _buildStepIndicator(),

                      const SizedBox(height: 30),

                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                if (_currentStep == 0) ...[
                                  _buildTextField(
                                    controller: _fullNameController,
                                    label: 'الاسم الرباعي',
                                    icon: Icons.person_outline,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال الاسم الرباعي';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  _buildTextField(
                                    controller: _idNumberController,
                                    label: 'رقم الهوية',
                                    icon: Icons.credit_card_outlined,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال رقم الهوية';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 30),
                                  _buildEnhancedAuthButton(
                                    context,
                                    icon: Icons.arrow_forward,
                                    label: 'التالي',
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 17, 126, 117),
                                        Color.fromARGB(255, 16, 78, 88),
                                      ],
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => _currentStep = 1);
                                      }
                                    },
                                  ),
                                ] else if (_currentStep == 1) ...[
                                  _buildTextField(
                                    controller: _accountController,
                                    label: 'الحساب',
                                    icon: Icons.account_circle_outlined,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال الحساب';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  _buildTextField(
                                    controller: _codeController,
                                    label: 'الرمز السري',
                                    icon: Icons.lock_outline,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال الرمز السري';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildEnhancedAuthButton(
                                          context,
                                          icon: Icons.arrow_back,
                                          label: 'السابق',
                                          gradient: const LinearGradient(
                                            colors: [Colors.grey, Colors.grey],
                                          ),
                                          onPressed: () =>
                                              setState(() => _currentStep = 0),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: _buildEnhancedAuthButton(
                                          context,
                                          icon: Icons.arrow_forward,
                                          label: 'التالي',
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 17, 126, 117),
                                              Color.fromARGB(255, 16, 78, 88),
                                            ],
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() => _currentStep = 2);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else if (_currentStep == 2) ...[
                                  Text(
                                    'صورة الهوية من الأمام',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildImagePreview(_frontIdentityImage, true),
                                  const SizedBox(height: 20),
                                  _buildEnhancedAuthButton(
                                    context,
                                    icon: Icons.camera_alt,
                                    label: 'اختر صورة الهوية من الأمام',
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 17, 126, 117),
                                        Color.fromARGB(255, 16, 78, 88),
                                      ],
                                    ),
                                    onPressed: () => _pickImage(true),
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    'صورة الهوية من الخلف',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildImagePreview(_backIdentityImage, false),
                                  const SizedBox(height: 20),
                                  _buildEnhancedAuthButton(
                                    context,
                                    icon: Icons.camera_alt,
                                    label: 'اختر صورة الهوية من الخلف',
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 17, 126, 117),
                                        Color.fromARGB(255, 16, 78, 88),
                                      ],
                                    ),
                                    onPressed: () => _pickImage(false),
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildEnhancedAuthButton(
                                          context,
                                          icon: Icons.arrow_back,
                                          label: 'السابق',
                                          gradient: const LinearGradient(
                                            colors: [Colors.grey, Colors.grey],
                                          ),
                                          onPressed: () =>
                                              setState(() => _currentStep = 1),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: _buildEnhancedAuthButton(
                                          context,
                                          icon: Icons.arrow_forward,
                                          label: 'التالي',
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 17, 126, 117),
                                              Color.fromARGB(255, 16, 78, 88),
                                            ],
                                          ),
                                          onPressed: () {
                                            if (_frontIdentityImage == null ||
                                                _backIdentityImage == null) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'الرجاء تحميل صور الهوية',
                                                    style: TextStyle(
                                                      fontFamily: 'Tajawal',
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              setState(() => _currentStep = 3);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else if (_currentStep == 3) ...[
                                  Text(
                                    'مراجعة المعلومات',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  _buildReviewCard(),
                                  const SizedBox(height: 30),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildEnhancedAuthButton(
                                          context,
                                          icon: Icons.arrow_back,
                                          label: 'السابق',
                                          gradient: const LinearGradient(
                                            colors: [Colors.grey, Colors.grey],
                                          ),
                                          onPressed: () =>
                                              setState(() => _currentStep = 2),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _isLoading
                                            ? Center(
                                                child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(
                                                        const Color.fromARGB(
                                                          255,
                                                          17,
                                                          126,
                                                          117,
                                                        ),
                                                      ),
                                                ),
                                              )
                                            : _buildEnhancedAuthButton(
                                                context,
                                                icon: Icons.check,
                                                label: 'إنشاء الحساب',
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                      255,
                                                      17,
                                                      126,
                                                      117,
                                                    ),
                                                    Color.fromARGB(
                                                      255,
                                                      16,
                                                      78,
                                                      88,
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    setState(
                                                      () => _isLoading = true,
                                                    );

                                                    try {
                                                      await _createAccount();
                                                    } finally {
                                                      if (mounted) {
                                                        setState(
                                                          () => _isLoading =
                                                              false,
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 30),
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

          // مؤشر التحميل
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color.fromARGB(255, 17, 126, 117),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
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
        style: TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.white70, fontFamily: 'Tajawal'),
          prefixIcon: Icon(icon, color: Colors.white70),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 17, 126, 117).withOpacity(0.7),
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

  Widget _buildReviewCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color.fromARGB(255, 17, 126, 117).withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildReviewRow('الاسم الرباعي', _fullNameController.text),
            const Divider(height: 30, color: Colors.white30),
            _buildReviewRow('رقم الهوية', _idNumberController.text),
            const Divider(height: 30, color: Colors.white30),
            _buildReviewRow('الحساب', _accountController.text),
            const Divider(height: 30, color: Colors.white30),
            _buildReviewRow('الرمز السري', '••••••••'),
            const Divider(height: 30, color: Colors.white30),
            _buildReviewRow(
              'صورة الهوية من الأمام',
              _frontIdentityImage != null ? 'تم التحميل' : 'غير محملة',
              isUploaded: _frontIdentityImage != null,
            ),
            const Divider(height: 30, color: Colors.white30),
            _buildReviewRow(
              'صورة الهوية من الخلف',
              _backIdentityImage != null ? 'تم التحميل' : 'غير محملة',
              isUploaded: _backIdentityImage != null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewRow(
    String label,
    String value, {
    bool isUploaded = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Tajawal',
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                color: isUploaded ? Colors.white : Colors.white70,
                fontFamily: 'Tajawal',
              ),
            ),
            if (isUploaded)
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
          ],
        ),
      ],
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: gradient,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Tajawal',
                    fontSize: 16,
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
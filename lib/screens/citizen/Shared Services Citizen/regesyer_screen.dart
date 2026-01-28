import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/user_main_screen.dart';

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
  File? _selfieImage;
  bool _isCapturingSelfie = false;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _phoneController =
      TextEditingController(); // جديد: حقل رقم الموبايل

  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController _flashController;
  late Animation<double> _flashAnimation;

  final Color _primaryColor = const Color(0xFF0D47A1);
  final Color _secondaryColor = const Color(0xFF1976D2);
  final Color _accentColor = const Color(0xFF64B5F6);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _borderColor = const Color(0xFFE0E0E0);
  final Color _locationColor = const Color(0xFF4CAF50);
  final Color _phoneColor = const Color(0xFF2196F3); // لون خاص بحقل الموبايل

  // قائمة المناطق
  final List<String> _regions = [
    'حي القادسية',
    'حي النصر',
    'حي الحرية',
    'حي البصرة',
    'حي الصحة',
    'حي الجامعة',
    'حي العمال',
    'محلة البو عبيد',
    'محلة البو غرغور (الغرغور)',
    'محلة البو محمد عيسى',
    'محلة البو ناصر',
    'محلة البو شهيل',
    'محلة الحسينية',
    'محلة السادة',
    'محلة البو عبود',
    'محلة البو حمد',
    'المنطقة المركزية (السوق الكبير)',
    'منطقة السدة',
    'محلة البو شهب',
    'محلة البو نجم',
    'محلة البو درويش',
    'حي الزهور',
    'حي الأمل',
    'منطقة القضاء (حول مركز الناحية)',
    'شارع المستشفى',
    'الشنافية',
    'أبو حمزة (البو حمزة)',
    'الكرادة',
    'الدلمج (ومشروع الدلمج الزراعي)',
    'الخضر',
    'أبو جميجمة',
    'النصرية الصغيرة',
    'البدعة',
    'الجرن',
    'الهرامة',
    'الجعافرة',
    'الطاهرية',
    'الطليعة',
    'كريزة',
    'الخرابة',
    'الشحيمية',
    'الطرف',
    'النهير',
    'المجر الكبير',
    'المجر الصغير',
    'السلام',
    'أبو عطيوي (البو عطيوي)',
    'الزوية',
    'أبو حلوفة (البو حلوفة)',
    'الشارع',
    'المنصورية',
    'البرك',
    'الحدادة',
    'الهرم',
    'الهرية',
    'الزيدية',
    'الرفاعية',
    'المكورة',
    'الرشيدية',
    'السودان',
    'العلوة',
    'المالحية',
    'أبو صخير (البو صخير)',
    'الشحنة',
    'الجديدة',
    'العكيكة',
    'أبو غريب (البو غريب) - محلي',
    'السلمان',
  ];

  @override
  void initState() {
    super.initState();

    print('InitState called');

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

    _flashController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _flashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _accountController.dispose();
    _codeController.dispose();
    _fullNameController.dispose();
    _idNumberController.dispose();
    _houseNumberController.dispose();
    _locationController.dispose();
    _phoneController.dispose(); // جديد
    _controller.dispose();
    _flashController.dispose();
    super.dispose();
  }

  // حذف جميع دوال GPS والموقع

  Future<void> _pickImage(bool isFront) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 90,
      );

      if (image != null && mounted) {
        setState(() {
          if (isFront) {
            _frontIdentityImage = File(image.path);
          } else {
            _backIdentityImage = File(image.path);
          }
        });
      }
    } catch (e) {
      print('خطأ في اختيار الصورة: $e');
    }
  }

  void _removeImage(bool isFront) {
    if (mounted) {
      setState(() {
        if (isFront) {
          _frontIdentityImage = null;
        } else {
          _backIdentityImage = null;
        }
      });
    }
  }

  Future<void> _captureSelfie() async {
    if (mounted) {
      setState(() => _isCapturingSelfie = true);
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 90,
      );

      if (mounted) {
        setState(() => _isCapturingSelfie = false);
      }

      if (image != null) {
        _flashController.forward(from: 0);
        await Future.delayed(Duration(milliseconds: 300));
        _flashController.reverse();

        if (mounted) {
          setState(() {
            _selfieImage = File(image.path);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCapturingSelfie = false);
      }
      print('خطأ في التقاط السيلفي: $e');
    }
  }

  void _removeSelfie() {
    if (mounted) {
      setState(() {
        _selfieImage = null;
      });
    }
  }

  void _showRegionSelectionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'اختر المنطقة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: _regions.length,
                  itemBuilder: (context, index) {
                    final region = _regions[index];
                    return ListTile(
                      title: Text(
                        region,
                        style: TextStyle(fontFamily: 'Tajawal', fontSize: 14),
                      ),
                      trailing: _locationController.text == region
                          ? Icon(Icons.check, color: _primaryColor)
                          : null,
                      onTap: () {
                        setState(() {
                          _locationController.text = region;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _createAccount() async {
    try {
      print('بدء إنشاء الحساب...');

      final email = _accountController.text.trim();
      final password = _codeController.text.trim();
      final fullName = _fullNameController.text.trim();
      final idNumber = _idNumberController.text.trim();
      final houseNumber = _houseNumberController.text.trim();
      final location = _locationController.text.trim();
      final phone = _phoneController.text.trim(); // جديد

      if (phone.isEmpty) {
        // جديد
        _showError('الرجاء إدخال رقم الموبايل');
        return false;
      }
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        _showError('البريد الإلكتروني غير صحيح');
        return false;
      }

      if (password.length < 6) {
        _showError('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
        return false;
      }

      if (location.isEmpty) {
        _showError('الرجاء اختيار المنطقة');
        return false;
      }

      final AuthResponse authResponse = await Supabase.instance.client.auth
          .signUp(email: email, password: password);

      final user = authResponse.user;
      if (user == null) {
        _showError('فشل في إنشاء المستخدم');
        return false;
      }

      await Future.delayed(Duration(milliseconds: 500));

      String frontImageUrl = '';
      String backImageUrl = '';
      String selfieImageUrl = '';

      if (_frontIdentityImage != null) {
        try {
          frontImageUrl = await _uploadImageToSupabase(
            _frontIdentityImage!,
            'front',
            user.id,
          );
        } catch (e) {
          print('خطأ في رفع الصورة الأمامية: $e');
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
        } catch (e) {
          print('خطأ في رفع الصورة الخلفية: $e');
          return false;
        }
      }

      if (_selfieImage != null) {
        try {
          selfieImageUrl = await _uploadImageToSupabase(
            _selfieImage!,
            'selfie',
            user.id,
          );
        } catch (e) {
          print('خطأ في رفع صورة السيلفي: $e');
          return false;
        }
      }

      // إضافة الحقول الجديدة
      final insertData = {
        'id': user.id,
        'full_name': fullName,
        'id_number': idNumber,
        'email': email,
        'phone': phone, // جديد
        'house_number': houseNumber,
        'location': location,
        'front_id_image': frontImageUrl,
        'back_id_image': backImageUrl,
        'selfie_image': selfieImageUrl,
        'user_type': 'citizen',
        'status': 'under_review',
        'created_at': DateTime.now().toIso8601String(),
      };

      await Supabase.instance.client.from('profiles').insert(insertData);

      _navigateToNextScreen();
      return true;
    } catch (e) {
      print('خطأ عام: $e');
      _showError('حدث خطأ: $e');
      return false;
    }
  }

  Future<String> _uploadImageToSupabase(
    File image,
    String fileType,
    String userId,
  ) async {
    try {
      final supabaseAdmin = SupabaseClient(
        'https://xuwxgjiewdlzzpgzvpxb.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh1d3hnamlld2RsenpwZ3p2cHhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4Mzc5MTIsImV4cCI6MjA3MjQxMzkxMn0.i1CD1NxOM7XDoViqSmyb4ECT7uKZFJPFbzjorscInRY',
      );

      final String fileName =
          '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileType.jpg';
      final bytes = await image.readAsBytes();

      await supabaseAdmin.storage
          .from('employee_documents')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(contentType: 'image/jpeg', upsert: false),
          );

      final String publicUrl = supabaseAdmin.storage
          .from('employee_documents')
          .getPublicUrl(fileName);

      await supabaseAdmin.dispose();

      return publicUrl;
    } catch (e) {
      throw Exception('فشل في رفع الصورة: $e');
    }
  }

  void _navigateToNextScreen() {
    if (mounted) {
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
          backgroundColor: _errorColor,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(fontFamily: 'Tajawal')),
          backgroundColor: _successColor,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildImagePreview(File? image, bool isFront) {
    return Container(
      height: 140,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _primaryColor.withOpacity(0.1),
        border: Border.all(color: _primaryColor, width: 1.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_camera, size: 40, color: _textSecondaryColor),
                SizedBox(height: 8),
                Text(
                  isFront ? 'الصورة الأمامية' : 'الصورة الخلفية',
                  style: TextStyle(
                    fontSize: 12,
                    color: _textSecondaryColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),

          if (image != null)
            Positioned(
              top: 4,
              left: 4,
              child: GestureDetector(
                onTap: () => _removeImage(isFront),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(Icons.close, size: 16, color: _errorColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelfiePreview() {
    return Container(
      height: 220,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _primaryColor.withOpacity(0.05),
        border: Border.all(color: _primaryColor, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_selfieImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                _selfieImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.face,
                    size: 40,
                    color: _primaryColor.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'لم يتم التقاط صورة سيلفي بعد',
                  style: TextStyle(
                    fontSize: 13,
                    color: _textSecondaryColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),

          AnimatedBuilder(
            animation: _flashAnimation,
            builder: (context, child) {
              return Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(_flashAnimation.value * 0.7),
                ),
              );
            },
          ),

          if (_selfieImage != null)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: _removeSelfie,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(Icons.close, size: 18, color: _errorColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final List<String> stepTitles = [
      'البيانات',
      'الحساب',
      'الهوية',
      'السيلفي',
      'المراجعة',
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentStep >= index
                      ? _primaryColor
                      : Colors.grey[300],
                  border: Border.all(
                    color: _currentStep >= index
                        ? _primaryColor
                        : const Color.fromARGB(255, 189, 189, 189),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      color: _currentStep >= index
                          ? Colors.white
                          : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stepTitles.map((title) {
              final index = stepTitles.indexOf(title);
              return Container(
                width: 60,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: _currentStep >= index
                        ? _primaryColor
                        : Colors.grey[600],
                    fontFamily: 'Tajawal',
                    fontWeight: _currentStep >= index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تحديد الموقع',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textColor,
            fontFamily: 'Tajawal',
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _borderColor),
            color: Colors.white,
          ),
          child: InkWell(
            onTap: () => _showRegionSelectionDialog(),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _locationController.text.isEmpty
                                ? 'انقر لاختيار المنطقة'
                                : _locationController.text,
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: _locationController.text.isEmpty
                                  ? _textSecondaryColor
                                  : _textColor,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: _locationController.text.isEmpty
                              ? _textSecondaryColor
                              : _primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        if (_locationController.text.isNotEmpty)
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _locationColor.withOpacity(0.1),
              border: Border.all(color: _locationColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: _locationColor, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _locationController.text,
                    style: TextStyle(
                      fontSize: 12,
                      color: _textColor,
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _locationController.clear();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _errorColor.withOpacity(0.1),
                    ),
                    child: Icon(Icons.close, size: 16, color: _errorColor),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Build called - Current step: $_currentStep');

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // الشعار والعنوان
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'إنشاء حساب جديد',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: _primaryColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'املأ البيانات التالية',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Tajawal',
                      color: _textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // مؤشر الخطوات
            _buildStepIndicator(),

            // المحتوى الرئيسي
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        SizedBox(height: 16),
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
                            if (value.length != 10) {
                              return 'رقم الهوية يجب أن يكون 10 أرقام';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _houseNumberController,
                          label: 'رقم الدار/المنزل',
                          icon: Icons.home_outlined,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال رقم الدار';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'رقم الموبايل',
                          icon: Icons.phone_android_outlined,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال رقم الموبايل';
                            }
                            if (value.length < 10 || value.length > 15) {
                              return 'رقم الموبايل غير صحيح';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        _buildLocationField(),
                        SizedBox(height: 24),
                        _buildAuthButton(
                          icon: Icons.arrow_forward,
                          label: 'التالي',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_locationController.text.isEmpty) {
                                _showError('الرجاء اختيار المنطقة');
                              } else {
                                setState(() => _currentStep = 1);
                              }
                            }
                          },
                        ),
                      ] else if (_currentStep == 1) ...[
                        _buildTextField(
                          controller: _accountController,
                          label: 'البريد الإلكتروني',
                          icon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return 'البريد الإلكتروني غير صحيح';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _codeController,
                          label: 'كلمة المرور',
                          icon: Icons.lock_outline,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال كلمة المرور';
                            }
                            if (value.length < 6) {
                              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _buildAuthButton(
                                icon: Icons.arrow_back,
                                label: 'السابق',
                                isSecondary: true,
                                onPressed: () =>
                                    setState(() => _currentStep = 0),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildAuthButton(
                                icon: Icons.arrow_forward,
                                label: 'التالي',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _currentStep = 2);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ] else if (_currentStep == 2) ...[
                        Text(
                          'رفع صور الهوية',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'يرجى رفع صورتين للهوية (أمامية وخلفية)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: _textSecondaryColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        SizedBox(height: 20),

                        Text(
                          'الصورة الأمامية',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _textColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildImagePreview(_frontIdentityImage, true),
                        SizedBox(height: 12),
                        _buildAuthButton(
                          icon: Icons.camera_alt,
                          label: 'اختر الصورة الأمامية',
                          onPressed: () => _pickImage(true),
                        ),

                        SizedBox(height: 24),

                        Text(
                          'الصورة الخلفية',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _textColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildImagePreview(_backIdentityImage, false),
                        SizedBox(height: 12),
                        _buildAuthButton(
                          icon: Icons.camera_alt,
                          label: 'اختر الصورة الخلفية',
                          onPressed: () => _pickImage(false),
                        ),

                        SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _buildAuthButton(
                                icon: Icons.arrow_back,
                                label: 'السابق',
                                isSecondary: true,
                                onPressed: () =>
                                    setState(() => _currentStep = 1),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildAuthButton(
                                icon: Icons.arrow_forward,
                                label: 'التالي',
                                onPressed: () {
                                  if (_frontIdentityImage == null ||
                                      _backIdentityImage == null) {
                                    _showError(
                                      'الرجاء رفع صور الهوية الأمامية والخلفية',
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
                          'التقاط صورة سيلفي',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'يرجى التقاط صورة سيلفي واضحة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: _textSecondaryColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        SizedBox(height: 20),

                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _accentColor.withOpacity(0.1),
                            border: Border.all(
                              color: _accentColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: _warningColor,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'تأكد من وضوح الوجه والإضاءة الجيدة',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _textColor,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),
                        _buildSelfiePreview(),
                        SizedBox(height: 20),

                        _isCapturingSelfie
                            ? Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'جارٍ التقاط الصورة...',
                                      style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        color: _textSecondaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : _buildAuthButton(
                                icon: Icons.camera_alt,
                                label: 'التقاط صورة سيلفي',
                                onPressed: _captureSelfie,
                              ),

                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildAuthButton(
                                icon: Icons.arrow_back,
                                label: 'السابق',
                                isSecondary: true,
                                onPressed: () =>
                                    setState(() => _currentStep = 2),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildAuthButton(
                                icon: _selfieImage != null
                                    ? Icons.check
                                    : Icons.skip_next,
                                label: _selfieImage != null ? 'التالي' : 'تخطي',
                                onPressed: () {
                                  setState(() => _currentStep = 4);
                                },
                              ),
                            ),
                          ],
                        ),
                      ] else if (_currentStep == 4) ...[
                        Text(
                          'مراجعة المعلومات',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'راجع المعلومات قبل إنشاء الحساب',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: _textSecondaryColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        SizedBox(height: 20),

                        Container(
                          height: 420,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            border: Border.all(color: _borderColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ListView(
                            padding: EdgeInsets.all(16),
                            children: [
                              _buildReviewItem(
                                'الاسم الرباعي',
                                _fullNameController.text,
                                Icons.person,
                              ),
                              SizedBox(height: 12),
                              _buildReviewItem(
                                'رقم الهوية',
                                _idNumberController.text,
                                Icons.credit_card,
                              ),
                              SizedBox(height: 12),
                              _buildReviewItem(
                                'رقم الدار/المنزل',
                                _houseNumberController.text,
                                Icons.home,
                              ),
                              SizedBox(height: 12),
                              // --- جديد: حقل رقم الموبايل ---
                              _buildReviewItem(
                                'رقم الموبايل',
                                _phoneController.text,
                                Icons.phone_android,
                              ),
                              SizedBox(height: 12),
                              // --- نهاية الجديد --
                              SizedBox(height: 12),
                              _buildReviewItem(
                                'المنطقة',
                                _locationController.text,
                                Icons.location_on,
                              ),
                              SizedBox(height: 12),
                              _buildReviewItem(
                                'البريد الإلكتروني',
                                _accountController.text,
                                Icons.email,
                              ),
                              SizedBox(height: 12),
                              _buildReviewItem(
                                'كلمة المرور',
                                '••••••••',
                                Icons.lock,
                              ),
                              SizedBox(height: 12),
                              _buildReviewStatus(
                                'صورة الهوية الأمامية',
                                _frontIdentityImage != null,
                                Icons.photo_camera_front,
                              ),
                              SizedBox(height: 12),
                              _buildReviewStatus(
                                'صورة الهوية الخلفية',
                                _backIdentityImage != null,
                                Icons.photo_camera_back,
                              ),
                              SizedBox(height: 12),
                              _buildReviewStatus(
                                'صورة السيلفي',
                                _selfieImage != null,
                                Icons.face,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _buildAuthButton(
                                icon: Icons.arrow_back,
                                label: 'السابق',
                                isSecondary: true,
                                onPressed: () =>
                                    setState(() => _currentStep = 3),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _isLoading
                                  ? Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: _primaryColor.withOpacity(0.1),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                _primaryColor,
                                              ),
                                        ),
                                      ),
                                    )
                                  : _buildAuthButton(
                                      icon: Icons.check,
                                      label: 'إنشاء الحساب',
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() => _isLoading = true);
                                          try {
                                            final success =
                                                await _createAccount();
                                            if (!success && mounted) {
                                              setState(
                                                () => _isLoading = false,
                                              );
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              setState(
                                                () => _isLoading = false,
                                              );
                                            }
                                            _showError('حدث خطأ: $e');
                                          }
                                        }
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ],

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لديك حساب بالفعل؟',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: _textSecondaryColor,
                              fontSize: 12,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                color: _primaryColor,
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      style: TextStyle(fontFamily: 'Tajawal', color: _textColor, fontSize: 14),
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
          fontFamily: 'Tajawal',
          color: _textSecondaryColor,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: _textSecondaryColor, size: 20),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildReviewItem(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _backgroundColor,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _primaryColor.withOpacity(0.1),
            ),
            child: Icon(icon, size: 18, color: _primaryColor),
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
                    color: _textSecondaryColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'غير محدد',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: value.isNotEmpty ? _textColor : _textSecondaryColor,
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStatus(String label, bool isCompleted, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _primaryColor.withOpacity(0.1),
                ),
                child: Icon(icon, size: 18, color: _primaryColor),
              ),
              SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? _successColor.withOpacity(0.1)
                  : _errorColor.withOpacity(0.1),
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.close,
              size: 14,
              color: isCompleted ? _successColor : _errorColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isSecondary = false,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.grey[200] : _primaryColor,
          foregroundColor: isSecondary ? _textColor : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

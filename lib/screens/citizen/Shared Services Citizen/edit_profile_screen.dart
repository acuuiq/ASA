import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'supabase_service.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  final Color primaryColor;
  final Color textColor;
  final Color textSecondaryColor;
  final Function(Map<String, dynamic>) onProfileUpdated;

  const EditProfileScreen({
    super.key,
    required this.userProfile,
    required this.primaryColor,
    required this.textColor,
    required this.textSecondaryColor,
    required this.onProfileUpdated,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _idNumberController;
  late TextEditingController _houseNumberController;
  late TextEditingController _locationController;

  bool _isLoading = false;
  bool _isUploadingImage = false;
  String? _errorMessage;
  File? _newSelfieImage;
  String? _newSelfieUrl; // هذا المتغير يحتاج معالجة خاصة

  @override
  void initState() {
    super.initState();
    // تهيئة الحقول بقيم المستخدم الحالية
    _fullNameController = TextEditingController(
      text: widget.userProfile['full_name'] ?? '',
    );
    _emailController = TextEditingController(
      text: widget.userProfile['email'] ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.userProfile['phone']?.toString() ?? '',
    );
    _idNumberController = TextEditingController(
      text: widget.userProfile['id_number']?.toString() ?? '',
    );
    _houseNumberController = TextEditingController(
      text: widget.userProfile['house_number']?.toString() ?? '',
    );
    _locationController = TextEditingController(
      text: widget.userProfile['location'] ?? '',
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _idNumberController.dispose();
    _houseNumberController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // دالة لالتقاط سيلفي جديد باستخدام الكاميرا
  Future<void> _takeNewSelfie() async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 90,
        maxWidth: 1080,
      );

      if (pickedFile != null) {
        setState(() {
          _newSelfieImage = File(pickedFile.path);
          _isUploadingImage = true;
        });

        // رفع الصورة تلقائياً إلى Supabase
        await _uploadSelfieToSupabase();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'خطأ في الكاميرا: $e';
        _isUploadingImage = false;
      });
    }
  }

  // دالة لرفع الصورة إلى Supabase
  Future<void> _uploadSelfieToSupabase() async {
    if (_newSelfieImage == null) return;

    try {
      final supabaseService = SupabaseService();
      final imageUrl = await supabaseService.uploadSelfie(_newSelfieImage!.path);

      if (imageUrl != null) {
        setState(() {
          _newSelfieUrl = imageUrl;
        });

        // عرض رسالة نجاح
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حفظ صورة السيلفي بنجاح'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل رفع الصورة: $e';
      });
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  // دالة حفظ البيانات - مصححة
  Future<void> _saveProfile() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  try {
    // تجهيز البيانات للتحديث
    final updatedData = {
      'full_name': _fullNameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'id_number': _idNumberController.text.trim(),
      'house_number': _houseNumberController.text.trim(),
      'location': _locationController.text.trim(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    // ✅ التصحيح: استخدام متغير محلي للتحقق من null
    final currentSelfieUrl = _newSelfieUrl;
    if (currentSelfieUrl != null && currentSelfieUrl.isNotEmpty) {
      updatedData['selfie_image'] = currentSelfieUrl;
    }

    // استدعاء Supabase لتحديث البيانات
    final supabaseService = SupabaseService();
    final response = await supabaseService.updateUserProfile(updatedData);

    if (response['success'] == true) {
      // ✅ التصحيح: تحويل Map<dynamic, dynamic> إلى Map<String, dynamic>
      final Map<String, dynamic> responseData = Map<String, dynamic>.from(response['data'] ?? {});
      
      // دمج البيانات الجديدة مع القديمة
      final Map<String, dynamic> newProfile = {
        ...widget.userProfile,
        ...updatedData,
        ...responseData, // ✅ الآن من النوع الصحيح
      };

      // إعادة البيانات المحدثة
      widget.onProfileUpdated(newProfile);

      // العودة للشاشة السابقة
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'تم تحديث الملف الشخصي بنجاح'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } else {
      throw Exception(response['message'] ?? 'فشل تحديث البيانات');
    }
  } catch (e) {
    setState(() {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    });
    
    // عرض رسالة الخطأ
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  // ودجة عرض صورة السيلفي
  Widget _buildSelfieSection() {
    final currentSelfie = widget.userProfile['selfie_image'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صورة السيلفي',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: widget.textColor,
          ),
        ),
        const SizedBox(height: 12),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              // معاينة الصورة
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    color: widget.primaryColor,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(57),
                  child: _isUploadingImage
                      ? Center(
                          child: CircularProgressIndicator(
                            color: widget.primaryColor,
                          ),
                        )
                      : _newSelfieImage != null
                          ? Image.file(_newSelfieImage!, fit: BoxFit.cover)
                          : currentSelfie != null && currentSelfie.toString().isNotEmpty
                              ? Image.network(
                                  currentSelfie.toString(),
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      size: 50,
                                      color: widget.primaryColor,
                                    );
                                  },
                                )
                              : Icon(
                                  Icons.person,
                                  size: 50,
                                  color: widget.primaryColor,
                                ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // زر التقاط سيلفي جديد
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isUploadingImage ? null : _takeNewSelfie,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  icon: const Icon(Icons.camera_alt, size: 20),
                  label: _isUploadingImage
                      ? const Text('جاري الرفع...')
                      : const Text('التقاط سيلفي جديد'),
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                _newSelfieImage != null
                    ? '✅ صورة جديدة جاهزة للحفظ'
                    : 'انقر لالتقاط صورة سيلفي جديدة',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.textSecondaryColor,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: widget.textSecondaryColor),
          prefixIcon: Icon(icon, color: widget.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: widget.primaryColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
          ),
        ),
        style: TextStyle(color: widget.textColor, fontSize: 14),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: widget.primaryColor,
        foregroundColor: Colors.white,
        title: const Text('تعديل الملف الشخصي'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رسالة الخطأ
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // قسم صورة السيلفي
              _buildSelfieSection(),

              // قسم المعلومات الشخصية
              Text(
                'المعلومات الشخصية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              // الحقول
              _buildTextField(
                label: 'الاسم الكامل',
                icon: Icons.person,
                controller: _fullNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الاسم الكامل';
                  }
                  return null;
                },
              ),

              _buildTextField(
                label: 'البريد الإلكتروني',
                icon: Icons.email,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'يرجى إدخال بريد إلكتروني صالح';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),

              _buildTextField(
                label: 'رقم الهاتف',
                icon: Icons.phone,
                controller: _phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم الهاتف';
                  }
                  if (value.length < 8) {
                    return 'رقم الهاتف يجب أن يكون 8 أرقام على الأقل';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
              ),

              _buildTextField(
                label: 'رقم الهوية',
                icon: Icons.credit_card,
                controller: _idNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم الهوية';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),

              _buildTextField(
                label: 'رقم المنزل',
                icon: Icons.home,
                controller: _houseNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم المنزل';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),

              _buildTextField(
                label: 'الموقع',
                icon: Icons.location_on,
                controller: _locationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الموقع';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                maxLines: 2,
              ),

              const SizedBox(height: 32),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isLoading || _isUploadingImage) ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'حفظ التغييرات',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              // زر إلغاء
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: (_isLoading || _isUploadingImage)
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.textSecondaryColor,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
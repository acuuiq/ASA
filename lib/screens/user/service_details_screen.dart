import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'monthly_consumption_screen.dart';
import 'dart:io';
import 'payment_screen.dart'; // تأكد من أن المسار صحيح
import 'package:supabase_flutter/supabase_flutter.dart';
class ServiceDetailsScreen extends StatefulWidget {
  static const String screenroot = '/service-details';
  final String serviceName;
  final Color serviceColor;
  final List<Color> serviceGradient;
  final String serviceTitle;

  const ServiceDetailsScreen({
    super.key,
    required this.serviceName,
    required this.serviceColor,
    required this.serviceGradient,
    required this.serviceTitle,
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: widget.serviceColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.serviceGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.serviceColor.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        title: Text(
          widget.serviceName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            shadows: [
              Shadow(
                blurRadius: 2,
                color: Colors.black12,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    if (widget.serviceName.contains('ضريبة')) {
      return _buildLatePaymentTaxContent();
    } else if (widget.serviceName.contains('هدايا')) {
      return _buildGiftsContent();
    } else if (widget.serviceName.contains('الإبلاغ عن مشكلة')) {
      return _buildProblemReportContent();
    } else if (widget.serviceName.contains('الاستهلاك')) {
      return _buildMonthlyConsumptionContent();
    } else if (widget.serviceName.contains('طارئ') ||
        widget.serviceName.contains('بلاغ')) {
      return _buildEmergencyContent();
    } else if (widget.serviceName.contains('خدمات جانبية مدفوعة') ||
        widget.serviceName.contains('خدمات مميزة')) {
      return _buildPaidServicesContent();
    } else {
      return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 3,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: widget.serviceColor,
              size: 50,
            ),
            const SizedBox(height: 15),
            const Text(
              'تفاصيل الخدمة ستظهر هنا مع إمكانية تنفيذ الإجراء المطلوب مباشرة',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildReportTypeCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3), width: 1),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Icon(Icons.chevron_left, color: Colors.grey[600], size: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProblemReportContent() {
  // تحديد الأيقونة حسب نوع الخدمة
  IconData serviceIcon;
  Color iconColor;
  
  if (widget.serviceTitle.contains('الماء')) {
    serviceIcon = Icons.water_drop;
    iconColor = Colors.blue;
  } else if (widget.serviceTitle.contains('الكهرباء')) {
    serviceIcon = Icons.bolt;
    iconColor = Colors.amber;
  } else if (widget.serviceTitle.contains('النفايات')) {
    serviceIcon = Icons.delete_outline;
    iconColor = Colors.green;
  } else {
    serviceIcon = Icons.help_outline;
    iconColor = Colors.grey;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 10),
      _buildSectionTitle('اختر نوع البلاغ'),
      const SizedBox(height: 10),
      _buildReportTypeCard(
        title: "الإبلاغ عن مشكلة في خدمة ${widget.serviceTitle}",
        icon: serviceIcon, // استخدام الأيقونة المحددة
        color: iconColor,   // استخدام اللون المحدد
        onTap: () => _showServiceProblemReport(),
      ),
      _buildReportTypeCard(
        title: "الإبلاغ عن تقصير الموظفين",
        icon: Icons.people_alt_outlined,
        color: Colors.blue,
        onTap: () => _showEmployeeProblemReport(),
      ),
      _buildReportTypeCard(
        title: "الإبلاغ عن مشكلة في التطبيق",
        icon: Icons.bug_report_outlined,
        color: Colors.red,
        onTap: () => _showAppProblemReport(),
      ),
    ],
  );
}
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: widget.serviceColor,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  void _showServiceProblemReport() {
  final formKey = GlobalKey<FormState>();
  final problemController = TextEditingController();
  String? selectedProblemType;
  List<XFile> attachedImages = [];

  // تحديد أنواع المشاكل حسب الخدمة
  List<String> problemTypes;
  IconData serviceIcon;
  Color serviceColor;

  if (widget.serviceTitle.contains('الماء')) {
    problemTypes = [
      'انقطاع الماء',
      'مشكلة في عدادات الماء',
    
      'جودة المياه',
      'أخرى'
    ];
    serviceIcon = Icons.water_drop;
    serviceColor = Colors.blue;
  } else if (widget.serviceTitle.contains('الكهرباء')) {
    problemTypes = [
      'انقطاع التيار الكهربائي',
      'مشكلة في العدادات',
      'مشكلة في الفولتية',
      'أخطار كهربائية',
      'أخرى'
    ];
    serviceIcon = Icons.bolt;
    serviceColor = Colors.amber;
  } else if (widget.serviceTitle.contains('النفايات')) {
    problemTypes = [
      'عدم جمع النفايات',
      'تسرب من الحاويات',
      'روائح كريهة',
      'حاويات تالفة',
      'أخرى'
    ];
    serviceIcon = Icons.delete_outline;
    serviceColor = Colors.green;
  } else {
    problemTypes = ['مشكلة عامة', 'أخرى'];
    serviceIcon = Icons.help_outline;
    serviceColor = Colors.grey;
  }
    Future<void> takePhoto() async {
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
        if (photo != null) {
          setState(() {
            attachedImages.add(photo);
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء التقاط الصورة: $e')),
        );
      }
    }

    Future<void> pickImage() async {
      try {
        final ImagePicker picker = ImagePicker();
        final List<XFile> images = await picker.pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            attachedImages.addAll(images);
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء اختيار الصور: $e')),
        );
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            width: 60,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'الإبلاغ عن مشكلة في خدمة ${widget.serviceTitle}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDropdownFormField(
                          label: 'نوع المشكلة',
                          value: selectedProblemType,
                          items: problemTypes,
                          onChanged: (value) {
                            setState(() {
                              selectedProblemType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى اختيار نوع المشكلة';
                            }
                            return null;
                          },
                          icon: Icons.help_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: problemController,
                          label: 'وصف المشكلة بالتفصيل',
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال وصف للمشكلة';
                            }
                            return null;
                          },
                          icon: Icons.description,
                        ),
                        const SizedBox(height: 16),
                        _buildImageAttachmentSection(
                          attachedImages: attachedImages,
                          onTakePhoto: takePhoto,
                          onPickImage: pickImage,
                          onRemoveImage: (index) {
                            setState(() {
                              attachedImages.removeAt(index);
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildSubmitButton(
                          color: Colors.purple,
                          text: 'إرسال البلاغ',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              String reportDetails =
                                  '$selectedProblemType: ${problemController.text}';

                              if (attachedImages.isNotEmpty) {
                                reportDetails +=
                                    '\n\nالصور المرفقة: ${attachedImages.length} صورة';
                              }

                              _submitProblemReport(
                                'مشكلة في ${widget.serviceTitle}',
                                reportDetails,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownFormField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        prefixIcon: Icon(icon, color: Colors.grey[600]),
      ),
      value: value,
      items: items.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type, textAlign: TextAlign.right),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      icon: const Icon(Icons.arrow_drop_down),
      isExpanded: true,
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    required String? Function(String?) validator,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        prefixIcon: Icon(icon, color: Colors.grey[600]),
      ),
      maxLines: maxLines,
      validator: validator,
      textAlign: TextAlign.right,
    );
  }

  Widget _buildImageAttachmentSection({
    required List<XFile> attachedImages,
    required VoidCallback onTakePhoto,
    required VoidCallback onPickImage,
    required Function(int) onRemoveImage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'إرفاق صورة (اختياري)',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAttachmentButton(
              icon: Icons.camera_alt,
              label: 'التقاط صورة',
              onPressed: onTakePhoto,
            ),
            _buildAttachmentButton(
              icon: Icons.photo_library,
              label: 'اختيار من المعرض',
              onPressed: onPickImage,
            ),
          ],
        ),
        if (attachedImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'الصور المرفقة:',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: attachedImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(attachedImages[index].path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 5,
                        left: 5,
                        child: InkWell(
                          onTap: () => onRemoveImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAttachmentButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontSize: 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildSubmitButton({
    required Color color,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showEmployeeProblemReport() {
    final formKey = GlobalKey<FormState>();
    final problemController = TextEditingController();
    final employeeNameController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    String? selectedEmployeeType;
    List<XFile> attachedImages = [];

    final List<String> employeeTypes = [
      'موظف الصيانة',
      'موظف الفواتير',
     'موظف استقبال البلاغات',
      'آخر',
    ];

    Future<void> takePhoto() async {
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
        if (photo != null) {
          setState(() {
            attachedImages.add(photo);
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء التقاط الصورة: $e')),
        );
      }
    }

    Future<void> pickImage() async {
      try {
        final ImagePicker picker = ImagePicker();
        final List<XFile> images = await picker.pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            attachedImages.addAll(images);
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء اختيار الصور: $e')),
        );
      }
    }

    Future<void> selectDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 30)),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: widget.serviceColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: widget.serviceColor,
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }

    Future<void> selectTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: widget.serviceColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: widget.serviceColor,
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        timeController.text = picked.format(context);
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            width: 60,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'الإبلاغ عن تقصير الموظفين',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextFormField(
                          controller: employeeNameController,
                          label: 'اسم الموظف (إن عرفته)',
                          maxLines: 1,
                          validator: (value) => null,
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownFormField(
                          label: 'نوع الموظف',
                          value: selectedEmployeeType,
                          items: employeeTypes,
                          onChanged: (value) {
                            setState(() {
                              selectedEmployeeType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى اختيار نوع الموظف';
                            }
                            return null;
                          },
                          icon: Icons.work_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: problemController,
                          label: 'وصف المشكلة بالتفصيل',
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال وصف للمشكلة';
                            }
                            return null;
                          },
                          icon: Icons.description,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'تاريخ ووقت الحادثة',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: dateController,
                                decoration: InputDecoration(
                                  labelText: 'التاريخ',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  prefixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: selectDate,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                ),
                                readOnly: true,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: timeController,
                                decoration: InputDecoration(
                                  labelText: 'الوقت',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  prefixIcon: IconButton(
                                    icon: const Icon(Icons.access_time),
                                    onPressed: selectTime,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                ),
                                readOnly: true,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildImageAttachmentSection(
                          attachedImages: attachedImages,
                          onTakePhoto: takePhoto,
                          onPickImage: pickImage,
                          onRemoveImage: (index) {
                            setState(() {
                              attachedImages.removeAt(index);
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildSubmitButton(
                          color: Colors.blue,
                          text: 'إرسال البلاغ',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              String reportDetails =
                                  '${employeeNameController.text} - '
                                  '$selectedEmployeeType: ${problemController.text}';

                              if (attachedImages.isNotEmpty) {
                                reportDetails +=
                                    '\n\nالصور المرفقة: ${attachedImages.length} صورة';
                              }

                              _submitProblemReport(
                                'تقصير موظفين',
                                reportDetails,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAppProblemReport() {
    final formKey = GlobalKey<FormState>();
    final problemController = TextEditingController();
    final phoneController = TextEditingController();
    String? selectedProblemType;
    XFile? screenshot;

    final List<String> problemTypes = [
      'تعطل في التطبيق',
      'مشكلة في الدفع',
      'واجهة المستخدم',
      'أخرى',
    ];

    Future<void> pickScreenshot() async {
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) {
          setState(() {
            screenshot = image;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء اختيار الصورة: $e')),
        );
      }
    }

    void removeScreenshot() {
      setState(() {
        screenshot = null;
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            width: 60,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'الإبلاغ عن مشكلة في التطبيق',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDropdownFormField(
                          label: 'نوع المشكلة',
                          value: selectedProblemType,
                          items: problemTypes,
                          onChanged: (value) {
                            setState(() {
                              selectedProblemType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى اختيار نوع المشكلة';
                            }
                            return null;
                          },
                          icon: Icons.bug_report_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: problemController,
                          label: 'وصف المشكلة بالتفصيل',
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال وصف للمشكلة';
                            }
                            return null;
                          },
                          icon: Icons.description,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'إرفاق لقطة شاشة (اختياري)',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 8),
                        if (screenshot == null)
                          _buildAttachmentButton(
                            icon: Icons.screenshot,
                            label: 'اختيار لقطة شاشة',
                            onPressed: pickScreenshot,
                          ),
                        if (screenshot != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(File(screenshot!.path)),
                                fit: BoxFit.contain,
                              ),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: removeScreenshot,
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text(
                              'إزالة لقطة الشاشة',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          controller: phoneController,
                          label: 'رقم الهاتف للتواصل (اختياري)',
                          maxLines: 1,
                          validator: (value) => null,
                          icon: Icons.phone,
                        ), 
                        const SizedBox(height: 24),
                        _buildSubmitButton(
                          color: Colors.red,
                          text: 'إرسال البلاغ',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              String reportDetails =
                                  '$selectedProblemType: ${problemController.text}';

                              if (screenshot != null) {
                                reportDetails += '\n\nتم إرفاق لقطة شاشة';
                              }

                              if (phoneController.text.isNotEmpty) {
                                reportDetails +=
                                    '\nرقم التواصل: ${phoneController.text}';
                              }

                              _submitProblemReport(
                                'مشكلة في التطبيق',
                                reportDetails,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _submitProblemReport(String reportType, String description) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 16),
              const Text(
                'تم إرسال البلاغ بنجاح',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'شكراً لك، تم استلام بلاغك وسيتم معالجته في أقرب وقت ممكن.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('نوع البلاغ: $reportType', textAlign: TextAlign.right),
                    const SizedBox(height: 8),
                    Text(
                      'رقم المرجع: #${DateTime.now().millisecondsSinceEpoch}',
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.serviceColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('حسناً', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyConsumptionContent() {
    String imagePath;
    if (widget.serviceTitle.contains('كهرباء') ||
        widget.serviceTitle.contains('electricity')) {
      imagePath = 'images/weo.jpg';
    } else if (widget.serviceTitle.contains('مياه') ||
        widget.serviceTitle.contains('water')) {
      imagePath = 'assets/images/wew.jpg';
    } else {
      imagePath = 'images/wew.jpg';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('الاستهلاك الشهري'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 50),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'اضغط على زر الاستمرار لعرض التفاصيل الكاملة للاستهلاك الشهري',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.serviceColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MonthlyConsumptionScreen(
                  serviceColor: widget.serviceColor,
                  serviceGradient: widget.serviceGradient,
                  serviceTitle: widget.serviceTitle,
                ),
              ),
            );
          },
          child: const Text(
            'عرض التفاصيل',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyContent() {
    String emergencyType = '';
    String instructions = '';
    String contactNumber = '';

    if (widget.serviceTitle == 'الكهرباء') {
      emergencyType = 'انقطاع التيار الكهربائي';
      instructions =
          'في حالة انقطاع التيار الكهربائي المفاجئ:\n\n1. تحقق من قواطع الكهرباء في منزلك\n'
          '2. تأكد من عدم وجود مشكلة في الأجهزة الكهربائية\n'
          '3. تحقق مع الجيران إذا كانت المشكلة عامة\n'
          '4. إذا استمرت المشكلة، اتصل بالطوارئ\n\n'
          '────────────────────\n\n'
          'في حالة التعرض للصعق الكهربائي:\n\n'
          '• لا تلمس الشخص المصاب مباشرة\n'
          '• افصل مصدر الكهرباء فوراً إن أمكن\n'
          '• استخدم مواد غير موصلة لتحريك المصاب\n'
          '• اتصل بالإسعاف فوراً\n'
          '• لا تحرك المصاب إلا للضرورة القصوى';
      contactNumber = '911';
    } else if (widget.serviceTitle == 'الماء') {
      emergencyType = 'تسرب المياه';
      instructions =
          'في حالة اكتشاف تسرب مياه:\n\n1. أغلق صمام المياه الرئيسي فوراً\n2. حاول تحديد مصدر التسرب\n3. نظف المياه المتسربة لتجنب الأضرار\n4. إذا كان التسرب في الأنابيب الرئيسية، اتصل بالطوارئ';
      contactNumber = '911';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('أمر طارئ - $emergencyType'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              Text(
                instructions,
                style: const TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'اتصل بالطوارئ على الرقم:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red[100]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone, color: Colors.red),
              const SizedBox(width: 12),
              Text(
                contactNumber,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'ملاحظة: هذا الرقم مخصص للطوارئ فقط',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLatePaymentTaxContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('ضريبة التأخير في الدفع'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow(
                icon: Icons.calendar_today,
                text: 'آخر موعد للدفع: 15 من كل شهر',
              ),
              const Divider(height: 30),
              _buildInfoRow(
                icon: Icons.money,
                text: 'الحد الأقصى للضريبة: 10% من قيمة الفاتورة',
              ),
              const Divider(height: 30),
              _buildInfoRow(
                icon: Icons.percent,
                text: 'نسبة الضريبة: 1% شهرياً من قيمة الفاتورة',
              ),
              const SizedBox(height: 20),
              const Text(
                'تطبق ضريبة تأخير بنسبة 1% من قيمة الفاتورة عن كل شهر تأخير بعد الموعد النهائي للدفع.',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: widget.serviceColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildGiftsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('الهدايا والعروض الحالية'),
        const SizedBox(height: 16),
        _buildGiftCard(
          title: 'خصم 10%',
          description: 'للمشتركين الذين يدفعون الفواتير قبل الموعد النهائي',
          icon: Icons.discount,
          color: Colors.green,
        ),
        _buildGiftCard(
          title: 'سحب شهري',
          description: 'على جوائز قيمة للمشتركين الملتزمين بالدفع',
          icon: Icons.card_giftcard,
          color: Colors.orange,
        ),
        _buildGiftCard(
          title: 'نقاط مكافآت',
          description: 'يمكن استبدالها بخدمات إضافية أو خصومات',
          icon: Icons.star,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildGiftCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 3,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: color,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaidServicesContent() {
    if (widget.serviceTitle.contains('الكهرباء')) {
      return _buildElectricityPaidServices();
    } else if (widget.serviceTitle.contains('الماء')) {
      return _buildWaterPaidServices();
    } else if (widget.serviceTitle.contains('النفايات')) {
      return _buildWastePaidServices();
    } else {
      return _buildDefaultPaidServices();
    }
  }

  Widget _buildElectricityPaidServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('الخدمات المدفوعة - الكهرباء'),
        const SizedBox(height: 16),
        _buildPaidServiceCard(
          title: 'تركيب عدادات ذكية',
          description: 'تركيب عداد كهرباء ذكي لمراقبة الاستهلاك بدقة',
          price: '150 د.ع',
          duration: '2-4 ساعات',
          icon: Icons.electrical_services,
          color: Colors.blue,
        ),
        _buildPaidServiceCard(
          title: 'فحص وصيانة لوحة الكهرباء',
          description: 'فحص شامل للوحة الكهرباء الرئيسية وإصلاح الأعطال',
          price: '200 د.ع',
          duration: '3-5 ساعات',
          icon: Icons.construction,
          color: Colors.orange,
        ),
        _buildPaidServiceCard(
          title: 'تمديدات كهربائية إضافية',
          description: 'تركيب نقاط كهرباء إضافية في المنزل',
          price: '80 د.ع/نقطة',
          duration: 'حسب الطلب',
          icon: Icons.extension,
          color: Colors.green,
        ),
        _buildPaidServiceCard(
          title: 'تركيب أنظمة الطاقة الشمسية',
          description: 'تركيب نظام طاقة شمسية متكامل للمنازل',
          price: 'يبدأ من 5000 د.ع',
          duration: '1-3 أيام',
          icon: Icons.solar_power,
          color: Colors.yellow[700]!,
        ),
      ],
    );
  }

  Widget _buildWaterPaidServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('الخدمات المدفوعة - الماء'),
        const SizedBox(height: 16),
        _buildPaidServiceCard(
          title: 'تركيب عداد مياه إضافي',
          description: 'تركيب عداد مياه جديد للمنزل أو المزرعة',
          price: '250 د.ع',
          duration: '2-3 ساعات',
          icon: Icons.water_damage,
          color: Colors.blue,
        ),
        _buildPaidServiceCard(
          title: 'كشف تسربات المياه',
          description: 'فحص دقيق لكشف تسربات المياه باستخدام أحدث الأجهزة',
          price: '150 د.ع',
          duration: '1-2 ساعة',
          icon: Icons.search,
          color: Colors.red,
        ),
        _buildPaidServiceCard(
          title: 'تنظيف خزانات المياه',
          description: 'تنظيف وتعقيم خزانات المياه المنزلية',
          price: '300 د.ع',
          duration: '2-4 ساعات',
          icon: Icons.cleaning_services,
          color: Colors.teal,
        ),
        _buildPaidServiceCard(
          title: 'تركيب أنظمة الري الذكية',
          description: 'تصميم وتركيب أنظمة ري ذكية للمساحات الخضراء',
          price: 'يبدأ من 1000 د.ع',
          duration: '1-2 يوم',
          icon: Icons.grass,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildWastePaidServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('الخدمات المدفوعة - النفايات'),
        const SizedBox(height: 16),
        _buildPaidServiceCard(
          title: 'إزالة نفايات البناء',
          description: 'إزالة نفايات البناء والهدم من الموقع',
          price: '500 د.ع/طن',
          duration: 'حسب الكمية',
          icon: Icons.construction,
          color: Colors.brown,
        ),
        _buildPaidServiceCard(
          title: 'تركيب حاويات نفايات كبيرة',
          description: 'توفير حاويات نفايات بسعات مختلفة للإيجار الشهري',
          price: '200 د.ع/شهر',
          duration: 'عقد سنوي',
          icon: Icons.delete_outline,
          color: Colors.grey,
        ),
        _buildPaidServiceCard(
          title: 'تدوير النفايات المنزلية',
          description: 'خدمة فصل وإعادة تدوير النفايات المنزلية',
          price: '100 د.ع/شهر',
          duration: 'زيارة أسبوعية',
          icon: Icons.recycling,
          color: Colors.green,
        ),
        _buildPaidServiceCard(
          title: 'تنظيف مواقع الأحداث',
          description: 'خدمة تنظيف كاملة بعد المناسبات والأحداث',
          price: 'يبدأ من 800 د.ع',
          duration: 'حسب المساحة',
          icon: Icons.event,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildDefaultPaidServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('الخدمات المدفوعة'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.credit_card, color: widget.serviceColor, size: 50),
              const SizedBox(height: 15),
              const Text(
                'الخدمات المدفوعة المتاحة تختلف حسب نوع الخدمة. الرجاء اختيار خدمة محددة لعرض الخيارات المتاحة.',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaidServiceCard({
    required String title,
    required String description,
    required String price,
    required String duration,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: color,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(label: Text(duration), backgroundColor: Colors.grey[100]),
                Chip(
                  label: Text(price),
                  backgroundColor: color.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _showServiceRequestDialog(title),
              child: const Text(
                'طلب الخدمة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // استبدال دالة _showServiceRequestDialog بالكامل بالدالة الجديدة التالية:
void _showServiceRequestDialog(String serviceName) {
  final servicePrice = _getServicePrice(serviceName);
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('طلب خدمة: $serviceName'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('سعر الخدمة: ${servicePrice.toStringAsFixed(2)} د.ع'),
          const SizedBox(height: 16),
          const Text('سيتم حفظ هذه الخدمة في قائمة الخدمات المتاحة'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.serviceColor,
          ),
          onPressed: () async {
            Navigator.pop(context);
            
            // إنشاء خدمة جديدة وحفظها في Supabase
            final newService = ServiceItem(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: serviceName,
              amount: servicePrice,
              color: widget.serviceColor,
              gradient: widget.serviceGradient,
              additionalInfo: 'خدمة متميزة - ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
            );

            // حفظ الخدمة في Supabase
            await _saveServiceToSupabase(newService);
            
            // الانتقال إلى صفحة الدفع
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentScreen(
                  services: [newService],
                  primaryColor: widget.serviceColor,
                  primaryGradient: widget.serviceGradient,
                ),
              ),
            );
          },
          child: const Text('موافق ومتابعة الدفع', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

// دالة لحفظ الخدمة في Supabase
Future<void> _saveServiceToSupabase(ServiceItem service) async {
  try {
    final response = await Supabase.instance.client
        .from('services')
        .insert(service.toMap());

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حفظ الخدمة "${service.name}" في القائمة المتاحة')),
      );
    }
  } catch (e) {
    print('Exception saving service: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('فشل في حفظ الخدمة: $e')),
    );
  }
}
// دالة مساعدة للحصول على سعر الخدمة (ستحتاج لتنفيذها حسب بياناتك)
double _getServicePrice(String serviceName) {
  // هذه قائمة افتراضية - يجب استبدالها ببياناتك الفعلية
  final Map<String, double> servicePrices = {
    'تركيب عدادات ذكية': 150.0,
    'فحص وصيانة لوحة الكهرباء': 200.0,
    'تمديدات كهربائية إضافية': 80.0,
    'تركيب أنظمة الطاقة الشمسية': 5000.0,
    'تركيب عداد مياه إضافي': 250.0,
    'كشف تسربات المياه': 150.0,
    'تنظيف خزانات المياه': 300.0,
    'تركيب أنظمة الري الذكية': 1000.0,
    'إزالة نفايات البناء': 500.0,
    'تركيب حاويات نفايات كبيرة': 200.0,
    'تدوير النفايات المنزلية': 100.0,
    'تنظيف مواقع الأحداث': 800.0,
  };
  
  return servicePrices[serviceName] ?? 100.0; // قيمة افتراضية إذا لم يجد السعر
}
  void _submitServiceRequest({
    required String serviceName,
    required String customerName,
    required String phone,
    required String address,
    required String details,
    required DateTime date,
    required TimeOfDay time,
  }) {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'تم استلام طلبك بنجاح',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'خدمة: $serviceName',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('الاسم: $customerName'),
            Text('الجوال: $phone'),
            Text(
              'الموعد: ${DateFormat.yMd().format(date)} - ${time.format(context)}',
            ),
            const SizedBox(height: 16),
            const Text(
              'سيتم التواصل معك خلال 24 ساعة لتأكيد الموعد والتفاصيل النهائية',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'رقم الطلب: #${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.serviceColor,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

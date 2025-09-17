import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProblemReportScreen extends StatefulWidget {
  static const String screenRoute = '/problem-report';
  final String serviceName;
  final Color serviceColor;
  final List<Color> serviceGradient;
  final String serviceTitle;

  const ProblemReportScreen({
    super.key,
    required this.serviceName,
    required this.serviceColor,
    required this.serviceGradient,
    required this.serviceTitle,
  });

  @override
  State<ProblemReportScreen> createState() => _ProblemReportScreenState();
}

class _ProblemReportScreenState extends State<ProblemReportScreen> {
  
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
    if (widget.serviceName.contains('الإبلاغ عن مشكلة')) {
      return _buildProblemReportContent();
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
          color: iconColor, // استخدام اللون المحدد
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
        'أخرى',
      ];
      serviceIcon = Icons.water_drop;
      serviceColor = Colors.blue;
    } else if (widget.serviceTitle.contains('الكهرباء')) {
      problemTypes = [
        'انقطاع التيار الكهربائي',
        'مشكلة في العدادات',
        'مشكلة في الفولتية',
        'أخرى',
      ];
      serviceIcon = Icons.bolt;
      serviceColor = Colors.amber;
    } else if (widget.serviceTitle.contains('النفايات')) {
      problemTypes = [
        'عدم جمع النفايات',
        'تسرب من الحاويات',
        'روائح كريهة',
        'حاويات تالفة',
        'أخرى',
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
        elevation: 3,
      ),
      onPressed: onPressed,
      child: const Text(
        'إرسال البلاغ',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showEmployeeProblemReport() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                  const Text(
                    'سيتم تطوير هذه الواجهة لاحقاً لتشمل نموذج الإبلاغ عن تقصير الموظفين',
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  _buildSubmitButton(
                    color: Colors.blue,
                    text: 'متابعة',
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('سيتم تطوير هذه الخدمة قريباً'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAppProblemReport() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                  const Text(
                    'سيتم تطوير هذه الواجهة لاحقاً لتشمل نموذج الإبلاغ عن مشاكل التطبيق',
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  _buildSubmitButton(
                    color: Colors.red,
                    text: 'متابعة',
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('سيتم تطوير هذه الخدمة قريباً'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submitProblemReport(String title, String details) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إرسال البلاغ: $title'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
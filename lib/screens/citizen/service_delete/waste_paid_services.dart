import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Shared Services Citizen/payment_screen.dart';
import 'dart:async';
import '../Shared Services Citizen/employee_selection_screen.dart';
import '../Shared Services Citizen/payment_process_screen.dart';
import 'package:intl/intl.dart'; // أضف هذا السطر

class WastePaidServices extends PaidServicesScreen {
  const WastePaidServices({super.key})
    : super(
        serviceName: 'خدمات النفايات المدفوعة',
        serviceColor: const Color(0xFF388E3C),
        serviceGradient: const [
          Color(0xFF388E3C), // استخدم Color مباشرة مع hex
          Color(0xFF4CAF50),
        ],
        serviceTitle: 'النفايات',
      );

  @override
  State<WastePaidServices> createState() => _WastePaidServicesState();
}

class _WastePaidServicesState extends State<WastePaidServices> {
  final SupabaseClient _supabase = Supabase.instance.client; // أضف هذا السطر

  int _currentIndex = 0;

  int _requestedServicesTabIndex = 0; // 🔥 مؤشر جديد للتبويب الداخلي
  Map<String, dynamic> _selectedEmployees = {};
  List<RequestedService> _requestedServices = []; // قائمة الخدمات المطلوبة

  List<RequestedService> _getFilteredServices() {
    switch (_requestedServicesTabIndex) {
      case 0: // الخدمات قيد الانتظار
        return _requestedServices
            .where(
              (service) =>
                  service.status == ServiceStatus.pending ||
                  service.status == ServiceStatus.inProgress,
            )
            .toList();
      case 1: // الخدمات المكتملة
        return _requestedServices
            .where((service) => service.status == ServiceStatus.completed)
            .toList();
      default:
        return _requestedServices;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // في دالة build، قم بتحديث الـ AppBar كالتالي:
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
        actions: [
          _buildNotificationButton(), // 🔥 أضف زر الإشعارات هنا
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildTabItem('الخدمات المدفوعة', 0),
                    _buildTabItem('الخدمات المطلوبة', 1),
                  ],
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildElectricityPaidServices(),
                    ),
                    _buildRequestedServicesTab(),
                  ],
                ),
              ),
            ],
          ),

          // 🔥 لوحة الإشعارات تظهر فوق المحتوى
          if (_showNotifications)
            Positioned(
              top: kToolbarHeight + 8,
              right: 16,
              left: 16,
              child: _buildNotificationsPanel(),
            ),
        ],
      ),
    );
  }
  // أضف هذا في class _ElectricityPaidServicesState

  // 🔥 متغيرات جديدة للإشعارات
  int _notificationCount = 3; // عدد الإشعارات غير المقروءة
  bool _showNotifications = false; // لعرض/إخفاء قائمة الإشعارات

  // 🔥 قائمة الإشعارات الوهمية
  final List<ServiceNotification> _notifications = [
    ServiceNotification(
      id: '1',
      title: 'رد على طلبك للخدمة المخصصة',
      message: 'تم تقديم عرض لخدمة "جمع النفايات المنزلية" بمبلغ 120 د.ع',
      serviceName: 'جمع النفايات المنزلية',
      employeeName: 'أحمد محمد',
      price: 120.0,
      timestamp: 'قبل ساعتين',
      isRead: false,
    ),
    ServiceNotification(
      id: '2',
      title: 'عروض جديدة لخدمتك المخصصة',
      message: '3 عمال تقدموا بعروض لخدمة "تنظيف حاوية النفايات"',
      serviceName: 'تنظيف حاوية النفايات',
      employeeName: 'فريق متعدد',
      price: 85.0,
      timestamp: 'قبل 5 ساعات',
      isRead: false,
    ),
    ServiceNotification(
      id: '3',
      title: 'عرض مقترح لخدمتك',
      message: 'عرض لخدمة "إزالة نفايات البناء" بمبلغ 180 د.ع مع ضمان 6 أشهر',
      serviceName: 'إزالة نفايات البناء',
      employeeName: 'علي حسن',
      price: 180.0,
      timestamp: 'أمس',
      isRead: true,
    ),
  ];

  // 🔥 دالة لبناء زر الإشعارات في AppBar
  Widget _buildNotificationButton() {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.white, size: 28),
          onPressed: () {
            setState(() {
              _showNotifications = !_showNotifications;
              if (_showNotifications) {
                // عند فتح الإشعارات، نعتبر جميع الإشعارات مقروءة
                _notificationCount = 0;
              }
            });
          },
        ),
        if (_notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                _notificationCount > 9 ? '9+' : _notificationCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  // 🔥 دالة لبناء قائمة الإشعارات
  Widget _buildNotificationsPanel() {
    if (!_showNotifications) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // رأس قائمة الإشعارات
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.serviceColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.notifications_active, color: widget.serviceColor),
                SizedBox(width: 8),
                Text(
                  'الإشعارات',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.serviceColor,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Text(
                  'الخدمات المخصصة',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),

          // قائمة الإشعارات
          Container(
            constraints: BoxConstraints(maxHeight: 400),
            child: _notifications.isEmpty
                ? _buildEmptyNotifications()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationItem(_notifications[index]);
                    },
                  ),
          ),

          // زر إغلاق
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.serviceColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _showNotifications = false;
                  });
                },
                child: Text('إغلاق', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 بناء عنصر إشعار فردي
  Widget _buildNotificationItem(ServiceNotification notification) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.grey[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead ? Colors.grey[300]! : Colors.green[200]!,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showNotificationDetails(notification);
          },
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة الإشعار
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? Colors.grey[300]
                        : widget.serviceColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.assignment, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),

                // محتوى الإشعار
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: notification.isRead
                                    ? Colors.grey[700]
                                    : widget.serviceColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            notification.timestamp,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person, size: 12, color: Colors.grey[500]),
                          SizedBox(width: 4),
                          Text(
                            notification.employeeName,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.attach_money,
                            size: 12,
                            color: Colors.green,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${notification.price} د.ع',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔥 بناء واجهة عندما لا توجد إشعارات
  Widget _buildEmptyNotifications() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_off, size: 60, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'لا توجد إشعارات جديدة',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'سيظهر هنا إشعارات الردود على خدماتك المخصصة',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 🔥 دالة لعرض تفاصيل الإشعار
  void _showNotificationDetails(ServiceNotification notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.assignment, color: widget.serviceColor),
              SizedBox(width: 8),
              Text('تفاصيل العرض'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: widget.serviceColor,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  notification.message,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(height: 16),
                _buildDetailRow('الخدمة:', notification.serviceName),
                _buildDetailRow('الفني:', notification.employeeName),
                _buildDetailRow(
                  'السعر المقترح:',
                  '${notification.price} دينار عراقي',
                ),
                _buildDetailRow('الوقت:', notification.timestamp),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'هذا عرض تجريبي. سيتم ربط هذه الخدمة مع النظام الفعلي لاحقاً.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('رفض', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.serviceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                _acceptServiceOffer(notification);
              },
              child: Text('قبول العرض', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  //*ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd

  // 🔥 دالة مساعدة لبناء صف تفاصيل
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              fontSize: 12,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 دالة لقبول عرض الخدمة
  void _acceptServiceOffer(ServiceNotification notification) {
    // هنا سيتم إضافة المنطق الفعلي لقبول العرض
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم قبول عرض الخدمة: ${notification.serviceName}'),
        backgroundColor: Colors.green,
      ),
    );

    // تحديث حالة الإشعار كمقروء
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  // أضف هذا في class _ElectricityPaidServicesState
  final List<Employee> _employees = [
    Employee(
      id: '1',
      name: 'أحمد محمد',
      specialty: 'فني جمع نفايات',
      rating: 4.8,
      completedJobs: 127,
      imageUrl: '',
      skills: ['جمع النفايات', 'فرز النفايات', 'إعادة التدوير'],
      hourlyRate: 25.0,
    ),
    Employee(
      id: '2',
      name: 'علي حسن',
      specialty: 'خبير نظافة عامة',
      rating: 4.6,
      completedJobs: 89,
      imageUrl: '',
      skills: ['تنظيف حاويات', 'تعقيم مناطق', 'إدارة النفايات'],
      hourlyRate: 30.0,
    ),
    Employee(
      id: '3',
      name: 'محمود خالد',
      specialty: 'فني إزالة نفايات',
      rating: 4.9,
      completedJobs: 156,
      imageUrl: '',
      skills: ['إزالة نفايات البناء', 'نقل النفايات', 'تخلص آمن'],
      hourlyRate: 22.0,
    ),
    Employee(
      id: '4',
      name: 'سامي رضا',
      specialty: 'خبير إعادة تدوير',
      rating: 4.7,
      completedJobs: 93,
      imageUrl: '',
      skills: ['فرز النفايات', 'إعادة التدوير', 'إدارة البيئة'],
      hourlyRate: 35.0,
    ),
    Employee(
      id: '5',
      name: 'حسن كريم',
      specialty: 'فني نظافة',
      rating: 4.5,
      completedJobs: 67,
      imageUrl: '',
      skills: ['تنظيف عام', 'جمع النفايات', 'تعقيم مناطق'],
      hourlyRate: 20.0,
    ),
    Employee(
      id: '6',
      name: 'عمر ناصر',
      specialty: 'فني معالجة نفايات',
      rating: 4.8,
      completedJobs: 112,
      imageUrl: '',
      skills: ['معالجة النفايات', 'فرز المواد', 'إعادة التدوير'],
      hourlyRate: 28.0,
    ),
  ];
  // 🔥 استخدام نفس واجهة اختيار الموظفين الكاملة مع دعم الاختيار المتعدد
  void _showMultiEmployeeSelectionForCustomService() {
    final currentSelection = _selectedEmployees['خدمة مخصصة'];
    List<Employee> initialSelection = [];

    // 🔥 التصحيح: التعامل الصحيح مع أنواع البيانات
    if (currentSelection is List<Employee>) {
      initialSelection = List.from(currentSelection);
    } else if (currentSelection is Employee) {
      // إذا كان هناك موظف واحد فقط، ضعه في قائمة
      initialSelection = [currentSelection];
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomEmployeeSelectionScreen(
          serviceTitle: 'خدمة مخصصة',
          primaryColor: widget.serviceColor,
          primaryGradient: widget.serviceGradient,
          initialSelection: initialSelection,
          employees: _employees,
          onEmployeesSelected: (selectedEmployees) {
            // 🔥 التأكد من أن البيانات مرسلة بشكل صحيح
            setState(() {
              _selectedEmployees['خدمة مخصصة'] = selectedEmployees;
            });

            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم اختيار ${selectedEmployees.length} فني للخدمة المخصصة',
                ),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }

  // أضف هذه الدالة المساعدة لبناء النجوم
  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  // 🔥 دالة للتحقق مما إذا قام المستخدم بتقييم الخدمة - محدثة
Future<bool> _hasUserRatedService(String serviceId) async {
  try {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final ratingServiceId = _getRatingServiceId(serviceId);

    final response = await _supabase
        .from('employee_ratings')
        .select()
        .eq('user_id', user.id)
        .eq('service_id', ratingServiceId)
        .maybeSingle();

    return response != null;
  } catch (e) {
    print('❌ خطأ في التحقق من التقييم: $e');
    return false;
  }
}
  void _showRatingDialog(RequestedService service) {
    int selectedRating = 0;
    TextEditingController reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('تقييم الخدمة'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (service.selectedEmployee != null) ...[
                      Text(
                        'الفني: ${service.selectedEmployee!.name}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'التخصص: ${service.selectedEmployee!.specialty}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      SizedBox(height: 16),
                    ],

                    Text(
                      'كيف كانت تجربتك مع الخدمة؟',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 12),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRating = index + 1;
                              });
                            },
                            child: Icon(
                              index < selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 40,
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 16),

                    Text(
                      'تعليق إضافي (اختياري):',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: reviewController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'اكتب تعليقك هنا...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('تخطي', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.serviceColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: selectedRating > 0
                      ? () async {
                          await _saveRating(
                            service,
                            selectedRating,
                            reviewController.text,
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('شكراً لتقييمك الخدمة!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      : null,
                  child: Text(
                    'تأكيد التقييم',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
Future<void> _saveRating(
  RequestedService service,
  int rating,
  String review,
) async {
  try {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final ratingServiceId = _getRatingServiceId(service.id);
    final employeeId = service.selectedEmployee?.id ?? 
                      (service.selectedEmployees?.isNotEmpty == true 
                        ? service.selectedEmployees!.first.id 
                        : 'default_1');
    
    final employeeName = service.selectedEmployee?.name ?? 
                       (service.selectedEmployees?.isNotEmpty == true 
                        ? service.selectedEmployees!.first.name 
                        : 'فريق المياه');
    
    final employeeSpecialty = service.selectedEmployee?.specialty ?? 
                            (service.selectedEmployees?.isNotEmpty == true 
                             ? service.selectedEmployees!.first.specialty 
                             : 'خدمات المياه');

    await _supabase.from('employee_ratings').insert({
      'user_id': user.id,
      'service_id': ratingServiceId,
      'service_name': service.name,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'employee_specialty': employeeSpecialty,
      'rating': rating,
      'review_text': review.isNotEmpty ? review : null,
      'created_at': DateTime.now().toIso8601String(),
    });

    print('✅ تم حفظ التقييم بنجاح للخدمة: ${service.name}');
    
    // 🔥 تحديث الواجهة مباشرة
    setState(() {
      final index = _requestedServices.indexWhere((s) => s.id == service.id);
      if (index != -1) {
        // يمكنك تحديث حالة الخدمة إذا أردت
        // أو إعادة تحميل الخدمات
      }
    });

  } catch (e) {
    print('❌ خطأ في حفظ التقييم: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('حدث خطأ في حفظ التقييم: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
  Widget _buildTabItem(String title, int index) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? widget.serviceColor.withOpacity(0.1)
                : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? widget.serviceColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? widget.serviceColor : Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  // 🔥 تحديث دالة بناء تبويبات الخدمات المطلوبة
  Widget _buildRequestedServicesTab() {
    final filteredServices = _getFilteredServices();

    return Column(
      children: [
        // 🔥 تبويبات الخدمات المطلوبة - تصميم جديد
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              _buildRequestedSubTabItem('قيد الانتظار', 0),
              _buildRequestedSubTabItem('المكتملة', 1),
            ],
          ),
        ),

        if (filteredServices.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _requestedServicesTabIndex == 0
                        ? Icons.access_time
                        : Icons.check_circle,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _requestedServicesTabIndex == 0
                        ? 'لا توجد خدمات قيد الانتظار'
                        : 'لا توجد خدمات مكتملة',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _requestedServicesTabIndex == 0
                        ? 'سيظهر هنا جميع الخدمات قيد الانتظار والتنفيذ'
                        : 'سيظهر هنا جميع الخدمات المكتملة',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              color: widget.serviceColor,
              onRefresh: () async {
                await _loadRequestedServicesFromSupabase();
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredServices.length,
                itemBuilder: (context, index) {
                  final service = filteredServices[index];
                  return _buildRequestedServiceCard(service);
                },
              ),
            ),
          ),
      ],
    );
  }

  //*qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq

  // 🔥 دالة لبناء تبويب فرعي داخل الخدمات المطلوبة - تصميم جديد
  Widget _buildRequestedSubTabItem(String title, int index) {
    final isSelected = _requestedServicesTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _requestedServicesTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? widget.serviceColor : Colors.transparent,
            borderRadius: _getBorderRadius(index),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: widget.serviceColor.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔥 إضافة أيقونة مختلفة لكل تبويب
              if (index == 0) // قيد الانتظار
                Icon(
                  Icons.access_time,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
              if (index == 1) // المكتملة
                Icon(
                  Icons.check_circle,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
              const SizedBox(width: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 دالة مساعدة لتحديد الزوايا المستديرة
  BorderRadius _getBorderRadius(int index) {
    if (index == 0) {
      return const BorderRadius.only(
        topRight: Radius.circular(10),
        bottomRight: Radius.circular(10),
      );
    } else {
      return const BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      );
    }
  }

  Widget _buildRequestedServiceCard(RequestedService service) {
    return FutureBuilder<bool>(
      future: _hasUserRatedService(service.id),
      builder: (context, snapshot) {
        final hasRated = snapshot.data ?? false;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: _getStatusColor(service.status),
                  width: 4,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            service.status,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(service.status),
                          ),
                        ),
                        child: Text(
                          _getStatusText(service.status),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getStatusColor(service.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (service.description != null &&
                      service.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        service.description!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 16, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        '${service.amount} د.ع',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        service.requestDate,
                        style: TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                  if (service.selectedEmployee != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16,
                          color: widget.serviceColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'الفني: ${service.selectedEmployee!.name}',
                          style: TextStyle(color: widget.serviceColor),
                        ),
                      ],
                    ),
                  ],
                  if (service.isCustom) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, size: 14, color: Colors.blue),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              service.customDetails ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // شعار التقييم للخدمات المكتملة
                  // شعار التقييم للخدمات المكتملة - تصميم مصغر
                // تأكد من هذا الجزء في دالة _buildRequestedServiceCard
// 🔥 قسم التقييم للخدمات المكتملة
if (service.status == ServiceStatus.completed)
  FutureBuilder<bool>(
    future: _hasUserRatedService(service.id),
    builder: (context, snapshot) {
      final hasRated = snapshot.data ?? false;
      
      return GestureDetector(
        onTap: () {
          // 🔥 التحقق من وجود موظف لتقييمه
          final hasEmployee = service.selectedEmployee != null || 
                            (service.selectedEmployees?.isNotEmpty == true);
          
          if (!hasEmployee) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('لا يمكن تقييم الخدمة بدون معرفة الفني'),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }
          
          if (!hasRated) {
            _showRatingDialog(service);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: hasRated ? Colors.green[50] : Colors.amber[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasRated ? Colors.green : Colors.amber,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                hasRated ? Icons.check_circle : Icons.star_rate_rounded,
                color: hasRated ? Colors.green : Colors.amber,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                hasRated ? 'تم التقييم' : 'تقييم الخدمة',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: hasRated ? Colors.green[800] : Colors.amber[800],
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
  ],
    )
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.pending:
        return Colors.orange;
      case ServiceStatus.inProgress:
        return Colors.blue;
      case ServiceStatus.completed:
        return Colors.green;
      case ServiceStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.pending:
        return 'قيد الانتظار';
      case ServiceStatus.inProgress:
        return 'قيد التنفيذ';
      case ServiceStatus.completed:
        return 'مكتمل';
      case ServiceStatus.cancelled:
        return 'ملغي';
    }
  }

  // دالة لحفظ الخدمة المطلوبة في Supabase
  // دالة لحفظ الخدمة المطلوبة في Supabase
  // تحديث دالة حفظ الخدمة لتضمن حفظ جميع البيانات
 Future<void> _saveRequestedServiceToSupabase(RequestedService service) async {
  try {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('يجب تسجيل الدخول أولاً');

    print('💾 جاري حفظ الخدمة في جدول النفايات: ${service.name}');

    // 🔥 التحقق من الازدواجية
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(Duration(days: 1));

    final existingServices = await _supabase
        .from('waste_services_invoices')
        .select()
        .eq('user_id', user.id)
        .eq('service_name', service.name)
        .eq('amount', service.amount)
        .gte('created_at', todayStart.toIso8601String())
        .lt('created_at', todayEnd.toIso8601String());

    if (existingServices.isNotEmpty) {
      print('⚠️ الخدمة موجودة مسبقاً في قاعدة البيانات، تم تجنب الازدواجية');
      return;
    }

    // 🔥 الحصول على بيانات الموظف من الخدمة الحالية
    dynamic employeesData;
    String? employeeName;
    String? employeeSpecialty;

    if (service.isCustom && service.selectedEmployees != null && service.selectedEmployees!.isNotEmpty) {
      // للخدمات المخصصة - قائمة الموظفين
      employeesData = service.selectedEmployees!
          .map(
            (emp) => {
              'id': emp.id,
              'name': emp.name,
              'specialty': emp.specialty,
              'rating': emp.rating,
              'completedJobs': emp.completedJobs,
              'hourlyRate': emp.hourlyRate,
              'skills': emp.skills,
            },
          )
          .toList();
      employeeName = 'فريق مكون من ${service.selectedEmployees!.length} فني';
      employeeSpecialty = service.selectedEmployees!.map((e) => e.specialty).join('، ');
    } else if (service.selectedEmployee != null) {
      // للخدمات العادية - موظف فردي
      employeesData = {
        'id': service.selectedEmployee!.id,
        'name': service.selectedEmployee!.name,
        'specialty': service.selectedEmployee!.specialty,
        'rating': service.selectedEmployee!.rating,
        'completedJobs': service.selectedEmployee!.completedJobs,
        'hourlyRate': service.selectedEmployee!.hourlyRate,
        'skills': service.selectedEmployee!.skills,
      };
      employeeName = service.selectedEmployee!.name;
      employeeSpecialty = service.selectedEmployee!.specialty;
    } else {
      // 🔥 إذا لم يكن هناك موظف محدد، استخدم موظف افتراضي
      employeesData = {
        'id': 'default_1',
        'name': 'فريق النفايات',
        'specialty': 'خدمات النفايات',
        'rating': 4.5,
        'completedJobs': 100,
        'hourlyRate': 25.0,
        'skills': ['جمع النفايات', 'إعادة التدوير'],
      };
      employeeName = 'فريق النفايات';
      employeeSpecialty = 'خدمات النفايات';
    }

    final referenceNumber = 'WS-${DateTime.now().millisecondsSinceEpoch}';

    // 🔥 حفظ الخدمة مع بيانات الموظف
    final response = await _supabase.from('waste_services_invoices').insert({
      'user_id': user.id,
      'service_name': service.name,
      'service_description': service.description ?? '',
      'amount': service.amount,
      'request_date': DateTime.now().toIso8601String(),
      'status': 'completed',
      'employee_name': employeeName,
      'employee_specialty': employeeSpecialty,
      'selected_employees': employeesData,
      'is_custom': service.isCustom,
      'custom_details': service.customDetails,
      'payment_status': 'paid',
      'service_type': 'waste',
      'reference_number': referenceNumber,
      'payment_method': 'طريقة الدفع المختارة',
      'payment_date': DateTime.now().toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }).select();

    print('✅ تم حفظ الخدمة في جدول النفايات: ${response.length} سجل');
  } catch (e) {
    print('❌ خطأ في حفظ الخدمة في جدول النفايات: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('حدث خطأ في حفظ الخدمة: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  // دالة مساعدة لتحويل النص إلى ServiceStatus
  ServiceStatus _parseStatus(String status) {
    switch (status) {
      case 'قيد الانتظار':
      case 'pending':
        return ServiceStatus.pending;
      case 'قيد التنفيذ':
      case 'in_progress':
        return ServiceStatus.inProgress;
      case 'مكتمل':
      case 'completed':
        return ServiceStatus.completed;
      case 'ملغي':
      case 'cancelled':
        return ServiceStatus.cancelled;
      default:
        return ServiceStatus.pending;
    }
  }

  // تحديث دالة إضافة الخدمة المطلوبة
  final PaidServicesInvoiceService _paidServicesInvoiceService =
      PaidServicesInvoiceService();
void _addRequestedService(ServiceItem service, {String? customDetails}) {
  final isCustom = customDetails != null;

  // ✅ تحسين التحقق من الازدواجية
  final now = DateTime.now();
  final todayFormatted = _formatDate(now);
  
  final serviceUniqueId = '${service.name}_${service.amount}_${customDetails ?? ''}';
  
  final existingServiceIndex = _requestedServices.indexWhere(
    (s) => '${s.name}_${s.amount}_${s.customDetails ?? ''}' == serviceUniqueId &&
        s.requestDate == todayFormatted,
  );

  if (existingServiceIndex != -1) {
    print('⚠️ الخدمة "${service.name}" موجودة مسبقاً، تم تجنب الازدواجية');
    final existingService = _requestedServices[existingServiceIndex];
    setState(() {
      _requestedServices.removeAt(existingServiceIndex);
      _requestedServices.insert(0, existingService);
    });
    return;
  }

  // 🔥 التأكد من وجود موظف للخدمة
  dynamic selectedEmployeeData;
  List<Employee>? selectedEmployeesList;

  if (isCustom) {
    // للخدمات المخصصة
    final employees = _selectedEmployees['خدمة مخصصة'];
    if (employees is List<Employee>) {
      selectedEmployeesList = employees;
    } else if (employees is Employee) {
      selectedEmployeesList = [employees];
    } else {
      // 🔥 إذا لم يتم اختيار موظفين، استخدم موظف افتراضي
      selectedEmployeesList = [
        Employee(
          id: 'default_1',
          name: 'فريق النفايات',
          specialty: 'خدمات النفايات',
          rating: 4.5,
          completedJobs: 100,
          imageUrl: '',
          skills: ['جمع النفايات', 'إعادة التدوير'],
          hourlyRate: 25.0,
        )
      ];
    }
  } else {
    // للخدمات العادية
    final employee = _selectedEmployees[service.name];
    if (employee is Employee) {
      selectedEmployeeData = employee;
    } else {
      // 🔥 إذا لم يتم اختيار موظف، استخدم موظف افتراضي
      selectedEmployeeData = Employee(
        id: 'default_1',
        name: 'فريق النفايات',
        specialty: 'خدمات النفايات',
        rating: 4.5,
        completedJobs: 100,
        imageUrl: '',
        skills: ['جمع النفايات', 'إعادة التدوير'],
        hourlyRate: 25.0,
      );
    }
  }

  final requestedService = RequestedService(
    id: 'req_${now.millisecondsSinceEpoch}_${service.name.hashCode}',
    name: service.name,
    description: service.additionalInfo,
    amount: service.amount,
    requestDate: todayFormatted,
    status: ServiceStatus.completed, // 🔥 تغيير إلى completed مباشرة
    selectedEmployee: isCustom ? null : selectedEmployeeData,
    selectedEmployees: isCustom ? selectedEmployeesList : null,
    isCustom: isCustom,
    customDetails: customDetails,
  );

  setState(() {
    _requestedServices.insert(0, requestedService);
  });

  // حفظ الخدمة في Supabase
  _saveRequestedServiceToSupabase(requestedService);

  print('✅ تم إضافة الخدمة المطلوبة: ${service.name}');
}
  Future<void> _cleanDuplicateServices() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('waste_services_invoices')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final Map<String, dynamic> uniqueServices = {};
      final List<String> duplicatesToDelete = [];

      for (final service in response) {
        final key =
            '${service['service_name']}_${service['amount']}_${service['created_at']?.toString().substring(0, 10)}';

        if (uniqueServices.containsKey(key)) {
          duplicatesToDelete.add(service['id']);
        } else {
          uniqueServices[key] = service;
        }
      }

      if (duplicatesToDelete.isNotEmpty) {
        print('🗑️ جاري حذف ${duplicatesToDelete.length} خدمة مكررة');
        for (final id in duplicatesToDelete) {
          await _supabase.from('waste_services_invoices').delete().eq('id', id);
        }
        print('✅ تم تنظيف البيانات المكررة');
      }
    } catch (e) {
      print('❌ خطأ في تنظيف البيانات المكررة: $e');
    }
  }

  // دالة لحفظ فاتورة الخدمة المدفوعة
  Future<void> _savePaidServiceInvoice(
    ServiceItem service, {
    String? customDetails,
  }) async {
    try {
      final selectedEmployee = _selectedEmployees[service.name];
      final isCustom = customDetails != null;

      String employeeName = '';
      String employeeSpecialty = '';

      if (isCustom && _selectedEmployees['خدمة مخصصة'] is List<Employee>) {
        final employees = _selectedEmployees['خدمة مخصصة'] as List<Employee>;
        if (employees.isNotEmpty) {
          employeeName = 'فريق مكون من ${employees.length} فني';
          employeeSpecialty = employees.map((e) => e.specialty).join('، ');
        }
      } else if (selectedEmployee is Employee) {
        employeeName = selectedEmployee.name;
        employeeSpecialty = selectedEmployee.specialty;
      }

      await _paidServicesInvoiceService.savePaidServiceInvoice(
        serviceName: service.name,
        serviceDescription: service.additionalInfo ?? '',
        amount: service.amount,
        paymentMethod: 'طريقة الدفع المختارة',
        employeeName: employeeName,
        employeeSpecialty: employeeSpecialty,
        isCustom: isCustom,
        customDetails: customDetails ?? '',
      );
    } catch (e) {
      print('❌ خطأ في حفظ فاتورة الخدمة: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _requestService(ServiceItem service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          services: [service],
          primaryColor: widget.serviceColor,
          primaryGradient: widget.serviceGradient,
        ),
      ),
    );
  }

  void _submitCustomRequest() {
    // بدلاً من فتح اختيار الموظفين مباشرة، نفتح نموذج إدخال التفاصيل أولاً
    _showCustomRequestBottomSheet();
  }

  //*ssssssssssssssssssssssssssssssssssss
  void _showCustomRequestBottomSheet() {
    final serviceNameController = TextEditingController();
    final budgetController = TextEditingController();
    final locationController = TextEditingController();
    final detailsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.serviceColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.design_services, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'طلب خدمة مخصصة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'يرجى ملء التفاصيل أدناه لطلب خدمة مخصصة:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildCustomField(
                      controller: serviceNameController,
                      label: 'اسم الخدمة المطلوبة',
                      hint: 'مثال: جمع النفايات المنزلية',
                      icon: Icons.title,
                    ),
                    const SizedBox(height: 16),

                    _buildCustomField(
                      controller: budgetController,
                      label: 'الميزانية المتوقعة (دينار عراقي)',
                      hint: 'مثال: 150',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    _buildCustomField(
                      controller: locationController,
                      label: 'الموقع',
                      hint: 'أدخل عنوانك بالتفصيل',
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 16),

                    _buildCustomField(
                      controller: detailsController,
                      label: 'تفاصيل إضافية',
                      hint: 'صف الخدمة المطلوبة بدقة وأي متطلبات خاصة',
                      icon: Icons.description,
                      maxLines: 5,
                    ),

                    const SizedBox(height: 20),

                    // 🔥 قسم اختيار الموظفين - جديد
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.group,
                                color: widget.serviceColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'فريق العمل',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.serviceColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // عرض الموظفين المختارين حالياً
                          _buildSelectedEmployeesChips(),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.serviceColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                _showMultiEmployeeSelectionForCustomService();
                              },
                              icon: Icon(Icons.group_add, color: Colors.white),
                              label: Text(
                                'اختيار فريق العمل',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'يمكنك اختيار حتى 5 فنيين للخدمة المخصصة',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: widget.serviceColor),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'إلغاء',
                              style: TextStyle(
                                color: widget.serviceColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.serviceColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              // 🔥 التحقق من اختيار الموظفين أولاً
                              final selectedEmployees =
                                  _selectedEmployees['خدمة مخصصة'];
                              if (selectedEmployees == null ||
                                  (selectedEmployees is List &&
                                      selectedEmployees.isEmpty)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'يرجى اختيار فريق العمل أولاً',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (serviceNameController.text.isEmpty ||
                                  detailsController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'يرجى ملء الحقول المطلوبة (اسم الخدمة والتفاصيل)',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final customService = ServiceItem(
                                id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                                name: serviceNameController.text,
                                amount:
                                    double.tryParse(budgetController.text) ??
                                    0.0,
                                color: widget.serviceColor,
                                gradient: widget.serviceGradient,
                                additionalInfo: detailsController.text,
                              );

                              final customDetails =
                                  '''اسم الخدمة: ${serviceNameController.text}
الميزانية: ${budgetController.text.isNotEmpty ? '${budgetController.text} د.ع' : 'غير محدد'}
الموقع: ${locationController.text.isNotEmpty ? locationController.text : 'غير محدد'}
التفاصيل: ${detailsController.text}''';

                              _addRequestedService(
                                customService,
                                customDetails: customDetails,
                              );

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تم إرسال طلب الخدمة المخصصة "${serviceNameController.text}"',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: const Text(
                              'إرسال الطلب',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.serviceColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: Icon(icon, color: widget.serviceColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildElectricityPaidServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('الخدمات المدفوعة - النفايات'),
        const SizedBox(height: 16),
        _buildPaidServiceCard(
          title: 'جمع النفايات المنزلية',
          description: 'خدمة جمع ونقل النفايات المنزلية بانتظام',
          detailedDescription:
              'تشمل هذه الخدمة جمع النفايات المنزلية، فرزها، ونقلها إلى مواقع التخلص الآمن. نستخدم مركبات مجهزة ومطابقة للمعايير البيئية مع فريق مدرب على التعامل مع مختلف أنواع النفايات.',
          price: '120 د.ع',
          duration: '1-2 ساعات',
          icon: Icons.delete,
          gradient: const [Color(0xFF4CAF50), Color(0xFF66BB6A)],
        ),
        _buildPaidServiceCard(
          title: 'تنظيف حاويات النفايات',
          description: 'تنظيف وتعقيم حاويات النفايات بشكل دوري',
          detailedDescription:
              'تشمل الخدمة تنظيفاً شاملاً لحاويات النفايات، إزالة الروائح الكريهة، تعقيم الحاويات، وفحصها للتأكد من سلامتها. نستخدم مواد تنظيف صديقة للبيئة وآمنة على الصحة العامة.',
          price: '80 د.ع',
          duration: '1-3 ساعات',
          icon: Icons.clean_hands,
          gradient: const [Color(0xFF4CAF50), Color(0xFF66BB6A)],
        ),
        _buildPaidServiceCard(
          title: 'إزالة نفايات البناء',
          description: 'إزالة ونقل مخلفات البناء والهدم',
          detailedDescription:
              'خدمة متخصصة في إزالة نفايات البناء والهدم باستخدام معدات متخصصة. تشمل الخدمة جمع الأنقاض، الخرسانة، الأخشاب، والمعادن ونقلها إلى مواقع مخصصة لإعادة التدوير أو التخلص الآمن.',
          price: '200 د.ع',
          duration: 'حسب الكمية',
          icon: Icons.construction,
          gradient: const [Color(0xFF4CAF50), Color(0xFF66BB6A)],
        ),
        _buildPaidServiceCard(
          title: 'خدمات إعادة التدوير',
          description: 'فرز وإعادة تدوير النفايات القابلة للتدوير',
          detailedDescription:
              'تشمل الخدمة فرز النفايات القابلة للتدوير مثل البلاستيك، الورق، المعادن، والزجاج. نضمن نقل المواد إلى مراكز إعادة التدوير المعتمدة والمساهمة في الحفاظ على البيئة.',
          price: 'يبدأ من 100 د.ع',
          duration: '2-4 ساعات',
          icon: Icons.recycling,
          gradient: const [Color(0xFF4CAF50), Color(0xFF66BB6A)],
        ),
        _buildCustomServiceCard(),
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

  //*ssssssssssssssssssssssssssssssssssss
  Widget _buildPaidServiceCard({
    required String title,
    required String description,
    required String detailedDescription,
    required String price,
    required String duration,
    required IconData icon,
    required List<Color> gradient,
  }) {
    final selectedEmployee = _selectedEmployees[title];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradient[0].withOpacity(0.05),
              gradient[1].withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: gradient[0].withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header Section
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: gradient[0].withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: gradient[0],
                            height: 1.3,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Detailed Description
              Text(
                detailedDescription,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.right,
              ),

              const SizedBox(height: 12),

              // Service Details - قسمين مع الاتجاه المعكوس
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // الجهة اليسرى - التسميات
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المدة',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'السعر',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'الفني',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  // الجهة اليمنى - القيم
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // المدة
                      Row(
                        children: [
                          Text(
                            duration,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.access_time,
                            color: Colors.orange,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // السعر
                      Row(
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.attach_money,
                            color: Colors.green,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // الفني
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: selectedEmployee != null
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedEmployee != null
                                    ? Colors.green
                                    : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              selectedEmployee != null
                                  ? Icons.person
                                  : Icons.person_outline,
                              color: selectedEmployee != null
                                  ? Colors.green
                                  : Colors.grey,
                              size: 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => _showEmployeeSelectionDialog(title),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: widget.serviceColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: widget.serviceColor),
                              ),
                              child: Text(
                                selectedEmployee != null ? 'تغيير' : 'اختيار',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: widget.serviceColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // معلومات الفني المختار
              // في قسم معلومات الفني المختار، أضف تحذير إذا لم يتم الاختيار:
              if (selectedEmployee != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedEmployee.name,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            Text(
                              selectedEmployee.specialty,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[50], // نفس لون الخلفية
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.grey[300]!, // نفس لون الحدود
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.grey[600], // نفس لون النص الثانوي
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'يجب اختيار فني لطلب الخدمة',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700], // نفس لون النص الرئيسي
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Request Service Button
              // في دالة _buildPaidServiceCard، استبدل زر طلب الخدمة بهذا:
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.serviceColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final selectedEmployee = _selectedEmployees[title];

                    // 🔥 التحقق من اختيار الموظف
                    if (selectedEmployee == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('يرجى اختيار فني للخدمة أولاً'),
                          backgroundColor: const Color.fromARGB(
                            255,
                            231,
                            73,
                            73,
                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );

                      // فتح اختيار الموظف تلقائياً
                      _showEmployeeSelectionDialog(title);
                      return;
                    }

                    final service = ServiceItem(
                      id: 'service_${DateTime.now().millisecondsSinceEpoch}',
                      name: title,
                      amount: _extractPrice(price),
                      color: gradient[0],
                      gradient: gradient,
                      additionalInfo: detailedDescription,
                    );
                    _showPaymentMethodsForService(service);
                  },
                  child: const Text(
                    'طلب الخدمة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedEmployeeCard(Employee employee, String serviceTitle) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.green.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: Colors.green, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    employee.specialty,
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _showEmployeeSelectionDialog(serviceTitle),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: Text(
                'تغيير',
                style: TextStyle(color: widget.serviceColor, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmployeeSelectionDialog(String serviceTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeSelectionScreen(
          serviceTitle: serviceTitle,
          primaryColor: widget.serviceColor,
          primaryGradient: widget.serviceGradient,
          onEmployeeSelected: (employee) {
            setState(() {
              _selectedEmployees[serviceTitle] = employee;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم اختيار الفني: ${employee.name}'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }

  // في ملف electricity_paid_services.dart - تحديث دالة _buildCustomServiceCard
  Widget _buildCustomServiceCard() {
    final selectedEmployee = _selectedEmployees['خدمة مخصصة'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.serviceColor.withOpacity(0.05),
              widget.serviceColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: widget.serviceColor.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header Section - مشابه للخدمات العادية
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.serviceGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: widget.serviceColor.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.design_services,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'خدمة مخصصة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: widget.serviceColor,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'تصميم خدمة خاصة حسب احتياجاتك',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Detailed Description
              Text(
                'يمكنك طلب أي خدمة نفايات غير موجودة في القائمة. سيتم دراسة طلبك وتقديم سعر وتفاصيل الخدمة خلال 24 ساعة.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.right,
              ),

              const SizedBox(height: 12),

              // Service Details - نفس تصميم الخدمات العادية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // الجهة اليسرى - التسميات
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المدة',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'السعر',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'الفني',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  // الجهة اليمنى - القيم
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // المدة
                      Row(
                        children: [
                          Text(
                            'حسب الطلب',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.access_time,
                            color: Colors.orange,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // السعر
                      Row(
                        children: [
                          Text(
                            'يحدد لاحقاً',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.attach_money,
                            color: Colors.green,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // الفني
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: selectedEmployee != null
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedEmployee != null
                                    ? Colors.green
                                    : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              selectedEmployee != null
                                  ? Icons.person
                                  : Icons.person_outline,
                              color: selectedEmployee != null
                                  ? Colors.green
                                  : Colors.grey,
                              size: 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () =>
                                _showEmployeeSelectionDialog('خدمة مخصصة'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: widget.serviceColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: widget.serviceColor),
                              ),
                              child: Text(
                                selectedEmployee != null ? 'تغيير' : 'اختيار',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: widget.serviceColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // معلومات الفني المختار
              if (selectedEmployee != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedEmployee.name,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            Text(
                              selectedEmployee.specialty,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.grey[600], size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'يجب اختيار فني لطلب الخدمة',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Request Service Button - نفس تصميم الخدمات العادية
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.serviceColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final selectedEmployee = _selectedEmployees['خدمة مخصصة'];

                    // التحقق من اختيار الموظف
                    if (selectedEmployee == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('يرجى اختيار فني للخدمة أولاً'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );

                      // فتح اختيار الموظف تلقائياً
                      _showEmployeeSelectionDialog('خدمة مخصصة');
                      return;
                    }

                    // فتح نافذة إدخال تفاصيل الخدمة
                    _showCustomServiceDetailsDialog();
                  },
                  child: const Text(
                    'طلب الخدمة المخصصة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //*jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
  // 🔥 دالة جديدة لإدخال تفاصيل الخدمة المخصصة
  // 🔥 دالة جديدة لعرض تفاصيل الخدمة المخصصة بنافذة منبثقة جميلة
  void _showCustomServiceDetailsDialog() {
    final serviceNameController = TextEditingController();
    final serviceDetailsController = TextEditingController();
    final budgetController = TextEditingController();
    final locationController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header - مشابه لشاشة الدفع
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.serviceColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.design_services, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'تفاصيل الخدمة المخصصة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'يرجى ملء التفاصيل أدناه لطلب خدمة مخصصة:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // اسم الخدمة
                    _buildCustomField(
                      controller: serviceNameController,
                      label: 'اسم الخدمة المطلوبة *',
                      hint: 'مثال: جمع النفايات المنزلية',
                      icon: Icons.title,
                    ),
                    const SizedBox(height: 16),

                    // الميزانية
                    _buildCustomField(
                      controller: budgetController,
                      label: 'الميزانية المتوقعة (دينار عراقي)',
                      hint: 'مثال: 150',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // الموقع
                    _buildCustomField(
                      controller: locationController,
                      label: 'الموقع',
                      hint: 'أدخل عنوانك بالتفصيل',
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 16),

                    // التفاصيل
                    _buildCustomField(
                      controller: serviceDetailsController,
                      label: 'تفاصيل إضافية *',
                      hint: 'صف الخدمة المطلوبة بدقة وأي متطلبات خاصة',
                      icon: Icons.description,
                      maxLines: 5,
                    ),

                    const SizedBox(height: 20),

                    const SizedBox(height: 30),

                    // Buttons - مشابه لشاشة الدفع
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: widget.serviceColor),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'إلغاء',
                              style: TextStyle(
                                color: widget.serviceColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.serviceColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (serviceNameController.text.isEmpty ||
                                  serviceDetailsController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'يرجى ملء الحقول المطلوبة (اسم الخدمة والتفاصيل)',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // إنشاء الخدمة المخصصة
                              final customService = ServiceItem(
                                id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                                name: serviceNameController.text,
                                amount:
                                    double.tryParse(budgetController.text) ??
                                    0.0,
                                color: widget.serviceColor,
                                gradient: widget.serviceGradient,
                                additionalInfo: serviceDetailsController.text,
                              );

                              final customDetails =
                                  '''اسم الخدمة: ${serviceNameController.text}
الميزانية: ${budgetController.text.isNotEmpty ? '${budgetController.text} د.ع' : 'غير محدد'}
الموقع: ${locationController.text.isNotEmpty ? locationController.text : 'غير محدد'}
التفاصيل: ${serviceDetailsController.text}''';

                              // إضافة الخدمة المطلوبة
                              _addRequestedService(
                                customService,
                                customDetails: customDetails,
                              );

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تم إرسال طلب الخدمة المخصصة "${serviceNameController.text}"',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: const Text(
                              'إرسال الطلب',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 تحديث دالة اختيار الموظفين للخدمة المخصصة

  Widget _buildSelectedEmployeesChips() {
    final selectedEmployees = _selectedEmployees['خدمة مخصصة'];

    // 🔥 التصحيح: التعامل مع جميع الأنواع المحتملة
    List<Employee> employeesList = [];

    if (selectedEmployees is List<Employee>) {
      employeesList = selectedEmployees;
    } else if (selectedEmployees is Employee) {
      employeesList = [selectedEmployees];
    }

    if (employeesList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.info, color: Colors.blue, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'لم يتم اختيار أي فنيين. يرجى الضغط على زر "اختيار فريق العمل"',
                style: TextStyle(color: Colors.blue[800], fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تم اختيار ${employeesList.length} فني:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.serviceColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: employeesList.map((employee) {
            return Chip(
              label: Text(employee.name, style: TextStyle(fontSize: 12)),
              avatar: CircleAvatar(
                backgroundColor: widget.serviceColor,
                child: Text(
                  employee.name[0],
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              backgroundColor: widget.serviceColor.withOpacity(0.1),
            );
          }).toList(),
        ),
      ],
    );
  }

  // دالة مساعدة للتحقق من نوع البيانات
  List<Employee> _getEmployeesList(dynamic employeesData) {
    if (employeesData is List<Employee>) {
      return employeesData;
    } else if (employeesData is Employee) {
      return [employeesData];
    }
    return [];
  }

  void _showPaymentMethodsForService(ServiceItem service) {
    final selectedEmployee = _selectedEmployees[service.name];
    final isCustomService = service.name == 'خدمة مخصصة' || service.isCustom;

    // 🔥 التحقق من اختيار موظف - دعم الخدمات العادية والمخصصة
    if (selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يرجى اختيار فني ${isCustomService ? 'أو فريق عمل' : ''} للخدمة أولاً',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );

      // فتح شاشة اختيار الموظف تلقائياً
      if (isCustomService) {
        _showMultiEmployeeSelectionForCustomService();
      } else {
        _showEmployeeSelectionDialog(service.name);
      }
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.serviceColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payment, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'اختر طريقة الدفع',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Selected Employee(s) Info - تم التحديث لدعم الخدمات المخصصة
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCustomService ? Colors.blue[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCustomService ? Colors.blue : Colors.green,
                ),
              ),
              child: _buildSelectedEmployeesInfo(
                service,
                selectedEmployee,
                isCustomService,
              ),
            ),

            // Payment Methods Content
            Expanded(
              child: PaymentMethodsDialog(
                services: [service],
                primaryColor: widget.serviceColor,
                primaryGradient: widget.serviceGradient,
                finalAmount: service.amount,
                usePoints: false,
                pointsDiscount: 0.0,
                isPremiumService: true,
                premiumServiceData: {
                  'serviceType': 'waste', // 🔥 أضف هذا السطر المهم
                  'employeeName': _getEmployeeNameForPayment(
                    selectedEmployee,
                    isCustomService,
                  ),
                  'employeeSpecialty': _getEmployeeSpecialtyForPayment(
                    selectedEmployee,
                    isCustomService,
                  ),
                  'isCustom': isCustomService,
                  'customDetails': isCustomService
                      ? service.additionalInfo
                      : null,
                  'selectedEmployees': isCustomService
                      ? selectedEmployee
                      : null,
                },
                onPaymentSuccess: () {
                  _handlePaidServicePaymentSuccess(service);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 دالة مساعدة لبناء معلومات الموظفين المختارين
  Widget _buildSelectedEmployeesInfo(
    ServiceItem service,
    dynamic selectedEmployee,
    bool isCustomService,
  ) {
    if (isCustomService && selectedEmployee is List<Employee>) {
      // للخدمات المخصصة - عرض فريق العمل
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.group, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'فريق العمل المختار (${selectedEmployee.length} فني)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showMultiEmployeeSelectionForCustomService(),
                child: Text(
                  'تغيير الفريق',
                  style: TextStyle(color: widget.serviceColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: selectedEmployee.take(3).map((employee) {
              return Chip(
                label: Text(employee.name, style: TextStyle(fontSize: 12)),
                backgroundColor: Colors.blue.withOpacity(0.1),
              );
            }).toList(),
          ),
          if (selectedEmployee.length > 3)
            Text(
              '+ ${selectedEmployee.length - 3} فنيين إضافيين',
              style: TextStyle(fontSize: 12, color: Colors.blue[600]),
            ),
        ],
      );
    } else if (selectedEmployee is Employee) {
      // للخدمات العادية - عرض موظف واحد
      return Row(
        children: [
          Icon(Icons.person, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الموظف المختار: ${selectedEmployee.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                Text(
                  'التخصص: ${selectedEmployee.specialty}',
                  style: TextStyle(color: Colors.green[600], fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showEmployeeSelectionDialog(service.name),
            child: Text('تغيير', style: TextStyle(color: widget.serviceColor)),
          ),
        ],
      );
    }

    return SizedBox.shrink();
  }

  // 🔥 دالة مساعدة للحصول على اسم الموظف للدفع
  String _getEmployeeNameForPayment(
    dynamic selectedEmployee,
    bool isCustomService,
  ) {
    if (isCustomService && selectedEmployee is List<Employee>) {
      if (selectedEmployee.isEmpty) return 'فريق عمل';
      if (selectedEmployee.length == 1) return selectedEmployee.first.name;
      return 'فريق مكون من ${selectedEmployee.length} فنيين';
    } else if (selectedEmployee is Employee) {
      return selectedEmployee.name;
    }
    return 'غير محدد';
  }

  // 🔥 دالة مساعدة للحصول على تخصص الموظف للدفع
  String _getEmployeeSpecialtyForPayment(
    dynamic selectedEmployee,
    bool isCustomService,
  ) {
    if (isCustomService && selectedEmployee is List<Employee>) {
      if (selectedEmployee.isEmpty) return 'خدمة مخصصة';
      // عرض التخصصات المختلفة إن وجدت
      final specialties = selectedEmployee.map((e) => e.specialty).toSet();
      if (specialties.length == 1) return specialties.first;
      return 'متعدد التخصصات (${specialties.length})';
    } else if (selectedEmployee is Employee) {
      return selectedEmployee.specialty;
    }
    return 'غير محدد';
  }


  // 🔥 دالة لتحويل معرف الخدمة ليتناسب مع نظام التقييم
String _getRatingServiceId(String serviceId) {
  // إذا كان المعرف يحتوي على 'req_' (الخدمات المطلوبة المحلية)
  if (serviceId.startsWith('req_')) {
    return serviceId;
  }
  // إذا كان المعرف من قاعدة البيانات، استخدمه كما هو
  return serviceId;
}

  Future<void> _loadRequestedServicesFromSupabase() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      print('🔄 جاري تحميل الخدمات المطلوبة من جدول النفايات فقط...');

      final response = await _supabase
          .from('waste_services_invoices')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      print('📊 عدد الخدمات المستلمة من النفايات: ${response.length}');

      if (response.isNotEmpty) {
        // 🔥 استخدام Set لإزالة التكرارات بناءً على المعرف الفريد
        final uniqueServices = <String, RequestedService>{};

        for (final data in response) {
          final serviceId = data['id'].toString();
          final serviceUniqueKey =
              '${data['service_name']}_${data['amount']}_${data['created_at']?.toString().substring(0, 10)}';

          // إذا كانت الخدمة غير موجودة، أضفها
          if (!uniqueServices.containsKey(serviceUniqueKey)) {
            print('🔍 معالجة خدمة نفايات: ${data['service_name']}');

            Employee? singleEmployee;
            List<Employee>? multipleEmployees;

           // داخل دالة _loadRequestedServicesFromSupabase - جزء معالجة البيانات
if (data['selected_employees'] != null) {
  if (data['is_custom'] == true) {
    final employeesList = data['selected_employees'] as List;
    multipleEmployees = employeesList.map<Employee>((empData) {
      return Employee(
        id: empData['id']?.toString() ?? 'default_1',
        name: empData['name'] ?? 'فريق النفايات',
        specialty: empData['specialty'] ?? 'خدمات النفايات',
        rating: (empData['rating'] ?? 4.5).toDouble(),
        completedJobs: empData['completedJobs'] ?? 100,
        imageUrl: '',
        skills: List<String>.from(empData['skills'] ?? ['جمع النفايات', 'إعادة التدوير']),
        hourlyRate: (empData['hourlyRate'] ?? 25.0).toDouble(),
      );
    }).toList();
  } else {
    final empData = data['selected_employees'];
    if (empData is Map) {
      singleEmployee = Employee(
        id: empData['id']?.toString() ?? 'default_1',
        name: empData['name'] ?? 'فريق النفايات',
        specialty: empData['specialty'] ?? 'خدمات النفايات',
        rating: (empData['rating'] ?? 4.5).toDouble(),
        completedJobs: empData['completedJobs'] ?? 100,
        imageUrl: '',
        skills: List<String>.from(empData['skills'] ?? ['جمع النفايات', 'إعادة التدوير']),
        hourlyRate: (empData['hourlyRate'] ?? 25.0).toDouble(),
      );
    }
  }
} else {
  // 🔥 إذا لم توجد بيانات موظف، إنشاء موظف افتراضي
  singleEmployee = Employee(
    id: 'default_1',
    name: data['employee_name'] ?? 'فريق النفايات',
    specialty: data['employee_specialty'] ?? 'خدمات النفايات',
    rating: 4.5,
    completedJobs: 100,
    imageUrl: '',
    skills: ['جمع النفايات', 'إعادة التدوير'],
    hourlyRate: 25.0,
  );
}

            final service = RequestedService(
              id: serviceId,
              name: data['service_name'] ?? 'خدمة غير محددة',
              description: data['service_description'],
              amount: (data['amount'] ?? 0).toDouble(),
              requestDate: _formatDate(DateTime.parse(data['created_at'])),
              status: _parseStatus(data['status'] ?? 'pending'),
              selectedEmployee: singleEmployee,
              selectedEmployees: multipleEmployees,
              isCustom: data['is_custom'] ?? false,
              customDetails: data['custom_details'],
            );

            uniqueServices[serviceUniqueKey] = service;
          } else {
            print('⚠️ تم تجاهل خدمة مكررة: ${data['service_name']}');
          }
        }

        setState(() {
          _requestedServices = uniqueServices.values.toList();
        });

        print(
          '✅ تم تحميل ${_requestedServices.length} خدمة نفايات بنجاح (بعد إزالة التكرارات)',
        );
      } else {
        print('ℹ️ لا توجد خدمات مطلوبة في جدول النفايات');
        setState(() {
          _requestedServices = [];
        });
      }
    } catch (e) {
      print('❌ خطأ في تحميل الخدمات من جدول النفايات: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحميل الخدمات: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRequestedServicesFromSupabase(); // أضف هذا السطر
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadRequestedServicesFromSupabase(); // أضف هذا السطر
  }

  void _refreshData() {
    setState(() {
      // إعادة تحميل الخدمات المطلوبة
      _loadRequestedServicesFromSupabase();
      // يمكنك إضافة أي تحديثات أخرى هنا
    });
  }

  // دالة مخصصة لمعالجة نجاح الدفع في الخدمات المدفوعة
  void _handlePaidServicePaymentSuccess(ServiceItem service) {
    // إضافة الخدمة إلى القائمة المطلوبة
    // _addRequestedService(service);

    // 🔥 تحديث الواجهة فوراً
    _refreshData();

    // إظهار رسالة نجاح
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم طلب الخدمة "${service.name}" بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _updateServiceStatus(
    String serviceId,
    ServiceStatus newStatus,
  ) async {
    try {
      // ✅ استخدم الجدول الصحيح
      await _supabase
          .from('requested_services_invoices')
          .update({
            'status': _getStatusText(newStatus),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', serviceId);

      setState(() {
        final index = _requestedServices.indexWhere((s) => s.id == serviceId);
        if (index != -1) {
          _requestedServices[index] = _requestedServices[index].copyWith(
            status: newStatus,
          );
        }
      });
    } catch (e) {
      print('❌ خطأ في تحديث حالة الخدمة: $e');
    }
  }
}
// واجهة اختيار الموظفين المخصصة للخدمات المخصصة

// إضافة دالة copyWith لنموذج RequestedService
extension RequestedServiceExtension on RequestedService {
  RequestedService copyWith({
    ServiceStatus? status,
    String? requestDate,
    double? amount,
  }) {
    return RequestedService(
      id: id,
      name: name,
      description: description,
      amount: amount ?? this.amount,
      requestDate: requestDate ?? this.requestDate,
      status: status ?? this.status,
      selectedEmployee: selectedEmployee,
      isCustom: isCustom,
      customDetails: customDetails,
    );
  }
}

double _extractPrice(String priceText) {
  try {
    final numericText = priceText.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.parse(numericText);
  } catch (e) {
    return 0.0;
  }
}

class RequestedService {
  final String id;
  final String name;
  final String? description;
  final double amount;
  final String requestDate;
  final ServiceStatus status;
  final Employee? selectedEmployee; // للموظف الواحد (الخدمات العادية)
  final List<Employee>? selectedEmployees; // لقائمة الموظفين (الخدمات المخصصة)
  final bool isCustom;
  final String? customDetails;

  RequestedService({
    required this.id,
    required this.name,
    this.description,
    required this.amount,
    required this.requestDate,
    required this.status,
    this.selectedEmployee,
    this.selectedEmployees,
    this.isCustom = false,
    this.customDetails,
  });
}

// خدمة منفصلة لفواتير الخدمات المدفوعة
// 🔥 تحديث خدمة فواتير الخدمات المدفوعة للنفايات
class PaidServicesInvoiceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> savePaidServiceInvoice({
    required String serviceName,
    required String serviceDescription,
    required double amount,
    required String paymentMethod,
    String? employeeName,
    String? employeeSpecialty,
    bool isCustom = false,
    String? customDetails,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('يجب تسجيل الدخول أولاً');

      // 🔥 استخدم جدول النفايات مباشرة
      await _supabase.from('waste_services_invoices').insert({
        'user_id': user.id,
        'service_name': serviceName,
        'service_description': serviceDescription,
        'amount': amount,
        'payment_method': paymentMethod,
        'employee_name': employeeName,
        'employee_specialty': employeeSpecialty,
        'is_custom': isCustom,
        'custom_details': customDetails,
        'payment_date': DateTime.now().toIso8601String(),
        'status': 'completed',
        'service_type': 'waste',
        'created_at': DateTime.now().toIso8601String(),
      });

      print('✅ تم حفظ فاتورة الخدمة المدفوعة في جدول النفايات');
    } catch (e) {
      print('❌ خطأ في حفظ فاتورة الخدمة المدفوعة: $e');
      throw e;
    }
  }
}

// نموذج تقييم الموظف
class EmployeeRating {
  final String id;
  final String serviceId;
  final String employeeId;
  final String employeeName;
  final String employeeSpecialty;
  final int rating;
  final String? reviewText;
  final DateTime createdAt;

  EmployeeRating({
    required this.id,
    required this.serviceId,
    required this.employeeId,
    required this.employeeName,
    required this.employeeSpecialty,
    required this.rating,
    this.reviewText,
    required this.createdAt,
  });
}

// 🔥 نموذج بيانات الإشعارات - أضف هذا في نهاية الملف
class ServiceNotification {
  final String id;
  final String title;
  final String message;
  final String serviceName;
  final String employeeName;
  final double price;
  final String timestamp;
  final bool isRead;

  ServiceNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.serviceName,
    required this.employeeName,
    required this.price,
    required this.timestamp,
    required this.isRead,
  });

  ServiceNotification copyWith({bool? isRead}) {
    return ServiceNotification(
      id: id,
      title: title,
      message: message,
      serviceName: serviceName,
      employeeName: employeeName,
      price: price,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

// إضافة enum لحالة الخدمة
enum ServiceStatus { pending, inProgress, completed, cancelled }

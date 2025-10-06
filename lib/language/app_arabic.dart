// TODO Implement this library.class AppLocalizationsAr {
 Map<String, String> get keys => {
    // الشاشة الرئيسية
    'accountantDashboard': 'لوحة تحكم المحاسب',
    'activeBills': 'الفواتير النشطة',
    'paidBills': 'الفواتير المدفوعة',
    'overdueBills': 'الفواتير المتأخرة',
    'createBill': 'إنشاء فاتورة',
    'notifications': 'الإشعارات',
    
    // معلومات المحاسب
    'accountantName': 'محمد أحمد',
    'accountantTitle': 'محاسب فواتير - قسم المالية',
    'paidInvoices': 'فواتير مدفوعة',
    'totalRevenue': 'إجمالي الإيرادات',
    
    // الإحصائيات
    'active': 'نشط',
    'paid': 'مدفوع',
    'overdue': 'متأخر',
    'bills': 'فواتير',
    
    // تفاصيل الفاتورة
    'invoiceNumber': 'رقم الفاتورة',
    'customer': 'العميل',
    'customerPhone': 'هاتف العميل',
    'amount': 'المبلغ',
    'dueDate': 'تاريخ الاستحقاق',
    'consumption': 'الاستهلاك',
    'paymentDate': 'تاريخ الدفع',
    'paymentMethod': 'طريقة الدفع',
    'status': 'الحالة',
    'unpaid': 'غير مدفوعة',
    'paidStatus': 'مدفوعة',
    'overdueStatus': 'متأخرة',
    
    // الأزرار والإجراءات
    'markAsPaid': 'تعيين كمدفوعة',
    'sendReminder': 'إرسال تذكير',
    'contactCustomer': 'الاتصال بالعميل',
    'confirm': 'تأكيد',
    'cancel': 'إلغاء',
    'close': 'إغلاق',
    'continue': 'متابعة',
    'save': 'حفظ',
    
    // الأداء
    'monthlyPerformance': 'الأداء الشهري',
    'paymentRate': 'معدل الدفع',
    'paidInvoicesCount': 'الفواتير المدفوعة',
    
    // التحليل
    'overdueAnalysis': 'تحليل الفواتير المتأخرة',
    'totalOverdueAmount': 'إجمالي المبالغ المتأخرة',
    'delayReason': 'سبب التأخير',
    'notReceived': 'لم يتم الاستلام',
    'paymentIssues': 'مشاكل في الدفع',
    'incorrectData': 'بيانات غير صحيحة',
    'invoicesCount': 'فواتير',
    
    // القائمة الجانبية
    'mainTabs': 'التبويبات الرئيسية',
    'settingsAndActions': 'الإعدادات والإجراءات',
    'reportsAndStats': 'التقارير والإحصائيات',
    'customerManagement': 'إدارة العملاء',
    'settings': 'الإعدادات',
    'helpAndSupport': 'المساعدة والدعم',
    'logout': 'تسجيل الخروج',
    
    // التقارير
    'reports': 'التقارير والإحصائيات',
    'monthlyPerformanceSummary': 'ملخص الأداء الشهري',
    'collectionRate': 'نسبة التحصيل',
    
    // العملاء
    'customers': 'إدارة العملاء',
    'underDevelopment': 'تحت التطوير',
    'searchCustomers': 'ابحث عن العملاء...',
    'totalCustomers': 'إجمالي العملاء',
    'noCustomersFound': 'لم يتم العثور على عملاء',
    'viewInvoices': 'عرض الفواتير',
    'editCustomer': 'تعديل العميل',
    'addNewCustomer': 'إضافة عميل جديد',
    'invoicesFor': 'فواتير',
    'customerId': 'رقم العميل',
    'customerName': 'اسم العميل',
    'email': 'البريد الإلكتروني',
    'address': 'العنوان',
    'meterNumber': 'رقم العداد',
    'subscriptionType': 'نوع الاشتراك',
    'joinDate': 'تاريخ الانضمام',
    'totalInvoices': 'إجمالي الفواتير',
    'totalPaid': 'إجمالي المدفوع',
    'pendingBills': 'الفواتير المعلقة',
    
    // الإعدادات
    'appearance': 'المظهر',
    'darkMode': 'الوضع الداكن',
    'darkModeDesc': 'تفعيل الوضع الداكن تلقائياً',
    'accountSettings': 'إعدادات الحساب',
    'accountInfo': 'معلومات الحساب',
    'accountInfoDesc': 'عرض وتعديل معلومات حسابك',
    'changePassword': 'تغيير كلمة المرور',
    'changePasswordDesc': 'تحديث كلمة المرور الحالية',
    'appSettings': 'إعدادات التطبيق',
    'language': 'اللغة',
    'languageDesc': 'اختر لغة التطبيق',
    'notificationsSettings': 'الإشعارات',
    'enableNotifications': 'تفعيل الإشعارات',
    'enableNotificationsDesc': 'استقبال الإشعارات والتحديثات',
    'invoiceNotifications': 'إشعارات الفواتير',
    'invoiceNotificationsDesc': 'تنبيهات بمواعيد الفواتير',
    'offersNotifications': 'إشعارات العروض',
    'offersNotificationsDesc': 'إشعارات بالخصومات والعروض',
    'systemNotifications': 'إشعارات النظام',
    'systemNotificationsDesc': 'تحديثات وإعلانات النظام',
    
    // الحوارات
    'confirmPayment': 'تأكيد الدفع',
    'confirmPaymentMessage': 'هل تريد تأكيد دفع فاتورة {invoice} للعميل {customer}؟',
    'sendReminderTitle': 'إرسال تذكير',
    'sendReminderMessage': 'إرسال تذكير للعميل {customer} بفاتورة {invoice}؟',
    'contactCustomerTitle': 'الاتصال بالعميل',
    'contactCustomerMessage': 'الاتصال بالعميل {customer} على الرقم {phone}؟',
    'createBillTitle': 'إنشاء فاتورة جديدة',
    'createBillMessage': 'سيتم فتح نموذج إنشاء فاتورة جديدة',
    'helpTitle': 'المساعدة والدعم',
    'helpMessage': 'سيتم فتح شاشة المساعدة والدعم قريباً',
    'logoutTitle': 'تسجيل الخروج',
    'logoutMessage': 'هل أنت متأكد من تسجيل الخروج؟',
    
    // النجاح
    'paymentConfirmed': 'تم تأكيد الدفع بنجاح',
    'reminderSent': 'تم إرسال التذكير بنجاح',
    'callingCustomer': 'جاري الاتصال بالعميل...',
    'openingForm': 'جاري فتح نموذج إنشاء الفاتورة...',
    'settingsSaved': 'تم حفظ الإعدادات بنجاح',
    'passwordChanged': 'تم تغيير كلمة المرور بنجاح',
    
    // العملات
    'currency': 'دينار',
    
    // نصوص إضافية
    'previousReading': 'القراءة السابقة',
    'currentReading': 'القراءة الحالية',
    'all': 'الكل',
    'inactive': 'غير نشط',
  };
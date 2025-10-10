import 'package:flutter/material.dart';

class WasteScheduleScreen extends StatelessWidget {
  final Color serviceColor;

  const WasteScheduleScreen({super.key, required this.serviceColor});

  @override
  Widget build(BuildContext context) {
    final schedule = [
      {'day': 'الأحد', 'time': '06:00 ص - 08:00 ص'},
      {'day': 'الاثنين', 'time': '06:00 ص - 08:00 ص'},
      {'day': 'الثلاثاء', 'time': '06:00 ص - 08:00 ص'},
      {'day': 'الأربعاء', 'time': '06:00 ص - 08:00 ص'},
      {'day': 'الخميس', 'time': '06:00 ص - 08:00 ص'},
      {'day': 'الجمعة', 'time': 'لا يوجد جمع'},
      {'day': 'السبت', 'time': '08:00 ص - 10:00 ص'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('جدول جمع النفايات'),
        backgroundColor: serviceColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
              Row(
                children: [
                  Icon(Icons.calendar_today, color: serviceColor, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    'مواعيد جمع النفايات',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: serviceColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Schedule cards
              ...schedule.map((day) => _buildScheduleCard(
                context: context,
                day: day['day']!,
                time: day['time']!,
                isDayOff: day['day'] == 'الجمعة',
              )),
              
              const SizedBox(height: 25),
              
              // Important notes
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: serviceColor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: serviceColor, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'إرشادات مهمة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: serviceColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildNoteItem('• أخرج الحاوية قبل الموعد بساعة على الأقل'),
                    _buildNoteItem('• في أيام العطل الرسمية، يتم الجمع في اليوم التالي'),
                    _buildNoteItem('• أغلق الحاوية بإحكام بعد الاستخدام'),
                    _buildNoteItem('• استخدم الحاويات المخصصة فقط (ممنوع البراميل)'),
                    _buildNoteItem('• ضع النفايات في أكياس مغلقة جيداً'),
                    _buildNoteItem('• تأكد من سلامة الحاوية وعدم وجود ثقوب'),
                    _buildNoteItem('• لا تضع مخلفات البناء أو المواد الخطرة'),
                    _buildNoteItem('• نظف حول الحاوية بعد إفراغها'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard({
    required BuildContext context,
    required String day,
    required String time,
    bool isDayOff = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isDayOff 
                  ? Colors.red.withOpacity(0.1)
                  : serviceColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  day.substring(0, 1), // First letter of day
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDayOff ? Colors.red : serviceColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDayOff ? Colors.red : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isDayOff ? Icons.beach_access : Icons.delete,
              color: isDayOff ? Colors.red : serviceColor,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8, color: serviceColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
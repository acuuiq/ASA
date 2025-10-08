import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const WasteSchedulerApp());
}

class WasteSchedulerApp extends StatelessWidget {
  const WasteSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام إدارة جمع النفايات',
      theme: ThemeData(
        primaryColor: const Color(0xFF117E75),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF117E75),
          primary: const Color(0xFF117E75),
          secondary: const Color(0xFF4CAF50),
        ),
        fontFamily: 'Tajawal',
      ),
      home: const EmployeeScheduleScreen(),
    );
  }
}

class EmployeeScheduleScreen extends StatefulWidget {
  const EmployeeScheduleScreen({super.key});

  @override
  State<EmployeeScheduleScreen> createState() => _EmployeeScheduleScreenState();
}

class _EmployeeScheduleScreenState extends State<EmployeeScheduleScreen> {
  List<DaySchedule> _weeklySchedule = [];
  List<Truck> _availableTrucks = [
    Truck(
      id: 1,
      name: 'شاحنة ١',
      capacity: '٣ طن',
      plateNumber: 'أ ب ج 123',
      sector: 'القطاع ١ - مركز المدينة',
      districts: ['حي المصيف', 'حي الروضة', 'حي العليا'],
    ),
    Truck(
      id: 2,
      name: 'شاحنة ٢',
      capacity: '٥ طن',
      plateNumber: 'د هـ و 456',
      sector: 'القطاع ٢ - المنطقة الشرقية',
      districts: ['حي النزهة', 'حي السلام', 'حي الورود'],
    ),
    Truck(
      id: 3,
      name: 'شاحنة ٣',
      capacity: '٣ طن',
      plateNumber: 'ز ح ط 789',
      sector: 'القطاع ٣ - المنطقة الغربية',
      districts: ['حي الخليج', 'حي الربيع', 'حي الضباب'],
    ),
    Truck(
      id: 4,
      name: 'شاحنة ٤',
      capacity: '٧ طن',
      plateNumber: 'ك ل م 101',
      sector: 'القطاع ٤ - المنطقة الشمالية',
      districts: ['حي الياسمين', 'حي النخيل', 'حي الصفاء'],
    ),
    Truck(
      id: 5,
      name: 'شاحنة ٥',
      capacity: '٥ طن',
      plateNumber: 'ن س ع 112',
      sector: 'القطاع ٥ - المنطقة الجنوبية',
      districts: ['حي الواحة', 'حي الريان', 'حي الضاحية'],
    ),
  ];

  final List<Cleaner> _cleaners = [
    Cleaner(id: 1, name: 'محمد أحمد', phone: '0551234567'),
    Cleaner(id: 2, name: 'علي حسن', phone: '0557654321'),
    Cleaner(id: 3, name: 'خالد سعيد', phone: '0559876543'),
    Cleaner(id: 4, name: 'فارس عمر', phone: '0554567890'),
    Cleaner(id: 5, name: 'يوسف كمال', phone: '0556789012'),
    Cleaner(id: 6, name: 'محمود زيد', phone: '0553456789'),
  ];

  @override
  void initState() {
    super.initState();
    _initializeSchedule();
  }

  void _initializeSchedule() {
    final now = DateTime.now();
    // بداية الأسبوع من الأحد (اليوم 7 في DateTime)
    final currentWeekStart = now.subtract(Duration(days: now.weekday % 7));
    
    _weeklySchedule = List.generate(7, (index) {
      final day = currentWeekStart.add(Duration(days: index));
      final isFriday = day.weekday == DateTime.friday;
      
      var daySchedule = DaySchedule(
        date: day,
        dayName: _getArabicDayName(day.weekday),
        startTime: isFriday ? 'لا يوجد جمع' : '06:00 ص',
        endTime: isFriday ? '' : '08:00 ص',
        truck: isFriday ? null : _availableTrucks[index % _availableTrucks.length],
        isDayOff: isFriday,
        assignedCleaners: isFriday ? [] : _getRandomCleanersForDay(index),
      );
      return daySchedule;
    });
  }

  List<Cleaner> _getRandomCleanersForDay(int dayIndex) {
    final shuffled = List<Cleaner>.from(_cleaners)..shuffle();
    return shuffled.take(2 + (dayIndex % 2)).toList();
  }

  String _getArabicDayName(int weekday) {
    switch (weekday) {
      case 7: return 'الأحد'; // Sunday
      case 1: return 'الإثنين'; // Monday
      case 2: return 'الثلاثاء'; // Tuesday
      case 3: return 'الأربعاء'; // Wednesday
      case 4: return 'الخميس'; // Thursday
      case 5: return 'الجمعة'; // Friday
      case 6: return 'السبت'; // Saturday
      default: return '';
    }
  }

  void _editDaySchedule(int index) {
    showDialog(
      context: context,
      builder: (context) => EditDayScheduleDialog(
        daySchedule: _weeklySchedule[index],
        availableTrucks: _availableTrucks,
        allCleaners: _cleaners,
        onScheduleUpdated: (updatedSchedule) {
          setState(() {
            _weeklySchedule[index] = updatedSchedule;
          });
        },
      ),
    );
  }

  void _toggleDayOff(int index) {
    setState(() {
      final schedule = _weeklySchedule[index];
      _weeklySchedule[index] = DaySchedule(
        date: schedule.date,
        dayName: schedule.dayName,
        startTime: schedule.isDayOff ? '06:00 ص' : 'لا يوجد جمع',
        endTime: schedule.isDayOff ? '08:00 ص' : '',
        truck: schedule.isDayOff ? _availableTrucks[index % _availableTrucks.length] : null,
        isDayOff: !schedule.isDayOff,
        assignedCleaners: schedule.isDayOff ? _getRandomCleanersForDay(index) : [],
      );
    });
  }

  void _goToNextWeek() {
    setState(() {
      _weeklySchedule = _weeklySchedule.map((schedule) {
        final newDate = schedule.date.add(const Duration(days: 7));
        return DaySchedule(
          date: newDate,
          dayName: _getArabicDayName(newDate.weekday),
          startTime: schedule.startTime,
          endTime: schedule.endTime,
          truck: schedule.truck,
          isDayOff: schedule.isDayOff,
          assignedCleaners: schedule.assignedCleaners,
        );
      }).toList();
    });
  }

  void _goToPreviousWeek() {
    setState(() {
      _weeklySchedule = _weeklySchedule.map((schedule) {
        final newDate = schedule.date.subtract(const Duration(days: 7));
        return DaySchedule(
          date: newDate,
          dayName: _getArabicDayName(newDate.weekday),
          startTime: schedule.startTime,
          endTime: schedule.endTime,
          truck: schedule.truck,
          isDayOff: schedule.isDayOff,
          assignedCleaners: schedule.assignedCleaners,
        );
      }).toList();
    });
  }

  String _getWeekRange() {
    if (_weeklySchedule.isEmpty) return '';
    final firstDay = _weeklySchedule.first.date;
    final lastDay = _weeklySchedule.last.date;
    return '${DateFormat('yyyy/MM/dd').format(firstDay)} - ${DateFormat('yyyy/MM/dd').format(lastDay)}';
  }

  void _manageTrucks() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => TruckManagementBottomSheet(
        trucks: _availableTrucks,
        onTrucksUpdated: (updatedTrucks) {
          setState(() {
            _availableTrucks = updatedTrucks;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF117E75),
        title: const Text(
          'جدول جمع النفايات - إدارة الموظف',
          style: TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: _showInstructions,
          ),
          IconButton(
            icon: const Icon(Icons.people, color: Colors.white),
            onPressed: _showCleanersList,
          ),
        ],
      ),
      body: Column(
        children: [
          // Week Navigation
          _buildWeekNavigation(),
          
          // Schedule List
          Expanded(
            child: ListView.builder(
              itemCount: _weeklySchedule.length,
              itemBuilder: (context, index) {
                return _buildDayScheduleCard(_weeklySchedule[index], index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'trucks_btn',
            backgroundColor: const Color(0xFF2196F3),
            mini: true,
            onPressed: _manageTrucks,
            child: const Icon(Icons.local_shipping, color: Colors.white),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'settings_btn',
            backgroundColor: const Color(0xFF117E75),
            onPressed: () {
              _showQuickActions(context);
            },
            child: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNavigation() {
    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF117E75)),
              onPressed: _goToNextWeek,
            ),
            Column(
              children: [
                Text(
                  'الجدول الأسبوعي',
                  style: TextStyle(
                    color: const Color(0xFF117E75),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getWeekRange(),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF117E75)),
              onPressed: _goToPreviousWeek,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayScheduleCard(DaySchedule schedule, int index) {
    return Card(
      elevation: 2,
      color: schedule.isDayOff ? Colors.orange[50] : Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: schedule.isDayOff ? Colors.orange : const Color(0xFF117E75),
              width: 4,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (schedule.isDayOff)
                    Chip(
                      label: const Text(
                        'عطلة',
                        style: TextStyle(fontFamily: 'Tajawal', color: Colors.white),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  Text(
                    '${schedule.dayName} - ${DateFormat('yyyy/MM/dd').format(schedule.date)}',
                    style: TextStyle(
                      color: schedule.isDayOff ? Colors.orange[800] : const Color(0xFF117E75),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              if (!schedule.isDayOff) ...[
                _buildScheduleDetail('الوقت', '${schedule.startTime} - ${schedule.endTime}'),
                const SizedBox(height: 8),
                if (schedule.truck != null) ...[
                  _buildScheduleDetail('الشاحنة', schedule.truck!.name),
                  const SizedBox(height: 4),
                  _buildScheduleDetail('السعة', schedule.truck!.capacity),
                  const SizedBox(height: 4),
                  _buildScheduleDetail('القطاع', schedule.truck!.sector),
                ],
                const SizedBox(height: 8),
                _buildCleanersList(schedule.assignedCleaners),
              ] else ...[
                _buildScheduleDetail('الحالة', 'عطلة - لا يوجد جمع', isDayOff: true),
              ],
              
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text(
                        'تعديل',
                        style: TextStyle(fontFamily: 'Tajawal'),
                      ),
                      onPressed: () => _editDaySchedule(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF117E75),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(
                        schedule.isDayOff ? Icons.work : Icons.beach_access,
                        size: 18,
                      ),
                      label: Text(
                        schedule.isDayOff ? 'دوام' : 'عطلة',
                        style: const TextStyle(fontFamily: 'Tajawal'),
                      ),
                      onPressed: () => _toggleDayOff(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: schedule.isDayOff ? const Color(0xFF4CAF50) : Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleDetail(String title, String value, {bool isDayOff = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: isDayOff ? Colors.orange[700] : Colors.grey[800],
              fontFamily: 'Tajawal',
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 80,
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: isDayOff ? Colors.orange[800] : const Color(0xFF117E75),
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCleanersList(List<Cleaner> cleaners) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: cleaners.map((cleaner) => Chip(
              label: Text(
                cleaner.name,
                style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
              ),
              backgroundColor: const Color(0xFFE8F5E8),
              visualDensity: VisualDensity.compact,
            )).toList(),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 80,
          child: Text(
            'العمال:',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: const Color(0xFF117E75),
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'إجراءات سريعة',
              style: TextStyle(
                color: const Color(0xFF117E75),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 16),
            _buildQuickActionButton(
              'تعيين جميع الأيام كأيام دوام',
              Icons.work,
              const Color(0xFF4CAF50),
              () {
                setState(() {
                  for (int i = 0; i < _weeklySchedule.length; i++) {
                    if (_weeklySchedule[i].isDayOff) {
                      _toggleDayOff(i);
                    }
                  }
                });
                Navigator.pop(context);
              },
            ),
            _buildQuickActionButton(
              'تعيين الجمعة كعطلة',
              Icons.beach_access,
              Colors.orange,
              () {
                setState(() {
                  for (int i = 0; i < _weeklySchedule.length; i++) {
                    if (_weeklySchedule[i].date.weekday == DateTime.friday && !_weeklySchedule[i].isDayOff) {
                      _toggleDayOff(i);
                    }
                  }
                });
                Navigator.pop(context);
              },
            ),
            _buildQuickActionButton(
              'تعيين وقت موحد للصباح',
              Icons.access_time,
              const Color(0xFF2196F3),
              () {
                setState(() {
                  for (int i = 0; i < _weeklySchedule.length; i++) {
                    if (!_weeklySchedule[i].isDayOff) {
                      _weeklySchedule[i] = DaySchedule(
                        date: _weeklySchedule[i].date,
                        dayName: _weeklySchedule[i].dayName,
                        startTime: '06:00 ص',
                        endTime: '08:00 ص',
                        truck: _weeklySchedule[i].truck,
                        isDayOff: false,
                        assignedCleaners: _weeklySchedule[i].assignedCleaners,
                      );
                    }
                  }
                });
                Navigator.pop(context);
              },
            ),
            _buildQuickActionButton(
              'توزيع العمال تلقائياً',
              Icons.people,
              const Color(0xFF9C27B0),
              () {
                setState(() {
                  for (int i = 0; i < _weeklySchedule.length; i++) {
                    if (!_weeklySchedule[i].isDayOff) {
                      _weeklySchedule[i] = DaySchedule(
                        date: _weeklySchedule[i].date,
                        dayName: _weeklySchedule[i].dayName,
                        startTime: _weeklySchedule[i].startTime,
                        endTime: _weeklySchedule[i].endTime,
                        truck: _weeklySchedule[i].truck,
                        isDayOff: false,
                        assignedCleaners: _getRandomCleanersForDay(i),
                      );
                    }
                  }
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return ListTile(
      trailing: Icon(icon, color: color),
      title: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: Colors.grey[800],
          fontFamily: 'Tajawal',
        ),
      ),
      onTap: onPressed,
    );
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'إرشادات إدارة الجدول',
          textAlign: TextAlign.right,
          style: TextStyle(color: const Color(0xFF117E75), fontFamily: 'Tajawal'),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildInstructionItem('• يمكنك تعديل وقت الجمع لكل يوم'),
              _buildInstructionItem('• يمكنك تغيير الشاحنة المخصصة لكل يوم'),
              _buildInstructionItem('• يمكنك تعيين أي يوم كعطلة أو دوام'),
              _buildInstructionItem('• يمكنك إدارة عمال النظافة لكل يوم'),
              _buildInstructionItem('• استخدم الأزرار السريعة للإجراءات الجماعية'),
              _buildInstructionItem('• التغييرات تحفظ تلقائياً'),
              _buildInstructionItem('• يمكنك التنقل بين الأسابيع باستخدام الأسهم'),
              _buildInstructionItem('• استخدم زر الشاحنة لإدارة أسطول الشاحنات'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'تم الفهم',
              style: TextStyle(
                color: const Color(0xFF117E75),
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCleanersList() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'قائمة عمال النظافة',
          textAlign: TextAlign.right,
          style: TextStyle(color: const Color(0xFF117E75), fontFamily: 'Tajawal'),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _cleaners.map((cleaner) => ListTile(
              trailing: CircleAvatar(
                backgroundColor: const Color(0xFF117E75),
                child: Text(
                  cleaner.id.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              title: Text(
                cleaner.name,
                textAlign: TextAlign.right,
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
              subtitle: Text(
                cleaner.phone,
                textAlign: TextAlign.right,
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إغلاق',
              style: TextStyle(
                color: const Color(0xFF117E75),
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: Colors.grey[700],
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }
}

class DaySchedule {
  final DateTime date;
  final String dayName;
  String startTime;
  String endTime;
  Truck? truck;
  bool isDayOff;
  List<Cleaner> assignedCleaners;

  DaySchedule({
    required this.date,
    required this.dayName,
    required this.startTime,
    required this.endTime,
    required this.truck,
    required this.isDayOff,
    required this.assignedCleaners,
  });
}

class Cleaner {
  final int id;
  final String name;
  final String phone;

  Cleaner({
    required this.id,
    required this.name,
    required this.phone,
  });
}

class Truck {
  final int id;
  final String name;
  final String capacity;
  final String plateNumber;
  final String sector;
  final List<String> districts;

  Truck({
    required this.id,
    required this.name,
    required this.capacity,
    required this.plateNumber,
    required this.sector,
    required this.districts,
  });

  Truck copyWith({
    int? id,
    String? name,
    String? capacity,
    String? plateNumber,
    String? sector,
    List<String>? districts,
  }) {
    return Truck(
      id: id ?? this.id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      plateNumber: plateNumber ?? this.plateNumber,
      sector: sector ?? this.sector,
      districts: districts ?? this.districts,
    );
  }
}

class TruckManagementBottomSheet extends StatefulWidget {
  final List<Truck> trucks;
  final Function(List<Truck>) onTrucksUpdated;

  const TruckManagementBottomSheet({
    super.key,
    required this.trucks,
    required this.onTrucksUpdated,
  });

  @override
  State<TruckManagementBottomSheet> createState() => _TruckManagementBottomSheetState();
}

class _TruckManagementBottomSheetState extends State<TruckManagementBottomSheet> {
  late List<Truck> _trucks;

  @override
  void initState() {
    super.initState();
    _trucks = List.from(widget.trucks);
  }

  void _addNewTruck() {
    showDialog(
      context: context,
      builder: (context) => AddTruckDialog(
        onTruckAdded: (newTruck) {
          setState(() {
            _trucks.add(newTruck);
          });
          widget.onTrucksUpdated(_trucks);
        },
      ),
    );
  }

  void _editTruck(int index) {
    showDialog(
      context: context,
      builder: (context) => EditTruckDialog(
        truck: _trucks[index],
        onTruckUpdated: (updatedTruck) {
          setState(() {
            _trucks[index] = updatedTruck;
          });
          widget.onTrucksUpdated(_trucks);
        },
      ),
    );
  }

  void _deleteTruck(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'تأكيد الحذف',
          textAlign: TextAlign.right,
          style: TextStyle(color: const Color(0xFF117E75), fontFamily: 'Tajawal'),
        ),
        content: Text(
          'هل أنت متأكد من حذف ${_trucks[index].name}؟',
          textAlign: TextAlign.right,
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _trucks.removeAt(index);
              });
              widget.onTrucksUpdated(_trucks);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'حذف',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                'إدارة الشاحنات',
                style: TextStyle(
                  color: const Color(0xFF117E75),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  'إضافة شاحنة',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
                onPressed: _addNewTruck,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _trucks.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد شاحنات مضافة',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Tajawal',
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _trucks.length,
                    itemBuilder: (context, index) {
                      return _buildTruckCard(_trucks[index], index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTruckCard(Truck truck, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () => _editTruck(index),
                      color: const Color(0xFF117E75),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18),
                      onPressed: () => _deleteTruck(index),
                      color: Colors.red,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      truck.name,
                      style: TextStyle(
                        color: const Color(0xFF117E75),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Text(
                      '${truck.capacity} - ${truck.plateNumber}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildTruckDetail('القطاع', truck.sector),
            const SizedBox(height: 4),
            _buildTruckDetail('الأحياء', truck.districts.join('، ')),
          ],
        ),
      ),
    );
  }

  Widget _buildTruckDetail(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.grey,
              fontFamily: 'Tajawal',
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: const Color(0xFF117E75),
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class AddTruckDialog extends StatefulWidget {
  final Function(Truck) onTruckAdded;

  const AddTruckDialog({super.key, required this.onTruckAdded});

  @override
  State<AddTruckDialog> createState() => _AddTruckDialogState();
}

class _AddTruckDialogState extends State<AddTruckDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _plateController = TextEditingController();
  String _selectedSector = 'القطاع ١ - مركز المدينة';
  final _districtsController = TextEditingController();

  final List<String> _sectors = [
    'القطاع ١ - مركز المدينة',
    'القطاع ٢ - المنطقة الشرقية',
    'القطاع ٣ - المنطقة الغربية',
    'القطاع ٤ - المنطقة الشمالية',
    'القطاع ٥ - المنطقة الجنوبية',
    'القطاع ٦ - المنطقة الصناعية',
    'القطاع ٧ - المنطقة التجارية',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'إضافة شاحنة جديدة',
        textAlign: TextAlign.right,
        style: TextStyle(color: const Color(0xFF117E75), fontFamily: 'Tajawal'),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: _nameController,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  labelText: 'اسم الشاحنة',
                  labelStyle: TextStyle(fontFamily: 'Tajawal'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم الشاحنة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  labelText: 'سعة الشاحنة (طن)',
                  labelStyle: TextStyle(fontFamily: 'Tajawal'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال سعة الشاحنة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plateController,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  labelText: 'رقم اللوحة',
                  labelStyle: TextStyle(fontFamily: 'Tajawal'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم اللوحة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSector,
                items: _sectors
                    .map((sector) => DropdownMenuItem(
                          value: sector,
                          child: Text(sector, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Tajawal')),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSector = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'القطاع',
                  labelStyle: TextStyle(fontFamily: 'Tajawal'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _districtsController,
                textAlign: TextAlign.right,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'الأحياء (افصل بينها بفاصلة)',
                  labelStyle: TextStyle(fontFamily: 'Tajawal'),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الأحياء';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newTruck = Truck(
                id: DateTime.now().millisecondsSinceEpoch,
                name: _nameController.text,
                capacity: _capacityController.text,
                plateNumber: _plateController.text,
                sector: _selectedSector,
                districts: _districtsController.text.split(',').map((e) => e.trim()).toList(),
              );
              widget.onTruckAdded(newTruck);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF117E75),
          ),
          child: const Text(
            'إضافة',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'إلغاء',
            style: TextStyle(
              color: Colors.grey[600],
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    );
  }
}

class EditTruckDialog extends StatefulWidget {
  final Truck truck;
  final Function(Truck) onTruckUpdated;

  const EditTruckDialog({super.key, required this.truck, required this.onTruckUpdated});

  @override
  State<EditTruckDialog> createState() => _EditTruckDialogState();
}

class _EditTruckDialogState extends State<EditTruckDialog> {
  late TextEditingController _nameController;
  late TextEditingController _capacityController;
  late TextEditingController _plateController;
  late String _selectedSector;
  late TextEditingController _districtsController;

  final List<String> _sectors = [
    'القطاع ١ - مركز المدينة',
    'القطاع ٢ - المنطقة الشرقية',
    'القطاع ٣ - المنطقة الغربية',
    'القطاع ٤ - المنطقة الشمالية',
    'القطاع ٥ - المنطقة الجنوبية',
    'القطاع ٦ - المنطقة الصناعية',
    'القطاع ٧ - المنطقة التجارية',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.truck.name);
    _capacityController = TextEditingController(text: widget.truck.capacity);
    _plateController = TextEditingController(text: widget.truck.plateNumber);
    _selectedSector = widget.truck.sector;
    _districtsController = TextEditingController(text: widget.truck.districts.join('، '));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'تعديل بيانات الشاحنة',
        textAlign: TextAlign.right,
        style: TextStyle(color: const Color(0xFF117E75), fontFamily: 'Tajawal'),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              controller: _nameController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'اسم الشاحنة',
                labelStyle: TextStyle(fontFamily: 'Tajawal'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _capacityController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'سعة الشاحنة (طن)',
                labelStyle: TextStyle(fontFamily: 'Tajawal'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _plateController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'رقم اللوحة',
                labelStyle: TextStyle(fontFamily: 'Tajawal'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSector,
              items: _sectors
                  .map((sector) => DropdownMenuItem(
                        value: sector,
                        child: Text(sector, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Tajawal')),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSector = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'القطاع',
                labelStyle: TextStyle(fontFamily: 'Tajawal'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _districtsController,
              textAlign: TextAlign.right,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'الأحياء (افصل بينها بفاصلة)',
                labelStyle: TextStyle(fontFamily: 'Tajawal'),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final updatedTruck = widget.truck.copyWith(
              name: _nameController.text,
              capacity: _capacityController.text,
              plateNumber: _plateController.text,
              sector: _selectedSector,
              districts: _districtsController.text.split(',').map((e) => e.trim()).toList(),
            );
            widget.onTruckUpdated(updatedTruck);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF117E75),
          ),
          child: const Text(
            'حفظ',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'إلغاء',
            style: TextStyle(
              color: Colors.grey[600],
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    );
  }
}

class EditDayScheduleDialog extends StatefulWidget {
  final DaySchedule daySchedule;
  final List<Truck> availableTrucks;
  final List<Cleaner> allCleaners;
  final Function(DaySchedule) onScheduleUpdated;

  const EditDayScheduleDialog({
    super.key,
    required this.daySchedule,
    required this.availableTrucks,
    required this.allCleaners,
    required this.onScheduleUpdated,
  });

  @override
  State<EditDayScheduleDialog> createState() => _EditDayScheduleDialogState();
}

class _EditDayScheduleDialogState extends State<EditDayScheduleDialog> {
  late String _selectedStartTime;
  late String _selectedEndTime;
  late Truck? _selectedTruck;
  late bool _isDayOff;
  late List<Cleaner> _selectedCleaners;

  final List<String> _timeSlots = [
    '05:00 ص', '06:00 ص', '07:00 ص', '08:00 ص', '09:00 ص',
    '10:00 ص', '11:00 ص', '12:00 م', '01:00 م', '02:00 م',
    '03:00 م', '04:00 م', '05:00 م', '06:00 م', '07:00 م'
  ];

  @override
  void initState() {
    super.initState();
    _selectedStartTime = widget.daySchedule.startTime == 'لا يوجد جمع' 
        ? '06:00 ص' 
        : widget.daySchedule.startTime;
    _selectedEndTime = widget.daySchedule.endTime.isEmpty 
        ? '08:00 ص' 
        : widget.daySchedule.endTime;
    _selectedTruck = widget.daySchedule.truck;
    _isDayOff = widget.daySchedule.isDayOff;
    _selectedCleaners = List.from(widget.daySchedule.assignedCleaners);
  }

  void _saveChanges() {
    final updatedSchedule = DaySchedule(
      date: widget.daySchedule.date,
      dayName: widget.daySchedule.dayName,
      startTime: _isDayOff ? 'لا يوجد جمع' : _selectedStartTime,
      endTime: _isDayOff ? '' : _selectedEndTime,
      truck: _isDayOff ? null : _selectedTruck,
      isDayOff: _isDayOff,
      assignedCleaners: _isDayOff ? [] : _selectedCleaners,
    );
    
    widget.onScheduleUpdated(updatedSchedule);
    Navigator.pop(context);
  }

  void _toggleCleanerSelection(Cleaner cleaner) {
    setState(() {
      if (_selectedCleaners.contains(cleaner)) {
        _selectedCleaners.remove(cleaner);
      } else {
        _selectedCleaners.add(cleaner);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'تعديل ${widget.daySchedule.dayName}',
        textAlign: TextAlign.right,
        style: TextStyle(color: const Color(0xFF117E75), fontFamily: 'Tajawal'),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Day Off Toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'عطلة',
                textAlign: TextAlign.right,
                style: TextStyle(color: const Color(0xFF117E75), fontFamily: 'Tajawal'),
              ),
              value: _isDayOff,
              onChanged: (value) {
                setState(() {
                  _isDayOff = value;
                });
              },
              activeColor: const Color(0xFF117E75),
            ),
            
            if (!_isDayOff) ...[
              const SizedBox(height: 16),
              
              // Start Time
              Text(
                'وقت البدء:',
                textAlign: TextAlign.right,
                style: TextStyle(color: const Color(0xFF117E75), fontFamily: 'Tajawal'),
              ),
              DropdownButtonFormField(
                value: _selectedStartTime,
                items: _timeSlots
                    .map((time) => DropdownMenuItem(
                          value: time,
                          child: Text(time, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Tajawal')),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedStartTime = value!),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
              ),
              
              const SizedBox(height: 16),
              
              // End Time
              Text(
                'وقت الانتهاء:',
                textAlign: TextAlign.right,
                style: TextStyle(color: const Color(0xFF117E75), fontFamily: 'Tajawal'),
              ),
              DropdownButtonFormField(
                value: _selectedEndTime,
                items: _timeSlots
                    .map((time) => DropdownMenuItem(
                          value: time,
                          child: Text(time, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Tajawal')),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedEndTime = value!),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
              ),
              
              const SizedBox(height: 16),
              
              // Truck Selection
              Text(
                'الشاحنة:',
                textAlign: TextAlign.right,
                style: TextStyle(color: const Color(0xFF117E75), fontFamily: 'Tajawal'),
              ),
              DropdownButtonFormField<Truck>(
                value: _selectedTruck,
                items: widget.availableTrucks
                    .map((truck) => DropdownMenuItem(
                          value: truck,
                          child: Text(truck.name, textAlign: TextAlign.right, style: const TextStyle(fontFamily: 'Tajawal')),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedTruck = value),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
              ),
              
              const SizedBox(height: 16),
              
              // Cleaners Selection
              Text(
                'اختر العمال:',
                textAlign: TextAlign.right,
                style: TextStyle(color: const Color(0xFF117E75), fontFamily: 'Tajawal'),
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: widget.allCleaners.length,
                  itemBuilder: (context, index) {
                    final cleaner = widget.allCleaners[index];
                    final isSelected = _selectedCleaners.contains(cleaner);
                    
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        cleaner.name,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontFamily: 'Tajawal'),
                      ),
                      subtitle: Text(
                        cleaner.phone,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12),
                      ),
                      value: isSelected,
                      onChanged: (value) => _toggleCleanerSelection(cleaner),
                      activeColor: const Color(0xFF117E75),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF117E75),
          ),
          child: const Text(
            'حفظ',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'إلغاء',
            style: TextStyle(
              color: Colors.grey[600],
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    );
  }
}
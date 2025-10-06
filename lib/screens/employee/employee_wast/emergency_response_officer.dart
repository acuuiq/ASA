import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmergencyResponseOfficerScreen extends StatefulWidget {
  const EmergencyResponseOfficerScreen({super.key});

  @override
  State<EmergencyResponseOfficerScreen> createState() =>
      _EmergencyResponseOfficerScreenState();
}

class _EmergencyResponseOfficerScreenState
    extends State<EmergencyResponseOfficerScreen>
    with SingleTickerProviderStateMixin {
  // نظام الألوان
  static const Color _primaryColor = Color(0xFF1A237E);
  static const Color _backgroundColor = Color(0xFFF8F9FA);
  static const Color _cardColor = Colors.white;
  static const Color _textColor = Color(0xFF263238);

  int _currentPageIndex = 0;

  // بيانات الطلبات العاجلة
  final List<Map<String, dynamic>> _emergencyRequests = [
    {
      'id': '1',
      'type': 'انسداد صرف صحي',
      'location': 'حي النخيل، شارع الأمير سلطان',
      'time': 'منذ 10 دقائق',
      'priority': 'عالية',
      'status': 'قيد المعالجة',
      'assignedTo': 'فريق الطوارئ 2',
      'icon': Icons.plumbing,
      'progress': 60,
    },
    {
      'id': '2',
      'type': 'حاوية متضررة',
      'location': 'حي الورود، شارع الخليج',
      'time': 'منذ 25 دقيقة',
      'priority': 'متوسطة',
      'status': 'معلقة',
      'assignedTo': 'لم يتم التعيين',
      'icon': Icons.auto_delete,
      'progress': 0,
    },
  ];

  // بيانات الفرق المتاحة
  final List<Map<String, dynamic>> _availableTeams = [
    {
      'id': '1',
      'name': 'فريق الطوارئ 1',
      'status': 'نشط',
      'location': 'حي الروضة',
      'currentTask': 'معالجة انسداد',
      'members': 5,
      'vehicle': 'شاحنة صرف صحي',
      'rating': 4.8,
    },
    {
      'id': '2',
      'name': 'فريق النظافة 2',
      'status': 'متاح',
      'location': 'حي العليا',
      'currentTask': 'لا يوجد',
      'members': 4,
      'vehicle': 'شاحنة نفايات',
      'rating': 4.5,
    },
  ];

  // بيانات الإحصائيات
  final Map<String, dynamic> _statisticsData = {
    'totalRequests': 24,
    'completedRequests': 18,
    'pendingRequests': 4,
    'inProgressRequests': 2,
    'responseTime': '15 دقيقة',
    'satisfactionRate': '92%',
    'teamsAvailable': 3,
    'teamsBusy': 5,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('مركز طوارئ النظافة', 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: _primaryColor,
        elevation: 4,
      ),
      body: Column(
        children: [
          // شريط التبويب البسيط
          Container(
            color: _cardColor,
            child: Row(
              children: [
                _buildTabItem(0, Icons.emergency, 'الطلبات'),
                _buildTabItem(1, Icons.group_work, 'الفرق'),
                _buildTabItem(2, Icons.analytics, 'الإحصائيات'),
              ],
            ),
          ),
          Expanded(
            child: _buildCurrentView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _wasteColor,
        onPressed: _reportNewEmergency,
        child: const Icon(Icons.add_alert, size: 28, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String title) {
    final isSelected = _currentPageIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentPageIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? _primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? _primaryColor : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? _primaryColor : Colors.grey,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyRequestsView() {
    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('الطلبات العاجلة', Icons.emergency),
            const SizedBox(height: 20),
            ..._emergencyRequests.map((request) => _buildRequestItem(request)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamsView() {
    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('الفرق المتاحة', Icons.group_work),
            const SizedBox(height: 20),
            ..._availableTeams.map((team) => _buildTeamItem(team)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDecisionWheelView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSectionHeader('عجلة القرار', Icons.explore),
          const SizedBox(height: 20),
          _buildDecisionWheelCard(),
        ],
      ),
    );
  }

  Widget _buildEmergencyRequestsView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _emergencyRequests.length,
      itemBuilder: (context, index) {
        final request = _emergencyRequests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(request['icon'], color: _primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        request['type'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        request['priority'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('الموقع: ${request['location']}'),
                const SizedBox(height: 8),
                Text('الوقت: ${request['time']}'),
                const SizedBox(height: 8),
                Text('الحالة: ${request['status']}'),
                if (request['progress'] > 0) ...[
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: request['progress'] / 100,
                    backgroundColor: Colors.grey[200],
                    color: _primaryColor,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeamsView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _availableTeams.length,
      itemBuilder: (context, index) {
        final team = _availableTeams[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        color: team['status'] == 'متاح' ? Colors.green : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            team['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            team['location'],
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(team['rating'].toString()),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('المهمة: ${team['currentTask']}'),
                const SizedBox(height: 8),
                Text('المركبة: ${team['vehicle']}'),
                const SizedBox(height: 8),
                Text('الأعضاء: ${team['members']}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatisticsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة إحصائيات عامة
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'نظرة عامة على الأداء',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatItem('إجمالي الطلبات', _statisticsData['totalRequests'].toString(), Icons.list_alt),
                      _buildStatItem('مكتملة', _statisticsData['completedRequests'].toString(), Icons.check_circle),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatItem('قيد المعالجة', _statisticsData['inProgressRequests'].toString(), Icons.autorenew),
                      _buildStatItem('معلقة', _statisticsData['pendingRequests'].toString(), Icons.pending),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // بطاقة أداء الفرق
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أداء الفرق',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatItem('فرق متاحة', _statisticsData['teamsAvailable'].toString(), Icons.group),
                      _buildStatItem('فرق مشغولة', _statisticsData['teamsBusy'].toString(), Icons.group_work),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // بطاقة مؤشرات الأداء
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مؤشرات الأداء',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPerformanceIndicator('متوسط وقت الاستجابة', _statisticsData['responseTime'], Icons.access_time),
                  const SizedBox(height: 12),
                  _buildPerformanceIndicator('معدل الرضا', _statisticsData['satisfactionRate'], Icons.sentiment_satisfied_alt),
                ],
              ),
            ),
          ),

          // مخطط بياني بسيط
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'توزيع الطلبات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: _backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bar_chart, size: 50, color: _primaryColor),
                          const SizedBox(height: 12),
                          Text(
                            'مخطط توزيع الطلبات حسب النوع',
                            style: TextStyle(color: _textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: _primaryColor, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            Text(
              'اختر فريقًا لتعيينه:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor),
            ),
            const SizedBox(height: 12),
            ..._availableTeams
                .where((team) => team['status'] == 'متاح')
                .map(
                  (team) => ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.group_work, color: _primaryColor, size: 20),
                    ),
                    title: Text(team['name'], style: TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
                    subtitle: Text(team['location'], style: TextStyle(color: _textSecondaryColor)),
                    trailing: Text('${team['members']} أعضاء', style: TextStyle(color: _textSecondaryColor)),
                    onTap: () {
                      Navigator.pop(context);
                      _assignTeamToRequest(request, team);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                )
                .toList(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryColor,
                  side: BorderSide(color: _primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('إلغاء'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceIndicator(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _primaryColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: _textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: _primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
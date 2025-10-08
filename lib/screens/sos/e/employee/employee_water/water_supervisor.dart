import 'package:flutter/material.dart';

class WaterSupervisorScreen extends StatefulWidget {
  const WaterSupervisorScreen({super.key});

  @override
  State<WaterSupervisorScreen> createState() => _WaterSupervisorScreenState();
}

class _WaterSupervisorScreenState extends State<WaterSupervisorScreen> {
  final List<WaterTask> tasks = [
    WaterTask(
      id: '1',
      title: 'فحص محطة التنقية',
      type: TaskType.inspection,
      schedule: 'يومي',
      time: '08:00 ص',
      status: TaskStatus.pending,
      assignedTo: 'فريق الصيانة أ',
      priority: Priority.high,
    ),
    WaterTask(
      id: '2',
      title: 'قراءة العدادات',
      type: TaskType.meterReading,
      schedule: 'أسبوعي',
      time: '10:00 ص',
      status: TaskStatus.inProgress,
      assignedTo: 'أحمد محمد',
      priority: Priority.medium,
    ),
    WaterTask(
      id: '3',
      title: 'صيانة الشبكة',
      type: TaskType.maintenance,
      schedule: 'شهري',
      time: '02:00 م',
      status: TaskStatus.completed,
      assignedTo: 'فريق الصيانة ب',
      priority: Priority.high,
    ),
    WaterTask(
      id: '4',
      title: 'تقرير الجودة',
      type: TaskType.report,
      schedule: 'يومي',
      time: '04:00 م',
      status: TaskStatus.pending,
      assignedTo: 'قسم الجودة',
      priority: Priority.low,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نظام إدارة المياه'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewTask,
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Header
          _buildStatsHeader(),
          // Unified Tasks View
          Expanded(
            child: _buildUnifiedTasksView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('المهام المعلقة', '2', Colors.orange),
          _buildStatItem('قيد التنفيذ', '1', Colors.blue),
          _buildStatItem('المكتملة', '1', Colors.green),
          _buildStatItem('الإجمالي', '4', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildUnifiedTasksView() {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(WaterTask task) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: _buildTaskIcon(task.type),
        title: Row(
          children: [
            Expanded(
              child: Text(
                task.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            _buildPriorityBadge(task.priority),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${task.time} - ${task.schedule}'),
                const Spacer(),
                Icon(Icons.person, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(task.assignedTo),
              ],
            ),
            const SizedBox(height: 4),
            _buildStatusBar(task.status),
          ],
        ),
        trailing: PopupMenuButton(
          onSelected: (value) => _handleTaskAction(value, task),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('تعديل')),
            const PopupMenuItem(value: 'delete', child: Text('حذف')),
            const PopupMenuItem(value: 'complete', child: Text('إكمال')),
          ],
        ),
        onTap: () => _showTaskDetails(task),
      ),
    );
  }

  Widget _buildTaskIcon(TaskType type) {
    final iconData = {
      TaskType.inspection: Icons.verified_user,
      TaskType.maintenance: Icons.build,
      TaskType.meterReading: Icons.speed,
      TaskType.report: Icons.assignment,
    }[type];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: Colors.blue[700], size: 20),
    );
  }

  Widget _buildPriorityBadge(Priority priority) {
    final colors = {
      Priority.high: Colors.red,
      Priority.medium: Colors.orange,
      Priority.low: Colors.green,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors[priority]!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors[priority]!),
      ),
      child: Text(
        priority == Priority.high ? 'عالي' : priority == Priority.medium ? 'متوسط' : 'منخفض',
        style: TextStyle(
          fontSize: 10,
          color: colors[priority],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusBar(TaskStatus status) {
    final statusColors = {
      TaskStatus.pending: Colors.orange,
      TaskStatus.inProgress: Colors.blue,
      TaskStatus.completed: Colors.green,
    };

    return LinearProgressIndicator(
      value: status == TaskStatus.pending ? 0.3 : status == TaskStatus.inProgress ? 0.7 : 1.0,
      backgroundColor: Colors.grey[200],
      valueColor: AlwaysStoppedAnimation<Color>(statusColors[status]!),
    );
  }

  void _showTaskDetails(WaterTask task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الموعد: ${task.time}'),
            Text('التكرار: ${task.schedule}'),
            Text('المسؤول: ${task.assignedTo}'),
            Text('الأولوية: ${task.priority == Priority.high ? 'عالي' : task.priority == Priority.medium ? 'متوسط' : 'منخفض'}'),
            Text('الحالة: ${task.status == TaskStatus.pending ? 'معلق' : task.status == TaskStatus.inProgress ? 'قيد التنفيذ' : 'مكتمل'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    // Implement filter dialog
  }

  void _addNewTask() {
    // Implement add new task
  }

  void _handleTaskAction(String action, WaterTask task) {
    switch (action) {
      case 'edit':
        // Implement edit task
        break;
      case 'delete':
        setState(() {
          tasks.remove(task);
        });
        break;
      case 'complete':
        setState(() {
          task.status = TaskStatus.completed;
        });
        break;
    }
  }
}

// Data Models
class WaterTask {
  final String id;
  final String title;
  final TaskType type;
  final String schedule;
  final String time;
  TaskStatus status;
  final String assignedTo;
  final Priority priority;

  WaterTask({
    required this.id,
    required this.title,
    required this.type,
    required this.schedule,
    required this.time,
    required this.status,
    required this.assignedTo,
    required this.priority,
  });
}

enum TaskType { inspection, maintenance, meterReading, report }
enum TaskStatus { pending, inProgress, completed }
enum Priority { high, medium, low }
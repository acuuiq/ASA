// فئة أساسية للموظف
abstract class BaseEmployee {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int completedJobs;
  final String imageUrl;
  final List<String> skills;
  final double hourlyRate;

  BaseEmployee({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.completedJobs,
    required this.imageUrl,
    required this.skills,
    required this.hourlyRate,
  });

  Map<String, dynamic> toMap();
}

// فئة Employee القديمة للتوافق (ضعها في نفس الملف أو ملف منفصل)
class Employee {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int completedJobs;
  final String imageUrl;
  final List<String> skills;
  final double hourlyRate;

  Employee({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.completedJobs,
    required this.imageUrl,
    required this.skills,
    required this.hourlyRate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'completedJobs': completedJobs,
      'imageUrl': imageUrl,
      'skills': skills,
      'hourlyRate': hourlyRate,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      completedJobs: map['completedJobs'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      hourlyRate: (map['hourlyRate'] ?? 0.0).toDouble(),
    );
  }
}
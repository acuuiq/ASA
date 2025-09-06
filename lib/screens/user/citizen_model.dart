class Citizen {
  final String id;
  final String name;
  final String email;
  final String department;
  final DateTime registrationDate;

  Citizen({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.registrationDate,
  });

  // تحويل البيانات إلى Map للتخزين
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
      'registrationDate': registrationDate.toIso8601String(),
    };
  }

  // إنشاء كائن من Map
  factory Citizen.fromMap(Map<String, dynamic> map) {
    return Citizen(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      department: map['department'],
      registrationDate: DateTime.parse(map['registrationDate']),
    );
  }
}
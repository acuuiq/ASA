import 'package:mang_mu/screens/citizen_model.dart';

class CitizenService {
  // قائمة مؤقتة لتخزين بيانات المواطنين (يمكن استبدالها بقاعدة بيانات)
  static List<Citizen> _citizens = [];

  // إضافة مواطن جديد
  static void addCitizen(Citizen citizen) {
    _citizens.add(citizen);
  }

  // الحصول على جميع المواطنين
  static List<Citizen> getAllCitizens() {
    return _citizens;
  }

  // الحصول على المواطنين حسب القسم
  static List<Citizen> getCitizensByDepartment(String department) {
    return _citizens
        .where((citizen) => citizen.department == department)
        .toList();
  }

  // البحث عن مواطن بالبريد الإلكتروني
  static Citizen? getCitizenByEmail(String email) {
    try {
      return _citizens.firstWhere((citizen) => citizen.email == email);
    } catch (e) {
      return null;
    }
  }

  // حذف مواطن
  static void removeCitizen(String id) {
    _citizens.removeWhere((citizen) => citizen.id == id);
  }

  // تحديث بيانات مواطن
  static void updateCitizen(Citizen updatedCitizen) {
    final index = _citizens.indexWhere(
      (citizen) => citizen.id == updatedCitizen.id,
    );
    if (index != -1) {
      _citizens[index] = updatedCitizen;
    }
  }
}

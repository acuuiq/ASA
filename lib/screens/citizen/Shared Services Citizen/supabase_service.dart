// services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io'; // ✅ إضافة هذا لاستخدام File

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> updateUserProfile(
    Map<String, dynamic> userData,
  ) async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        return {'success': false, 'message': 'المستخدم غير مسجل الدخول'};
      }

      // ⚠️ تحويل house_number إلى house_numb ليتوافق مع قاعدة البيانات
      final dbData = {
        'full_name': userData['full_name'],
        'email': userData['email'],
        'phone': userData['phone'],
        'id_number': userData['id_number'],
        'house_number': userData['house_number'], // ⚠️ التعديل هنا
        'location': userData['location'],
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('profiles')
          .update(dbData) // ⚠️ استخدام dbData المعدل
          .eq('id', user.id)
          .select();

      if (response.isEmpty) {
        return {'success': false, 'message': 'لم يتم العثور على المستخدم'};
      }

      return {
        'success': true,
        'message': 'تم تحديث الملف الشخصي بنجاح',
        'data': response.first,
      };
    } catch (e) {
      print('Supabase Error: $e');
      return {'success': false, 'message': 'فشل تحديث البيانات: $e'};
    }
  }

  // دالة للحصول على بيانات المستخدم
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        return {'success': false, 'message': 'المستخدم غير مسجل الدخول'};
      }

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id);

      if (response.isEmpty) {
        return {'success': false, 'message': 'لم يتم العثور على المستخدم'};
      }

      return {'success': true, 'data': response.first};
    } catch (e) {
      print('Supabase Error: $e');
      return {'success': false, 'message': 'فشل جلب البيانات: $e'};
    }
  }

  // ✅ دالة لرفع صورة السيلفي مع إضافة استيراد dart:io
  Future<String?> uploadSelfie(String imagePath) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final fileName =
          'selfie_${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // ✅ استخدم File من dart:io
      final file = File(imagePath);

      final response = await _supabase.storage
          .from('selfies') // اسم bucket في Supabase Storage
          .upload(fileName, file);

      // الحصول على رابط الصورة
      final imageUrl = _supabase.storage.from('selfies').getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }
}

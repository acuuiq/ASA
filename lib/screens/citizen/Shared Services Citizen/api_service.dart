import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://your-api-url.com/api'; // استبدل برابط API الخاص بك
  
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // أو أي طريقة تخزين token لديك
      
      final response = await http.post(
        Uri.parse('$baseUrl/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'فشل تحديث البيانات: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في الاتصال: $e',
      };
    }
  }
}
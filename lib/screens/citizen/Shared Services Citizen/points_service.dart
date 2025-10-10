// services/points_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class PointsService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // دالة للحصول على تيار للتغييرات الحية في نقاط المستخدم
  Stream<int> getUserPointsStream() {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    
    return _supabase
        .from('user_points')
        .stream(primaryKey: ['user_id'])
        .eq('user_id', user.id)
        .map((data) => data.isNotEmpty ? data[0]['total_points'] as int : 0);
  }

  // الحصول على نقاط المستخدم
  Future<int> getUserPoints() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('user_points')
        .select('total_points')
        .eq('user_id', user.id)
        .single();

    return response['total_points'] ?? 0;
  }

  // إضافة نقاط للمستخدم
  Future<void> addPoints({
    required int points,
    required String reason,
    String? serviceType,
    String? billNumber,
    String? referenceId,
    Duration? expiration,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // إضافة النقاط إلى جدول المعاملات
    await _supabase.from('points_transactions').insert({
      'user_id': user.id,
      'points': points,
      'type': 'earned',
      'reason': reason,
      'service_type': serviceType,
      'bill_number': billNumber,
      'reference_id': referenceId,
      'expires_at': expiration != null 
          ? DateTime.now().add(expiration).toIso8601String()
          : null,
    });

    // تحديث النقاط الإجمالية للمستخدم
    await _supabase.rpc('update_user_total_points', params: {
      'p_user_id': user.id,
      'p_points_to_add': points,
    });
  }

  // استخدام النقاط
  Future<void> usePoints({
    required int points,
    required String reason,
    String? referenceId,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // التحقق من أن المستخدم لديه نقاط كافية
    final currentPoints = await getUserPoints();
    if (currentPoints < points) {
      throw Exception('نقاط غير كافية');
    }

    // تسجيل معاملة استخدام النقاط
    await _supabase.from('points_transactions').insert({
      'user_id': user.id,
      'points': -points, // سالب للإشارة إلى الاستخدام
      'type': 'used',
      'reason': reason,
      'reference_id': referenceId,
    });

    // تحديث النقاط الإجمالية للمستخدم
    await _supabase.rpc('update_user_total_points', params: {
      'p_user_id': user.id,
      'p_points_to_add': -points, // سالب لخصم النقاط
    });
  }

  // الحصول على سجل النقاط
  Future<List<Map<String, dynamic>>> getPointsHistory({
    int limit = 50,
    int offset = 0,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('points_transactions')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(limit)
        .range(offset, offset + limit - 1);

    return response;
  }
}
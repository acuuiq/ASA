import 'package:supabase_flutter/supabase_flutter.dart';

class InvoicesService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // حفظ فاتورة جديدة
  Future<void> saveInvoice({
    required double amount,
    required String paymentMethod,
    required List<Map<String, dynamic>> services,
    required String status,
    int? pointsUsed,
    int? pointsEarned,
    double? pointsDiscount,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      await _supabase.from('invoices').insert({
        'user_id': user.id,
        'amount': amount,
        'payment_method': paymentMethod,
        'status': status,
        'services': services,
        'points_used': pointsUsed,
        'points_earned': pointsEarned,
        'points_discount': pointsDiscount,
        'payment_date': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error saving invoice: $e');
      throw e;
    }
  }

  // جلب الفواتير الخاصة بالمستخدم
  Future<List<Map<String, dynamic>>> getUserInvoices() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final response = await _supabase
          .from('invoices')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return response;
    } catch (e) {
      print('Error fetching invoices: $e');
      throw e;
    }
  }

  // حذف فاتورة
  Future<void> deleteInvoice(String invoiceId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      await _supabase
          .from('invoices')
          .delete()
          .eq('id', invoiceId)
          .eq('user_id', user.id);
    } catch (e) {
      print('Error deleting invoice: $e');
      throw e;
    }
  }

  // حذف جميع فواتير المستخدم
  Future<void> deleteAllUserInvoices() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      await _supabase
          .from('invoices')
          .delete()
          .eq('user_id', user.id);
    } catch (e) {
      print('Error deleting all invoices: $e');
      throw e;
    }
  }
  // إضافة دالة للحصول على تيار التحديثات
Stream<List<Map<String, dynamic>>> getInvoicesStream() {
  try {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    return _supabase
        .from('invoices')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
  } catch (e) {
    print('Error creating invoices stream: $e');
    throw e;
  }
}
  // التحقق من وجود فواتير جديدة
Future<bool> hasNewInvoices() async {
  try {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    // جلب آخر تاريخ مشاهدة
    final preferencesResponse = await _supabase
        .from('user_preferences')
        .select('last_invoices_seen')
        .eq('user_id', user.id)
        .single()
        .catchError((_) => null);

    DateTime lastSeen;
    
    if (preferencesResponse != null && preferencesResponse['last_invoices_seen'] != null) {
      lastSeen = DateTime.parse(preferencesResponse['last_invoices_seen']);
      print('📅 Last seen: $lastSeen'); // للت debug
    } else {
      // إذا لم يكن هناك سجل، لا تظهر النقطة الحمراء
      print('📅 No last seen record found'); // للت debug
      return false;
    }

    // التحقق من الفواتير الجديدة بعد آخر مشاهدة
    final invoicesResponse = await _supabase
        .from('invoices')
        .select('created_at, id')
        .eq('user_id', user.id)
        .gt('created_at', lastSeen.toIso8601String())
        .limit(1);

    print('🔍 New invoices found: ${invoicesResponse.isNotEmpty}'); // للت debug
    return invoicesResponse.isNotEmpty;
    
  } catch (e) {
    print('❌ Error checking new invoices: $e');
    return false;
  }
}

  // وضع علامة أن المستخدم شاهد الفواتير
 // وضع علامة أن المستخدم شاهد الفواتير
Future<void> markInvoicesAsSeen() async {
  try {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final now = DateTime.now().toIso8601String();
    
    await _supabase
        .from('user_preferences')
        .upsert({
          'user_id': user.id,
          'last_invoices_seen': now,
          'updated_at': now,
        }, 
        onConflict: 'user_id'
    );
    
    print('✅ Invoices marked as seen at: $now'); // للت debug
  } catch (e) {
    print('❌ Error marking invoices as seen: $e');
  }
}

  // جلب آخر تاريخ شوهدت فيه الفواتير
  Future<DateTime> _getLastSeenDate() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final response = await _supabase
          .from('user_preferences')
          .select('last_invoices_seen')
          .eq('user_id', user.id)
          .single()
          .catchError((_) => null);

      if (response != null && response['last_invoices_seen'] != null) {
        return DateTime.parse(response['last_invoices_seen']);
      }
      
      // إذا لم يكن هناك سجل، ارجع تاريخ قديم جداً
      return DateTime(2000);
    } catch (e) {
      print('Error getting last seen date: $e');
      return DateTime(2000);
    }
  }

}

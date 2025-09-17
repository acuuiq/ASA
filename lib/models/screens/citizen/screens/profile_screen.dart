import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
      static const String screen = 'profile_screen';

  final Map<String, dynamic>? userProfile;
  final Future<void> Function() onSignOut;
  final Color primaryColor;
  final Color textColor;
  final Color textSecondaryColor;
  final Color errorColor;

  const ProfileScreen({
    super.key,
    required this.userProfile,
    required this.onSignOut,
    required this.primaryColor,
    required this.textColor,
    required this.textSecondaryColor,
    required this.errorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Icon(Icons.person, size: 50, color: primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              userProfile?['full_name'] ?? 'غير معروف',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userProfile?['email'] ?? 'غير معروف',
              style: TextStyle(fontSize: 16, color: textSecondaryColor),
            ),
            const SizedBox(height: 24),
            _buildProfileInfoItem(
              Icons.credit_card,
              'رقم الهوية',
              userProfile?['id_number'] ?? 'غير معروف',
            ),
            _buildProfileInfoItem(
              Icons.email,
              'البريد الإلكتروني',
              userProfile?['email'] ?? 'غير معروف',
            ),
            _buildProfileInfoItem(
              Icons.star,
              'حالة الحساب',
              userProfile?['status'] == 'approved'
                  ? 'معتمد'
                  : userProfile?['status'] == 'under_review'
                      ? 'قيد المراجعة'
                      : 'مرفوض',
            ),
            const SizedBox(height: 32),
            // زر تسجيل الخروج
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await onSignOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: errorColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoItem(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
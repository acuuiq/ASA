import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final IconData? icon;
  final double fontSize; // إضافة خاصية حجم الخط

  const Mybutton({
    super.key,
    required this.color,
    required this.title,
    required this.onPressed,
    this.gradient,
    this.icon,
    this.fontSize = 18, // قيمة افتراضية
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12), // تعديل الهوامش
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // مهم لضبط المساحة
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize, // استخدام حجم الخط المحدد
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class WaterSupervisorScreen extends StatelessWidget {
  const WaterSupervisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مشرف المياه')),
      body: const Center(child: Text('محتوى شاشة مشرف المياه')),
    );
  }
}

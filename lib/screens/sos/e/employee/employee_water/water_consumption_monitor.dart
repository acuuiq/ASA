import 'package:flutter/material.dart';

class WaterConsumptionMonitorScreen extends StatelessWidget {
  const WaterConsumptionMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مراقب استهلاك المياه')),
      body: const Center(child: Text('محتوى شاشة مراقب استهلاك المياه')),
    );
  }
}

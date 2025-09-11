//مراقب الاستهلاك (الكهرباء)
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';

class ConsumptionMonitoringOfficerScreen extends StatelessWidget {
  const ConsumptionMonitoringOfficerScreen({super.key});
  static const String screenroot = 'consumption_monitoring_officer_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('مراقب الاستهلاك (الكهرباء)')),
      body: Center(child: Text('مرحبًا بك في شاشة مراقب الاستهلاك (الكهرباء)')),
    );
  }
}

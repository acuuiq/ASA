//شاشه مدير طلبات الحاويات ولنفايات
import 'package:flutter/material.dart';

class ContainerRequestManager extends StatelessWidget {
  const ContainerRequestManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Container Request Manager')),
      body: const Center(child: Text('Container Request Manager Screen')),
    );
  }
}

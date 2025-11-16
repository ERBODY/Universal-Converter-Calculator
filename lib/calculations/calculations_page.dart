import 'package:flutter/material.dart';

class CalculationsPage extends StatelessWidget {
  const CalculationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculations'),
      ),
      body: const Center(
        child: Text('Calculations Page'),
      ),
    );
  }
}

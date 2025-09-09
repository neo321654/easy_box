import 'package:easy_box/shared/widgets/gradient_action_card.dart';
import 'package:flutter/material.dart';

class ComponentTestPage extends StatelessWidget {
  const ComponentTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8474A1), // A purplish background like in the image
      appBar: AppBar(
        title: const Text('Component Test'),
        backgroundColor: const Color(0xFF6C5B7B),
      ),
      body: const Center(
        child: GradientActionCard(
          text: 'Sending Tasks',
          iconData: Icons.local_shipping_outlined,
        ),
      ),
    );
  }
}

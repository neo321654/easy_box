import 'package:flutter/material.dart';

class GradientActionCard extends StatelessWidget {
  final String text;
  final IconData iconData;
  final VoidCallback? onTap;

  const GradientActionCard({
    super.key,
    required this.text,
    required this.iconData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF8B195),
              Color(0xFFF67280),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black26,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Icon(
              iconData,
              color: Colors.white,
              size: 48,
              shadows: const [
                Shadow(
                  blurRadius: 3.0,
                  color: Colors.black38,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

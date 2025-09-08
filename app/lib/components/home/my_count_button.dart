import 'package:flutter/material.dart';

class MyCountButton extends StatelessWidget {

  final int count;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const MyCountButton({
    super.key,
    required this.count,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4,),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white
              ),
            )
          ],
        ),
      ),
    );
  }
}
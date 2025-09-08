import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final bool isOutlined;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isOutlined = false, // default is filled button
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : Colors.black87,
          borderRadius: BorderRadius.circular(8),
          border: isOutlined ? Border.all(color: Colors.grey[400]!) : null,
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(left: 40, right: 40, bottom: 12),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isOutlined ? Colors.black87 : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final String text;
  final void Function()? onTap;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(left: 40, right: 40, bottom: 12),
        child: Center(
          child: Text(text,),
        ),
      ),
    );
  }
}
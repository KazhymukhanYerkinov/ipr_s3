import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const ActionButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: IconButton(onPressed: onPressed, icon: Icon(icon, size: 28)),
    );
  }
}

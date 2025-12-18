import 'package:flutter/material.dart';

class BackButtonRounded extends StatelessWidget {
  final Color color;
  final double size;

  const BackButtonRounded({
    super.key,
    this.color = const Color(0xFF6667B0),
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_back,
          color: color,
          size: size * 0.55,
        ),
      ),
    );
  }
}

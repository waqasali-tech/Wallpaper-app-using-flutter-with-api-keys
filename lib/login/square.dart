import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final String ImagePath;
  final Function()? onTap;
  const Square({super.key, required this.ImagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.grey[200],
              border: Border.all(color: Colors.white12, width: 2.0)),
          child: Image.asset(
            ImagePath,
            height: 30,
          )),
    );
  }
}

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String? imagePath;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.imagePath,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 30,
        ),
        alignment: Alignment.center,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath != null)
            Image.asset(
              imagePath!,
              width: 30,
              height: 30,
            ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'InriaSans',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

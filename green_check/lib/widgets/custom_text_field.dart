import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool enabled;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.validator,
    this.controller,
    this.keyboardType = TextInputType.text,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.onTap,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onTap: onTap,
      onChanged: onChanged,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Color(0xF4D9D9D9), 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none 
        ),
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
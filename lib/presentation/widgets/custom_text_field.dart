import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
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
  final bool
      isPasswordField; // Nueva variable para identificar si es un campo de contraseña

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
    this.isPasswordField = false,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscure,
      keyboardType: widget.keyboardType,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      decoration: InputDecoration(
        hintText: widget.labelText,
        filled: true,
        fillColor: Color(0xF4D9D9D9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        prefixIcon: widget.isPasswordField
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
                child: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : Icon(widget.icon),
      ),
    );
  }
}

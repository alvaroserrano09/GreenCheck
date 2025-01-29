import 'package:flutter/material.dart';
import 'package:green_check/widgets/background.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const BackGround(title: "Registrarse"),
      );
  }
}
import 'package:flutter/material.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/custom_button.dart';
import 'package:green_check/presentation/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: IntrinsicHeight(
                    child: Stack(
                      children: [
                        const BackGround(title: "Iniciar Sesión"),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 100),
                              CustomTextField(
                                labelText: 'Correo electrónico',
                                icon: Icons.email,
                              ),
                              SizedBox(height: 16),
                              CustomTextField(
                                icon: Icons.remove_red_eye,
                                labelText: 'Contraseña',
                                obscureText: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomButton(
                    text: "Iniciar Sesión",
                    backgroundColor: Color(0xFF8DC324),
                    onPressed: () {},
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/forgot_password');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: '¿Has olvidado tu contraseña?',
                        style: const TextStyle(
                          color: Color(0xFF9CCA2C),
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

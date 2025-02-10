import 'package:flutter/material.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/custom_button.dart';
import 'package:green_check/presentation/widgets/custom_text_field.dart';
import 'package:green_check/presentation/widgets/toolbar.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                        const BackGround(title: "Registrarse"),
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
                                labelText: 'Nombre',
                                icon: Icons.person,
                              ),
                              SizedBox(height: 16),
                              CustomTextField(
                                labelText: 'Apellidos',
                                icon: Icons.person,
                              ),
                              SizedBox(height: 16),
                              CustomTextField(
                                icon: Icons.remove_red_eye,
                                labelText: 'Contraseña',
                                obscureText: true,
                              ),
                              SizedBox(height: 16),
                              CustomTextField(
                                icon: Icons.remove_red_eye,
                                labelText: 'Repetir Contraseña',
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
                    text: "Registrarse",
                    backgroundColor: Color(0xFF8DC324),
                    onPressed: () {},
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: '¿Ya tienes cuenta? ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Inicia sesión',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }
}

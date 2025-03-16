import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';

import 'package:green_check/presentation/widgets/custom_button.dart';
import 'package:green_check/presentation/widgets/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static const String name = 'login-screen';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Map<String, String?> errorMessages = {
    'email': null,
    'password': null,
  };

  void validateFields() {
    setState(() {
      errorMessages['email'] = emailController.text.isEmpty
          ? 'El correo electrónico es obligatorio.'
          : null;
      errorMessages['password'] = passwordController.text.isEmpty
          ? 'La contraseña es obligatoria.'
          : null;
    });
  }

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
                                controller: emailController,
                              ),
                              SizedBox(height: 16),
                              CustomTextField(
                                icon: Icons.remove_red_eye,
                                labelText: 'Contraseña',
                                obscureText: true,
                                isPasswordField: true,
                                controller: passwordController,
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
                    onPressed: () async {
                      validateFields();
                      if (errorMessages.values
                          .any((message) => message != null)) {
                        return;
                      }

                      try {
                        await ref.read(studentProvider.notifier).loginStudent(
                              email: emailController.text,
                              password: passwordController.text,
                            );

                        scaffoldMessengerKey.currentState?.showSnackBar(
                          const SnackBar(
                              content: Text('Inicio de sesión exitoso')),
                        );

                        context.replace('/home/user');
                      } catch (e) {
                        scaffoldMessengerKey.currentState?.showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
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

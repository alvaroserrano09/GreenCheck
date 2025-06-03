import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/presentation/providers/user_provider.dart';
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
      // Validación de email
      if (emailController.text.isEmpty) {
        errorMessages['email'] = 'El correo electrónico es obligatorio.';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
          .hasMatch(emailController.text)) {
        errorMessages['email'] = 'Ingresa un correo electrónico válido.';
      } else {
        errorMessages['email'] = null;
      }

      // Validación de contraseña
      if (passwordController.text.isEmpty) {
        errorMessages['password'] = 'La contraseña es obligatoria.';
      } else if (passwordController.text.length < 6) {
        errorMessages['password'] =
            'La contraseña debe tener al menos 6 caracteres.';
      } else {
        errorMessages['password'] = null;
      }
    });
  }

  Widget _buildErrorText(String? error) {
    return error != null
        ? Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0),
            child: Text(
              error,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(userProvider);
    final isLoading = provider.isLoading;
    final errorMessage = provider.errorMessage;

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
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
                                const SizedBox(height: 100),
                                CustomTextField(
                                  labelText: 'Correo electrónico',
                                  icon: Icons.email,
                                  controller: emailController,
                                ),
                                _buildErrorText(errorMessages['email']),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  icon: Icons.remove_red_eye,
                                  labelText: 'Contraseña',
                                  isPasswordField: true,
                                  controller: passwordController,
                                ),
                                _buildErrorText(errorMessages['password']),
                                if (errorMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      errorMessage,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                    ),
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
                      backgroundColor: const Color(0xFF8DC324),
                      onPressed: isLoading
                          ? null
                          : () async {
                              validateFields();
                              if (errorMessages.values
                                  .any((message) => message != null)) {
                                return;
                              }

                              try {
                                await ref
                                    .read(userProvider.notifier)
                                    .loginStudent(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );

                                scaffoldMessengerKey.currentState?.showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Inicio de sesión exitoso')),
                                );

                                context.replace('/home');
                              } catch (e) {
                                scaffoldMessengerKey.currentState?.showSnackBar(
                                  SnackBar(content: Text('$e')),
                                );
                              }
                            },
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                              context.push('/forgot_password');
                            },
                      child: RichText(
                        text: const TextSpan(
                          text: '¿Has olvidado tu contraseña?',
                          style: TextStyle(
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
      ),
    );
  }
}

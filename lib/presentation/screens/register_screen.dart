import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/custom_button.dart';
import 'package:green_check/presentation/widgets/custom_text_field.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(studentProvider);
    final isLoading = provider.isLoading;
    final errorMessage = provider.errorMessage;
    final isRegistered = provider.isRegistered;

    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final lastNameController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isRegistered) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrado con éxito')),
        );
        Future.delayed(const Duration(microseconds: 10), () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
    });

    return Scaffold(
      body: SafeArea(
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
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              const SizedBox(height: 100),
                              CustomTextField(
                                labelText: 'Correo electrónico',
                                icon: Icons.email,
                                controller: emailController,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                labelText: 'Nombre',
                                icon: Icons.person,
                                controller: nameController,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                labelText: 'Apellidos',
                                icon: Icons.person,
                                controller: lastNameController,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                icon: Icons.remove_red_eye,
                                labelText: 'Contraseña',
                                obscureText: true,
                                controller: passwordController,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                icon: Icons.remove_red_eye,
                                labelText: 'Repetir Contraseña',
                                obscureText: true,
                                controller: confirmPasswordController,
                              ),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomButton(
                text: "Registrarse",
                backgroundColor: const Color(0xFF8DC324),
                onPressed: () {
                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Las contraseñas no coinciden'),
                      ),
                    );
                    return;
                  }

                  ref.read(studentProvider.notifier).registerStudent(
                        email: emailController.text,
                        password: passwordController.text,
                        name: nameController.text,
                        surname: lastNameController.text,
                      );
                },
              ),
      ),
    );
  }
}

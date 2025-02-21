import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/custom_button.dart';
import 'package:green_check/presentation/widgets/custom_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  static const String name = 'register-screen';

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  Map<String, String?> errorMessages = {
    'email': null,
    'name': null,
    'lastName': null,
    'password': null,
    'confirmPassword': null,
  };

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    nameController = TextEditingController();
    lastNameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void validateFields() {
    setState(() {
      errorMessages['email'] = emailController.text.isEmpty
          ? 'El correo electrónico es obligatorio.'
          : null;
      errorMessages['name'] =
          nameController.text.isEmpty ? 'El nombre es obligatorio.' : null;
      errorMessages['lastName'] = lastNameController.text.isEmpty
          ? 'Los apellidos son obligatorios.'
          : null;
      errorMessages['password'] = passwordController.text.isEmpty
          ? 'La contraseña es obligatoria.'
          : null;
      errorMessages['confirmPassword'] = confirmPasswordController.text.isEmpty
          ? 'Debes repetir la contraseña.'
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(studentProvider);
    final isLoading = provider.isLoading;
    final errorMessage = provider.errorMessage;

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
                              if (errorMessages['email'] != null)
                                Text(
                                  errorMessages['email']!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                labelText: 'Nombre',
                                icon: Icons.person,
                                controller: nameController,
                              ),
                              if (errorMessages['name'] != null)
                                Text(
                                  errorMessages['name']!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                labelText: 'Apellidos',
                                icon: Icons.person,
                                controller: lastNameController,
                              ),
                              if (errorMessages['lastName'] != null)
                                Text(
                                  errorMessages['lastName']!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                icon: Icons.remove_red_eye,
                                labelText: 'Contraseña',
                                obscureText: true,
                                controller: passwordController,
                                isPasswordField: true,
                              ),
                              if (errorMessages['password'] != null)
                                Text(
                                  errorMessages['password']!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                icon: Icons.remove_red_eye,
                                labelText: 'Repetir Contraseña',
                                obscureText: true,
                                controller: confirmPasswordController,
                                isPasswordField: true,
                              ),
                              if (errorMessages['confirmPassword'] != null)
                                Text(
                                  errorMessages['confirmPassword']!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
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
                onPressed: () async {
                  validateFields();
                  if (errorMessages.values.any((message) => message != null)) {
                    return;
                  }

                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Las contraseñas no coinciden'),
                      ),
                    );
                    return;
                  }

                  try {
                    await ref.read(studentProvider.notifier).registerStudent(
                          email: emailController.text,
                          password: passwordController.text,
                          name: nameController.text,
                          surname: lastNameController.text,
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registrado con éxito')),
                    );

                    // Limpia los controladores
                    emailController.clear();
                    passwordController.clear();
                    nameController.clear();
                    lastNameController.clear();

                    // Navega a la ruta principal
                    context.push('/');
                  } catch (e) {
                    throw Exception(e);
                  }
                },
              ),
      ),
    );
  }
}

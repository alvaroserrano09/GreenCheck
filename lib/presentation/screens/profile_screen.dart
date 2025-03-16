import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_check/domain/models/user.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/custom_button.dart';
import 'package:green_check/presentation/widgets/custom_text_field.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  static const String name = 'profile-screen';

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends ConsumerState<ProfileScreen> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController surnameController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentState = ref.read(studentProvider);
    final User? student = studentState.student;
    final isLoading = studentState.isLoading;
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
                        const BackGround(title: "Editar Perfil"),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    const SizedBox(height: 50),
                                    Container(
                                      padding: const EdgeInsets.all(
                                          16), // Añade un padding interno
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD9D9D9)
                                            .withOpacity(
                                                0.25), // Fondo gris con opacidad
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Nombre",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'InriaSans',
                                                color: Color(0x63000000),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          CustomTextField(
                                            labelText: student!.name,
                                            controller: nameController,
                                          ),
                                          const SizedBox(height: 50),
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Apellidos",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'InriaSans',
                                                color: Color(0x63000000),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          CustomTextField(
                                            labelText: student.surname,
                                            controller: surnameController,
                                          ),
                                          const SizedBox(height: 50),
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Correo Electrónico",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'InriaSans',
                                                color: Color(0x63000000),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          CustomTextField(
                                              labelText: student.email,
                                              controller: emailController),
                                          const SizedBox(height: 30),
                                          CustomButton(
                                            text: "Guardar Cambios",
                                            backgroundColor:
                                                const Color(0xFF8DC324),
                                            onPressed: () async {
                                              try {
                                                await ref
                                                    .read(studentProvider
                                                        .notifier)
                                                    .updatePersonalInfo(
                                                      email: student.email,
                                                      name: nameController.text,
                                                      surname: surnameController
                                                          .text,
                                                    );
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Error al actulizar la información  $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
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
          ],
        ),
      ),
    );
  }
}

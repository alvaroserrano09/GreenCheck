import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:green_check/domain/models/user.dart' as user;
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/custom_button.dart';
import 'package:green_check/presentation/widgets/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  static const String name = 'profile-screen';

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends ConsumerState<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController surnameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    surnameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentState = ref.watch(studentProvider);
    final studentNotifier = ref.read(studentProvider.notifier);
    final user.User? student = studentState.student;
    final isLoading = studentState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const BackGround(title: "Editar Perfil"),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      const Text(
                                        "Mis datos",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Nombre",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            CustomTextField(
                                              labelText: student!.name,
                                              controller: nameController,
                                            ),
                                            const SizedBox(height: 20),
                                            const Text(
                                              "Apellidos",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            CustomTextField(
                                              labelText: student.surname,
                                              controller: surnameController,
                                            ),
                                            const SizedBox(height: 20),
                                            const Text(
                                              "Correo Electrónico",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            CustomTextField(
                                              labelText: student.email,
                                              enabled: false,
                                            ),
                                            const SizedBox(height: 30),
                                            CustomButton(
                                              text: "Modificar Cambios",
                                              backgroundColor:
                                                  const Color(0xFF8DC324),
                                              onPressed: () async {
                                                try {
                                                  await studentNotifier
                                                      .updatePersonalInfo(
                                                    email: student.email,
                                                    name: nameController
                                                            .text.isNotEmpty
                                                        ? nameController.text
                                                        : student.name,
                                                    surname: surnameController
                                                            .text.isNotEmpty
                                                        ? surnameController.text
                                                        : student.surname,
                                                    role: student.role!,
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Información actualizada'),
                                                    ),
                                                  );

                                                  nameController.clear();
                                                  surnameController.clear();
                                                  Navigator.pop(context);
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content:
                                                          Text('Error: $e'),
                                                      backgroundColor:
                                                          Colors.red,
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
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    children: [
                                      const Divider(color: Colors.grey),
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            final overlay = OverlayEntry(
                                              builder: (context) => const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            );
                                            Overlay.of(context).insert(overlay);

                                            await Supabase.instance.client.auth
                                                .signOut();

                                            try {
                                              final googleSignIn =
                                                  GoogleSignIn();
                                              if (await googleSignIn
                                                  .isSignedIn()) {
                                                await googleSignIn.disconnect();
                                                await googleSignIn.signOut();
                                              }
                                            } catch (e) {
                                              debugPrint(
                                                  'Error al cerrar Google: $e');
                                            }

                                            studentNotifier.logoutStudent();

                                            overlay.remove();
                                            if (mounted) context.go("/");
                                          } catch (e) {
                                            // Manejo de errores
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Error al cerrar sesión: ${e.toString()}'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: const Text(
                                          'Cerrar sesión',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Divider(color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

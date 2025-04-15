import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/presentation/widgets/custom_button_user.dart';
import 'package:green_check/presentation/widgets/toolbar.dart';
import 'package:green_check/presentation/providers/student_provider.dart';

class UserHomeScreen extends ConsumerWidget {
  const UserHomeScreen({super.key});
  static const String name = 'home-user-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentState = ref.watch(studentProvider);
    final student = studentState.student;

    final userName = student?.name ?? "Usuario";
    final role = student?.role;

    final isTeacher = role == 'profesor';

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFD1E34B), Color(0xFF5EAD09)],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = constraints.maxHeight;
                final screenWidth = constraints.maxWidth;

                double buttonTopPosition(int buttonNumber) {
                  if (isTeacher) {
                    return screenHeight * (0.55 + (buttonNumber - 1) * 0.2);
                  } else {
                    return screenHeight * (0.55 + (buttonNumber - 1) * 0.13);
                  }
                }

                return Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            top: screenHeight * 0.005,
                            left: (screenWidth - screenWidth * 0.8) / 2,
                            child: Image.asset(
                              'assets/icon/logo_gc_blanco.png',
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.4,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            top: screenHeight * 0.35,
                            left: screenWidth * 0.1,
                            right: screenWidth * 0.1,
                            child: AutoSizeText(
                              "Bienvenido de\nnuevo, $userName",
                              style: const TextStyle(
                                fontSize: 48,
                                color: Colors.white,
                                fontFamily: 'InriaSans',
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              minFontSize: 12,
                              stepGranularity: 1,
                            ),
                          ),
                          if (!isTeacher) ...[
                            Positioned(
                              top: buttonTopPosition(1),
                              left: screenWidth * 0.1,
                              right: screenWidth * 0.1,
                              child: CustomButtonUser(
                                text: 'Realizar Últimos Tests',
                                onPressed: () {
                                  context.push("/");
                                },
                              ),
                            ),
                            Positioned(
                              top: buttonTopPosition(2),
                              left: screenWidth * 0.1,
                              right: screenWidth * 0.1,
                              child: CustomButtonUser(
                                text: 'Ver Últimos Resultados',
                                onPressed: () {},
                              ),
                            ),
                            Positioned(
                              top: buttonTopPosition(3),
                              left: screenWidth * 0.1,
                              right: screenWidth * 0.1,
                              child: CustomButtonUser(
                                text: 'Cursos favoritos',
                                onPressed: () {},
                              ),
                            ),
                          ],
                          if (isTeacher) ...[
                            Positioned(
                              top: buttonTopPosition(1),
                              left: screenWidth * 0.1,
                              right: screenWidth * 0.1,
                              child: CustomButtonUser(
                                text: 'Añadir aviso',
                                onPressed: () {
                                  context.push(
                                      "/home/notices-screen/add-notice-screen");
                                },
                              ),
                            ),
                            Positioned(
                              top: buttonTopPosition(2),
                              left: screenWidth * 0.1,
                              right: screenWidth * 0.1,
                              child: CustomButtonUser(
                                text: 'Añadir curso',
                                onPressed: () {
                                  context.push("/home/add-course-screen");
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF5EAD09),
        ),
        child: const Toolbar(),
      ),
    );
  }
}

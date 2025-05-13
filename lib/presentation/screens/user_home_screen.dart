import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/infrastructure/services/google_service.dart';
import 'package:green_check/presentation/widgets/custom_button_user.dart';
import 'package:green_check/presentation/widgets/toolbar.dart';
import 'package:green_check/presentation/providers/student_provider.dart';

class UserHomeScreen extends ConsumerStatefulWidget {
  UserHomeScreen({super.key});
  static const String name = 'home-user-screen';
  final GoogleService googleService = GoogleService();

  @override
  ConsumerState<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends ConsumerState<UserHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late double screenWidth;
  late double screenHeight;
  late bool isTeacher;

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Salir de la aplicación?'),
            content:
                const Text('¿Estás seguro que quieres cerrar sesión y salir?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Salir'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _signOut() async {
    try {
      print("Cerrando sesión...");
      await widget.googleService.signOut();

      await ref.read(studentProvider.notifier).logoutStudent();
      if (!mounted) return;
      context.go('/'); // Redirige a la pantalla de inicio
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cerrar sesión: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  double buttonTopPosition(int buttonNumber) {
    return isTeacher
        ? screenHeight * (0.55 + (buttonNumber - 1) * 0.2)
        : screenHeight * (0.55 + (buttonNumber - 1) * 0.13);
  }

  Positioned _buildButton(int position, String text, VoidCallback onPressed) {
    return Positioned(
      top: buttonTopPosition(position),
      left: screenWidth * 0.1,
      right: screenWidth * 0.1,
      child: CustomButtonUser(
        text: text,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentState = ref.watch(studentProvider);
    final student = studentState.student;
    final userName = student?.name ?? "Usuario";
    isTeacher = student?.role == 'profesor';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          final shouldPop = await _showExitDialog();
          if (shouldPop && mounted) {
            await _signOut();
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            screenHeight = constraints.maxHeight;
            screenWidth = constraints.maxWidth;

            return Stack(
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
                  child: Column(
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
                              ),
                            ),
                            if (!isTeacher) ...[
                              _buildButton(1, 'Realizar Últimos Tests',
                                  () => context.push("/")),
                              _buildButton(2, 'Ver Últimos Resultados',
                                  () => context.push("/home/results-screen")),
                              _buildButton(3, 'Cursos favoritos',
                                  () => context.push("/home/favorites-screen")),
                            ] else ...[
                              _buildButton(
                                1,
                                'Añadir aviso',
                                () => context.push(
                                    "/home/notices-screen/add-notice-screen"),
                              ),
                              _buildButton(
                                2,
                                'Añadir curso',
                                () => context.push("/home/add-course-screen"),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF5EAD09),
          ),
          child: const Toolbar(),
        ),
      ),
    );
  }
}

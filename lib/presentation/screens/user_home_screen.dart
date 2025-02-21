import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:green_check/presentation/widgets/toolbar.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});
  static const String name = 'home-user-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final screenWidth = constraints.maxWidth;
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD1E34B), Color(0xFF5EAD09)],
                stops: [0.0, 1.0],
              ),
            ),
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
                    "Bienvenido de\nnuevo, Usuario",
                    style: TextStyle(
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
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Toolbar(),
    );
  }
}

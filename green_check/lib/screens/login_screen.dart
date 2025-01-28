import 'package:flutter/material.dart';
import 'package:green_check/widgets/background.dart'; // Ensure this import is correct
import 'package:auto_size_text/auto_size_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final screenWidth = constraints.maxWidth;
          return Stack(
            children: [
              const BackGround(title: 'Green Check', isUserLoggedIn:true),
              Positioned(
                top: screenHeight * 0.1,
                left: (screenWidth - screenWidth * 0.8) / 2,
                child: Image.asset(
                  'assets/icon/logo_gc_blanco.png',
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.4,
                  fit: BoxFit.contain,
                ),
              ),
       Positioned(
            top: screenHeight * 0.54,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: const Opacity(
              opacity: 0.69, 
              child: AutoSizeText(
                "Todo tipo de tests \n al alcance de tu mano.",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontFamily: 'InriaSans',
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                minFontSize: 12,
                stepGranularity: 1,
              ),
            ),
          ),
          
              // Otros widgets pueden ir aquí
            ],
          );
        },
      ),
    );
  }
}

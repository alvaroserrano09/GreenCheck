import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFD1E34B),
                Color(0xFF5EAD09)
              ],
              stops: [0.0, 1.0],
            ),
          ),
          child: Stack(
            children: [
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
              top:screenHeight * 0.26,
              left:screenWidth * 0.55,
              right:screenWidth * 0.05,
              child:Image(
                image: AssetImage(
                  'assets/check_2.png'
                  ),
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.5,
            ),

              ),
       Positioned(
            top: screenHeight * 0.54,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: const Opacity(
              opacity: 0.69, 
              child: AutoSizeText(
                "Todo tipo de tests al \n alcance de tu mano.",
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
          Positioned(
              top:screenHeight * 0.40,
              left: screenWidth * 0.05, 
              right: screenWidth * 0.55,
              child:Image(
                image: AssetImage(
                  'assets/check_1.png'
                  ),
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.5,
            ),

              ),
          Positioned(
            top: screenHeight * 0.7,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9CCA2C),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 30,
                ),
                alignment: Alignment.center,
              ),
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'InriaSans',
                  color: Colors.white,

                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.8,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA5D671),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  alignment: Alignment.center,
              ),
            
              child: const Text(
                'Registrarse',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'InriaSans',
                  color: Colors.white,

                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.9,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/googleSession');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1965BD),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 30,
                ),
                alignment: Alignment.center,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Image.asset(
                  'assets/logoGoogle.png',
                  width: 30,
                  height: 30,
                ),
                  const SizedBox(width: 15),

                  const Text(
                    'Continuar con Google',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'InriaSans',
                      color: Colors.white,
                    ),
                  ),
                 
                ],
              )
            ),
          ),
          
              // Otros widgets pueden ir aquí
            ],
          ),
          );
        },
      ),
    );
  }
}

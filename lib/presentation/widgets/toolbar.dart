import 'package:flutter/material.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFF8DC324),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF8DC324),
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('home_icon.png')),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('book_icon.png')),
              label: 'Mis cursos',
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('bell_icon.png')),
              label: "Avisos",
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('user_icon.png')),
              label: 'Perfil',
            ),
          ],
          selectedItemColor: Colors.white, // Color del texto seleccionado
          unselectedItemColor:
              Colors.white70, // Color del texto no seleccionado
          iconSize: 30, // Tamaño de los iconos
        ),
      ),
    );
  }
}

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
              icon: Image(image: AssetImage('assets/home_icon.png')),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('assets/book_icon.png')),
              label: 'Mis cursos',
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('assets/bell_icon.png')),
              label: "Avisos",
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('assets/user_icon.png')),
              label: 'Perfil',
            ),
          ],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          iconSize: 30,
        ),
      ),
    );
  }
}

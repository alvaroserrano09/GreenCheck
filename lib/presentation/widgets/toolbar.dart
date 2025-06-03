import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFF8DC324),
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
        selectedItemColor: Colors.white70,
        unselectedItemColor: Colors.white70,
        iconSize: 30,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              context.replace('/home');
              break;
            case 1:
              context.replace('/home/courses-screen');
              break;
            case 2:
              context.replace('/home/notices-screen');
              break;
            case 3:
              context.replace('/home/profile-screen');
              break;
          }
        },
      ),
    );
  }
}

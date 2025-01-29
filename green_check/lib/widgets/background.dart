import 'package:flutter/material.dart';

class BackGround extends StatelessWidget {
  final String title;

  const BackGround({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
              backgroundColor: const Color(0xFF8DC324),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: Container(color: Colors.white, height: 2),
              ),
              actions: [
                Image.asset(
                  'assets/icon/logo_gc_blanco.png',
                  height: 60,
                  width: 60,
                ),
              ],
          ),
      body: Container(
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
     
      ),
    );
  }
}

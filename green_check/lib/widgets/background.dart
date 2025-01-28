import 'package:flutter/material.dart';

class BackGround extends StatelessWidget {
  final String title;
  final bool? home;
  final Widget? page;
  final bool isUserLoggedIn;
  final bool showAppBar;

  const BackGround({
    super.key,
    required this.title,
    this.home,
    this.page,
    required this.isUserLoggedIn,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

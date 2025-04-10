import 'package:flutter/material.dart';
import 'package:green_check/presentation/widgets/background.dart';

class NoticesScrenn extends StatefulWidget {
  const NoticesScrenn({super.key});
  static const String name = 'notices-screen';

  @override
  State<NoticesScrenn> createState() => _NoticesScrennState();
}

class _NoticesScrennState extends State<NoticesScrenn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackGround(title: 'Avisos'),
    );
  }
}

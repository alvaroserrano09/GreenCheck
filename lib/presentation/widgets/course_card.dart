import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String teacher;
  final VoidCallback onTap; // Callback para manejar el toque

  const CourseCard({
    super.key,
    required this.title,
    required this.teacher,
    required this.onTap, // Añade el callback como parámetro requerido
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: GestureDetector(
        onTap: onTap, // Ejecuta el callback cuando se toca la tarjeta
        child: Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  teacher,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

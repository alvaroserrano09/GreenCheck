import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String teacher;
  final bool isFavorite;
  final VoidCallback onTap;
  final String? rol;
  final VoidCallback onPressed;

  const CourseCard({
    super.key,
    required this.title,
    required this.teacher,
    required this.onTap,
    required this.isFavorite,
    required this.onPressed,
    required this.rol,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Stack(
            children: [
              Padding(
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
              Positioned(
                top: 8.0,
                right: 8.0,
                child: IconButton(
                  icon: Icon(
                    rol == 'profesor'
                        ? Icons.delete
                        : isFavorite
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                    color: Colors.black,
                  ),
                  onPressed: onPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

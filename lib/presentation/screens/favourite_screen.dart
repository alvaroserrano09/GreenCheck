import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/domain/models/user.dart';
import 'package:green_check/presentation/providers/course_provider.dart';
import 'package:green_check/presentation/providers/user_provider.dart';
import 'package:green_check/presentation/widgets/background.dart';
import 'package:green_check/presentation/widgets/course_card.dart';
import 'package:green_check/presentation/widgets/toolbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  static const String name = "favorites-screen";

  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() {
    Future.microtask(() {
      final studentState = ref.read(userProvider);
      final User? student = studentState.student;
      if (student != null) {
        ref.read(courseProvider.notifier).loadCoursesForStudent(student.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseState = ref.watch(courseProvider);
    final studentState = ref.watch(userProvider);

    final favoriteCourses =
        courseState.courses.where((course) => course.isFavorite).toList();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const BackGround(title: "Mis Favoritos"),
            if (courseState.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (courseState.errorMessage != null)
              Center(
                child: Text(
                  'Error: ${courseState.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (favoriteCourses.isEmpty)
              const Center(
                child: Text(
                  'No tienes cursos favoritos',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: favoriteCourses.length,
                  itemBuilder: (context, index) {
                    final course = favoriteCourses[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: CourseCard(
                        rol: studentState.student?.role,
                        title: course.name,
                        teacher: course.teacherName != null
                            ? 'Profesor ${course.teacherName}'
                            : 'Profesor ${studentState.student?.name}',
                        onTap: () => context.push(
                            '/home/courses-screen/course-screen/${course.id}'),
                        isFavorite: course.isFavorite,
                        onPressed: () {
                          ref.read(courseProvider.notifier).toggleFavorite(
                              course.id, studentState.student!.id);
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }
}

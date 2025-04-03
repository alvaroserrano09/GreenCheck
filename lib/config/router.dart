import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/presentation/screens/admin/add_course_screen.dart';
import 'package:green_check/presentation/screens/course_screen.dart';
import 'package:green_check/presentation/screens/courses_screen.dart';
import 'package:green_check/presentation/screens/home_screen.dart';
import 'package:green_check/presentation/screens/login_screen.dart';
import 'package:green_check/presentation/screens/profile_screen.dart';
import 'package:green_check/presentation/screens/register_screen.dart';
import 'package:green_check/presentation/screens/students_screen.dart';
import 'package:green_check/presentation/screens/test_screen.dart';
import 'package:green_check/presentation/screens/tests_screen.dart';
import 'package:green_check/presentation/screens/user_home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/', // Ruta inicial
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const HomeScreen(),
    ),
    GoRoute(
      path: '/Register',
      name: RegisterScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const RegisterScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const LoginScreen(),
    ),
    GoRoute(
      path: '/home/user',
      name: UserHomeScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const UserHomeScreen(),
    ),
    GoRoute(
      path: '/home/add-course-screen',
      name: AddCourseScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const AddCourseScreen(),
    ),
    GoRoute(
      path: '/home/courses-screen',
      name: CoursesScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const CoursesScreen(),
    ),
    GoRoute(
      path: '/home/course-screen/:courseId', // Ruta dinámica
      builder: (context, state) {
        final int courseId =
            int.parse(state.pathParameters['courseId']!); // Extrae el ID
        return CourseScreen(courseId: courseId);
      },
    ),
    GoRoute(
      path: '/home/profile-screen',
      name: ProfileScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ProfileScreen(),
    ),
    GoRoute(
      path: '/home/tests-screen/:courseId',
      name: TestsScreen.name,
      builder: (context, state) {
        final int courseId = int.parse(state.pathParameters['courseId']!);
        return TestsScreen(courseId: courseId);
      },
    ),
    GoRoute(
      path: '/home/course-creen/students-screen/:courseId',
      name: StudentsScreen.name,
      builder: (context, state) {
        final int courseId = int.parse(state.pathParameters['courseId']!);
        return StudentsScreen(courseId: courseId);
      },
    ),
    GoRoute(
      path: '/home/course-screen/tests-screen/test-screen/:testId',
      name: TestScreen.name,
      builder: (context, state) {
        final int testId = int.parse(state.pathParameters['testId']!);
        return TestScreen(
          testId: testId,
        );
      },
    )
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    final isAuthenticated = await _checkIfUserIsAuthenticated();

    if (isAuthenticated && state.uri.path == '/') {
      return '/home/user';
    }

    return null;
  },
);

Future<bool> _checkIfUserIsAuthenticated() async {
  if (Supabase.instance.client.auth.currentUser != null) {
    return true;
  }
  return false;
}

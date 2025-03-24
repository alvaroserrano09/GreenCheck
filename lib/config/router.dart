import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/presentation/screens/admin/add_course_screen.dart';
import 'package:green_check/presentation/screens/course_screen.dart';
import 'package:green_check/presentation/screens/courses_screen.dart';
import 'package:green_check/presentation/screens/home_screen.dart';
import 'package:green_check/presentation/screens/login_screen.dart';
import 'package:green_check/presentation/screens/profile_screen.dart';
import 'package:green_check/presentation/screens/register_screen.dart';
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
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    final isAuthenticated = await _checkIfUserIsAuthenticated();

    if (isAuthenticated && state.uri.path == '/') {
      return '/home/user';
    }

    return null;
  },
);

// Simula la verificación de autenticación
Future<bool> _checkIfUserIsAuthenticated() async {
  print("entro");
  print(Supabase.instance.client.auth.currentUser);
  if (Supabase.instance.client.auth.currentUser != null) {
    print("entro true");
    return true;
  }
  return false; // Cambia esto según tu lógica de autenticación
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/screens/add_notice_screen.dart';
import 'package:green_check/presentation/screens/admin/add_course_screen.dart';
import 'package:green_check/presentation/screens/course_screen.dart';
import 'package:green_check/presentation/screens/courses_screen.dart';
import 'package:green_check/presentation/screens/home_screen.dart';
import 'package:green_check/presentation/screens/lasts_results_tests_screen.dart';
import 'package:green_check/presentation/screens/login_screen.dart';
import 'package:green_check/presentation/screens/notices_screnn.dart';
import 'package:green_check/presentation/screens/profile_screen.dart';
import 'package:green_check/presentation/screens/register_screen.dart';
import 'package:green_check/presentation/screens/review_test_screen.dart';
import 'package:green_check/presentation/screens/students_screen.dart';
import 'package:green_check/presentation/screens/test_screen.dart';
import 'package:green_check/presentation/screens/tests_screen.dart';
import 'package:green_check/presentation/screens/user_home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<bool> _checkIfUserIsAuthenticated(ProviderContainer container) async {
  final auth = Supabase.instance.client.auth;
  if (auth.currentUser != null) {
    final user = auth.currentUser!;
    await container.read(studentProvider.notifier).signInWithGoogle(user);
    return true;
  }
  return false;
}

final appRouter = GoRouter(
  initialLocation: '/',
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
      path: '/home/course-screen/:courseId',
      builder: (context, state) {
        final int courseId = int.parse(state.pathParameters['courseId']!);
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
        return TestScreen(testId: testId);
      },
    ),
    GoRoute(
      path: '/home/notices-screen',
      name: NoticesScreen.name,
      builder: (context, state) {
        return const NoticesScreen();
      },
    ),
    GoRoute(
      path: '/home/notices-screen/add-notice-screen',
      name: AddNoticeScreen.name,
      builder: (context, state) {
        return const AddNoticeScreen();
      },
    ),
    GoRoute(
      path: '/test-review',
      name: TestReviewScreen.name,
      builder: (context, state) {
        final extra = state.extra;

        if (extra is Map<String, dynamic>) {
          return TestReviewScreen(
            questions: extra['questions'],
            selectedAnswers: extra['answers'],
            score: extra['score'],
          );
        }
        throw Exception('Invalid extra data for TestReviewScreen');
      },
    ),
    GoRoute(
      path: '/home/results-screen',
      name: LastsResultsTestsScreen.name,
      builder: (context, state) {
        return const LastsResultsTestsScreen();
      },
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    try {
      final container = ProviderScope.containerOf(context);
      final isAuthenticated = await _checkIfUserIsAuthenticated(container);

      if (isAuthenticated && state.uri.path == '/') {
        return '/home/user';
      }
      return null;
    } catch (e) {
      return null;
    }
  },
);

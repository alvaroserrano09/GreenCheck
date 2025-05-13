import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_check/presentation/providers/student_provider.dart';
import 'package:green_check/presentation/screens/add_notice_screen.dart';
import 'package:green_check/presentation/screens/admin/add_course_screen.dart';
import 'package:green_check/presentation/screens/course_screen.dart';
import 'package:green_check/presentation/screens/courses_screen.dart';
import 'package:green_check/presentation/screens/favourite_screen.dart';
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
      builder: (BuildContext context, GoRouterState state) => HomeScreen(),
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
      path: '/home',
      name: UserHomeScreen.name,
      builder: (BuildContext context, GoRouterState state) => UserHomeScreen(),
      routes: [
        GoRoute(
          path: 'add-course-screen',
          name: AddCourseScreen.name,
          builder: (BuildContext context, GoRouterState state) =>
              const AddCourseScreen(),
        ),
        GoRoute(
          path: 'courses-screen',
          name: CoursesScreen.name,
          builder: (BuildContext context, GoRouterState state) =>
              const CoursesScreen(),
          routes: [
            GoRoute(
              path: 'course-screen/:courseId',
              builder: (context, state) {
                final courseId = state.pathParameters['courseId']!;
                return CourseScreen(courseId: courseId);
              },
              routes: [
                GoRoute(
                  path: 'tests-screen',
                  name: TestsScreen.name,
                  builder: (context, state) {
                    final courseId = state.pathParameters['courseId']!;
                    return TestsScreen(courseId: courseId);
                  },
                  routes: [
                    GoRoute(
                      path: 'test-screen/:testId',
                      name: TestScreen.name,
                      builder: (context, state) {
                        final testId = state.pathParameters['testId']!;
                        return TestScreen(testId: testId);
                      },
                      routes: [
                        GoRoute(
                          path: 'test-review',
                          name: TestReviewScreen.name,
                          builder: (context, state) {
                            final extra = state.extra as Map<String, dynamic>?;
                            if (extra != null) {
                              return TestReviewScreen(
                                questions: extra['questions'],
                                selectedAnswers: extra['answers'],
                                score: extra['score'],
                              );
                            }
                            throw Exception(
                                'Invalid extra data for TestReviewScreen');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: 'students-screen',
                  name: StudentsScreen.name,
                  builder: (context, state) {
                    final courseId = state.pathParameters['courseId']!;
                    return StudentsScreen(courseId: courseId);
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'profile-screen',
          name: ProfileScreen.name,
          builder: (BuildContext context, GoRouterState state) =>
              ProfileScreen(),
        ),
        GoRoute(
          path: 'notices-screen',
          name: NoticesScreen.name,
          builder: (context, state) => const NoticesScreen(),
          routes: [
            GoRoute(
              path: 'add-notice-screen',
              name: AddNoticeScreen.name,
              builder: (context, state) => const AddNoticeScreen(),
            ),
          ],
        ),
        GoRoute(
            path: 'results-screen',
            name: LastsResultsTestsScreen.name,
            builder: (context, state) => const LastsResultsTestsScreen(),
            routes: [
              GoRoute(
                path: 'test-screen/:testId',
                name: 'results-test-screen',
                builder: (context, state) {
                  final testId = state.pathParameters['testId']!;
                  return TestScreen(testId: testId);
                },
              ),
            ]),
        GoRoute(
          path: 'favorites-screen',
          name: FavoritesScreen.name,
          builder: (context, state) => const FavoritesScreen(),
        ),
      ],
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    try {
      final container = ProviderScope.containerOf(context);
      final isAuthenticated = await _checkIfUserIsAuthenticated(container);

      if (isAuthenticated && state.uri.path == '/') {
        return '/home';
      }
      return null;
    } catch (e) {
      return null;
    }
  },
);

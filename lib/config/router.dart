import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:green_check/presentation/screens/home_screen.dart';
import 'package:green_check/presentation/screens/login_screen.dart';
import 'package:green_check/presentation/screens/register_screen.dart';
import 'package:green_check/presentation/screens/user_home_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final appRouter =
    GoRouter(initialLocation: '/', navigatorKey: navigatorKey, routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.name,
    builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
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
    builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/home/:page',
    name: UserHomeScreen.name,
    builder: (BuildContext context, GoRouterState state) =>
        const UserHomeScreen(),
  )
]);

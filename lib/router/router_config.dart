import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_management/cookify/models/menu_model.dart';
import 'package:restaurant_management/router/router_constants.dart';

import '../Menu/UI/full_app.dart';
import '../Menu/UI/recipe_screen.dart';
import '../Signup/UI/forgot_password_screen.dart';
import '../Signup/UI/login_screen.dart';
import '../Signup/UI/register_screen.dart';
import '../Signup/UI/splash_screen.dart';

class AppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: RouterConstants.splashScreen,
        path: '/splash',
        pageBuilder: (context, state) =>
            MaterialPage(child: CookifySplashScreen()),
      ),
      GoRoute(
        name: RouterConstants.registerScreen,
        path: '/register',
        pageBuilder: (context, state) =>
            MaterialPage(child: CookifyRegisterScreen()),
      ),
      GoRoute(
        name: RouterConstants.loginScreen,
        path: '/login',
        pageBuilder: (context, state) =>
            MaterialPage(child: CookifyLoginScreen()),
      ),
      GoRoute(
        name: RouterConstants.forgotPasswordScreen,
        path: '/forgot_passwd',
        pageBuilder: (context, state) =>
            MaterialPage(child: CookifyForgotPasswordScreen()),
      ),
      GoRoute(
        name: RouterConstants.homeScreen,
        path: '/',
        pageBuilder: (context, state) => MaterialPage(child: CookifyFullApp()),
      ),
      GoRoute(
          name: RouterConstants.recipeScreen,
          path: '/recipe',
          builder: (context, state) {
            MenuItem item = state.extra as MenuItem;
            return MenuItemDetailScreen(menuItem: item);
          }),
    ],
    initialLocation: '/',
  );
}

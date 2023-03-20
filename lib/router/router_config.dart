import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_management/cookify/forgot_password_screen.dart';
import 'package:restaurant_management/cookify/full_app.dart';
import 'package:restaurant_management/cookify/login_screen.dart';
import 'package:restaurant_management/cookify/recipe_screen.dart';
import 'package:restaurant_management/cookify/register_screen.dart';
import 'package:restaurant_management/cookify/splash_screen.dart';
import 'package:restaurant_management/data/provider/firebase_auth.dart';
import 'package:restaurant_management/router/router_constants.dart';

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
        pageBuilder: (context, state) =>
            MaterialPage(child: CookifyRecipeScreen()),
      ),
    ],
    initialLocation: '/',
  );
}

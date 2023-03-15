import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management/cookify/full_app.dart';
import 'package:restaurant_management/cookify/login_screen.dart';
import 'package:restaurant_management/cookify/splash_screen.dart';
import 'package:restaurant_management/theme/app_notifier.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppNotifier()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CookifySplashScreen(),
    );
  }
}

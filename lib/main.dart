import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management/logic/bloc/auth_bloc.dart';
import 'package:restaurant_management/logic/bloc/bloc_observer.dart';
import 'package:restaurant_management/logic/repositories/firebase_auth.dart';
import 'package:restaurant_management/router/router_config.dart';
import 'package:restaurant_management/theme/app_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebaes
  await Firebase.initializeApp();

  Bloc.observer = AppBlocObserver();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppNotifier()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FAuth(),
      child: BlocProvider(
        create: (context) =>
            AuthBloc(FAuth: RepositoryProvider.of<FAuth>(context)),
        child: MaterialApp.router(
          routerConfig: AppRouter().router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

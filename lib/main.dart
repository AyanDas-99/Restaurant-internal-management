import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_management/data/provider/menu_provider.dart';
import 'package:restaurant_management/data/repositories/menu_repository.dart';
import 'package:restaurant_management/logic/bloc/auth_bloc.dart';
import 'package:restaurant_management/logic/bloc/bloc_observer.dart';
import 'package:restaurant_management/data/provider/firebase_auth.dart';
import 'package:restaurant_management/logic/bloc/menu_bloc.dart';
import 'package:restaurant_management/logic/bloc/user_like_bloc.dart';
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => FAuth(),
        ),
        RepositoryProvider(
          create: (context) => MenuRepository(),
        ),
        RepositoryProvider(
          create: (context) => FirestoreMenu(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(FAuth: RepositoryProvider.of<FAuth>(context)),
          ),
          BlocProvider(
            create: (context) => MenuBloc(
                menuRepository: RepositoryProvider.of<MenuRepository>(context),
                firestoreMenu: RepositoryProvider.of<FirestoreMenu>(context)),
          ),
          BlocProvider(
            create: (context) => UserLikeBloc(),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: AppRouter().router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

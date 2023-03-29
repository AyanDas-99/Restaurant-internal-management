import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver implements BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    print(change);
  }

  @override
  void onClose(BlocBase bloc) {
    print("closed bloc" + bloc.toString());
  }

  @override
  void onCreate(BlocBase bloc) {
    print("Created bloc" + bloc.toString());
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
  }
}

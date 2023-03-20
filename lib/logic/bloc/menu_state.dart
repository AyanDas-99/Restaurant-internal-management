part of 'menu_bloc.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoaded extends MenuState {
  final Menu menu;

  MenuLoaded({required this.menu});
}

class MenuLoading extends MenuState {}

class MenuError extends MenuState {
  final String errorMessage;

  MenuError(this.errorMessage);
}

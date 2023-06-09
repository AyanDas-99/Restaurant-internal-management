part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class FullMenuRequested extends MenuEvent {}

class TagMenuRequested extends MenuEvent {
  final String tag;

  TagMenuRequested(this.tag);
}

class CategoryMenuRequested extends MenuEvent {
  final String category;

  CategoryMenuRequested(this.category);
}

class SearchMenuRequested extends MenuEvent {
  final String query;

  SearchMenuRequested(this.query);
}

class FavoriteMenuRequested extends MenuEvent {
  final List likedItems;

  FavoriteMenuRequested(this.likedItems);
}

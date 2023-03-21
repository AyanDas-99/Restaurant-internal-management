import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurant_management/cookify/models/menu_model.dart';
import 'package:restaurant_management/data/provider/menu_provider.dart';
import 'package:restaurant_management/data/repositories/menu_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;
  final FirestoreMenu firestoreMenu;
  MenuBloc({required this.menuRepository, required this.firestoreMenu})
      : super(MenuInitial()) {
    on<FullMenuRequested>((event, emit) async {
      emit(MenuLoading());
      try {
        var fullMenu =
            await menuRepository.getFullMenu(firestoreMenu.getFullMenuList);
        emit(MenuLoaded(menu: fullMenu));
      } catch (e) {
        print(e);
        emit(MenuError("Sorry :( Menu not found"));
      }
    });

    // Category based menu
    on<CategoryMenuRequested>(
      (event, emit) async {
        emit(MenuLoading());
        try {
          var fullMenu = await menuRepository.getMenu(
              firestoreMenu.getCategoryMenuList, event.category);
          emit(MenuLoaded(menu: fullMenu));
        } catch (e) {
          print(e);
          emit(MenuError("Sorry :( Menu not found"));
        }
      },
    );

    on<SearchMenuRequested>(
      (event, emit) async {
        emit(MenuLoading());
        try {
          var fullMenu = await menuRepository.getMenu(
              firestoreMenu.getSearchedMenuList, event.query);
          emit(MenuLoaded(menu: fullMenu));
        } catch (e) {
          print(e);
          emit(MenuError("Sorry :( Menu not found"));
        }
      },
    );
  }
}

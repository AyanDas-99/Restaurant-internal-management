import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_management/data/provider/menu_provider.dart';
import 'package:restaurant_management/data/provider/user_provider.dart';
import 'package:restaurant_management/data/repositories/menu_repository.dart';
import 'package:restaurant_management/flutx/lib/extensions/string_extension.dart';
import 'package:restaurant_management/logic/bloc/menu_bloc.dart';
import 'package:restaurant_management/logic/bloc/user_like_bloc.dart';
import 'package:restaurant_management/router/router_constants.dart';
import 'package:restaurant_management/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'models/menu_model.dart';
import 'models/category.dart';
import 'models/showcase.dart';

class CookifyShowcaseScreen extends StatefulWidget {
  @override
  _CookifyShowcaseScreenState createState() => _CookifyShowcaseScreenState();
}

class _CookifyShowcaseScreenState extends State<CookifyShowcaseScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final menuRepository = MenuRepository();
  final firestoreMenu = FirestoreMenu();
  final firestoreUserData = FirestoreUser();

// Bloc
  late MenuBloc _menuBloc;
  late UserLikeBloc _likeBloc;
  // focus node for search bar
  final FocusNode _focusNode = FocusNode();

  late List<Showcase> showcases;
  late List<Category> categories;
  late CustomTheme customTheme;
  late ThemeData theme;

  String selectedCategory = "Menu(All)";

  // Controller
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _menuBloc =
        MenuBloc(menuRepository: menuRepository, firestoreMenu: firestoreMenu)
          ..add(FullMenuRequested());
    _likeBloc = UserLikeBloc()..add(GetLikes(user?.email ?? ""));
    showcases = Showcase.getList();
    categories = Category.getList();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  void dispose() {
    _menuBloc.close();
    _focusNode.dispose();
    _likeBloc.close();
    super.dispose();
  }

  // Get menu item names
  // Store the names in menuItemNames list
  // Return items list based on pattern
  Future<Iterable<String>> getItemNames(String pattern) async {
    List<String> menuItemNames = [];
    var menuItems =
        await menuRepository.getFullMenu(firestoreMenu.getFullMenuList);
    for (var item in menuItems.menuItems) {
      menuItemNames.add(item.item_name);
    }
    Iterable<String> list =
        menuItemNames.where((element) => element.contains(pattern));
    return list;
  }

  // Select category
  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });

    _menuBloc.add(CategoryMenuRequested(category.toLowerCase()));
  }

  // Select Home
  void selectHome() {
    setState(() {
      selectedCategory = 'Menu(All)';
    });
    _menuBloc.add(FullMenuRequested());
  }

  // Search for menu
  void searchMenu(String query) {
    setState(() {
      selectedCategory = query;
    });
    _menuBloc.add(SearchMenuRequested(query));
    print("The query is " + query);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: customTheme.cookifyPrimary.withAlpha(40))),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: FxSpacing.top(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding:
                          FxSpacing.symmetric(horizontal: 16, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.bodyLarge(
                            "Hello ${user?.displayName ?? ""}",
                            fontSize: 20,
                            fontWeight: 700,
                            color: customTheme.cookifyPrimary,
                          ),
                          FxText.bodySmall(
                              "Excited to try something new today?")
                        ],
                      )),
                  Container(
                    padding: FxSpacing.x(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                                onSubmitted: (value) => searchMenu(value),
                                focusNode: _focusNode,
                                controller: searchController,
                                style: DefaultTextStyle.of(context).style,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: customTheme.cookifyPrimary)),
                                    hintText: "Search",
                                    border: OutlineInputBorder())),
                            suggestionsCallback: (pattern) async {
                              return await getItemNames(pattern);
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              searchController.text = suggestion;
                              searchMenu(searchController.text);
                              _focusNode.unfocus();
                            },
                          ),
                        ),
                        FxSpacing.width(16),
                        InkWell(
                          onTap: () {
                            searchMenu(searchController.text);
                            _focusNode.unfocus();
                          },
                          child: FxContainer(
                            padding: FxSpacing.all(12),
                            color: customTheme.cookifyPrimary.withAlpha(80),
                            child: Icon(
                              Icons.local_dining_outlined,
                              size: 24,
                              color: customTheme.cookifyPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FxSpacing.height(16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: buildCategories(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: FxText.bodyMedium(
                        selectedCategory,
                        fontSize: 20,
                        fontWeight: 600,
                        color: customTheme.cookifyPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: FxSpacing.fromLTRB(16, 24, 16, 0),
                    child: BlocBuilder<MenuBloc, MenuState>(
                      bloc: _menuBloc,
                      builder: (context, menuState) {
                        return BlocBuilder<UserLikeBloc, UserLikeState>(
                            bloc: _likeBloc,
                            builder: (context, likeState) {
                              if (menuState is MenuLoaded &&
                                  likeState is UserLikes) {
                                return Column(
                                  children: buildShowcases(menuState.menu),
                                );
                              }
                              if (menuState is MenuError) {
                                return Text(menuState.errorMessage);
                              }

                              if (menuState is MenuLoaded) {
                                return Column(
                                  children: buildShowcases(menuState.menu),
                                );
                              }
                              return Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: customTheme.cookifyPrimary,
                                )),
                              );
                            });
                      },
                    ),
                  ),
                  FxSpacing.height(24)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildShowcases(Menu menu) {
    return menu.menuItems.map((e) => singleShowcase(e)).toList();
  }

  Widget singleShowcase(MenuItem showcase) {
    return FxContainer(
      onTap: () {
        _showSheet(showcase, context);
      },
      color: Colors.transparent,
      padding: FxSpacing.bottom(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Image(
              image: NetworkImage(showcase.image),
            ),
          ),
          FxSpacing.height(8),
          FxText.bodyLarge(showcase.item_name.capitalize,
              fontWeight: 700, letterSpacing: 0),
          FxText.bodySmall(showcase.description,
              muted: true, fontWeight: 500, letterSpacing: -0.1),
          FxSpacing.height(16),
          Row(
            children: [
              BlocConsumer<UserLikeBloc, UserLikeState>(
                  bloc: _likeBloc,
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    if (state is UserLikes) {
                      return InkWell(
                        onTap: () {
                          if (state.likedItems.contains(showcase.item_name)) {
                            _likeBloc.add(RemoveItemLike(
                                showcase.item_name, user?.email ?? ""));
                          } else
                            _likeBloc.add(LikeItem(
                                showcase.item_name, user?.email ?? ""));
                        },
                        child: Icon(
                          (state.likedItems.contains(showcase.item_name)
                              ? Icons.favorite
                              : Icons.favorite_border_outlined),
                          size: 16,
                          color: Colors.red[800],
                        ),
                      );
                    }
                    return Icon(
                      Icons.favorite_border_rounded,
                      size: 17,
                      color: Colors.red,
                    );
                  }),
              FxSpacing.width(4),
              FxText.bodySmall(showcase.likes.toString(), muted: true),
              FxSpacing.width(16),
              Icon(
                Icons.currency_rupee,
                size: 16,
                color: theme.colorScheme.onBackground.withAlpha(200),
              ),
              FxSpacing.width(4),
              FxText.bodySmall(showcase.price.toString(), muted: true),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> buildCategories() {
    List<Widget> list = [];

    list.add(FxSpacing.width(16));

    bool ishome = true;
    for (Category category in categories) {
      list.add(singleCategory(category, ishome));
      list.add(FxSpacing.width(16));
      ishome = false;
    }
    return list;
  }

  Widget singleCategory(Category category, bool isHome) {
    return InkWell(
      onTap: () => isHome ? selectHome() : selectCategory(category.title),
      child: FxContainer(
        paddingAll: 16,
        color: customTheme.cookifyPrimary.withAlpha(40),
        child: Column(
          children: [
            Icon(
              category.icon,
              color: customTheme.cookifyPrimary,
              size: 28,
            ),
            FxSpacing.height(8),
            FxText.bodySmall(
              category.title,
              color: customTheme.cookifyPrimary,
            )
          ],
        ),
      ),
    );
  }

  _showSheet(MenuItem item, BuildContext pageContext) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => Container(
              color: customTheme.cookifyOnPrimary,
              child: CupertinoActionSheet(
                title: FxText.titleLarge(item.item_name.capitalize,
                    fontWeight: 700, letterSpacing: 0.5),
                message: FxText.titleSmall("Select any action",
                    fontWeight: 500, letterSpacing: 0.2),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.cartPlus),
                        FxSpacing.width(20),
                        FxText.bodyLarge(
                          "Add to order",
                          fontWeight: 600,
                        )
                      ],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.info),
                        FxSpacing.width(20),
                        FxText.bodyLarge(
                          "Know more",
                          fontWeight: 600,
                        )
                      ],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      GoRouter.of(pageContext)
                          .pushNamed(RouterConstants.recipeScreen, extra: item);
                    },
                  )
                ],
                cancelButton: Container(
                  color: Color.fromARGB(255, 255, 169, 169),
                  child: CupertinoActionSheetAction(
                    child: FxText.titleMedium("Cancel", fontWeight: 600),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ));
  }
}

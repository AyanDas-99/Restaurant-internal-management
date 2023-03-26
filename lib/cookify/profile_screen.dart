import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_management/cookify/models/menu_model.dart';
import 'package:restaurant_management/logic/bloc/auth_bloc.dart';
import 'package:restaurant_management/logic/bloc/menu_bloc.dart';
import 'package:restaurant_management/logic/bloc/user_like_bloc.dart';
import 'package:restaurant_management/router/router_constants.dart';
import 'package:restaurant_management/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../data/provider/menu_provider.dart';
import '../data/repositories/menu_repository.dart';

class CookifyProfileScreen extends StatefulWidget {
  @override
  _CookifyProfileScreenState createState() => _CookifyProfileScreenState();
}

class _CookifyProfileScreenState extends State<CookifyProfileScreen> {
// User
  final User? user = FirebaseAuth.instance.currentUser;

// Menu bloc
  late MenuBloc _menuBloc;
  late UserLikeBloc _userLikeBloc;

  final menuRepository = MenuRepository();
  final firestoreMenu = FirestoreMenu();

  late CustomTheme customTheme;
  late ThemeData theme;

  bool notification = true, offlineReading = false;

  @override
  void initState() {
    super.initState();
    _userLikeBloc = UserLikeBloc()..add(GetLikes(user?.email ?? ""));
    _menuBloc =
        MenuBloc(menuRepository: menuRepository, firestoreMenu: firestoreMenu);
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserLikeBloc, UserLikeState>(
      bloc: _userLikeBloc,
      listener: (context, state) {
        if (state is UserLikes) {
          _menuBloc.add(FavoriteMenuRequested(state.likedItems));
        }
      },
      child: Theme(
        data: theme.copyWith(
            colorScheme: theme.colorScheme
                .copyWith(secondary: customTheme.cookifyPrimary.withAlpha(40))),
        child: SafeArea(
          child: Scaffold(
            body: ListView(
              padding: FxSpacing.fromLTRB(24, 36, 24, 24),
              children: [
                FxContainer(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FadeInImage(
                          image: NetworkImage(user?.photoURL ?? ""),
                          height: 100,
                          width: 100,
                          placeholder: AssetImage(
                              "assets/images/profile_placeholder.jpeg"),
                          imageErrorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            '/assets/images/profile_placeholder.jpeg',
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      FxSpacing.width(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FxText.bodyLarge(user?.displayName ?? "",
                                fontWeight: 700),
                            FxSpacing.width(8),
                            FxText.bodyMedium(
                              user?.email ?? "",
                            ),
                            FxSpacing.height(8),
                            FxButton.outlined(
                                onPressed: () {},
                                splashColor:
                                    customTheme.cookifyPrimary.withAlpha(40),
                                borderColor: customTheme.cookifyPrimary,
                                padding: FxSpacing.xy(16, 4),
                                borderRadiusAll: 32,
                                child: FxText.bodySmall("Edit profile",
                                    color: customTheme.cookifyPrimary))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FxSpacing.height(24),
                FxContainer(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      dense: true,
                      contentPadding: FxSpacing.zero,
                      visualDensity: VisualDensity.compact,
                      title: FxText.bodyLarge(
                        "Favorite Recipes",
                        letterSpacing: 0,
                      ),
                    ),
                    FxSpacing.height(16),
                    BlocConsumer<MenuBloc, MenuState>(
                      bloc: _menuBloc,
                      listener: (context, state) {
                        if (state is MenuError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.errorMessage)));
                        }
                      },
                      builder: (context, state) {
                        if (state is MenuLoaded) {
                          return favoriteGrid(state.menu);
                        }
                        if (state is MenuLoading || state is MenuInitial) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container(
                          child: Text("Couldn't load menu"),
                        );
                      },
                    ),
                    FxSpacing.height(16),
                    Center(
                        child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthUnAuthenticated) {
                          GoRouter.of(context)
                              .goNamed(RouterConstants.loginScreen);
                        }
                      },
                      builder: (context, state) {
                        return FxButton.rounded(
                          onPressed: () {
                            context.read<AuthBloc>().add(SignOutRequested());
                          },
                          child: FxText.labelLarge(
                            "LOGOUT",
                            color: customTheme.cookifyOnPrimary,
                          ),
                          elevation: 2,
                          backgroundColor: customTheme.cookifyPrimary,
                        );
                      },
                    ))
                  ],
                )),
                FxSpacing.height(24),
                FxContainer(
                    color: customTheme.cookifyPrimary.withAlpha(40),
                    padding: FxSpacing.xy(16, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FxTwoToneIcon(
                          FxTwoToneMdiIcons.headset_mic,
                          size: 32,
                          color: customTheme.cookifyPrimary,
                        ),
                        FxSpacing.width(12),
                        FxText.bodySmall(
                          "Feel Free to Ask, We Ready to Help",
                          color: customTheme.cookifyPrimary,
                          letterSpacing: 0,
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget favoriteGrid(Menu favoriteMenu) {
    return Column(children: getFavoriteList(favoriteMenu));
  }

  List<Widget> getFavoriteList(Menu favoriteMenu) {
    List<Widget> list = [];

    for (MenuItem item in favoriteMenu.menuItems) {
      list.add(Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(item.image),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                item.item_name,
                style: TextStyle(),
              ),
            ),
            IconButton(
              onPressed: () {
                _userLikeBloc
                    .add(RemoveItemLike(item.item_name, user?.email ?? ""));
              },
              icon: Icon(Icons.cancel),
              color: customTheme.cookifyPrimary,
            ),
          ],
        ),
      ));
      list.add(SizedBox(
        height: 20,
      ));
    }
    return list;
  }
}

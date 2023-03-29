import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_management/cookify/models/menu_model.dart';
import 'package:restaurant_management/flutx/lib/extensions/string_extension.dart';
import 'package:restaurant_management/logic/bloc/auth_bloc.dart';
import 'package:restaurant_management/logic/bloc/menu_bloc.dart';
import 'package:restaurant_management/logic/bloc/user_like_bloc.dart';
import 'package:restaurant_management/router/router_constants.dart';
import 'package:restaurant_management/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../data/provider/menu_provider.dart';
import '../data/repositories/menu_repository.dart';
import '../logic/bloc/order_bloc.dart';

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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FxSpacing.height(24),
                FxContainer(
                    child: Column(
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
                          if (state.menu.menuItems.length == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FxSvg(
                                  'assets/images/undraw_love_it_3km3.svg',
                                  size: 60,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Nothing added to favorite",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            );
                          }
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
      list.add(Builder(builder: (context) {
        return InkWell(
          onTap: () => _showSheet(item, context),
          child: Container(
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
          ),
        );
      }));
      list.add(SizedBox(
        height: 20,
      ));
    }
    return list;
  }

  // Dialog to select "know more" or "add to order"
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
                      _showDialog(item);
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

  void _showDialog(MenuItem item) {
    showDialog(
        context: context,
        builder: (BuildContext context) => _SimpleDialog(
              item: item,
            ));
  }
}

class _SimpleDialog extends StatefulWidget {
  int quantity = 1;
  final MenuItem item;

  _SimpleDialog({super.key, required this.item});

  @override
  State<_SimpleDialog> createState() => _SimpleDialogState();
}

class _SimpleDialogState extends State<_SimpleDialog> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: FxSpacing.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FxText.titleLarge(
              "Set quantity",
              fontWeight: 700,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (widget.quantity == 0) return null;
                      setState(() {
                        widget.quantity--;
                      });
                    },
                    icon: Icon(Icons.remove)),
                SizedBox(
                  width: 10,
                ),
                Text(widget.quantity.toString()),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.quantity++;
                      });
                    },
                    icon: Icon(Icons.add)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text("Cancel"),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.redAccent)),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<OrderBloc>().add(OrderAddRequest(
                        item: widget.item, quantity: widget.quantity));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Color.fromARGB(255, 178, 255, 181),
                        elevation: 0.0,
                        content: Text(
                          "Added to list",
                          style: TextStyle(color: Colors.black),
                        ),
                        duration: Duration(milliseconds: 2000),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )));
                    context.pop();
                  },
                  child: Text("Ok"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:restaurant_management/theme/app_theme.dart';
import 'package:flutx/flutx.dart';
import 'meal_plan_screen.dart';
import 'package:flutter/material.dart';

import 'profile_screen.dart';
import 'showcase_screen.dart';

class CookifyFullApp extends StatefulWidget {
  @override
  _CookifyFullAppState createState() => _CookifyFullAppState();
}

class _CookifyFullAppState extends State<CookifyFullApp> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: customTheme.cookifyPrimary.withAlpha(40))),
      child: Scaffold(
        body: FxBottomNavigationBar(
          activeTitleStyle: FxTextStyle.bodySmall(
              color: customTheme.cookifyPrimary, fontWeight: 800),
          itemList: [
            FxBottomNavigationBarItem(
              page: CookifyShowcaseScreen(),
              icon: FxTwoToneIcon(
                FxTwoToneMdiIcons.import_contacts,
                color: customTheme.cookifyPrimary.withAlpha(240),
                size: 24,
              ),
              activeIcon: Icon(
                Icons.menu_book,
                color: customTheme.cookifyPrimary.withAlpha(240),
                size: 24,
              ),
              title: "Menu",
              activeIconColor: customTheme.cookifyPrimary,
              activeTitleColor: customTheme.cookifyPrimary,
            ),
            FxBottomNavigationBarItem(
              page: CookifyMealPlanScreen(),
              icon: FxTwoToneIcon(
                FxTwoToneMdiIcons.fastfood,
                color: customTheme.cookifyPrimary.withAlpha(240),
                size: 24,
              ),
              activeIcon: Icon(
                Icons.lunch_dining,
                color: customTheme.cookifyPrimary,
                size: 24,
              ),
              title: "Meal",
              activeIconColor: customTheme.cookifyPrimary,
              activeTitleColor: customTheme.cookifyPrimary,
            ),
            FxBottomNavigationBarItem(
              page: CookifyProfileScreen(),
              icon: FxTwoToneIcon(
                FxTwoToneMdiIcons.person,
                color: customTheme.cookifyPrimary.withAlpha(240),
                size: 24,
              ),
              activeIcon: Icon(
                Icons.person,
                color: customTheme.cookifyPrimary,
                size: 24,
              ),
              title: "Setting",
              activeIconColor: customTheme.cookifyPrimary,
              activeTitleColor: customTheme.cookifyPrimary,
            ),
          ],
          activeContainerColor: theme.primaryColor.withAlpha(100),
          fxBottomNavigationBarType: FxBottomNavigationBarType.normal,
          backgroundColor: customTheme.card,
          showLabel: false,
          labelSpacing: 8,
          initialIndex: 0,
          labelDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

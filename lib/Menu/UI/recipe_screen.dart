import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_management/cookify/models/menu_model.dart';
import 'package:restaurant_management/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

class MenuItemDetailScreen extends StatefulWidget {
  final MenuItem menuItem;

  const MenuItemDetailScreen({super.key, required this.menuItem});

  @override
  _MenuItemDetailScreenState createState() => _MenuItemDetailScreenState();
}

class _MenuItemDetailScreenState extends State<MenuItemDetailScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    print(widget.menuItem);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: customTheme.cookifyPrimary.withAlpha(40))),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left,
              color: theme.colorScheme.onBackground,
            ),
          ),
          actions: [
            Icon(
              Icons.favorite_border,
              color: customTheme.cookifyPrimary,
            ),
            FxSpacing.width(16)
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: customTheme.cookifyPrimary,
          label: FxText.bodyMedium("Add to order",
              color: customTheme.cookifyOnPrimary, fontWeight: 600),
          icon: FaIcon(
            FontAwesomeIcons.cartPlus,
            color: customTheme.cookifyOnPrimary,
          ),
        ),
        body: Container(
          color: theme.scaffoldBackgroundColor,
          child: ListView(
            padding: FxSpacing.fromLTRB(24, 4, 24, 0),
            children: [
              FxText.displaySmall(widget.menuItem.item_name,
                  fontWeight: 800, letterSpacing: -0.2),
              FxSpacing.height(8),
              FxText.bodyMedium(widget.menuItem.description,
                  color: theme.colorScheme.onBackground.withAlpha(140),
                  letterSpacing: 0,
                  fontWeight: 600),
              FxSpacing.height(24),
              FxSpacing.width(24),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: NetworkImage(widget.menuItem.image),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              FxSpacing.height(24),
              FxText.titleLarge("Main Ingredients",
                  fontWeight: 700, letterSpacing: -0.2),
              FxSpacing.height(12),
              Wrap(
                children: buildIngredientList(widget.menuItem.ingredients),
              ),
              FxSpacing.height(80)
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildIngredientList(List ingredientList) {
    List<Widget> list = [];
    for (var ingredient in ingredientList) {
      list.add(Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: customTheme.border),
        margin: FxSpacing.all(2),
        padding: FxSpacing.all(5),
        child: FxText(ingredient.toString()),
      ));
    }
    return list;
  }
}

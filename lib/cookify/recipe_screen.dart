import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_management/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import 'models/full_recipe.dart';

class CookifyRecipeScreen extends StatefulWidget {
  @override
  _CookifyRecipeScreenState createState() => _CookifyRecipeScreenState();
}

class _CookifyRecipeScreenState extends State<CookifyRecipeScreen> {
  late FullRecipe recipe;
  late CustomTheme customTheme;
  late ThemeData theme;

  late List<Widget> ingredients;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    recipe = FullRecipe.getSingle();
    ingredients = buildIngredientList();
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
          label: FxText.bodyMedium("Order now",
              color: customTheme.cookifyOnPrimary, fontWeight: 600),
          icon: FaIcon(
            FontAwesomeIcons.bowlRice,
            color: customTheme.cookifyOnPrimary,
          ),
        ),
        body: Container(
          color: theme.scaffoldBackgroundColor,
          child: ListView(
            padding: FxSpacing.fromLTRB(24, 4, 24, 0),
            children: [
              FxText.displaySmall(recipe.title,
                  fontWeight: 800, letterSpacing: -0.2),
              FxSpacing.height(8),
              FxText.bodyMedium(recipe.body,
                  color: theme.colorScheme.onBackground.withAlpha(140),
                  letterSpacing: 0,
                  fontWeight: 600),
              FxSpacing.height(24),
              FxSpacing.width(24),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: AssetImage(recipe.image),
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
                children: ingredients,
              ),
              FxSpacing.height(80)
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildIngredientList() {
    List<Widget> list = [];
    for (Ingredient ingredient in recipe.ingredients) {
      list.add(Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: customTheme.border),
        margin: FxSpacing.all(2),
        padding: FxSpacing.all(5),
        child: FxText(
          ingredient.ingredient,
        ),
      ));
    }
    return list;
  }
}

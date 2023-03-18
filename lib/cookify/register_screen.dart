import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_management/logic/bloc/auth_bloc.dart';
import 'package:restaurant_management/router/router_constants.dart';
import 'package:restaurant_management/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

class CookifyRegisterScreen extends StatefulWidget {
  @override
  _CookifyRegisterScreenState createState() => _CookifyRegisterScreenState();
}

class _CookifyRegisterScreenState extends State<CookifyRegisterScreen> {
// text controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
        body: ListView(
          padding: FxSpacing.fromLTRB(24, 100, 24, 0),
          children: [
            FxTwoToneIcon(
              FxTwoToneMdiIcons.menu_book,
              color: customTheme.cookifyPrimary,
              size: 64,
            ),
            FxSpacing.height(16),
            FxText.displaySmall(
              "Create an Account",
              color: customTheme.cookifyPrimary,
              fontWeight: 800,
              textAlign: TextAlign.center,
            ),
            FxSpacing.height(32),
            // FxTextField(
            //   floatingLabelBehavior: FloatingLabelBehavior.never,
            //   autoFocusedBorder: true,
            //   textFieldStyle: FxTextFieldStyle.outlined,
            //   textFieldType: FxTextFieldType.name,
            //   filled: true,
            //   fillColor: customTheme.cookifyPrimary.withAlpha(40),
            //   enabledBorderColor: customTheme.cookifyPrimary,
            //   focusedBorderColor: customTheme.cookifyPrimary,
            //   prefixIconColor: customTheme.cookifyPrimary,
            //   labelTextColor: customTheme.cookifyPrimary,
            //   cursorColor: customTheme.cookifyPrimary,
            // ),
            // FxSpacing.height(24),
            FxTextField(
              controller: emailController,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              autoFocusedBorder: true,
              textFieldStyle: FxTextFieldStyle.outlined,
              textFieldType: FxTextFieldType.email,
              filled: true,
              fillColor: customTheme.cookifyPrimary.withAlpha(40),
              enabledBorderColor: customTheme.cookifyPrimary,
              focusedBorderColor: customTheme.cookifyPrimary,
              prefixIconColor: customTheme.cookifyPrimary,
              labelTextColor: customTheme.cookifyPrimary,
              cursorColor: customTheme.cookifyPrimary,
            ),
            FxSpacing.height(24),
            FxTextField(
              controller: passwordController,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              autoFocusedBorder: true,
              textFieldStyle: FxTextFieldStyle.outlined,
              textFieldType: FxTextFieldType.password,
              filled: true,
              fillColor: customTheme.cookifyPrimary.withAlpha(40),
              enabledBorderColor: customTheme.cookifyPrimary,
              focusedBorderColor: customTheme.cookifyPrimary,
              prefixIconColor: customTheme.cookifyPrimary,
              labelTextColor: customTheme.cookifyPrimary,
              cursorColor: customTheme.cookifyPrimary,
            ),
            FxSpacing.height(16),
            Align(
              alignment: Alignment.centerRight,
              child: FxButton.text(
                  padding: FxSpacing.zero,
                  onPressed: () {
                    GoRouter.of(context)
                        .pushNamed(RouterConstants.forgotPasswordScreen);
                  },
                  splashColor: customTheme.cookifyPrimary.withAlpha(40),
                  child: FxText.bodySmall("Forgot Password?",
                      color: customTheme.cookifyPrimary)),
            ),
            FxSpacing.height(16),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  showSnackBar(state.error);
                }
                if (state is AuthAuthenticated) {
                  GoRouter.of(context)
                      .pushReplacementNamed(RouterConstants.homeScreen);
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return FxButton.block(
                      onPressed: null, child: CircularProgressIndicator());
                }
                return FxButton.block(
                    borderRadiusAll: 8,
                    onPressed: () {
                      if (emailController.text == "" ||
                          passwordController.text == "") {
                        showSnackBar("All fields are required");
                      } else {
                        context.read<AuthBloc>().add(RegisterRequested(
                            emailController.text, passwordController.text));
                      }
                    },
                    backgroundColor: customTheme.cookifyPrimary,
                    child: FxText.labelLarge(
                      "Create an Account",
                      color: customTheme.cookifyOnPrimary,
                    ));
              },
            ),
            FxSpacing.height(16),
            FxButton.text(
                onPressed: () {
                  GoRouter.of(context).pushNamed(RouterConstants.loginScreen);
                },
                splashColor: customTheme.cookifyPrimary.withAlpha(40),
                child: FxText.labelMedium("I have already an account",
                    decoration: TextDecoration.underline,
                    color: customTheme.cookifyPrimary)),
            FxSpacing.height(16),
          ],
        ),
      ),
    );
  }

  // show snackbar
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: customTheme.cookifyPrimary,
    ));
  }
}

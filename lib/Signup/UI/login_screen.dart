import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_management/Signup/logic/bloc/auth_bloc.dart';
import 'package:restaurant_management/router/router_constants.dart';
import 'package:restaurant_management/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

class CookifyLoginScreen extends StatefulWidget {
  @override
  _CookifyLoginScreenState createState() => _CookifyLoginScreenState();
}

class _CookifyLoginScreenState extends State<CookifyLoginScreen> {
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
            Center(
              child: FxText.headlineSmall("Log In",
                  color: customTheme.cookifyPrimary, fontWeight: 800),
            ),
            FxSpacing.height(32),
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
                  onPressed: () {
                    // Navigator.of(context, rootNavigator: true).push(
                    //   MaterialPageRoute(
                    //       builder: (context) => CookifyForgotPasswordScreen()),
                    // );
                    GoRouter.of(context)
                        .pushNamed(RouterConstants.forgotPasswordScreen);
                  },
                  padding: FxSpacing.zero,
                  splashColor: customTheme.cookifyPrimary.withAlpha(40),
                  child: FxText.labelMedium("Forgot Password?",
                      color: customTheme.cookifyPrimary)),
            ),
            FxSpacing.height(16),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  GoRouter.of(context)
                      .pushReplacementNamed(RouterConstants.homeScreen);
                }
                if (state is AuthError) {
                  showSnackBar(state.error);
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return FxButton.block(
                    onPressed: null,
                    child: CircularProgressIndicator(),
                    backgroundColor: customTheme.cookifyPrimary,
                  );
                }

                return FxButton.block(
                    borderRadiusAll: 8,
                    onPressed: () {
                      if (emailController.text == "" ||
                          passwordController.text == "") {
                        showSnackBar("All fields required");
                      } else {
                        context.read<AuthBloc>().add(LoginRequested(
                            emailController.text, passwordController.text));
                      }
                    },
                    backgroundColor: customTheme.cookifyPrimary,
                    child: FxText.labelLarge(
                      "Log In",
                      color: customTheme.cookifyOnPrimary,
                    ));
              },
            ),
            FxSpacing.height(10),
            FxButton.block(
                borderRadiusAll: 8,
                onPressed: () {
                  context.read<AuthBloc>().add(GoogleSignInRequested());
                },
                backgroundColor: customTheme.carolinaBlue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(FxBoxIcons.bxl_google),
                    FxSpacing.width(10),
                    FxText.labelLarge(
                      "Google Sign In",
                      color: customTheme.cookifyOnPrimary,
                    ),
                  ],
                )),
            FxSpacing.height(16),
            FxButton.text(
                onPressed: () {
                  // Navigator.of(context, rootNavigator: true).push(
                  //   MaterialPageRoute(
                  //       builder: (context) => CookifyRegisterScreen()),
                  // );
                  GoRouter.of(context)
                      .pushNamed(RouterConstants.registerScreen);
                },
                splashColor: customTheme.cookifyPrimary.withAlpha(40),
                child: FxText.labelMedium("I haven\'t an account",
                    decoration: TextDecoration.underline,
                    color: customTheme.cookifyPrimary))
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

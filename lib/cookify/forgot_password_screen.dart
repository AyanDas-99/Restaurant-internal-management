import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_management/logic/bloc/auth_bloc.dart';
import 'package:restaurant_management/router/router_constants.dart';
import 'package:restaurant_management/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import 'full_app.dart';
import 'register_screen.dart';

class CookifyForgotPasswordScreen extends StatefulWidget {
  @override
  _CookifyForgotPasswordScreenState createState() =>
      _CookifyForgotPasswordScreenState();
}

class _CookifyForgotPasswordScreenState
    extends State<CookifyForgotPasswordScreen> {
  late ThemeData theme;
  late CustomTheme customTheme;

  // Email text controller
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: customTheme.cookifyPrimary.withAlpha(40))),
      child: Scaffold(
        body: ListView(
          padding: FxSpacing.fromLTRB(24, 200, 24, 0),
          children: [
            FxTwoToneIcon(
              FxTwoToneMdiIcons.menu_book,
              color: customTheme.cookifyPrimary,
              size: 64,
            ),
            FxSpacing.height(16),
            FxText.headlineSmall(
              "Forgot Password",
              color: customTheme.cookifyPrimary,
              fontWeight: 800,
              textAlign: TextAlign.center,
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
            FxSpacing.height(32),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  showSnackBar(state.error);
                }
                if (state is PassResetEmailSent) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Password reset email sent !"),
                    backgroundColor: CustomTheme.green,
                  ));
                  Future.delayed(Duration(seconds: 5), () {
                    context.goNamed(RouterConstants.loginScreen);
                  });
                }
              },
              child: FxButton.block(
                  borderRadiusAll: 8,
                  onPressed: () {
                    if (emailController.text == "") {
                      showSnackBar("Email is required");
                    } else {
                      context
                          .read<AuthBloc>()
                          .add(PasswordResetRequested(emailController.text));
                    }
                  },
                  backgroundColor: customTheme.cookifyPrimary,
                  child: FxText.labelLarge(
                    "Forgot Password",
                    color: customTheme.cookifyOnPrimary,
                  )),
            ),
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
                child: FxText.bodySmall("I haven\'t an account",
                    decoration: TextDecoration.underline,
                    color: customTheme.cookifyPrimary))
          ],
        ),
      ),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: customTheme.cookifyPrimary,
    ));
  }
}

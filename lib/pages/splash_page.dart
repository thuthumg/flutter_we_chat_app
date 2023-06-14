import 'package:flutter/material.dart';
import 'package:we_chat_app/pages/login_page.dart';
import 'package:we_chat_app/pages/otp_verify_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/utils/extensions.dart';

import '../widgets/custom_button_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [LogoSectionView(), TitleTextAndButtonSectionView()],
      ),
    );
  }
}

class TitleTextAndButtonSectionView extends StatelessWidget {
  const TitleTextAndButtonSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: const [
          TitleView(),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          SubTitleView(),
          SizedBox(
            height: MARGIN_XXLARGE,
          ),
          SignUpAndLoginView()
        ],
      ),
    );
  }
}

class SignUpAndLoginView extends StatelessWidget {
  const SignUpAndLoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(
          flex: 1,
          child: SignUpView(),
        ),
        Expanded(
          flex: 1,
          child: LoginView(),
        )
      ],
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      buttonText: LOGIN_TXT,
      buttonTextColor: Colors.white,
      buttonBackground: SECONDARY_COLOR,
      buttonBorderColor: SECONDARY_COLOR,
      buttonHeight: CUSTOM_BUTTON_HEIGHT,
      buttonWidth: 0.0,
      onTapButton: () {
        navigateToScreen(context, LoginPage());
      },
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      buttonText: SIGN_UP_TXT,
      buttonTextColor: SECONDARY_COLOR,
      buttonBackground: Colors.white,
      buttonBorderColor: SECONDARY_COLOR,
      buttonHeight: CUSTOM_BUTTON_HEIGHT,
      buttonWidth: 0.0,
      onTapButton: () {
        navigateToScreen(context, OTPVerifyPage());
      },
    );
  }
}

class SubTitleView extends StatelessWidget {
  const SubTitleView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      SPLASH_SCREEN_SUBTITLE_TXT,
      style: TextStyle(
          color: SECONDARY_COLOR,
          fontSize: TEXT_REGULAR,
          fontWeight: FontWeight.w400),
    );
  }
}

class TitleView extends StatelessWidget {
  const TitleView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      SPLASH_SCREEN_TITLE_TXT,
      style: TextStyle(
          color: SECONDARY_COLOR,
          fontSize: TEXT_REGULAR_2X,
          fontWeight: FontWeight.w600),
    );
  }
}

class LogoSectionView extends StatelessWidget {
  const LogoSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Image.asset('assets/splash/logo.png'),
    );
  }
}

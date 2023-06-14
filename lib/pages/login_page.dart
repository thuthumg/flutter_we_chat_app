import 'package:flutter/material.dart';
import 'package:we_chat_app/pages/home_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/utils/extensions.dart';
import 'package:we_chat_app/widgets/custom_button_widget.dart';
import 'package:we_chat_app/widgets/edit_text_widget.dart';

class LoginPage extends StatelessWidget{
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){Navigator.pop(context);},
            child: Image.asset('assets/left_button.png')),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: MARGIN_XXLARGE,right: MARGIN_LARGE),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Title
              const Text(
                WELCOME_TXT,
                style: TextStyle(
                  fontSize: HI_TXT_FONT_SIZE,
                  color: SECONDARY_COLOR,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: MARGIN_MEDIUM,
              ),
              ///SubTitle
              const Text(
                LOGIN_TO_CONTINUE_TXT,
                style: TextStyle(
                  fontSize: TEXT_REGULAR_1X,
                  color: CREATE_NEW_ACCOUNT_TXT_COLOR,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: MARGIN_MEDIUM,
              ),

              ///Image
              Center(
                child: Image.asset('assets/login/login_bg_img.png',
                    fit: BoxFit.cover),),

              ///Phone Number edit text section
              const PhNumTextFieldSectionView(),
              const SizedBox(
                height: MARGIN_XLARGE,
              ),

              ///Password edit text section
              const PasswordTextFieldSectionView(),
              const SizedBox(
                height: MARGIN_XLARGE,
              ),

              ///Forgot password link section
              const Align(
                alignment:  Alignment.centerRight,
                child: Text(
                  FORGET_PW_TXT,
                  style: TextStyle(
                    fontSize: TEXT_REGULAR_1X,
                    color: SECONDARY_COLOR,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: MARGIN_XXLARGE,
              ),

              ///Login Section
              const LoginSectionView()
            ],
          ),
        ),
      ),
    );
  }

}

class LoginSectionView extends StatelessWidget {
  const LoginSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButtonWidget(
        buttonText: LOGIN_TXT,
        buttonTextColor: Colors.white,
        buttonBackground: SECONDARY_COLOR,
        buttonBorderColor: SECONDARY_COLOR,
        buttonHeight: 50,
        buttonWidth: 150,
        onTapButton: () {
          navigateToScreen(context, HomePage());
        },
      ),
    );
  }
}

class PhNumTextFieldSectionView extends StatelessWidget {
  const PhNumTextFieldSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CUSTOM_BUTTON_HEIGHT,
      child: EditTextWidget(
        editTextName: "",
        editTextType: "number",
        hintTextName: ENTER_YOUR_PHONE_NUM_TXT,
      ),
    );
  }
}

class PasswordTextFieldSectionView extends StatelessWidget {
  const PasswordTextFieldSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CUSTOM_BUTTON_HEIGHT,
      child: EditTextWidget(
        editTextName: "",
        editTextType: "text",
        hintTextName: ENTER_YOUR_PW_TXT,
      ),
    );
  }
}
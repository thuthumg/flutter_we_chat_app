import 'package:flutter/material.dart';
import 'package:we_chat_app/pages/login_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/utils/extensions.dart';
import 'package:we_chat_app/widgets/agree_to_terms_and_service_widget.dart';
import 'package:we_chat_app/widgets/custom_button_widget.dart';
import 'package:we_chat_app/widgets/date_of_birth_drop_down_widget.dart';
import 'package:we_chat_app/widgets/edit_text_widget.dart';
import 'package:we_chat_app/widgets/gender_radio_button_widget.dart';

class SignUpPage extends StatelessWidget{
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: PRIMARY_COLOR,
          child: Stack(
            children: [

              ///Back button section
              Positioned(
                // left: 0.0,
                left: 0.0,
                top: 0.0,
                //   bottom: 0.0,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: MARGIN_XXLARGE,left: MARGIN_LARGE),
                    child: Image.asset('assets/left_button.png'),
                  ),
                ),),

              ///background image view section
              Positioned(
                // left: 0.0,
                right: 0.0,
                top: 0.0,
                //   bottom: 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: MARGIN_XLARGE),
                  child: Image.asset('assets/register/first_half_circle.png',
                    scale: 3,),
                ),),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: MARGIN_MEDIUM_3),
                  child: Image.asset('assets/register/second_half_circle.png',
                    scale: 3,),
                ),),
              Positioned(
                right: 0.0,
                bottom: 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: MARGIN_MEDIUM_3,right: MARGIN_MEDIUM_3),
                  child: Image.asset('assets/register/wave_icon.png',
                    scale: 1,),
                ),),
              Positioned(
                left: 0.0,
                bottom: 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: MARGIN_MEDIUM_3,left: MARGIN_MEDIUM_3),
                  child: Image.asset('assets/register/triangle_icon.png',
                    scale: 4,),
                ),),

              ///Form view section
              Positioned(
                  left: 0.0,
                  right: 0.0,
                  top: 100.0,
                  bottom: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: MARGIN_XXLARGE,right: MARGIN_LARGE),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Title
                          const Text(
                            HI_TXT,
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
                            CREATE_NEW_ACCOUNT_TXT,
                            style: TextStyle(
                              fontSize: TEXT_REGULAR_1X,
                              color: CREATE_NEW_ACCOUNT_TXT_COLOR,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: MARGIN_XLARGE,
                          ),

                          ///Name Edit Text section
                          EditTextWidget(
                            editTextName: "",
                            editTextType: "text",
                            hintTextName: NAME_TXT,
                          ),
                          const SizedBox(
                            height: MARGIN_LARGE,
                          ),

                          ///Date of Birth section
                          const Text(
                            DATE_OF_BIRTH_TXT,
                            style: TextStyle(
                              fontSize: TEXT_REGULAR_1X,
                              color: TEXT_FIELD_HINT_TXT_COLOR,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          DateOfBirthDropDownWidget(),
                          const SizedBox(
                            height: MARGIN_LARGE,
                          ),

                          ///Gender section
                          const Text(
                            GENDER_TXT,
                            style: TextStyle(
                              fontSize: TEXT_REGULAR_1X,
                              color: TEXT_FIELD_HINT_TXT_COLOR,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          GenderRadioButtonWidget(),

                          ///password edit text section
                          EditTextWidget(
                            editTextName: "",
                            editTextType: "password",
                            hintTextName: PASSWORD_TXT,
                          ),

                          ///terms and service selected section
                          const AgreeToTermsAndServiceWidget(),
                          const SizedBox(
                            height: MARGIN_XLARGE,
                          ),

                          ///Sign Up button click section
                          const SignUpSectionView()


                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      );

  }

}

class SignUpSectionView extends StatelessWidget {
  const SignUpSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButtonWidget(
        buttonText: SIGN_UP_TXT,
        buttonTextColor: Colors.white,
        buttonBackground: SECONDARY_COLOR,
        buttonBorderColor: SECONDARY_COLOR,
        buttonHeight: 50,
        buttonWidth: 150,
        onTapButton: () {
           navigateToScreen(context, LoginPage());
        },
      ),
    );
  }
}

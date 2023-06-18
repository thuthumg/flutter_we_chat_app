import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/otp_verify_page_bloc.dart';
import 'package:we_chat_app/pages/sign_up_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/utils/extensions.dart';
import 'package:we_chat_app/widgets/custom_button_widget.dart';
import 'package:we_chat_app/widgets/edit_text_widget.dart';
import 'package:we_chat_app/widgets/loading_view.dart';
import 'package:we_chat_app/widgets/otp_widget.dart';

class OTPVerifyPage extends StatelessWidget {
  const OTPVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> OtpVerifyPageBloc(),
      child: Scaffold(
        backgroundColor: PRIMARY_COLOR,
        appBar: AppBar(
          backgroundColor: PRIMARY_COLOR,
          elevation: 0,
          leading: GestureDetector(
              onTap: (){Navigator.pop(context);},
              child: Image.asset('assets/left_button.png')),
        ),
        body: Selector<OtpVerifyPageBloc,bool>(
          selector: (context,bloc)=>bloc.isLoading,
          builder:(context,isLoading,child){
            debugPrint("check isLoading $isLoading");
            return
              Padding(
            padding: const EdgeInsets.only(left: MARGIN_XXLARGE,right: MARGIN_LARGE),
            child: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
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
                        height: MARGIN_MEDIUM,
                      ),
                      ///Image
                      Center(
                          child: Image.asset('assets/register/otp_img.png',
                              fit: BoxFit.cover),),
                      ///Email  Text section
                      Consumer<OtpVerifyPageBloc>(
                        builder: (context,bloc,child)=> EditTextWidget(
                          isSecure: false,
                          editTextName: "",
                          editTextType: "emailText",
                          hintTextName: EMAIL_TXT,
                          isGroupNameText: false,
                          onChanged: (email){
                            bloc.onEmailChanged(email);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_XLARGE,
                      ),
                      ///Phone Number And OTP Section
                      const PhNumTextFieldAndOTPBtnSectionView(),
                      const SizedBox(
                        height: MARGIN_XLARGE,
                      ),

                      ///Enter OTP section
                      Consumer<OtpVerifyPageBloc>(
                        builder:(context,bloc,child)=> OTPSectionView(
                          pinCodeText: (pinText){
                            bloc.onPinCodeText(pinText);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      ///ResendCode Section
                      const ResendCodeSectionView(),
                      const SizedBox(
                        height: MARGIN_XLARGE,
                      ),
                      ///Verify Section
                      Consumer<OtpVerifyPageBloc>(
                        builder:(context,bloc,child)=> VerifySectionView(
                          onTapButton: (){
                            bloc.onTapVerify()
                            .then((_) => navigateToScreen(context, SignUpPage(
                              phoneNum: bloc.phoneNumber,
                              email: bloc.email
                            ),false))
                                .catchError((error)=>showSnackBarWithMessage(context, error.toString()));

                          },
                        ),
                      )
                    ],
                  ),
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Visibility(
                        visible: isLoading,
                        child: Container(
                          // color: Colors.transparent,
                          child: Center(
                            child: LoadingView(),
                          ),
                        ),)
                  )
                ],
              ),
            ),
          );

          },
        ),
      ),
    );
  }
}

class VerifySectionView extends StatelessWidget {
  final Function onTapButton;
  const VerifySectionView({
    super.key,
    required this.onTapButton
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButtonWidget(
        buttonText: VERIFY_TXT,
        buttonTextColor: Colors.white,
        buttonBackground: SECONDARY_COLOR,
        buttonBorderColor: SECONDARY_COLOR,
        buttonHeight: VERITY_BUTTON_HEIGHT,
        buttonWidth: VERITY_BUTTON_WIDTH,
        onTapButton: () {
          onTapButton();
        },
      ),
    );
  }
}

class ResendCodeSectionView extends StatelessWidget {
  const ResendCodeSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            DONT_RECEIVE_OTP_TXT,
            style: TextStyle(
              fontSize: TEXT_REGULAR,
              color: DONT_RECEIVE_OTP_TXT_COLOR,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            RESEND_CODE_TXT,
            style: TextStyle(
              fontSize: TEXT_REGULAR,
              color: SECONDARY_COLOR,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}

class OTPSectionView extends StatelessWidget {

  final Function(String) pinCodeText;

  const OTPSectionView({
    super.key,
    required this.pinCodeText
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OTPWidget(
        pinCodeText: (String pinText) {
          debugPrint("check text = $pinText");
          pinCodeText(pinText);
        },
      ),
    );
  }
}

class PhNumTextFieldAndOTPBtnSectionView extends StatelessWidget {
  const PhNumTextFieldAndOTPBtnSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CUSTOM_BUTTON_HEIGHT,
      child: Row(
        children: [
          Expanded(flex: 2, child: Consumer<OtpVerifyPageBloc>(
            builder:(context,bloc,child)=> EditTextWidget(
              isSecure: false,
              editTextName: "",
              editTextType: "number",
              hintTextName: ENTER_YOUR_PH_NUMBER_TXT,
              isGroupNameText: false,
              onChanged: (phoneNum){
                bloc.onUserPhoneNumberChanged(phoneNum);
              },
            ),
          ),),

          Expanded(
            flex: 1,
            child: CustomButtonWidget(
              buttonText: GET_OTP_TXT,
              buttonTextColor: Colors.white,
              buttonBackground: SECONDARY_COLOR,
              buttonBorderColor: SECONDARY_COLOR,
              buttonHeight: GET_OTP_BUTTON_HEIDHT,
              buttonWidth: GET_OTP_BUTTON_WIDTH,
              onTapButton: () {
                // navigateToScreen(context, LoginPage());
              },
            ),
          )
        ],
      ),
    );
  }
}

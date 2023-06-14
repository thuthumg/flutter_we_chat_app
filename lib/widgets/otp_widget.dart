import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class OTPWidget extends StatelessWidget {

  Function(String) pinCodeText;

  OTPWidget({
    Key? key,
    required this.pinCodeText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextSection(pinCodeText: (String pinText){
      pinCodeText(pinText);
    });
  }
}

class PinCodeTextSection extends StatelessWidget {

  Function(String) pinCodeText;

  PinCodeTextSection({
    Key? key,
    required this.pinCodeText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(

      width: 43,
      height: 43,

      textStyle: const TextStyle(
          fontSize: PIN_PUT_TEXT_SIZE,
          color: PIN_THEME_TEXT_COLOR,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
       // border: Border.all(color: SECONDARY_COLOR),
        borderRadius: BorderRadius.circular(PIN_THEME_BORDER_RADIUS),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Adjust the shadow position
          ),
        ],
       // colorBuilder: PinListenColorBuilder(Color(0xFFCCCCCC), Colors.red),

      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
     // border: Border.all(color: SECONDARY_COLOR),
      borderRadius: BorderRadius.circular(PIN_THEME_BORDER_RADIUS),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // Adjust the shadow position
        ),
      ],
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: SUMBITED_PIN_THEME_COLOR,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Adjust the shadow position
          ),
        ],
      ),
    );
    return Pinput(

      length: 4,
      separator: const SizedBox(width: MARGIN_MEDIUM_3,),
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      // validator: (s) {
      //   return s == '222222' ? null : 'Pin is incorrect';
      // },
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: (pin){
        print(pin);
        pinCodeText(pin);
      } ,
    );
  }
}
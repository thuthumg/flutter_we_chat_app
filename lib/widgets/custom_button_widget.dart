import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/dimens.dart';

class CustomButtonWidget extends StatelessWidget {

  final String buttonText;
  final Color buttonBackground;
  final Color buttonBorderColor;
  final Color buttonTextColor;
  final double buttonHeight;
  final double buttonWidth;
  Function onTapButton;

   CustomButtonWidget({
    super.key,
    required this.buttonText,
    required this.buttonBackground,
    required this.buttonBorderColor,
    required this.buttonTextColor,
    required this.buttonHeight,
    required this.buttonWidth,
    required this.onTapButton

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
       onTapButton();
      },
      child: Container(
        // width: 50,
        width: (buttonWidth == 0.0) ? null : buttonWidth,
        height: buttonHeight,
        margin: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
        decoration: BoxDecoration(
          color: buttonBackground,
          border: Border.all(
            width: CUSTOM_BUTTON_BORDER_WIDTH,
            color: buttonBorderColor,
          ),
          borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: TEXT_REGULAR_1X,
              color: buttonTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
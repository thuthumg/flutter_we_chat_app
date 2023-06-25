import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/widgets/custom_button_widget.dart';

class ErrorAlertBoxView extends StatelessWidget {
  String messageStr;

  ErrorAlertBoxView({required this.messageStr});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: SECONDARY_COLOR),
        borderRadius: BorderRadius.all(
          Radius.circular(MARGIN_SMALL),
        ),
      ),
      backgroundColor: PRIMARY_COLOR,
      content: Text(messageStr,style: const TextStyle(
        fontSize: TEXT_REGULAR_3X,
        color: Colors.red,
        fontWeight: FontWeight.w600,
      ),),
      actions: [
        CustomButtonWidget(
          buttonText: 'OK',
          buttonTextColor: Colors.white,
          buttonBackground: SECONDARY_COLOR,
          buttonBorderColor: SECONDARY_COLOR,
          buttonHeight: 50.0,
          buttonWidth: 100,
          onTapButton: () {
            //to save data at firebase
            Navigator.pop(context);

          },
        )
      ],
    );
  }
}
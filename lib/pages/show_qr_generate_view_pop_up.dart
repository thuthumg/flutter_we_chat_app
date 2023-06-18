import 'package:flutter/material.dart';
import 'package:we_chat_app/pages/qr_generate_view.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class ShowQRGenerateViewPopUp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: SECONDARY_COLOR),
        borderRadius: BorderRadius.all(
          Radius.circular(MARGIN_SMALL),
        ),

      ),
      backgroundColor: PRIMARY_COLOR,
      content:  Container(
          width: 200,
          height: 200,
          child: Center(child: QRSectionView(qrStr: "www.google.com",qrSize:200.0,isPopupQR: true,))),
      actions: [
        ///Sign Up button click section
      ],
    );
  }

}
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:we_chat_app/resources/dimens.dart';

class QRSectionView extends StatelessWidget {

  String qrStr;
  double qrSize;
  bool isPopupQR;

  QRSectionView({
    Key? key,
    required this.qrStr,
    required this.qrSize,
    required this.isPopupQR
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return QrImage(
      padding: EdgeInsets.all(2),
      data: qrStr,
      version: QrVersions.auto,
      size: qrSize,
      foregroundColor: Colors.black,
       backgroundColor: (isPopupQR)? Colors.transparent:Colors.white,
    );
  }
}
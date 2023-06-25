import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/dimens.dart';

class EachImageOrVideoViewItem extends StatelessWidget{

  final String? imageOrVideoLink;

  EachImageOrVideoViewItem({
    required this.imageOrVideoLink
});


  @override
  Widget build(BuildContext context) {
   return

     Container(
      width: MOMENT_DESC_IMAGE_WIDTH,
      height: MOMENT_DESC_IMAGE_HEIGHT,
      margin: const EdgeInsets.all( MARGIN_MEDIUM),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
      ),
      child:
      (imageOrVideoLink == null || imageOrVideoLink == "")?
      Container():
      ClipRRect(
        borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
        child:
        Image.network(
          imageOrVideoLink??"",
          fit: BoxFit.cover,
        ),
        // Image.asset(
        //   'assets/moments/background_sample.jpg',
        //   fit: BoxFit.cover,
        // ),
      ),
    );
  }

}
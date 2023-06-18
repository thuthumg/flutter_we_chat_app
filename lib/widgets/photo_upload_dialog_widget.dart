import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/widgets/custom_button_widget.dart';

class PhotoUploadDialogWidget extends StatelessWidget {

  final Function onTapGallery;
  final Function onTapCamera;

  PhotoUploadDialogWidget({
    required this.onTapGallery,
    required this.onTapCamera
});

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
      contentPadding: EdgeInsets.symmetric(vertical: MARGIN_CARD_MEDIUM_2),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children:  [
         const ChooseTitleView(),
          const SizedBox(
            height: MARGIN_MEDIUM,
          ),
          const Divider(
            height: 1,
            color: Colors.black87,
          ),
          const SizedBox(height: MARGIN_XLARGE),
          CameraAndGalleryActionButtonView(

            onTapGallery: (){
             onTapGallery();
            },
            onTapCamera: (){
             onTapCamera();
            },


          ),
        ],
      ),
      actions: const [
        Divider(
          height: 1,
          color: Colors.black87,
        ),
        SizedBox(
          height: MARGIN_MEDIUM,
        ),
        CancelButton(),
      ],
    );
  }
}


class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      buttonText: "Cancel",
      buttonTextColor: SECONDARY_COLOR,
      buttonBackground: Colors.white,
      buttonBorderColor: SECONDARY_COLOR,
      buttonHeight: 40,
      buttonWidth: 100,
      onTapButton: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class CameraAndGalleryActionButtonView extends StatelessWidget {

  final Function onTapGallery;
  final Function onTapCamera;

  const CameraAndGalleryActionButtonView({
    super.key,
    required this.onTapGallery,
    required this.onTapCamera
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_XLARGE),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: [
          CameraActionView(
            onTapCamera: (){
            onTapCamera();
          },),
          GalleryActionView(
            onTapGallery: (){
              onTapGallery();
            }
          )
        ],
      ),
    );
  }
}

class GalleryActionView extends StatelessWidget {

  final Function onTapGallery;
  const GalleryActionView({
    super.key,
    required this.onTapGallery
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTapGallery();
      },
      child: Column(
        children: [
          Image.asset(
            'assets/register/gallery_pic.png',
            scale: 2,
          ),
         const Text(
            "Gallery",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: SECONDARY_COLOR,
                fontSize: TEXT_REGULAR_3X,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class CameraActionView extends StatelessWidget {

  final Function onTapCamera;
  const CameraActionView({
    super.key,
    required this.onTapCamera
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTapCamera();
      },
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/register/camera_pic.png',
            scale: 2,
          ),
          Text(
            "Camera",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: SECONDARY_COLOR,
                fontSize: TEXT_REGULAR_3X,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class ChooseTitleView extends StatelessWidget {
  const ChooseTitleView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: MARGIN_CARD_MEDIUM_2),
      child: Text(
        "Choose",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: SECONDARY_COLOR,
            fontSize: TEXT_HEADING_1X,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

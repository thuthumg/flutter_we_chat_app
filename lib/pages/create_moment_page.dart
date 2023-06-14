import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
/*import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';*/
//import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/widgets/custom_button_widget.dart';

class CreateMomentPage extends StatefulWidget {
  @override
  State<CreateMomentPage> createState() => _CreateMomentPageState();
}

class _CreateMomentPageState extends State<CreateMomentPage> {



  List<dynamic> _selectedImages = ['assets/moments/add_choose_img_or_video_pic.png']; // List to store selected images

  Future<void> _pickMultipleImages() async {
    List<XFile>? images = await ImagePicker().pickMultiImage(); // Use pickMultiImage function

    if (images != null) {
      setState(() {
        images.forEach((element) {
          _selectedImages.add(File(element.path));
        });

      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: PRIMARY_COLOR,
        title: const Text(
          'New Moment',
          style: TextStyle(
            fontSize: TEXT_HEADING_1X,
            color: SECONDARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(
            top: MARGIN_CARD_MEDIUM_2,
            left: MARGIN_CARD_MEDIUM_2,
            bottom: MARGIN_CARD_MEDIUM_2,
          ),
          child: Image.asset(
            'assets/moments/dismiss_btn.png',
            scale: 3,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                top: MARGIN_CARD_MEDIUM_2, bottom: MARGIN_CARD_MEDIUM_2),
            child: CustomButtonWidget(
              buttonText: 'Create',
              buttonTextColor: Colors.white,
              buttonBackground: SECONDARY_COLOR,
              buttonBorderColor: SECONDARY_COLOR,
              buttonHeight: 0.0,
              buttonWidth: 70,
              onTapButton: () {
                //to save data at firebase

              },
            ),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
                child: LoginProfileImgAndUserNameSectionView()),
          ),
          Expanded(flex: 1,
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ChooseImageOrVideoGridSectionView(
                    selectedImageList: _selectedImages,
                    onTapChooseImg: (position) async {
                      if(position == 0)
                        {
                          //call image picker
                          debugPrint("onTapChoose Image");
                          _pickMultipleImages();
                          //   final ImagePicker _picker = ImagePicker();
                          // final List<XFile> pickedFileList = await _picker.pickMultiImage(
                          //   maxWidth: 200,
                          //   maxHeight: 200,
                          //   imageQuality: 80,
                          // );


                        //  _pickImages();

                        }
                    },
                  )),)
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //
          //   ],
          // )
        ],
      ),
    );
  }
}

class LoginProfileImgAndUserNameSectionView extends StatelessWidget {
  const LoginProfileImgAndUserNameSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
              child: const CircleAvatar(
                backgroundImage:
                    AssetImage('assets/moments/profile_sample.jpg'),
                radius: 21,
              ),
            ),
            const SizedBox(
              width: MARGIN_MEDIUM,
            ),
            const Text(
              "Michael",
              style: TextStyle(
                fontSize: TEXT_REGULAR_3X,
                color: SECONDARY_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.only(right: MARGIN_CARD_MEDIUM_2),
            child: TextField(
              controller: TextEditingController(text: ''),
              onChanged: (text) {},
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'What\'s on your mind?',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ))
      ],
    );
  }
}

class ChooseImageOrVideoGridSectionView extends StatefulWidget {

  Function(int) onTapChooseImg;
  List<dynamic> selectedImageList;

  ChooseImageOrVideoGridSectionView(
  {
    required this.onTapChooseImg,
    required this.selectedImageList
}
      );

  @override
  _ChooseImageOrVideoGridSectionViewState createState() => _ChooseImageOrVideoGridSectionViewState();
}

class _ChooseImageOrVideoGridSectionViewState extends State<ChooseImageOrVideoGridSectionView> {

 // List<String> imgList = ['assets/moments/add_choose_img_or_video_pic.png'];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.selectedImageList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        childAspectRatio: 1, // Width to height ratio of grid cells
      ),
      itemBuilder: (BuildContext context, int index) {
        return
          GestureDetector(
            onTap: (){
              widget.onTapChooseImg(index);
            },
            child: Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.all(MARGIN_MEDIUM),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
                child: (index == 0) ? Image.asset(
                  'assets/moments/add_choose_img_or_video_pic.png',
                  fit: BoxFit.cover,
                ):Image.file(widget.selectedImageList[index])
                // Image.network(
                //   'assets/moments/add_choose_img_or_video_pic.png',
                //   fit: BoxFit.cover,
                // ) ,
              ),
            ),
          );
      },
    );
  }
}


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/widgets/custom_button_widget.dart';

class CreateMomentPage extends StatefulWidget {
  const CreateMomentPage({super.key});

  @override
  State<CreateMomentPage> createState() => _CreateMomentPageState();
}

class _CreateMomentPageState extends State<CreateMomentPage> {
  List<dynamic> _selectedImages = [
    'assets/moments/add_choose_img_or_video_pic.png'
  ]; // List to store selected images

  Future<void> _pickMultipleImages() async {
    List<XFile>? images =
        await ImagePicker().pickMultiImage(); // Use pickMultiImage function

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
      appBar: CreateMomentPageAppBarView(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Profile User Name and description section
          const Expanded(
            flex: 1,
            child: SingleChildScrollView(
                child: LoginProfileImgAndUserNameSectionView()),
          ),

          ///choose image or video section
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ChooseImageOrVideoGridSectionView(
                selectedImageList: _selectedImages,
                onTapChooseImg: (position) async {
                  if (position == 0) {
                    //call image picker
                    debugPrint("onTapChoose Image");
                    _pickMultipleImages();
                  }
                },
                onTapDeleteItem: (selectedItem){                  
                  setState(() {
                    _selectedImages.removeAt(selectedItem);
                  });

                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CreateMomentPageAppBarView extends StatelessWidget implements PreferredSizeWidget{


  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  const CreateMomentPageAppBarView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        child: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/moments/dismiss_btn.png',
            scale: 3,
          ),
        ),
      ),
      actions: [
        CreateMomentBtnView()
      ],
    );
  }

}

class CreateMomentBtnView extends StatelessWidget {
  const CreateMomentBtnView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
  Function(int) onTapDeleteItem;
  List<dynamic> selectedImageList;

  ChooseImageOrVideoGridSectionView(
      {super.key,
      required this.onTapChooseImg,
      required this.selectedImageList,
      required this.onTapDeleteItem});

  @override
  _ChooseImageOrVideoGridSectionViewState createState() =>
      _ChooseImageOrVideoGridSectionViewState();
}

class _ChooseImageOrVideoGridSectionViewState
    extends State<ChooseImageOrVideoGridSectionView> {
  // List<String> imgList = ['assets/moments/add_choose_img_or_video_pic.png'];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.selectedImageList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        childAspectRatio: 1, // Width to height ratio of grid cells
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            widget.onTapChooseImg(index);
          },
          child: Stack(
            children: [
              SelectedImageView(widget: widget, index: index),
              (index == 0) ?
              Container() :
              CloseBtnView(index: index,onTapDeleteItem: (selectedItem){
                widget.onTapDeleteItem(selectedItem);
              },)
            ],
          ),
        );
      },
    );
  }
}

class SelectedImageView extends StatelessWidget {
  final int index;

  const SelectedImageView(
      {super.key, required this.widget, required this.index});

  final ChooseImageOrVideoGridSectionView widget;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.all(MARGIN_MEDIUM),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
            child: (index == 0)
                ? Image.asset(
                    'assets/moments/add_choose_img_or_video_pic.png',
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    widget.selectedImageList[index],
                    fit: BoxFit.cover,
                  )
            // Image.network(
            //   'assets/moments/add_choose_img_or_video_pic.png',
            //   fit: BoxFit.cover,
            // ) ,
            ),
      ),
    );
  }
}

class CloseBtnView extends StatelessWidget {

  final int index;
  final Function(int) onTapDeleteItem;

  const CloseBtnView({
    super.key,
    required this.index,
    required this.onTapDeleteItem
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MARGIN_MEDIUM_3,
      right: MARGIN_MEDIUM_3,
      child: GestureDetector(
        onTap: (){
          onTapDeleteItem(index);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MARGIN_XLARGE),
            color: Colors.white,
          ),
          child: const Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

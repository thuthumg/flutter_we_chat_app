import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/create_moment_page_bloc.dart';
import 'package:we_chat_app/blocs/video_controller_bloc.dart';
import 'package:we_chat_app/pages/error_alert_box_view.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/widgets/custom_button_widget.dart';
import 'package:path/path.dart' as path;
import 'package:we_chat_app/widgets/loading_view.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class CreateMomentPage extends StatelessWidget {
  CreateMomentPage({super.key});

  FileType getFileTypeFromPath(String? path) {
    String? extension = path?.split('.').last.toLowerCase();
    if (extension == 'mp4' || extension == 'mov') {
      return FileType.video;
    } else if (extension == 'jpg' || extension == 'png') {
      return FileType.image;
    } else {
      return FileType.any;
    }
  }
  Future<void> _pickMultipleImages(CreateMomentPageBloc bloc) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {

      List<String?> filePaths = result.paths;
      List fileTypes = result.paths
          .map((path) => getFileTypeFromPath(path))
          .toList();

      bool hasVideo = fileTypes.contains(FileType.video);
      if (hasVideo) {
        debugPrint("hasvideo");
        filePaths = [result.paths.last];
        fileTypes = [getFileTypeFromPath(result.paths.last)];
        bloc.initVideo(filePaths.last!);
      }

      bloc.onImageChosen(filePaths);

    }


  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateMomentPageBloc(),
      child: Consumer<CreateMomentPageBloc>(
        builder: (context, bloc, child) => Scaffold(
          backgroundColor: PRIMARY_COLOR,
          appBar: CreateMomentPageAppBarView(createMomentPageBloc: bloc),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Profile User Name and description section
                  Expanded(
                   // flex: 1,
                    child: SingleChildScrollView(
                        child: LoginProfileImgAndUserNameSectionView(
                            createMomentPageBloc: bloc
                        )),
                  ),

                  Spacer(),
                  ///choose image or video section
                  Padding(
                    padding: const EdgeInsets.only(left: MARGIN_MEDIUM_3),
                    child: SizedBox(

                      height: 130,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: bloc.selectedImages.length,
                        itemBuilder: (BuildContext context, int index) {
                         // debugPrint("check file type ${checkFileType(bloc.selectedImages[index])}");
                          return Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(right: MARGIN_MEDIUM,bottom: MARGIN_MEDIUM_2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
                            ),
                            child:
                            (index == 0)?
                            GestureDetector(
                              onTap: (){
                                _pickMultipleImages(bloc);
                              },
                              child:
                              ClipRRect(
                                borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
                                child: Image.asset(
                                  bloc.selectedImages[index].toString(),
                                 // 'assets/moments/add_choose_img_or_video_pic.png',
                                 // fit: BoxFit.cover,
                                ),

                              ),
                            ):
                            (checkFileType(bloc.selectedImages[index].toString()) == 'Video') ?
                            GestureDetector(
                              onTap: (){
                                bloc.videoController!.value.isPlaying
                                    ? bloc.pause()
                                    : bloc.play();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
                                child: AspectRatio(
                                  aspectRatio: 2/3,
                                  child: bloc.videoController != null ?
                                  Stack(
                                    children: [
                                      VideoPlayer(
                                        bloc.videoController!,
                                      ),
                                      Center(
                                        child: Icon(
                                          bloc.videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      )
                                    ],
                                  ) : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            )
                                :
                            ClipRRect(
                              borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
                              child: Image.file(
                                bloc.selectedImages[index],
                                fit: BoxFit.cover,
                              ),

                            )
                            ,
                          );
                        },
                      ),
                    ),
                  )


                  // Expanded(
                  //   flex: 1,
                  //   child: Align(
                  //     alignment: Alignment.bottomLeft,
                  //     child: ChooseImageOrVideoGridSectionView(
                  //       createMomentPageBloc: bloc,
                  //       selectedImageList: _selectedImages,
                  //       onTapChooseImg: (position) async {
                  //         if (position == 0) {
                  //           //call image picker
                  //           debugPrint("onTapChoose Image");
                  //           _pickMultipleImages();
                  //         }
                  //       },
                  //       onTapDeleteItem: (selectedItem) {
                  //         // setState(() {
                  //         //   _selectedImages.removeAt(selectedItem);
                  //         // });????
                  //       },
                  //     ),
                  //   ),
                  // )
                ],
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Visibility(
                    visible: bloc.isLoading,
                    child: Container(
                      // color: Colors.transparent,
                      child: Center(
                        child: LoadingView(),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  String checkFileType(String path) {
    String extension = path.split('.').last.toLowerCase();
    debugPrint("check extension ${extension} ${path}");
    if (extension == 'mp4\'' || extension == 'mov\'') {
      debugPrint("check extension 2 ${path}");
      return 'Video';
    } else if (extension == 'jpg' || extension == 'png') {
      return 'Image';
    } else {
      return 'Unknown';
    }
  }

  //  checkFileType(String downloadUrl) async {
  //   String fileType;
  //   try {
  //     // Send a HEAD request to retrieve the file's metadata
  //     final response = await http.head(Uri.parse(downloadUrl));
  //
  //     // Check the 'content-type' header in the response
  //     final contentType = response.headers['content-type'];
  //
  //     // Determine the file type based on the content type
  //     if (contentType != null && contentType.startsWith('image/')) {
  //       fileType = 'Image';
  //     } else if (contentType != null && contentType.startsWith('video/')) {
  //       fileType = 'Video';
  //     } else {
  //       fileType = 'Unknown';
  //     }
  //
  //     debugPrint("check file type $fileType");
  //     return fileType;
  //
  //   } catch (error) {
  //     return 'Error: $error';
  //     //print('Error: $error');
  //   }
  // }
}

class CreateMomentPageAppBarView extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  CreateMomentPageBloc createMomentPageBloc;

  CreateMomentPageAppBarView({
    super.key,
    required this.createMomentPageBloc
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
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/moments/dismiss_btn.png',
            scale: 3,
          ),
        ),
      ),
      actions: [CreateMomentBtnView(createMomentPageBloc: createMomentPageBloc)],
    );
  }
}

class CreateMomentBtnView extends StatelessWidget {
  CreateMomentPageBloc createMomentPageBloc;
  CreateMomentBtnView({
    super.key,
    required this.createMomentPageBloc
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
          createMomentPageBloc.onTapAddNewMoment().then((value) => Navigator.pop(context))
              .catchError((error){

            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildPopupDialog(context));
          });
          // if(createMomentPageBloc.isAddNewMomentError)
          //   {
          //     showDialog(
          //         context: context,
          //         builder: (BuildContext context) =>
          //             _buildPopupDialog(context));
          //
          //   }else{
          //   createMomentPageBloc.onTapAddNewMoment().then((value) => Navigator.pop(context))
          //   .catchError((error){
          //     showDialog(
          //         context: context,
          //         builder: (BuildContext context) =>
          //             _buildPopupDialog(context));
          //   });
          // }




        },
      ),
    );
  }

  _buildPopupDialog(BuildContext context) {
    return ErrorAlertBoxView(messageStr: "Post should not be empty" );
  }
}

class LoginProfileImgAndUserNameSectionView extends StatelessWidget {

  CreateMomentPageBloc createMomentPageBloc;

  LoginProfileImgAndUserNameSectionView({
    super.key,
    required this.createMomentPageBloc
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MARGIN_MEDIUM_3),
      child: Column(
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
                child:
               (createMomentPageBloc.profilePicture != "" )?
                CircleAvatar(
                  backgroundImage:
                  NetworkImage(createMomentPageBloc.profilePicture) ,
                  radius: 21,
                ):
               Container(
                 color: Colors.white,
                 child: CircleAvatar(
                   backgroundColor: SUMBITED_PIN_THEME_COLOR,
                   radius: 21,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Image.asset('assets/splash/logo.png'),
                   ),
                 ),
               ),
               // const CircleAvatar(
               //    backgroundImage:
               //    AssetImage('assets/moments/profile_sample.jpg') ,
               //    radius: 21,
               //  ),
              ),
              const SizedBox(
                width: MARGIN_MEDIUM,
              ),
              Text(
                createMomentPageBloc.userName,
                style: const TextStyle(
                  fontSize: TEXT_REGULAR_3X,
                  color: SECONDARY_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(right: MARGIN_SMALL,top: MARGIN_CARD_MEDIUM_2),
              child: TextField(
                controller: TextEditingController(text: ''),
                onChanged: (text) {
                  createMomentPageBloc.onNewMomentTextChanged(text);
                },
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
      ),
    );
  }
}

class ChooseImageOrVideoGridSectionView extends StatelessWidget {
  Function(int) onTapChooseImg;
  Function(int) onTapDeleteItem;
  List<dynamic> selectedImageList;

  CreateMomentPageBloc createMomentPageBloc;

  ChooseImageOrVideoGridSectionView(
      {super.key,
      required this.onTapChooseImg,
      required this.selectedImageList,
      required this.onTapDeleteItem,
      required this.createMomentPageBloc});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: selectedImageList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        childAspectRatio: 1, // Width to height ratio of grid cells
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            onTapChooseImg(index);
          },
          child: Stack(
            children: [
             // SelectedImageView(selectedImageList, index: index),
              (index == 0)
                  ? Container()
                  : CloseBtnView(
                index: index,
                onTapDeleteItem: (selectedItem) {
                  onTapDeleteItem(selectedItem);
                },
              )
            ],
          ),
        );
      },
    );
  }
}

class SelectedImageView extends StatelessWidget {
  final int index;
  List<dynamic> selectedImageList;

  SelectedImageView(
      {super.key, required this.index,required this.selectedImageList});

  @override
  Widget build(BuildContext context) {
    String extension = path.extension(selectedImageList[index]);
    // bool isJpg = hasFileExtension(filePath, '.jpg');
    print(extension);

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
              :
              //         (extension == ".mp4")?
              // AspectRatio(
              // aspectRatio: controller.value.aspectRatio,
              // child: VideoPlayer(controller),
              // // Image.network(
              // //   'assets/moments/add_choose_img_or_video_pic.png',
              // //   fit: BoxFit.cover,
              // // ) ,
              // ):
              Image.file(
                  selectedImageList[index],
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}

class CloseBtnView extends StatelessWidget {
  final int index;
  final Function(int) onTapDeleteItem;

  const CloseBtnView(
      {super.key, required this.index, required this.onTapDeleteItem});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MARGIN_MEDIUM_3,
      right: MARGIN_MEDIUM_3,
      child: GestureDetector(
        onTap: () {
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

class PostDescriptionErrorSection extends StatelessWidget {
  const PostDescriptionErrorSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateMomentPageBloc>(
      builder: (context, bloc, child) => Visibility(
        visible: bloc.isAddNewMomentError,
        child: Container(
          child: Text(
            "Post should not be empty",
            style: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

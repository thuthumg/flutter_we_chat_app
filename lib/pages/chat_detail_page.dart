import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_sound/flutter_sound.dart';
//import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat_app/blocs/chat_detail_page_bloc.dart';
import 'package:we_chat_app/components/profile_img_with_active_status_view.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/pages/audio_record_page.dart';
import 'package:we_chat_app/pages/custom_voice_record_dialog.dart';
import 'package:we_chat_app/pages/error_alert_box_view.dart';
import 'package:we_chat_app/pages/photo_view_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/utils/extensions.dart';
import 'package:we_chat_app/viewitems/giphy_custom_view.dart';
import 'package:we_chat_app/viewitems/giphy_widget.dart';
import 'package:we_chat_app/viewitems/sent_msg_and_receive_msg_view_item.dart';
import 'package:we_chat_app/widgets/loading_view.dart';

class ChatDetailPage extends StatelessWidget {
  final String chatUserName;
  final String chatUserId;
  final String chatUserProfile;
  final bool isGroupChat;

  ChatDetailPage(
      {required this.chatUserName,
      required this.chatUserId,
      required this.chatUserProfile,
      required this.isGroupChat});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatDetailPageBloc(chatUserId,isGroupChat),
      child: Consumer<ChatDetailPageBloc>(
        builder: (context, bloc, child) => Scaffold(
          backgroundColor: CHAT_PAGE_BG_COLOR,
          appBar: CustomAppBarSectionView(
              chatUserName: chatUserName, chatUserProfile: chatUserProfile),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///show chat msg (chat History time + Sent Msg +Receive Msg ) Section View
                  ChatMsgSectionView(
                    bloc:bloc,
                      loginUserVO:bloc.userVO,
                      chatMessageList: bloc.chatMessageVOList
                  ),

                  ///Type And Send Msg Section View
                  /// Media(photo,video) data, git data, location data and voice data Action Section View
                  Column(

                    children: [
                      ///show selected image section
                      Visibility(
                        visible: (bloc.selectedImages.isNotEmpty) ? true : false,
                        child: SelectImageSectionView(chatDetailPageBloc: bloc,
                        onTapDeleteSelectedData: (selectedId){
                            bloc.onRemoveSelectedImage(selectedId);
                        },),
                      ),
                      Visibility(
                        visible: (bloc.selectedGifImages.isNotEmpty) ? true : false,
                        child: SelectGifImageSectionView(chatDetailPageBloc: bloc,
                          onTapDeleteSelectedData: (selectedId){
                            bloc.onRemoveSelectedGifImage(selectedId);
                          },),
                      ),
                      ///Type And Send Msg Section View
                      SendMsgSectionView(
                          chatDetailPageBloc: bloc,
                          onTapSendMessage: () {
                            bloc.onTapSendMessage(
                                bloc.userVO?.id,
                                chatUserId,
                                bloc.typeMessageText,
                                bloc.userVO?.userName,
                                bloc.selectedImages,
                                bloc.userVO?.profileUrl,
                                isGroupChat,
                              bloc.selectedGifImages,
                            bloc.voiceRecordedFile).then((value) {
                                  bloc.typeMessageText = "";
                                  bloc.selectedImages = [];
                                  bloc.selectedGifImages = [];
                                })
                                .catchError((error){

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog(context));
                            });

                        // return bloc.onTapSendMessage(
                        //     bloc.userVO?.id,
                        //     chatUserId,
                        //     bloc.typeMessageText,
                        //     bloc.userVO?.userName,
                        //     bloc.selectedImages,
                        //     bloc.userVO?.profileUrl,
                        //     isGroupChat);
                      }),

                      /// Media(photo,video) data, git data, location data and voice data Action Section View
                      ActionButtonSectionViewForSendMediaMsg(
                        onTapBottomNavItem: (bottomNavIndex){

                          if(bottomNavIndex == 0)
                          _pickMultipleImages(bloc);
                          else if(bottomNavIndex == 1)
                            _takePhotoFromCamera(bloc);
                          else if(bottomNavIndex == 2)
                            _gifImages(context,bloc);
                          else if(bottomNavIndex == 4)
                            _voiceRecord(context,bloc,chatUserId,isGroupChat);
                        },
                      ),
                    ],
                  ),
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
                    ),)
              )
            ],
          ),
        ),
      ),
    );
  }
  _buildPopupDialog(BuildContext context) {
    return ErrorAlertBoxView(messageStr: "Send Message should not be empty" );
  }

  Future<void> _gifImages(BuildContext context,ChatDetailPageBloc bloc) async {

    showGiphyPicker(context,bloc);

    // showModalBottomSheet<void>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return
    //
    //       CustomGiphyScreen();
    //       //GiphyWidget();
    //      // BottomSheetView();
    //   },
    //   isScrollControlled: true
    // );

  }
  Future<void> showGiphyPicker(BuildContext context,ChatDetailPageBloc bloc) async {
    final gif = await GiphyGet.getGif(context: context, apiKey: 'VV9RTZMYg9CMotPE7viDXSQTwOJos5Yg');

    if (gif != null) {
      // Use the selected gif
      print('Selected Gif: ${gif.images?.original?.url}');
      bloc.onTapGifImage(gif.images?.original?.url??"");
    }
  }
  Future<void> _takePhotoFromCamera(ChatDetailPageBloc bloc) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera);
    if (image != null) {
      bloc.onTakePhoto(File(image.path));
    }
  }

}

Future<void> _voiceRecord(BuildContext context, ChatDetailPageBloc bloc,
    String chatUserId, bool isGroupChat) async {

/*  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => VoiceRecorderApp()),
  );*/

   showModalBottomSheet<void>(
     context: context,
     builder: (BuildContext context) {
       return
         CustomVoiceRecordDialog(bloc:bloc,onTapSendMessage: (){
          // debugPrint("check audio file ${ bloc.voiceRecordedFile}");
           bloc.onTapSendMessage(
               bloc.userVO?.id,
               chatUserId,
               bloc.typeMessageText,
               bloc.userVO?.userName,
               bloc.selectedImages,
               bloc.userVO?.profileUrl,
               isGroupChat,
               bloc.selectedGifImages,
           bloc.voiceRecordedFile).then((value) {
             bloc.typeMessageText = "";
             bloc.selectedImages = [];
             bloc.selectedGifImages = [];
             Navigator.of(context).pop();

           })
               .catchError((error){

             showDialog(
                 context: context,
                 builder: (BuildContext context) =>
                  ErrorAlertBoxView(messageStr: "Send Message should not be empty" )
             );
               });




           },);

     },
     isScrollControlled: true
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

Future<void> _pickMultipleImages(ChatDetailPageBloc bloc) async {
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

class ActionButtonSectionViewForSendMediaMsg extends StatefulWidget {

  Function(int) onTapBottomNavItem;

  ActionButtonSectionViewForSendMediaMsg({
    super.key,
    required this.onTapBottomNavItem
  });

  @override
  State<ActionButtonSectionViewForSendMediaMsg> createState() =>
      _ActionButtonSectionViewForSendMediaMsgState();
}

class _ActionButtonSectionViewForSendMediaMsgState
    extends State<ActionButtonSectionViewForSendMediaMsg> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    widget.onTapBottomNavItem(index);
    setState(() {
      _selectedIndex = index;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes the position of the shadow
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: PRIMARY_COLOR,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        iconSize: 24.0,
        selectedItemColor: SECONDARY_COLOR,
        unselectedItemColor: TEXT_FIELD_HINT_TXT_COLOR,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/chat/gallery_white_icon.png",
                scale: 3,
              ),
              activeIcon: Image.asset(
                "assets/chat/gallery_white_icon.png",
                scale: 3,
              ),
              label: ''),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/chat/camera_white_icon.png',
              scale: 3,
            ),
            activeIcon: Image.asset(
              "assets/chat/camera_white_icon.png",
              scale: 3,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/chat/gif_white_icon.png',
              scale: 3,
            ),
            activeIcon: Image.asset(
              "assets/chat/gif_white_icon.png",
              scale: 3,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/chat/location_white_icon.png',
              scale: 3,
            ),
            activeIcon: Image.asset(
              "assets/chat/location_white_icon.png",
              scale: 3,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/chat/voice_record_icon.png',
              scale: 3,
            ),
            activeIcon: Image.asset(
              "assets/chat/voice_record_icon.png",
              scale: 3,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
class SelectGifImageSectionView extends StatelessWidget {
  final Function(int) onTapDeleteSelectedData;
  final ChatDetailPageBloc chatDetailPageBloc;
  const SelectGifImageSectionView({super.key,
    required this.onTapDeleteSelectedData,
    required this.chatDetailPageBloc});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chatDetailPageBloc.selectedGifImages.length,
        itemBuilder: (BuildContext context, int index) {

          print("chatdetail ${chatDetailPageBloc.selectedGifImages[index].toString()}");

          return Container(
              width: 100,
              height: 60,
              margin: const EdgeInsets.only(
                  left: MARGIN_MEDIUM,
                  right: MARGIN_MEDIUM,
                  bottom: MARGIN_MEDIUM_2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
                color: Color.fromRGBO(100, 100, 100, 0.2)
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom:0,
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
                      child:
                      CachedNetworkImage(
                        imageUrl:  chatDetailPageBloc.selectedGifImages[index],
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            Container(
                                margin: EdgeInsets.all(MARGIN_MEDIUM_3),
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(value: downloadProgress.progress)),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      // Image.network(
                      //   chatDetailPageBloc.selectedGifImages[index],
                      //   fit: BoxFit.cover,
                      // ),

                    ),),

                  Positioned(
                      top: 0,
                      left: 0,
                      child: GestureDetector(
                          onTap: (){
                            onTapDeleteSelectedData(index);
                          },
                          child: Icon(Icons.cancel,size: 25,color: Colors.black,)))


                ],
              )

          );
        },
      ),
    );
  }
}
class SelectImageSectionView extends StatelessWidget {
 final Function(int) onTapDeleteSelectedData;
  final ChatDetailPageBloc chatDetailPageBloc;
  const SelectImageSectionView({super.key,
    required this.onTapDeleteSelectedData,
    required this.chatDetailPageBloc});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chatDetailPageBloc.selectedImages.length,
        itemBuilder: (BuildContext context, int index) {

          print("chatdetail ${chatDetailPageBloc.selectedImages[index].toString()}");

          return Container(
              width: 100,
              height: 60,
              margin: const EdgeInsets.only(
                  left: MARGIN_MEDIUM,
                  right: MARGIN_MEDIUM,
                  bottom: MARGIN_MEDIUM_2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom:0,
                    child: (checkFileType(chatDetailPageBloc.selectedImages[index].toString()) == 'Video') ?
                    GestureDetector(
                      onTap: (){
                        chatDetailPageBloc.videoController!.value.isPlaying
                            ? chatDetailPageBloc.pause()
                            : chatDetailPageBloc.play();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
                        child: AspectRatio(
                          aspectRatio: 2/3,
                          child: chatDetailPageBloc.videoController != null ?
                          Stack(
                            children: [
                              VideoPlayer(
                                chatDetailPageBloc.videoController!,
                              ),
                              Center(
                                child: Icon(
                                  chatDetailPageBloc.videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
                        chatDetailPageBloc.selectedImages[index],
                        fit: BoxFit.cover,
                      ),

                    ),),

                  GestureDetector(
                    onTap: (){
                      onTapDeleteSelectedData(index);
                    },
                    child: const Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(Icons.cancel,size: 25,color: Colors.black,)),
                  )


                ],
              )

          );
        },
      ),
    );
  }
}

class SendMsgSectionView extends StatelessWidget {
  final Function onTapSendMessage;
  final ChatDetailPageBloc chatDetailPageBloc;
  const SendMsgSectionView({super.key,
    required this.onTapSendMessage,
  required this.chatDetailPageBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: ''),
              onChanged: (text) {
                chatDetailPageBloc.onTypeMessageTextChanged(text);
              },
              decoration: const InputDecoration(
                hintText: 'Type a message',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onTapSendMessage();
            },
            child: Image.asset(
              'assets/chat/send_btn_icon.png',
              scale: 3,
            ),
          )
        ],
      ),
    );
  }
}

class ChatMsgSectionView extends StatelessWidget {
  ChatDetailPageBloc bloc;
  List<ChatMessageVO> chatMessageList;
  UserVO? loginUserVO;

   ChatMsgSectionView({
    super.key,
     required this.chatMessageList,
     required this.loginUserVO,
     required this.bloc
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("check chat message list2 =  ${chatMessageList.length}");

    return Expanded(
      child: ListView.builder(
        reverse: true,
       // physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        // physics: NeverScrollableScrollPhysics(),
       // shrinkWrap: true,
        itemCount: chatMessageList.length,
        itemBuilder: (context, index) {
          ChatMessageVO message = chatMessageList[index];

          print("check chatMessageObject ${message.toJson()}");

          DateFormat dateFormat = DateFormat("hh:mm a", "en_US");
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(message.timestamp.toString()));
          String dateString = dateFormat.format(dateTime);

          return Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            //  mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///Chat History Section Time
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(MARGIN_MEDIUM),
                  child: Text(
                    dateString.toString(),
                    style: const TextStyle(
                      fontSize: TEXT_REGULAR,
                      color: TEXT_FIELD_HINT_TXT_COLOR,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
             const SizedBox(
                height: MARGIN_CARD_MEDIUM_2,
              ),
              SentMsgAndReceiveMsgViewItem(
                bloc: bloc,
                loginUserVO: loginUserVO,
                msgItem: message,
                  onTapSelectedPhoto: (url,mediaTypeVO){
                  debugPrint("chat detail page");
                    navigateToScreen(context,MediaDetailViewPage(
                        imageUrl : url,
                            mediaTypeVO : mediaTypeVO,
                      isExitFullScreen: false,
                    ),false);

                  },
              )
            ],
          );
        },
      ),
    );
  }
}

class CustomAppBarSectionView extends StatelessWidget
    implements PreferredSizeWidget {
  final String chatUserName;
  final String chatUserProfile;

  const CustomAppBarSectionView(
      {super.key, required this.chatUserName, required this.chatUserProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes the position of the shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///Back button , chat profile pic , user name and status section
            Padding(
              padding: EdgeInsets.only(top: MARGIN_CARD_MEDIUM_2),
              child: ChatDetailPageProfileAndStatusView(
                  chatUserName: chatUserName, chatUserProfile: chatUserProfile),
            ),

            /// chat contextual  menu section
            Image.asset(
              'assets/chat/chat_detail_appbar_contextual_menu.png',
              scale: 2.5,
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ChatDetailPageProfileAndStatusView extends StatelessWidget {
  final String chatUserName;
  final String chatUserProfile;

  const ChatDetailPageProfileAndStatusView(
      {super.key, required this.chatUserName, required this.chatUserProfile});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///Back Button View
        BackButtonView(),

        ///Chat Profile pic , user name and status
        ProfileImgWithActiveStatusView(chatUserProfile: chatUserProfile),
        const SizedBox(
          width: MARGIN_MEDIUM,
        ),
        ChatUserNameAndStatusView(chatUserName: chatUserName),
      ],
    );
  }
}

class BackButtonView extends StatelessWidget {
  const BackButtonView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Image.asset('assets/left_button.png'),
    );
  }
}

class ChatUserNameAndStatusView extends StatelessWidget {
  final String chatUserName;

  const ChatUserNameAndStatusView({super.key, required this.chatUserName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          chatUserName,
          style: const TextStyle(
            fontSize: TEXT_REGULAR_1X,
            color: Color.fromRGBO(17, 58, 93, 1),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: MARGIN_SMALL,
        ),
        const Text(
          'online',
          style: TextStyle(
            fontSize: TEXT_REGULAR,
            color: TEXT_FIELD_HINT_TXT_COLOR,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}


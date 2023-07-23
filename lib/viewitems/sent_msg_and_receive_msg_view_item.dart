import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

import 'package:we_chat_app/blocs/chat_detail_page_bloc.dart';
import 'package:we_chat_app/components/profile_img_with_active_status_view.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';
import 'package:we_chat_app/data/vos/media_type_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/pages/photo_view_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/viewitems/video_view_custom_widget.dart';


class SentMsgAndReceiveMsgViewItem extends StatelessWidget {
  final ChatDetailPageBloc bloc;
  final ChatMessageVO msgItem;
  final UserVO? loginUserVO;
  Function(String,MediaTypeVO) onTapSelectedPhoto;

  SentMsgAndReceiveMsgViewItem({
    super.key,
    required this.msgItem,
  required this.loginUserVO,
  required this.bloc,
  required this.onTapSelectedPhoto
  });

  @override
  Widget build(BuildContext context) {

    return (loginUserVO?.id == msgItem.userId)
        ? SentMsgSectionView(
        bloc:bloc,
        msgItem: msgItem,onTapSelectedPhoto: (url,mediaTypeVO){
          debugPrint("sendmsgandrecivemsg data ${url}");
         return onTapSelectedPhoto(url,mediaTypeVO);

    })
        : ReceiveMsgSectionView(bloc:bloc,msgItem: msgItem,onTapSelectedPhoto: (url,mediaTypeVO){
      debugPrint("sendmsgandrecivemsg data ${url}");
      return onTapSelectedPhoto(url,mediaTypeVO);

    });

  }
}

class ReceiveMsgSectionView extends StatelessWidget {

  final ChatDetailPageBloc bloc;
  Function(String,MediaTypeVO) onTapSelectedPhoto;

  ReceiveMsgSectionView({
    super.key,
    required this.msgItem,
    required this.bloc,
    required this.onTapSelectedPhoto
  });

  final ChatMessageVO msgItem;

  @override
  Widget build(BuildContext context) {

    return Container(

        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: MARGIN_MEDIUM_1,
                  bottom: MARGIN_MEDIUM_1,
                  right: MARGIN_MEDIUM_1),
              child: ProfileImgWithActiveStatusView(chatUserProfile: msgItem.profileUrl??"",),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                    visible: (msgItem.message == "")? false: true,
                    child: ReceiveTextMsgView(msgItem: msgItem)),

                const SizedBox(height: MARGIN_MEDIUM,),
                Visibility(
                    visible: (msgItem.mediaFile?.length == 0)? false: true,
                    child: ReceiveImgOrVideoMsgView(bloc:bloc,msgItem: msgItem,onTapSelectedPhoto:(url,mediaTypeVO){
                     return onTapSelectedPhoto(url,mediaTypeVO);
                    })),
              ],
            ),
          ],
        ),
      );
  }
}

class ReceiveImgOrVideoMsgView extends StatelessWidget {
  final ChatDetailPageBloc bloc;
  Function(String,MediaTypeVO) onTapSelectedPhoto;

  ReceiveImgOrVideoMsgView({
    super.key,
    required this.msgItem,
    required this.bloc,
    required this.onTapSelectedPhoto
  });
  final ChatMessageVO msgItem;

  @override
  Widget build(BuildContext context) {

   List<MediaTypeVO> sendFileList =  msgItem.mediaFile as List<MediaTypeVO>;
    DateFormat dateFormat = DateFormat("hh:mm a", "en_US");
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(msgItem.timestamp.toString()));
    String dateString = dateFormat.format(dateTime);

    return
      (sendFileList.length == 1)?
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: (){
              return onTapSelectedPhoto(sendFileList[0].fileUrl.toString() ,sendFileList[0]);
            },
            child: Container(
              width: 160,
              height: 100,
              margin: const EdgeInsets.only(top:MARGIN_MEDIUM),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
              ),
              child:
              (sendFileList[0].fileUrl != "")?
              (sendFileList[0].fileType.toString().contains("video"))?
              VideoMsgView(bloc: bloc,msgItem: msgItem,videoUrl:sendFileList[0].fileUrl??"")
                  :
              ClipRRect(
                borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
                child: Image.network(
                  sendFileList[0].fileUrl??"",
                  fit: BoxFit.cover,
                ),
              ):
              ClipRRect(
                borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
                child: Image.asset(
                  "assets/chat/empty_image.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: MARGIN_MEDIUM,),
          Text(
            dateString,
            style: const TextStyle(
              fontSize: TEXT_XSMALL,
              color:TEXT_FIELD_HINT_TXT_COLOR,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ):

      Container(
        width:MediaQuery.of(context).size.width*0.73,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                // mainAxisSpacing:5,
                crossAxisSpacing: MARGIN_MEDIUM,
                childAspectRatio: 1.45,
              ),
              itemCount: sendFileList.length,
              itemBuilder: (context,index){

               return
                 GestureDetector(
                   onTap: (){
                     return onTapSelectedPhoto(sendFileList[index].fileUrl.toString() ,sendFileList[index]);
                   },
                   child: Container(
                    width: IMAGE_MESSAGE_WIDTH,
                    height: IMAGE_MESSAGE_HEIGHT,
                    margin: const EdgeInsets.only(top:MARGIN_MEDIUM),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
                    ),
                    child:
                    (sendFileList[index].fileUrl != "")?
                    (sendFileList[index].fileType.toString().contains("video"))?
                    VideoMsgView(bloc: bloc,msgItem: msgItem,videoUrl:sendFileList[index].fileUrl??"" ,):

                    ClipRRect(
                      borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
                      child: Image.network(
                        sendFileList[index].fileUrl??"",
                        fit: BoxFit.cover,
                      ),
                    ):
                    ClipRRect(
                      borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
                      child: Image.asset(
                        "assets/chat/empty_image.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                ),
                 )

                ;
              },

            ),
            const SizedBox(height: MARGIN_MEDIUM,),
            Text(
              dateString,
              style: const TextStyle(
                fontSize: TEXT_XSMALL,
                color:TEXT_FIELD_HINT_TXT_COLOR,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
  }

}

class ReceiveTextMsgView extends StatelessWidget {
  const ReceiveTextMsgView({
    super.key,
    required this.msgItem,
  });

  final ChatMessageVO msgItem;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("hh:mm a", "en_US");
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(msgItem.timestamp.toString()));
    String dateString = dateFormat.format(dateTime);


    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(243, 243, 243, 1),
        borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            msgItem.message??"",
            style: const TextStyle(
              color: SECONDARY_COLOR,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: MARGIN_MEDIUM,),
          Text(
            dateString,
            style: const TextStyle(
              fontSize: TEXT_XSMALL,
              color:TEXT_FIELD_HINT_TXT_COLOR,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class SentMsgSectionView extends StatelessWidget {
  final ChatDetailPageBloc bloc;
  Function(String,MediaTypeVO) onTapSelectedPhoto;
   SentMsgSectionView({
    super.key,
    required this.msgItem,
     required this.bloc,
     required this.onTapSelectedPhoto
  });

  final ChatMessageVO msgItem;

  @override
  Container build(BuildContext context) {
    var stringValue = "";
    debugPrint("check send msg ${msgItem.message}");
    

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
                visible: (msgItem.message == "")? false: true,
                child:  TextMsgView(msgItem: msgItem),),
            const SizedBox(height: MARGIN_MEDIUM,),
            Visibility(
              visible: (msgItem.mediaFile?.length == 0)? false: true,
              child:
              ImageMsgOrVideoMsgView(bloc:bloc,msgItem: msgItem,onTapSelectedPhoto: (url,mediaTypeVO){

                debugPrint("sentmsgandrecivemsg click listener url ${url}");

                onTapSelectedPhoto(url,mediaTypeVO);

             /*   Container(
                 width: 100,
                    height: 100,
                    child: PhotoView(
                      imageProvider: NetworkImage("${url}"),
                    )
                );*/
              },))
    //         Visibility(
    //             visible: (msgItem.file == "")? false: true,
    //             child:
    // (bloc.checkFileFromUrl(msgItem.file??"") == "image")?
    //             ImageMsgView(msgItem: msgItem):
    // (bloc.checkFileFromUrl(msgItem.file??"") == "video")?
    // VideoMsgView(bloc: bloc,msgItem: msgItem) : Container(),)
          ],
        ),
      );
  }
}


class ImageMsgOrVideoMsgView extends StatelessWidget {

  final ChatDetailPageBloc bloc;
  Function(String,MediaTypeVO) onTapSelectedPhoto;

  ImageMsgOrVideoMsgView({
    super.key,
    required this.msgItem,
    required this.bloc,
    required this.onTapSelectedPhoto
  });
  final ChatMessageVO msgItem;



  @override
  Widget build(BuildContext context) {

  //  List<String> sendFileList =  msgItem.file?.split(",")??[];
    List<MediaTypeVO> sendFileList =   msgItem.mediaFile??[];//convertToList(msgItem.mediaFile);
  // List<MediaTypeVO> sendFileList =  msgItem.mediaFile?.values.toList()??[];

   DateFormat dateFormat = DateFormat("hh:mm a", "en_US");
   DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(msgItem.timestamp.toString()));
   String dateString = dateFormat.format(dateTime);

  print("check file url ${sendFileList[0].fileUrl} ------------ ${sendFileList[0].fileType}");


    if(sendFileList.length ==1 &&
        sendFileList[0].fileType.toString().contains("video") ) {

     // bloc.initVideoWithNetworkLink(sendFileList[0].fileUrl.toString());
    }


    return
      (sendFileList.length ==1)?

      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: (){
              debugPrint("sentmsgandrecivemsg click listener1");
              onTapSelectedPhoto(sendFileList[0].fileUrl??"",sendFileList[0]);
            },
            child: Container(
              width: 160,
              height: 100,
              margin: const EdgeInsets.only(top:MARGIN_MEDIUM),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
              ),
              child:
              (sendFileList[0].fileUrl != "")?
              (sendFileList[0].fileType.toString().contains("video"))?
              VideoMsgView(bloc: bloc,msgItem: msgItem,videoUrl:sendFileList[0].fileUrl??"")
             : (sendFileList[0].fileType.toString().contains("gif"))?
                  ClipRRect(
                borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
                child: Image.network(
                  sendFileList[0].fileUrl??"",
                  fit: BoxFit.cover,
                ),
              ):
              ClipRRect(
                borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
                child: Image.network(
                  sendFileList[0].fileUrl??"",
                  fit: BoxFit.cover,
                ),
              )
                :
              ClipRRect(
                borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
                child: Image.asset(
                  "assets/chat/empty_image.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: MARGIN_MEDIUM,),
          Text(
            dateString,
            style: const TextStyle(
              fontSize: TEXT_XSMALL,
              color:TEXT_FIELD_HINT_TXT_COLOR,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ):

      Container(
        constraints:  BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width*0.75,
            maxHeight: double.infinity),
        // minWidth: MediaQuery.of(context).size.width*0.8,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GridView.builder(
               shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
               // mainAxisSpacing:5,
                crossAxisSpacing: MARGIN_MEDIUM,
                childAspectRatio: 1.5,
              ),
              itemCount: sendFileList.length,
              itemBuilder: (context,index){

                return GestureDetector(
                  onTap: (){
                    debugPrint("sentmsgandrecivemsg click listener2");
                    onTapSelectedPhoto(sendFileList[index].fileUrl??"",sendFileList[index]);
                },
                  child: Container(
                    width: IMAGE_MESSAGE_WIDTH,
                    height: IMAGE_MESSAGE_HEIGHT,
                    margin: const EdgeInsets.only(top:MARGIN_MEDIUM),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
                    ),
                    child:
                    (sendFileList[index].fileUrl != "")?
                    (sendFileList[index].fileType.toString().contains("video"))?
                    VideoMsgView(bloc: bloc,msgItem: msgItem,videoUrl: sendFileList[index].fileUrl??"",):
                    (sendFileList[0].fileType.toString().contains("gif"))?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
                      child: Image.network(
                        sendFileList[0].fileUrl??"",
                        fit: BoxFit.cover,
                      ),
                    ):
                    ClipRRect(
                      borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
                      child: Image.network(
                        sendFileList[index].fileUrl??"",
                        fit: BoxFit.cover,
                      ),
                    ):
                    ClipRRect(
                      borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
                      child: Image.asset(
                        "assets/chat/empty_image.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );

              },

            ),
            SizedBox(height: MARGIN_MEDIUM,),
            Text(
              dateString,
              style: const TextStyle(
                fontSize: TEXT_XSMALL,
                color:TEXT_FIELD_HINT_TXT_COLOR,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
  }
}

class VideoMsgView extends StatelessWidget {
  final ChatDetailPageBloc bloc;
  final String videoUrl;
  const VideoMsgView({
    super.key,
    required this.msgItem,
    required this.bloc,
    required this.videoUrl
  });
  final ChatMessageVO msgItem;

  @override
  Widget build(BuildContext context) {
    return
      VideoViewCustomWidget(videoUrl:videoUrl);
  }
}
class TextMsgView extends StatelessWidget {
  const TextMsgView({
    super.key,
    required this.msgItem,
  });

  final ChatMessageVO msgItem;

  @override
  Widget build(BuildContext context) {

    DateFormat dateFormat = DateFormat("hh:mm a", "en_US");
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(msgItem.timestamp.toString()));
    String dateString = dateFormat.format(dateTime);


    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(17, 58, 93, 1),
        borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            msgItem.message??"",
            style: const TextStyle(
              color: Colors.white,
              fontSize: TEXT_REGULAR_1X,
            ),
          ),
          const SizedBox(height: MARGIN_SMALL,),
          Row(
            mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dateString,
                      style: const TextStyle(
                        fontSize: TEXT_XSMALL,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Image.asset('assets/chat/msg_seen_icon.png',scale: 2.5,)
                  ],
                )
        ],
      ),
    );
  }
}

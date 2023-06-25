import 'package:flutter/material.dart';
import 'package:we_chat_app/data/vos/chat_history_vo.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/components/profile_img_with_active_status_view.dart';

class EachChatViewItem extends StatelessWidget{

  final ChatHistoryVO chatHistoryVO;

  const EachChatViewItem({super.key,
  required this.chatHistoryVO
  });

  @override
  Widget build(BuildContext context) {
   return SizedBox(
      width: ACTIVE_NOW_CHAT_ITEM_WIDTH,
     child: Column(
       mainAxisSize: MainAxisSize.min,
       // crossAxisAlignment: CrossAxisAlignment.start,
        children:   [
          ProfileImgWithActiveStatusView(
            chatUserProfile: chatHistoryVO.chatUserProfileUrl??"",),
           const SizedBox(height: MARGIN_MEDIUM,),
           ActiveNowChatUserNameView(
               activeNowUserName:chatHistoryVO.chatUserName??""),

        ],
      ),
   );
  }

}



class ActiveNowChatUserNameView extends StatelessWidget {

  final String activeNowUserName;

  const ActiveNowChatUserNameView({
    super.key,
    required this.activeNowUserName
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
       activeNowUserName,
       style: TextStyle(
         fontSize: TEXT_REGULAR,
         color: Color.fromRGBO(17, 58, 93, 1),
         fontWeight: FontWeight.w600,
       ),
          ),
    );
  }
}




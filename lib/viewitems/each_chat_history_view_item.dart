import 'package:flutter/material.dart';
import 'package:we_chat_app/components/profile_img_with_active_status_view.dart';
import 'package:we_chat_app/data/vos/chat_history_vo.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class EachChatHistoryViewItem extends StatelessWidget{

  final Function(ChatHistoryVO) onTapEachChat;

  final ChatHistoryVO chatHistoryVO;

  const EachChatHistoryViewItem({super.key,
    required this.onTapEachChat,
  required this.chatHistoryVO});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        debugPrint("check action 3");
        onTapEachChat(chatHistoryVO);
      },
      child: Container(
        margin: const EdgeInsets.only(
            top: MARGIN_SMALL,
            left: MARGIN_CARD_MEDIUM_2,
            right: MARGIN_CARD_MEDIUM_2,
            bottom: MARGIN_SMALL),
        height: CHAT_HISTORY_CARD_HEIGHT,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // changes the position of the shadow
            ),
          ],
        ),

       // width: ACTIVE_NOW_CHAT_ITEM_WIDTH,
        child: Padding(
          padding: const EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
          child: Row(
           // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              ///chat history profile and chat msg section
              ChatHistoryProfileAndChatMsgView(chatHistoryVO: chatHistoryVO),

              ///chat msg status
              ChatMsgHistoryTimeAndStatusView(chatHistoryVO: chatHistoryVO),

            ],
          ),
        ),
      ),
    );
  }

}

class ChatHistoryProfileAndChatMsgView extends StatelessWidget {

  final ChatHistoryVO chatHistoryVO;

  const ChatHistoryProfileAndChatMsgView({
    super.key,
    required this.chatHistoryVO
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       ProfileImgWithActiveStatusView(chatUserProfile: chatHistoryVO.chatUserProfileUrl??"",),
        SizedBox(width: MARGIN_MEDIUM,),
        ChatUserNameAndChatLastMsgView(chatHistoryVO:chatHistoryVO),
      ],
    );
  }
}
class ChatHistoryProfileImageView extends StatelessWidget {
  const ChatHistoryProfileImageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: CHAT_HISTORY_ITEM_PROFILE_RADIUS,
      backgroundImage: AssetImage('assets/moments/profile_sample.jpg'),
    );
  }
}

class ChatMsgHistoryTimeAndStatusView extends StatelessWidget {

  final ChatHistoryVO chatHistoryVO;

  const ChatMsgHistoryTimeAndStatusView({
    super.key,
    required this.chatHistoryVO
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: MARGIN_CARD_MEDIUM_2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chatHistoryVO.chatTime??"",
            style: TextStyle(
              fontSize: TEXT_SMALL,
              color: Color.fromRGBO(17, 58, 93, 1),
              fontWeight: FontWeight.w600,
            ),
          ),
        Image.asset('assets/chat/msg_seen_icon.png',scale: 2.5,)

        ],
      ),
    );
  }
}

class ChatUserNameAndChatLastMsgView extends StatelessWidget {

  final ChatHistoryVO chatHistoryVO;

  const ChatUserNameAndChatLastMsgView({
    super.key,
    required this.chatHistoryVO
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          chatHistoryVO.chatUserName??"",
          style: const TextStyle(
            fontSize: TEXT_REGULAR_1X,
            color: Color.fromRGBO(17, 58, 93, 1),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: MARGIN_SMALL,),
        Text(
          chatHistoryVO.chatMsg??"",
          style: const TextStyle(
            fontSize: TEXT_REGULAR,
            color: TEXT_FIELD_HINT_TXT_COLOR,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class ChatHistoryProfileActiveStatusView extends StatelessWidget {
  const ChatHistoryProfileActiveStatusView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      right: 0,
      bottom: 0,
      child: Container(
        width: ACTIVE_STATUS_CIRCLE_SIZE,
        height: ACTIVE_STATUS_CIRCLE_SIZE,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
    );
  }
}






import 'package:flutter/material.dart';
import 'package:we_chat_app/components/profile_img_with_active_status_view.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class EachChatHistoryViewItem extends StatelessWidget{

  final Function onTapEachChat;

  const EachChatHistoryViewItem({super.key,required this.onTapEachChat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        debugPrint("check action 3");
        onTapEachChat();
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
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
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
            children:  const [
              ///chat history profile and chat msg section
              ChatHistoryProfileAndChatMsgView(),

              ///chat msg status
              ChatMsgHistoryTimeAndStatusView(),

            ],
          ),
        ),
      ),
    );
  }

}

class ChatHistoryProfileAndChatMsgView extends StatelessWidget {
  const ChatHistoryProfileAndChatMsgView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
       ProfileImgWithActiveStatusView(),
        SizedBox(width: MARGIN_MEDIUM,),
        ChatUserNameAndChatLastMsgView(),
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
  const ChatMsgHistoryTimeAndStatusView({
    super.key,
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
            '5min',
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
  const ChatUserNameAndChatLastMsgView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'May Thu Hein',
          style: TextStyle(
            fontSize: TEXT_REGULAR_1X,
            color: Color.fromRGBO(17, 58, 93, 1),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: MARGIN_SMALL,),
        Text(
          'Hello',
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






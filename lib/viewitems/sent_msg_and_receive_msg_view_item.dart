import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:we_chat_app/components/profile_img_with_active_status_view.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/pages/chat_detail_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class SentMsgAndReceiveMsgViewItem extends StatelessWidget {
  final ChatMessageVO msgItem;
  final UserVO? loginUserVO;

  const SentMsgAndReceiveMsgViewItem({super.key,
    required this.msgItem,
  required this.loginUserVO});

  @override
  Widget build(BuildContext context) {

    debugPrint("check send msg id ${loginUserVO?.id} ------ ${msgItem.userId}");

    return (loginUserVO?.id == msgItem.userId)
        ? SentMsgSectionView(msgItem: msgItem)
        : ReceiveMsgSectionView(msgItem: msgItem);

  }
}

class ReceiveMsgSectionView extends StatelessWidget {
  const ReceiveMsgSectionView({
    super.key,
    required this.msgItem,
  });

  final ChatMessageVO msgItem;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Padding(
              padding: EdgeInsets.only(
                  top: MARGIN_CARD_MEDIUM_2,
                  bottom: MARGIN_CARD_MEDIUM_2,
                  right: MARGIN_CARD_MEDIUM_2),
              child: ProfileImgWithActiveStatusView(chatUserProfile: '',),
            ),
            Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                    visible: (msgItem.message == "")? false: true,
                    child: ReceiveTextMsgView(msgItem: msgItem)),

                SizedBox(height: MARGIN_MEDIUM,),
                Visibility(
                    visible: (msgItem.file == "")? false: true,
                    child: ReceiveImgOrVideoMsgView(msgItem: msgItem)),
              ],
            ),
          ],
        ),
      );
  }
}

class ReceiveImgOrVideoMsgView extends StatelessWidget {
  const ReceiveImgOrVideoMsgView({
    super.key,
    required this.msgItem
  });
  final ChatMessageVO msgItem;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 150,
          height: 90,
          margin: const EdgeInsets.only(
              top:MARGIN_MEDIUM,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
            child: Image.asset(
              msgItem.file??"",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: MARGIN_MEDIUM,),
        const Text(
          '12:30AM',
          style: TextStyle(
            fontSize: TEXT_XSMALL,
            color:TEXT_FIELD_HINT_TXT_COLOR,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
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
  const SentMsgSectionView({
    super.key,
    required this.msgItem,
  });

  final ChatMessageVO msgItem;

  @override
  Widget build(BuildContext context) {
    debugPrint("check send msg ${msgItem.message}");
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Visibility(
                visible: (msgItem.message == "")? false: true,
                child:  TextMsgView(msgItem: msgItem),),
            const SizedBox(height: MARGIN_MEDIUM,),
            Visibility(
                visible: (msgItem.file == "")? false: true,
                child: ImageOrVideoMsgView(msgItem: msgItem)),
          ],
        ),
      );
  }
}

class ImageOrVideoMsgView extends StatelessWidget {
  const ImageOrVideoMsgView({
    super.key,
    required this.msgItem
  });
  final ChatMessageVO msgItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 150,
          height: 90,
          margin: const EdgeInsets.only(top:MARGIN_MEDIUM),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
            child: Image.asset(
              msgItem.file??"",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: MARGIN_MEDIUM,),
        const Text(
          '12:30AM',
          style: TextStyle(
            fontSize: TEXT_XSMALL,
            color:TEXT_FIELD_HINT_TXT_COLOR,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
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

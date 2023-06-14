import 'package:flutter/material.dart';
import 'package:we_chat_app/components/profile_img_with_active_status_view.dart';
import 'package:we_chat_app/pages/chat_detail_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class SentMsgAndReceiveMsgViewItem extends StatelessWidget {
  final ChatMessage msgItem;

  const SentMsgAndReceiveMsgViewItem({super.key, required this.msgItem});

  @override
  Widget build(BuildContext context) {
    return (msgItem.isSent)
        ? SentMsgSectionView(msgItem: msgItem)
        : ReceiveMsgSectionView(msgItem: msgItem);

  }
}

class ReceiveMsgSectionView extends StatelessWidget {
  const ReceiveMsgSectionView({
    super.key,
    required this.msgItem,
  });

  final ChatMessage msgItem;

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
              child: ProfileImgWithActiveStatusView(),
            ),
            Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReceiveTextMsgView(msgItem: msgItem),

                SizedBox(height: MARGIN_MEDIUM,),
                ReceiveImgOrVideoMsgView(),
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
  });

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
              'assets/moments/background_sample.jpg',
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

  final ChatMessage msgItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromRGBO(243, 243, 243, 1),
        borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            msgItem.message,
            style: TextStyle(
              color: SECONDARY_COLOR,
              fontSize: 16,
            ),
          ),
          SizedBox(height: MARGIN_MEDIUM,),
          Text(
            '12:30AM',
            style: TextStyle(
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

  final ChatMessage msgItem;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextMsgView(msgItem: msgItem),
            const SizedBox(height: MARGIN_MEDIUM,),
            ImageOrVideoMsgView(),
          ],
        ),
      );
  }
}

class ImageOrVideoMsgView extends StatelessWidget {
  const ImageOrVideoMsgView({
    super.key,
  });

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
              'assets/moments/background_sample.jpg',
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

  final ChatMessage msgItem;

  @override
  Widget build(BuildContext context) {
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
            msgItem.message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: TEXT_REGULAR_1X,
            ),
          ),
          const SizedBox(height: MARGIN_SMALL,),
          Row(
            mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '12:30AM',
                      style: TextStyle(
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

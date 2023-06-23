import 'package:flutter/material.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/pages/chat_detail_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/utils/extensions.dart';
import 'package:we_chat_app/viewitems/each_chat_history_view_item.dart';
import 'package:we_chat_app/viewitems/each_chat_view_item.dart';

class ChatsPage extends StatelessWidget{

  final UserVO? userVO;

  const ChatsPage({super.key,required this.userVO});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CHAT_PAGE_BG_COLOR,
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        automaticallyImplyLeading: false,
        title: const Text(
          CHAT_TXT,
          style: TextStyle(
            fontSize: TEXT_HEADING_2X,
            color: SECONDARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
              onTap: (){
               // navigateToScreen(context,CreateMomentPage());
              },
              child: Image.asset('assets/chat/search_icon.png',scale: 3,))
        ],

      ),
      body: SingleChildScrollView(
        child: Column(
         // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const ActiveNowTextView(),
           const SizedBox(height: MARGIN_MEDIUM,),
           const ActiveNowChatListView(),
           ChatHistoryListView(onTapEachChat: (){
             debugPrint("check action 1");
              navigateToScreen(context, ChatDetailPage(),false);
            },)
          ],
        ),
      ),
    );
  }


}
class ActiveNowTextView extends StatelessWidget {
  const ActiveNowTextView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
      child: Text(
        ACTIVE_NOW_TXT,
        style: TextStyle(
          fontSize: TEXT_SMALL,
          color: ACTIVE_NOW_TXT_COLOR,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ActiveNowChatListView extends StatelessWidget {
  const ActiveNowChatListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: MARGIN_CARD_MEDIUM_2),
      child: SizedBox(
        height: ACTIVE_NOW_CHAT_LIST_SECTION_HEIGHT,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            return const EachChatViewItem();
          },
        ),
      ),
    );
  }
}

class ChatHistoryListView extends StatelessWidget {

  final Function onTapEachChat;

  const ChatHistoryListView({
    super.key,
    required this.onTapEachChat
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: 10,
      itemBuilder: (context, index) {
        return EachChatHistoryViewItem(onTapEachChat: (){
          debugPrint("check action 2");
         onTapEachChat();
        });
      },
    );
  }
}




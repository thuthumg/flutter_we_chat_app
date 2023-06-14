import 'package:flutter/material.dart';
import 'package:we_chat_app/components/profile_img_with_active_status_view.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/viewitems/sent_msg_and_receive_msg_view_item.dart';

class ChatMessage {
  final String message;
  final bool isSent;

  ChatMessage({required this.message, required this.isSent});
}

final List<ChatMessage> chatMessages = [
  ChatMessage(message: 'Hello!', isSent: false),
  ChatMessage(message: 'Hi there!', isSent: true),
  ChatMessage(message: 'How are you?', isSent: false),
  ChatMessage(message: "I'm good. How about you?", isSent: true),
];

class ChatDetailPage extends StatefulWidget {
  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  TextEditingController _textEditingController = TextEditingController();
  void _sendMessage() {
    String messageText = _textEditingController.text.trim();
    if (messageText.isNotEmpty) {
      ChatMessage message = ChatMessage(message: messageText, isSent: true);
      setState(() {
        chatMessages.add(message);
        _textEditingController.clear();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CHAT_PAGE_BG_COLOR,
      appBar: CustomAppBarSectionView(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ///show chat msg (chat History time + Sent Msg +Receive Msg ) Section View
          ChatMsgSectionView(),

          ///Type And Send Msg Section View
          /// Media(photo,video) data, git data, location data and voice data Action Section View
          Column(
            children: const [
              ///Type And Send Msg Section View
              SendMsgSectionView(),

              /// Media(photo,video) data, git data, location data and voice data Action Section View
              ActionButtonSectionViewForSendMediaMsg(),

            ],
          ),
        ],
      ),
    );
  }
}

class ActionButtonSectionViewForSendMediaMsg extends StatefulWidget {

  const ActionButtonSectionViewForSendMediaMsg({
    super.key,
  });

  @override
  State<ActionButtonSectionViewForSendMediaMsg> createState() => _ActionButtonSectionViewForSendMediaMsgState();
}

class _ActionButtonSectionViewForSendMediaMsgState extends State<ActionButtonSectionViewForSendMediaMsg> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
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
            offset:
            Offset(0, 3), // changes the position of the shadow
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

class SendMsgSectionView extends StatelessWidget {
  const SendMsgSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: ''),
              onChanged: (text) {},
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
          Image.asset(
            'assets/chat/send_btn_icon.png',
            scale: 3,
          )
        ],
      ),
    );
  }
}

class ChatMsgSectionView extends StatelessWidget {
  const ChatMsgSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        scrollDirection: Axis.vertical,
        // physics: NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        itemCount: chatMessages.length,
        itemBuilder: (context, index) {
          ChatMessage message = chatMessages[index];
          return Column(
           // crossAxisAlignment: CrossAxisAlignment.start,
          //  mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///Chat History Section Time
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(MARGIN_MEDIUM),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      fontSize: TEXT_REGULAR,
                      color: TEXT_FIELD_HINT_TXT_COLOR,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
                SizedBox(height: MARGIN_CARD_MEDIUM_2,),
                SentMsgAndReceiveMsgViewItem(
                msgItem: message,
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
  const CustomAppBarSectionView({
    super.key,
  });

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
            const Padding(
              padding: EdgeInsets.only(top: MARGIN_CARD_MEDIUM_2),
              child: ChatDetailPageProfileAndStatusView(),
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
  const ChatDetailPageProfileAndStatusView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        ///Back Button View
        BackButtonView(),

        ///Chat Profile pic , user name and status
        ProfileImgWithActiveStatusView(),
        SizedBox(
          width: MARGIN_MEDIUM,
        ),
        ChatUserNameAndStatusView(),
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
  const ChatUserNameAndStatusView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'May Thu Hein',
          style: TextStyle(
            fontSize: TEXT_REGULAR_1X,
            color: Color.fromRGBO(17, 58, 93, 1),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: MARGIN_SMALL,
        ),
        Text(
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

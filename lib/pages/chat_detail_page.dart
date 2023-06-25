import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/chat_detail_page_bloc.dart';
import 'package:we_chat_app/components/profile_img_with_active_status_view.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/viewitems/sent_msg_and_receive_msg_view_item.dart';

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
      create: (context) => ChatDetailPageBloc(chatUserId),
      child: Consumer<ChatDetailPageBloc>(
        builder: (context, bloc, child) => Scaffold(
          backgroundColor: CHAT_PAGE_BG_COLOR,
          appBar: CustomAppBarSectionView(
              chatUserName: chatUserName, chatUserProfile: chatUserProfile),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///show chat msg (chat History time + Sent Msg +Receive Msg ) Section View
              ChatMsgSectionView(
                  loginUserVO:bloc.userVO,
                  chatMessageList: bloc.chatMessageVOList
              ),

              ///Type And Send Msg Section View
              /// Media(photo,video) data, git data, location data and voice data Action Section View
              Column(
                children: [
                  ///Type And Send Msg Section View
                  SendMsgSectionView(
                      chatDetailPageBloc: bloc,
                      onTapSendMessage: () {
                    return bloc.onTapSendMessage(
                        bloc.userVO?.id,
                        chatUserId,
                        bloc.typeMessageText,
                        bloc.userVO?.userName,
                        "",
                        bloc.userVO?.profileUrl);
                  }),

                  /// Media(photo,video) data, git data, location data and voice data Action Section View
                  ActionButtonSectionViewForSendMediaMsg(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButtonSectionViewForSendMediaMsg extends StatefulWidget {
  const ActionButtonSectionViewForSendMediaMsg({
    super.key,
  });

  @override
  State<ActionButtonSectionViewForSendMediaMsg> createState() =>
      _ActionButtonSectionViewForSendMediaMsgState();
}

class _ActionButtonSectionViewForSendMediaMsgState
    extends State<ActionButtonSectionViewForSendMediaMsg> {
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
  List<ChatMessageVO> chatMessageList;
  UserVO? loginUserVO;

   ChatMsgSectionView({
    super.key,
     required this.chatMessageList,
     required this.loginUserVO
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("check chat message list2 =  ${chatMessageList.length}");

    return Expanded(
      child: ListView.builder(
        reverse: true,
        scrollDirection: Axis.vertical,
        // physics: NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        itemCount: chatMessageList.length,
        itemBuilder: (context, index) {
          ChatMessageVO message = chatMessageList[index];

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
              SizedBox(
                height: MARGIN_CARD_MEDIUM_2,
              ),
              SentMsgAndReceiveMsgViewItem(
                loginUserVO: loginUserVO,
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

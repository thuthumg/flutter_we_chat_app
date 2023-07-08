import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/chat_history_vo.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/utils/constants.dart';

class ChatsPageBloc extends ChangeNotifier {

  ///State
  bool isDisposed = false;
  bool isLoading = false;

  UserVO? userVO;

  List<ChatHistoryVO> chatHistoryVOList = [];

  List<ChatHistoryVO> groupChatHistoryVOList = [];

  ///Model
  final WeChatAppModel _mWeChatAppModel = WeChatAppModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  ChatsPageBloc() {
    _showLoading();
    _mWeChatAppModel.getUserVOById(
        _authenticationModel.getLoggedInUser().id ?? "")
        .listen((userObj) {
      userVO = userObj;
      privateChatHistoryList(userVO);
      groupChatHistoryList(userVO);
      _hideLoading();
      _notifySafely();
    });




  }


  @override
  void dispose() async{
    super.dispose();

    isDisposed = true;

  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  void _showLoading(){
    isLoading = true;
    _notifySafely();
  }

  void _hideLoading(){
    isLoading = false;
    _notifySafely();
  }

  void privateChatHistoryList(UserVO? userVO) {
    _mWeChatAppModel.getChatHistoryList(userVO?.id??"").listen((chatMsgList){
      debugPrint("check chat message list length ${chatMsgList.length}");

      chatHistoryVOList = chatMsgList;
      _notifySafely();
    });

  }

  void groupChatHistoryList(UserVO? userVO) {
    _mWeChatAppModel.getChatGroupsList(userVO?.id ?? "").listen((groupChatHistoryListVO) {
      debugPrint("check chat message list length ${groupChatHistoryListVO.length}");

      List<ChatHistoryVO> chatHistoryMessageList = [];

      for (var groupChatHistoryVO in groupChatHistoryListVO) {
        var mChatHistoryVO = ChatHistoryVO();

        mChatHistoryVO.chatUserId = groupChatHistoryVO.id;
        mChatHistoryVO.chatUserName = groupChatHistoryVO.name;
        mChatHistoryVO.chatUserProfileUrl = groupChatHistoryVO.profileUrl;

        var sortedListData = groupChatHistoryVO.message?.values.toList();
        if(sortedListData != null && sortedListData.length > 0)
          {
            debugPrint("group chat list ${sortedListData.length}");
            sortedListData.sort((a, b) {
              return (b.timestamp??"").compareTo(a.timestamp??"");
            });

            mChatHistoryVO.chatMsg = sortedListData?.first.message;

            mChatHistoryVO.chatTime = sortedListData?.first.timestamp!= null
                ? changeFromTimestampToDate(int.parse(sortedListData?.first.timestamp??""))
                : null;
            chatHistoryMessageList.add(mChatHistoryVO);
          }

      }

      groupChatHistoryVOList = chatHistoryMessageList;
      _notifySafely();
    });



  }

}
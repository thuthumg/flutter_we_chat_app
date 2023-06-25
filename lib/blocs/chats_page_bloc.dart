import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/chat_history_vo.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';

class ChatsPageBloc extends ChangeNotifier {

  ///State
  bool isDisposed = false;
  bool isLoading = false;

  UserVO? userVO;

  List<ChatHistoryVO> chatHistoryVOList = [];

  ///Model
  final WeChatAppModel _mWeChatAppModel = WeChatAppModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  ChatsPageBloc() {
    _showLoading();
    _mWeChatAppModel.getUserVOById(
        _authenticationModel.getLoggedInUser().id ?? "")
        .listen((userObj) {
      userVO = userObj;
      _mWeChatAppModel.getChatHistoryList(userVO?.id??"").listen((chatMsgList){
        debugPrint("check chat message list length ${chatMsgList.length}");

        // chatHistoryVOList.forEach((element) {
        //   debugPrint("check chat message for each loop ${element.chatUserId} ${element.chatMsg}");
        //
        // });
        // chatMsgList.forEach((element) {
        //
        //   chatHistoryVOList.add(ChatHistoryVO(
        //       element.userId,
        //       element.name,
        //       element.profileUrl,
        //       element.message,
        //       element.timestamp)
        //   )
        // })
        chatHistoryVOList = chatMsgList;
        _notifySafely();
      });
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

}
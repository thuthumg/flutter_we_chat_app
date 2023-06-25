import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';

class ChatDetailPageBloc extends ChangeNotifier {
  ///State
  bool isDisposed = false;
  bool isLoading = false;

  UserVO? userVO;
  String typeMessageText = "";
  bool isSendMessageError = false;

  String profilePicture = "";

  List<ChatMessageVO> chatMessageVOList = [];
  List<File> selectedImages = [];
  ///Model
  final WeChatAppModel _mWeChatAppModel = WeChatAppModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  ChatDetailPageBloc(String receiverId) {
    _showLoading();
    _mWeChatAppModel
        .getUserVOById(_authenticationModel.getLoggedInUser().id ?? "")
        .listen((userObj) {
      userVO = userObj;
      _mWeChatAppModel
          .getChatMessageList(userVO?.id ?? "", receiverId)
          .listen((chatMsgList) {
        debugPrint("check chat message list length ${chatMsgList.length}");
        // chatMsgList.sort((a, b) => (b.timestamp??"").compareTo(a.timestamp??""));
        chatMessageVOList = chatMsgList;
        chatMessageVOList
            .sort((a, b) => (b.timestamp ?? "").compareTo(a.timestamp ?? ""));
        _notifySafely();
      });
      _hideLoading();
      _notifySafely();
    });
  }

  void onTypeMessageTextChanged(String typeMessageText) {
    this.typeMessageText = typeMessageText;
  }

  Future onTapSendMessage(
    senderId,
    receiverId,
    sendMsg,
    senderName,
    sendMsgFileUrl,
    profileUrl,
  ) {
    _showLoading();
    if (typeMessageText.isEmpty) {
      debugPrint("type text empty case");
      _hideLoading();
      isSendMessageError = true;
      _notifySafely();
      return Future.error("Error");
    } else {
      debugPrint("type text not empty case");
      isLoading = true;
      isSendMessageError = false;
      _notifySafely();
      return _sendChatMessage(senderId, receiverId, sendMsg, senderName,
              sendMsgFileUrl, profileUrl)
          .then((value) {
        isLoading = false;
        _hideLoading();
        _notifySafely();
      });
    }
  }

  Future<void> _sendChatMessage(senderId, receiverId, sendMsg, senderName,
      sendMsgFileUrl, profileUrl) async {
    _mWeChatAppModel.sendMessage(
        senderId,
        receiverId,
        sendMsg,
        senderName,
        sendMsgFileUrl,
        profileUrl,
        DateTime.now().millisecondsSinceEpoch.toString());

    _notifySafely();
  }

  void onImageChosen(File imageFile){
    _showLoading();
    selectedImages.add(imageFile);
    _hideLoading();
    _notifySafely();

  }
  @override
  void dispose() async {
    super.dispose();

    isDisposed = true;
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  void _showLoading() {
    isLoading = true;
    _notifySafely();
  }

  void _hideLoading() {
    isLoading = false;
    _notifySafely();
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:http/http.dart' as http;

class ChatDetailPageBloc extends ChangeNotifier {
  ///State
  bool isDisposed = false;
  bool isLoading = false;

  UserVO? userVO;
  String typeMessageText = "";
  bool isSendMessageError = false;

  String profilePicture = "";
 // bool isGroup = false;
  List<ChatMessageVO> chatMessageVOList = [];
  List<File> selectedImages = [];

  bool fileTypeStr = false;

  VideoPlayerController? _videoController;
  VideoPlayerController? get videoController => _videoController;
  ///Model
  final WeChatAppModel _mWeChatAppModel = WeChatAppModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  ChatDetailPageBloc(String receiverId,bool isGroup) {
    _showLoading();
    _mWeChatAppModel
        .getUserVOById(_authenticationModel.getLoggedInUser().id ?? "")
        .listen((userObj) {
      userVO = userObj;
      _mWeChatAppModel
          .getChatMessageList(userVO?.id ?? "", receiverId,isGroup)
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
      isChatGroup
  ) {
    _showLoading();
    if (typeMessageText.isEmpty && selectedImages.isEmpty) {
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

      if(isChatGroup)
        {
          return _sendGroupChatMessage(senderId, receiverId, sendMsg, senderName,
              sendMsgFileUrl, profileUrl)
              .then((value) {
            isLoading = false;
            _hideLoading();
            _notifySafely();
          });
        }
      else{
        return _sendChatMessage(senderId, receiverId, sendMsg, senderName,
            sendMsgFileUrl, profileUrl)
            .then((value) {
          isLoading = false;
          _hideLoading();
          _notifySafely();
        });
      }


    }
  }

  //  checkFileType(String msgFile){
  //   getContentType(msgFile).then((value) {
  //     if (value != null) {
  //       fileTypeStr = value;
  //      // stringValue = value;
  //      // print(stringValue);
  //     } else {
  //       print('Error: Future returned null');
  //     }
  //   });
  //   _notifySafely();
  // }



   checkFileFromUrl(String url) {
    print("check url = ${url}");
    http.head(Uri.parse(url)).then((http.Response response) {
      if (response.statusCode == 200) {
        final String? contentType = response.headers['content-type'];

        if (isImage(contentType!)) {
          // Handle image file
          print('Image file found!');
          return "image";
        } else if (isVideo(contentType)) {
          // Handle video file
          print('Video file found!');
          return "video";
        } else {
          print('Unsupported file type!');
          return "error";
        }
      } else {
        print('Error occurred!');
        return "error";
      }
    });
  }

  bool isImage(String contentType) {
    // Perform your image file type check here
    // Return true if it's an image, false otherwise
    return contentType.startsWith('image/');
  }

  bool isVideo(String contentType) {
    // Perform your video file type check here
    // Return true if it's a video, false otherwise
    return contentType.startsWith('video/');
  }

  //
  // Future<bool> getContentType(String downloadUrl)  {
  //   try {// Future<String?>
  //     final response =  http.head(Uri.parse(downloadUrl));
  //     var contentType =  response.headers['content-type'].toString();
  //    return contentType != null && contentType.startsWith('image/');
  //
  //   } catch (e) {
  //     print('Error retrieving content type: $e');
  //     return false;
  //   }
  // }
  // bool isImageFile(String contentType) {
  //   print('isImageFile: $contentType');
  //
  //   return contentType != null && contentType.startsWith('image/');
  // }
  //
  // bool isVideoFile(String contentType) {
  //   return contentType != null && contentType.startsWith('video/');
  // }

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

/*  void onImageChosen(File imageFile){
    _showLoading();
    selectedImages.add(imageFile);
    _hideLoading();
    _notifySafely();

  }*/

  void onImageChosen(List<dynamic> imageFiles){
    _showLoading();
    // chosenImageFile = imageFile;
    imageFiles.forEach((element) {
      selectedImages.add(File(element));
    });

    _hideLoading();
    _notifySafely();

  }
  void onRemoveSelectedImage(int selectedId){
    selectedImages.removeAt(selectedId);
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


  Future<void> _sendGroupChatMessage(senderId, receiverId, sendMsg, senderName,
      sendMsgFileUrl, profileUrl) async {
    _mWeChatAppModel.sendGroupMessage(
        senderId,
        receiverId,
        sendMsg,
        senderName,
        sendMsgFileUrl,
        profileUrl,
        DateTime.now().millisecondsSinceEpoch.toString());

    _notifySafely();
  }


  Future<void> initVideo(String path) async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(File(path));
    await _videoController!.initialize();
    notifyListeners();
  }

  Future<void> play() async {
    await _videoController!.play();
    notifyListeners();
  }

  Future<void> pause() async {
    await _videoController!.pause();
    notifyListeners();
  }
}

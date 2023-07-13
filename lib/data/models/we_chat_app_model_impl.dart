import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/vos/chat_group_vo.dart';
import 'package:we_chat_app/data/vos/chat_history_vo.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';
import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/data/vos/otp_code_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/network/dataagents/cloud_firestore_data_agent_impl.dart';
import 'package:we_chat_app/network/dataagents/real_time_database_agent_impl.dart';
import 'package:we_chat_app/network/dataagents/we_chat_app_data_agent.dart';
import 'package:we_chat_app/network/dataagents/we_chat_app_real_time_db_data_agent.dart';

class WeChatAppModelImpl extends WeChatAppModel {
  static final WeChatAppModelImpl _singleton = WeChatAppModelImpl._internal();

  factory WeChatAppModelImpl() {
    return _singleton;
  }

  WeChatAppModelImpl._internal();

  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();
  WeChatAppDataAgent mDataAgent = CloudFirestoreDataAgentImpl();
  WeChatAppRealTimeDBDataAgent mRealTimeDataAgent = RealtimeDatabaseDataAgentImpl();

  @override
  Stream<List<OTPCodeVO>> getOtpCode() {
    return mDataAgent.getOtpCode();
  }

  @override
  Stream<UserVO> getUserVOById(String userVOId) {
    return mDataAgent.getUserVOById(userVOId);
  }

  @override
  Future<void> addNewMoment(
      UserVO? userVO, String description, List<File> imageFile) {
    debugPrint("check image file ${imageFile.length}");
    if (imageFile != null) {
      return mDataAgent
          .multiUploadFileToFirebase(imageFile)
          .then(
              (downloadUrl) => craftMomentVO(userVO, description, downloadUrl))
          .then((newMoment) => mDataAgent.addNewMoment(newMoment));
    } else {
      return craftMomentVO(userVO, description, "")
          .then((newMoment) => mDataAgent.addNewMoment(newMoment));
    }
  }

  Future<MomentVO> craftMomentVO(
      UserVO? userVO, String description, String downloadUrl) {

    debugPrint("check downloadurl ${downloadUrl}");

    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    String formattedDateTime = dateFormat.format(now);
    print(formattedDateTime);

    var currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    var newMoment = MomentVO(
        id: currentMilliseconds.toString(),
        name: userVO?.userName,
        description: description,
        phoneNumber: userVO?.phoneNumber,
        photoOrVideoUrlLink: downloadUrl,
        profileUrl: userVO?.profileUrl,
        timestamp: formattedDateTime,
        likedIdList: []);

    // MomentVO(
    //     id: currentMilliseconds.toString(),
    //     name: _authenticationModel.getLoggedInUser().userName,
    //     description : description,
    //     phoneNumber:_authenticationModel.getLoggedInUser().phoneNumber,
    //     photoOrVideoUrlLink:downloadUrl,
    //     profileUrl: _authenticationModel.getLoggedInUser().profileUrl);

    return Future.value(newMoment);
  }

  @override
  Future<String> uploadImages(List<File> imagesOrVideos) {
    return mDataAgent.multiUploadFileToFirebase(imagesOrVideos);
  }

  @override
  Stream<List<MomentVO>> getMomentsList() {
    return mDataAgent.getMomentsList();
  }

  @override
  Stream<List<MomentVO>> getMomentVOByUserId(String userVOId) {
    return mDataAgent.getMomentsListByUserId(userVOId);
  }

  @override
  Stream<List<MomentVO>> getMomentVOByUserIdForFavouriteMoment(String userVOId) {
    return mDataAgent.getMomentVOByUserIdForFavouriteMoment(userVOId);
  }

  @override
  Future<void> saveBookmark(UserVO userVO, MomentVO newMoment) {
    return mDataAgent.saveBookmark(userVO, newMoment);
  }

  @override
  Future<void> saveFavourite(UserVO userVO, MomentVO newMoment) {
    return mDataAgent.saveFavourite(userVO, newMoment);
  }


  @override
  Future<void> saveQRScanUserVO(String loginUserVOId, String scanUserVOId) {
    return mDataAgent.saveQRScanUserVO(loginUserVOId, scanUserVOId);
  }

  @override
  Stream<List<UserVO>> getContactList(String userVOId) {
   return mDataAgent.getContactList(userVOId);
  }

  @override
  Future<void> sendMessage(String senderId, String receiverId, String sendMsg, String senderName, List<File> sendMsgFileUrl, String profileUrl, String timestamp) {
    return mRealTimeDataAgent.sendMessage(senderId, receiverId, sendMsg, senderName, sendMsgFileUrl, profileUrl, timestamp);
  }

  @override
  Stream<List<ChatMessageVO>> getChatMessageList(String loginUserId,String receiverId,
      bool isGroup) {
    return mRealTimeDataAgent.getChatMessageList(loginUserId,receiverId,isGroup);
  }

  @override
  Stream<List<ChatHistoryVO>> getChatHistoryList(String loginUserId) {
    return mRealTimeDataAgent.getChatHistoryList(loginUserId);
  }

  @override
  Future<void> createChatGroup(String groupName, List<String> membersList, File groupPhoto) {


    if (groupPhoto != null) {
      return mDataAgent
          .uploadFileToFirebase(groupPhoto)
          .then(
              (downloadUrl) => craftChatGroupVO(groupName, membersList, downloadUrl))
          .then((newChatGroup) => mRealTimeDataAgent.createChatGroup(newChatGroup));
    } else {
      return craftChatGroupVO(groupName, membersList, "")
          .then((newChatGroup) => mRealTimeDataAgent.createChatGroup(newChatGroup));
    }

  //  return mRealTimeDataAgent.createChatGroup(groupName, membersList, groupPhoto);
  }

  Future<ChatGroupVO> craftChatGroupVO(
  String groupName, List<String> membersList, String strGroupPhoto) {


    final currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();

    var newGroupChat = ChatGroupVO(
        id: currentTimestamp,
        name: groupName,
        message: {},
        membersList: membersList,
        profileUrl: strGroupPhoto);


    return Future.value(newGroupChat);
  }

  @override
  Stream<List<ChatGroupVO>> getChatGroupsList(String loginUserId) {
    debugPrint("getChatGroupsList model");
   return mRealTimeDataAgent.getChatGroupsList(loginUserId);
  }

  @override
  Future<void> sendGroupMessage(
      String senderId,
      String receiverId,
      String sendMsg,
      String senderName,
      List<File> sendMsgFileUrl,
      String profileUrl,
      String timestamp) {
    return mRealTimeDataAgent.sendGroupMessage(senderId,
        receiverId, sendMsg, senderName, sendMsgFileUrl, profileUrl, timestamp);

  }
}

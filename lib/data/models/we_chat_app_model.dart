import 'dart:io';

import 'package:we_chat_app/data/vos/chat_group_vo.dart';
import 'package:we_chat_app/data/vos/chat_history_vo.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';
import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/data/vos/otp_code_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';

abstract class WeChatAppModel{
  Stream<List<OTPCodeVO>> getOtpCode();

  Stream<UserVO> getUserVOById(String userVOId);

  Stream<List<MomentVO>> getMomentVOByUserId(String userVOId);

  Stream<List<MomentVO>> getMomentVOByUserIdForFavouriteMoment(String userVOId);

  Future<void> addNewMoment(UserVO? userVO,String description,List<File> imageFile);

  Future<void> uploadImages(List<File> imagesOrVideos);

  Stream<List<MomentVO>> getMomentsList();

  Future<void> saveBookmark(UserVO userVO,MomentVO newMoment);

  Future<void> saveFavourite(UserVO userVO,MomentVO newMoment);


  Future<void> saveQRScanUserVO(String loginUserVOId,String scanUserVOId);


  Stream<List<UserVO>> getContactList(String userVOId);

  Future<void> sendMessage(String senderId, String receiverId, String sendMsg,
      String senderName, List<File> sendMsgFileUrl, String profileUrl,
      String timestamp,List<String>  selectedGifImages,String voiceRecordedFile);


  Stream<List<ChatMessageVO>> getChatMessageList(String loginUserId,String receiverId,
      bool isGroup);
  Stream<List<ChatHistoryVO>> getChatHistoryList(String loginUserId);

  Future<void> createChatGroup(
      String groupName,
      List<String> membersList,
      File groupPhoto
      );

  Stream<List<ChatGroupVO>> getChatGroupsList(String loginUserId);

  Future<void> sendGroupMessage(
      String senderId,
      String receiverId,
      String sendMsg,
      String senderName,
      List<File> sendMsgFileUrl,
      String profileUrl,
      String timestamp,
      List<String> selectedGifImages,
      String voiceRecordedFile);

}
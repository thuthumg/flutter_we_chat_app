import 'dart:io';

import 'package:we_chat_app/data/vos/chat_group_vo.dart';
import 'package:we_chat_app/data/vos/chat_history_vo.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';

abstract class WeChatAppRealTimeDBDataAgent {

  Future<void> sendMessage(String senderId, String receiverId, String sendMsg,
      String senderName, List<File> sendMsgFileUrl, String profileUrl,String timestamp);

  Stream<List<ChatMessageVO>> getChatMessageList(String loginUserId,String receiverId,bool isGroup);
  Stream<List<ChatHistoryVO>> getChatHistoryList(String loginUserId);

  Future<void> createChatGroup(
      ChatGroupVO chatGroupVO
      );
  Stream<List<ChatGroupVO>> getChatGroupsList(String loginUserId);

  Future<void> sendGroupMessage(
      String senderId,
      String receiverId,
      String sendMsg,
      String senderName,
      List<File> sendMsgFileUrl,
      String profileUrl,
      String timestamp);


}

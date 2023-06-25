import 'package:we_chat_app/data/vos/chat_history_vo.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';

abstract class WeChatAppRealTimeDBDataAgent {

  Future<void> sendMessage(String senderId, String receiverId, String sendMsg,
      String senderName, String sendMsgFileUrl, String profileUrl,String timestamp);

  Stream<List<ChatMessageVO>> getChatMessageList(String loginUserId,String receiverId);
  Stream<List<ChatHistoryVO>> getChatHistoryList(String loginUserId);
//getChatHistoryList
//createChatGroup
//getChatGroupsList
//sendGroupMessage
}

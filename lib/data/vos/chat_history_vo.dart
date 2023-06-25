import 'package:json_annotation/json_annotation.dart';

part 'chat_history_vo.g.dart';

@JsonSerializable()
class ChatHistoryVO {

  @JsonKey(name: "chatUserId")
  String? chatUserId;

  @JsonKey(name: "chatUserName")
  String? chatUserName;

  @JsonKey(name: "chatUserProfileUrl")
  String? chatUserProfileUrl;

  @JsonKey(name: "chatMsg")
  String? chatMsg;

  @JsonKey(name: "chatTime")
  String? chatTime;

  ChatHistoryVO({
    this.chatUserId, this.chatUserName, this.chatUserProfileUrl,
    this.chatMsg, this.chatTime
});

  factory ChatHistoryVO.fromJson(Map<String, dynamic> json) =>
      _$ChatHistoryVOFromJson(json);

  Map<String, dynamic> toJson() => _$ChatHistoryVOToJson(this);
}
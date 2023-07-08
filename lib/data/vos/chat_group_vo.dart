import 'package:json_annotation/json_annotation.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';

part 'chat_group_vo.g.dart';

@JsonSerializable()
class ChatGroupVO {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "message")
  Map<String, ChatMessageVO>? message;

  @JsonKey(name: "membersList")
  List<String>? membersList;

  @JsonKey(name: "profileUrl")
  String? profileUrl;

  ChatGroupVO(
      {this.id, this.name, this.message, this.membersList, this.profileUrl});

  factory ChatGroupVO.fromJson(Map<String, dynamic> json) =>
      _$ChatGroupVOFromJson(json);

  Map<String, dynamic> toJson() => _$ChatGroupVOToJson(this);

  @override
  String toString() {
    return 'ChatGroupVO{id: $id, name: $name, message: $message, membersList: $membersList, profileUrl: $profileUrl}';
  }
}

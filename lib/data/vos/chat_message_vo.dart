import 'package:json_annotation/json_annotation.dart';
import 'package:we_chat_app/data/vos/media_type_vo.dart';

part 'chat_message_vo.g.dart';

@JsonSerializable()
class ChatMessageVO {

  @JsonKey(name: "id")
  String? id;

  // @JsonKey(name: "file")
  // String? file;
  @JsonKey(name: "media_file")
   List<MediaTypeVO>? mediaFile;
 // List<Map<String, dynamic>>? mediaFile;
 // Map<String, MediaTypeVO>? mediaFile;


  @JsonKey(name: "message")
  String? message;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "profileUrl")
  String? profileUrl;

  @JsonKey(name: "timestamp")
  String? timestamp;

  @JsonKey(name: "userId")
  String? userId;


  ChatMessageVO({this.id, this.mediaFile, this.message, this.name, this.profileUrl,
    this.timestamp, this.userId});

  factory ChatMessageVO.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageVOFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageVOToJson(this);
}
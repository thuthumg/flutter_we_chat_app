// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageVO _$ChatMessageVOFromJson(Map<String, dynamic> json) =>
    ChatMessageVO(
      id: json['id'] as String?,
      file: json['file'] as String?,
      message: json['message'] as String?,
      name: json['name'] as String?,
      profileUrl: json['profileUrl'] as String?,
      timestamp: json['timestamp'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$ChatMessageVOToJson(ChatMessageVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file': instance.file,
      'message': instance.message,
      'name': instance.name,
      'profileUrl': instance.profileUrl,
      'timestamp': instance.timestamp,
      'userId': instance.userId,
    };

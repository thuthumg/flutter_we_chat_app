// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageVO _$ChatMessageVOFromJson(Map<String, dynamic> json) =>
    ChatMessageVO(
      id: json['id'] as String?,
      mediaFile: (json['media_file'] as List<dynamic>?)
          ?.map((e) => MediaTypeVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      name: json['name'] as String?,
      profileUrl: json['profileUrl'] as String?,
      timestamp: json['timestamp'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$ChatMessageVOToJson(ChatMessageVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_file': instance.mediaFile,
      'message': instance.message,
      'name': instance.name,
      'profileUrl': instance.profileUrl,
      'timestamp': instance.timestamp,
      'userId': instance.userId,
    };

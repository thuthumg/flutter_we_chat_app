// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_group_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatGroupVO _$ChatGroupVOFromJson(Map<String, dynamic> json) => ChatGroupVO(
      id: json['id'] as String?,
      name: json['name'] as String?,
      message: (json['message'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, ChatMessageVO.fromJson(e as Map<String, dynamic>)),
      ),
      membersList: (json['membersList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      profileUrl: json['profileUrl'] as String?,
    );

Map<String, dynamic> _$ChatGroupVOToJson(ChatGroupVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'message': instance.message,
      'membersList': instance.membersList,
      'profileUrl': instance.profileUrl,
    };

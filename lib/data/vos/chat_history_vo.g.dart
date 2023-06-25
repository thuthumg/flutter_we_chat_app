// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_history_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatHistoryVO _$ChatHistoryVOFromJson(Map<String, dynamic> json) =>
    ChatHistoryVO(
      chatUserId: json['chatUserId'] as String?,
      chatUserName: json['chatUserName'] as String?,
      chatUserProfileUrl: json['chatUserProfileUrl'] as String?,
      chatMsg: json['chatMsg'] as String?,
      chatTime: json['chatTime'] as String?,
    );

Map<String, dynamic> _$ChatHistoryVOToJson(ChatHistoryVO instance) =>
    <String, dynamic>{
      'chatUserId': instance.chatUserId,
      'chatUserName': instance.chatUserName,
      'chatUserProfileUrl': instance.chatUserProfileUrl,
      'chatMsg': instance.chatMsg,
      'chatTime': instance.chatTime,
    };

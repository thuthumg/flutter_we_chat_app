// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MomentVO _$MomentVOFromJson(Map<String, dynamic> json) => MomentVO(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      phoneNumber: json['phone_number'] as String?,
      photoOrVideoUrlLink: json['photo_or_video_url_link'] as String?,
      profileUrl: json['profile_url'] as String?,
      timestamp: json['timestamp'] as String?,
      likedIdList: (json['liked_id_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bookmarkedIdList: (json['bookmarked_id_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MomentVOToJson(MomentVO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'phone_number': instance.phoneNumber,
      'photo_or_video_url_link': instance.photoOrVideoUrlLink,
      'profile_url': instance.profileUrl,
      'timestamp': instance.timestamp,
      'liked_id_list': instance.likedIdList,
      'bookmarked_id_list': instance.bookmarkedIdList,
    };

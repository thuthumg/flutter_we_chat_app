// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVO _$UserVOFromJson(Map<String, dynamic> json) => UserVO(
      id: json['id'] as String?,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profileUrl: json['profileUrl'] as String?,
      genderType: json['genderType'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      activeStatus: json['activeStatus'] as String?,
    );

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'email': instance.email,
      'password': instance.password,
      'phoneNumber': instance.phoneNumber,
      'profileUrl': instance.profileUrl,
      'genderType': instance.genderType,
      'dateOfBirth': instance.dateOfBirth,
      'activeStatus': instance.activeStatus,
    };

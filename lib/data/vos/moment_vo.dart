import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'moment_vo.g.dart';

@JsonSerializable()
class MomentVO {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "phone_number")
  String? phoneNumber;

  @JsonKey(name: "photo_or_video_url_link")
  String? photoOrVideoUrlLink;

  @JsonKey(name: "profile_url")
  String? profileUrl;

  @JsonKey(name: "timestamp")
  String? timestamp;

  @JsonKey(name: "liked_id_list")
  List<String>? likedIdList;


  @JsonKey(name: "isUserBookMarkFlag")
  bool isUserBookMarkFlag = false;

  MomentVO(
      {this.id,
      this.name,
      this.description,
      this.phoneNumber,
      this.photoOrVideoUrlLink,
      this.profileUrl,
      this.timestamp,
      this.likedIdList});


  @override
  String toString() {
    return 'MomentVO{id: $id, name: $name, description: $description, phoneNumber: $phoneNumber, photoOrVideoUrlLink: $photoOrVideoUrlLink, profileUrl: $profileUrl, timestamp: $timestamp, likedIdList: $likedIdList, isUserBookMarkFlag: $isUserBookMarkFlag}';
  }

  factory MomentVO.fromJson(Map<String, dynamic> json) =>
      _$MomentVOFromJson(json);

  Map<String, dynamic> toJson() => _$MomentVOToJson(this);
}

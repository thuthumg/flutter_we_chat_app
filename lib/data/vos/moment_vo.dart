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

  @JsonKey(name: "bookmarked_id_list")
  List<String>? bookmarkedIdList;

  MomentVO(
      {this.id,
      this.name,
      this.description,
      this.phoneNumber,
      this.photoOrVideoUrlLink,
      this.profileUrl,
      this.timestamp,
      this.likedIdList,
      this.bookmarkedIdList});

  factory MomentVO.fromJson(Map<String, dynamic> json) =>
      _$MomentVOFromJson(json);

  Map<String, dynamic> toJson() => _$MomentVOToJson(this);
}

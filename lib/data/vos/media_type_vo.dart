import 'package:json_annotation/json_annotation.dart';

part 'media_type_vo.g.dart';

@JsonSerializable()
class MediaTypeVO {

  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "file_url")
  String? fileUrl;

  @JsonKey(name: "file_type")
  String? fileType;

  MediaTypeVO({this.id, this.fileUrl, this.fileType});

  factory MediaTypeVO.fromJson(Map<String, dynamic> json) =>
      _$MediaTypeVOFromJson(json);

  Map<String, dynamic> toJson() => _$MediaTypeVOToJson(this);
}
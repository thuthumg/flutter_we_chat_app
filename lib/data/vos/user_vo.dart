import 'package:json_annotation/json_annotation.dart';

part 'user_vo.g.dart';

@JsonSerializable()
class UserVO{

  @JsonKey(name:"id")
  String? id;

  @JsonKey(name:"userName")
  String? userName;

  @JsonKey(name:"email")
  String? email;

  @JsonKey(name:"password")
  String? password;

  @JsonKey(name:"phoneNumber")
  String? phoneNumber;

  @JsonKey(name:"profileUrl")
  String? profileUrl;

  @JsonKey(name:"genderType")
  String? genderType; // female / male/ other

  @JsonKey(name:"dateOfBirth")
  String? dateOfBirth; // 1999-4-3

  @JsonKey(name:"activeStatus")
  String? activeStatus;


  bool? isSelected = false;




  UserVO({this.id, this.userName, this.email, this.password, this.phoneNumber,
    this.profileUrl, this.genderType, this.dateOfBirth, this.activeStatus,this.isSelected});

  factory UserVO.fromJson(Map<String, dynamic> json) =>
      _$UserVOFromJson(json);

  Map<String, dynamic> toJson() => _$UserVOToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

part 'otp_code_vo.g.dart';

@JsonSerializable()
class OTPCodeVO{

  @JsonKey(name:"code")
  String? code;


  OTPCodeVO({this.code});

  factory OTPCodeVO.fromJson(Map<String, dynamic> json) =>
      _$OTPCodeVOFromJson(json);

  Map<String, dynamic> toJson() => _$OTPCodeVOToJson(this);
}
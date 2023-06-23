import 'dart:io';

import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/data/vos/otp_code_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';

abstract class WeChatAppModel{
  Stream<List<OTPCodeVO>> getOtpCode();

  Stream<UserVO> getUserVOById(String userVOId);

  Stream<List<MomentVO>> getMomentVOByUserId(String userVOId);

  Future<void> addNewMoment(UserVO? userVO,String description,List<File> imageFile);

  Future<void> uploadImages(List<File> imagesOrVideos);

  Stream<List<MomentVO>> getMomentsList();

  Future<void> saveBookmark(UserVO userVO,MomentVO newMoment);


}
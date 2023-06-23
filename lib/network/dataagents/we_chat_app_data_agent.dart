import 'dart:io';

import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/data/vos/otp_code_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';

abstract class WeChatAppDataAgent{


  Future<String> uploadFileToFirebase(File image);
  Stream<UserVO> getUserVOById(String userVOId);

  ///Authentication
  Future registerNewUser(String email,String phoneNumber);
  Future signUpNewUser(UserVO newUser);
  Future login(String email,String password);

  ///get otp data
  Stream<List<OTPCodeVO>> getOtpCode();
  UserVO getLoggedInUser();


  ///Add New Moment
  Future<void> addNewMoment(MomentVO newMoment);
  Future<String> multiUploadFileToFirebase(List<File> image);
  Future<void> saveBookmark(UserVO userVO,MomentVO newMoment);


  ///Get New Moment
  Stream<List<MomentVO>> getMomentsList();
  Stream<List<MomentVO>> getMomentsListByUserId(String userVOId);


}
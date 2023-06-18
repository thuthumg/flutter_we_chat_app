import 'dart:io';

import 'package:we_chat_app/data/vos/otp_code_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';

abstract class WeChatAppDataAgent{


  Future<String> uploadFileToFirebase(File image);

  ///Authentication
  Future registerNewUser(String email,String phoneNumber);
  Future signUpNewUser(UserVO newUser);
  Future login(String email,String password);

  ///get otp data

  Stream<List<OTPCodeVO>> getOtpCode();
}
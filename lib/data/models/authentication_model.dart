import 'dart:io';

import 'package:we_chat_app/data/vos/user_vo.dart';

abstract class AuthenticationModel{

  Future<void> signup(
      String email,
      String userName,
      String password,
      String phoneNumber,
      File? profileUrl,
      String genderType,
      String dateOfBirth,
      String activeStatus);

  Future<void> registerNewUser(
      String email,
      String phoneNumber,
      );

  Future login(String email, String password);
  UserVO getLoggedInUser();
}
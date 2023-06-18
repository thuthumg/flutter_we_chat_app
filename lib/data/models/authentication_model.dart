import 'dart:io';

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

  Future<void> login(String email, String password);

}
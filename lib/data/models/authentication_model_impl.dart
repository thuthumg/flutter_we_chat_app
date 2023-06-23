import 'dart:io';

import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/network/dataagents/cloud_firestore_data_agent_impl.dart';
import 'package:we_chat_app/network/dataagents/we_chat_app_data_agent.dart';

class AuthenticationModelImpl extends AuthenticationModel{

  static final AuthenticationModelImpl _singleton = AuthenticationModelImpl._internal();

  factory AuthenticationModelImpl(){
    return _singleton;
  }

  AuthenticationModelImpl._internal();

  WeChatAppDataAgent mDataAgent = CloudFirestoreDataAgentImpl();

  @override
  Future<void> signup(String email,
      String userName,
      String password,
      String phoneNumber,
      File? profileUrl,
      String genderType,
      String dateOfBirth,
      String activeStatus) {
    if(profileUrl != null)
    {

      return mDataAgent.uploadFileToFirebase(profileUrl)
          .then((downloadUrl) =>
          craftUserVO(
              email, userName, password,
              phoneNumber, downloadUrl,
              genderType, dateOfBirth, activeStatus))
          .then((user) => mDataAgent.signUpNewUser(user));
    }else
    {
      return craftUserVO(
          email, userName, password,
          phoneNumber, "",
          genderType, dateOfBirth, activeStatus)
          .then((user) => mDataAgent.signUpNewUser(user));
    }

  }
  Future<UserVO> craftUserVO(
      String email,
      String userName,
      String password,
      String phoneNumber,
      String profileUrl,
      String genderType,
      String dateOfBirth,
      String activeStatus){
    var newUser =UserVO(
        id : "",
        userName:userName,
        email:email,
        password:password,
        phoneNumber:phoneNumber,
        profileUrl:profileUrl,
        genderType:genderType,
        dateOfBirth:dateOfBirth,
        activeStatus:activeStatus);
    return Future.value(newUser);
  }

  @override
  Future<void> registerNewUser(String email, String phoneNumber) {
  return  mDataAgent.registerNewUser(
        email,
        phoneNumber);
  }

  @override
  Future login(String email, String password) {
    return mDataAgent.login(email, password);
  }

  @override
  UserVO getLoggedInUser() {
    return mDataAgent.getLoggedInUser();
  }



}
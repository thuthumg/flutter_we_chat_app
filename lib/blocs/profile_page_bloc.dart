import 'dart:io';

import 'package:flutter/material.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/data/vos/otp_code_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/utils/constants.dart';

class ProfilePageBloc extends ChangeNotifier{


  final WeChatAppModel _mWeChatAppModel = WeChatAppModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  ///State
  bool isTextFieldError = false;
  bool isDisposed = false;
  bool isLoading = false;
  String userId = "";
  String phoneNum = "";

  String name = "";
  String dateOfBirth = "";
  String selectedDay= "";
  String selectedMonth = "";
  String selectedYear = "";

  String genderType = "";
  String password = "";
  String profilePicture = "";

  List<MomentVO> mMomentsList=[];
  UserVO? mUserVO;


  ///Image
  File? chosenImageFile;

  ProfilePageBloc(UserVO? userVO){

    mUserVO = userVO;


    _mWeChatAppModel.getMomentVOByUserId(
        _authenticationModel.getLoggedInUser().id ?? "")
        .listen((momentList) {

      mMomentsList = momentList;
      debugPrint("check otp list in bloc ${mMomentsList.length}");

      _hideLoading();
      _notifySafely();
    });


    userId = userVO?.id ?? "";
    phoneNum = userVO?.phoneNumber ?? "";
    name = userVO?.userName??"";
    dateOfBirth = userVO?.dateOfBirth??"";
    selectedDay= ((userVO?.dateOfBirth??"").split('-').isNotEmpty)?
    (userVO?.dateOfBirth??"").split('-')[2] : "";
    selectedMonth = ((userVO?.dateOfBirth??"").split('-').isNotEmpty)?
    (userVO?.dateOfBirth??"").split('-')[1] : "";
    selectedYear = ((userVO?.dateOfBirth??"").split('-').isNotEmpty)?
    (userVO?.dateOfBirth??"").split('-')[0] : "";

    genderType =  userVO?.genderType??"";
    password =  userVO?.password??"";
    profilePicture =  userVO?.profileUrl??"";



  }
  void onImageChosen(File imageFile){
    chosenImageFile = imageFile;
    _notifySafely();
  }
  void saveBookMark(UserVO mUserVO,MomentVO mMomentVO){
    _showLoading();
    _mWeChatAppModel.saveBookmark(mUserVO, mMomentVO).then((value){
      isLoading = false;
      _hideLoading();
      _notifySafely();
    });
  }

  void _showLoading(){
    debugPrint("check isLoading before flag $isLoading");
    isLoading = true;
    debugPrint("check isLoading after flag $isLoading");
    _notifySafely();
  }

  void _hideLoading(){
    isLoading = false;
    _notifySafely();
  }
  void _notifySafely(){
    if(!isDisposed){
      notifyListeners();
    }
  }
  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

}
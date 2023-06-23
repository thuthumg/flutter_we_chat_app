import 'dart:io';

import 'package:flutter/material.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/otp_code_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/utils/constants.dart';

class EditProfileBloc extends ChangeNotifier{


  final WeChatAppModel _mWeChatAppModel = WeChatAppModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  ///State
  bool isTextFieldError = false;
  bool isDisposed = false;
  bool isLoading = false;
  String userId = "";
  String phoneNum = "";
  String email = "";
  String name = "";
  String dateOfBirth = "";
  String selectedDay= "";
  String selectedMonth = "";
  String selectedYear = "";

  String genderType = "";
  String password = "";
  String profilePicture = "";

  ///Image
  File? chosenImageFile;

  EditProfileBloc(UserVO? userVO){
    userId = userVO?.id ?? "";
    email = userVO?.email ?? "";
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

  void onNameChanged(String name){
    this.name = name;
    _notifySafely();
  }
  void onPhoneNumChanged(String phoneNum){
    this.phoneNum = phoneNum;
    _notifySafely();
  }
  void onPasswordChanged(String password){
    this.password = password;
    _notifySafely();
  }
  void onDayChanged(String selectedDay){
    this.selectedDay = selectedDay;
    _notifySafely();
  }
  void onMonthChanged(String selectedMonth){
    this.selectedMonth = selectedMonth;
    _notifySafely();
  }
  void onYearChanged(String selectedYear){
    this.selectedYear = selectedYear;
    _notifySafely();
  }
  void onGenderTypeChanged(String genderType){
    this.genderType = genderType;
    _notifySafely();
  }

  Future onTapSignUp(String phoneNum,String email){
    _showLoading();

    if(name.isEmpty)
    {
      _hideLoading();
      isTextFieldError = true;
      _notifySafely();
      return Future.error("Error");

    }
    else if(selectedDay.isEmpty && selectedMonth.isEmpty && selectedYear.isEmpty){
      _hideLoading();
      isTextFieldError = true;
      _notifySafely();
      return Future.error("Error");

    }
    else if(genderType.isEmpty){
      _hideLoading();
      isTextFieldError = true;
      _notifySafely();
      return Future.error("Error");

    }
    else if(password.isEmpty){
      _hideLoading();
      isTextFieldError = true;
      _notifySafely();
      return Future.error("Error");

    }else{

      dateOfBirth = '$selectedYear-${changeMonthType(selectedMonth)}-$selectedDay';
      return _authenticationModel.signup(
          email,
          name,
          password,
          phoneNum,
          chosenImageFile,
          genderType,
          dateOfBirth,
          '0').whenComplete(()=>_hideLoading());

    }

  }
  String changeMonthType(String month){
    if (selectedMonth == monthsList[0]) {
      return month = '1';
    }
    if (selectedMonth == monthsList[1]) {
      return month = '2';
    }
    if (selectedMonth == monthsList[2]) {
      return  month = '3';
    }
    if (selectedMonth == monthsList[3]) {
      return  month = '4';
    }
    if (selectedMonth == monthsList[4]) {
      return  month = '5';
    }
    if (selectedMonth == monthsList[5]) {
      return  month = '6';
    }
    if (selectedMonth == monthsList[6]) {
      return  month = '7';
    }
    if (selectedMonth == monthsList[7]) {
      return  month = '8';
    }
    if (selectedMonth == monthsList[8]) {
      return  month = '9';
    }
    if (selectedMonth == monthsList[9]) {
      return  month = '10';
    }
    if (selectedMonth == monthsList[10]) {
      return  month = '11';
    }
    if (selectedMonth == monthsList[11]) {
      return  month = '12';
    }else {
      return month ='';
    }
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
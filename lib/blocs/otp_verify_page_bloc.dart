import 'package:flutter/material.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/otp_code_vo.dart';

class OtpVerifyPageBloc extends ChangeNotifier{

  List<OTPCodeVO> otpCodeVOs =[];
  final WeChatAppModel _mWeChatAppModel = WeChatAppModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  ///State
  bool isDisposed = false;
  bool isLoading = false;
  String email = "";
  String phoneNumber = "";
  String pinCodeText = "";

  OtpVerifyPageBloc(){

    _mWeChatAppModel.getOtpCode().listen((otpCodeList) {

      otpCodeVOs = otpCodeList;
      debugPrint("check otp list in bloc ${otpCodeVOs.toString()}");
      _notifySafely();
    });

  }

  void onPinCodeText(String pinCode){
    this.pinCodeText = pinCode;
  }
  void onEmailChanged(String email){
    this.email = email;
  }
  void onUserPhoneNumberChanged(String phoneNumber){
    this.phoneNumber = phoneNumber;
  }
  bool isMobileNumberValid(String phoneNumber) {
    String regexPattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    var regExp = new RegExp(regexPattern);

    if (phoneNumber.isEmpty) {
      return false;
    } else if (regExp.hasMatch(phoneNumber)) {
      return true;
    }
    return false;
  }
  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (regex.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }
  Future onTapVerify(){
    _showLoading();
    OTPCodeVO searchOTP = OTPCodeVO(code: pinCodeText);
    if(email.isEmpty)
      {
        _hideLoading();
        return Future.error("Please Enter Your Email");

      }
    else if (!validateEmail(email))
      {
        _hideLoading();
        return Future.error("Please enter valid email.");
      }
    else if(phoneNumber.isEmpty){
      _hideLoading();
      return Future.error("Please Enter Your Phone Number");
    }else if(!isMobileNumberValid(phoneNumber)){
      _hideLoading();
      return Future.error("Please enter valid mobile number");
    }else{
      int index = otpCodeVOs.indexWhere(
              (otpVO) => otpVO.code == searchOTP.code);

      if (index != -1) {
        print('The list contains the otp code');
        return _authenticationModel.registerNewUser(
            email,
            phoneNumber).whenComplete(()=>_hideLoading());
      } else {
        print('The list does not contain the otp code');
        _hideLoading();
        return Future.error("Your OTP code is wrong.");
      }
    }




    //
    // if(otpCodeVOs.contains(searchOTP))
    //   {
    //     return _authenticationModel.registerNewUser(
    //         email,
    //         phoneNumber).whenComplete(()=>_hideLoading());
    //   }
    //   else{
    //   return Future.error("Error");
    // }

    // return _authenticationModel.registerNewUser(
    //     email,
    //     phoneNumber).whenComplete(()=>_hideLoading());
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
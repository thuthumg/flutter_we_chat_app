import 'package:flutter/material.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/otp_code_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';

class HomePageBloc extends ChangeNotifier{

  UserVO? userVO;
  final WeChatAppModel _mWeChatAppModel = WeChatAppModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  ///State
  bool isDisposed = false;
  bool isLoading = false;


  HomePageBloc(){

    _mWeChatAppModel.getUserVOById(
        _authenticationModel.getLoggedInUser().id ?? "")
        .listen((userObj) {

      userVO = userObj;
     // debugPrint("check otp list in bloc ${userVO.toString()}");
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
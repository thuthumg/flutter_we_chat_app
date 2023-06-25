import 'package:flutter/material.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';

class MomentsPageBloc extends ChangeNotifier{

  List<MomentVO>? mMomentsList;

  final WeChatAppModel _mWeChatAppModel = WeChatAppModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  bool isDisposed = false;
  bool isLoading = false;
  UserVO? userVO;


  MomentsPageBloc(){
    _showLoading();
    _mWeChatAppModel.getUserVOById(
        _authenticationModel.getLoggedInUser().id ?? "")
        .listen((userObj) {
      userVO = userObj;
      debugPrint("check otp list in bloc ${userVO?.userName}");
      _mWeChatAppModel.getMomentsList().listen((momentsList) {
        mMomentsList = momentsList;
        mMomentsList?.sort((a, b) => (b.id??"").compareTo(a.id??""));
        _hideLoading();
        _notifySafely();
      });

      _notifySafely();
    });


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
    isLoading = true;
    _notifySafely();
  }

  void _hideLoading(){
    isLoading = false;
    _notifySafely();
  }
  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

}
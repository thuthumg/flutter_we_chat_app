import 'package:flutter/material.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:async/async.dart';
class MomentsPageBloc extends ChangeNotifier{

  List<MomentVO>? mMomentsList;
  List<MomentVO>? mBookMarksList;
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
      getAllMomentsList();
     // getBookMarksMomentsList();
     // setBookMarksToShowHome();
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
  void getAllMomentsList(){
    _mWeChatAppModel.getMomentsList().listen((momentsList) {
      mMomentsList = momentsList;
      mMomentsList?.sort((a, b) => (b.id??"").compareTo(a.id??""));
      getBookMarksMomentsList();
      _hideLoading();
      _notifySafely();
    });


  }
  void getBookMarksMomentsList(){

  _mWeChatAppModel.getMomentVOByUserId(
        _authenticationModel.getLoggedInUser().id ?? "")
        .listen((momentList) {
      mBookMarksList = momentList;
      debugPrint("check otp list in bloc ${mBookMarksList?.length}");
      setBookMarksToShowHome(mMomentsList??[],mBookMarksList??[]).listen((event) {
        mMomentsList = event;
        _notifySafely();
      });
      _hideLoading();
      _notifySafely();
    });

  }
  Stream<List<MomentVO>> setBookMarksToShowHome(List<MomentVO> momentsList, List<MomentVO> bookMarksList) {
    Stream<List<MomentVO>> momentsStream = Stream.fromIterable([momentsList]);
    Stream<List<MomentVO>> bookmarksStream = Stream.fromIterable([bookMarksList]);

    StreamZip<List<MomentVO>> zippedStream = StreamZip<List<MomentVO>>([momentsStream, bookmarksStream]);

    Stream<List<MomentVO>> combinedStream = zippedStream.map((combinedList) {
      List<MomentVO> allMomentsList = combinedList[0];
      List<MomentVO> userBookMarksList = combinedList[1];

      debugPrint(
          "check all Moments  -----"
              " ${userBookMarksList.toList().toString()}"
      );

      return allMomentsList.map((momentObj) {
        debugPrint(
            "check  Moment ${momentObj.name} ${momentObj.isUserBookMarkFlag} ${userBookMarksList.contains(momentObj)}"
        );

        if(userBookMarksList.contains(momentObj))
          {
            momentObj.isUserBookMarkFlag = true;
          }
        else{
          momentObj.isUserBookMarkFlag = false;
        }



        debugPrint(
            "check  Moment 2 ${momentObj.name} ${momentObj.isUserBookMarkFlag} "
        );
        _notifySafely();
        return momentObj;
      }).toList();
    });
    _notifySafely();
    return combinedStream;
  }

}
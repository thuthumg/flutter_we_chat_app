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
  List<MomentVO>? mFavouriteList;
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
      getFavouritesMomentsAndBookMarkedList();
     // setBookMarksToShowHome();
      _notifySafely();
    });


  }

  void saveBookMark(UserVO mUserVO,MomentVO mMomentVO){
    _showLoading();
    _mWeChatAppModel.saveBookmark(mUserVO, mMomentVO).then((value){
     // getBookMarksMomentsList();
      getFavouritesMomentsAndBookMarkedList();
      isLoading = false;
      _hideLoading();
      _notifySafely();
    });
  }


  void saveFavourite(UserVO mUserVO,MomentVO mMomentVO){
    _showLoading();
    _mWeChatAppModel.saveFavourite(mUserVO, mMomentVO).then((value){
      getFavouritesMomentsAndBookMarkedList();
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
     // getBookMarksMomentsList();???
      _hideLoading();
      _notifySafely();
    });


  }
  // void getBookMarksMomentsList(){
  //
  // _mWeChatAppModel.getMomentVOByUserId(
  //       _authenticationModel.getLoggedInUser().id ?? "")
  //       .listen((momentList) {
  //     mBookMarksList = momentList;
  //     debugPrint("check bookmark list in bloc ${mBookMarksList?.length}");
  //     setBookMarksToShowHome(mMomentsList??[],mBookMarksList??[]).listen((event) {
  //       mMomentsList = event;
  //       _notifySafely();
  //     });
  //     _hideLoading();
  //     _notifySafely();
  //   });
  //
  // }
  // Stream<List<MomentVO>> setBookMarksToShowHome(
  //     List<MomentVO> momentsList, List<MomentVO> bookMarksList) {
  //   Stream<List<MomentVO>> momentsStream = Stream.fromIterable([momentsList]);
  //   Stream<List<MomentVO>> bookmarksStream = Stream.fromIterable([bookMarksList]);
  //
  //   StreamZip<List<MomentVO>> zippedStream = StreamZip<List<MomentVO>>([momentsStream, bookmarksStream]);
  //
  //   Stream<List<MomentVO>> combinedStream = zippedStream.map((combinedList) {
  //     List<MomentVO> allMomentsList = combinedList[0];
  //     List<MomentVO> userBookMarksList = combinedList[1];
  //
  //     debugPrint(
  //         "check all Moments  -----"
  //             " ${allMomentsList.toList().toString()}"
  //     );
  //
  //     debugPrint(
  //         "check userBookMarksList   -----"
  //             " ${userBookMarksList.toList().toString()}"
  //     );
  //
  //     return allMomentsList.map((momentObj) {
  //       debugPrint(
  //           "check  Moment ${momentObj.name} ${momentObj.isUserBookMarkFlag} ${userBookMarksList.contains(momentObj)}"
  //       );
  //
  //         if(userBookMarksList.contains(momentObj))
  //         {
  //           momentObj.isUserBookMarkFlag = true;
  //         }
  //       else{
  //         momentObj.isUserBookMarkFlag = false;
  //       }
  //
  //
  //
  //       debugPrint(
  //           "check  Moment 2 ${momentObj.name} ${momentObj.isUserBookMarkFlag} \n "
  //       );
  //       _notifySafely();
  //       return momentObj;
  //     }).toList();
  //   });
  //   _notifySafely();
  //   return combinedStream;
  // }

  void getFavouritesMomentsAndBookMarkedList(){

    _mWeChatAppModel.getMomentVOByUserId(
        _authenticationModel.getLoggedInUser().id ?? "")
        .listen((momentList) {
      mBookMarksList = momentList;
      debugPrint("check bookmark list in bloc ${mBookMarksList?.length}");

      _mWeChatAppModel.getMomentVOByUserIdForFavouriteMoment(
          _authenticationModel.getLoggedInUser().id ?? "")
          .listen((momentList1) {
        mFavouriteList = momentList1;
        debugPrint("check bookmark list in bloc ${mFavouriteList?.length}");
        setFavouritesAndBookMarkedToShowHome(mMomentsList??[],mFavouriteList??[],mBookMarksList??[]).listen((event) {
          mMomentsList = event;
          _notifySafely();
        });
        _hideLoading();
        _notifySafely();
      });

      // setBookMarksToShowHome(mMomentsList??[],mBookMarksList??[]).listen((event) {
      //   mMomentsList = event;
      //   _notifySafely();
      // });
      _hideLoading();
      _notifySafely();
    });




  }

  Stream<List<MomentVO>> setFavouritesAndBookMarkedToShowHome(
      List<MomentVO> momentsList,
      List<MomentVO> favouritesList,
      List<MomentVO> bookMarksList) {
    Stream<List<MomentVO>> momentsStream = Stream.fromIterable([momentsList]);
    Stream<List<MomentVO>> favouritesStream = Stream.fromIterable([favouritesList]);
    Stream<List<MomentVO>> bookMarksStream = Stream.fromIterable([bookMarksList]);

    StreamZip<List<MomentVO>> zippedStream = StreamZip<List<MomentVO>>([momentsStream, favouritesStream,bookMarksStream]);

    Stream<List<MomentVO>> combinedStream = zippedStream.map((combinedList) {
      List<MomentVO> allMomentsList = combinedList[0];
      List<MomentVO> userFavouritesList = combinedList[1];
      List<MomentVO> bookMarksList = combinedList[2];

      return allMomentsList.map((momentObj) {
        if(userFavouritesList.contains(momentObj))
        {
          momentObj.isUserFavouriteFlag = true;
        }
        else{
          momentObj.isUserFavouriteFlag = false;
        }

        if(bookMarksList.contains(momentObj))

          {
            momentObj.isUserBookMarkFlag = true;
          }else{
          momentObj.isUserBookMarkFlag = false;
        }
        _notifySafely();
        return momentObj;
      }).toList();
    });
    _notifySafely();
    return combinedStream;
  }

}
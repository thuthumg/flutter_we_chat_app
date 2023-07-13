import 'dart:io';

import 'package:flutter/material.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:async/async.dart';

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

  List<MomentVO>? mBookMarksList;
  List<MomentVO>? mFavouriteList;
  ///Image
  File? chosenImageFile;

  ProfilePageBloc(UserVO? userVO){

    mUserVO = userVO;


    _mWeChatAppModel.getMomentVOByUserId(
        _authenticationModel.getLoggedInUser().id ?? "")
        .listen((momentList) {

      mMomentsList = momentList;

    //  getBookMarksMomentsList();
      getFavouritesMomentsAndBookMarkedList();

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
      getFavouritesMomentsAndBookMarkedList();
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
  //   _mWeChatAppModel.getMomentVOByUserId(
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
  // Stream<List<MomentVO>> setBookMarksToShowHome(List<MomentVO> momentsList, List<MomentVO> bookMarksList) {
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
  //       if(userBookMarksList.contains(momentObj))
  //       {
  //         momentObj.isUserBookMarkFlag = true;
  //       }
  //       else{
  //         momentObj.isUserBookMarkFlag = false;
  //       }
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

  void saveFavourite(UserVO mUserVO,MomentVO mMomentVO){
    _showLoading();
    _mWeChatAppModel.saveFavourite(mUserVO, mMomentVO).then((value){
      getFavouritesMomentsAndBookMarkedList();
      isLoading = false;
      _hideLoading();
      _notifySafely();
    });
  }

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

      debugPrint(
          "check all Moments  -----"
              " ${allMomentsList.toList().toString()}"
      );

      debugPrint(
          "check userFavouritesList   -----"
              " ${userFavouritesList.toList().toString()}"
      );

      return allMomentsList.map((momentObj) {
        debugPrint(
            "check  Moment ${momentObj.name} ${momentObj.isUserFavouriteFlag} ${userFavouritesList.contains(momentObj)}"
        );

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



        debugPrint(
            "check  Moment 2 ${momentObj.name} ${momentObj.isUserFavouriteFlag} \n "
        );
        _notifySafely();
        return momentObj;
      }).toList();
    });
    _notifySafely();
    return combinedStream;
  }
}
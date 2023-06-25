import 'package:flutter/material.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';

class ContactsPageBloc extends ChangeNotifier {

  ///State
  bool isDisposed = false;
  bool isLoading = false;


  Color themeColor = Colors.black;

  UserVO? userVO;
  List<UserVO>? mContactsList;

  Map<String, List<UserVO>> userMap ={};


  ///Model
  final WeChatAppModel _mWeChatAppModel = WeChatAppModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();


  ContactsPageBloc() {
    _showLoading();
    _mWeChatAppModel.getUserVOById(
        _authenticationModel.getLoggedInUser().id ?? "")
        .listen((userObj) {

      userVO = userObj;
      debugPrint("check otp list in bloc ${userVO?.userName}");

      _hideLoading();
      _notifySafely();
    });


    _mWeChatAppModel
        .getContactList(_authenticationModel.getLoggedInUser().id ?? "")
        .listen((contactsList) {
      mContactsList = contactsList;
      userMap = contactsGroupList(mContactsList!);////???
      _notifySafely();
    });
  }
  Future saveQRScanUserVO(String loginUserVOId,String scanUserVOId){
    _showLoading();
   return _mWeChatAppModel.saveQRScanUserVO(loginUserVOId, scanUserVOId)
    .then((value) {
      isLoading = false;
      _hideLoading();
      _notifySafely();
    }).catchError((){
      _hideLoading();
      Future.value("Error");
      _notifySafely();
    });


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

  void _showLoading(){
    isLoading = true;
    _notifySafely();
  }

  void _hideLoading(){
    isLoading = false;
    _notifySafely();
  }
  Map<String, List<UserVO>> contactsGroupList(List<UserVO> contactsList) {
    Map<String, List<UserVO>> hashMap = {};

    for (UserVO userItem in contactsList) {
      String nameFirstCharacter = userItem.userName?.substring(0, 1) ?? '';

      if (hashMap.isEmpty) {
        List<UserVO> nameList = [userItem];
        hashMap[nameFirstCharacter] = nameList;
      } else {
        List<UserVO> customGroupList = [];

        if (hashMap[nameFirstCharacter]?.isEmpty ?? true) {
          customGroupList.add(userItem);
        } else {
          customGroupList = hashMap[nameFirstCharacter]!;
          customGroupList.add(userItem);
        }

        if (customGroupList.isNotEmpty) {
          hashMap[nameFirstCharacter] = customGroupList;
        }
      }
    }

    print('LogData: $hashMap');
    return hashMap;
  }

}
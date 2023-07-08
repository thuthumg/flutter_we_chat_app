import 'dart:io';

import 'package:flutter/material.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/chat_group_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';

class ContactsPageBloc extends ChangeNotifier {

  ///State
  bool isDisposed = false;
  bool isLoading = false;


  UserVO? userVO;
  List<UserVO>? mContactsList;

  List<ChatGroupVO>? mGroupContactsList = [ChatGroupVO(
      id: "",
      name: "",
      message: {},
      membersList: [],
      profileUrl: "")];
  Map<String, List<UserVO>> userMap ={};
  // Map<String, List<UserVO>> filteredMap={};
  // List<ChatGroupVO>? filterGroupContactsList = [ChatGroupVO(
  //     id: "",
  //     name: "",
  //     message: {},
  //     membersList: [],
  //     profileUrl: "")];


  List<UserVO?> selectedContactList = [];
  String groupName="";

  ///Image
  File? chosenImageFile;

  ///Model
  final WeChatAppModel _mWeChatAppModel = WeChatAppModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();


  ContactsPageBloc() {
    _showLoading();
    formLoadData();



  }

  void formLoadData() {
    _mWeChatAppModel.getUserVOById(
        _authenticationModel.getLoggedInUser().id ?? "")
        .listen((userObj) {
      userVO = userObj;
      debugPrint("check otp list in bloc ${userVO?.userName}");

      getContactsList(userVO);

      debugPrint("before group contact list");
      getGroupsList(userVO);


      _hideLoading();
      _notifySafely();
    });
  }

  void getGroupsList(UserVO? userVO) {
    _mWeChatAppModel
        .getChatGroupsList(userVO?.id ?? "")
        .listen((groupContactsList) {
      debugPrint("group contact list ${groupContactsList}");

      if(groupContactsList.isNotEmpty)
        {
          mGroupContactsList = [ChatGroupVO(
              id: "",
              name: "",
              message: {},
              membersList: [],
              profileUrl: "")];
          mGroupContactsList?.addAll(groupContactsList);
        }
      mGroupContactsList?.reversed;
      _notifySafely();
    });
  }

  void getContactsList(UserVO? userVO) {
    _mWeChatAppModel
        .getContactList(userVO?.id ?? "")
        .listen((contactsList) {

      // if(selectedContactList.isNotEmpty)
      // {
      //   selectedContactList.forEach((element) {
      //     if(contactsList.contains(element))
      //     {
      //       int index = contactsList.indexOf(element!);
      //      // var
      //      contactsList[index].isSelected = element.isSelected;
      //       contactsList[index] = (contactsList[index]);
      //
      //     }
      //     });
      // }

      mContactsList = contactsList;
      userMap = contactsGroupList(mContactsList!);////???
      _notifySafely();
    });
  }

  void onImageChosen(File imageFile){
    chosenImageFile = imageFile;
    _notifySafely();
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

  void onTapContactSelected(UserVO? selectedContactVO) {
   // this.selectedContact = selectedContact;
   // debugPrint("onTapcontact 2 $selectedContact");

    if(mContactsList!.contains(selectedContactVO))
    {
      int index = mContactsList!.indexOf(selectedContactVO!);

      mContactsList?[index] = (selectedContactVO);

    }

    userMap = contactsGroupList(mContactsList!);////???
    selectedContactList = mContactsList!.where((userVO) => userVO.isSelected == true).cast<UserVO?>().toList();


    _notifySafely();


  }



  void groupNameTextChanged(String groupName) {
    this.groupName = groupName;
  }


  void createChatGroup(){
    _showLoading();
    List<String> membersList = [];
    selectedContactList.add(userVO);
    selectedContactList.forEach((element) {
      membersList.add(element?.id.toString()??"");
      debugPrint("createChat group ${membersList.length}");
    });
    _mWeChatAppModel.createChatGroup(groupName, membersList, chosenImageFile??File("")).then((value)
    {_hideLoading();_notifySafely();});
  }

  void searchContacts(String searchQuery,String pageType) {
   // formLoadData();
    print("check search text  = ${searchQuery}");

    if(pageType == "createGroup")
      {
        if(searchQuery.isNotEmpty)
        {

          userMap = userMap.entries
              .where((entry) => entry.value.any((user) =>  user.userName?.toLowerCase().contains(searchQuery.toLowerCase())??false))
              .fold<Map<String, List<UserVO>>>({}, (map, entry) {
            map[entry.key] = entry.value;
            return map;
          });
          _notifySafely();
        }else{
          // print("check search text empty");
          formLoadData();
           _notifySafely();
        }
      }
    else{

      if(searchQuery.isNotEmpty)
      {
        // formLoadData();
        userMap = userMap.entries
            .where((entry) => entry.value.any((user) =>  user.userName?.toLowerCase().contains(searchQuery.toLowerCase())??false))
            .fold<Map<String, List<UserVO>>>({}, (map, entry) {
          map[entry.key] = entry.value;
          return map;
        });

        // userMap = filteredMap;

        List<ChatGroupVO>  groupContactsList = mGroupContactsList?.where(
                (group) => group.name?.toLowerCase().contains(searchQuery.toLowerCase())??false).toList()??[];

        if(groupContactsList.isNotEmpty)
        {
          mGroupContactsList = [ChatGroupVO(
              id: "",
              name: "",
              message: {},
              membersList: [],
              profileUrl: "")];
          mGroupContactsList?.addAll(groupContactsList);
        }
        mGroupContactsList?.reversed;

        //print("check search text not empty 2 = ${filteredMap}");
        _notifySafely();
      }else{
        // print("check search text empty");
        formLoadData();
        // filteredMap = {};
        // filterGroupContactsList = [];
        // print("check search text empty 2 = ${filterGroupContactsList}");
        mGroupContactsList = mGroupContactsList;
        _notifySafely();
      }
    }





  }

}
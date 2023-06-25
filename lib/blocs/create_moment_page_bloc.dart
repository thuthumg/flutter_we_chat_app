import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';

class CreateMomentPageBloc extends ChangeNotifier {

  ///State
  String newMomentDescription = "";
  bool isAddNewMomentError = false;
  bool isDisposed = false;
  bool isLoading = false;

  List<dynamic> selectedImages = [
    'assets/moments/add_choose_img_or_video_pic.png'
  ]; // List to store selected images



  String userName = "";
  String profilePicture = "";
  MomentVO? mNewMoment;
  UserVO? _loggedInUser;


  UserVO? userVO;

  ///Model
  final WeChatAppModel _mWeChatAppModel = WeChatAppModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  VideoPlayerController? _videoController;
  VideoPlayerController? get videoController => _videoController;

  CreateMomentPageBloc() {
    _showLoading();
    _mWeChatAppModel.getUserVOById(
        _authenticationModel.getLoggedInUser().id ?? "")
        .listen((userObj) {

      userVO = userObj;
      debugPrint("check otp list in bloc ${userVO?.userName}");
      _prepopulateDataForAddNewMoment(userVO);
      _hideLoading();
      _notifySafely();
    });



  }

  void onNewMomentTextChanged(String newMomentDescription) {
    this.newMomentDescription = newMomentDescription;
  }

  Future onTapAddNewMoment() {
    _showLoading();
    if ((newMomentDescription.isEmpty && selectedImages.length == 1) ||   selectedImages.isEmpty ) {
     _hideLoading();
      isAddNewMomentError = true;
      _notifySafely();
      return Future.error("Error");
    } else {
      isLoading = true;
      isAddNewMomentError = false;
      _notifySafely();
        return _createNewMoment().then((value){
          isLoading = false;
          _hideLoading();
          _notifySafely();
        });

    }
  }

  Future<void> _createNewMoment(){
    List<File> uploadImagesStr =[];
    for (int i = 0; i < selectedImages.length; i++) {
      print("Element at index $i: ${selectedImages[i]}");
      if(i>0)
        {
          uploadImagesStr.add(selectedImages[i]);
        }

    }

    return _mWeChatAppModel.addNewMoment(userVO,newMomentDescription,uploadImagesStr);
  }
  @override
  void dispose() async{
    super.dispose();
    await _videoController?.dispose();
    isDisposed = true;

  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  void _prepopulateDataForAddNewMoment(UserVO? userVO) {
    userName = userVO?.userName ?? "";
    profilePicture = userVO?.profileUrl??"";
    _notifySafely();
  }

  void onImageChosen(List<dynamic> imageFiles){
    _showLoading();
   // chosenImageFile = imageFile;
    imageFiles.forEach((element) {
      selectedImages.add(File(element));
    });

    //_selectedImages = imageFiles;
   // List<dynamic> uploadImagesOrVideosData = selectedImages;
   // uploadImagesOrVideosData.removeAt(0);
   // _mWeChatAppModel.uploadImages(uploadImagesOrVideosData.map((dynamic item) => File(item.path)).toList());
    _hideLoading();
    _notifySafely();

  }

  void onTapDeleteImage(){
   // chosenImageFile = null;
    _notifySafely();
  }
  void _showLoading(){
    isLoading = true;
    _notifySafely();
  }

  void _hideLoading(){
    isLoading = false;
    _notifySafely();
  }


  Future<void> initVideo(String path) async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(File(path));
    await _videoController!.initialize();
    notifyListeners();
  }

  Future<void> play() async {
    await _videoController!.play();
    notifyListeners();
  }

  Future<void> pause() async {
    await _videoController!.pause();
    notifyListeners();
  }
}
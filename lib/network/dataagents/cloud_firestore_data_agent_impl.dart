import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/data/vos/otp_code_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/network/dataagents/we_chat_app_data_agent.dart';


const sampleOTPCollection = "sampleotpcode";
const usersCollection = "users";
const bookMarkedListCollection = "bookMarkedList";
const fileUploadRef = "uploads";
const momentsCollection = "moments";
const contactsCollection = "contacts";

class CloudFirestoreDataAgentImpl extends WeChatAppDataAgent{

  ///Database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ///storage
  var firebaseStorage = FirebaseStorage.instance;

  ///Authentication
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future signUpNewUser(UserVO newUser) {
  // return

     newUser.id = auth.currentUser?.uid ?? "";
     auth.currentUser?.updateDisplayName(newUser.userName);
     auth.currentUser?.updatePassword(newUser.password??"");
   return  _addNewUser(newUser,null);

   //   auth.createUserWithEmailAndPassword(
   //     email: newUser.email ?? "",
   //     password: newUser.password ?? "")
   //     .then((credential) {
   //   credential.user?.updateDisplayName(newUser.userName);
   //   return credential.user?..updatePhotoURL(newUser.profileUrl);
   //
   // }).then((user) {
   //   newUser.id = user?.uid ?? "";
   //   _addNewUser(newUser);
   // });
  }
  Future<void> _addNewUser(UserVO newUser,MomentVO? momentVO) async{


    final CollectionReference parentCollection = _firestore.collection(usersCollection);
    final DocumentReference parentDocument = parentCollection.doc(newUser.id.toString());
    await parentDocument.set(newUser.toJson());
    final CollectionReference subCollection = parentDocument.collection(bookMarkedListCollection);

    if (momentVO != null) {
      final DocumentReference newDocument = subCollection.doc(momentVO.id);
      await newDocument.set(momentVO.toJson());
    }
   // final DocumentReference newDocument = subCollection.doc(momentVO?.id);
  //  await newDocument.set(momentVO?.toJson());



      // _firestore
      //   .collection(usersCollection)
      //   .doc(newUser.id.toString())
      //   .set(newUser.toJson());
  }

  @override
  Future<String> uploadFileToFirebase(File image) {
    return firebaseStorage
        .ref(fileUploadRef)
        .child("${DateTime.now().millisecondsSinceEpoch}")
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
  }

  @override
  Stream<List<OTPCodeVO>> getOtpCode() {
    return _firestore
        .collection(sampleOTPCollection)
        .snapshots()
        .map((querySnapShot) {

          debugPrint("check otp list ${querySnapShot.docs.toList()}");

            return querySnapShot.docs.map<OTPCodeVO>((document) {

              debugPrint("check otp list document ${document.data().toString()}");

              return OTPCodeVO.fromJson(document.data());
            }).toList();
          });
  }

  @override
  Future registerNewUser(String email,String phoneNumber) {
   return auth.createUserWithEmailAndPassword(
        email: email ?? "",
        password: "123456");
     //    .then((credential) {
     //  return credential.user?.updateDisplayName(newUser.userName);
     // });
  }

  @override
  Future login(String email, String password) {
   return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Stream<UserVO> getUserVOById(String userVOId) {
   return _firestore
       .collection(usersCollection)
       .doc(userVOId.toString())
       .get()
       .asStream()
       .where((documentSnapShot) => documentSnapShot.data() != null)
       .map((documentSnapShot) => UserVO.fromJson(documentSnapShot.data()!));
  }

  @override
  UserVO getLoggedInUser() {

    return UserVO(
        id: auth.currentUser?.uid,
        email: auth.currentUser?.email,
        userName: auth.currentUser?.displayName,
        profileUrl: auth.currentUser?.photoURL,
    );
  }

  @override
  Future<void> addNewMoment(MomentVO newMoment) {
    return _firestore
        .collection(momentsCollection)
        .doc(newMoment.id.toString())
        .set(newMoment.toJson());
  }
  @override
  Future<String> multiUploadFileToFirebase(List<File> imagesOrVideos) async {
    List<String> strImagesOrVideos = [];

    for (var element in imagesOrVideos) {
      var taskSnapshot = await firebaseStorage
          .ref(fileUploadRef)
          .child("${DateTime.now().millisecondsSinceEpoch}")
          .putFile(element);

      var downloadURL = await taskSnapshot.ref.getDownloadURL();
      strImagesOrVideos.add(downloadURL);
    }

    return strImagesOrVideos.join(",");
  }
  // @override
  // Future<String> multiUploadFileToFirebase(List<File> imagesOrVideos) {
  //   List<String> strImagesOrVideos = [];
  //   imagesOrVideos.forEach((element) async {
  //     strImagesOrVideos.add(await firebaseStorage
  //         .ref(fileUploadRef)
  //         .child("${DateTime.now().microsecondsSinceEpoch}")
  //         .putFile(element)
  //         .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL()));
  //   });
  //
  //   return Future.value(strImagesOrVideos.join(","));
  //
  // }

  @override
  Stream<List<MomentVO>> getMomentsList() {
    return _firestore
        .collection(momentsCollection)
        .snapshots()
        .map((querySnapShot) {
      return querySnapShot.docs.map<MomentVO>((document){
        return MomentVO.fromJson(document.data());
      }).toList();
    });
  }

  @override
  Stream<List<MomentVO>> getMomentsListByUserId(String userVOId) {

    final CollectionReference parentCollection = _firestore.collection(usersCollection);
    final DocumentReference parentDocument = parentCollection.doc(userVOId);
    final CollectionReference subCollection = parentDocument.collection(bookMarkedListCollection);

    return subCollection.snapshots().map<List<MomentVO>>((querySnapshot) {
      return querySnapshot.docs.map<MomentVO>((document) {
        return MomentVO.fromJson(document.data() as Map<String, dynamic>);
      }).toList();
    }).handleError((error) {
      print("Error retrieving moments list: $error");
      return []; // Return an empty list in case of an error
    });


  }

  @override
  Future<void> saveBookmark(UserVO userVO,MomentVO newMoment) async{
      debugPrint("save book mark before condition ${newMoment.bookmarkedIdList}");
    if( newMoment.bookmarkedIdList == null ||  newMoment.bookmarkedIdList?.length == 0)
      {
        debugPrint("save book mark  condition1 list null ${userVO.phoneNumber.toString()} ");
        newMoment.bookmarkedIdList?.add(userVO.phoneNumber.toString());
        saveToMomentsCollection(newMoment);
        saveToUserCollection(userVO,newMoment);
      }else{
      debugPrint("save book mark  condition2 not null ");
      var bookmarkedList = newMoment.bookmarkedIdList;

      for (var bookmarkData in bookmarkedList!) {
        if(bookmarkData == userVO.phoneNumber.toString())
        {
          debugPrint("save book mark  condition3 same phone number");
          newMoment.bookmarkedIdList?.remove(bookmarkData);


        }else{
          debugPrint("save book mark condition4 not contain phone number");
          newMoment.bookmarkedIdList?.add(userVO.phoneNumber.toString());


        }
      }

      saveToMomentsCollection(newMoment);
      saveToUserCollection(userVO,newMoment);

    }


   
  }


  void saveToUserCollection(UserVO userVO, MomentVO newMoment) async{

    debugPrint("saveToUserCollection");

    final CollectionReference parentCollection = _firestore.collection(usersCollection);
    final DocumentReference parentDocument = parentCollection.doc(userVO.id.toString());
    await parentDocument.set(userVO.toJson());
    final CollectionReference subCollection = parentDocument.collection(bookMarkedListCollection);

    if (newMoment != null) {
      final DocumentReference newDocument = subCollection.doc(newMoment.id);
      await newDocument.set(newMoment.toJson());
    }

  }

  void saveToMomentsCollection(MomentVO newMoment) {

    debugPrint("saveToMomentsCollection ${newMoment.bookmarkedIdList?.length}");

    _firestore
        .collection(momentsCollection)
        .doc(newMoment.id.toString())
        .set(newMoment.toJson());
  }

  @override
  Future<void> saveQRScanUserVO(String loginUserVOId, String scanUserVOId) async {
        UserVO loginUserVO = await  getUserVOById(loginUserVOId).first;
        UserVO scanUserVO = await getUserVOById(scanUserVOId).first;

        final CollectionReference parentCollection = _firestore.collection(usersCollection);
        final DocumentReference parentDocument = parentCollection.doc(loginUserVO.id.toString());
       // await parentDocument.set(loginUserVO.toJson());
        final CollectionReference subCollection = parentDocument.collection(contactsCollection);
        final DocumentReference newDocument = subCollection.doc(scanUserVO.id);
        await newDocument.set(scanUserVO.toJson());

        final CollectionReference qr_generate_parentCollection = _firestore.collection(usersCollection);
        final DocumentReference qr_generate_parentDocument = qr_generate_parentCollection.doc(scanUserVO.id.toString());
        // await parentDocument.set(loginUserVO.toJson());
        final CollectionReference qr_generate_subCollection = qr_generate_parentDocument.collection(contactsCollection);
        final DocumentReference qr_generate_newDocument = qr_generate_subCollection.doc(loginUserVO.id);
        await qr_generate_newDocument.set(loginUserVO.toJson());

  }

  @override
  Stream<List<UserVO>> getContactList(String userVOId) {
    final CollectionReference parentCollection = _firestore.collection(usersCollection);
    final DocumentReference parentDocument = parentCollection.doc(userVOId);
    final CollectionReference subCollection = parentDocument.collection(contactsCollection);

    return subCollection.snapshots().map<List<UserVO>>((querySnapshot) {
      return querySnapshot.docs.map<UserVO>((document) {
        return UserVO.fromJson(document.data() as Map<String, dynamic>);
      }).toList();
    }).handleError((error) {
      print("Error retrieving moments list: $error");
      return []; // Return an empty list in case of an error
    });

  }


}

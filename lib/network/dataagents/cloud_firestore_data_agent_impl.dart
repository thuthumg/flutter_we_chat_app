import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/data/vos/otp_code_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/network/dataagents/we_chat_app_data_agent.dart';


const sampleOTPCollection = "sampleotpcode";
const usersCollection = "users";
const fileUploadRef = "uploads";

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
     auth.currentUser?.updatePassword(newUser.password??"");
   return  _addNewUser(newUser);

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
  Future<void> _addNewUser(UserVO newUser) {

    return _firestore
        .collection(usersCollection)
        .doc(newUser.id.toString())
        .set(newUser.toJson());
  }

  @override
  Future<String> uploadFileToFirebase(File image) {
    return firebaseStorage
        .ref(fileUploadRef)
        .child("${DateTime.now().microsecondsSinceEpoch}")
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
}
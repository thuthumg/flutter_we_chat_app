import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/data/vos/media_type_vo.dart';
import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/data/vos/otp_code_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/network/dataagents/we_chat_app_data_agent.dart';


const sampleOTPCollection = "sampleotpcode";
const usersCollection = "users";
const bookMarkedListCollection = "bookMarkedList";
const likedListCollection = "likedList";
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
  Future<List<MediaTypeVO>> multiUploadFileToFirebaseForChatMsg(List<File> imagesOrVideos) async {
    // List<String> strImagesOrVideos = [];

    List<MediaTypeVO> strImagesOrVideos = [];
    for (var index = 0; index < imagesOrVideos.length; index++) {
      var element = imagesOrVideos[index];
   // for (var element in imagesOrVideos) {
      var taskSnapshot = await firebaseStorage
          .ref(fileUploadRef)
          .child("${DateTime.now().millisecondsSinceEpoch}")
          .putFile(element);

      var downloadURL = await taskSnapshot.ref.getDownloadURL();
      var metaData = await taskSnapshot.ref.getMetadata();
      var contentType = metaData.contentType;
      strImagesOrVideos.add(MediaTypeVO(
        id: (index+1).toString(),
          fileType: contentType,
          fileUrl: downloadURL
      ));
    }
//strImagesOrVideos.join(",");
    return strImagesOrVideos;
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
     // var metaData = await taskSnapshot.ref.getMetadata();
     // var contentType = metaData.contentType;
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
  Stream<List<MomentVO>> getMomentVOByUserIdForFavouriteMoment(String userVOId) {

    final CollectionReference parentCollection = _firestore.collection(usersCollection);
    final DocumentReference parentDocument = parentCollection.doc(userVOId);
    final CollectionReference subCollection = parentDocument.collection(likedListCollection);

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
     // debugPrint("save book mark before condition ${newMoment.bookmarkedIdList}");
    // if( newMoment.bookmarkedIdList == null ||  newMoment.bookmarkedIdList?.length == 0)
    //   {
    //     debugPrint("save book mark  condition1 list null ${userVO.phoneNumber.toString()} ");
    //     newMoment.bookmarkedIdList?.add(userVO.phoneNumber.toString());
    //     saveToMomentsCollection(newMoment);
    //     saveToUserCollection(userVO,newMoment);
    //   }else{
    //   debugPrint("save book mark  condition2 not null ");
    //   var bookmarkedList = newMoment.bookmarkedIdList;
    //
    //   for (var bookmarkData in bookmarkedList!) {
    //     if(bookmarkData == userVO.phoneNumber.toString())
    //     {
    //       debugPrint("save book mark  condition3 same phone number");
    //       newMoment.bookmarkedIdList?.remove(bookmarkData);
    //
    //
    //     }else{
    //       debugPrint("save book mark condition4 not contain phone number");
    //       newMoment.bookmarkedIdList?.add(userVO.phoneNumber.toString());
    //
    //
    //     }
    //   }
    //
    //  // saveToMomentsCollection(newMoment);
    //   saveToUserCollection(userVO,newMoment);
    //
    // }

      saveToUserCollectionForBookMark(userVO,newMoment);
   
  }

  @override
  Future<void> saveFavourite(UserVO userVO,MomentVO newMoment) async{
    // debugPrint("save book mark before condition ${newMoment.bookmarkedIdList}");
    // if( newMoment.bookmarkedIdList == null ||  newMoment.bookmarkedIdList?.length == 0)
    //   {
    //     debugPrint("save book mark  condition1 list null ${userVO.phoneNumber.toString()} ");
    //     newMoment.bookmarkedIdList?.add(userVO.phoneNumber.toString());
    //     saveToMomentsCollection(newMoment);
    //     saveToUserCollection(userVO,newMoment);
    //   }else{
    //   debugPrint("save book mark  condition2 not null ");
    //   var bookmarkedList = newMoment.bookmarkedIdList;
    //
    //   for (var bookmarkData in bookmarkedList!) {
    //     if(bookmarkData == userVO.phoneNumber.toString())
    //     {
    //       debugPrint("save book mark  condition3 same phone number");
    //       newMoment.bookmarkedIdList?.remove(bookmarkData);
    //
    //
    //     }else{
    //       debugPrint("save book mark condition4 not contain phone number");
    //       newMoment.bookmarkedIdList?.add(userVO.phoneNumber.toString());
    //
    //
    //     }
    //   }
    //
    //  // saveToMomentsCollection(newMoment);
    //   saveToUserCollection(userVO,newMoment);
    //
    // }

    saveToUserCollectionForFavouriteMoment(userVO,newMoment);

  }

  void saveToUserCollectionForFavouriteMoment(UserVO userVO, MomentVO newMoment) async{

    _firestore.collection(usersCollection)
        .doc(userVO.id.toString())
        .collection(likedListCollection)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      List<MomentVO> momentObjects = [];
      querySnapshot.docs.forEach((doc) {
        MomentVO momentObject = MomentVO.fromJson(doc.data() as Map<String,dynamic>);
        momentObjects.add(momentObject);

      });
      // Do something with myObjects list
      if(momentObjects.length == 0)
      {
        print("add function");
        //add
        final CollectionReference parentCollection = _firestore.collection(usersCollection);
        final DocumentReference parentDocument = parentCollection.doc(userVO.id.toString());
        await parentDocument.set(userVO.toJson());
        final CollectionReference subCollection = parentDocument.collection(likedListCollection);

        if (newMoment != null) {
          // newMoment.isUserBookMarkFlag = !(newMoment.isUserBookMarkFlag??false);
          // print("cloud firestore ${newMoment.isUserBookMarkFlag}");
          final DocumentReference newDocument = subCollection.doc(newMoment.id);
          await newDocument.set(newMoment.toJson());
        }
      }else{


        if(momentObjects.contains(newMoment))

        {
          print("remove function");
          removeMomentVOFromFavouriteListCollection(userVO, newMoment);
        }else{

          print("add function");
          //add
          final CollectionReference parentCollection = _firestore.collection(usersCollection);
          final DocumentReference parentDocument = parentCollection.doc(userVO.id.toString());
          await parentDocument.set(userVO.toJson());
          final CollectionReference subCollection = parentDocument.collection(likedListCollection);

          if (newMoment != null) {
            // newMoment.isUserBookMarkFlag = !(newMoment.isUserBookMarkFlag??false);
            // print("cloud firestore ${newMoment.isUserBookMarkFlag}");
            final DocumentReference newDocument = subCollection.doc(newMoment.id);
            await newDocument.set(newMoment.toJson());
          }
        }


      }
    });

  }
  void saveToUserCollectionForBookMark(UserVO userVO, MomentVO newMoment) async{
    // //add
    // final CollectionReference parentCollection = _firestore.collection(usersCollection);
    // final DocumentReference parentDocument = parentCollection.doc(userVO.id.toString());
    // await parentDocument.set(userVO.toJson());
    // final CollectionReference subCollection = parentDocument.collection(bookMarkedListCollection);
    //
    // if (newMoment != null) {
    //   // newMoment.isUserBookMarkFlag = !(newMoment.isUserBookMarkFlag??false);
    //   // print("cloud firestore ${newMoment.isUserBookMarkFlag}");
    //   final DocumentReference newDocument = subCollection.doc(newMoment.id);
    //   await newDocument.set(newMoment.toJson());
    // }
    // debugPrint("saveToUserCollection" + newMoment.isUserBookMarkFlag.toString());


    _firestore.collection(usersCollection)
        .doc(userVO.id.toString())
        .collection(bookMarkedListCollection)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      List<MomentVO> momentObjects = [];
      querySnapshot.docs.forEach((doc) {
        MomentVO momentObject = MomentVO.fromJson(doc.data() as Map<String,dynamic>);
        momentObjects.add(momentObject);

      });
      // Do something with myObjects list
      if(momentObjects.length == 0)
      {
        print("add function");
        //add
        final CollectionReference parentCollection = _firestore.collection(usersCollection);
        final DocumentReference parentDocument = parentCollection.doc(userVO.id.toString());
        await parentDocument.set(userVO.toJson());
        final CollectionReference subCollection = parentDocument.collection(bookMarkedListCollection);

        if (newMoment != null) {
          // newMoment.isUserBookMarkFlag = !(newMoment.isUserBookMarkFlag??false);
          // print("cloud firestore ${newMoment.isUserBookMarkFlag}");
          final DocumentReference newDocument = subCollection.doc(newMoment.id);
          await newDocument.set(newMoment.toJson());
        }
      }else{


        if(momentObjects.contains(newMoment))

          {
            print("remove function");
            removeMomentVOFromBookMarkListCollection(userVO, newMoment);
          }else{

          print("add function");
          //add
          final CollectionReference parentCollection = _firestore.collection(usersCollection);
          final DocumentReference parentDocument = parentCollection.doc(userVO.id.toString());
          await parentDocument.set(userVO.toJson());
          final CollectionReference subCollection = parentDocument.collection(bookMarkedListCollection);

          if (newMoment != null) {
            // newMoment.isUserBookMarkFlag = !(newMoment.isUserBookMarkFlag??false);
            // print("cloud firestore ${newMoment.isUserBookMarkFlag}");
            final DocumentReference newDocument = subCollection.doc(newMoment.id);
            await newDocument.set(newMoment.toJson());
          }
        }


      }
    });



//     print("cloud firestore ${newMoment.isUserBookMarkFlag}");
//     final parentDocumentRef = _firestore.collection(usersCollection).doc(userVO.id.toString());
//     // Get a reference to the specific document within the subcollection
//     final subCollectionDocumentRef = parentDocumentRef.collection(bookMarkedListCollection);
//
// //fsafas
//
//     var listData =   subCollectionDocumentRef.get();
//   var listData =  subCollectionDocumentRef.snapshots().map<List<MomentVO>>((querySnapshot){
//        querySnapshot.docs.map<MomentVO>((document){
//          MomentVO.fromJson(document.data() as Map<String, dynamic>);
//       }).toList();
//
//     }).handleError((error) {
//       print("Error retrieving moments list: $error");
//       return []; // Return an empty list in case of an error
//     });



    //
    //
    // if(newMoment.isUserBookMarkFlag == true)
    //   {
    //     //add
    //     final CollectionReference parentCollection = _firestore.collection(usersCollection);
    //     final DocumentReference parentDocument = parentCollection.doc(userVO.id.toString());
    //     await parentDocument.set(userVO.toJson());
    //     final CollectionReference subCollection = parentDocument.collection(bookMarkedListCollection);
    //
    //     if (newMoment != null) {
    //       // newMoment.isUserBookMarkFlag = !(newMoment.isUserBookMarkFlag??false);
    //       // print("cloud firestore ${newMoment.isUserBookMarkFlag}");
    //       final DocumentReference newDocument = subCollection.doc(newMoment.id);
    //       await newDocument.set(newMoment.toJson());
    //     }
    //   }else{
    //   //remove
    //   removeMomentVOFromBookMarkListCollection(userVO, newMoment);
    // }


  }

  void removeMomentVOFromFavouriteListCollection(UserVO userVO, MomentVO newMoment) {
    // Get a reference to the parent document that contains the subcollection
    final parentDocumentRef = _firestore.collection(usersCollection).doc(userVO.id.toString());

    // Get a reference to the specific document within the subcollection
    final subCollectionDocumentRef = parentDocumentRef.collection(likedListCollection).doc(newMoment.id);

    // Delete the document from the subcollection
    subCollectionDocumentRef.delete().then((_) {
      print('Subcollection document removed successfully');
    }).catchError((error) {
      print('Error removing subcollection document: $error');
    });
  }
  void removeMomentVOFromBookMarkListCollection(UserVO userVO, MomentVO newMoment) {
    // Get a reference to the parent document that contains the subcollection
    final parentDocumentRef = _firestore.collection(usersCollection).doc(userVO.id.toString());

    // Get a reference to the specific document within the subcollection
    final subCollectionDocumentRef = parentDocumentRef.collection(bookMarkedListCollection).doc(newMoment.id);

    // Delete the document from the subcollection
    subCollectionDocumentRef.delete().then((_) {
      print('Subcollection document removed successfully');
    }).catchError((error) {
      print('Error removing subcollection document: $error');
    });
  }
  void saveToMomentsCollection(MomentVO newMoment) {

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

  @override
  Future<List<MediaTypeVO>> uploadVoiceRecordFileToFirebaseForChatMsg(String voiceRecordFile) async {
    List<MediaTypeVO> strVoiceRecordFile = [];
    File recordedFile = File(voiceRecordFile);

    var taskSnapshot = await firebaseStorage
        .ref()
        .child("audio/${DateTime.now().millisecondsSinceEpoch}")
        .putFile(recordedFile);

    var downloadURL = await taskSnapshot.ref.getDownloadURL();
    var metaData = await taskSnapshot.ref.getMetadata();
    var contentType = metaData.contentType;
    strVoiceRecordFile.add(MediaTypeVO(
        id: "1",
        fileType: "aac",
        fileUrl: downloadURL
    ));

    return strVoiceRecordFile;
  }


}

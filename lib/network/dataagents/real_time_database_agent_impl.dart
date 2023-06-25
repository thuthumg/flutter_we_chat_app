import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/chat_history_vo.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/network/dataagents/we_chat_app_real_time_db_data_agent.dart';

///Database Paths
const contactsAndMessagesCollection = "contacts&Messages";
const fileUploadRef = "uploads";
const usersPath = "users";
const groupCollection = "groups";
const usersCollection = "users";

class RealtimeDatabaseDataAgentImpl extends WeChatAppRealTimeDBDataAgent {
  static final RealtimeDatabaseDataAgentImpl _singleton =
  RealtimeDatabaseDataAgentImpl._internal();

  factory RealtimeDatabaseDataAgentImpl() {
    return _singleton;
  }

  RealtimeDatabaseDataAgentImpl._internal();

  ///Database
  var databaseRef = FirebaseDatabase.instance.ref();
  ///Database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Storage
  var firebaseStorage = FirebaseStorage.instance;

  ///Authentication
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<void> sendMessage(String senderId,
      String receiverId,
      String sendMsg,
      String senderName,
      String sendMsgFileUrl,
      String profileUrl,
      String timestamp) {
    databaseRef
        .child(contactsAndMessagesCollection)
        .child(senderId.toString())
        .child(receiverId.toString())
        .child(timestamp)
        .set(ChatMessageVO(
        file: sendMsgFileUrl,
        message: sendMsg,
        name: senderName,
        profileUrl: profileUrl,
        timestamp: timestamp,
        userId: senderId).toJson());

    return databaseRef
        .child(contactsAndMessagesCollection)
        .child(receiverId.toString())
        .child(senderId.toString())
        .child(timestamp)
        .set(ChatMessageVO(
        file: sendMsgFileUrl,
        message: sendMsg,
        name: senderName,
        profileUrl: profileUrl,
        timestamp: timestamp,
        userId: senderId).toJson());
  }

  @override
  Stream<List<ChatMessageVO>> getChatMessageList(String loginUserId,
      String receiverId) {

      return databaseRef
        .child(contactsAndMessagesCollection)
        .child(loginUserId)
        .child(receiverId)
        .onValue.map((event) {
      ///for complex key
      //event.snapshot.value => Map<String,dynamic> => values=> List<Map<String,dynamic>> => NewsFeedVO.fromJson() => List<NewsFeedVO>
      debugPrint("getChatMessageList ${event.snapshot.value}");

      Map<Object?, Object?> objectMap = event.snapshot.value
      as Map<Object?, Object?>; // Replace with the actual object

      Map<String?, dynamic> convertedMap = {};

    //  Map<String?, dynamic> convertedMap2 = {};

      objectMap.forEach((key, value) {

        convertedMap[key.toString()] = value;
        // convertedMap[key.toString()].forEach((key, value){
        //   convertedMap2[key.toString()] = value;
        // });

      });
      return (convertedMap.values).map<ChatMessageVO>((element) {
        return ChatMessageVO.fromJson(Map<String, dynamic>.from(element));
      }).toList();
    });



//  }

  }

  @override
  Stream<List<ChatHistoryVO>> getChatHistoryList(String loginUserId) {
    StreamController<List<ChatHistoryVO>> controller =
    StreamController<List<ChatHistoryVO>>();

    DatabaseReference chatRef = databaseRef
        .child(contactsAndMessagesCollection)
        .child(loginUserId.toString());

    chatRef.onValue.listen((event) {
      Map<dynamic, dynamic> objectMap = event.snapshot.value as Map<dynamic, dynamic>;

      Map<String, dynamic> convertedMap = {};
      List<ChatHistoryVO> mChatHistoryListVO = [];

      objectMap.forEach((key, value) {
        convertedMap[key.toString()] = value;
        debugPrint("check convertedMap data ${convertedMap.values} ");

        Map<String, dynamic> convertedMap2 = Map<String, dynamic>.from(convertedMap[key.toString()]);
        debugPrint("check convertedMap2 data ${convertedMap2.values} ");

        List sortedListData = (convertedMap2.values).toList()
          ..sort((a, b) {
          //  debugPrint("check timestamp data ${b} ---- ${a['timestamp']}");
            return b['timestamp'].compareTo(a['timestamp']);
          });

        ChatMessageVO? chatMsg = sortedListData.first['timestamp'] != null
            ? ChatMessageVO.fromJson(Map<String, dynamic>.from(sortedListData.first))
            : null;

        if (chatMsg != null) {
          getChatUser(key.toString()).listen((receiverUserVO) {
            DateFormat dateFormat = DateFormat("yyyy-MM-dd", "en_US");
            String dateString =
            dateFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(chatMsg.timestamp.toString())));

            mChatHistoryListVO.add(
              ChatHistoryVO(
                chatUserId: key.toString(),
                chatUserName: receiverUserVO?.userName,
                chatMsg: chatMsg.message,
                chatTime: dateString,
                chatUserProfileUrl: receiverUserVO?.profileUrl,
              ),
            );

            controller.add(mChatHistoryListVO);
          });
        }
      });
    });

    return controller.stream;
  }

// @override
//   Stream<List<ChatHistoryVO>> getChatHistoryList(String loginUserId) {
//     StreamController<List<ChatHistoryVO>> controller =
//     StreamController<List<ChatHistoryVO>>();
//
//     DatabaseReference chatRef = databaseRef
//         .child(contactsAndMessagesCollection)
//         .child(loginUserId.toString());
//
//     chatRef.onValue.listen((event) {
//       Map<Object?, Object?> objectMap = event.snapshot.value as Map<Object?, Object?>;
//
//       Map<String?, dynamic> convertedMap = {};
//
//       List<ChatHistoryVO> mChatHistoryListVO = [];
//
//       objectMap.forEach((key, value) {
//         convertedMap[key.toString()] = value;
//         debugPrint("check convertedMap data ${convertedMap.values} ");
//         Map<String?, dynamic> convertedMap2 = {};
//
//         convertedMap[key.toString()].forEach((key2, value2) {
//           convertedMap2[key2.toString()] = value2;
//         });
//         debugPrint("check convertedMap2 data ${convertedMap2.values} ");
//
//
//         List sortedListData = (convertedMap2.values).toList()
//           ..sort((a, b) {
//             debugPrint("check timestamp data ${b} ---- ${a['timestamp']}");
//             return  b['timestamp'].compareTo(a['timestamp']);
//           });
//
//         ChatMessageVO? chatMsg = sortedListData.first['timestamp'] != null
//             ? ChatMessageVO.fromJson(sortedListData.first)
//             : null;
//
//         if (chatMsg != null) {
//           getChatUser(key.toString()).listen((receiverUserVO) {
//             DateFormat dateFormat = DateFormat("yyyy-MM-dd", "en_US");
//             String dateString =
//             dateFormat.format(DateTime.fromMillisecondsSinceEpoch(chatMsg.timestamp as int));
//
//             mChatHistoryListVO.add(
//               ChatHistoryVO(
//                 chatUserId: key.toString(),
//                 chatUserName: receiverUserVO?.userName,
//                 chatMsg: chatMsg.message,
//                 chatTime: dateString,
//                 chatUserProfileUrl: receiverUserVO?.profileUrl,
//               ),
//             );
//
//             controller.add(mChatHistoryListVO);
//           });
//         }
//       });
//     });
//
//     return controller.stream;
//   }


  // @override
  // Stream<List<ChatMessageVO>> getChatHistoryList(String loginUserId) {
  //
  //   debugPrint("getChatHistoryList before call db ${loginUserId}");
  //
  //   // return databaseRef
  //   //     .child(contactsAndMessagesCollection)
  //   //     .child(loginUserId.toString())
  //   //     .onValue.map((event) {
  //   //   ///for complex key
  //   //   //event.snapshot.value => Map<String,dynamic> => values=> List<Map<String,dynamic>> => NewsFeedVO.fromJson() => List<NewsFeedVO>
  //   //   debugPrint("getChatHistoryList ${event.snapshot.value}");
  //   //
  //   //   Map<Object?, Object?> objectMap = event.snapshot.value
  //   //   as Map<Object?, Object?>; // Replace with the actual object
  //   //
  //   //   Map<String?, dynamic> convertedMap = {};
  //   //
  //   //
  //   //   objectMap.forEach((key, value) {
  //   //     convertedMap[key.toString()] = value;
  //   //   });
  //   //
  //   //   debugPrint("getChatHistoryList 1 ${convertedMap.values}");
  //   //
  //   //
  //   //   return (convertedMap.values).map<ChatMessageVO>((element) {
  //   //     return ChatMessageVO.fromJson(Map<String, dynamic>.from(element));
  //   //   }).toList();
  //   // });
  //   UserVO? receiverUserVO;
  //   return databaseRef
  //        .child(contactsAndMessagesCollection)
  //        .child(loginUserId.toString())
  //        .onValue.map((event) {
  //
  //        Map<Object?, Object?> objectMap = event.snapshot.value
  //        as Map<Object?, Object?>;
  //        Map<String?, dynamic> convertedMap = {};
  //        List<ChatHistoryVO> mChatHistoryListVO = [];
  //
  //          objectMap.forEach((key, value) {
  //            convertedMap[key.toString()] = value;
  //
  //
  //            List sortedListData = (convertedMap.values).toList()
  //              ..sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
  //
  //            ChatMessageVO? chatMsg =
  //            sortedListData.first['timestamp'] != null
  //                ? ChatMessageVO.fromJson(sortedListData.first)
  //                : null;
  //
  //
  //
  //
  //            getChatUser(key.toString()).listen((userObj) {
  //              receiverUserVO = userObj;
  //
  //              if (chatMsg != null) {
  //                DateFormat dateFormat = DateFormat("yyyy-MM-dd", "en_US");
  //                String dateString = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(chatMsg.timestamp));
  //
  //                mChatHistoryListVO.add(
  //                  ChatHistoryVO(
  //                    chatUserId: key.toString(),
  //                    chatUserName: receiverUserVO?.userName,
  //                    chatMsg: chatMsg.message,
  //                    chatTime: dateString,
  //                    chatUserProfileUrl: receiverUserVO?.profileUrl,
  //                  ),
  //                );
  //              }
  //
  //
  //
  //            });
  //          });
  //
  //
  //   });
  //
  //
  //
  // }

  Stream<UserVO> getChatUser(
      String receiverId) {
  return  _firestore
        .collection(usersCollection)
        .doc(receiverId)
        .get()
        .asStream()
        .where((documentSnapShot) => documentSnapShot.data() != null)
        .map((documentSnapShot) => UserVO.fromJson(documentSnapShot.data()!));
  }



}

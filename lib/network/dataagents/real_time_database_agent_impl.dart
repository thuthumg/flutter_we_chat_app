import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model_impl.dart';
import 'package:we_chat_app/data/vos/chat_group_vo.dart';
import 'package:we_chat_app/data/vos/chat_history_vo.dart';
import 'package:we_chat_app/data/vos/chat_message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/network/dataagents/cloud_firestore_data_agent_impl.dart';
import 'package:we_chat_app/network/dataagents/we_chat_app_data_agent.dart';
import 'package:we_chat_app/network/dataagents/we_chat_app_real_time_db_data_agent.dart';

///Database Paths
const contactsAndMessagesCollection = "contacts&Messages";
const fileUploadRef = "uploads";
const usersPath = "users";
const usersCollection = "users";
const groupsCollection = "groups";
const messageDocument = "message";

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
  WeChatAppDataAgent mDataAgent = CloudFirestoreDataAgentImpl();
  ///Authentication
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<void> sendMessage(
      String senderId,
      String receiverId,
      String sendMsg,
      String senderName,
      List<File> sendMsgFileUrl,
      String profileUrl,
      String timestamp) {
    debugPrint("check send Message ${sendMsgFileUrl.length}");
    if (sendMsgFileUrl != null) {
      return mDataAgent
          .multiUploadFileToFirebase(sendMsgFileUrl)
          .then(
              (downloadUrl) => sendChatMessageVO(senderId,
                  receiverId,
                  sendMsg,
                  senderName,
                  downloadUrl,
                  profileUrl,
                  timestamp));
              } else {
      return sendChatMessageVO(senderId,
          receiverId,
          sendMsg,
          senderName,
          "",
          profileUrl,
          timestamp);
    }


  }
  Future<void> sendChatMessageVO(String senderId,
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
        userId: senderId)
        .toJson());

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
        userId: senderId)
        .toJson());
  }
  @override
  Stream<List<ChatMessageVO>> getChatMessageList(
      String loginUserId, String receiverId,bool isGroup) {
    return
      (isGroup)?

      databaseRef
          .child(groupsCollection)
          .child(receiverId)
          .child(messageDocument)
          .onValue
          .map((event) {
        ///for complex key
        //event.snapshot.value => Map<String,dynamic> => values=> List<Map<String,dynamic>> => NewsFeedVO.fromJson() => List<NewsFeedVO>
        debugPrint("getChatMessageList ${event.snapshot.value}");

        if(event.snapshot.value != null)
        {
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
        }else{
          return List.empty();
        }



      }):

      databaseRef
        .child(contactsAndMessagesCollection)
        .child(loginUserId)
        .child(receiverId)
        .onValue
        .map((event) {
      ///for complex key
      //event.snapshot.value => Map<String,dynamic> => values=> List<Map<String,dynamic>> => NewsFeedVO.fromJson() => List<NewsFeedVO>
      debugPrint("getChatMessageList ${event.snapshot.value}");

      if(event.snapshot.value != null)
        {
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
        }else{
        return List.empty();
      }



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

      if(event.snapshot.value != null)
        {
          Map<dynamic, dynamic> objectMap =
          event.snapshot.value as Map<dynamic, dynamic>;

          Map<String, dynamic> convertedMap = {};
          List<ChatHistoryVO> mChatHistoryListVO = [];

          objectMap.forEach((key, value) {
            convertedMap[key.toString()] = value;
            debugPrint("check convertedMap data ${convertedMap.values} ");

            Map<String, dynamic> convertedMap2 =
            Map<String, dynamic>.from(convertedMap[key.toString()]);
            debugPrint("check convertedMap2 data ${convertedMap2.values} ");

            List sortedListData = (convertedMap2.values).toList()
              ..sort((a, b) {
                //  debugPrint("check timestamp data ${b} ---- ${a['timestamp']}");
                return b['timestamp'].compareTo(a['timestamp']);
              });

            ChatMessageVO? chatMsg = sortedListData.first['timestamp'] != null
                ? ChatMessageVO.fromJson(
                Map<String, dynamic>.from(sortedListData.first))
                : null;

            if (chatMsg != null) {
              getChatUser(key.toString()).listen((receiverUserVO) {
                DateFormat dateFormat = DateFormat("yyyy-MM-dd", "en_US");
                String dateString = dateFormat.format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(chatMsg.timestamp.toString())));

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
        }


    });

    return controller.stream;
  }


  Stream<List<ChatHistoryVO>> getChatGroupHistoryList(String loginUserId) {
    StreamController<List<ChatHistoryVO>> controller =
    StreamController<List<ChatHistoryVO>>();


    // final mChatGroupVOList = <ChatGroupVO>[];
    //event.snapshot.value => Map<String,dynamic> => values=> List<Map<String,dynamic>> => NewsFeedVO.fromJson() => List<NewsFeedVO>

    DatabaseReference databaseReference = databaseRef.child(groupsCollection);
   // StreamController<List<ChatGroupVO>> controller = StreamController<List<ChatGroupVO>>();

    databaseReference.onValue.listen((DatabaseEvent event) {
      debugPrint("getChatGroupsList fun before condition = $loginUserId");

      if(event.snapshot.value != null)
      {

        Map<Object?, Object?> objectMap =
        event.snapshot.value as Map<Object?, Object?>;

        Map<String, dynamic> convertedMap = {};
        List<ChatGroupVO> mChatGroupListVO = [];

        objectMap.forEach((key, value) {
          convertedMap[key.toString()] = value;
        });

        (convertedMap.values).forEach((element) {
          debugPrint("getChatGroupsList fun condition 1  ${element}");

          ChatGroupVO chatGroupVO = ChatGroupVO.fromJson(Map<String, dynamic>.from(element));

          debugPrint("getChatGroupsList fun condition 2 ${chatGroupVO.toString()}");
          if (chatGroupVO.membersList?.contains(loginUserId) == true) {
            mChatGroupListVO.add(chatGroupVO);
            //debugPrint("getChatGroupsList fun condition 3 ${mChatGroupListVO.length}");
           // controller.add(mChatGroupListVO.toList());
          }

          // if((element['message']?.length != null) && (element['message']?.length)! > 0)
          //   {
          //
          //
          //     Map<Object?, Object?> objectMessageMap =
          //     element['message'].message as Map<Object?, Object?>;
          //
          //     Map<String, dynamic> convertedMessageMap = {};
          //     List<ChatMessageVO> mChatGroupMessageListVO = [];
          //
          //     objectMessageMap.forEach((key, value) {
          //       convertedMessageMap[key.toString()] = value;
          //     });
          //
          //     convertedMessageMap.values.forEach((msgElement) {
          //       ChatMessageVO chatMessageVO = ChatMessageVO.fromJson(Map<String, dynamic>.from(msgElement));
          //       mChatGroupMessageListVO.add(chatMessageVO);
          //     });
          //
          //   }else{
          // }




        });
      }




    });

    return controller.stream;
  }

  Stream<UserVO> getChatUser(String receiverId) {
    return _firestore
        .collection(usersCollection)
        .doc(receiverId)
        .get()
        .asStream()
        .where((documentSnapShot) => documentSnapShot.data() != null)
        .map((documentSnapShot) => UserVO.fromJson(documentSnapShot.data()!));
  }

  @override
  Future<void> createChatGroup(
     ChatGroupVO chatGroupVO) {

    return databaseRef.child(groupsCollection).child(chatGroupVO.id.toString()??"").set(
        chatGroupVO.toJson());
  }

  @override
  Stream<List<ChatGroupVO>> getChatGroupsList(String loginUserId) {
    DatabaseReference databaseReference = databaseRef.child(groupsCollection);
    StreamController<List<ChatGroupVO>> controller = StreamController<List<ChatGroupVO>>();

    databaseReference.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> objectMap = event.snapshot.value as Map<dynamic, dynamic>;

        List<ChatGroupVO> mChatGroupListVO = [];

        objectMap.forEach((key, value) {
          if (value != null && value is Map<dynamic, dynamic>) {
            Map<String, dynamic> elementMap = value.cast<String, dynamic>();

            // Manually convert the nested map to ChatMessageVO
            Map<String, dynamic>? messageMap = elementMap['message'] != null
                ? Map<String, dynamic>.from(elementMap['message'])
                : null;

            Map<String, ChatMessageVO>? chatMessageMap = {};
            if (messageMap != null) {
              messageMap.forEach((key, value) {
                chatMessageMap[key] = ChatMessageVO.fromJson(Map<String, dynamic>.from(value));
              });
            }

            // Manually extract and assign the values to the ChatGroupVO object
            ChatGroupVO chatGroupVO = ChatGroupVO(
              id: elementMap['id'],
              name: elementMap['name'],
              message: chatMessageMap,
              membersList: List<String>.from(elementMap['membersList'] ?? []),
              profileUrl: elementMap['profileUrl'],
            );

            if (chatGroupVO.membersList?.contains(loginUserId) == true) {
              mChatGroupListVO.add(chatGroupVO);
            }
          }
        });

        controller.add(mChatGroupListVO);
      }
    });

    return controller.stream;
  }

  @override
  Future<void> sendGroupMessage(
      String senderId,
      String receiverId,
      String sendMsg,
      String senderName,
      List<File> sendMsgFileUrl,
      String profileUrl,
      String timestamp)
    {


      if (sendMsgFileUrl != null) {
        return mDataAgent
            .multiUploadFileToFirebase(sendMsgFileUrl)
            .then(
                (downloadUrl) => sendGroupChatMessageVO(
                senderId,
                receiverId,
                sendMsg,
                senderName,
                downloadUrl,
                profileUrl,
                timestamp));
      } else {
        return sendGroupChatMessageVO(
            senderId,
            receiverId,
            sendMsg,
            senderName,
            "",
            profileUrl,
            timestamp);
      }




    }

  Future<void> sendGroupChatMessageVO(
      String senderId,
      String receiverId,
      String sendMsg,
      String senderName,
      String sendMsgFileUrl,
      String profileUrl,
      String timestamp) {


    return databaseRef
        .child(groupsCollection)
        .child(receiverId.toString())
        .child(messageDocument)
        .child(timestamp)
        .set(ChatMessageVO(
        file: sendMsgFileUrl,
        message: sendMsg,
        name: senderName,
        profileUrl: profileUrl,
        timestamp: timestamp,
        userId: senderId)
        .toJson());
  }

}

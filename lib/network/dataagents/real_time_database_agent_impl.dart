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
import 'package:we_chat_app/data/vos/media_type_vo.dart';
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
      String timestamp,
      List<String>  selectedGifImages) {
    debugPrint("check send Message ${sendMsgFileUrl.length}");
    if (sendMsgFileUrl.isNotEmpty) {//sendMsgFileUrl != null
      return mDataAgent
          .multiUploadFileToFirebaseForChatMsg(sendMsgFileUrl)
          .then(
              (mediaTypeObjList) => sendChatMessageVO(senderId,
                  receiverId,
                  sendMsg,
                  senderName,
                  mediaTypeObjList,
                  profileUrl,
                  timestamp));
              } else {
      debugPrint("check link data ${selectedGifImages.toString()}");
      if(selectedGifImages.isNotEmpty)
        {
          List<MediaTypeVO> strGifImage = [];
          strGifImage.add(MediaTypeVO(
              id: "1",
              fileType: "gif",
              fileUrl: selectedGifImages.firstOrNull.toString()
          ));

          debugPrint("check link data ${strGifImage.length}");

          return sendChatMessageVO(senderId,
              receiverId,
              sendMsg,
              senderName,
              strGifImage,
              profileUrl,
              timestamp);
        }
      else
        {
          return sendChatMessageVO(senderId,
              receiverId,
              sendMsg,
              senderName,
              [],
              profileUrl,
              timestamp);
        }




    }


  }
  // dynamic getListMap(List<MediaTypeVO> items) {
  //   if (items == null) {
  //     return null;
  //   }
  //   List<Map<String, MediaTypeVO>> list = [];
  //   items.forEach((element) {
  //     list.add(element.toJson());
  //   });
  //   return list;
  // }
  // Map<String, dynamic>? dynamicMap = {};
  // mediaTypeVOList.forEach((mediaTypeVO) {
  //   dynamicMap[mediaTypeVO.id??"0"] = mediaTypeVO.toJson();
  // });
  // Map<String, MediaTypeVO> mediaTypeMap = dynamicMap.map((key, value) =>
  //     MapEntry(key, MediaTypeVO(id:value['id'],
  //         fileUrl:value['fileUrl'],fileType:value['fileType'])));
  //

  // Map<String, MediaTypeVO> mediaTypeMap = {};
  // mediaTypeVOList.forEach((mediaTypeVO) {
  //   mediaTypeMap[mediaTypeVO.id??""] = mediaTypeVO;
  // });

  // Map<String, MediaTypeVO> mediaTypeMap = {};
  // mediaTypeVOList.forEach((mediaTypeVO) {
  //   mediaTypeMap[mediaTypeVO.id??""] = mediaTypeVO;
  // });

  //
  // Map<String, MediaTypeVO> mediaTypeMap = {};
  // mediaTypeVOList.forEach((mediaTypeVO) {
  //   mediaTypeMap[mediaTypeVO.id??""] = mediaTypeVO;
  // });
  //
  // Map<String, Map<String, MediaTypeVO>> convertedMediaTypeMap = mediaTypeMap.map(
  //       (key, value) => MapEntry(key, value as Map<String, MediaTypeVO>),
  // );
//mediaTypeVOList.map((mediaTypeVO) => mediaTypeVO.toJson()).toList()

  // var mediaTypeObjVOList = mediaTypeVOList.map((e){
  //   return {
  //     "id": e.id,
  //     "file_url": e.fileUrl,
  //     "file_type": e.fileType
  //   };
  // }).toList();getListMap(List<MediaTypeVO>.from(mediaTypeVOList.map((x) => x.toJson())))

  Future<void> sendChatMessageVO(String senderId,
      String receiverId,
      String sendMsg,
      String senderName,
      List<MediaTypeVO> mediaTypeVOList,
      String profileUrl,
      String timestamp) {

   // List<Map<String, dynamic>> mapList = mediaTypeVOList.map((item) => item.toJson()).toList();
   // List<MediaTypeVO> mediaTypeVOListNew = mapList.map((map) => MediaTypeVO.fromJson(map)).toList();

    debugPrint("check mediatypeVO ${mediaTypeVOList.toString()}");

    databaseRef
        .child(contactsAndMessagesCollection)
        .child(senderId.toString())
        .child(receiverId.toString())
        .child(timestamp)
        .set(ChatMessageVO(
        mediaFile:mediaTypeVOList,
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
        mediaFile:mediaTypeVOList,
        message: sendMsg,
        name: senderName,
        profileUrl: profileUrl,
        timestamp: timestamp,
        userId: senderId)
        .toJson());
  }
  //
  // Future<void> sendChatMessageVO(
  //     String senderId,
  //     String receiverId,
  //     String sendMsg,
  //     String senderName,
  //     List<MediaTypeVO> mediaTypeVOList,
  //     String profileUrl,
  //     String timestamp) async {
  //
  //   final senderChatMessage = ChatMessageVO(
  //     mediaFile:    [
  //       MediaTypeVO(id: '1', fileType :"image/jpeg",
  //           fileUrl
  //           :"https://firebasestorage.googleapis.com/v0/b/wechatapp-e690f.appspot.com/o/uploads%2F1688884892673?alt=media&token=3d123bdc-0c48-4cc7-a643-1a5166bd4296"
  //       ),
  //      // Note(title: 'Note 2', content: 'Content 2'),
  //   ],
  //     message: sendMsg,
  //     name: senderName,
  //     profileUrl: profileUrl,
  //     timestamp: timestamp,
  //     userId: senderId,
  //   );
  //
  //   final receiverChatMessage = ChatMessageVO(
  //     mediaFile:  [
  //       MediaTypeVO(id: '1', fileType :"image/jpeg",
  //           fileUrl
  //               :"https://firebasestorage.googleapis.com/v0/b/wechatapp-e690f.appspot.com/o/uploads%2F1688884892673?alt=media&token=3d123bdc-0c48-4cc7-a643-1a5166bd4296"
  //       ),
  //       // Note(title: 'Note 2', content: 'Content 2'),
  //     ],// mediaTypeVOList
  //     message: sendMsg,
  //     name: senderName,
  //     profileUrl: profileUrl,
  //     timestamp: timestamp,
  //     userId: senderId,
  //   );
  //
  //   final senderRef = databaseRef
  //       .child(contactsAndMessagesCollection)
  //       .child(senderId)
  //       .child(receiverId)
  //       .child(timestamp);
  //
  //   final receiverRef = databaseRef
  //       .child(contactsAndMessagesCollection)
  //       .child(receiverId)
  //       .child(senderId)
  //       .child(timestamp);
  //
  //   await senderRef.set(senderChatMessage.toJson());
  //   await receiverRef.set(receiverChatMessage.toJson());
  // }



  @override
  Stream<List<ChatMessageVO>> getChatMessageList(
      String loginUserId,
      String receiverId,
      bool isGroup,
      ) {
    return (isGroup)
        ? databaseRef
        .child(groupsCollection)
        .child(receiverId)
        .child(messageDocument)
        .onValue
        .map((event) {
      if (event.snapshot.value != null) {
        List<ChatMessageVO> chatMessageVOList = [];

        Map<dynamic, dynamic> objectMap = event.snapshot.value as Map<dynamic, dynamic>;

        objectMap.forEach((key, value) {
          if (value != null && value is Map<dynamic, dynamic>) {
            Map<String, dynamic> elementMap = value.cast<String, dynamic>();

            // 1. Manually convert the nested map to List<Map<String, dynamic>>?
            List<dynamic>? mediaFileList = elementMap['media_file'];
            List<Map<String, dynamic>>? mediaFileMapList = [];

            if (mediaFileList != null) {
              mediaFileMapList = mediaFileList
                  .where((mediaFile) => mediaFile is Map<dynamic, dynamic>)
                  .map<Map<String, dynamic>>((mediaFile) => Map<String, dynamic>.from(mediaFile.cast<String, dynamic>()))
                  .toList();
            }
            // 2. convert from List<Map<String, dynamic>>? to List<MediaTypeVO>
            List<MediaTypeVO> mediaTypeList = convertMapListToMediaTypeList(mediaFileMapList);

            ChatMessageVO chatMessageVO = ChatMessageVO(
              mediaFile: mediaTypeList,
              message: elementMap['message'],
              name: elementMap['name'],
              profileUrl: elementMap['profileUrl'],
              timestamp: elementMap['timestamp'],
              userId: elementMap['userId'],
            );

            chatMessageVOList.add(chatMessageVO);
          }
        });

        return chatMessageVOList;
      } else {
        return List.empty();
      }
    })
        :
    databaseRef
        .child(contactsAndMessagesCollection)
        .child(loginUserId)
        .child(receiverId)
        .onValue
        .map((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> objectMap = event.snapshot.value as Map<dynamic, dynamic>;

        List<ChatMessageVO> chatMessageVOList = [];

        objectMap.forEach((key, value) {
          if (value != null && value is Map<dynamic, dynamic>) {
            Map<String, dynamic> elementMap = value.cast<String, dynamic>();

            // 1. Manually convert the nested map to List<Map<String, dynamic>>?
            List<dynamic>? mediaFileList = elementMap['media_file'];
            List<Map<String, dynamic>>? mediaFileMapList = [];

            if (mediaFileList != null) {
              mediaFileMapList = mediaFileList
                  .where((mediaFile) => mediaFile is Map<dynamic, dynamic>)
                  .map<Map<String, dynamic>>((mediaFile) => Map<String, dynamic>.from(mediaFile.cast<String, dynamic>()))
                  .toList();
            }

            // 2. convert from List<Map<String, dynamic>>? to List<MediaTypeVO>
            List<MediaTypeVO> mediaTypeList = convertMapListToMediaTypeList(mediaFileMapList);

            ChatMessageVO chatMessageVO = ChatMessageVO(
              mediaFile: mediaTypeList,
              message: elementMap['message'],
              name: elementMap['name'],
              profileUrl: elementMap['profileUrl'],
              timestamp: elementMap['timestamp'],
              userId: elementMap['userId'],
            );

            chatMessageVOList.add(chatMessageVO);
          }
        });

        return chatMessageVOList;
      } else {
        return List.empty();
      }
    });
  }


  List<MediaTypeVO> convertMapListToMediaTypeList(List<Map<String, dynamic>> mapList) {
    List<MediaTypeVO> mediaTypeList = mapList.map((map) {
      return MediaTypeVO(
        fileType: map['file_type'] as String,
        fileUrl: map['file_url'] as String,
        id: map['id'] as String,
      );
    }).toList();

    return mediaTypeList;
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
            ChatMessageVO? chatMsg;
            if( sortedListData.first['timestamp'] != null)
              {

                Map<String, dynamic> elementMap = sortedListData.first.cast<String, dynamic>();

                // Manually convert the nested map to ChatMessageVO
               // Map<String, dynamic>? mediaTypeMap = elementMap['media_file'] != null
               //      ? Map<String, dynamic>.from(elementMap['media_file'])
               //      : null;

                Map<String, dynamic>? mediaTypeMap = elementMap['media_file'] is Map<dynamic, dynamic>
                    ? Map<String, dynamic>.from(elementMap['media_file'] as Map<dynamic, dynamic>)
                    : null;

                List<MediaTypeVO> resultList = [];
                mediaTypeMap?.forEach((key, value) {
                  String id = key;
                  String fileUrl = value['file_url'];
                  String fileType = value['file_type'];

                  MediaTypeVO mediaType = MediaTypeVO(id:id,fileUrl: fileUrl, fileType: fileType);
                  resultList.add(mediaType);
                });


                ChatMessageVO chatMessageVO = ChatMessageVO(
                  id: elementMap['id'],
                  mediaFile: resultList,
                  name: elementMap['name'],
                  message: elementMap['message'],
                  profileUrl: elementMap['profileUrl'],
                  timestamp: elementMap['timestamp'],
                  userId: elementMap['userId'],
                );
                chatMsg = chatMessageVO;
                // ChatMessageVO.fromJson(
                //     Map<String, dynamic>.from(sortedListData.first))


              }else{
              chatMsg = null;
            }


            // ChatMessageVO? chatMsg1 =
            // sortedListData.first['timestamp'] != null
            //     ?
            //
            //
            // ChatMessageVO.fromJson(
            //     Map<String, dynamic>.from(sortedListData.first))
            //
            //
            //     : null;

            if (chatMsg != null) {
              getChatUser(key.toString()).listen((receiverUserVO) {
                DateFormat dateFormat = DateFormat("yyyy-MM-dd", "en_US");
                String dateString = dateFormat.format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(chatMsg?.timestamp.toString()??"")));

                mChatHistoryListVO.add(
                  ChatHistoryVO(
                    chatUserId: key.toString(),
                    chatUserName: receiverUserVO?.userName,
                    chatMsg: chatMsg?.message,
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





                Map<String, dynamic>? mediaTypeMap = value?['media_file'] is Map<dynamic, dynamic>
                    ? Map<String, dynamic>.from(value?['media_file'] as Map<dynamic, dynamic>)
                    : null;

                List<MediaTypeVO> resultList = [];
                mediaTypeMap?.forEach((key, value) {
                  String id = key;
                  String fileUrl = value['file_url'];
                  String fileType = value['file_type'];

                  MediaTypeVO mediaType = MediaTypeVO(id:id,fileUrl: fileUrl, fileType: fileType);
                  resultList.add(mediaType);
                });


                ChatMessageVO chatMessageVO = ChatMessageVO(
                    id: messageMap?['id'],
                    mediaFile: resultList,
                    message: messageMap?['message'],
                    name: messageMap?['name'],
                    profileUrl: messageMap?['profileUrl'],
                    timestamp: messageMap?['timestamp'],
                    userId: messageMap?['userId']
                );




                chatMessageMap[key] = chatMessageVO;

                  //  ChatMessageVO.fromJson(Map<String, dynamic>.from(chatMessageVO));
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
      String timestamp,
      List<String>  selectedGifImages)
    {

      if (sendMsgFileUrl.isNotEmpty) {
        return mDataAgent
            .multiUploadFileToFirebaseForChatMsg(sendMsgFileUrl)
            .then(
                (mediaTypeVOList) => sendGroupChatMessageVO(
                senderId,
                receiverId,
                sendMsg,
                senderName,
                mediaTypeVOList,
                profileUrl,
                timestamp));
      } else {

        if(selectedGifImages.isNotEmpty)

          {
            List<MediaTypeVO> strGifImage = [];
            strGifImage.add(MediaTypeVO(
                id: "1",
                fileType: "gif",
                fileUrl: selectedGifImages.firstOrNull.toString()
            ));


            return sendGroupChatMessageVO(
                senderId,
                receiverId,
                sendMsg,
                senderName,
                strGifImage,
                profileUrl,
                timestamp);
          }
        else
          {
            return sendGroupChatMessageVO(
                senderId,
                receiverId,
                sendMsg,
                senderName,
                [],
                profileUrl,
                timestamp);
          }


      }




    }

  Future<void> sendGroupChatMessageVO(
      String senderId,
      String receiverId,
      String sendMsg,
      String senderName,
      List<MediaTypeVO> mediaTypeVOList,
      String profileUrl,
      String timestamp) {
    // Map<String, dynamic>? dynamicMap = {};
    // mediaTypeVOList.forEach((mediaTypeVO) {
    //   dynamicMap[mediaTypeVO.id??"0"] = mediaTypeVO.toJson();
    // });
    // Map<String, MediaTypeVO> mediaTypeMap = dynamicMap.map((key, value) =>
    //     MapEntry(key, MediaTypeVO(id:value['id'],
    //         fileUrl:value['fileUrl'],fileType:value['fileType'])));

    // Map<String, MediaTypeVO> mediaTypeMap = {};
    // mediaTypeVOList.forEach((mediaTypeVO) {
    //   mediaTypeMap[mediaTypeVO.id??""] = mediaTypeVO;
    // });

    // Map<String, MediaTypeVO> mediaTypeMap = {};
    // mediaTypeVOList.forEach((mediaTypeVO) {
    //   mediaTypeMap[mediaTypeVO.id??""] = mediaTypeVO;
    // });
// mediaTypeVOList.map((mediaTypeVO) => mediaTypeVO.toJson()).toList()

    return databaseRef
        .child(groupsCollection)
        .child(receiverId.toString())
        .child(messageDocument)
        .child(timestamp)
        .set(ChatMessageVO(
        mediaFile:mediaTypeVOList,
        message: sendMsg,
        name: senderName,
        profileUrl: profileUrl,
        timestamp: timestamp,
        userId: senderId)
        .toJson());
  }

}

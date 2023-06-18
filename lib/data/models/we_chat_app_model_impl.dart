import 'package:we_chat_app/data/models/authentication_model.dart';
import 'package:we_chat_app/data/models/authentication_model_impl.dart';
import 'package:we_chat_app/data/models/we_chat_app_model.dart';
import 'package:we_chat_app/data/vos/otp_code_vo.dart';
import 'package:we_chat_app/network/dataagents/cloud_firestore_data_agent_impl.dart';
import 'package:we_chat_app/network/dataagents/we_chat_app_data_agent.dart';

class WeChatAppModelImpl extends WeChatAppModel{

  static final WeChatAppModelImpl _singleton = WeChatAppModelImpl._internal();

  factory WeChatAppModelImpl(){
    return _singleton;
  }
  WeChatAppModelImpl._internal();

  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();
  WeChatAppDataAgent mDataAgent = CloudFirestoreDataAgentImpl();


  @override
  Stream<List<OTPCodeVO>> getOtpCode() {
    return mDataAgent.getOtpCode();
  }



}
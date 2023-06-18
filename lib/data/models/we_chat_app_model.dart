import 'package:we_chat_app/data/vos/otp_code_vo.dart';

abstract class WeChatAppModel{
  Stream<List<OTPCodeVO>> getOtpCode();

}
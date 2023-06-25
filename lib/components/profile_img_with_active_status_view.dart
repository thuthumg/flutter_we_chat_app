import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/dimens.dart';

class ProfileImgWithActiveStatusView extends StatelessWidget {

  final String chatUserProfile;

  const ProfileImgWithActiveStatusView({
    super.key,
    required this.chatUserProfile
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ActiveNowProfileImageView(
            chatUserProfile: chatUserProfile),
        const ActiveNowProfileActiveStatusView(),
      ],
    );
  }
}
class ActiveNowProfileImageView extends StatelessWidget {

  final String chatUserProfile;

  const ActiveNowProfileImageView({
    super.key,
    required this.chatUserProfile
  });

  @override
  Widget build(BuildContext context) {
    return
      (chatUserProfile == "")?
      const CircleAvatar(
      radius: ACTIVE_NOW_CHAT_ITEM_PROFILE_RADIUS,
      backgroundImage: AssetImage('assets/moments/profile_sample.jpg'),
    ):
      CircleAvatar(
        radius: ACTIVE_NOW_CHAT_ITEM_PROFILE_RADIUS,
        backgroundImage: NetworkImage(chatUserProfile),
      ) ;
  }
}

class ActiveNowProfileActiveStatusView extends StatelessWidget {
  const ActiveNowProfileActiveStatusView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      right: 0,
      bottom: 0,
      child: Container(
        width: ACTIVE_STATUS_CIRCLE_SIZE,
        height: ACTIVE_STATUS_CIRCLE_SIZE,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/dimens.dart';

class ProfileImgWithActiveStatusView extends StatelessWidget {
  const ProfileImgWithActiveStatusView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        ActiveNowProfileImageView(),
        ActiveNowProfileActiveStatusView(),
      ],
    );
  }
}
class ActiveNowProfileImageView extends StatelessWidget {
  const ActiveNowProfileImageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: ACTIVE_NOW_CHAT_ITEM_PROFILE_RADIUS,
      backgroundImage: AssetImage('assets/moments/profile_sample.jpg'),
    );
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
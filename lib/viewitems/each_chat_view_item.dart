import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/components/profile_img_with_active_status_view.dart';

class EachChatViewItem extends StatelessWidget{
  const EachChatViewItem({super.key});

  @override
  Widget build(BuildContext context) {
   return SizedBox(
      width: ACTIVE_NOW_CHAT_ITEM_WIDTH,
     child: Column(
       mainAxisSize: MainAxisSize.min,
       // crossAxisAlignment: CrossAxisAlignment.start,
        children:  const [
          ProfileImgWithActiveStatusView(),
           SizedBox(height: MARGIN_MEDIUM,),
           ActiveNowChatUserNameView(),

        ],
      ),
   );
  }

}



class ActiveNowChatUserNameView extends StatelessWidget {
  const ActiveNowChatUserNameView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
       'Yuya',
       style: TextStyle(
         fontSize: TEXT_REGULAR,
         color: Color.fromRGBO(17, 58, 93, 1),
         fontWeight: FontWeight.w600,
       ),
          ),
    );
  }
}




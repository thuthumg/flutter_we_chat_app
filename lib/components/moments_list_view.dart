import 'package:flutter/material.dart';
import 'package:we_chat_app/blocs/moments_page_bloc.dart';
import 'package:we_chat_app/blocs/profile_page_bloc.dart';
import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/viewitems/each_moment_view_item.dart';

class MomentsListView extends StatelessWidget {

  final bool isBookmark;
 final Function(MomentVO) onTapBookMark;
 final String loginUserPhoneNum;

  MomentsListView({
    super.key,
    required this.items,
    required this.isBookmark,
   required this.onTapBookMark,
    required this.loginUserPhoneNum
  });

  final List<MomentVO> items;

  @override
  Widget build(BuildContext context) {
    return isBookmark ?
    ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return EachMomentViewItem(
          loginUserPhoneNum:loginUserPhoneNum,
          mMomentVO:items[index],
          onTapBookmark: (momentVO){
            onTapBookMark(momentVO);
          },);
      },
    ):
    ListView.builder(
      // shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return EachMomentViewItem(mMomentVO:items[index],
            loginUserPhoneNum:loginUserPhoneNum,
        onTapBookmark: (momentVO){
          onTapBookMark(momentVO);

        },);
      },
    );
  }
}
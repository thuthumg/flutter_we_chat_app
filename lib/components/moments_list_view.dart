import 'package:flutter/material.dart';
import 'package:we_chat_app/viewitems/each_moment_view_item.dart';

class MomentsListView extends StatelessWidget {

  final bool isBookmark;

  const MomentsListView({
    super.key,
    required this.items,
    required this.isBookmark
  });

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return isBookmark ?
    ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return const EachMomentViewItem();
      },
    ):
    ListView.builder(
      // shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return const EachMomentViewItem();
      },
    );
  }
}
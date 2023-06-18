import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/viewitems/each_contact_view_item.dart';

class ContactNameFirstCharacterGroupEachViewItem extends StatelessWidget {

  final String? firstCharacterGroupName;
  final int secondListViewItemCount;
  final bool isCreateGroup;

  final Function(bool) onTapCheckbox;
  final bool selectedCheck;

  const ContactNameFirstCharacterGroupEachViewItem({
    super.key,
    required this.secondListViewItemCount,
    required this.firstCharacterGroupName,
    required this.isCreateGroup,
    required this.selectedCheck,
    required this.onTapCheckbox
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: totalHeight,
      margin: EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Adjust the shadow position
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MARGIN_MEDIUM_2,
              left: MARGIN_MEDIUM_2,
            ),
            child: Text(
              firstCharacterGroupName ?? 'Favourites(5)',
              style: TextStyle(
                fontSize: TEXT_REGULAR_2X,
                color: SECONDARY_COLOR,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ContactListView(secondListViewItemCount: secondListViewItemCount,
              isCreateGroup:isCreateGroup,
            onTapCheckbox: (selectedCheck){
            onTapCheckbox(selectedCheck);
            },
            selectedCheck: selectedCheck,
          ),
        ],
      ),
    );
  }
}

class ContactListView extends StatelessWidget {

  final bool isCreateGroup;
  final Function(bool) onTapCheckbox;
  final bool selectedCheck;

  const ContactListView({
    super.key,
    required this.secondListViewItemCount,
    required this.isCreateGroup,
    required this.onTapCheckbox,
    required this.selectedCheck
  });

  final int secondListViewItemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: secondListViewItemCount,
      itemBuilder: (BuildContext context, int index) {
        return EachContactViewItem(
          isCreateGroup: isCreateGroup,
          onTapCheckbox: (selectedCheck){
            onTapCheckbox(selectedCheck);
          },
          selectedCheck: selectedCheck,
        );
      },
    );
  }
}
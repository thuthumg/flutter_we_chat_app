import 'package:flutter/material.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/viewitems/each_contact_view_item.dart';

class ContactNameFirstCharacterGroupEachViewItem extends StatelessWidget {

  final String? firstCharacterGroupName;
  final List<UserVO>? secondListViewItem;
  final bool isCreateGroup;

  final Function(bool) onTapCheckbox;
  final bool selectedCheck;
  final Function(UserVO?) onTapContact;

  const ContactNameFirstCharacterGroupEachViewItem({
    super.key,
    required this.secondListViewItem,
    required this.firstCharacterGroupName,
    required this.isCreateGroup,
    required this.selectedCheck,
    required this.onTapCheckbox,
    required this.onTapContact
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: totalHeight,
      margin: EdgeInsets.only(left: MARGIN_SMALL,right: MARGIN_MEDIUM_2,top:MARGIN_MEDIUM_2 ),
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
              firstCharacterGroupName ?? '',
              style: const TextStyle(
                fontSize: TEXT_REGULAR_2X,
                color: SECONDARY_COLOR,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ContactListView(secondListViewItem: secondListViewItem,
              isCreateGroup:isCreateGroup,
            onTapCheckbox: (selectedCheck){
            onTapCheckbox(selectedCheck);
            },
            selectedCheck: selectedCheck,
            onTapContact: (contactUserVO){
            onTapContact(contactUserVO);
            },
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
  final Function(UserVO?)  onTapContact;

  const ContactListView({
    super.key,
    required this.secondListViewItem,
    required this.isCreateGroup,
    required this.onTapCheckbox,
    required this.selectedCheck,
    required this.onTapContact
  });

  final List<UserVO>? secondListViewItem;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: secondListViewItem?.length,
      itemBuilder: (BuildContext context, int index) {
        return EachContactViewItem(
          contactUserVO:secondListViewItem?[index],
          isCreateGroup: isCreateGroup,
          onTapCheckbox: (selectedCheck){
            onTapCheckbox(selectedCheck);
          },
          selectedCheck: selectedCheck,
          onTapContact: (userVO){
            onTapContact(userVO);
          },
        );
      },
    );
  }
}
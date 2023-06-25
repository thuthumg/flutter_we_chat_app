import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class EachGroupContactViewItem extends StatelessWidget {

  final int firstItemIndex;
  final Function onTapCreateGroup;
  final Function onTapEachGroup;

  const EachGroupContactViewItem({
    super.key,
    required this.firstItemIndex,
    required this.onTapCreateGroup,
    required this.onTapEachGroup
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

        (firstItemIndex == 0) ?
            onTapCreateGroup(): onTapEachGroup();

      },
      child: Container(
          width: 100,
          margin: const EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
          decoration: BoxDecoration(
              color: (firstItemIndex == 0)? SECONDARY_COLOR : Colors.white,
              borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // Adjust the shadow position
                ),
              ]
          ),
          child:
          Padding(
            padding: const EdgeInsets.only(
                top:MARGIN_CARD_MEDIUM_2,
                left:MARGIN_CARD_MEDIUM_2,
                right: MARGIN_CARD_MEDIUM_2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GroupImageView(groupImage: "",firstItemIndex:firstItemIndex),
                const SizedBox(height: MARGIN_MEDIUM,),
                GroupNameView(groupName: "",firstItemIndex: firstItemIndex,),

              ],
            ),
          )
      ),
    );
  }
}

class GroupNameView extends StatelessWidget {

  final String groupName;
  final int firstItemIndex;

  const GroupNameView({
    super.key,
    required this.groupName,
    required this.firstItemIndex
  });



  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        (firstItemIndex == 0)? 'Add New' : 'Smiles',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: TEXT_REGULAR,
          color: (firstItemIndex == 0)? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class GroupImageView extends StatelessWidget {

  final String groupImage;
  final int firstItemIndex;

  const GroupImageView({
    super.key,
    required this.groupImage,
    required this.firstItemIndex
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (firstItemIndex == 0)? 40 :50,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
        child: (firstItemIndex == 0)?
        Image.asset(
          'assets/contacts/group_add_icon.png',
          fit: BoxFit.cover,
         // scale: 5,
        ):
        Image.asset(
          'assets/moments/background_sample.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
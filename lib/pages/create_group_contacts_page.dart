import 'package:flutter/material.dart';
import 'package:we_chat_app/pages/qr_scan_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/utils/extensions.dart';
import 'package:we_chat_app/viewitems/name_first_character_group_group_each_view_item.dart';
import 'package:we_chat_app/widgets/custom_button_widget.dart';
import 'package:we_chat_app/widgets/edit_text_widget.dart';
import 'package:we_chat_app/widgets/search_box_widget.dart';

class CreateGroupContactsPage extends StatelessWidget{
  const CreateGroupContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CHAT_PAGE_BG_COLOR,
      appBar: CreateGroupContactsCustomAppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: MARGIN_CARD_MEDIUM_2),
              child: EditTextWidget(
                editTextName: "Group1",
                editTextType: "text",
                hintTextName: 'Group Name',
                isGroupNameText: true,
                isSecure: false,
                onChanged: (groupName){
                  //?
                },
              ),
            ),

            ///Search contact section view
            SearchBoxWidget(onSearch: (searchText){},),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(child:
                ContactNameFirstCharacterGroupContactListView()),
                Positioned(
                    right:0,
                    child: Image.asset('assets/contacts/contacts_letter_view_pic.png'),
          )
              ],
            ),
          )



          ],
        ),
      ),
    );
  }

}

class ContactNameFirstCharacterGroupContactListView extends StatefulWidget {

  const ContactNameFirstCharacterGroupContactListView({
    super.key,
  });

  @override
  State<ContactNameFirstCharacterGroupContactListView> createState() => _ContactNameFirstCharacterGroupContactListViewState();
}

class _ContactNameFirstCharacterGroupContactListViewState extends State<ContactNameFirstCharacterGroupContactListView> {
  @override
  Widget build(BuildContext context) {
    bool selectedContact = false;
    return Padding(
      padding: const EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3, // Only one item to display
        itemBuilder: (BuildContext context, int index) {
          final secondListViewItemCount =
          3; // Replace with your actual item count
          return ContactNameFirstCharacterGroupEachViewItem(
            secondListViewItem: null,
            firstCharacterGroupName: "A",
          isCreateGroup: true,
          onTapCheckbox: (selectedCheck){
              setState(() {
                debugPrint("selectedCheck $selectedCheck");
                selectedContact = selectedCheck;
              });
          },
            selectedCheck: selectedContact,
            onTapContact: (userVO)
            {
              //?
            },
          );
        },
      ),
    );
  }
}


class CreateGroupContactsCustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  const CreateGroupContactsCustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: PRIMARY_COLOR,
      title: const Text(
        'New Group',
        style: TextStyle(
          fontSize: TEXT_HEADING_1X,
          color: SECONDARY_COLOR,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(
          top: MARGIN_CARD_MEDIUM_2,
          left: MARGIN_CARD_MEDIUM_2,
          bottom: MARGIN_CARD_MEDIUM_2,
        ),
        child: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/moments/dismiss_btn.png',
            scale: 3,
          ),
        ),
      ),
      actions: [
        CreateGroupBtnView()
      ],
    );
  }

}
class CreateGroupBtnView extends StatelessWidget {
  const CreateGroupBtnView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: MARGIN_CARD_MEDIUM_2, bottom: MARGIN_CARD_MEDIUM_2),
      child: CustomButtonWidget(
        buttonText: 'Create',
        buttonTextColor: Colors.white,
        buttonBackground: SECONDARY_COLOR,
        buttonBorderColor: SECONDARY_COLOR,
        buttonHeight: 0.0,
        buttonWidth: 70,
        onTapButton: () {
          //to save data at firebase
        },
      ),
    );
  }
}

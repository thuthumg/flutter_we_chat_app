import 'package:flutter/material.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/pages/chat_detail_page.dart';
import 'package:we_chat_app/pages/create_group_contacts_page.dart';
import 'package:we_chat_app/pages/qr_scan_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/utils/extensions.dart';
import 'package:we_chat_app/viewitems/each_contact_view_item.dart';
import 'package:we_chat_app/viewitems/each_group_contact_view_item.dart';
import 'package:we_chat_app/viewitems/name_first_character_group_group_each_view_item.dart';
import 'package:we_chat_app/widgets/search_box_widget.dart';

class ContactsPage extends StatelessWidget {

  final UserVO? userVO;

  ContactsPage({super.key,required this.userVO});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CHAT_PAGE_BG_COLOR,
      appBar: const ContactsCustomAppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Search contact section view
            SearchBoxWidget(
              onSearch: (searchText) {},
            ),
            const Expanded(child: GroupSectionAndContactsListView()),
          ],
        ),
      ),
    );
  }
}

class ContactsCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  const ContactsCustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PRIMARY_COLOR,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          ContactTitleTextView(),
          ContactsTotalCountView(
            contactCount: 0,
          ),
        ],
      ),
      actions: [
        ContactAddView(
          onTapAddContact: () {
            navigateToScreen(context, QRScanPage(),false);
          },
        )
      ],
    );
  }
}

class ContactAddView extends StatelessWidget {
  final Function onTapAddContact;

  const ContactAddView({super.key, required this.onTapAddContact});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onTapAddContact();
        },
        child: Image.asset(
          'assets/contacts/contacts_add_btn.png',
          scale: 3,
        ));
  }
}

class ContactTitleTextView extends StatelessWidget {
  const ContactTitleTextView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Contacts',
      style: TextStyle(
        fontSize: TEXT_HEADING_2X,
        color: SECONDARY_COLOR,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class ContactsTotalCountView extends StatelessWidget {
  final int contactCount;

  const ContactsTotalCountView({super.key, required this.contactCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MARGIN_SMALL),
      child: Text(
        '($contactCount)',
        style: const TextStyle(
          fontSize: TEXT_REGULAR,
          color: TEXT_FIELD_HINT_TXT_COLOR,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class GroupSectionAndContactsListView extends StatelessWidget {
  const GroupSectionAndContactsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return
      //SingleChildScrollView(
     // physics: ScrollPhysics(),
     // child:
      SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Group section view
            const CreateGroupAndGroupContactsListView(groupCount: 0, groupList: []),

            /// Contacts List (group by nameFirstcharacter) section view
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
           // Expanded(child: ContactNameFirstCharacterGroupContactListView())
          ],
        ),
      );
   // );
  }
}

class ContactNameFirstCharacterGroupContactListView extends StatelessWidget {
  const ContactNameFirstCharacterGroupContactListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3, // Only one item to display
        itemBuilder: (BuildContext context, int index) {
          final secondListViewItemCount =
              5; // Replace with your actual item count
          return ContactNameFirstCharacterGroupEachViewItem(
              secondListViewItemCount: secondListViewItemCount,
          firstCharacterGroupName: "A",
          isCreateGroup: false,
          onTapCheckbox: (selectedCheck){},
          selectedCheck: false,);
        },
      ),
    );
  }
}


class CreateGroupAndGroupContactsListView extends StatelessWidget {
  final int groupCount;
  final List<String> groupList;

  const CreateGroupAndGroupContactsListView(
      {super.key, required this.groupCount, required this.groupList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupTextAndCountView(
          groupCount: groupCount,
        ),
        const GroupContactsListView(
          groupList: [],
        )
      ],
    );
  }
}

class GroupTextAndCountView extends StatelessWidget {
  final int groupCount;

  const GroupTextAndCountView({super.key, required this.groupCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MARGIN_CARD_MEDIUM_2),
      child: Text(
        'Groups($groupCount)',
        style: const TextStyle(
          fontSize: TEXT_REGULAR_1X,
          color: SECONDARY_COLOR,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class GroupContactsListView extends StatelessWidget {
  final List<String> groupList;

  const GroupContactsListView({super.key, required this.groupList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return EachGroupContactViewItem(
              firstItemIndex: index,
              onTapCreateGroup: () {
                navigateToScreen(context, CreateGroupContactsPage(),false);
              },
              onTapEachGroup: () {
                navigateToScreen(context, ChatDetailPage(),false);
              },
            );
          }),
    );
  }
}

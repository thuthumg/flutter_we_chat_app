import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/contacts_page_bloc.dart';
import 'package:we_chat_app/data/vos/chat_group_vo.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/pages/chat_detail_page.dart';
import 'package:we_chat_app/pages/create_group_contacts_page.dart';
import 'package:we_chat_app/pages/qr_scan_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/utils/extensions.dart';
import 'package:we_chat_app/viewitems/each_group_contact_view_item.dart';
import 'package:we_chat_app/viewitems/name_first_character_group_group_each_view_item.dart';
import 'package:we_chat_app/widgets/search_box_widget.dart';

class ContactsPage extends StatelessWidget {

  final UserVO? userVO;

  ContactsPage({super.key,required this.userVO});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactsPageBloc(),
      child: Consumer<ContactsPageBloc>(
        builder: (context, bloc, child) => Scaffold(
          backgroundColor: CHAT_PAGE_BG_COLOR,
          appBar: ContactsCustomAppBar(contactsPageBloc: bloc),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Search contact section view
                SearchBoxWidget(
                  hintText: "Search Contacts.....",
                  onSearch: (searchText) {
                    bloc.searchContacts(searchText,"contactsList");
                  },
                ),
                Expanded(child: GroupSectionAndContactsListView(
                    contactsPageBloc: bloc)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContactsCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  ContactsPageBloc contactsPageBloc;

  ContactsCustomAppBar({
    super.key,
    required this.contactsPageBloc
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PRIMARY_COLOR,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const ContactTitleTextView(),
          ContactsTotalCountView(
            contactCount:
            contactsPageBloc.userMap.length,
            // (contactsPageBloc.filteredMap.length == 0)?
            // contactsPageBloc.userMap.length : contactsPageBloc.filteredMap.length,
          ),
        ],
      ),
      actions: [
        ContactAddView(
          onTapAddContact: () {
            navigateToScreen(context, QRScanPage(contactsPageBloc:contactsPageBloc),false);
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

  final ContactsPageBloc contactsPageBloc;

  const GroupSectionAndContactsListView({
    super.key,
    required this.contactsPageBloc
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
            CreateGroupAndGroupContactsListView(groupCount: contactsPageBloc.mGroupContactsList?.length??0,
                groupList: contactsPageBloc.mGroupContactsList),

            /// Contacts List (group by nameFirstcharacter) section view
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(child:
                  ContactNameFirstCharacterGroupContactListView(
                      contactsPageBloc: contactsPageBloc)),
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

  final ContactsPageBloc contactsPageBloc;

  const ContactNameFirstCharacterGroupContactListView({
    super.key,
    required this.contactsPageBloc
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount:
        // (contactsPageBloc.filteredMap == {})?
        // contactsPageBloc.userMap.length : contactsPageBloc.filteredMap.length,

        contactsPageBloc.userMap.length, // Only one item to display
        itemBuilder: (BuildContext context, int index) {


          String group =
          contactsPageBloc.userMap.keys.elementAt(index);
          List<UserVO>? users =
          contactsPageBloc.userMap[group];

          //
          // String group =  (contactsPageBloc.filteredMap == {})?
          // contactsPageBloc.userMap.keys.elementAt(index) : contactsPageBloc.filteredMap.keys.elementAt(index);
          // List<UserVO>? users = (contactsPageBloc.filteredMap == {})?
          // contactsPageBloc.userMap[group] : contactsPageBloc.filteredMap[group];

          return ContactNameFirstCharacterGroupEachViewItem(
            bloc: contactsPageBloc,
              secondListViewItem: users,
          firstCharacterGroupName: group,
          isCreateGroup: false,
          onTapCheckbox: (selectedCheck){},
          selectedCheck: false,
          onTapContact: (contactUserVO){
            navigateToScreen(context, ChatDetailPage(
              chatUserProfile: contactUserVO?.profileUrl??"",
              chatUserName: contactUserVO?.userName??"",
              chatUserId: contactUserVO?.id??"",
              isGroupChat: false,
            ),false);
          }
          );
        },
      ),
    );
  }
}


class CreateGroupAndGroupContactsListView extends StatelessWidget {
  final int groupCount;
  final List<ChatGroupVO>? groupList;

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
        GroupContactsListView(
          groupList: groupList,
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
  final List<ChatGroupVO>? groupList;

  const GroupContactsListView({super.key, required this.groupList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: groupList?.length,
          itemBuilder: (BuildContext context, int index) {
            return EachGroupContactViewItem(
              chatGroupVO: groupList?[index],
              firstItemIndex: index,
              onTapCreateGroup: () {
                navigateToScreen(context, CreateGroupContactsPage(),false);
              },
              onTapEachGroup: () {
                navigateToScreen(context,  ChatDetailPage(
                  chatUserProfile:  groupList?[index].profileUrl??"",
                  chatUserName: groupList?[index].name??"",
                  chatUserId: groupList?[index].id??"",
                  isGroupChat: true,
                ),false);
              },
            );
          }),
    );
  }
}

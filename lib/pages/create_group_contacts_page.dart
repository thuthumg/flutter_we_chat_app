import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/components/profile_img_with_active_status_view.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/pages/qr_scan_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/utils/extensions.dart';
import 'package:we_chat_app/viewitems/name_first_character_group_group_each_view_item.dart';
import 'package:we_chat_app/widgets/custom_button_widget.dart';
import 'package:we_chat_app/widgets/edit_text_widget.dart';
import 'package:we_chat_app/widgets/photo_upload_dialog_widget.dart';
import 'package:we_chat_app/widgets/search_box_widget.dart';

import '../blocs/contacts_page_bloc.dart';

class CreateGroupContactsPage extends StatelessWidget{
  const CreateGroupContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactsPageBloc(),
      child: Consumer<ContactsPageBloc>(
        builder: (context, bloc, child) => Scaffold(
          backgroundColor: CHAT_PAGE_BG_COLOR,
          appBar: CreateGroupContactsCustomAppBar(bloc:bloc),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UploadGroupPhotoView(
                    onTapUploadProfile: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _photoUploadDialog(context, bloc),
                      );
                    },
                    contactsPageBloc: bloc),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: MARGIN_CARD_MEDIUM_2),
                  child: EditTextWidget(
                    editTextName: bloc.groupName ?? '',
                    editTextType: "text",
                    hintTextName: 'Group Name',
                    isGroupNameText: true,
                    isSecure: false,
                    onChanged: (groupName){
                      bloc.groupNameTextChanged(groupName);
                    },
                  ),
                ),

                ///Search contact section view

                SearchBoxWidget(onSearch: (searchText){

                  bloc.searchContacts(searchText,"createGroup");

                },),
              Visibility(
                  visible: (bloc.selectedContactList.length > 0)? true:false,
                  child:
              SelectedContactListView(bloc:bloc,onTapRemoveSelectedContact: (userVO){
                bloc.onTapContactSelected(userVO);
              },)
              )
             ,


              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(child:
                    ContactNameFirstCharacterGroupContactListView(createGroupContactsPageBloc:bloc)),
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
        ),
      ),
    );
  }

}

Widget _photoUploadDialog(BuildContext context, ContactsPageBloc bloc) {
  return PhotoUploadDialogWidget(
    onTapCamera: () {
      _takePhotoFromCamera(bloc);
      Navigator.pop(context);
    },
    onTapGallery: () {
      _choosePhotoFromGallery(bloc);
      Navigator.pop(context);
    },
  );
}

Future<void> _takePhotoFromCamera(ContactsPageBloc bloc) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(
      source: ImageSource.camera);
  if (image != null) {
    bloc.onImageChosen(File(image.path));
  }
}

Future<void> _choosePhotoFromGallery(ContactsPageBloc bloc) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery);
  if (image != null) {
    bloc.onImageChosen(File(image.path));
  }
}

class UploadGroupPhotoView extends StatelessWidget {
  ContactsPageBloc contactsPageBloc;
  final Function onTapUploadProfile;

  UploadGroupPhotoView({
    super.key,
    required this.onTapUploadProfile,
    required this.contactsPageBloc
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsPageBloc>(
      builder: (context, bloc, child) =>
          GestureDetector(
            onTap: () {
              onTapUploadProfile();
            },
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child:
                  (contactsPageBloc.chosenImageFile == null) ?
                  Container(
                    margin: EdgeInsets.only(top: MARGIN_CARD_MEDIUM_2),
                    child: CircleAvatar(
                      backgroundColor: SUMBITED_PIN_THEME_COLOR,
                      radius: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/splash/logo.png'),
                      ),
                    ),
                  )

                      :
                  Container(
                    margin: EdgeInsets.only(top: MARGIN_CARD_MEDIUM_2),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(
                          contactsPageBloc.chosenImageFile ?? File("")),
                    ),
                  )
                  ,
                ),

                /* const CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    backgroundImage:
                    AssetImage('assets/splash/logo.png',),
                  )*/
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,

                    child:
                    Container(
                      color: Colors.transparent,
                      child: Image.asset(
                        'assets/register/profile_upload_pic.png',
                        scale: 2,),
                    )

                )
              ],
            ),
          ),
    );
  }
}
class SelectedContactListView extends StatelessWidget {

  final Function(UserVO?) onTapRemoveSelectedContact;
  final ContactsPageBloc bloc;
  const SelectedContactListView({
    super.key,
    required this.bloc,
    required this.onTapRemoveSelectedContact
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(left: MARGIN_CARD_MEDIUM_2),
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
       // shrinkWrap: true,
       // physics: NeverScrollableScrollPhysics(),
        itemCount: bloc.selectedContactList.length, // Only one item to display
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            alignment: Alignment.center,
            children: [
             Container(
                margin: EdgeInsets.only(top: MARGIN_MEDIUM,right: MARGIN_MEDIUM),
                width: 90,
                height: 120,
                decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius: BorderRadius.circular(MARGIN_MEDIUM), // Corner radius
                boxShadow: [
                BoxShadow(
                color: Colors.black.withOpacity(0.5), // Shadow color
                blurRadius: 5, // Spread radius
                offset: Offset(0, 3), // Shadow offset
                ),
                ],
                ),
                child:  Padding(
                  padding: const EdgeInsets.all(MARGIN_MEDIUM_2),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfileImgWithActiveStatusView(
                        chatUserProfile:bloc.selectedContactList[index]?.profileUrl??"" ,),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            bloc.selectedContactList[index]?.userName??"",
                            style: TextStyle(
                              fontSize: TEXT_SMALL,
                              color: SECONDARY_COLOR,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                ),

              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                      onTap: (){
                        bloc.selectedContactList[index]?.isSelected =  (!(bloc.selectedContactList[index]?.isSelected)!);
                        onTapRemoveSelectedContact(bloc.selectedContactList[index]);
                      },
                      child: Image.asset('assets/contacts/remove_selected_icon.png',scale: 2,))),

            ],
          );
        },
      ),
    );
  }
}

class ContactNameFirstCharacterGroupContactListView extends StatelessWidget {

  final ContactsPageBloc createGroupContactsPageBloc;

  const ContactNameFirstCharacterGroupContactListView({
    super.key,
    required this.createGroupContactsPageBloc
  });

  @override
  Widget build(BuildContext context) {
    bool selectedContact = false;
    return Padding(
      padding: const EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: createGroupContactsPageBloc.userMap.length, // Only one item to display
        itemBuilder: (BuildContext context, int index) {

          String group =  createGroupContactsPageBloc.userMap.keys.elementAt(index);
          List<UserVO>? users = createGroupContactsPageBloc.userMap[group];


          return ContactNameFirstCharacterGroupEachViewItem(
            bloc: createGroupContactsPageBloc,
            secondListViewItem: users,
            firstCharacterGroupName: group,
            isCreateGroup: true,
            onTapCheckbox: (selectedCheck){

            },
            selectedCheck: selectedContact,
            onTapContact: (userVO)
            {
              debugPrint("check user vo contact status ${userVO?.isSelected}");
             createGroupContactsPageBloc.onTapContactSelected(userVO);
            },
          );
        },
      ),
    );
  }
}

class CreateGroupContactsCustomAppBar extends StatelessWidget implements PreferredSizeWidget{
 final ContactsPageBloc bloc;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  const CreateGroupContactsCustomAppBar({
    super.key,
    required this.bloc
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
        CreateGroupBtnView(bloc:bloc)
      ],
    );
  }

}
class CreateGroupBtnView extends StatelessWidget {

  final ContactsPageBloc bloc;

  const CreateGroupBtnView({
    super.key,
    required this.bloc
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
          bloc.createChatGroup();
          Navigator.pop(context);
        },
      ),
    );
  }
}

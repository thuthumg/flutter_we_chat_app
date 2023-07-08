
import 'package:flutter/material.dart';
import 'package:we_chat_app/blocs/contacts_page_bloc.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class EachContactViewItem extends StatelessWidget {

  final bool isCreateGroup;
  final Function(bool) onTapCheckbox;
  final bool selectedCheck;
  final UserVO? contactUserVO;
  final Function(UserVO?) onTapContact;
  final ContactsPageBloc bloc;

  const EachContactViewItem({
    super.key,
    required this.isCreateGroup,
    required this.onTapCheckbox,
    required this.selectedCheck,
    required this.contactUserVO,
    required this.onTapContact,
    required this.bloc
  });
  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
    return
      GestureDetector(
      onTap: (){
        contactUserVO?.isSelected = (!(contactUserVO?.isSelected??false));
        onTapContact(contactUserVO);
      },
      child: Container(
        margin:
        const EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ContactProfileImgView(contactProfile: contactUserVO?.profileUrl??"",),
                const SizedBox(
                  width: MARGIN_CARD_MEDIUM_2,
                ),
                ContactNameView(contactName: contactUserVO?.userName??"",),
              ],
            ),
            isCreateGroup ? Align(
                alignment: Alignment.centerRight,
                child:
                Container(
                  child: contactUserVO?.isSelected??false ?
                  Image.asset('assets/contacts/contact_selected_icon.png',scale: 2,):
                  Image.asset('assets/contacts/contact_unselected_icon.png',scale: 2,),
                )



/*

              SizedBox(
                height: CHECK_BOX_SIZE_HEIGHT,
                width: CHECK_BOX_SIZE_WIDTH,
                child: Theme(
                  data: ThemeData(
                    unselectedWidgetColor: SECONDARY_COLOR, // Change the unselected checkbox color
                    checkboxTheme: CheckboxThemeData(
                      fillColor: MaterialStateColor.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return SECONDARY_COLOR; // Change the selected checkbox color
                        }
                        return Colors.grey; // Change the default checkbox color
                      }),
                    ),
                  ),
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (newValue) {
                      debugPrint("check newValue $newValue");
                      setState(() {
                        debugPrint("check newValue $newValue");
                       // isChecked = newValue ?? false;
                      });
                    },
                  ),
                ),
              )*/
              // Checkbox(
              //   value: widget.selectedCheck,
              //   onChanged: (newValue) {
              //     debugPrint("onchange");
              //     widget.onTapCheckbox(newValue ?? false);
              //
              //     // setState(() {
              //     //   debugPrint("set state change");
              //     //   isChecked = newValue ?? false;
              //     // });
              //   },
              // )
              //     Checkbox(
              //    // checkColor: Colors.white,
              //     fillColor: MaterialStateProperty.resolveWith(
              //             (states) {
              //           // If the button is pressed, return green, otherwise blue
              //           if (states.contains(MaterialState.pressed)) {
              //             return Colors.green;
              //           }
              //           return Colors.blue;
              //         }
              //     ),
              //     value: isChecked,
              //     shape: CircleBorder(),
              //     onChanged: (bool? value) {
              //       debugPrint("onchange");
              //       setState(() {
              //         debugPrint("onchange set state");
              //         isChecked = value!;
              //       });
              //     },
              // ),
            ) : Container()
            // Center(
            //     child: InkWell(
            //       onTap: () {
            //         setState(() {
            //           _value = !_value;
            //         });
            //       },
            //       child: Container(
            //       //  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            //         child: Padding(
            //           padding: const EdgeInsets.all(10.0),
            //           child: _value?
            //           Icon(
            //             Icons.check,
            //             size: 30.0,
            //             color: Colors.white,
            //           )
            //               : Icon(
            //             Icons.check_box_outline_blank,
            //             size: 30.0,
            //             color: Colors.blue,
            //           ),
            //         ),
            //       ),
            //     ))

          ],
        ),
      ),
    );
  }
}

class ContactProfileImgView extends StatelessWidget {

  final String contactProfile;

  const ContactProfileImgView({
    super.key,
    required this.contactProfile
  });

  @override
  Widget build(BuildContext context) {
    return
      (contactProfile == "")?
      Container(
        color: Colors.white,
        child: CircleAvatar(
          backgroundColor: SUMBITED_PIN_THEME_COLOR,
          radius: ACTIVE_NOW_CHAT_ITEM_PROFILE_RADIUS,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/splash/logo.png'),
          ),
        ),
      )
     :CircleAvatar(
        radius: ACTIVE_NOW_CHAT_ITEM_PROFILE_RADIUS,
        backgroundImage:
        NetworkImage(contactProfile),
      );



/*
    const CircleAvatar(
      radius: ACTIVE_NOW_CHAT_ITEM_PROFILE_RADIUS,
      backgroundImage:
      AssetImage('assets/moments/profile_sample.jpg'),
    ):*/
  }
}

class ContactNameView extends StatelessWidget {

  final String contactName;

  const ContactNameView({
    super.key,
    required this.contactName
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      contactName,
      style: const TextStyle(
        fontSize: TEXT_REGULAR_2X,
        color: SECONDARY_COLOR,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
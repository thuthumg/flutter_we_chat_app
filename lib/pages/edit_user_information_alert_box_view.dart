import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/edit_profile_bloc.dart';
import 'package:we_chat_app/blocs/profile_page_bloc.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/widgets/custom_button_widget.dart';
import 'package:we_chat_app/widgets/date_of_birth_drop_down_widget.dart';
import 'package:we_chat_app/widgets/edit_text_widget.dart';
import 'package:we_chat_app/widgets/gender_radio_button_widget.dart';

class EditUserInformationAlertBoxView extends StatelessWidget {
  UserVO userVO;

  EditUserInformationAlertBoxView({required this.userVO});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditProfileBloc(userVO),
      child: Consumer<EditProfileBloc>(
        builder: (context, bloc, child) => AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: SECONDARY_COLOR),
            borderRadius: BorderRadius.all(
              Radius.circular(MARGIN_SMALL),
            ),
          ),
          backgroundColor: PRIMARY_COLOR,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Name Edit Text section
                EditTextWidget(
                  isSecure: false,
                  editTextName: bloc.name ?? '',
                  editTextType: "text",
                  hintTextName: NAME_TXT,
                  isGroupNameText: false,
                  onChanged: (name) {
                    bloc.onNameChanged(name);
                  },
                ),
                const SizedBox(
                  height: MARGIN_LARGE,
                ),

                ///Phone number section
                EditTextWidget(
                  isSecure: false,
                  editTextName: bloc.phoneNum ?? '',
                  editTextType: "number",
                  hintTextName: 'Phone Number',
                  isGroupNameText: false,
                  onChanged: (phoneNum) {
                    bloc.onPhoneNumChanged(phoneNum);
                  },
                ),
                const SizedBox(
                  height: MARGIN_LARGE,
                ),

                ///Date of Birth section
                const Text(
                  DATE_OF_BIRTH_TXT,
                  style: TextStyle(
                    fontSize: TEXT_REGULAR_1X,
                    color: TEXT_FIELD_HINT_TXT_COLOR,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DateOfBirthDropDownWidget(
                  strDay: bloc.selectedDay,
                  strMonth: bloc.selectedMonth,
                  strYear: bloc.selectedYear,
                  onTapDay: (selectedDay) {
                    bloc.onDayChanged(selectedDay);
                  },
                  onTapMonth: (selectedMonth) {
                    bloc.onMonthChanged(selectedMonth);
                  },
                  onTapYear: (selectedYear) {
                    bloc.onYearChanged(selectedYear);
                  },
                ),
                const SizedBox(
                  height: MARGIN_LARGE,
                ),

                ///Gender section
                const Text(
                  GENDER_TXT,
                  style: TextStyle(
                    fontSize: TEXT_REGULAR_1X,
                    color: TEXT_FIELD_HINT_TXT_COLOR,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GenderRadioButtonWidget(
                  genderType: bloc.genderType,
                  onTapGender: (selectedGenderType) {
                    bloc.genderType = selectedGenderType;
                  },
                ),
                const SizedBox(
                  height: MARGIN_LARGE,
                ),

                Row(
                  children: [
                    CustomButtonWidget(
                      buttonText: 'Cancel',
                      buttonTextColor: SECONDARY_COLOR,
                      buttonBackground: Colors.white,
                      buttonBorderColor: SECONDARY_COLOR,
                      buttonHeight: 40,
                      buttonWidth: 100,
                      onTapButton: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CustomButtonWidget(
                      buttonText: 'Save',
                      buttonTextColor: Colors.white,
                      buttonBackground: SECONDARY_COLOR,
                      buttonBorderColor: SECONDARY_COLOR,
                      buttonHeight: 40,
                      buttonWidth: 100,
                      onTapButton: () {

                        bloc.onTapSignUp(bloc.phoneNum, bloc.email).then((value){
                          Navigator.pop(context);


                        });

                      },
                    )
                  ],
                )
              ],
            ),
          ),
          actions: [
            ///Sign Up button click section
          ],
        ),
      ),
    );
  }
}

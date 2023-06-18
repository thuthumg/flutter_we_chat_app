import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/sign_up_page_bloc.dart';
import 'package:we_chat_app/pages/login_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/utils/extensions.dart';
import 'package:we_chat_app/widgets/agree_to_terms_and_service_widget.dart';
import 'package:we_chat_app/widgets/custom_button_widget.dart';
import 'package:we_chat_app/widgets/date_of_birth_drop_down_widget.dart';
import 'package:we_chat_app/widgets/edit_text_widget.dart';
import 'package:we_chat_app/widgets/gender_radio_button_widget.dart';
import 'package:we_chat_app/widgets/loading_view.dart';
import 'package:we_chat_app/widgets/photo_upload_dialog_widget.dart';
import 'package:we_chat_app/widgets/text_field_error_section.dart';

class SignUpPage extends StatelessWidget {

  final String phoneNum;
  final String email;

  const SignUpPage({super.key,
    required this.phoneNum,
    required this.email});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpPageBloc(phoneNumber: phoneNum),
      child: Consumer<SignUpPageBloc>(
        builder: (context, bloc, child) =>
            Scaffold(
              body: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: PRIMARY_COLOR,
                    child: Stack(
                      children: [

                        ///Back button section
                        Positioned(
                          // left: 0.0,
                          left: 0.0,
                          top: 0.0,
                          //   bottom: 0.0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: MARGIN_XXLARGE, left: MARGIN_LARGE),
                              child: Image.asset('assets/left_button.png'),
                            ),
                          ),),

                        ///background image view section
                        Positioned(
                          // left: 0.0,
                          right: 0.0,
                          top: 0.0,
                          //   bottom: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: MARGIN_XLARGE),
                            child: Image.asset(
                              'assets/register/first_half_circle.png',
                              scale: 3,),
                          ),),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: MARGIN_MEDIUM_3),
                            child: Image.asset(
                              'assets/register/second_half_circle.png',
                              scale: 3,),
                          ),),
                        Positioned(
                          right: 0.0,
                          bottom: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: MARGIN_MEDIUM_3, right: MARGIN_MEDIUM_3),
                            child: Image.asset('assets/register/wave_icon.png',
                              scale: 1,),
                          ),),
                        Positioned(
                          left: 0.0,
                          bottom: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: MARGIN_MEDIUM_3, left: MARGIN_MEDIUM_3),
                            child: Image.asset('assets/register/triangle_icon.png',
                              scale: 4,),
                          ),),

                        ///Form view section
                        Positioned(
                            left: 0.0,
                            right: 0.0,
                            top: 100.0,
                            bottom: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: MARGIN_XXLARGE, right: MARGIN_LARGE),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    ///Title section
                                    TitleSectionView(),

                                    ///ProfileSection
                                    ProfileUploadSectionView(
                                      signUpPageBloc: bloc,
                                      onTapUploadProfile: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _photoUploadDialog(context, bloc),
                                        );
                                      },
                                    ),

                                    ///Name Edit Text section
                                    NameTextFieldSectionView(bloc:bloc),

                                    ///Date of Birth section
                                    DateOfBirthSectionView(bloc:bloc),

                                    ///Gender section
                                    GenderTypeSectionView(bloc:bloc),

                                    ///password edit text section
                                    PasswordTextFieldSectionView(bloc:bloc),

                                    ///terms and service selected section
                                    AgreeTermAndServiceSectionView(),

                                    ///Sign Up button click section
                                    SignUpSectionView(
                                      bloc: bloc,
                                      phoneNum: phoneNum,
                                      email: email,),


                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Visibility(
                        visible: bloc.isLoading,
                        child: Container(
                          // color: Colors.transparent,
                          child: Center(
                            child: LoadingView(),
                          ),
                        ),)
                  )
                ],
              ),
            ),
      ),
    );
  }

}

Widget _photoUploadDialog(BuildContext context, SignUpPageBloc bloc) {
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

Future<void> _takePhotoFromCamera(SignUpPageBloc bloc) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(
      source: ImageSource.camera);
  if (image != null) {
    bloc.onImageChosen(File(image.path));
  }
}

Future<void> _choosePhotoFromGallery(SignUpPageBloc bloc) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery);
  if (image != null) {
    bloc.onImageChosen(File(image.path));
  }
}

class ProfileUploadSectionView extends StatelessWidget {
  SignUpPageBloc signUpPageBloc;
  final Function onTapUploadProfile;

  ProfileUploadSectionView({
    super.key,
    required this.onTapUploadProfile,
    required this.signUpPageBloc
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpPageBloc>(
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
                  (signUpPageBloc.chosenImageFile == null) ?
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage:
                    AssetImage('assets/moments/profile_sample.jpg'),
                  ) :
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(
                        signUpPageBloc.chosenImageFile ?? File("")),
                  )
                  ,
                ),
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

class AgreeTermAndServiceSectionView extends StatelessWidget {
  const AgreeTermAndServiceSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        AgreeToTermsAndServiceWidget(),
        SizedBox(
          height: MARGIN_XLARGE,
        ),
      ],
    );
  }
}

class PasswordTextFieldSectionView extends StatelessWidget {

  SignUpPageBloc bloc;

  PasswordTextFieldSectionView({
    super.key,
    required this.bloc
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditTextWidget(
          isSecure: true,
          editTextName: "",
          editTextType: "password",
          hintTextName: PASSWORD_TXT,
          isGroupNameText: false,
          onChanged: (password) {
            bloc.onPasswordChanged(password);
          },
        ),
        const TextFieldErrorSection(errorMsg: "Please enter your password"),
      ],
    );
  }
}

class GenderTypeSectionView extends StatelessWidget {

  SignUpPageBloc bloc;

  GenderTypeSectionView({
    super.key,
    required this.bloc

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          GENDER_TXT,
          style: TextStyle(
            fontSize: TEXT_REGULAR_1X,
            color: TEXT_FIELD_HINT_TXT_COLOR,
            fontWeight: FontWeight.w400,
          ),
        ),
        GenderRadioButtonWidget(
          onTapGender: (selectedGenderType){
            bloc.genderType = selectedGenderType;
          },
        ),
        const TextFieldErrorSection(errorMsg: "Please Gender Type"),
      ],
    );
  }
}

class DateOfBirthSectionView extends StatelessWidget {

  SignUpPageBloc bloc;

  DateOfBirthSectionView({
    super.key,
    required this.bloc
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          DATE_OF_BIRTH_TXT,
          style: TextStyle(
            fontSize: TEXT_REGULAR_1X,
            color: TEXT_FIELD_HINT_TXT_COLOR,
            fontWeight: FontWeight.w400,
          ),
        ),
        DateOfBirthDropDownWidget(
          onTapDay: (selectedDay){
            bloc.onDayChanged(selectedDay);
          },
          onTapMonth: (selectedMonth){
            bloc.onMonthChanged(selectedMonth);
          },
          onTapYear: (selectedYear){
            bloc.onYearChanged(selectedYear);
          },
        ),
        const TextFieldErrorSection(
            errorMsg: "Please Choose Your Date of Birth"),
        const SizedBox(
          height: MARGIN_LARGE,
        ),
      ],
    );
  }
}

class TitleSectionView extends StatelessWidget {
  const TitleSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ///Title
        const Text(
          HI_TXT,
          style: TextStyle(
            fontSize: HI_TXT_FONT_SIZE,
            color: SECONDARY_COLOR,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: MARGIN_MEDIUM,
        ),

        ///SubTitle
        const Text(
          CREATE_NEW_ACCOUNT_TXT,
          style: TextStyle(
            fontSize: TEXT_REGULAR_1X,
            color: CREATE_NEW_ACCOUNT_TXT_COLOR,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: MARGIN_XLARGE,
        )
      ],
    );
  }
}

class NameTextFieldSectionView extends StatelessWidget {

  SignUpPageBloc bloc;

  NameTextFieldSectionView({
    super.key,
    required this.bloc
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditTextWidget(
          isSecure: false,
          editTextName: "",
          editTextType: "text",
          hintTextName: NAME_TXT,
          isGroupNameText: false,
          onChanged: (name) {
            bloc.onNameChanged(name);
          },
        ),
        const TextFieldErrorSection(errorMsg: "Please Enter Your Name"),
        const SizedBox(
          height: MARGIN_LARGE,
        ),
      ],
    );
  }
}

class SignUpSectionView extends StatelessWidget {
  SignUpPageBloc bloc;
  final String phoneNum;
  final String email;

  SignUpSectionView({
    super.key,
    required this.bloc,
    required this.phoneNum,
    required this.email
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButtonWidget(
        buttonText: SIGN_UP_TXT,
        buttonTextColor: Colors.white,
        buttonBackground: SECONDARY_COLOR,
        buttonBorderColor: SECONDARY_COLOR,
        buttonHeight: 50,
        buttonWidth: 150,
        onTapButton: () {
          bloc.onTapSignUp(phoneNum, email).then((value){
            Navigator.pop(context);
            Navigator.pop(context);
            navigateToScreen(context, LoginPage(),true);

          } );

        },
      ),
    );
  }
}

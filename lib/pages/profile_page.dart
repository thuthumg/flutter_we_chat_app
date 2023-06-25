import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/profile_page_bloc.dart';
import 'package:we_chat_app/components/moments_list_view.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/pages/edit_user_information_alert_box_view.dart';
import 'package:we_chat_app/pages/qr_generate_view.dart';
import 'package:we_chat_app/pages/show_qr_generate_view_pop_up.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class ProfilePage extends StatelessWidget {

  final UserVO? userVO;

  const ProfilePage({super.key,required this.userVO});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          ProfilePageBloc(userVO),
      child: Consumer<ProfilePageBloc>(
        builder: (context, bloc, child) => Scaffold(
          backgroundColor: CHAT_PAGE_BG_COLOR,
          appBar: ProfilePageAppBarView(userVO: userVO),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///show login user information section view
                LoginUserInformationView(bloc: bloc),

                ///bookmark moment list view
                BookmarkMomentsListView(bloc:bloc)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePageAppBarView extends StatelessWidget
    implements PreferredSizeWidget {

  UserVO? userVO;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  ProfilePageAppBarView({
    super.key,
    required this.userVO
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PRIMARY_COLOR,
      automaticallyImplyLeading: false,
      title: const Text(
        'Me',
        style: TextStyle(
          fontSize: TEXT_HEADING_2X,
          color: SECONDARY_COLOR,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupDialog(context,userVO!));
            },
            child: Image.asset(
              'assets/profile/edit_icon.png',
              scale: 3,
            ))
      ],
    );
  }
}

Widget _buildPopupDialog(BuildContext context,UserVO userVO) {
  return EditUserInformationAlertBoxView(userVO:userVO);
}

class BookmarkMomentsListView extends StatelessWidget {

  final ProfilePageBloc bloc;

  const BookmarkMomentsListView({
    super.key,
    required this.bloc
  });

  @override
  Widget build(BuildContext context) {
    return
      (bloc.mMomentsList != null && bloc.mMomentsList.length > 0)?
      Padding(
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_CARD_MEDIUM_2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bookmarked Moments',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: TEXT_REGULAR_3X,
              color: SECONDARY_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: MARGIN_CARD_MEDIUM_2,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: MomentsListView(
              loginUserPhoneNum: bloc.mUserVO?.phoneNumber.toString()??"",
              items: bloc.mMomentsList,
              isBookmark: true,
              onTapBookMark: (momentVO){
                bloc.saveBookMark(bloc.mUserVO!, momentVO);
              },

            ),
          )
        ],
      ),
    ):
    Container();
  }
}

class LoginUserInformationView extends StatelessWidget {

  ProfilePageBloc bloc;

  LoginUserInformationView({
    super.key,
    required this.bloc
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
      decoration: BoxDecoration(
        color: SECONDARY_COLOR,
        borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ///Profile Image show, upload profile image and generate QR code section
            ProfileShowProfileUploadAndQRGenerateView(bloc:bloc),

            ///show user phone no, dob, gender
            UserInformationShowView(bloc:bloc)
          ],
        ),
      ),
    );
  }
}

class UserInformationShowView extends StatelessWidget {

  final ProfilePageBloc bloc;

  const UserInformationShowView({
    super.key,
    required this.bloc
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: MARGIN_XLARGE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserProfileNameView(userName:bloc.name??''),
         const SizedBox(
            height: MARGIN_MEDIUM,
          ),
          UserPhoneNumView(phoneNum:bloc.phoneNum??''),
          const SizedBox(
            height: MARGIN_MEDIUM,
          ),
          UserDOBView(dateOfBirth:bloc.dateOfBirth??''),
          const SizedBox(
            height: MARGIN_MEDIUM,
          ),
          UserGenderView(genderType:bloc.genderType??'')
        ],
      ),
    );
  }
}

class UserGenderView extends StatelessWidget {

  final String genderType;

  const UserGenderView({
    super.key,
    required this.genderType
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/profile/direction_icon.png',
          fit: BoxFit.cover,
          scale: 3,
        ),
        const SizedBox(
          width: MARGIN_CARD_MEDIUM_2,
        ),
        Text(
         genderType,
          style: const TextStyle(
            fontSize: TEXT_REGULAR,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class UserDOBView extends StatelessWidget {

  final String dateOfBirth;

  const UserDOBView({
    super.key,
    required this.dateOfBirth
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/profile/date_icon.png',
          fit: BoxFit.cover,
          scale: 3,
        ),
        const SizedBox(
          width: MARGIN_CARD_MEDIUM_2,
        ),
        Text(
          dateOfBirth,
          style: const TextStyle(
            fontSize: TEXT_REGULAR,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class UserPhoneNumView extends StatelessWidget {

  final String phoneNum;

  const UserPhoneNumView({
    super.key,
    required this.phoneNum
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/profile/phone_icon.png',
          fit: BoxFit.cover,
          scale: 3,
        ),
        const SizedBox(
          width: MARGIN_CARD_MEDIUM_2,
        ),
         Text(
         phoneNum,
          style: const TextStyle(
            fontSize: TEXT_REGULAR,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class UserProfileNameView extends StatelessWidget {

  final String userName;

  const UserProfileNameView({
    super.key,
    required this.userName
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      userName,
      style: const TextStyle(
        fontSize: TEXT_REGULAR_3X,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class ProfileShowProfileUploadAndQRGenerateView extends StatelessWidget {

  ProfilePageBloc bloc;

  ProfileShowProfileUploadAndQRGenerateView({
    super.key,
    required this.bloc
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
    (bloc.profilePicture == "") ?
        const CircleAvatar(
          radius: 55,
          backgroundImage:
          AssetImage('assets/moments/profile_sample.jpg')

        ):
    CircleAvatar(
        radius: 55,
        backgroundImage:

        NetworkImage('${bloc.profilePicture}')

    ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Image.asset(
            'assets/profile/photo_upload_icon.png',
            fit: BoxFit.cover,
            scale: 3,
          ),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildQRPopupDialog(context,bloc.userId),
                );
              },
              child: QRSectionView(qrStr: "${bloc.userId}", qrSize: 55.0,isPopupQR: false,),
            )
            // Image.asset('assets/profile/QR_icon.png',fit: BoxFit.cover,scale: 3,),
            ),
      ],
    );
  }

  Widget _buildQRPopupDialog(BuildContext context,String qrString) {
    return ShowQRGenerateViewPopUp(qrString: qrString);
  }
}

import 'package:flutter/material.dart';
import 'package:we_chat_app/components/moments_list_view.dart';
import 'package:we_chat_app/pages/edit_user_information_alert_box_view.dart';
import 'package:we_chat_app/pages/qr_generate_view.dart';
import 'package:we_chat_app/pages/show_qr_generate_view_pop_up.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CHAT_PAGE_BG_COLOR,
      appBar: const ProfilePageAppBarView(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ///show login user information section view
            LoginUserInformationView(),

            ///bookmark moment list view
            BookmarkMomentsListView()
          ],
        ),
      ),
    );
  }
}

class ProfilePageAppBarView extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  const ProfilePageAppBarView({
    super.key,
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
                      _buildPopupDialog(context));
            },
            child: Image.asset(
              'assets/profile/edit_icon.png',
              scale: 3,
            ))
      ],
    );
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return EditUserInformationAlertBoxView();
}

class BookmarkMomentsListView extends StatelessWidget {
  const BookmarkMomentsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            child: const MomentsListView(
              items: [
                'Item 1',
                'Item 2',
                'Item 3',
                'Item 4',
                'Item 5',
              ],
              isBookmark: true,
            ),
          )
        ],
      ),
    );
  }
}

class LoginUserInformationView extends StatelessWidget {
  const LoginUserInformationView({
    super.key,
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
          children: const [
            ///Profile Image show, upload profile image and generate QR code section
            ProfileShowProfileUploadAndQRGenerateView(),

            ///show user phone no, dob, gender
            UserInformationShowView()
          ],
        ),
      ),
    );
  }
}

class UserInformationShowView extends StatelessWidget {
  const UserInformationShowView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: MARGIN_XLARGE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          UserProfileNameView(),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          UserPhoneNumView(),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          UserDOBView(),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          UserGenderView()
        ],
      ),
    );
  }
}

class UserGenderView extends StatelessWidget {
  const UserGenderView({
    super.key,
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
        SizedBox(
          width: MARGIN_CARD_MEDIUM_2,
        ),
        const Text(
          'Male',
          style: TextStyle(
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
  const UserDOBView({
    super.key,
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
        SizedBox(
          width: MARGIN_CARD_MEDIUM_2,
        ),
        const Text(
          '1994-02-01',
          style: TextStyle(
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
  const UserPhoneNumView({
    super.key,
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
        SizedBox(
          width: MARGIN_CARD_MEDIUM_2,
        ),
        const Text(
          '09 952819765',
          style: TextStyle(
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
  const UserProfileNameView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Aung Aung',
      style: TextStyle(
        fontSize: TEXT_REGULAR_3X,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class ProfileShowProfileUploadAndQRGenerateView extends StatelessWidget {
  const ProfileShowProfileUploadAndQRGenerateView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundImage: AssetImage('assets/moments/profile_sample.jpg'),
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
                      _buildQRPopupDialog(context),
                );
              },
              child: QRSectionView(qrStr: "www.google.com", qrSize: 55.0,isPopupQR: false,),
            )
            // Image.asset('assets/profile/QR_icon.png',fit: BoxFit.cover,scale: 3,),
            ),
      ],
    );
  }

  Widget _buildQRPopupDialog(BuildContext context) {
    return ShowQRGenerateViewPopUp();
  }
}

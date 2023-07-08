import 'package:flutter/material.dart';
import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/utils/constants.dart';
import 'package:we_chat_app/viewitems/each_image_or_video_view_item.dart';

class EachMomentViewItem extends StatelessWidget {
  final MomentVO? mMomentVO;
  final Function(MomentVO) onTapBookmark;
  final String loginUserPhoneNum;
  const EachMomentViewItem({
    super.key,
    required this.mMomentVO,
    required this.onTapBookmark,
    required this.loginUserPhoneNum
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ///moment profile , title , contextual menu section
        Padding(
          padding: EdgeInsets.only(top: MARGIN_CARD_MEDIUM_2,
              left:MARGIN_CARD_MEDIUM_2 ),
          child: ProfileImgAndTitleSettingSectionView(mMomentVO: mMomentVO),
        ),
        SizedBox(height: MARGIN_MEDIUM,),

        ///moment text and description section
        DescriptionTextSectionView(mMomentVO: mMomentVO),
        SizedBox(height: MARGIN_MEDIUM,),

        /// like , comment and save section
        LikeCommentSaveActionSectionView(
          loginUserPhoneNum:loginUserPhoneNum,
          mMomentVO: mMomentVO,
        onTapBookMark: (mMomentVO){
          onTapBookmark(mMomentVO);
        },
        ),
        SizedBox(height: MARGIN_MEDIUM,),

        Divider(height: 1,color: TEXT_FIELD_HINT_TXT_COLOR,),

        SizedBox(height: MARGIN_MEDIUM,),


      ],
    );
  }
}

class LikeCommentSaveActionSectionView extends StatelessWidget {

  final MomentVO? mMomentVO;

  final Function(MomentVO) onTapBookMark;

  final String loginUserPhoneNum;

  const LikeCommentSaveActionSectionView({
    super.key,
    required this.mMomentVO,
    required this.onTapBookMark,
    required this.loginUserPhoneNum

  });

  @override
  Widget build(BuildContext context) {

    debugPrint("check  user book flag = ${mMomentVO?.isUserBookMarkFlag}");

    return Padding(
      padding: const EdgeInsets.only(left: MARGIN_MEDIUM_2,
      right: MARGIN_CARD_MEDIUM_2,
      bottom: MARGIN_CARD_MEDIUM_2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         const LikeActionView(
           likeCount: "0",
           isSelected: false,
         ),
          Row(
            children: [
              const Icon(Icons.comment_outlined,color: Colors.grey,),
              const SizedBox(width: MARGIN_MEDIUM,),
              GestureDetector(
                onTap: (){
                  onTapBookMark(mMomentVO!);
                },
                child: SaveMomentActionView(
           /*       isSelected: (
                      mMomentVO?.bookmarkedIdList?.contains(loginUserPhoneNum)??false)? true :false,*/

                  isSelected:mMomentVO?.isUserBookMarkFlag??false,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SaveMomentActionView extends StatelessWidget {

  final bool isSelected;


  const SaveMomentActionView({
    super.key,
    required this.isSelected
  });

  @override
  Widget build(BuildContext context) {
    return  (isSelected)?
    const Icon(Icons.bookmark,color: Colors.red,):
    const Icon(Icons.bookmark_border,color: Colors.grey,);
  }
}

class LikeActionView extends StatelessWidget {

  final String likeCount;
  final bool isSelected;

  const LikeActionView({
    super.key,
    required this.likeCount,
    required this.isSelected
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (isSelected)?
        const Icon(Icons.favorite,color: Colors.red,):
        const Icon(Icons.favorite_border,color: Colors.grey,),
        Text(
          likeCount,
          style: const TextStyle(
            fontSize: TEXT_REGULAR_1X,
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        )

      ],
    );
  }
}

class DescriptionTextSectionView extends StatelessWidget {
  final MomentVO? mMomentVO;

  const DescriptionTextSectionView({
    super.key,
    required this.mMomentVO
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: MARGIN_CARD_MEDIUM_2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextDescView(mMomentVO: mMomentVO),
          Visibility(
              visible:  (mMomentVO?.photoOrVideoUrlLink == null || mMomentVO?.photoOrVideoUrlLink?.length == 0)? false : true ,
              child:  ImageDescView(mMomentVO:mMomentVO))


        ],
      ),
    );
  }
}

class ImageDescView extends StatelessWidget {
  final MomentVO? mMomentVO;

  const ImageDescView({
    super.key,
    required this.mMomentVO
  });

  @override
  Widget build(BuildContext context) {

    List<String>? photoOrVideoList = mMomentVO?.photoOrVideoUrlLink?.split(",");

    return Container(
      margin: const EdgeInsets.only(left: MARGIN_SMALL),
      width: MediaQuery.of(context).size.width,
      height: 200,
      child:
      (photoOrVideoList?.length == 1)?
      ClipRRect(
        borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
        child:
        Image.network(
          photoOrVideoList?[0]??"",
          fit: BoxFit.cover,
        ),
        // Image.asset(
        //   'assets/moments/background_sample.jpg',
        //   fit: BoxFit.cover,
        // ),
      ):
      ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photoOrVideoList?.length,
        itemBuilder: (context, index) {
          return
            EachImageOrVideoViewItem(
              imageOrVideoLink: photoOrVideoList?[index],
          );

        },
      ),
    );
  }
}

class TextDescView extends StatelessWidget {

  final MomentVO? mMomentVO;

  const TextDescView({
    super.key,
    required this.mMomentVO
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
      child: Text(
        mMomentVO?.description??"",
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontSize: TEXT_REGULAR_2X,
          color: SECONDARY_COLOR,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class ProfileImgAndTitleSettingSectionView extends StatelessWidget {

  final MomentVO? mMomentVO;

  const ProfileImgAndTitleSettingSectionView({
    super.key,
    required this.mMomentVO
  });

  @override
  Widget build(BuildContext context) {
    return Row(
     // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
              child:
              (mMomentVO?.profileUrl == null || mMomentVO?.profileUrl == "")?
              Container(
                color: Colors.white,
                child: CircleAvatar(
                  backgroundColor: SUMBITED_PIN_THEME_COLOR,
                  radius: 21,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/splash/logo.png'),
                  ),
                ),
              )
             : CircleAvatar(
                backgroundImage: NetworkImage(mMomentVO?.profileUrl??""),
                radius: 21,
              ),
            ),

            // const CircleAvatar(
            //   backgroundImage: AssetImage('assets/moments/profile_sample.jpg'),
            //   radius: 21,
            // )
            const SizedBox(width: MARGIN_MEDIUM,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mMomentVO?.name??"",
                  style: const TextStyle(
                    fontSize: TEXT_REGULAR_3X,
                    color: SECONDARY_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: MARGIN_SMALL,),
                Text(
                  convertTimeToText(mMomentVO?.timestamp)??"",
                  style: const TextStyle(
                    fontSize: TEXT_SMALL,
                    color: TEXT_FIELD_HINT_TXT_COLOR,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: MARGIN_CARD_MEDIUM_2),
          child: Image.asset('assets/moments/contextual_icon.png',scale: 3,),
        )


      ],
    );
  }
}
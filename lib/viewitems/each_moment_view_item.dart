import 'package:flutter/material.dart';
import 'package:we_chat_app/data/vos/moment_vo.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/utils/constants.dart';

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



    return Padding(
      padding: const EdgeInsets.only(left: MARGIN_CARD_MEDIUM_2,
      right: MARGIN_CARD_MEDIUM_2,
      bottom: MARGIN_CARD_MEDIUM_2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         const LikeActionView(
           likeCount: "2",
           isSelected: true,
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
                  isSelected: (mMomentVO?.bookmarkedIdList?.contains(loginUserPhoneNum)??false)? true :false,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextDescView(mMomentVO: mMomentVO),
        Visibility(
            visible:  (mMomentVO?.photoOrVideoUrlLink == null || mMomentVO?.photoOrVideoUrlLink?.length == 0)? false : true ,
            child:  ImageDescView(mMomentVO:mMomentVO))


      ],
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
    return Container(
      margin: const EdgeInsets.only(left: MARGIN_SMALL),
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return  Container(
            width: MOMENT_DESC_IMAGE_WIDTH,
            height: MOMENT_DESC_IMAGE_HEIGHT,
            margin: const EdgeInsets.all( MARGIN_MEDIUM),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
            ),
            child:
            (mMomentVO?.photoOrVideoUrlLink == null || mMomentVO?.photoOrVideoUrlLink == "")?
                Container():
            ClipRRect(
              borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
              child:
              Image.network(
               mMomentVO?.photoOrVideoUrlLink.toString()??"",
                fit: BoxFit.cover,
              ),
              // Image.asset(
              //   'assets/moments/background_sample.jpg',
              //   fit: BoxFit.cover,
              // ),
            ),
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
              const CircleAvatar(
                backgroundImage: AssetImage('assets/moments/profile_sample.jpg'),
                radius: 21,
              ): CircleAvatar(
                backgroundImage: NetworkImage(mMomentVO?.profileUrl??""),
                radius: 21,
              ),
            ),
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
import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class EachMomentViewItem extends StatelessWidget {
  const EachMomentViewItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [

        ///moment profile , title , contextual menu section
        Padding(
          padding: EdgeInsets.only(top: MARGIN_CARD_MEDIUM_2,
              left:MARGIN_CARD_MEDIUM_2 ),
          child: ProfileImgAndTitleSettingSectionView(),
        ),
        SizedBox(height: MARGIN_MEDIUM,),

        ///moment text and description section
        DescriptionTextSectionView(),
        SizedBox(height: MARGIN_MEDIUM,),

        /// like , comment and save section
        LikeCommentSaveActionSectionView(),
        SizedBox(height: MARGIN_MEDIUM,),

      ],
    );
  }
}

class LikeCommentSaveActionSectionView extends StatelessWidget {

  const LikeCommentSaveActionSectionView({
    super.key,
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
            children: const [
              Icon(Icons.comment_outlined,color: Colors.grey,),
              SizedBox(width: MARGIN_MEDIUM,),
              SaveMomentActionView(
                isSelected: false,
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
  const DescriptionTextSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TextDescView(),
        ImageDescView()
      ],
    );
  }
}

class ImageDescView extends StatelessWidget {
  const ImageDescView({
    super.key,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
              child: Image.asset(
                'assets/moments/background_sample.jpg',
                fit: BoxFit.cover,
              ),
            ),
          );

        },
      ),
    );
  }
}

class TextDescView extends StatelessWidget {
  const TextDescView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(MARGIN_CARD_MEDIUM_2),
      child: Text(
        "A machine resembling a human being and able to replicate certain human movements and functions automatically",
        style: TextStyle(
          fontSize: TEXT_REGULAR_2X,
          color: SECONDARY_COLOR,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class ProfileImgAndTitleSettingSectionView extends StatelessWidget {
  const ProfileImgAndTitleSettingSectionView({
    super.key,
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
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/moments/profile_sample.jpg'),
                radius: 21,
              ),
            ),
            SizedBox(width: MARGIN_MEDIUM,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Michael",
                  style: TextStyle(
                    fontSize: TEXT_REGULAR_3X,
                    color: SECONDARY_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: MARGIN_SMALL,),
                Text(
                  "15 min ago",
                  style: TextStyle(
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
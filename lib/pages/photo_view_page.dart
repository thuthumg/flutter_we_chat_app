import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:we_chat_app/data/vos/media_type_vo.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/viewitems/video_view_custom_widget.dart';

class MediaDetailViewPage extends StatelessWidget {
  final String imageUrl;
  final MediaTypeVO mediaTypeVO;
  MediaDetailViewPage({required this.imageUrl,required this.mediaTypeVO});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
        constraints: BoxConstraints.expand(
          // Set the constraints to cover the available space
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        child:
        (mediaTypeVO.fileType.toString().contains("video"))?
        VideoViewCustomWidget(videoUrl:mediaTypeVO.fileUrl)
            : (mediaTypeVO.fileType.toString().contains("gif"))?
        ClipRRect(
          borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
          child:
          CachedNetworkImage(
            height: MediaQuery.of(context).size.height,
            imageUrl: mediaTypeVO.fileUrl.toString(),
          /*  placeholder: (context, url) => SizedBox(
          width: 50.0, // Set your desired width
          height: 50.0, // Set your desired height
          child: CircularProgressIndicator(),
        ),*/
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                  child: SizedBox(
                     // margin: EdgeInsets.all(MARGIN_MEDIUM_3),
                      width:50.0,
                      height:50.0,
                      child: CircularProgressIndicator(value: downloadProgress.progress)),
                ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          // Image.network(
          //   chatDetailPageBloc.selectedGifImages[index],
          //   fit: BoxFit.cover,
          // ),

        ):

        PhotoView(
          imageProvider: NetworkImage(imageUrl),
          loadingBuilder: (context, event) {
            if (event == null) {
              return Center(child: CircularProgressIndicator());
            } else if (event.cumulativeBytesLoaded == event.expectedTotalBytes) {
              // If the image has finished loading
              return Container(); // Return an empty container to remove the CircularProgressIndicator
            } else {
              // Handle loading progress
              final progress = event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 100);
              return Center(child: CircularProgressIndicator(value: progress));
            }
          },
        ),
      ),
    );
  }
}

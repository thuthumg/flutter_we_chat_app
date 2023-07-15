import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat_app/resources/dimens.dart';

class VideoViewCustomWidget extends StatefulWidget{

  final String? videoUrl;

  VideoViewCustomWidget({required this.videoUrl});

  @override
  State<VideoViewCustomWidget> createState() => _VideoViewCustomWidgetState();
}

class _VideoViewCustomWidgetState extends State<VideoViewCustomWidget> {

  late VideoPlayerController _controller;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        widget.videoUrl??'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }



  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: (){

          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });


        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(MARGIN_CARD_MEDIUM_2),
          child: AspectRatio(
            aspectRatio: 2/3,
           // aspectRatio: _controller.value.aspectRatio,
            child:_controller != null ?
            Stack(
              children: [
                VideoPlayer(
                    _controller
                ),
                Center(
                  child: Icon(
                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                )
              ],
            ) : const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );




    //   Container(
    //   child: Stack(
    //     children: [
    //       Center(
    //         child: _controller.value.isInitialized
    //             ? AspectRatio(
    //           aspectRatio: _controller.value.aspectRatio,
    //           child: VideoPlayer(_controller),
    //         )
    //             : Container(),
    //       ),
    //       Icon(icon)
    //     ],
    //   ),
    // );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
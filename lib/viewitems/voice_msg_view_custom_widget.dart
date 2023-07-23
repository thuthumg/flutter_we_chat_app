import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:we_chat_app/resources/dimens.dart';

class VoiceMsgViewCustomWidget extends StatefulWidget{

  final String voiceRecordUrl;
  VoiceMsgViewCustomWidget({required this.voiceRecordUrl});

  @override
  State<VoiceMsgViewCustomWidget> createState() => _VoiceMsgViewCustomWidgetState();
}

class _VoiceMsgViewCustomWidgetState extends State<VoiceMsgViewCustomWidget> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlayingRecordedFile = false;

  @override
  Widget build(BuildContext context) {
   return ClipRRect(
     borderRadius:
     BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
     child: Container(
       decoration: BoxDecoration(
         color: const Color.fromRGBO(17, 58, 93, 1),
         borderRadius: BorderRadius.circular(
             CUSTOM_BUTTON_RADIUS),
       ),
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Row(
           mainAxisAlignment:
           MainAxisAlignment.spaceBetween,
           crossAxisAlignment:
           CrossAxisAlignment.center,
           children: [
             SizedBox(
               height: 40,
               child: LoadingIndicator(
                 indicatorType:
                 Indicator.lineScalePulseOutRapid,
                 colors: [Colors.white],
                 strokeWidth: 2,
                 backgroundColor: Colors.transparent,
                 pathBackgroundColor: Colors.white,
                 pause: isPlayingRecordedFile
                     ? false
                     : true,
               ),
             ),
             isPlayingRecordedFile
                 ?
             IconButton(
               onPressed: () {
                 _stopPlayingAudio();
               },
               icon: const Icon(
                 Icons.stop,
                 size: 35,
                 color: Colors.red,
               ),
             )
                 :
             IconButton(
               onPressed: () {

                 _playRecordedAudio(widget.voiceRecordUrl);
               },
               icon: const Icon(
                 Icons.play_arrow,
                 size: 35,
                 color: Colors.green,
               ),
             ),
           ],
         ),
       ),
     ),
   );
  }





  Future<void> _playRecordedAudio(recordFile) async {
    print("record path ${recordFile.isNotEmpty}");
    if (recordFile.isNotEmpty) {

      // File recordedFile = File(_recordPath);
      await _audioPlayer.play(UrlSource(recordFile));
      setState(() {
        isPlayingRecordedFile = true;
      });

    }
  }

  Future<void> _stopPlayingAudio() async {
    await _audioPlayer.stop();
    // bloc.isPlayingRecordedFile = false;
    setState(() {
      isPlayingRecordedFile = false;
    });

  }

}
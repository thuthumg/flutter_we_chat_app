
import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:we_chat_app/blocs/chat_detail_page_bloc.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class CustomVoiceRecordDialog extends StatefulWidget {

  ChatDetailPageBloc bloc;

  CustomVoiceRecordDialog({required this.bloc});

  @override
  State<CustomVoiceRecordDialog> createState() => _CustomVoiceRecordDialogState();
}

class _CustomVoiceRecordDialogState extends State<CustomVoiceRecordDialog> {

  bool _isRecording = false;
  bool _isPlaying = false;
  late String _recordPath = ''; // Initialize with an empty string
  late Timer _stopTimer;
  Duration _recordingDuration = Duration(minutes: 10);

  List<String> _recordedFiles = []; // Create a list to store the recorded file paths

  bool _showRecordedFilesVisible = false; // Variable to track the visibility of the recorded files list

  AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playRecordedAudio() async {
    print("record path ${_recordPath.isNotEmpty}");
    _recordedFiles.add(_recordPath);
    if (_recordPath.isNotEmpty) {
      // File recordedFile = File(_recordPath);
      await _audioPlayer.play(UrlSource(_recordPath));

    }

    setState(() {
      _isPlaying = true;
    });
  }
  Future<void> _stopPlayingAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }


  @override
  void dispose() {
    _stopRecording();
    super.dispose();
  }
  Future<void> _checkPermissionsAndStartRecording() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      await _startRecording();
    } else {
      debugPrint("Permission to record audio denied.");
    }
  }

  Future<void> _startRecording() async {

    try {
      // Get the writable directory
      Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
      String recordedFilePath = '${appDocumentsDirectory.path}/audio.aac';

      // Start recording
      await Record().start(
        path: recordedFilePath,
        encoder: AudioEncoder.aacLc,
      );

      setState(() {
        debugPrint("check record Path $recordedFilePath");
        _isRecording = true;
        _isPlaying = false;
        _recordPath = recordedFilePath;
      });

      // Start the auto-stop timer
      _stopTimer = Timer(_recordingDuration, () {
        if (_isRecording) {
          _stopRecording();
        }
      });
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      await Record().stop();
      setState(() {
        _isPlaying = false;
        _isRecording = false;
      });
      _stopTimer?.cancel(); // Cancel the auto-stop timer
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }



  // Function to show the recorded files UI
  Widget _showRecordedFiles() {
    if (_recordedFiles.isEmpty) {
      return Text('No recorded files available.');
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _recordedFiles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Recorded File ${index + 1}'),
            trailing: IconButton(
              onPressed: () {
                _playRecordedFileAtIndex(index);
              },
              icon: Icon(Icons.play_arrow),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isRecording
                ? Column(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  child: const LoadingIndicator(
                    indicatorType: Indicator.audioEqualizer,
                    colors: [SECONDARY_COLOR],
                    strokeWidth: 2,
                    backgroundColor: Colors.transparent,
                    pathBackgroundColor: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Recording...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            )
                : IconButton(
              onPressed: _checkPermissionsAndStartRecording,
              icon: Icon(Icons.mic),
              iconSize: 48,
              color: Colors.blue,
            ),
            _isRecording
                ? IconButton(
              onPressed: _stopRecording,
              icon: Icon(Icons.stop),
              iconSize: 48,
              color: Colors.red,
            )
                : SizedBox(),
            // _recordPath.isNotEmpty
            //     ? IconButton(
            //   onPressed: _playRecordedAudio,
            //   icon: Icon(Icons.play_arrow),
            //   iconSize: 48,
            //   color: Colors.green,
            // )
            //     : SizedBox(),
            // _recordPath.isNotEmpty
            //     ? IconButton(
            //   onPressed: _stopPlayingAudio,
            //   icon: Icon(Icons.stop),
            //   iconSize: 48,
            //   color: Colors.red,
            // )
            //     : SizedBox(),

            _recordPath.isNotEmpty
                ?
                Container(
                  margin: EdgeInsets.symmetric(horizontal: MARGIN_LARGE),
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(

                        children: [
                        const Text('Recorded File ......'),
                        LoadingIndicator(
                          indicatorType: Indicator.lineScalePulseOut,
                          colors: [SECONDARY_COLOR],
                          strokeWidth: 2,
                          backgroundColor: Colors.transparent,
                          pathBackgroundColor: Colors.black,
                          pause: _isPlaying? false : true,

                        )
                      ],)
                    ,
                    Row(

                      children: [
                      IconButton(
                        onPressed: (){
                          _playRecordedAudio();
                        },
                        icon: const Icon(Icons.play_arrow ,size: 35,
                          color: Colors.green,),
                      ),
                      IconButton(
                        onPressed: (){
                         // _isPlaying = false;
                          _stopPlayingAudio();
                        },
                        icon: const Icon(Icons.stop,size: 35,
                          color: Colors.red,),
                      )
                    ],)

                  ],
                  ),
                )
                : const SizedBox(),

          ],
        ),
      ),
    );
  }


  // Function to play the recorded file at a specific index
  void _playRecordedFileAtIndex(int index) {
    String filePath = _recordedFiles[index];
    _audioPlayer.play(UrlSource(filePath));
  }



}



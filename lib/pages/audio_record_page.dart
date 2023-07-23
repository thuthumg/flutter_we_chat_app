import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorderApp extends StatefulWidget {
  @override
  _VoiceRecorderAppState createState() => _VoiceRecorderAppState();
}

class _VoiceRecorderAppState extends State<VoiceRecorderApp> {
 // bool _isRecording = false;
 // late String _recordPath;
 // late Timer _stopTimer;
 // Duration _recordingDuration = Duration(minutes: 10); // Set the recording duration here

  bool _isRecording = false;
  late String _recordPath = ''; // Initialize with an empty string
  late Timer _stopTimer;
  Duration _recordingDuration = Duration(minutes: 10);



  AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playRecordedAudio() async {
    print("record path ${_recordPath.isNotEmpty}");
    if (_recordPath.isNotEmpty) {
     // File recordedFile = File(_recordPath);
      await _audioPlayer.play(UrlSource(_recordPath));
      /*int result = await _audioPlayer.play(recordedFile.path); // Use AudioPlayer to play the audio
      if (result == 1) {
        // success
      } else {
        print("Error playing audio");
      }*/
    }
  }
  Future<void> _stopPlayingAudio() async {
    await _audioPlayer.stop();
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
        _isRecording = false;
      });
      _stopTimer?.cancel(); // Cancel the auto-stop timer
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Recorder')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isRecording
                ? Text('Recording...')
                : ElevatedButton(
              onPressed: _checkPermissionsAndStartRecording,
              child: Text('Start Recording'),
            ),
            _isRecording
                ? ElevatedButton(
              onPressed: _stopRecording,
              child: Text('Stop Recording'),
            )
                : SizedBox(),
            _recordPath.isNotEmpty
                ? ElevatedButton(
              onPressed: _playRecordedAudio,
              child: Text('Play Recorded Audio'),
            )
                : SizedBox(),
            _recordPath.isNotEmpty
                ? ElevatedButton(
              onPressed: _stopPlayingAudio,
              child: Text('Stop Playing'),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Recorder')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isRecording
                ? Text('Recording...')
                : ElevatedButton(
              onPressed: _checkPermissionsAndStartRecording,
              child: Text('Start Recording'),
            ),
            _isRecording
                ? ElevatedButton(
              onPressed: _stopRecording,
              child: Text('Stop Recording'),
            )
                : SizedBox(),
          ],
        ),
      ),
    );*/
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'dart:async';
//
//
// class VoiceRecorderApp extends StatefulWidget {
//   @override
//   _VoiceRecorderAppState createState() => _VoiceRecorderAppState();
// }
//
// class _VoiceRecorderAppState extends State<VoiceRecorderApp> {
//   FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
//
//   bool _isRecording = false;
//   late String _recordPath;
//   late Timer _stopTimer;
//   Duration _recordingDuration = Duration(minutes: 10); // Set the recording duration here
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _soundRecorder.closeRecorder();
//     _stopTimer?.cancel(); // Cancel the timer when the widget is disposed
//     super.dispose();
//   }
//
//   Future<void> _startRecording() async {
//     try {
//       await _soundRecorder.openRecorder();
//      String path =  await _soundRecorder.startRecorder(
//         codec: Codec.aacADTS,
//         toFile: 'audio.aac',
//       ).then((value) => value).toString();
//       setState(() {
//
//         debugPrint("check record Path ${path.toString()}");
//
//         _isRecording = true;
//         _recordPath = path;
//       });
//
//       // Start the auto-stop timer
//       _stopTimer = Timer(_recordingDuration, () {
//         if (_isRecording) {
//           _stopRecording();
//         }
//       });
//     } catch (e) {
//       print("Error starting recording: $e");
//     }
//   }
//
//   Future<void> _stopRecording() async {
//     try {
//       await _soundRecorder.stopRecorder();
//       setState(() {
//         _isRecording = false;
//       });
//       _stopTimer?.cancel(); // Cancel the auto-stop timer
//     } catch (e) {
//       print("Error stopping recording: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Voice Recorder')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _isRecording
//                 ? Text('Recording...')
//                 : ElevatedButton(
//               onPressed: _startRecording,
//               child: Text('Start Recording'),
//             ),
//             _isRecording
//                 ? ElevatedButton(
//               onPressed: _stopRecording,
//               child: Text('Stop Recording'),
//             )
//                 : SizedBox(),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class AudioRecorder extends StatefulWidget {
//   @override
//   _AudioRecorderState createState() => _AudioRecorderState();
// }
//
// class _AudioRecorderState extends State<AudioRecorder> {
//   FlutterSoundRecorder? _soundRecorder;
//
//   @override
//   void initState() {
//     super.initState();
//     _soundRecorder = FlutterSoundRecorder();
//   }
//
//   Future<void> startRecording() async {
//     await _soundRecorder!.openRecorder();
//     await _soundRecorder!.startRecorder(toFile: 'audio_message.aac');
//   }
//
//   Future<void> stopRecording() async {
//     await _soundRecorder!.stopRecorder();
//     await _soundRecorder!.closeRecorder();
//   }
//
//   @override
//   void dispose() {
//     _soundRecorder?.closeRecorder();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Audio Recorder'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await startRecording();
//             // Wait for some duration to record the message, then call stopRecording()
//           },
//           child: Text('Start Recording'),
//         ),
//       ),
//     );
//   }
//
//   void startRecordingTimer() async {
//     await startRecording();
//     // Record for 10 seconds
//     await Future.delayed(Duration(seconds: 10));
//     await stopRecording();
//   }
//
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
//
// class VoiceRecorderApp extends StatefulWidget {
//   @override
//   _VoiceRecorderAppState createState() => _VoiceRecorderAppState();
// }
//
// class _VoiceRecorderAppState extends State<VoiceRecorderApp> {
//   FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
//   FlutterSoundPlayer _soundPlayer = FlutterSoundPlayer();
//
//   bool _isRecording = false;
//   bool _isPlaying = false;
//   late String _recordPath;
//   FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
//
//   @override
//   void initState() {
//     super.initState();
//     _soundPlayer.openPlayer().then((value) {
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     _soundRecorder.closeRecorder();
//     _soundPlayer.closePlayer();
//     super.dispose();
//   }
//   //Codec codec = Codec.defaultCodec,   String? toFile,   StreamSink<Food>? toStream,   int sampleRate = 16000,   int numChannels = 1,   int bitRate = 16000,   AudioSource audioSource = AudioSource.defaultSource,
//   Future<void> _startRecording() async {
//     try {
//       await _soundRecorder.openRecorder();
//       String path = await _audioRecorder.startRecorder(
//         toFile: 'message.aac',
//         codec: Codec.aacADTS,
//       );
//       setState(() {
//         _isRecording = true;
//         _recordPath = path;
//       });
//     } catch (e) {
//       print("Error starting recording: $e");
//     }
//   }
//
//   Future<void> _stopRecording() async {
//     try {
//       await _soundRecorder.stopRecorder();
//       setState(() {
//         _isRecording = false;
//       });
//     } catch (e) {
//       print("Error stopping recording: $e");
//     }
//   }
//
//   Future<void> _playRecording() async {
//     try {
//       await _soundPlayer.startPlayer(
//         fromURI: _recordPath,
//         codec: Codec.aacADTS,
//       );
//       setState(() {
//         _isPlaying = true;
//       });
//
//       // Wait for the duration of the recording
//       await Future.delayed(Duration(milliseconds: _soundPlayer.duration.inMilliseconds));
//
//       // Playback completed
//       _stopPlayback();
//     } catch (e) {
//       print("Error playing recording: $e");
//     }
//   }
//
//   Future<void> _stopPlayback() async {
//     await _soundPlayer.stopPlayer();
//     setState(() {
//       _isPlaying = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Voice Recorder')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _isRecording
//                 ? Text('Recording...')
//                 : ElevatedButton(
//               onPressed: _startRecording,
//               child: Text('Start Recording'),
//             ),
//             _isRecording
//                 ? ElevatedButton(
//               onPressed: _stopRecording,
//               child: Text('Stop Recording'),
//             )
//                 : SizedBox(),
//             _isPlaying
//                 ? Text('Playing...')
//                 : ElevatedButton(
//               onPressed: _playRecording,
//               child: Text('Play Recording'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class VideoController extends ChangeNotifier {
  VideoPlayerController? _controller;

  Future<void> init(String url) async {
    _controller?.dispose();
    _controller = VideoPlayerController.network(url);
    await _controller!.initialize();
    notifyListeners();
  }

  VideoPlayerController? get controller => _controller;

  Future<void> play() async {
    await _controller!.play();
    notifyListeners();
  }

  Future<void> pause() async {
    await _controller!.pause();
    notifyListeners();
  }

  Future<void> seek(Duration duration) async {
    await _controller!.seekTo(duration);
    notifyListeners();
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    super.dispose();
  }
}
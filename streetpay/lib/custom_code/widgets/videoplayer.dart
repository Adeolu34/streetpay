// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
class Videoplayer extends StatefulWidget {
  final String? videourl;
  final double? width;
  final double? height;

  Videoplayer({
    required this.videourl,
    this.width,
    this.height,
  });

  @override
  State<StatefulWidget> createState() => _VideoplayerState();
}

class _VideoplayerState extends State<Videoplayer> {
  late dynamic _controller;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    if (isYouTubeUrl(widget.videourl!)) {
      String videoId = YoutubePlayer.convertUrlToId(widget.videourl!)!;
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    } else if (isFacebookUrl(widget.videourl!)) {
      String directVideoUrl = getDirectFacebookVideoUrl(widget.videourl!);
      if (directVideoUrl.isNotEmpty) {
        _controller = VideoPlayerController.network(directVideoUrl)
          ..initialize().then((_) {
            setState(() {});
          });
      } else {
        _showError("Unsupported Facebook video URL");
      }
    } else if (isDirectVideoUrl(widget.videourl!)) {
      _controller = VideoPlayerController.network(widget.videourl!)
        ..initialize().then((_) {
          setState(() {});
        });
    } else {
      _showError("Unsupported video URL");
    }
  }

  bool isYouTubeUrl(String url) {
    return url.contains("youtube.com") || url.contains("youtu.be");
  }

  bool isFacebookUrl(String url) {
    return url.contains("facebook.com");
  }

  bool isDirectVideoUrl(String url) {
    // Check if the URL ends with common video file extensions
    return url.endsWith('.mp4') || url.endsWith('.mov') || url.endsWith('.avi');
  }

  String getDirectFacebookVideoUrl(String url) {
    // Logic to extract direct video URL from Facebook link
    // This is a placeholder; you may need to implement a method to get the direct URL
    return ""; // Return the direct video URL if found
  }

  void _showError(String message) {
    // Display an error message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    if (_controller is YoutubePlayerController) {
      _controller.dispose();
    } else if (_controller is VideoPlayerController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: _controller is YoutubePlayerController
          ? YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            )
          : _controller is VideoPlayerController &&
                  _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Center(child: CircularProgressIndicator()), // Loading indicator
    );
  }
}

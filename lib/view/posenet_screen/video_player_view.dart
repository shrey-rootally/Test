import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatelessWidget {
  const VideoPlayerView({
    Key? key,
    required Future<void> initializeVideoPlayerFuture,
    required this.screenHeight,
    required this.screenWidth,
    required this.cameraViewWidth,
    required VideoPlayerController videoPlayer,
  })  : _initializeVideoPlayerFuture = initializeVideoPlayerFuture,
        _videoPlayer = videoPlayer,
        super(key: key);

  final Future<void> _initializeVideoPlayerFuture;
  final double screenHeight;
  final double screenWidth;
  final double cameraViewWidth;
  final VideoPlayerController _videoPlayer;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          const color = Color(0xFFcccccb);
          return Container(
              decoration: const BoxDecoration(color: color),
              height: screenHeight,
              width: screenWidth - cameraViewWidth,
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: 1,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(_videoPlayer),
              ));
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
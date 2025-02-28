import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_clone/core/controllers.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final File? videoFile;
  final String? videoUrl;
  const VideoPlayerWidget({super.key, this.videoFile, this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final VideoPlayerController video;

  @override
  void initState() {
    super.initState();
    if (widget.videoFile != null) {
      video = VideoPlayerController.file(widget.videoFile!);
    } else if (widget.videoUrl != null) {
      video = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
    }
    video.initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    video.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return video.value.isInitialized
        ? Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity, // Makes it fill the width
          height: double.infinity,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: SizedBox(
                width: video.value.size.width,
                height: video.value.size.height,
                child: VideoPlayer(video)),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: IconButton(
            icon: Icon(
              video.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                video.value.isPlaying ? video.pause() : video.play();
              });
            },
          ),
        ),
      ],
    )
        : Center(child: CircularProgressIndicator());
  }
}

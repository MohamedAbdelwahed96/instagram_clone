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
  final formControllers = FormControllers();

  @override
  void initState() {
    super.initState();
    if (widget.videoFile != null) {
      formControllers.video = VideoPlayerController.file(widget.videoFile!);
    } else if (widget.videoUrl != null) {
      formControllers.video = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
    }
    formControllers.video.initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    formControllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return formControllers.video.value.isInitialized
        ? Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity, // Makes it fill the width
          height: double.infinity,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
                width: formControllers.video.value.size.width,
                height: formControllers.video.value.size.height,
                child: VideoPlayer(formControllers.video)),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: IconButton(
            icon: Icon(
              formControllers.video.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                formControllers.video.value.isPlaying ? formControllers.video.pause() : formControllers.video.play();
              });
            },
          ),
        ),
      ],
    )
        : Center(child: CircularProgressIndicator());
  }
}

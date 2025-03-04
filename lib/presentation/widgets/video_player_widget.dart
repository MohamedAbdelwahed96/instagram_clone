import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final File? videoFile;
  final String? videoUrl;
  final BoxFit fit;
  final bool tapToPlayPause;

  const VideoPlayerWidget({
    super.key,
    this.videoFile,
    this.videoUrl,
    this.fit = BoxFit.cover,
    this.tapToPlayPause = false,
  });

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
    if(!video.value.isInitialized) return Center(child: CircularProgressIndicator());
    return InkWell(
      onTap: (){
        if (widget.tapToPlayPause) {
          setState(() => video.value.isPlaying ? video.pause() : video.play());
        }},
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: FittedBox(
          fit: widget.fit,
          child: SizedBox(
            width: video.value.size.width,
            height: video.value.size.height,
            child: VideoPlayer(video),
          ),
        ),
      ),
    );
  }
}

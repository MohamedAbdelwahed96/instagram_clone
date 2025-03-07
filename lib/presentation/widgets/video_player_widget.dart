import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerWidget extends StatefulWidget {
  final File? videoFile;
  final String? videoUrl;
  final BoxFit fit;
  final bool tapToPlayPause;
  final bool autoPlay;

  const VideoPlayerWidget({
    super.key,
    this.videoFile,
    this.videoUrl,
    this.fit = BoxFit.cover,
    this.tapToPlayPause = false,
    this.autoPlay = false,
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

    video.initialize().then((_) {
      if (widget.autoPlay) video.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    video.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!video.value.isInitialized) return Center(child: CircularProgressIndicator());

    return VisibilityDetector(
      key: Key(widget.videoUrl ?? widget.videoFile?.path ?? "video"),
      onVisibilityChanged: (value) {
        if (value.visibleFraction == 0 && video.value.isPlaying) {
          setState(() {});
          video.pause();
        }
      },
      child: GestureDetector(
        onTap: !widget.tapToPlayPause ? null :
            () {
          setState(() {});
          video.value.isPlaying ? video.pause() : video.play();
        },
        onLongPress: () {
          setState(() {});
          video.pause();
        },
        onLongPressEnd: (_) {
          setState(() {});
          video.play();
        },
        child: ClipRRect(
          child: AspectRatio(
            aspectRatio: 1, // Forces a square aspect ratio
            child: FittedBox(
              fit: widget.fit,
              child: SizedBox(
                width: video.value.size.width,
                height: video.value.size.height,
                child: VideoPlayer(video),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

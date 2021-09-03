import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String link;

  const VideoWidget({Key key, this.link}) : super(key: key);
  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: VideoPlayerController.network(widget.link),
        aspectRatio: 16 / 9,
        autoInitialize: true,
        autoPlay: false,
        looping: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    _chewieController.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}

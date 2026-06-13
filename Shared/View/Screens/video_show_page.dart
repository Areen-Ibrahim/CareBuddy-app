import 'dart:async';
import 'package:carebuddy/Core/Components/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../Core/Components/app_scaffold_widget.dart';

class VideoPlayerPage extends StatefulWidget {
  final String url;
  const VideoPlayerPage({super.key, required this.url});

  @override
  State<StatefulWidget> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.url,
    )..initialize().then((_) {
      setState(() {});
    });

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = true;
    });
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
      _toggleControls();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(title: const Text("Video"),),
      body: Builder(
        builder: (context){
          if( _controller.value.isInitialized ) 
            {
              return Center(
                child: GestureDetector(
                  onTap: _toggleControls,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 16/9,
                        child: VideoPlayer(_controller),
                      ),
                      if (_showControls)
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 60,
                            color: Colors.white,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                    ],
                  ),
                ),
              );
            }
          else
            {
              return const LoadingWidget();
            }
        },
      ),
    );
  }
}

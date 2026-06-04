
import 'dart:ui';

import 'package:final_project/pages/fullvideo.dart';
import 'package:final_project/pages/video.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoCaroselSlider extends StatefulWidget {
  final List<VideoModel> videos;
  final int initialpage;
  const VideoCaroselSlider(
      {super.key, required this.videos, required this.initialpage});

  @override
  State<VideoCaroselSlider> createState() => _VideoCaroselSliderState();
}

class _VideoCaroselSliderState extends State<VideoCaroselSlider> {
  late PageController _pageController;
  late int _currentpage;
  VideoPlayerController? _videoController;
  bool isvideoReady = false;

  @override
  void initState() {
    super.initState();
    _currentpage = widget.initialpage;
    _pageController =
        PageController(viewportFraction: 0.8, initialPage: _currentpage);
    _loadVideo(widget.videos[_currentpage].videoUrl);
  }

  Future<void> _loadVideo(String Url) async {
    setState(() {
      isvideoReady = false;
    });
    _videoController?.dispose();
    final controller = VideoPlayerController.networkUrl(Uri.parse(Url));
    await controller.initialize();
    controller.setLooping(true);
    controller.setVolume(0);
    await controller.play();
    if (mounted) {
      setState(() {
        _videoController = controller;
        isvideoReady = true;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 600),
          child: Image.network(
            widget.videos[_currentpage].image,
            key: ValueKey(widget.videos[_currentpage].image),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        ),
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: PageView.builder(
                controller: _pageController,
                itemCount: widget.videos.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentpage = index;
                    _loadVideo(widget.videos[index].videoUrl);
                  });
                },
                itemBuilder: (context, index) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;

                    value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                  }
                  return Transform.scale(

                    scale: value,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute( 
                            builder: (_) => FullScreenVideo(videoUrl: widget.videos[index].videoUrl),
                         ));
                      },
                      child: Hero(tag: widget.videos[index].id.toString(),
                       
                       child: isvideoReady ? AspectRatio(aspectRatio: _videoController!.value.aspectRatio
                       ,
                       child: VideoPlayer(_videoController!),
                       ):const 
                       Center(child: CircularProgressIndicator(),)
                       
      
                       ),
                     ),
                  );
                }),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideo extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideo({super.key, required this.videoUrl});

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  late VideoPlayerController _controller;
  bool _isSetting = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> setasVideoWallpaper() async {
  setState(() {
    _isSetting = true;
  });

  _controller.pause();

  try {
    await MethodChannel('com.example.wallpaper/set_wallpaper').invokeMethod(
      'setVideoWallpaper',
      {'videoUrl': widget.videoUrl},
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Live wallpaper applied successfully!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    }

    // 👇 Show overlay for smoother experience
    await Future.delayed(const Duration(seconds: 2)); // 2s fade wait

  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Failed to apply wallpaper: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  setState(() {
    _isSetting = false;
  });
}


  void _showSetAsOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              title: const Text(
                "Set as Live Wallpaper",
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                Navigator.pop(context);
                setasVideoWallpaper();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: _isSetting ? null : () => _showSetAsOptions(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              icon: const Icon(Icons.wallpaper),
              label: const Text("Set As"),
            ),
          ),

          // ✅ Overlay for loading
          if (_isSetting)
  Container(
color: Colors.black.withAlpha(178), // 178 ≈ 70% of 255
    child: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            "Applying wallpaper...",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    ),
  ),

        ],
      ),
    );
  }
}

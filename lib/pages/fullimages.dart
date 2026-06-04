import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreenImage extends StatefulWidget {
  final String imagePath;

  const FullScreenImage({super.key, required this.imagePath});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  bool _isSetting = false;

  Future<void> setAsWallpaper(String target) async {
    setState(() => _isSetting = true);

    try {
      final result = await MethodChannel('com.example.wallpaper/set_wallpaper')
          .invokeMethod('setWallpaper', {
        'imageUrl': widget.imagePath,
        'target': target,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(' Wallpaper set successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(' Failed to set wallpaper: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    setState(() => _isSetting = false);
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
              title: const Text("Set as Home Screen",
                  style: TextStyle(color: Colors.blue)),
              onTap: () {
                Navigator.pop(context);
                setAsWallpaper("Home");
              },
            ),
            ListTile(
              title: const Text("Set as Lock Screen",
                  style: TextStyle(color: Colors.blue)),
              onTap: () {
                Navigator.pop(context);
                setAsWallpaper("Lock");
              },
            ),
            ListTile(
              title: const Text("Set as Both Screens",
                  style: TextStyle(color: Colors.blue)),
              onTap: () {
                Navigator.pop(context);
                setAsWallpaper("Both");
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
            child: Hero(
              tag: widget.imagePath,
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 5,
                child: AspectRatio(
                  aspectRatio: 9 / 16, 
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.imagePath),
                        fit: BoxFit.contain, 
                      ),
                    ),
                  ),
                ),
              ),
            ),
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

          // ✅ Full-screen progress overlay
          if (_isSetting)
            Container(
              color: Colors.black.withAlpha(178),
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



import 'dart:convert';
import 'package:final_project/pages/video.dart';
import 'package:final_project/pages/vieoCaroselsilser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class LiveWallpaperScreen extends StatefulWidget {
  const LiveWallpaperScreen({super.key});

  @override
  State<LiveWallpaperScreen> createState() => _LiveWallpaperScreenState();
}

class _LiveWallpaperScreenState extends State<LiveWallpaperScreen> {
  List<VideoModel> videos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLiveWallpapers();
  }

  Future<void> fetchLiveWallpapers() async {
    final response = await http.get(
      Uri.parse('https://api.pexels.com/videos/search?query=live wallpaper&per_page=60'),
      headers: {
        'Authorization': "bBzBgGOjYSQ1MHJHX8lOJ48RWesfVfJkurARjTSRdTh7wACkmunR5iyt"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List fetched = data['videos'];
      setState(() {
        videos = fetched.map((e) => VideoModel.fromMap(e)).toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      print('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: videos.length,
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoCaroselSlider(
                          videos: videos,
                          initialpage: index,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: videos[index].image,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) =>
                          const Center(child: CircularProgressIndicator(strokeWidth: 1)),
                      errorWidget: (ctx, url, err) =>
                          const Icon(Icons.broken_image, color: Colors.red),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
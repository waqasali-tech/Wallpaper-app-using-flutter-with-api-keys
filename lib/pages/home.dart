
import 'dart:convert';
import 'dart:math';

import 'package:final_project/pages/Coursel.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'photosmodel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<PhotosModel> photos = [];
  int page = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  late AnimationController _titleAnimationController;
  late Animation<Offset> _slideAnimation;
  bool hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();


    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !isLoading) {
        page++;
        fetchWallpapers();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!hasLoadedOnce) {
        fetchWallpapers();
        hasLoadedOnce = true;
      }
    });
  }

  Future<void> fetchWallpapers() async {
    setState(() => isLoading = true);
        try {
      final response = await http.get(
        Uri.parse(
             "https://api.pexels.com/v1/curated?per_page=20&page=${Random().nextInt(50)}"),
        headers: {
          "Authorization":
              "bBzBgGOjYSQ1MHJHX8lOJ48RWesfVfJkurARjTSRdTh7wACkmunR5iyt"
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
             final List<PhotosModel> newPhotos = [];

        for (var element in jsonData["photos"]) {
             newPhotos.add(PhotosModel.fromMap(element));
        }

              setState(() {
          photos.addAll(newPhotos);
        });
      } else {
                  print("Failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
        super.build(context);

    return Scaffold(
appBar: AppBar(
  title: Text(
    "Pull Down to explore new",
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.deepOrange,
      shadows: [
        Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black45),
      ],
    ),
  ),
),
body: photos.isEmpty && isLoading
    ? const Center(child: CircularProgressIndicator(strokeWidth: 3))
    : LiquidPullToRefresh(
        onRefresh: () async {
          setState(() {
            photos.clear();
            page = 1;
          });
          await fetchWallpapers();
        },
        color: Colors.blue,
        backgroundColor: Colors.white,
        height: 160,
        animSpeedFactor: 1.5,
        showChildOpacityTransition: true,
        child: GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: photos.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2 / 3,
          ),
          itemBuilder: (context, index) {
            if (index == photos.length) {
              return isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }

            return GestureDetector(
              onTap: () {
                List<String> imageUrls = photos
                    .map((photo) => photo.src?.large ?? '')
                    .toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CursorNetworkSlider(
                      imageUrls: imageUrls,
                      initialPage: index,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: CachedNetworkImage(
                    imageUrl: photos[index].src?.large ?? '',
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2)),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}

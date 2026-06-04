import 'dart:convert';
import 'dart:math';
import 'package:final_project/pages/Coursel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_project/pages/photosmodel.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final List<String> categoryTitles = [
    "Allah",
    "City",
    "Food",
    "Nature",
    "Wildlife",
    "Babies",
    "Fishes",
    "Cars",
    "Flowers",
    "3D-View",
    
    "Space",
    "Technology",

  ];

  final List<String> categoryImages = [
    "images/Allah.jpeg",
    "images/City.jpeg",
    "images/Food.jpeg",
    "images/Nature.jpeg",
    "images/wildlife.jpeg",
    "images/babies.jpeg",
    "images/Fishes.jpeg",
    "images/Cars.jpeg",
    "images/Flowers.jpeg",
    "images/3D.jpeg",
    
    "images/Space.jpeg",
    "images/Technology.jpeg",
   
  ];

  final Map<String, String> categoryQueries = {
    "Allah": "islamic calligraphy mosque quran muslim",
    "City": "city skyline buildings street urban night",
    "Food": "delicious food dishes meals gourmet",
    "Nature": "nature mountain lake forest scenery",
    "Wildlife": "wild animals safari jungle nature",
    "Babies": "cute baby newborn infant portrait",
    "Fishes": "colorful fish underwater sea ocean",
    "Cars": "sports cars luxury vehicles supercars",
    "Flowers": "beautiful flowers garden colorful blossoms",
    "3D-View": "3d illustration render futuristic abstract",
    "Sports": "sports action games athletes competition",
    "Birds": "birds flying colorful feathers nature",
    "Space": "space planets stars galaxy nebula",
    "Technology": "modern technology gadgets digital",
    "Fantasy": "fantasy art dragons magic mythical",
  };

  List<PhotosModel> photos = [];
  bool isLoading = false;
  String selectedCategory = "";

  Future<void> getCategoryWallpaper(String category) async {
    setState(() {
      isLoading = true;
      selectedCategory = category;
    });

    final String query = categoryQueries[category] ?? category;
    final int page = Random().nextInt(3) + 1; // Random page 1–3

    final url = Uri.parse(
        "https://api.pexels.com/v1/search?query=$query&per_page=50&page=$page&orientation=landscape");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "bBzBgGOjYSQ1MHJHX8lOJ48RWesfVfJkurARjTSRdTh7wACkmunR5iyt"
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<PhotosModel> loadedPhotos = [];

      for (var element in jsonData["photos"]) {
        final photo = PhotosModel.fromMap(element);
        if (photo.src?.large != null && photo.src!.large!.isNotEmpty) {
          loadedPhotos.add(photo);
        }
      }

      setState(() {
        photos = loadedPhotos;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      print("Failed to load images for category $category");
    }
  }

 Widget wallpaperGrid(List<PhotosModel> photos) {
  List<String> imageUrls = photos.map((photo) => photo.src?.large ?? '').toList();

  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    itemCount: photos.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.6,
    ),
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
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
          child: Image.network(
            photos[index].src?.large ?? '',
            fit: BoxFit.cover,
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectedCategory.isNotEmpty
          ? AppBar(
              title: Text(selectedCategory),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedCategory = "";
                    photos.clear();
                  });
                },
              ),
            )
          : null,
      body: selectedCategory.isEmpty
          ? ListView.builder(
              padding: const EdgeInsets.only(top: 20),
              itemCount: min(categoryTitles.length, categoryImages.length),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => getCategoryWallpaper(categoryTitles[index]),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            categoryImages[index],
                            width: MediaQuery.of(context).size.width,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                              color: Colors.black45,
                            ),
                            child: Center(
                              child: Text(
                                categoryTitles[index],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.indigo),
                )
              : wallpaperGrid(photos),
    );
  }
}

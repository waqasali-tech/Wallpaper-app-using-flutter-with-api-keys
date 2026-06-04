import 'dart:convert';
import 'package:final_project/pages/Coursel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'photosmodel.dart';
import 'package:final_project/microphone/text_to_specch.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<PhotosModel> photos = [];
  TextEditingController searchcontroller = TextEditingController();
  bool search = false;
  bool isLoading = false;

  void clearSearch() {
    searchcontroller.clear();
    setState(() {
      search = false;
      photos = [];
    });
  }

  Future<void> getSearchWallpaper(String searchQuery) async {
    if (searchQuery.trim().isEmpty) return;

    setState(() => isLoading = true);
    final response = await http.get(
      Uri.parse("https://api.pexels.com/v1/search?query=$searchQuery&per_page=200"),
      headers: {
        "Authorization": "bBzBgGOjYSQ1MHJHX8lOJ48RWesfVfJkurARjTSRdTh7wACkmunR5iyt"
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<PhotosModel> loadedPhotos = [];

      for (var element in jsonData["photos"]) {
        loadedPhotos.add(PhotosModel.fromMap(element));
      }

      setState(() {
        photos = loadedPhotos;
        search = true;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      print("Failed to load images");
    }
  }

  Widget wallpaper(List<PhotosModel> photos, BuildContext context) {
  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    itemCount: photos.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.6,
    ),
    itemBuilder: (context, index) {
      final imageUrls = photos.map((photo) => photo.src?.portrait ?? '').toList();

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
            photos[index].src?.portrait ?? '',
            fit: BoxFit.cover,
          ),
        ),
      );
    },
  );
}

Future<void> openSpeechToText() async {
  final spokenText = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const TextToSpecch()),
  );

  if (spokenText != null && spokenText is String && spokenText.isNotEmpty) {
    searchcontroller.text = spokenText;
    getSearchWallpaper(spokenText);
    FocusScope.of(context).unfocus(); 
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              
              "Search",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchcontroller,
                      onSubmitted: getSearchWallpaper,
                      decoration: const InputDecoration(
                   iconColor: Colors.cyan,
                        fillColor: Colors.cyan,
                        hintText: "Search for wallpapers 😘",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(search ? Icons.close : Icons.search,
                    color: Colors.white),
                    onPressed: () {
                      if (search) {
                        clearSearch();
                      } else {
                        getSearchWallpaper(searchcontroller.text);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic,
                    color: Colors.red,),
                    onPressed: openSpeechToText,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
  child: isLoading
      ? const Center(
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                color: Colors.indigo,
                strokeWidth: 4,
                
              ),
              SizedBox(height: 10), 
              Text(
                "Loading...",
                style: TextStyle(
                  color: Colors.indigo, 
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )
      : wallpaper(photos, context),
),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_project/pages/photosmodel.dart';
import 'package:flutter/material.dart';


Widget wallpaper(List<PhotosModel> listPhotos, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: listPhotos.map((PhotosModel photosModel) {
        return GridTile(
          child: Hero(
            tag: photosModel
                .src!.portrait!, // Use null check here or handle null
            child: Container(
              //Added a container
              child: CachedNetworkImage(
                imageUrl: photosModel.src!.portrait!, // Use null check here
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

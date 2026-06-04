class PhotosModel {
  String? url;
  SrcModel? src; 

  PhotosModel({this.url, this.src});

  factory PhotosModel.fromMap(Map<String, dynamic> parsedJson) {
    return PhotosModel(
      url: parsedJson["url"],
      src: SrcModel.fromMap(parsedJson["src"]),
    );
  }
}

class SrcModel {
  String? portrait;
  String? large;
  String? landscape;
  String? medium;

  SrcModel({this.landscape, this.large, this.medium, this.portrait});

  factory SrcModel.fromMap(Map<String, dynamic> json) {
    return SrcModel(
      landscape: json["landscape"],
      large: json["large"],
      medium: json["medium"],
      portrait: json["portrait"],
    );
  }
}

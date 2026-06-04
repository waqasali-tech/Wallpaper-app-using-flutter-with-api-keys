
class VideoModel {
  final int id;
  final String image; 
  final String videoUrl;

  VideoModel({
    required this.id,
    required this.image,
    required this.videoUrl,
  });

  factory VideoModel.fromMap(Map<String, dynamic> json) {
    final videoFiles = json['video_files'] as List;

    final videoLink = videoFiles.firstWhere(
      (file) => file['quality'] == 'hd',
      orElse: () => videoFiles.first,
    )['link'];

    return VideoModel(
      id: json['id'],
      image: json['image'],
      videoUrl: videoLink,
    );
  }
}

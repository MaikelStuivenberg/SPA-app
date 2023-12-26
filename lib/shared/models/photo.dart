class Photo {
  Photo({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    required this.likes,
    required this.likedBy,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      likes: json['likes'] as int,
      likedBy: json['likedBy'] as List<String>,
    );
  }

  final String id;
  final String url;
  final String thumbnailUrl;
  int likes;
  final List<String> likedBy;
}

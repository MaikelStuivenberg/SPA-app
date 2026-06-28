class Photo {
  const Photo({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    required this.likes,
    required this.likedBy,
  });

  final String id;
  final String url;
  final String thumbnailUrl;
  final int likes;
  final List<String> likedBy;

  Photo copyWith({
    int? likes,
    List<String>? likedBy,
  }) {
    return Photo(
      id: id,
      url: url,
      thumbnailUrl: thumbnailUrl,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
    );
  }
}

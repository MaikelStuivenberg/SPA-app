class PhotoAlbum {
  const PhotoAlbum({
    required this.id,
    required this.title,
    required this.coverThumbnailUrl,
    this.photoCount = 0,
    this.isFavorites = false,
  });

  final String id;
  final String title;
  final String coverThumbnailUrl;
  final int photoCount;
  final bool isFavorites;
}

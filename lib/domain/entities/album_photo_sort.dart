enum AlbumPhotoSort {
  newestFirst,
  oldestFirst;

  String get flickrValue => switch (this) {
        AlbumPhotoSort.newestFirst => 'date-taken-desc',
        AlbumPhotoSort.oldestFirst => 'date-taken-asc',
      };

  AlbumPhotoSort get toggled => switch (this) {
        AlbumPhotoSort.newestFirst => AlbumPhotoSort.oldestFirst,
        AlbumPhotoSort.oldestFirst => AlbumPhotoSort.newestFirst,
      };
}

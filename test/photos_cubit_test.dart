import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spa_app/domain/entities/album_photo_sort.dart';
import 'package:spa_app/domain/entities/photo.dart';
import 'package:spa_app/domain/repositories/photo_repository.dart';
import 'package:spa_app/ui/features/photos/cubit/photos_cubit.dart';

class _MockPhotoRepository extends Mock implements PhotoRepository {}

void main() {
  late PhotoRepository photoRepository;

  const albumId = '72177720331523846';

  const photo = Photo(
    id: '1',
    url: 'https://example.com/large.jpg',
    thumbnailUrl: 'https://example.com/thumb.jpg',
    likes: 0,
    likedBy: [],
  );

  const photoTwo = Photo(
    id: '2',
    url: 'https://example.com/large-2.jpg',
    thumbnailUrl: 'https://example.com/thumb-2.jpg',
    likes: 0,
    likedBy: [],
  );

  setUp(() {
    photoRepository = _MockPhotoRepository();
  });

  blocTest<PhotosCubit, PhotosState>(
    'fetchLastPhotos loads first album page',
    build: () {
      when(
        () => photoRepository.getAlbumImages(
          albumId,
          page: 1,
          sort: AlbumPhotoSort.newestFirst,
        ),
      ).thenAnswer((_) async => [photo]);
      return PhotosCubit(
        photoRepository: photoRepository,
        albumId: albumId,
      );
    },
    act: (cubit) => cubit.fetchLastPhotos(),
    expect: () => [
      isA<PhotosState>().having((s) => s.isLoading, 'loading', true),
      isA<PhotosState>()
          .having((s) => s.isLoading, 'loading', false)
          .having((s) => s.currentPage, 'page', 1)
          .having((s) => s.photos?.length, 'photo count', 1),
    ],
    verify: (_) {
      verify(
        () => photoRepository.getAlbumImages(
          albumId,
          page: 1,
          sort: AlbumPhotoSort.newestFirst,
        ),
      ).called(1);
    },
  );

  blocTest<PhotosCubit, PhotosState>(
    'fetchMorePhotos appends next album page',
    build: () {
      when(
        () => photoRepository.getAlbumImages(
          albumId,
          page: 1,
          sort: AlbumPhotoSort.newestFirst,
        ),
      ).thenAnswer((_) async => [photo]);
      when(
        () => photoRepository.getAlbumImages(
          albumId,
          page: 2,
          sort: AlbumPhotoSort.newestFirst,
        ),
      ).thenAnswer((_) async => [photoTwo]);
      return PhotosCubit(
        photoRepository: photoRepository,
        albumId: albumId,
      );
    },
    act: (cubit) async {
      await cubit.fetchLastPhotos();
      await cubit.fetchMorePhotos();
    },
    expect: () => [
      isA<PhotosState>().having((s) => s.isLoading, 'loading', true),
      isA<PhotosState>()
          .having((s) => s.isLoading, 'loading', false)
          .having((s) => s.currentPage, 'page', 1),
      isA<PhotosState>().having((s) => s.isLoading, 'loading', true),
      isA<PhotosState>()
          .having((s) => s.isLoading, 'loading', false)
          .having((s) => s.currentPage, 'page', 2)
          .having((s) => s.photos?.length, 'photo count', 2),
    ],
  );

  blocTest<PhotosCubit, PhotosState>(
    'toggleSort reloads photos with oldest-first sort',
    build: () {
      when(
        () => photoRepository.getAlbumImages(
          albumId,
          page: 1,
          sort: AlbumPhotoSort.newestFirst,
        ),
      ).thenAnswer((_) async => [photo]);
      when(
        () => photoRepository.getAlbumImages(
          albumId,
          sort: AlbumPhotoSort.oldestFirst,
        ),
      ).thenAnswer((_) async => [photoTwo]);
      return PhotosCubit(
        photoRepository: photoRepository,
        albumId: albumId,
      );
    },
    act: (cubit) async {
      await cubit.fetchLastPhotos();
      await cubit.toggleSort();
    },
    expect: () => [
      isA<PhotosState>().having((s) => s.isLoading, 'loading', true),
      isA<PhotosState>()
          .having((s) => s.sort, 'sort', AlbumPhotoSort.newestFirst),
      isA<PhotosState>()
          .having((s) => s.isLoading, 'loading', true)
          .having((s) => s.sort, 'sort', AlbumPhotoSort.oldestFirst),
      isA<PhotosState>()
          .having((s) => s.isLoading, 'loading', false)
          .having((s) => s.sort, 'sort', AlbumPhotoSort.oldestFirst)
          .having((s) => s.photos?.single.id, 'photo id', '2'),
    ],
    verify: (_) {
      verify(
        () => photoRepository.getAlbumImages(
          albumId,
          sort: AlbumPhotoSort.oldestFirst,
        ),
      ).called(1);
    },
  );
}

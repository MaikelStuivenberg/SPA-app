import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/domain/entities/album_photo_sort.dart';
import 'package:spa_app/domain/entities/photo.dart';
import 'package:spa_app/domain/entities/photo_album_ids.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/features/photos/cubit/albums_cubit.dart';
import 'package:spa_app/ui/features/photos/cubit/photos_cubit.dart';
import 'package:spa_app/ui/features/photos/widgets/photo_selection.dart';

class AlbumPhotosPage extends StatefulWidget {
  const AlbumPhotosPage({required this.albumId, super.key});

  final String albumId;

  bool get isFavorites => albumId == PhotoAlbumIds.favorites;

  @override
  State<AlbumPhotosPage> createState() => _AlbumPhotosPageState();
}

class _AlbumPhotosPageState extends State<AlbumPhotosPage> {
  final _scrollViewController = ScrollController();

  static const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 4,
    mainAxisSpacing: 4,
    childAspectRatio: 4 / 5,
  );

  @override
  void initState() {
    super.initState();

    _scrollViewController.addListener(() {
      if (_scrollViewController.position.extentAfter < 1000) {
        context.read<PhotosCubit>().fetchMorePhotos();
      }
    });
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    super.dispose();
  }

  String _albumTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final album = context.read<AlbumsCubit>().albumById(widget.albumId);
    if (album?.isFavorites ?? false) {
      return l10n.photoAlbumFavorites;
    }
    return album?.title ?? l10n.photoAlbumPhotosTitle;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<PhotosCubit, PhotosState>(
          listenWhen: (previous, current) => previous.sort != current.sort,
          listener: (context, state) {
            if (_scrollViewController.hasClients) {
              _scrollViewController.jumpTo(0);
            }
          },
        ),
        if (widget.isFavorites)
          BlocListener<PhotosCubit, PhotosState>(
            listenWhen: (previous, current) =>
                previous.photos?.length != current.photos?.length,
            listener: (context, state) {
              context.read<AlbumsCubit>().fetchAlbums();
            },
          ),
      ],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 48, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                Expanded(
                  child: Text(
                    _albumTitle(context),
                    style: Theme.of(context).textTheme.headlineLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!widget.isFavorites)
                  BlocBuilder<PhotosCubit, PhotosState>(
                    buildWhen: (previous, current) =>
                        previous.sort != current.sort,
                    builder: (context, state) {
                      final isNewestFirst =
                          state.sort == AlbumPhotoSort.newestFirst;
                      return IconButton(
                        icon: Icon(
                          isNewestFirst
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                        ),
                        tooltip: isNewestFirst
                            ? l10n.photoAlbumSortShowOldest
                            : l10n.photoAlbumSortShowNewest,
                        onPressed: () =>
                            context.read<PhotosCubit>().toggleSort(),
                      );
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<PhotosCubit, PhotosState>(
                builder: (context, state) {
                  if (state.isLoading &&
                      (state.photos == null || state.photos!.isEmpty)) {
                    return Center(
                      child: SizedBox(
                        width: 64,
                        height: 64,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  }
                  return _buildPhotoGrid(context, l10n, state.photos);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(
    BuildContext context,
    AppLocalizations l10n,
    List<Photo>? photos,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    if (photos == null || photos.isEmpty) {
      return Center(
        child: Text(
          widget.isFavorites
              ? l10n.profilePhotosLikedEmpty
              : l10n.photoAlbumsEmpty,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurface,
          ),
        ),
      );
    }

    return SelectablePhotoGrid(
      photos: photos,
      gridDelegate: _gridDelegate,
      controller: _scrollViewController,
      showLikeBadge: true,
      floatAboveShellNavigation: true,
      onBulkLike: (selected) => bulkToggleLikePhotos(context, selected),
    );
  }
}

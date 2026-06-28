import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/domain/entities/photo_album.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/features/photos/cubit/albums_cubit.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({super.key});

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  static const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 4,
    mainAxisSpacing: 4,
    childAspectRatio: 4 / 5,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlbumsCubit>().fetchAlbums();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.photoTitle,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<AlbumsCubit, AlbumsState>(
              builder: (context, state) {
                if (state.isLoading && state.albums == null) {
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

                final albums = state.albums;
                final favoritesAlbum = state.favoritesAlbum;
                final hasFavorites = favoritesAlbum != null;
                final hasAlbums = albums != null && albums.isNotEmpty;

                if (!hasFavorites && !hasAlbums) {
                  return Center(
                    child: Text(
                      l10n.photoAlbumsEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                }

                final itemCount = (albums?.length ?? 0) + (hasFavorites ? 1 : 0);

                return GridView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  gridDelegate: _gridDelegate,
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (hasFavorites && index == 0) {
                      return _AlbumCard(album: favoritesAlbum);
                    }

                    final albumIndex = hasFavorites ? index - 1 : index;
                    return _AlbumCard(album: albums![albumIndex]);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _AlbumCard extends StatelessWidget {
  const _AlbumCard({required this.album});

  final PhotoAlbum album;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final scrim = context.appColors.scrim;
    final title =
        album.isFavorites ? l10n.photoAlbumFavorites : album.title;

    return GestureDetector(
      onTap: () => context.push(RoutePaths.photosAlbumFor(album.id)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: album.coverThumbnailUrl,
              fit: BoxFit.cover,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scrim.withValues(alpha: 0),
                    scrim.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
            if (album.isFavorites)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  FontAwesomeIcons.solidHeart,
                  color: context.appColors.favorite,
                  size: 18,
                ),
              ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (album.photoCount > 0)
                    Text(
                      l10n.photoAlbumPhotoCount(album.photoCount),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary.withValues(alpha: 0.9),
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

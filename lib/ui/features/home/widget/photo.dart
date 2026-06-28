import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/ui/core/widgets/card.dart';
import 'package:spa_app/ui/features/photos/cubit/albums_cubit.dart';

class PhotoWidget extends StatefulWidget {
  const PhotoWidget({super.key});

  @override
  State<PhotoWidget> createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumsCubit, AlbumsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Expanded(
            child: CardWidget(
              height: 200,
              child: const SizedBox.expand(
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        }

        final albums = state.albums;
        if (albums == null || albums.isEmpty) {
          return Container();
        }

        final latestAlbum = albums.first;

        return Expanded(
          child: CardWidget(
            padding: 0,
            height: 200,
            onTap: () =>
                context.go(RoutePaths.photosAlbumFor(latestAlbum.id)),
            child: SizedBox.expand(
              child: CachedNetworkImage(
                imageUrl: latestAlbum.coverThumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}

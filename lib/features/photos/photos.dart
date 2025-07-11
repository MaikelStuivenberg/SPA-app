import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_app/features/photos/cubit/photos_cubit.dart';
import 'package:spa_app/features/photos/widgets/photo.dart';
import 'package:spa_app/shared/models/photo.dart';
import 'package:spa_app/shared/repositories/photo_data.dart';
import 'package:spa_app/shared/widgets/default_body.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  PhotosPageState createState() => PhotosPageState();
}

class PhotosPageState extends State<PhotosPage> {
  final photoDataRepository = PhotoDataRepository();
  final _scrollViewController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollViewController.addListener(() {
      // When on 3/4 of the page, load more photos
      if (_scrollViewController.position.extentAfter < 1000) {
        BlocProvider.of<PhotosCubit>(context).fetchMorePhotos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.photoTitle,
      Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<PhotosCubit, PhotosState>(
                builder: (context, state) {
                  if (state.isLoading && state.currentPage == 0) {
                    return const Center(
                      child: SizedBox(
                        width: 64,
                        height: 64,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                  return _buildPhotoGrid(state.photos);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(List<Photo>? photos) {
    if (photos == null || photos.isEmpty) {
      return const Center(
        child: Text(
          "We zijn druk bezig met het maken van foto's van dit jaar! Check later nog eens. :)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      );
    }
    return GridView.builder(
      controller: _scrollViewController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 4 / 5,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              // isScrollControlled: true,
              barrierColor: Colors.black87,
              backgroundColor: Colors.transparent,
              builder: (context) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
                child: PhotoStateWidget(photo),
              ),
            );
          },
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 4 / 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: photo.thumbnailUrl,
                    cacheKey: photo.thumbnailUrl,
                    fadeInDuration: Duration.zero,
                    fit: BoxFit.cover,
                    errorListener: (error) => const Center(
                      child: Icon(Icons.error_outline),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 6,
                top: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        photo.likes.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

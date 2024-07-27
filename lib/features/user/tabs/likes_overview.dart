import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/shared/models/photo.dart';
import 'package:spa_app/shared/repositories/photo_data.dart';

class LikesOverview extends StatefulWidget {
  LikesOverview({super.key});

  @override
  State<LikesOverview> createState() => _LikesOverviewState();
}

class _LikesOverviewState extends State<LikesOverview> {
  late Future<List<Photo>> photos;

  @override
  Widget build(BuildContext context) {
    photos = PhotoDataRepository().getMyLikedPhotos();

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildGridView(snapshot.data!);
        } else if (snapshot.hasError) {
          return const Text(''); 
        }
        return const Center(
          child: SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(),
          ),
        );
      },
      future: photos,
    );
  }

  Widget _buildGridView(List<Photo> photos) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.solidHeart,
                color: Colors.red,
              ),
              Container(width: 4),
              Text(
                AppLocalizations.of(context)!.profilePhotosLiked,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 16),
              child: GridView.builder(
                itemCount: photos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return _buildGridItem(photos[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(Photo photo) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: photo.thumbnailUrl,
                  fit: BoxFit.cover,
                  height: 400,
                  errorListener: (error) => const Center(
                    child: Icon(Icons.error_outline),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

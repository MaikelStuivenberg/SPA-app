import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/shared/models/photo.dart';
import 'package:spa_app/shared/repositories/photo_data.dart';

class LikesOverview extends StatelessWidget {
  late Future<List<Photo>> photos;
  @override
  Widget build(BuildContext context) {
    photos = PhotoDataRepository().getMyLikedPhotos();

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildGridView(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
      future: photos,
    );
  }

  Widget _buildGridView(List<Photo> photos) {
    return GridView.builder(
        itemCount: photos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1,),
        itemBuilder: (context, index) {
          return _buildGridItem(photos[index]);
        });
  }

  Widget _buildGridItem(Photo photo) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
        ],
      ),
    );
  }
}

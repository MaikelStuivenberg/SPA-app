import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:spa_app/features/photos/widgets/photo.dart';
import 'package:spa_app/shared/models/photo.dart';
import 'package:spa_app/shared/repositories/photo_data.dart';
import 'package:spa_app/shared/repositories/user_data.dart';

class LikesOverview extends StatefulWidget {
  const LikesOverview({super.key});

  @override
  State<LikesOverview> createState() => _LikesOverviewState();
}

class _LikesOverviewState extends State<LikesOverview> {
  final int _pageSize = 9;
  final List<Photo> _photos = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDoc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _fetchPhotos();
    }
  }

  Future<void> _fetchPhotos() async {
    setState(() {
      _isLoading = true;
    });
    final repo = PhotoDataRepository();
    Query query = repo.photosCollection
        .where('likedBy',
            arrayContains: (await UserDataRepository().getFirebaseUser()).id,)
        .orderBy(FieldPath.documentId, descending: true)
        .limit(_pageSize);
    if (_lastDoc != null) {
      query = query.startAfterDocument(_lastDoc!);
    }
    final querySnapshot = await query.get();
    final docs = querySnapshot.docs;
    if (docs.isNotEmpty) {
      _lastDoc = docs.last;
    }
    final newPhotos = <Photo>[];
    for (final doc in docs) {
      final photoId = doc.id;
      var url = 'https://www.flickr.com/services/rest/';
      url += '?method=flickr.photos.getSizes&api_key=${repo.apiKey}';
      url +=
          '&photo_id=$photoId&format=json&nojsoncallback=1&extras=url_m,url_k';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        continue;
      }
      final data = json.decode(response.body) as Map<String, dynamic>;
      final sizes = data['sizes']['size'] as List<dynamic>;
      final photoData = Photo(
        id: photoId,
        url: sizes.firstWhere((element) =>
            element['label'].toString() == 'Large 2048',)['source'] as String,
        thumbnailUrl: sizes.firstWhere(
                (element) => element['label'].toString() == 'Medium',)['source']
            as String,
        likes: await repo.getLikes(photoId),
        likedBy: await repo.getLikedBy(photoId),
      );
      newPhotos.add(photoData);
    }
    setState(() {
      _photos.addAll(newPhotos);
      _isLoading = false;
      if (docs.length < _pageSize) {
        _hasMore = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.solidHeart,
              color: Colors.red,
              size: 16,
            ),
            Container(width: 8),
            Text(
              AppLocalizations.of(context)!.profilePhotosLiked,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Container(height: 16),
        Expanded(
          child: _photos.isEmpty && _isLoading
              ? const Center(
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(),
                  ),
                )
              : GridView.builder(
                  controller: _scrollController,
                  itemCount: _photos.length + (_hasMore ? 1 : 0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 4 / 5,
                  ),
                  itemBuilder: (context, index) {
                    if (index < _photos.length) {
                      return _buildGridItem(_photos[index]);
                    } else {
                      // Loading indicator at the bottom
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
        ),
      ],
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
              padding: const EdgeInsets.only(top: 16, left: 2, right: 2),
              child: GridView.builder(
                itemCount: photos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 4 / 5, // slightly higher photos
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
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  barrierColor: Colors.black87,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
                    child: PhotoStateWidget(photo),
                  ),
                );
              },
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: photo.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorListener: (error) => const Center(
                      child: Icon(Icons.error_outline),
                    ),
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

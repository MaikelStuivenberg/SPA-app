import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:http/http.dart' as http;
import 'package:spa_app/shared/models/photo.dart';
import 'package:spa_app/shared/repositories/user_data.dart';

class PhotoDataRepository {
  final CollectionReference<Map<String, dynamic>> photosCollection =
      FirebaseFirestore.instance.collection('photos');

  Future<List<Photo>> getRecentImages() async {
    final photos = <Photo>[];
    final remoteConfig = FirebaseRemoteConfig.instance;
    final minUploadDate = remoteConfig.getInt('flickr_min_upload_date');
    final maxUploadDate = remoteConfig.getInt('flickr_max_upload_date');
    final photosPerPage = remoteConfig.getInt('show_photos_per_page');

    const apiKey = '639f377344ffa79f1f0ebc8349dbae6f';
    const userId = '195851792@N04';

    var url = 'https://www.flickr.com/services/rest/';
    url += '?method=flickr.people.getPhotos&api_key=$apiKey';
    url += '&user_id=$userId&extras=url_m,date_taken';
    url += '&sort=date-taken-desc&min_upload_date=$minUploadDate';
    url += '&max_upload_date=$maxUploadDate';
    url += '&per_page=$photosPerPage&format=json';
    url += '&nojsoncallback=1&extras=url_m,url_k';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final photos = data['photos']['photo'] as List<dynamic>;

      for (final photo in photos) {
        final photoId = photo['id'] as String;
        final photoUrl = photo['url_m'] as String;
        final thumbnailUrl = photo['url_k'] as String;

        final photoData = Photo(
          id: photoId,
          url: photoUrl,
          thumbnailUrl: thumbnailUrl,
          likes: await getLikes(photoId),
          likedBy: [],
        );

        photos.add(photoData);
        // 'likedBy': await getLikedBy(photoId),
      }
    }

    return photos;
  }

  Future<void> addLike(String photoId) async {
    final userId = (await UserDataRepository().getFirebaseUser()).id;

    await photosCollection.doc(photoId).update({
      'likes': FieldValue.increment(1),
      'likedBy': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> removeLike(String photoId) async {
    final userId = (await UserDataRepository().getFirebaseUser()).id;

    await photosCollection.doc(photoId).update({
      'likes': FieldValue.increment(-1),
      'likedBy': FieldValue.arrayRemove([userId]),
    });
  }

  Future<int> getLikes(String photoId) async {
    final snapshot = await photosCollection.doc(photoId).get();
    final data = snapshot.data();
    return data!['likes'] as int;
  }

  Future<List<String>> getLikedBy(String photoId) async {
    final snapshot = await photosCollection.doc(photoId).get();
    final data = snapshot.data();
    return List<String>.from(data!['likedBy'] as List<String>);
  }

  Future<List<String>> getMyLikedPhotos() async {
    final userId = (await UserDataRepository().getFirebaseUser()).id;
    
    final querySnapshot =
        await photosCollection.where('likedBy', arrayContains: userId).get();
    final likedPhotos = querySnapshot.docs.map((doc) => doc.id).toList();
    return likedPhotos;
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:http/http.dart' as http;
import 'package:spa_app/shared/models/photo.dart';
import 'package:spa_app/shared/repositories/user_data.dart';

class PhotoDataRepository {
  final CollectionReference<Map<String, dynamic>> photosCollection =
      FirebaseFirestore.instance.collection('photos');

  final apiKey = '639f377344ffa79f1f0ebc8349dbae6f';
  final userId = '195851792@N04';

  Future<List<Photo>> getRecentImages(int page) async {
    final photoResult = <Photo>[];
    final remoteConfig = FirebaseRemoteConfig.instance;
    final minUploadDate = remoteConfig.getInt('flickr_min_upload_date');
    final maxUploadDate = remoteConfig.getInt('flickr_max_upload_date');
    final photosPerPage = remoteConfig.getInt('show_photos_per_page');
    var url = 'https://www.flickr.com/services/rest/';
    url += '?method=flickr.people.getPhotos&api_key=$apiKey';
    url += '&user_id=$userId&extras=url_m,date_taken';
    url += '&sort=date-taken-desc&min_upload_date=$minUploadDate';
    url += '&max_upload_date=$maxUploadDate';
    url += '&per_page=$photosPerPage&page=$page&format=json';
    url += '&nojsoncallback=1&extras=url_m,url_k';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final photos = data['photos']['photo'] as List<dynamic>;

      for (final photo in photos) {
        final photoId = photo['id'] as String;
        final photoUrl = photo['url_k'] as String;
        final thumbnailUrl = photo['url_m'] as String;

        final photoData = Photo(
          id: photoId,
          url: photoUrl,
          thumbnailUrl: thumbnailUrl,
          likes: await getLikes(photoId),
          likedBy: await getLikedBy(photoId),
        );

        photoResult.add(photoData);
      }
    }

    return photoResult;
  }

  Future<void> addLike(String photoId) async {
    final userId = (await UserDataRepository().getFirebaseUser()).id;

    // Check if doc exists
    final doc = await photosCollection.doc(photoId).get();
    if (!doc.exists) {
      await photosCollection.doc(photoId).set({
        'likedBy': [userId],
      });
      return;
    }

    await photosCollection.doc(photoId).update({
      'likedBy': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> removeLike(String photoId) async {
    final userId = (await UserDataRepository().getFirebaseUser()).id;

    await photosCollection.doc(photoId).update({
      'likedBy': FieldValue.arrayRemove([userId]),
    });
  }

  Future<int> getLikes(String photoId) async {
    final snapshot = await photosCollection.doc(photoId).get();
    final data = snapshot.data();

    if (data == null || data['likedBy'] == null) {
      return 0;
    }

    return data['likedBy'].length as int;
  }

  Future<List<String>> getLikedBy(String photoId) async {
    final snapshot = await photosCollection.doc(photoId).get();
    final data = snapshot.data();

    if (data == null) {
      return [];
    }

    var result = data['likedBy'] as List<dynamic>;
    return result.map((e) => e.toString()).toList();
  }

  Future<List<Photo>> getMyLikedPhotos() async {
    final userId = (await UserDataRepository().getFirebaseUser()).id;

    final querySnapshot =
        await photosCollection.where('likedBy', arrayContains: userId).get();
    final myPhotos = querySnapshot.docs.map((doc) => doc.id).toList();

    final likedPhotos = <Photo>[];

    for (final photoId in myPhotos) {
      // final photo = await photosCollection.doc(photoId).get();
      // final snapshotData = photo.data();

      // if (snapshotData == null) {
      //   continue;
      // }

      // get data from flickr
      var url = 'https://www.flickr.com/services/rest/';
      url += '?method=flickr.photos.getSizes&api_key=$apiKey';
      url +=
          '&photo_id=$photoId&format=json&nojsoncallback=1&extras=url_m,url_k';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        continue;
      }

      final data = json.decode(response.body);
      final sizes = data['sizes']['size'] as List<dynamic>;

      final photoData = Photo(
        id: photoId,
        url: sizes.firstWhere((element) =>
            element['label'].toString() == 'Large 2048')['source'] as String,
        thumbnailUrl: sizes.firstWhere(
                (element) => element['label'].toString() == 'Medium')['source']
            as String,
        likes: 0,
        // likes: data['likedBy'].length as int,
        likedBy: [],
        // likedBy: data['likedBy'].map((e) => e.toString()).toList(),
      );

      likedPhotos.add(photoData);
    }

    return likedPhotos;
  }
}

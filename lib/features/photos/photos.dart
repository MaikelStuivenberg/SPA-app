import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spa_app/features/user/models/user.dart';
import 'package:spa_app/shared/models/photo.dart';
import 'package:spa_app/shared/repositories/photo_data.dart';
import 'package:spa_app/shared/repositories/user_data.dart';
import 'package:spa_app/shared/widgets/default_body.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  PhotosPageState createState() => PhotosPageState();
}

class PhotosPageState extends State<PhotosPage> {
  final photoDataRepository = PhotoDataRepository();
  final userDataRepository = UserDataRepository();
  final List<Photo> _photos = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.photoTitle,
      SafeArea(
        maintainBottomViewPadding: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
            future: Future.wait([
              userDataRepository.getUser(),
              photoDataRepository.getRecentImages()
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _buildPhotoGrid(snapshot.data![0] as User, snapshot.data![1] as List<Photo>?);
              } else {
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
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(User currentUser, List<Photo>? photos) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: photos != null && _photos.isNotEmpty
          ? SingleChildScrollView(
              child: Expanded(
                child: Column(
                  children: List.generate(10, (i) {
                    return _buildPhoto(currentUser, photos[i]);
                  }),
                ),
              ),
            )
          : const Text(
              "We zijn druk bezig met het maken van foto's van dit jaar! Check later nog eens. :)",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
    );
  }

  Widget _buildPhoto(User currentUser, Photo photo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              photo.thumbnailUrl,
              semanticLabel: '',
              fit: BoxFit.cover,
              height: 400,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.error_outline),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: const Color.fromARGB(196, 255, 255, 255),
              ),
              padding: const EdgeInsets.all(2),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () async {
                      // Like photo
                      if (!photo.likedBy.contains(currentUser.id)) {
                        await photoDataRepository.addLike(photo.id);
                        setState(() {
                          photo.likes--;
                        });
                      } else {
                        await photoDataRepository.removeLike(photo.id);
                        setState(() {
                          photo.likes++;
                        });
                      }
                    },
                    icon: Column(
                      children: [
                        Icon(
                          photo.likedBy.contains(currentUser.id)
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: photo.likedBy.contains(currentUser.id)
                              ? Colors.red
                              : Colors.black,
                        ),
                        Text(photo.likes.toString()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () async {
                      final response = await http.get(Uri.parse(photo.url));
                      final directory = await getTemporaryDirectory();
                      final path = directory.path;
                      final file = File('$path/spa.jpg');
                      await file.writeAsBytes(response.bodyBytes);
                      await Share.shareXFiles([XFile('$path/spa.jpg')]);
                    },
                    icon: const Icon(FontAwesomeIcons.paperPlane),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

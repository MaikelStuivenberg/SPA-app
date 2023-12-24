import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_app/features/photos/widgets/photo.dart';
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

  final _userFuture = UserDataRepository().getUser();
  final _photosFuture = PhotoDataRepository().getRecentImages();

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
            future: Future.wait([_userFuture, _photosFuture]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _buildPhotoGrid(
                  snapshot.data![0] as User,
                  snapshot.data![1] as List<Photo>?,
                );
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
      child: photos != null && photos.isNotEmpty
          ? SingleChildScrollView(
              child: Expanded(
                child: Column(
                  children: List.generate(10, (i) {
                    return PhotoStateWidget(currentUser, photos[i]);
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
}

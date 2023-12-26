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
  final _photosFuture = PhotoDataRepository().getRecentImages(0);

  final _scrollViewController = ScrollController();
  List<Photo> _photos = [];
  var page = 1;
  var _currentlyLoading = true;

  @override
  void initState() {
    super.initState();

    photoDataRepository.getRecentImages(page).then((value) {
      setState(() {
        _currentlyLoading = false;
        _photos.addAll(value);
      });
    });

    _scrollViewController.addListener(() {
      // When on 3/4 of the page, load more photos
      if (_scrollViewController.position.extentAfter < 100 &&
          _currentlyLoading == false) {
        page = page + 1;
        _currentlyLoading = true;
        photoDataRepository.getRecentImages(page).then((value) {
          setState(() {
            _currentlyLoading = false;
            _photos.addAll(value);
          });
        });
      }
    });
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
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _buildPhotoGrid(
                  snapshot.data!,
                  _photos,
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
              controller: _scrollViewController,
              child: Expanded(
                child: Column(
                  children: List.generate(photos.length, (i) {
                    return PhotoStateWidget(currentUser, photos[i]);
                  }),
                ),
              ),
            )
          : _currentlyLoading
              ? const Center(
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      color: Colors.white,
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

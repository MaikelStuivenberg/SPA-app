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
      if (_scrollViewController.position.extentAfter < 500) {
        BlocProvider.of<PhotosCubit>(context).fetchMorePhotos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.photoTitle,
      Padding(
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

            return _buildPhotoGrid(
              state.photos,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(List<Photo>? photos) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: photos != null && photos.isNotEmpty
          ? SingleChildScrollView(
              controller: _scrollViewController,
              child: SafeArea(
                maintainBottomViewPadding: true,
                child: Column(
                  children: List.generate(photos.length, (i) {
                    return PhotoStateWidget(photos[i]);
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

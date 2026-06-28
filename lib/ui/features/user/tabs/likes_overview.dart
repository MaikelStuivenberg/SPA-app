import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/features/photos/widgets/photo.dart';
import 'package:spa_app/ui/features/photos/widgets/photo_selection.dart';
import 'package:spa_app/ui/features/user/cubit/user_profile_cubit.dart';

const _likesGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 3,
  crossAxisSpacing: 4,
  mainAxisSpacing: 4,
  childAspectRatio: 4 / 5,
);

class LikesOverview extends StatefulWidget {
  const LikesOverview({super.key});

  @override
  State<LikesOverview> createState() => _LikesOverviewState();
}

class _LikesOverviewState extends State<LikesOverview> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _ensureLikesLoaded();
    _scrollController.addListener(_onScroll);
  }

  void _ensureLikesLoaded() {
    final cubit = context.read<UserProfileCubit>();
    if (cubit.state.likedPhotos.isEmpty && !cubit.state.isLoadingLikes) {
      cubit.loadLikedPhotos();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<UserProfileCubit>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !cubit.state.isLoadingLikes &&
        cubit.state.hasMoreLikes) {
      cubit.loadLikedPhotos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.solidHeart,
                  color: context.appColors.favorite,
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
            Expanded(child: _buildContent(state)),
          ],
        );
      },
    );
  }

  Widget _buildContent(UserProfileState state) {
    if (state.likedPhotos.isEmpty && state.isLoadingLikes) {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: _likesGridDelegate,
        itemCount: UserProfileCubit.likesPageSize,
        itemBuilder: (context, index) => const PhotoGridSkeleton(),
      );
    }

    if (state.likedPhotos.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.profilePhotosLikedEmpty,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return SelectablePhotoGrid(
      photos: state.likedPhotos,
      gridDelegate: _likesGridDelegate,
      controller: _scrollController,
      itemCount: state.likedPhotos.length + (state.hasMoreLikes ? 1 : 0),
      likeActionIcon: FontAwesomeIcons.solidHeart,
      likeActionTooltip: AppLocalizations.of(context)!.photoSelectionUnlike,
      extraItemBuilder: (context, index) {
        return state.isLoadingLikes
            ? const PhotoGridSkeleton()
            : const SizedBox.shrink();
      },
      onBulkLike: (selected) =>
          context.read<UserProfileCubit>().removeLikedPhotos(selected),
      onViewerToggleLike: (photo, userId) async {
        if (photo.likedBy.contains(userId)) {
          await context.read<UserProfileCubit>().removeLikedPhotos([photo]);
        }
      },
    );
  }
}

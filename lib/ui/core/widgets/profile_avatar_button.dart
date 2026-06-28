import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/ui/features/auth/cubit/auth_cubit.dart';

/// Hero tag shared between Home greeting and profile screen.
const profileAvatarHeroTag = 'profile-avatar';

/// Tappable profile avatar that navigates to the user details screen.
class ProfileAvatarButton extends StatelessWidget {
  const ProfileAvatarButton({
    this.size = 36,
    this.heroTag,
    super.key,
  });

  final double size;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is! AuthStateSuccess) {
          return const SizedBox.shrink();
        }

        final user = state.user;
        final hasImage = user.image != null && user.image!.isNotEmpty;

        final avatar = CircleAvatar(
          radius: size / 2,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundImage: hasImage
              ? CachedNetworkImageProvider(user.imageUrl!)
              : const AssetImage('assets/profile_default.jpg')
                  as ImageProvider<Object>,
        );

        final taggedAvatar = heroTag != null
            ? Hero(tag: heroTag!, child: avatar)
            : avatar;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push(RoutePaths.userDetails),
            customBorder: const CircleBorder(),
            child: taggedAvatar,
          ),
        );
      },
    );
  }
}

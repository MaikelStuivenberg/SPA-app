import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/core/widgets/default_body.dart';
import 'package:spa_app/ui/core/widgets/profile_avatar_button.dart';
import 'package:spa_app/ui/features/user/cubit/user_profile_cubit.dart';
import 'package:spa_app/ui/features/user/tabs/likes_overview.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  UserDetailsPageState createState() => UserDetailsPageState();
}

class UserDetailsPageState extends State<UserDetailsPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<UserProfileCubit>();
    if (cubit.state.user == null) {
      cubit.loadUser();
    }
    if (cubit.state.likedPhotos.isEmpty && !cubit.state.isLoadingLikes) {
      cubit.loadLikedPhotos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.profileTitle,
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state.isLoadingUser && state.user == null) {
                return const Center(
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final user = state.user;
              if (user == null) {
                return Center(
                  child: Text(state.userError ?? 'Unable to load profile'),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      '${user.firstname} ${user.lastname}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Container(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        height: 96,
                        width: 96,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            Hero(
                              tag: profileAvatarHeroTag,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                foregroundImage: ((user.image != null &&
                                        user.image != '')
                                    ? CachedNetworkImageProvider(
                                        user.imageUrl!,
                                      )
                                    : const AssetImage(
                                        'assets/profile_default.jpg',
                                      )) as ImageProvider<Object>,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (user.major != null && user.major!.isNotEmpty)
                            Row(
                              children: [
                                Text(
                                  'Major: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  user.major!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          if (user.minor != null && user.minor!.isNotEmpty)
                            Row(
                              children: [
                                Text(
                                  'Minor: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  user.minor!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          if (user.biblestudyGroup != null &&
                              user.biblestudyGroup!.isNotEmpty)
                            Row(
                              children: [
                                Text(
                                  'Bijbelstudie groep: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  user.biblestudyGroup!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          if (user.tent != null && user.tent!.isNotEmpty)
                            Row(
                              children: [
                                Text(
                                  'Tent: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  user.tent!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                  Container(height: 24),
                  Container(
                    height: 0.5,
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    color: Theme.of(context).dividerColor,
                  ),
                  Container(height: 16),
                  const Expanded(child: LikesOverview()),
                ],
              );
            },
          ),
        ),
      ),
      showMenu: false,
      back: true,
      actions: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.penToSquare),
          onPressed: () {
            context.push(RoutePaths.editUser);
          },
        ),
      ],
    );
  }
}

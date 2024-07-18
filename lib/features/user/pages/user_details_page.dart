import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/features/user/tabs/likes_overview.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/repositories/user_data.dart';
import 'package:spa_app/shared/widgets/default_body.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  UserDetailsPageState createState() => UserDetailsPageState();
}

class UserDetailsPageState extends State<UserDetailsPage> {
  final UserDataRepository _userDataRepository = UserDataRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext parentContext) {
    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.profileTitle,
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: FutureBuilder(
            future: _userDataRepository.getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        '${snapshot.data!.firstname} ${snapshot.data!.lastname}',
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
                                tag: 'tag',
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundImage:
                                      ((snapshot.data?.image != null &&
                                              snapshot.data?.image != '')
                                          ? CachedNetworkImageProvider(
                                              snapshot.data!.imageUrl!,
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
                            if (snapshot.data!.major != null &&
                                snapshot.data!.major!.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                    'Major: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    '${snapshot.data!.major}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            if (snapshot.data!.minor != null &&
                                snapshot.data!.minor!.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                    'Minor: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    '${snapshot.data!.minor}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            if (snapshot.data!.biblestudyGroup != null &&
                                snapshot.data!.biblestudyGroup!.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                    'Bijbelstudie groep: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    '${snapshot.data!.biblestudyGroup}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            if (snapshot.data!.tent != null &&
                                snapshot.data!.tent!.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                    'Tent: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    '${snapshot.data!.tent}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                    Container(height: 24),
                    // border
                    Container(
                      height: 0.5,
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      color: Theme.of(context).dividerColor,
                    ),
                    Container(height: 16),

                    LikesOverview(),
                  ],
                );
              } else {
                return const Center(
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.penToSquare),
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.editUser);
          },
        ),
      ],
    );
  }
}

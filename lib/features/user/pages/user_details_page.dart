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
                if (snapshot.data == null ||
                    snapshot.data!.firstname == null ||
                    snapshot.data!.firstname!.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(parentContext).pushNamed(Routes.editUser);
                  });
                }
                // _firstnameController.text = snapshot.data!.firstname!;
                // _lastnameController.text = snapshot.data!.lastname!;
                // _ageController.text = snapshot.data!.age!;
                // _majorValue = snapshot.data!.major!;
                // _minorValue = snapshot.data!.minor!;

                return Column(
                  children: [
                    SizedBox(
                      height: 128,
                      width: 128,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          Hero(
                            tag: 'tag',
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundImage: ((snapshot.data?.image != null &&
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
                    Container(height: 16),
                    Text(
                      '${snapshot.data!.firstname} ${snapshot.data!.lastname}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Container(height: 4),
                    if (snapshot.data!.major != null &&
                        snapshot.data!.major!.isNotEmpty &&
                        snapshot.data!.minor != null &&
                        snapshot.data!.minor!.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (snapshot.data!.major != null &&
                              snapshot.data!.major!.isNotEmpty)
                            Text(
                              'Major: ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          Text(
                            '${snapshot.data!.major}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (FirebaseRemoteConfig.instance
                              .getBool('use_minor'))
                            Row(
                              children: [
                                Container(width: 16),
                                if (snapshot.data!.minor != null &&
                                    snapshot.data!.minor!.isNotEmpty)
                                  Text(
                                    'Minor: ',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                Text(
                                  '${snapshot.data!.minor}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                        ],
                      ),
                    Container(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.red,
                        ),
                        Container(width: 4),
                        Text(
                          AppLocalizations.of(context)!.profilePhotosLiked,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Container(height: 16),
                    // border
                    Container(
                      height: 0.5,
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      color: Theme.of(context).dividerColor,
                    ),
                    Expanded(child: LikesOverview()),
                  ],
                );
              } else {
                return const Center(
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                        ),
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
            Navigator.pushNamed(context, Routes.editUser);
          },
        ),
      ],
    );
  }
}

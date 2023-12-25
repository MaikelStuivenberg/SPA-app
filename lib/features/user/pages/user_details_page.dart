import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/features/user/tabs/likes_overview.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/repositories/user_data.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:spa_app/utils/styles.dart';

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
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.profileTitle,
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
            future: _userDataRepository.getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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
                      style: Styles.pageSubTitle,
                    ),
                    Container(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text("Major: ", style: Styles.textStyleMediumDarkBold),
                      Text("${snapshot.data!.major}", style: Styles.textStyleLight),
                      Container(width: 16),
                      Text("Minor: ", style: Styles.textStyleMediumDarkBold),
                      Text("${snapshot.data!.minor}", style: Styles.textStyleLight),
                    ],),
                    Container(height: 16),
                    //draw line
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.white.withAlpha(75),
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
                        const Text(
                          "Photo's you liked",
                          style: Styles.textStyleLight,
                        ),
                      ],
                    ),
                    Container(height: 16),
                    Expanded(child: LikesOverview()),
                  ],
                );
              } else {
                return const Center(
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      color: Colors.white,
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
          color: Colors.white,
        ),
      ],
    );
  }
}

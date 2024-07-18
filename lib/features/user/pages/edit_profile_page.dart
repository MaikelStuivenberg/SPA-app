import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spa_app/app/injection/injection.dart';
import 'package:spa_app/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/features/user/models/user.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/repositories/user_data.dart';
import 'package:spa_app/shared/widgets/default_body.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final UserDataRepository _userDataRepository = UserDataRepository();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _ageController = TextEditingController();
  var _majorValue = '';
  var _minorValue = '';

  bool _isSaving = false;
  bool _doneSaving = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.profileEditTitle,
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: FutureBuilder(
            future: _userDataRepository.getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _firstnameController.text = snapshot.data!.firstname!;
                _lastnameController.text = snapshot.data!.lastname!;
                _ageController.text = snapshot.data!.age!;
                _majorValue = snapshot.data!.major!;
                _minorValue = snapshot.data!.minor!;

                return Column(
                  children: [
                    SizedBox(
                      height: 96,
                      width: 96,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          Hero(
                            transitionOnUserGestures: true,
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
                          Positioned(
                            bottom: 0,
                            right: -25,
                            child: RawMaterialButton(
                              onPressed: () {
                                ImagePicker()
                                    .pickImage(source: ImageSource.gallery)
                                    .then((value) async {
                                  if (value != null) {
                                    final file = await FlutterImageCompress
                                        .compressWithFile(
                                      value.path,
                                      quality: 80,
                                      minWidth: 1440,
                                      minHeight: 810,
                                    );

                                    if (file == null) return;

                                    await _userDataRepository
                                        .setProfileImage(file);

                                    setState(() {});
                                  }
                                });
                              },
                              // fillColor: AppColors.buttonColor,
                              shape: const CircleBorder(),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _firstnameController,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .profileFirstname,
                                ),
                              ),
                              TextFormField(
                                controller: _lastnameController,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .profileLastname,
                                ),
                              ),
                              TextFormField(
                                controller: _ageController,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context)!.profileAge,
                                ),
                              ),
                              DropdownButtonFormField(
                                value: _majorValue.isEmpty ? null : _majorValue,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .profileMajor,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Brass',
                                    child: Text('Brass'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Choir',
                                    child: Text('Choir'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Dance',
                                    child: Text('Dance'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'MMS',
                                    child: Text('MMS'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Theatre',
                                    child: Text('Theatre'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Sports',
                                    child: Text('Sports'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    _majorValue = value;
                                  }
                                },
                              ),
                              if (FirebaseRemoteConfig.instance
                                  .getBool('use_minor'))
                                DropdownButtonFormField(
                                  value:
                                      _minorValue.isEmpty ? null : _minorValue,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!
                                        .profileMinor,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Brass Class',
                                      child: Text('Brass Class'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Zingen in stijl!',
                                      child: Text('Zingen in stijl!'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Ritme',
                                      child: Text('Ritme'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Media',
                                      child: Text('Media'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Handige Handjes',
                                      child: Text('Handige Handjes'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Timbrels',
                                      child: Text('Timbrels'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Directie',
                                      child: Text('Directie'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      _minorValue = value;
                                    }
                                  },
                                ),
                              const SizedBox(
                                height: 24,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_isSaving) return;
                                    setState(() {
                                      _isSaving = true;
                                      _doneSaving = false;
                                    });

                                    await context
                                        .read<AuthCubit>()
                                        .updateUserData(
                                          UserData(
                                            firstname:
                                                _firstnameController.text,
                                            lastname: _lastnameController.text,
                                            age: _ageController.text,
                                            major: _majorValue,
                                            minor: _minorValue,
                                          ),
                                        );

                                    setState(() {
                                      _isSaving = false;
                                      _doneSaving = true;

                                      Timer(const Duration(milliseconds: 1500),
                                          () {
                                        setState(() {
                                          _doneSaving = false;
                                        });

                                        Navigator.of(context).canPop()
                                            ? Navigator.of(context).pop()
                                            : Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                Routes.userDetails,
                                                (route) => false,
                                              );
                                      });
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: _doneSaving
                                      ? const Icon(FontAwesomeIcons.check)
                                      : _isSaving
                                          ? const CircularProgressIndicator()
                                          : const Text('Save'),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.logout,
                                  ),
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      Routes.login,
                                      (route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  label: const Text('Logout'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

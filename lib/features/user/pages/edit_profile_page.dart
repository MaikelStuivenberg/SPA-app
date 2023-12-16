import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spa_app/features/user/models/user.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/repositories/user_data.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:spa_app/utils/app_colors.dart';
import 'package:spa_app/utils/styles.dart';

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
      'Edit Profile',
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              foregroundImage: ((snapshot.data?.image != null)
                                  ? MemoryImage(snapshot.data!.image!)
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
                                    await _userDataRepository.setImage(
                                      await value.readAsBytes(),
                                    );

                                    setState(() {});
                                  }
                                });
                              },
                              fillColor: AppColors.buttonColor,
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
                    // Expanded(
                    //   child: Container(
                    //     width: double.infinity,
                    //     decoration: const BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(16),
                    //         topRight: Radius.circular(16),
                    //       ),
                    //     ),
                    //     child: Column(
                    //       children: [
                    // Container(
                    //   height: 50,
                    //   width: 150,
                    //   child: AppBar(
                    //       backgroundColor: Colors.transparent,
                    //       elevation: 0,
                    //       // bottom: const TabBar(
                    //       //   indicatorColor: AppColors.buttonColor,
                    //       //   dividerColor: Colors.transparent,
                    //       //   labelColor: AppColors.buttonColor,
                    //       //   unselectedLabelColor: Colors.black,
                    //       //   tabs: [
                    //       //     Tab(
                    //       //       icon: Icon(
                    //       //         FontAwesomeIcons.heart,
                    //       //       ),
                    //       //     ),
                    //       //     Tab(
                    //       //       icon: Icon(FontAwesomeIcons.circleUser),
                    //       //     ),
                    //       //   ],
                    //       // )),
                    // ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _firstnameController,
                                decoration: Styles.textInputDecoration.copyWith(
                                  labelText: AppLocalizations.of(context)!
                                      .profileFirstname,
                                ),
                                style: Styles.textInput,
                              ),
                              TextFormField(
                                controller: _lastnameController,
                                decoration: Styles.textInputDecoration.copyWith(
                                  labelText: AppLocalizations.of(context)!
                                      .profileLastname,
                                ),
                                style: Styles.textInput,
                              ),
                              TextFormField(
                                controller: _ageController,
                                decoration: Styles.textInputDecoration.copyWith(
                                  labelText:
                                      AppLocalizations.of(context)!.profileAge,
                                ),
                                style: Styles.textInput,
                              ),
                              DropdownButtonFormField(
                                value: _majorValue.isEmpty ? null : _majorValue,
                                dropdownColor:
                                    const Color.fromARGB(135, 0, 0, 0),
                                decoration: Styles.textInputDecoration.copyWith(
                                  labelText: AppLocalizations.of(context)!
                                      .profileMajor,
                                ),
                                style: Styles.textInput,
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
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    _majorValue = value;
                                  }
                                },
                              ),
                              DropdownButtonFormField(
                                value: _minorValue.isEmpty ? null : _minorValue,
                                dropdownColor:
                                    const Color.fromARGB(135, 0, 0, 0),
                                decoration: Styles.textInputDecoration.copyWith(
                                  labelText: AppLocalizations.of(context)!
                                      .profileMinor,
                                ),
                                style: Styles.textInput,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Brass Class',
                                    child: Text('Brass Class'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Gospel',
                                    child: Text('Gospel'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Sport & Ministries',
                                    child: Text('Sport & Ministries'),
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
                                    value: 'Compositie',
                                    child: Text('Compositie'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Timbrels',
                                    child: Text('Timbrels'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Improvisatie',
                                    child: Text('Improvisatie'),
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
                                    await _userDataRepository.updateUser(
                                      User(
                                        firstname: _firstnameController.text,
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

                                        Navigator.canPop(context)
                                            ? Navigator.pop(context)
                                            : Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Routes.userDetails,
                                                (route) => false,
                                              );
                                      });
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buttonColor,
                                    foregroundColor: Colors.white,
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
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.logout,
                                  ),
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
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
      actions: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.penToSquare),
          onPressed: () {
            // Navigator.pushNamed(context, Routes.likes);
          },
          color: Colors.white,
        ),
      ],
    );
  }
}

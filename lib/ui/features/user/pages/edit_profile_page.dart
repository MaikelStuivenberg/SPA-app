import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/core/theme/theme_extensions.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/core/widgets/default_body.dart';
import 'package:spa_app/ui/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/ui/features/user/cubit/user_profile_cubit.dart';
import 'package:spa_app/ui/features/user/models/user.dart';
import 'package:spa_app/ui/features/user/widgets/profile_image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _ageController = TextEditingController();
  var _formInitialized = false;

  bool _isSaving = false;
  bool _doneSaving = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<UserProfileCubit>();
    if (cubit.state.user == null) {
      cubit.loadUser();
    }
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _initializeForm(UserData user) {
    if (_formInitialized) return;
    _firstnameController.text = user.firstname ?? '';
    _lastnameController.text = user.lastname ?? '';
    _ageController.text = user.age ?? '';
    _formInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldWidget(
      AppLocalizations.of(context)!.profileEditTitle,
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state.isLoadingUser && state.user == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final user = state.user;
              if (user == null) {
                return Center(
                  child: Text(state.userError ?? 'Unable to load profile'),
                );
              }

              final colorScheme = Theme.of(context).colorScheme;
              final appColors = context.appColors;

              _initializeForm(user);

              return Column(
                children: [
                  ProfileAvatarPicker(
                    heroTag: 'tag',
                    foregroundImage: ((user.image != null &&
                            user.image != '')
                        ? CachedNetworkImageProvider(user.imageUrl!)
                        : const AssetImage(
                            'assets/profile_default.jpg',
                          )) as ImageProvider<Object>,
                    onPickPressed: () async {
                      final profileCubit = context.read<UserProfileCubit>();
                      final file = await pickAndCompressProfileImage();
                      if (file == null || !mounted) return;
                      await profileCubit.setProfileImage(file);
                    },
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
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_isSaving) return;
                                  setState(() {
                                    _isSaving = true;
                                    _doneSaving = false;
                                  });

                                  await context.read<AuthCubit>().updateUserData(
                                        UserData(
                                          firstname: _firstnameController.text,
                                          lastname: _lastnameController.text,
                                          age: _ageController.text,
                                        ),
                                      );

                                  if (!mounted) return;

                                  await context
                                      .read<UserProfileCubit>()
                                      .loadUser();

                                  setState(() {
                                    _isSaving = false;
                                    _doneSaving = true;

                                    Timer(const Duration(milliseconds: 1500),
                                        () {
                                      if (!mounted) return;
                                      setState(() {
                                        _doneSaving = false;
                                      });

                                      context.canPop()
                                          ? context.pop()
                                          : context.go(RoutePaths.userDetails);
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
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  Icons.logout,
                                  color: colorScheme.onPrimary,
                                ),
                                onPressed: () async {
                                  await context.read<AuthCubit>().logout();
                                  if (context.mounted) {
                                    context.go(RoutePaths.login);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                label: const Text('Logout'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            BlocListener<AuthCubit, AuthState>(
                              listener: (context, authState) {
                                if (authState is AuthStateError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(authState.errorMessage),
                                    ),
                                  );
                                } else if (authState is AuthStateInitial) {
                                  context.go(RoutePaths.login);
                                }
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: appColors.error,
                                  ),
                                  label: Text(
                                    AppLocalizations.of(context)!
                                        .deleteAccountButton,
                                    style: TextStyle(color: appColors.error),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.surface,
                                    side: BorderSide(color: appColors.error),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          AppLocalizations.of(context)!
                                              .deleteAccountTitle,
                                        ),
                                        content: Text(
                                          AppLocalizations.of(context)!
                                              .deleteAccountDescription,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(false),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .deleteAccountCancel,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .deleteAccountConfirm,
                                              style: TextStyle(
                                                color: appColors.error,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmed == true && context.mounted) {
                                      await context
                                          .read<AuthCubit>()
                                          .deleteAccount();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      showMenu: false,
      back: true,
    );
  }
}

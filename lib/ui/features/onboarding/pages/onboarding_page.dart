import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/core/widgets/default_body.dart';
import 'package:spa_app/ui/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/ui/features/onboarding/widgets/onboarding_name_step.dart';
import 'package:spa_app/ui/features/onboarding/widgets/onboarding_photo_step.dart';
import 'package:spa_app/ui/features/onboarding/widgets/onboarding_step_indicator.dart';
import 'package:spa_app/ui/features/onboarding/widgets/onboarding_welcome_step.dart';
import 'package:spa_app/ui/features/user/cubit/user_profile_cubit.dart';
import 'package:spa_app/ui/features/user/models/user.dart';
import 'package:spa_app/ui/features/user/widgets/profile_image_picker.dart';

/// Persists the current onboarding step across route remounts in one app session.
int? onboardingSessionStep;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _stepCount = 3;

  final _nameFormKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();

  int _currentPage = 0;
  bool _isSaving = false;
  Uint8List? _pendingPhoto;
  String _savedFirstname = '';

  int _resolveInitialPage(AuthStateSuccess authState) {
    final user = authState.user;
    _firstnameController.text = user.firstname ?? '';
    _lastnameController.text = user.lastname ?? '';
    _savedFirstname = user.firstname?.trim() ?? '';

    if (onboardingSessionStep != null) {
      return onboardingSessionStep!.clamp(0, _stepCount - 1);
    }

    if (user.onboardingComplete == false &&
        (user.firstname?.trim().isNotEmpty ?? false)) {
      return 1;
    }

    return 0;
  }

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthStateSuccess) {
      _currentPage = _resolveInitialPage(authState);
      onboardingSessionStep = _currentPage;
    }
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
      onboardingSessionStep = page;
    });
  }

  UserData _currentUser() {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthStateSuccess) {
      throw StateError('User must be logged in during onboarding');
    }
    return authState.user;
  }

  Future<void> _saveNameAndContinue() async {
    if (_nameFormKey.currentState?.validate() != true) return;

    setState(() => _isSaving = true);

    try {
      final current = _currentUser();
      final updated = UserData(
        id: current.id,
        firstname: _firstnameController.text.trim(),
        lastname: _lastnameController.text.trim(),
        age: current.age,
        major: current.major,
        minor: current.minor,
        image: current.image,
        biblestudyGroup: current.biblestudyGroup,
        biblestudyLeader: current.biblestudyLeader,
        tent: current.tent,
        tentLeader: current.tentLeader,
        staff: current.staff,
        onboardingComplete: false,
      );

      await context.read<AuthCubit>().updateUserData(updated);
      if (!mounted) return;
      await context.read<UserProfileCubit>().loadUser();

      setState(() {
        _savedFirstname = updated.firstname ?? '';
        _isSaving = false;
      });
      _goToPage(1);
    } catch (_) {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _completeOnboarding() async {
    final current = _currentUser();
    await context.read<AuthCubit>().updateUserData(
          UserData(
            id: current.id,
            firstname: current.firstname,
            lastname: current.lastname,
            age: current.age,
            major: current.major,
            minor: current.minor,
            image: current.image,
            biblestudyGroup: current.biblestudyGroup,
            biblestudyLeader: current.biblestudyLeader,
            tent: current.tent,
            tentLeader: current.tentLeader,
            staff: current.staff,
            onboardingComplete: true,
          ),
        );
    onboardingSessionStep = null;
    if (!mounted) return;
    context.go(RoutePaths.home);
  }

  Future<void> _pickPhoto() async {
    final bytes = await pickAndCompressProfileImage();
    if (bytes != null && mounted) {
      setState(() => _pendingPhoto = bytes);
    }
  }

  Future<void> _finishPhotoStep({required bool uploadPhoto}) async {
    setState(() => _isSaving = true);

    try {
      if (uploadPhoto && _pendingPhoto != null) {
        await context.read<UserProfileCubit>().setProfileImage(_pendingPhoto!);
      }

      if (!mounted) return;
      setState(() => _isSaving = false);
      _goToPage(2);
    } catch (_) {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWelcomeStep = _currentPage == 2;
    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight;
    final contentTopInset = isWelcomeStep
        ? MediaQuery.paddingOf(context).top
        : topInset;

    return DefaultScaffoldWidget(
      isWelcomeStep ? null : l10n.onboardingTitle,
      Padding(
        padding: EdgeInsets.only(top: contentTopInset),
        child: Column(
          children: [
            if (!isWelcomeStep)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
                child: OnboardingStepIndicator(
                  currentStep: _currentPage,
                  stepCount: _stepCount,
                ),
              ),
            Expanded(
              child: IndexedStack(
                index: _currentPage,
                children: [
                  OnboardingNameStep(
                    formKey: _nameFormKey,
                    firstnameController: _firstnameController,
                    lastnameController: _lastnameController,
                  ),
                  OnboardingPhotoStep(
                    pendingPhoto: _pendingPhoto,
                    onPhotoPicked: _pickPhoto,
                  ),
                  OnboardingWelcomeStep(
                    firstname: _savedFirstname.isNotEmpty
                        ? _savedFirstname
                        : _firstnameController.text.trim(),
                    hasPhoto: _pendingPhoto != null,
                    onFinish: _completeOnboarding,
                  ),
                ],
              ),
            ),
            if (!isWelcomeStep)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  children: [
                    if (_currentPage == 0)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveNameAndContinue,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(l10n.onboardingContinue),
                        ),
                      )
                    else if (_currentPage == 1) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving
                              ? null
                              : () => _finishPhotoStep(
                                    uploadPhoto: _pendingPhoto != null,
                                  ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(l10n.onboardingContinue),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _isSaving
                            ? null
                            : () =>
                                _finishPhotoStep(uploadPhoto: false),
                        child: Text(l10n.onboardingPhotoSkip),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
      showMenu: false,
      actions: const [],
    );
  }
}

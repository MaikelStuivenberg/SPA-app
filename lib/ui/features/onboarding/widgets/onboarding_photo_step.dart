import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:spa_app/l10n/app_localizations.dart';
import 'package:spa_app/ui/features/user/widgets/profile_image_picker.dart';

class OnboardingPhotoStep extends StatelessWidget {
  const OnboardingPhotoStep({
    required this.pendingPhoto,
    required this.onPhotoPicked,
    super.key,
  });

  final Uint8List? pendingPhoto;
  final Future<void> Function() onPhotoPicked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    ImageProvider<Object>? imageProvider;
    if (pendingPhoto != null) {
      imageProvider = MemoryImage(pendingPhoto!);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        children: [
          Text(
            l10n.onboardingPhotoTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingPhotoSubtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          ProfileAvatarPicker(
            size: 120,
            foregroundImage: imageProvider,
            onPickPressed: onPhotoPicked,
          ),
        ],
      ),
    );
  }
}
